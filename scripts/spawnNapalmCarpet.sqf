/*
    scripts\spawnNapalmCarpet.sqf
    Creates a napalm “wall of fire” effect perpendicular to a given direction,
    and plays a whoosh sound locally on all clients.

    Usage (from server):
        [_pos, _dir] execVM "scripts\spawnNapalmCarpet.sqf";

    _pos: position of impact [x,y,z]
    _dir: direction (degrees) the player was facing when throwing smoke
*/

if (!isServer) exitWith {};

params [
    ["_pos", [0,0,0], [[]], 3],
    ["_dir", 0, [0]]
];

// --- Config ---
private _fireClass    = "test_EmptyObjectForFireBig"; // visible fire effect
private _fireCount    = 10;    // number of fires
private _spacing      = 3;     // meters between fires
private _burnDuration = 40;    // seconds
private _damageRadius = 5;     // radius of burn damage
private _igniteDelay  = 0.08;  // delay between each fire
private _whooshSound  = "A3\Sounds_F\air\sfx\jet_pass_02.wss";

// --- Compute perpendicular bearing (rotate 90°) ---
private _bearing = (_dir + 90) mod 360;
private _rad = _bearing * (pi / 180);
private _dirVector = [sin _rad, cos _rad, 0];

// --- Center the fire line on _pos ---
private _halfLength = (_fireCount - 1) * _spacing / 2;

// --- Play whoosh sound on all clients ---
[_whooshSound, _pos] remoteExec ["playSound3D", 0, true];

// --- Spawn and ignite fires sequentially ---
private _spawned = [];

for "_i" from 0 to (_fireCount - 1) do {
    private _offset = (_i * _spacing) - _halfLength;
    private _posFire = _pos vectorAdd (_dirVector vectorMultiply _offset);

    private _fire = createVehicle [_fireClass, _posFire, [], 0, "CAN_COLLIDE"];
    if (!isNull _fire) then {
        _fire setPosATL _posFire;
        _fire setVectorUp surfaceNormal _posFire;
        _spawned pushBack _fire;
    };

    // Damage over time
    [_posFire, _damageRadius, _burnDuration] spawn {
        params ["_center", "_radius", "_duration"];
        private _endTime = time + _duration;
        while { time < _endTime } do {
            {
                if (alive _x) then { _x setDamage ((damage _x) + 0.015); };
            } forEach (_center nearEntities ["Man", _radius]);
            sleep 1;
        };
    };

    sleep _igniteDelay;
};

// --- Cleanup fires after burn finishes ---
[_spawned, _burnDuration] spawn {
    params ["_objs", "_wait"];
    sleep (_wait + 3);
    { if (!isNull _x) then { deleteVehicle _x; }; } forEach _objs;
};

diag_log format ["spawnNapalmCarpet: %1 fires at %2 (bearing %3°)", count _spawned, _pos, round _bearing];
