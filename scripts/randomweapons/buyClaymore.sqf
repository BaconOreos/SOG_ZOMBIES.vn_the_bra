/* //buyClaymore.sqf
_user10Key = actionKeysImages "User10";

//titleText [format ["<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> to pick up a random explosive</t>", _user10Key], "PLAIN NOFADE", -1, false, true];
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
		[] spawn {
				private _claymore = selectRandom ["vn_mine_m18_range_mag"];
				player addMagazines [_claymore, 1];
		}
	};
}];
 */

// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define the cost of this buy station
private _cost = 950;

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
                private _claymore = selectRandom ["vn_mine_m18_range_mag"];
                player addMagazines [_claymore, 1];
                player playAction "gestureFreeze";
            } else {
                /* cutText ["<br/><br/><br/><t color='#ff4444' size='4'>Not enough points</t>", "PLAIN", -1, true, true]; */
            };
        };
    };
}];



/* 

// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define the cost of this buy station
private _cost = 1000;

// Store the cost globally for later access
missionNamespace setVariable ["BAC_buyCost", _cost];

// Add event handler for keypress
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];
    if (!_activated) exitWith {}; // only run on press, not release

    // ✅ Get cost from missionNamespace every time
    private _cost = missionNamespace getVariable ["BAC_buyCost", 0];

    // Check if the player has enough points to buy
    if ([_cost] call BAC_fnc_scoreBuy) then {
        // Select a random claymore (though array only has one option now)
        private _claymore = selectRandom ["vn_mine_m18_range_mag"];
        player addMagazines [_claymore, 1];
        //cutText ["<t color='#00FF00' size='4'>You bought a Claymore!</t>", "PLAIN", -1, true];
    } else {
        // Display message if not enough points
        //cutText ["<t color='#FF0000' size='4'>Not enough points!</t>", "PLAIN", -1, true];
    };
}];
 */