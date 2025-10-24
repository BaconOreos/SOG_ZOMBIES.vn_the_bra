
// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define the cost of this buy station
private _cost = 4000;

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
				[] remoteExec ["BAC_fnc_fullAmmo", 0, true];
                player playAction "gestureFreeze";

            } else {
                // Display message if not enough points
                /* cutText ["<br/><br/><br/><t color='#ff4444' size='4'>Not enough points</t>", "PLAIN", -1, true, true]; */
            };
        };
    };
}];