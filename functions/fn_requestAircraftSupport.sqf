/*
    File: fn_requestAircraftSupport.sqf
    Author: You
    
    Description:
        Client requests air support.
        Server spawns aircraft and notifies client to move into the gunship.
    
    Parameters:
        0: OBJECT - The player requesting support
        1: STRING - Aircraft classname
*/

params [
    ["_caller", objNull, [objNull]],
    ["_planeClass", "", [""]]
];

//--- Validate
if (isNull _caller || {_planeClass isEqualTo ""}) exitWith {
    diag_log "[BAC_fnc_requestAircraftSupport] ERROR: Invalid parameters!";
};

//--- CLIENT SIDE: send request to server
if (hasInterface && !isServer) exitWith {
    [_caller, _planeClass] remoteExecCall ["BAC_fnc_requestAircraftSupport", 2];
};

//--- SERVER SIDE BELOW
if (!isServer) exitWith {};

//--- Get orbit center position
private _pos = getPosASL _caller;

// --- CONFIGURABLE SETTINGS (based on aircraft type) ---
private _altitude     = 300;
private _duration     = 60;             // Timer duration in seconds
private _orbitRadius  = 400;
private _orbitSpeed   = 70;

// --- Aircraft-specific settings ---
switch (_planeClass) do {
    case "vn_b_air_ah1g_04": {
        // Helicopter settings - tighter orbit, slower speed
        _orbitRadius = 200;
        _orbitSpeed = 50;
        _altitude = 150;
    };
    case "vnx_b_air_ac119_01_01": {
        // AC-119 settings - wider orbit, faster speed
        _orbitRadius = 400;
        _orbitSpeed = 70;
        _altitude = 300;
    };
    default {
        // Default fixed-wing settings
        _orbitRadius = 400;
        _orbitSpeed = 70;
        _altitude = 300;
    };
};

// --- Spawn plane at altitude, pointed tangent to orbit (COUNTER-CLOCKWISE) ---
// --- Define orbit geometry ---
private _spawnAngle = 0;                       // NORTH - same as first waypoint (360°/0°)
private _entryOffset = 200;                    // Spawn 200m east of waypoint
private _spawnDist = _orbitRadius + _entryOffset;

// --- Spawn at first waypoint's latitude (orbitRadius north), offset 200m EAST ---
private _spawnPos = [
    (_pos select 0) + 800,                      // 200m east of center
    (_pos select 1) + _orbitRadius,             // Same north distance as first waypoint
    _altitude
];

// --- Create the aircraft ---
private _gunship = createVehicle [_planeClass, _spawnPos, [], 0, "FLY"];

// --- Face the first waypoint (west toward the orbit circle) ---
private _tangentDir = 270;  // Face west
_gunship setDir _tangentDir;

// --- Give initial velocity to enter orbit smoothly ---
private _initialVel = [
    sin(_tangentDir) * _orbitSpeed,
    cos(_tangentDir) * _orbitSpeed,
    0
];
_gunship setVelocity _initialVel;

// --- Maintain altitude & speed ---
_gunship flyInHeight _altitude;
_gunship forceSpeed _orbitSpeed;
_gunship setVelocityModelSpace [0, _orbitSpeed, 0];  // Add this - forward velocity in model space


// --- Create AI pilot with optimal settings ---
private _pilotGroup = createGroup [side _caller, true];
private _pilot = _pilotGroup createUnit ["B_Helipilot_F", [0,0,0], [], 0, "NONE"];
_pilot moveInDriver _gunship;

// Configure AI
_pilot setSkill 1;
_pilot allowFleeing 0;
_pilotGroup setBehaviour "CARELESS";
_pilotGroup setCombatMode "BLUE";
_pilotGroup setSpeedMode "LIMITED";

sleep 2;

// --- Clear any auto-created waypoints first ---
while {count waypoints _pilotGroup > 0} do {
    deleteWaypoint [_pilotGroup, 0];
};

// --- Create circular orbit waypoints (COUNTER-CLOCKWISE) ---
private _numWaypoints = 12;
for "_i" from 0 to (_numWaypoints - 1) do {
    // counter-clockwise: decrease angle instead of increase
    private _angle = 360 - (_i * (360 / _numWaypoints));
    private _wpPos = _pos getPos [_orbitRadius, _angle];
    _wpPos set [2, _altitude];

    private _wp = _pilotGroup addWaypoint [_wpPos, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointSpeed "LIMITED";
    _wp setWaypointBehaviour "CARELESS";
    _wp setWaypointCombatMode "BLUE";
    _wp setWaypointCompletionRadius 150;  // Increase from 60 to 150
};

// --- Add the CYCLE waypoint back to the first orbit point ---
private _firstPos = waypointPosition [_pilotGroup, 0];
private _wpCycle = _pilotGroup addWaypoint [_firstPos, 0];
_wpCycle setWaypointType "CYCLE";



// --- Minimal stability check loop ---
[_gunship, _altitude] spawn {
    params ["_gunship", "_alt"];
    
    while {alive _gunship && !isNull _gunship} do {
        private _currentAlt = (getPosATL _gunship) select 2;
        if (_currentAlt < (_alt - 80)) then {
            private _currentVel = velocity _gunship;
            _gunship setVelocity [
                _currentVel select 0,
                _currentVel select 1,
                10
            ];
        };
        
        private _currentSpeed = vectorMagnitude velocity _gunship;
        if (_currentSpeed < 30) then {
            _gunship forceSpeed 60;
        };
        
        sleep 5;
    };
};

// --- Get NetID and tell client to move in ---
private _netId = netId _gunship;
[_caller, _netId] remoteExec ["BAC_fnc_movePlayerToGunship", _caller];

// --- Timer: Return player after duration and cleanup ---
[_gunship, _caller, _pilotGroup, _duration] spawn {
    params ["_gunship", "_caller", "_pilotGroup", "_duration"];
    
    sleep _duration;
    
    // Teleport player back to respawn marker if still in aircraft
    if (vehicle _caller == _gunship) then {
        private _returnMarker = getMarkerPos "respawn_west"; // return location

        // Move player back to base (on that client's machine)
        [_caller, _returnMarker] remoteExec ["setPosATL", _caller];

        // Notify and restore view distances
        remoteExec [{
            setViewDistance 100;
            setObjectViewDistance [100, 100];
        }, _caller];
    };

    // Cleanup aircraft and crew
    { deleteVehicle _x } forEach crew _gunship;
    deleteGroup _pilotGroup;
    deleteVehicle _gunship;
    
    diag_log format [
        "[BAC_fnc_requestAircraftSupport] Cleaned up %1 for %2",
        typeOf _gunship, name _caller
    ];
};



// --- Log for debugging
diag_log format [
    "[BAC_fnc_requestAircraftSupport] Spawned %1 for %2 at %3 (NetID: %4)",
    _planeClass, name _caller, _pos, _netId
];