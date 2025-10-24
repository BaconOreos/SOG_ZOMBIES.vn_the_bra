/* //randomgrenade.sqf
_user10Key = actionKeysImages "User10";

//titleText [format ["<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> to pick up a random explosive</t>", _user10Key], "PLAIN NOFADE", -1, false, true];
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
		[] spawn {
				private _grenade = selectRandom ["vn_m67_grenade_mag", "vn_m61_grenade_mag", "vn_molotov_grenade_mag"]; //"MiniGrenade", "vn_mine_m18_range_mag"
				player addMagazines [_grenade, 1];
		}
	};
}];
 */

// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define the cost of this buy station
private _cost = 500;

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
				private _grenade = selectRandom ["vn_m67_grenade_mag", "vn_m61_grenade_mag", "vn_molotov_grenade_mag"]; //"MiniGrenade", "vn_mine_m18_range_mag"
				player addMagazines [_grenade, 1];
                [player, "buygrenade", 2] call BAC_fnc_playVoiceLine;
                player playAction "gestureFreeze";

            } else {
                // Display message if not enough points
                
            };
        };
    };
}];
