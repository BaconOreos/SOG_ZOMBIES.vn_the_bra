/*
    File: fn_proximityTrigger.sqf

    Description:
        Creates a local, player-only proximity-based trigger replacement.
        Executes code when player enters/leaves defined radius of an object or position.

    Params:
        0: OBJECT - The unit (usually player)
        1: OBJECT or ARRAY - Target object or position
        2: NUMBER - Activation distance (meters)
        3: CODE - Code to execute when entering
        4: CODE - Code to execute when leaving
*/

params [
    ["_unit", objNull, [objNull]],
    ["_target", objNull, [objNull, []]],
    ["_radius", 2, [0]],
    ["_onEnter", {}, [{}]],
    ["_onLeave", {}, [{}]]
];

// ✅ Safety check — exit if player is invalid or not local
if (isNull _unit || {!local _unit}) exitWith {};

// Local state flag
private _inRange = false;

// Main monitoring loop (spawned so it doesn’t block init)
[_unit, _target, _radius, _onEnter, _onLeave, _inRange] spawn {
    params ["_unit", "_target", "_radius", "_onEnter", "_onLeave", "_inRange"];

    // Loop until player or object is gone
    while {alive _unit} do {
        private _posTarget = if (_target isEqualType objNull) then {
            if (!isNull _target) then { getPosATL _target } else { [0,0,0] }
        } else {
            _target
        };

        private _dist = _unit distance _posTarget;

        // --- ENTER CONDITION ---
        if (!_inRange && {_dist <= _radius}) then {
            _inRange = true;
            [_unit, _target] call _onEnter;
        };

        // --- LEAVE CONDITION ---
        if (_inRange && {_dist > _radius}) then {
            _inRange = false;
            [_unit, _target] call _onLeave;
        };

        sleep 0.25; // balance between responsiveness & performance
    };
};

