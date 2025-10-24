// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define the cost of this buy station
private _cost = 800;

// Store the cost globally so the handler can access it later
missionNamespace setVariable ["BAC_buyCost", _cost];

// Show the prompt with the cost
/* titleText [format [
    "<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> to buy a random gun [Cost: %2]</t>",
    _user10Key,
    missionNamespace getVariable ["BAC_buyCost", 0]   // ✅ safe fetch
], "PLAIN NOFADE", -1, false, true]; */

// Add event handler for keypress
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];

    if (_activated) then {
        [] spawn {
            // ✅ get cost from missionNamespace every time
            private _cost = missionNamespace getVariable ["BAC_buyCost", 0];

            if ([_cost] call BAC_fnc_scoreBuy) then {
                private _weapon = selectRandom [
                    "vn_l2a1_01"
                ];

                player playAction "gestureFreeze";
                //removeAllMagazines player;
                player addWeapon _weapon;
                uiSleep 0.2;
                [] call BAC_fnc_keepOnlyCompatibleMags;
                
                private _compatMag = (compatibleMagazines _weapon) select 0;
                player addMagazines [_compatMag, 6];
                player addPrimaryWeaponItem _compatMag;


                /* cutText ["<br/><br/><br/><t color='#ff6600' size='4'>Picked up " + _weapon + "</t>", "PLAIN", -1, true, true];
                uiSleep 1;
                cutText ["", "PLAIN", -1, true, true]; */
            } else {
                /* cutText ["<br/><br/><br/><t color='#ff4444' size='4'>Not enough points</t>", "PLAIN", -1, true, true]; */
            };
        };
    };
}];











