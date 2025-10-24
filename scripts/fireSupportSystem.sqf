// File: scripts\fireSupportSystem.sqf
// Description: Detects smoke grenades and spawns fire support or crates at their location
// Execute on server only

if (!isServer) exitWith {};

// Define smoke grenade classnames and their colors
private _smokeGrenades = [
    // Vanilla
    ["SmokeShell", "white"],
    ["SmokeShellRed", "red"],
    ["SmokeShellGreen", "green"],
    ["SmokeShellYellow", "yellow"],
    ["SmokeShellPurple", "purple"],
    ["SmokeShellBlue", "blue"],
    ["SmokeShellOrange", "orange"],
    // SOG Prairie Fire (ammo, not mag)
    ["vn_m18_white_ammo", "white"],
    ["vn_m18_green_ammo", "green"],
    ["vn_m18_red_ammo", "red"],
    ["vn_m18_yellow_ammo", "yellow"],
    ["vn_m18_purple_ammo", "purple"],
    ["vn_m18_blue_ammo", "blue"]
];

// --- Client-side helper for proximity setup ---
BAC_fnc_setupCrateProximity = {
    params ["_crate"];
    
    // Set up the proximity trigger - this runs on each client
    [player, _crate, 3,
        {
            params ["_unit", "_crate"];
            ["Hold User10", "to unpack turret", nil] call BAC_fnc_showMessage;
            
            _unit setVariable ["BAC_activeCrate", _crate];
            
            if (isNil {_unit getVariable "BAC_turretHandlerActive"}) then {
                _unit setVariable ["BAC_turretHandlerActive", true];
                [] call BAC_fnc_setupTurretHandler;
            };
        },
        {
            params ["_unit", "_crate"];
            ["", "", nil, true] call BAC_fnc_showMessage;
            _unit setVariable ["BAC_activeCrate", nil];
        }
    ] call BAC_fnc_proximityTrigger;  // <-- THIS is the virtual trigger call
};

// --- Main mission event handler ---
addMissionEventHandler ["ProjectileCreated", {
    params ["_projectile"];
    private _smokeGrenades = _thisArgs select 0;
    private _grenadeType = typeOf _projectile;

    private _matchingGrenade = _smokeGrenades select {(_x select 0) == _grenadeType};

    if (count _matchingGrenade > 0) then {
        private _color = (_matchingGrenade select 0) select 1;

        [_projectile, _color] spawn {
            params ["_projectile", "_color"];

            // Wait until smoke lands
            waitUntil {
                sleep 0.1;
                isNull _projectile || {vectorMagnitude (velocity _projectile) < 1}
            };

            if (!isNull _projectile) then {
                private _pos = getPosATL _projectile;
                
                // Get the thrower BEFORE deleting projectile
                private _thrower = _projectile getVariable ["ace_thrower", objNull];
                if (isNull _thrower) then { 
                    _thrower = _projectile getVariable ["thrower", objNull]; 
                };
                
                sleep 2;

                switch (_color) do {
                    // --- WHITE SMOKE ---
                    case "white": {
                        // TODO
                    };

                    // --- RED SMOKE ---
                    case "red": {
                        [_pos, "G_40mm_HE", 5, 12, 0.2] spawn BIS_fnc_fireSupportVirtual;
                    };

                    // --- GREEN SMOKE ---
                    case "green": {
                        private _crate = createVehicle ["Land_vn_woodencrate_01_f", _pos, [], 0, "NONE"];
                        _crate setDir (random 360);
                        _crate setVectorUp surfaceNormal _pos;

                        // RemoteExec the proximity trigger setup to ALL clients
                        [[_crate], {
                            params ["_crate"];
                            
                            [player, _crate, 3,
                                {
                                    params ["_unit", "_crate"];
                                    ["Press", "to unpack", nil] call BAC_fnc_showMessage;
                                    [_crate] execVM "scripts\spawnTurretOnPos.sqf";
                                },
                                {
                                    params ["_unit", "_crate"];
                                    ["", "", nil, true] call BAC_fnc_showMessage;
                                    removeAllUserActionEventHandlers ["User10", "Activate"];
                                }
                            ] call BAC_fnc_proximityTrigger;
                            
                        }] remoteExec ["call", 0, _crate];
                    };

                    case "yellow": {
                        if (!isNull _thrower) then {
                        };
                    };


                    // --- PURPLE SMOKE ---
                    case "purple": {
                        if (!isNull _thrower) then {
                        };
                    };


                    // --- BLUE SMOKE ---
                    case "blue": {
                        [_pos] execVM "scripts\spawnMenOnPos.sqf";
                    };

                    // --- ORANGE SMOKE ---
                    case "orange": {
                        [_pos] execVM "scripts\spawnNapalmCarpet.sqf";
                    };
                };

                // Delete the grenade so it stops billowing smoke
                deleteVehicle _projectile;
            };
        };
    };
}, [_smokeGrenades]];