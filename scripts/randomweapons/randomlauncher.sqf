
// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define the cost of this buy station
private _cost = 1000;

// Store the cost globally so the handler can access it later
missionNamespace setVariable ["BAC_buyCost", _cost];

// Add event handler for keypress
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];

    if (_activated) then {
        [] spawn {
            // ✅ get cost from missionNamespace every time
            private _cost = missionNamespace getVariable ["BAC_buyCost", 0];

            if ([_cost] call BAC_fnc_scoreBuy) then {
				private _launcher = selectRandom ["vn_rpg7", "vn_m72", "vn_m20a1b1_01"];
				
                player playAction "gestureFreeze";
                //removeAllMagazines player;
				player addWeapon _launcher;
                uiSleep 0.2;
                [] call BAC_fnc_keepOnlyCompatibleMags;
                
				private _compatMagLauncher = compatibleMagazines _launcher select 0;
				player addMagazines [_compatMagLauncher, 1];
				player addSecondaryWeaponItem _compatMagLauncher;


				execVM "scripts\notSoFullAmmo.sqf";
            } else {
                /* cutText ["<br/><br/><br/><t color='#ff4444' size='4'>Not enough points</t>", "PLAIN", -1, true, true]; */
            };
        };
    };
}];
