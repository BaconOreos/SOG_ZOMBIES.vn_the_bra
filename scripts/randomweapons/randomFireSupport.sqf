//randomFireSupport.sqf
// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define the cost of this buy station
private _cost = 30000;

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
				private _grenade = selectRandom ["SmokeShellRed","SmokeShellBlue","SmokeShellYellow","SmokeShellGreen","SmokeShellOrange","SmokeShellPurple"]; //"MiniGrenade", "vn_mine_m18_range_mag"
				player addMagazines [_grenade, 1];
                [player, "buygrenade", 2] call BAC_fnc_playVoiceLine;
                player playAction "gestureFreeze";

            } else {
                // Display message if not enough points
                
            };
        };
    };
}];

//white     SmokeShell               slow down area
//Red	    SmokeShellRed            40mm barrage
//Green	    SmokeShellGreen          random turret
//Yellow	SmokeShellYellow         c119 gunship
//Purple	SmokeShellPurple         cobra gunship
//Blue	    SmokeShellBlue           3x ai reinforcements
//Orange	SmokeShellOrange         scripted wall of napalm
//vn_m18_red_mag