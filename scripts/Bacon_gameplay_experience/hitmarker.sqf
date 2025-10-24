//https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitPart   checks if player is hit
//https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitPart_2 checks if projectile has hit something, must be tied to a projectile from the player's weapon

//https://community.bistudio.com/wiki/cutRsc
//    cutRsc [class, effect, speed, showInMap, drawOverHUD]

player addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

	// Attach hit detection to bullet
	_projectile addEventHandler ["HitPart", {
		params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius", "_surfaceType", "_instigator"];

		if (_projectileOwner == player && !isNull _hitEntity && _hitEntity isKindOf "Man" && {alive _hitEntity}) then {
			cutRsc ["Hitmarker","PLAIN",0.7,false,true];
			[10] call BAC_fnc_moneyPopup;
		};				
	}];
}];

addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer", "_instigator"];

    // Did THIS local player get credited? (handles vehicles via _instigator)
    if (_killer isEqualTo player || {_instigator isEqualTo player}) then {

        // OPTIONAL: only count enemy kills
        // if (side group _unit == side group player) exitWith {};

        // show red kill marker
        cutRsc ["Hitmarker_Kill", "PLAIN", 0.7, false, true];
		[100] call BAC_fnc_moneyPopup;

        // suppress any white marker that might still fire in the next frame or two
        missionNamespace setVariable ["BAC_hitmarkerKillUntil", diag_tickTime + 0.2];
    };
}];


/* player addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

	// Attach hit detection to bullet
	_projectile addEventHandler ["HitPart", {
		params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius", "_surfaceType", "_instigator"];

		if (_projectileOwner == player && !isNull _hitEntity && _hitEntity isKindOf "Man" && {alive _hitEntity}) then {
			cutRsc ["Hitmarker","PLAIN",0.7,false,true];
		};				
	}];
}]; */


//_hitEntity isKindOf "Man"
