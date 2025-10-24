/* //https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#UserAction_Event_Handlers
//https://community.bistudio.com/wiki/inputAction/actions

//adds event handler to check for input (custom user input 10) and executes code if input is pressed

_user10Key = actionKeysImages "User10";

titleText [format ["<t color='#cccccc' size='5'>Press</t><t color='#40ccd0' size='5'> %1</t><t color='#cccccc' size='5'> to pick up ammo</t>", _user10Key], "PLAIN NOFADE", -1, false, true];

addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
		[] spawn {
        private _compatMag = (compatibleMagazines currentWeapon player) select 0;
		player addMagazines [_compatMag, 3];
		cutText ["<br/><br/><br/><t color='##00FF00' size='5'>Picked up ammo</t>", "PLAIN", -1, true, true];
		uiSleep 1;
		cutText ["<br/><br/><br/><t color='##00FF00' size='5'></t>", "PLAIN", -1, true, true];
		}
	};
}];
 */
 
// 🔹 Buy Station Template with optional evolving cost

// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Base cost for this station
private _baseCost = 700;

// Enable evolving cost? (true = yes, false = no)
private _useEvo = false;

// Store base cost + option globally (in case you want multiple buy stations later)
missionNamespace setVariable ["BAC_buyCost", _baseCost];
missionNamespace setVariable ["BAC_buyEvo", _useEvo];

// Show prompt (only shows base cost, evolving part is explained on purchase)
/* titleText [format [
    "<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> to buy [Cost: %2]</t>",
    _user10Key,
    missionNamespace getVariable ["BAC_buyCost", 0]
], "PLAIN NOFADE", -1, false, true]; */

// Handle keypress
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
				private _compatMag = (compatibleMagazines currentWeapon player) select 0;
				player addMagazines [_compatMag, 6];
				cutText ["<br/><br/><br/><t color='##00FF00' size='5'>Picked up ammo</t>", "PLAIN", -1, true, true];
				uiSleep 1;
				cutText ["<br/><br/><br/><t color='##00FF00' size='5'></t>", "PLAIN", -1, true, true];
                player playAction "gestureFreeze";
            } else {
                // Not enough points
                /* cutText [format [
                    "<br/><br/><br/><t color='#ff4444' size='4'>Not enough points (Need: %1)</t>",
                    _finalCost
                ], "PLAIN", -1, true, true];
				uiSleep 1;
				cutText ["<br/><br/><br/><t color='##00FF00' size='5'></t>", "PLAIN", -1, true, true]; */
            };
        };
    };
}];
