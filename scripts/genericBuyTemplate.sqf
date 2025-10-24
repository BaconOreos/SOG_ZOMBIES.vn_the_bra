// 🔹 Buy Station Template with optional evolving cost

// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Base cost for this station
private _baseCost = 500;

// Enable evolving cost? (true = yes, false = no)
private _useEvo = false;

// Store base cost + option globally (in case you want multiple buy stations later)
missionNamespace setVariable ["BAC_buyCost", _baseCost];
missionNamespace setVariable ["BAC_buyEvo", _useEvo];

// Show prompt (only shows base cost, evolving part is explained on purchase)
titleText [format [
    "<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> to buy [Cost: %2]</t>",
    _user10Key,
    missionNamespace getVariable ["BAC_buyCost", 0]
], "PLAIN NOFADE", -1, false, true];

// Handle keypress
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];

    if (_activated) then {
        [] spawn {
            private _baseCost = missionNamespace getVariable ["BAC_buyCost", 0];
            private _useEvo   = missionNamespace getVariable ["BAC_buyEvo", false];

            // Calculate evolving cost if enabled
            private _finalCost = if (_useEvo) then {
                private _round = missionNamespace getVariable ["BAC_zombRoundCount", 1];
                _baseCost * _round
            } else {
                _baseCost
            };

            // Try to buy
            if ([_finalCost] call BAC_fnc_scoreBuy) then {

                // --------------------------------
                // ✅ Code to execute when purchase succeeds
                // Example: give weapon, spawn vehicle, open crate, etc.
                // --------------------------------
                player playAction "gestureFreeze";

                cutText [format [
                    "<br/><br/><br/><t color='#40ff40' size='4'>Purchase successful (Cost: %1)</t>",
                    _finalCost
                ], "PLAIN", -1, true, true];
            } else {
                // Not enough points
                cutText [format [
                    "<br/><br/><br/><t color='#ff4444' size='4'>Not enough points (Need: %1)</t>",
                    _finalCost
                ], "PLAIN", -1, true, true];
            };
        };
    };
}];
