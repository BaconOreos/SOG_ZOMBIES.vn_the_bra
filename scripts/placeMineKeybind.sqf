/*
    placeMineKeybind.sqf
    Allows player to place a Claymore (vn_mine_m18_range_mag) by holding User11.
    Uses createMine with the ammo class, and tags ownership so kills can be credited.
*/

// Get the key name for User11 so we can display it (optional for UI hints)
_user11Key = actionKeysImages "User11";

// Add event handler for the key
addUserActionEventHandler ["User11", "Activate", {
    params ["_activated"];

    if (_activated) then {
        [] spawn {
            private _holdTime = 0.4;
            private _startTime = time;

            waitUntil {
                sleep 0.01;
                !(inputAction "User11" > 0) || (time - _startTime > _holdTime)
            };

            if (time - _startTime > _holdTime) then {
                if ("vn_mine_m18_range_mag" in (magazines player)) then {
                    // Play gesture + voiceline
                    player playAction "gestureGo"; //https://community.bistudio.com/wiki/playAction/actions
                    [player, "buyclaymore", 2, 1] call BAC_fnc_playVoiceLine;

                    // Remove inventory item
                    player removeMagazine "vn_mine_m18_range_mag";

                    // Spawn mine in front of player
                    private _minePos = player modelToWorld [0,1,0];
                    private _mine = createVehicle ["vn_mine_m18_range_ammo", _minePos, [], 0, "NONE"];
                    _mine setDir (getDir player);

                    // Arm mine
                    _mine setVehicleAmmo 1;

                    // Tag mine with owner
                    _mine setVariable ["BAC_owner", player, true];

                } else {
                    //systemChat ">>> No Claymore in inventory!";
                };
            };
        };
    };
}];







/* 
// Get the key name for User11 so we can display it (optional for UI hints)
_user11Key = actionKeysImages "User11";

// Add event handler for the key
addUserActionEventHandler ["User11", "Activate", {
    params ["_activated"];

    if (_activated) then {
        systemChat ">>> Mine key pressed (detected).";

        [] spawn {
            // Hold duration
            private _holdTime = 0.4;
            private _startTime = time;

            systemChat ">>> Holding key for mine placement...";

            // Wait until key is released OR time passes
            waitUntil {
                sleep 0.01;
                !(inputAction "User11" > 0) || (time - _startTime > _holdTime)
            };

            if (time - _startTime > _holdTime) then {
                // Check if player has at least one Claymore
			if ("vn_mine_m18_range_mag" in (magazines player)) then {
				systemChat ">>> Placing Claymore!";

				// Play simple gesture
				player playAction "gestureGo";

                //play voice line
                [player, "buyclaymore", 2] call BAC_fnc_playVoiceLine;

				// Remove mine from inventory
				player removeMagazine "vn_mine_m18_range_mag";

				// Position in front of player
				private _minePos = player modelToWorld [0,1,0];
				//_pos set [2, getTerrainHeightASL _pos]; // snap to terrain height
				private _mine = createVehicle ["vn_mine_m18_range_ammo", _minePos, [], 0, "NONE"];

				// --- Face away from player ---
				private _dir = getDir player;
				_mine setDir _dir;


				// Arm mine
				_mine setVehicleAmmo 1;

                } else {
                    systemChat ">>> No Claymore in inventory!";
                };
            } else {
                systemChat ">>> Mine key released too early.";
            };
        };
    };
}];
 */