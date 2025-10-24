

// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define the cost of this buy station
private _cost = 0;

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
				private _handgun = selectRandom ["vn_m1911"];
				
				player playAction "gestureFreeze";
                //removeAllMagazines player;
				player addWeapon _handgun;
                uiSleep 0.2;
                [] call BAC_fnc_keepOnlyCompatibleMags;
                
				private _compatMagPistol = compatibleMagazines _handgun select 0;
				player addMagazines [_compatMagPistol, 3];
				player addHandgunItem _compatMagPistol;


				//execVM "scripts\notSoFullAmmo.sqf";

            } else {
                // Display message if not enough points
                /* cutText ["<br/><br/><br/><t color='#ff4444' size='4'>Not enough points</t>", "PLAIN", -1, true, true]; */
            };
        };
    };
}];

