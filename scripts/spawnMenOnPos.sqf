/*
    File: scripts\spawnMenOnPos.sqf
    Author: ARMA 3 Script GPT
    Description:
        Spawns 5 friendly AI units (vn_b_men_army_15) at a given position to assist the player.

    Usage:
        [position] execVM "scripts\spawnMenOnPos.sqf";
*/

params ["_pos"];

// Safety: If no position provided, exit
if (isNil "_pos" || {typeName _pos != "ARRAY"}) exitWith {
    diag_log "[spawnMenOnPos.sqf] Invalid or missing position parameter.";
};

// --- CONFIGURABLE SETTINGS ---
private _unitClass = "vn_b_men_army_15";   // unit type
private _side      = west;                 // friendly to BLUFOR
private _count     = 3;                    // number of soldiers
private _radius    = 3;                    // spawn spread around position

// --- Create a temporary group ---
private _grp = createGroup [_side, true];

// --- Spawn units ---
for "_i" from 1 to _count do {
    private _spawnPos = _pos getPos [random _radius, random 360];
    private _unit = _grp createUnit [_unitClass, _spawnPos, [], 0, "CAN_COLLIDE"];
    _unit setDir (random 360);
    _unit setVectorUp surfaceNormal _spawnPos;
};

// --- Optional: make them join the nearest player’s group (friendly reinforcement) ---
private _nearestPlayer = objNull;
private _nearestDist = 99999;
{
    private _dist = _pos distance2D _x;
    if (_dist < _nearestDist) then {
        _nearestPlayer = _x;
        _nearestDist = _dist;
    };
} forEach allPlayers;

if (!isNull _nearestPlayer) then {
    {
        [_x] joinSilent (group _nearestPlayer);
    } forEach units _grp;
};

// --- Optional feedback ---
//[format ["Reinforcements arrived (%1 men)", _count], "", nil] remoteExec ["BAC_fnc_showMessage", _nearestPlayer];

// Done
_grp
