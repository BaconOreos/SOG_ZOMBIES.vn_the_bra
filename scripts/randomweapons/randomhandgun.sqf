/* 
_user10Key = actionKeysImages "User10";

//titleText [format ["<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> to pick a random pistol</t>", _user10Key], "PLAIN NOFADE", -1, false, true];
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
		private _handgun = selectRandom ["vn_welrod", "vn_vz61_p", "vn_type64", "vn_tt33", "vn_ppk", "vn_pm", "vn_p38", "vn_m10", "vn_mk22", "vn_m712", "vn_m1911", "vn_m1895", "vn_izh54_p", "vn_hd", "vn_hp", "vn_p38s", "vnx_hd_02", "vnx_gjet", "vn_m79_p", "vn_p38s"];
		removeAllMagazines player;
		player addWeapon _handgun;

		private _compatMagPistol = compatibleMagazines _handgun select 0;
		player addMagazines [_compatMagPistol, 3];
		player addHandgunItem _compatMagPistol;

		execVM "scripts\notSoFullAmmo.sqf";
		
    };
}]; */

// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define the cost of this buy station
private _cost = 800;

// Store the cost globally for later access
missionNamespace setVariable ["BAC_buyCost", _cost];

// Add event handler for keypress
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];

    if (_activated) then {
        [] spawn {
            // ✅ Get cost from missionNamespace every time
            private _cost = missionNamespace getVariable ["BAC_buyCost", 0];

            // Check if the player has enough points to buy
            if ([_cost] call BAC_fnc_scoreBuy) then {
                // Select a random weapon from the list
				private _handgun = selectRandom ["vn_welrod", "vn_vz61_p", "vn_type64", "vn_tt33", "vn_ppk", "vn_pm", "vn_p38", "vn_m10", "vn_mk22", "vn_m712", "vn_m1911", "vn_m1895", "vn_izh54_p", "vn_hd", "vn_hp", "vn_p38s", "vnx_hd_02", "vnx_gjet", "vnx_c96", "vn_m79_p", "vn_p38s"];
				
                player playAction "gestureFreeze";
                //removeAllMagazines player;
				player addWeapon _handgun;
                uiSleep 0.2;
                [] call BAC_fnc_keepOnlyCompatibleMags;

				private _compatMagPistol = compatibleMagazines _handgun select 0;
				player addMagazines [_compatMagPistol, 3];
				player addHandgunItem _compatMagPistol;


				execVM "scripts\notSoFullAmmo.sqf";

            } else {
                // Display message if not enough points
                /* cutText ["<br/><br/><br/><t color='#ff4444' size='4'>Not enough points</t>", "PLAIN", -1, true, true]; */
            };
        };
    };
}];

