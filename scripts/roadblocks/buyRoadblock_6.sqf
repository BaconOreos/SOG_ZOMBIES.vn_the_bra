// 🔹 Buy Station Template

// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define cost for this station
private _cost = 1500;

// Store the cost so the handler can access it later
missionNamespace setVariable ["BAC_buyCost", _cost];

/* // Show prompt
titleText [format [
    "<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> to clear blockage Cost: [%2]</t>",
    _user10Key,
    missionNamespace getVariable ["BAC_buyCost", 0]
], "PLAIN NOFADE", -1, false, true];
 */
// Handle keypress
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];

    if (_activated) then {
        [] spawn {
            private _cost = missionNamespace getVariable ["BAC_buyCost", 0];

            if ([_cost] call BAC_fnc_scoreBuy) then {
                // ✅ SUCCESSFUL PURCHASE
                ["blocker_6"] remoteExec ["BAC_fnc_blockerClear", 0]; // run on all clients
				["", -1, true] remoteExec ["BAC_fnc_interactPrompt", player];
                //["zone6", ["teleport_6"]] execVM "functions\fn_ZombieSectorUnlock.sqf";
				removeAllUserActionEventHandlers ["User10", "Activate"];
                [] call BAC_fnc_clearMessage;
                [player, "buyblocker", 2, 1] call BAC_fnc_playVoiceLine;
                player playAction "gestureFreeze";
                removeAllUserActionEventHandlers ["User10", "Activate"];
				
            } else {
                // ❌ Not enough points
                /* cutText ["<br/><br/><br/><t color='#ff4444' size='4'>Not enough points</t>", "PLAIN", -1, true, true];
                uiSleep 1;
                cutText ["<br/><br/><br/><t color='#cccccc' size='4'></t>", "PLAIN", -1, true, true]; */
            };
        };
    };
}];
