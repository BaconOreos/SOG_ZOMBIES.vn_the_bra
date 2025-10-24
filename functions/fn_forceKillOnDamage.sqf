/*
    fn_forceKillOnDamage.sqf
    Forces a unit to die if it takes at least a threshold of damage.
    Use: [unit, 0.8] call BAC_fnc_forceKillOnDamage;  // kill if >= 80% damage
*/

params ["_unit", ["_threshold", 0.8]];   // default: 80% damage

if (isNull _unit || {!alive _unit}) exitWith {};

_unit addEventHandler ["HandleDamage", {
    params ["_target", "_selection", "_damage", "_source", "_projectile", "_hitIndex"];

    private _threshold = _thisEventHandlerArgs select 0;  // pass threshold through EH args
    private _newDmg = damage _target + _damage;

    if (_newDmg >= _threshold) then {
        _target setDamage 1;   // force kill
    };

    _damage   // still apply normal damage
}, [_threshold]];   // pass threshold as custom args
