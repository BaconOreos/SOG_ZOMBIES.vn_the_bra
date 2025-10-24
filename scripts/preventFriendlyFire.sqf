/*
    File: preventFriendlyFire.sqf
    Description: Prevents damage if the attacker is on the same side as the target.
*/

player addEventHandler ["HandleDamage", {
    params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitPartIndex", "_instigator"];

    // If the source is on the same side as the unit, negate damage
    if (!isNull _source && {side _source == side _unit}) then {
        _damage = 0;
    };

    _damage
}];
