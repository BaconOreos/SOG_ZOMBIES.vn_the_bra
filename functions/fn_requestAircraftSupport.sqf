/*
    File: fn_requestAircraftSupport.sqf
    Description:
        Spawns and manages AI aircraft (gunship) for air support.
        Works in both local MP and dedicated servers with minimal stability correction.

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

// --- CONFIGURABLE SETTINGS ---
private _altitude     = 300;
private _duration     = 60;             // seconds
private _orbitRadius  = 400;
private _orbitSpeed   = 70;

// --- Aircraft-specific adjustments ---
switch (_planeClass) do {
    case "vn_b_air_ah1g_04": {
        _orbitRadius = 200;
        _orbitSpeed  = 50;
        _altitude    = 150;
    };
    case "vnx_b_air_ac119_01_01": {
        _orbitRadius = 400;
        _orbitSpeed  = 70;
        _altitude    = 300;
    };
    default {
        _orbitRadius = 400;
        _orbitSpeed  = 70;
        _altitude    = 300;
    };
};

// --- Spawn aircraft ---
private _spawnPos = [
    (_pos select 0) + 800,
    (_pos select 1) + _orbitRadius,
    _altitude
];
private _gunship = createVehicle [_planeClass, _spawnPos, [], 0, "FLY"];
_gunship setDir 270;

// --- Initial forward motion ---
private _initialVel = [
    sin 270 * _orbitSpeed,
    cos 270 * _orbitSpeed,
    0
];
_gunship setVelocity _initialVel;

// --- Altitude & speed lock ---
_gunship flyInHeightASL [_altitude, _altitude, _altitude];
_gunship forceSpeed _orbitSpeed;
_gunship setVelocityModelSpace [0, _orbitSpeed, 0];

// --- Create AI pilot ---
private _pilotGroup = createGroup [side _caller, true];
private _pilot = _pilotGroup createUnit ["B_Helipilot_F", [0,0,0], [], 0, "NONE"];
_pilot moveInDriver _gunship;

// --- AI tuning ---
_pilot setSkill 1;
_pilot allowFleeing 0;
_pilotGroup setBehaviour "CARELESS";
_pilotGroup setCombatMode "BLUE";
_pilotGroup setSpeedMode "LIMITED";

// --- Remove default waypoints ---
sleep 1;
while {count waypoints _pilotGroup > 0} do {
    deleteWaypoint [_pilotGroup, 0];
};

// --- Create orbit waypoints ---
private _isHeli = _planeClass isKindOf "Helicopter";
private _numWaypoints = if (_isHeli) then {6} else {12};
private _wpRadius = if (_isHeli) then {200} else {150};

for "_i" from 0 to (_numWaypoints - 1) do {
    private _angle = 360 - (_i * (360 / _numWaypoints));
    private _wpPos = _pos getPos [_orbitRadius, _angle];
    _wpPos set [2, _altitude];

    private _wp = _pilotGroup addWaypoint [_wpPos, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointSpeed "LIMITED";
    _wp setWaypointBehaviour "CARELESS";
    _wp setWaypointCombatMode "BLUE";
    _wp setWaypointCompletionRadius _wpRadius;
};

// --- Add CYCLE waypoint ---
private _firstPos = waypointPosition [_pilotGroup, 0];
private _wpCycle = _pilotGroup addWaypoint [_firstPos, 0];
_wpCycle setWaypointType "CYCLE";

// --- Minimal altitude safeguard (only if drops below 400m AGL) ---
[_gunship] spawn {
    params ["_gunship"];
    while {alive _gunship && {!isNull _gunship}} do {
        private _altAGL = (getPosATL _gunship) select 2;
        if (_altAGL < 400) then {
            private _vel = velocity _gunship;
            // Small gentle upward nudge, no rotation or forced velocity reset
            _gunship setVelocity [
                _vel select 0,
                _vel select 1,
                (_vel select 2) max 5
            ];
            _gunship flyInHeightASL [400,400,400];
        };
        sleep 5;
    };
};

// --- Move player into the gunship ---
private _netId = netId _gunship;
[_caller, _netId] remoteExec ["BAC_fnc_movePlayerToGunship", _caller];

// --- Timed cleanup & return player ---
[_gunship, _caller, _pilotGroup, _duration] spawn {
    params ["_gunship", "_caller", "_pilotGroup", "_duration"];
    sleep _duration;

    if (vehicle _caller == _gunship) then {
        private _returnMarker = getMarkerPos "respawn_west";
        [_caller, _returnMarker] remoteExec ["setPosATL", _caller];
        remoteExec [{
            setViewDistance 100;
            setObjectViewDistance [100,100];
        }, _caller];
    };

    { deleteVehicle _x } forEach crew _gunship;
    deleteGroup _pilotGroup;
    deleteVehicle _gunship;

    diag_log format [
        "[BAC_fnc_requestAircraftSupport] Cleaned up %1 for %2",
        typeOf _gunship, name _caller
    ];
};

// --- Log ---
diag_log format [
    "[BAC_fnc_requestAircraftSupport] Spawned %1 for %2 at %3 (NetID: %4)",
    _planeClass, name _caller, _pos, netId _gunship
];
