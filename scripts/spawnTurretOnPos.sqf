/*
    File: scripts\spawnTurretOnPos.sqf
    Description:
        Allows player to place a static turret by holding User10 near a crate.
*/

params ["_crate"];

// Store the crate reference globally for the handler to access
missionNamespace setVariable ["BAC_turretCrate", _crate];

// Define turret types
private _turretTypes = [
    "vn_b_army_static_m60_high",
    "vn_b_army_static_m2_high",
    "vn_b_army_static_m1919a4_high",
    "vn_o_nva_65_static_m1910_low_01",
    "vn_o_nva_65_static_sgm_low_01",
    "vn_o_nva_65_static_dshkm_high_01",
    "vn_o_nva_65_static_pk_high",
    "vn_o_pls_static_mg42_high"
];
missionNamespace setVariable ["BAC_turretTypes", _turretTypes];

// Key binding visual (User10 key)
private _user10Key = actionKeysImages "User10";

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
            // Get the crate from missionNamespace
            private _crate = missionNamespace getVariable ["BAC_turretCrate", objNull];
           
            if (!isNull _crate) then {
                private _turretTypes = missionNamespace getVariable ["BAC_turretTypes", []];
                private _turretClass = selectRandom _turretTypes;
                private _turretPos = getPosATL _crate;
                private _turretDir = getDir player;
               
                player playAction "gestureGo";
               
                // Create turret
                private _turret = createVehicle [_turretClass, _turretPos, [], 0, "CAN_COLLIDE"];
                _turret setDir _turretDir;
                _turret setPosATL _turretPos;
               
                // Delete crate
                deleteVehicle _crate;
               
                // Clear the crate reference
                missionNamespace setVariable ["BAC_turretCrate", nil];
            };
        };
    };
}];