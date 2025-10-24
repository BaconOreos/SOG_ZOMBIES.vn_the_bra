/*
    fn_revivePlayer.sqf
    Revives a downed *player*.

    called with _unit spawn BAC_fnc_revivePlayer;


*/
params ["_unit"];

if (!isPlayer _unit) exitWith {};
if !(_unit getVariable ["BAC_isDowned", false]) exitWith {};

_unit setVariable ["BAC_isDowned", false, true];
_unit allowDamage true;
_unit setDamage 0;  // revive at 0% damage
[_unit, "revived", 2, 1] call BAC_fnc_playVoiceLine;

// Restore group
/* private _blufor = createGroup [west, true];
[_unit] joinSilent _blufor;
 */

//restore captive state
_unit setCaptive false;

// Restore gear from saved state
private _savedGear = _unit getVariable ["BAC_savedLoadout", getUnitLoadout _unit];
_unit setUnitLoadout _savedGear;

// Restore controls
if (local _unit) then {
    _unit enableSimulation true;
};

_unit enableAI "MOVE";
_unit enableAI "PATH";

// Reset stance
[_unit, "AmovPercMstpSrasWrflDnon"] remoteExec ["switchMove", 0, true]; //standing

if (isServer) then {
    [] spawn BAC_fnc_checkPlayersAlive;
};