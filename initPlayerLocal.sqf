//initPlayerLocal.sqf
//systemChat ">>> initPlayerLocal.sqf START";
diag_log ">>> initPlayerLocal.sqf START";
[] spawn {
    uiSleep 3;
    [] execVM "scripts\Bacon_gameplay_experience\camshake.sqf";
    [] execVM "scripts\Bacon_gameplay_experience\reloadshake.sqf";
    [] execVM "scripts\Bacon_gameplay_experience\standup.sqf";
    [] execVM "scripts\Bacon_gameplay_experience\hitmarker.sqf";
    [] execVM "scripts\Bacon_gameplay_experience\movementSpeed.sqf";
    [] execVM "scripts\Bacon_gameplay_experience\jumpScript.sqf";
    [] execVM "scripts\Bacon_gameplay_experience\meleeAttack.sqf";
    [] execVM "scripts\preventFriendlyFire.sqf";
    //[] execVM "scripts\Bacon_gameplay_experience\proneStandup.sqf";
    //[] execVM "scripts\Bacon_gameplay_experience\directionalDash.sqf";
    //[] execVM "scripts\Bacon_gameplay_experience\slideScript.sqf"; //no errors but doesn't really work
    [] execVM "scripts\nametags.sqf";
    [] execVM "scripts\checkPlayerKeybinds.sqf";
    uiSleep 3;
    // Attach display system to monitor when player joins
    [screenMonitor] call BAC_fnc_updateStockDisplay;
    //adds claymore placing keybind functionality
    [] execVM "scripts\placeMineKeybind.sqf";
    //Creates the round HUD when player joins (including JIP). local to client
    [] execVM "scripts\HUD\createRoundHUD.sqf";
    uiSleep 3;
    //["Resupply", "ammomachine", 500] call BAC_fnc_add3DDisplay;
    //[ball, "hello world", 2] call BAC_fnc_add3DDisplay;

};



/*
    File: initPlayerLocal.sqf
    Description: Client-side smoke detection for support request
*/

player addEventHandler ["Fired", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_mag", "_projectile"];

    // Define relevant smoke ammo types
    private _smokes = [
        ["SmokeShellYellow", "yellow"],
        ["SmokeShellPurple", "purple"]
    ];

    // Check if the fired ammo matches one of our smokes
    private _match = _smokes select { (_x select 0) == _ammo };
    if (count _match == 0) exitWith {};  // Not a relevant smoke type

    private _color = (_match select 0) select 1;

    // Wait for projectile to land and start emitting smoke
    [_projectile, _color] spawn {
        params ["_proj", "_clr"];

        waitUntil {
            sleep 0.1;
            isNull _proj || { vectorMagnitude (velocity _proj) < 1 }
        };

        if (!isNull _proj) then {
            private _pos = getPosATL _proj;

            // Optional: little delay for realism
            sleep 2;

            switch (_clr) do {
                case "yellow": {
                    [player, "vnx_b_air_ac119_01_01"] call BAC_fnc_requestAircraftSupport;
                    //hint "🟡 Yellow smoke detected — requesting aircraft support!";
                };
                case "purple": {
                    [player, "vn_b_air_ah1g_04"] call BAC_fnc_requestAircraftSupport;
                    //hint "🟣 Purple smoke detected — requesting aircraft support!";
                };
            };
        };
    };
}];



[] spawn {
    waitUntil { !isNil "BAC_zombRoundCount" };
    uiSleep 4;
//spawning proxi triggers for buy stations and blockers
//[player, _object, _radius, _onEnterCode, _onLeaveCode] call BAC_fnc_proximityTrigger;
/*  
Params:
0: OBJECT - The unit
1: OBJECT or ARRAY - Target object or position
2: NUMBER - Activation distance (meters)
3: CODE - Code to execute when entering
4: CODE - Code to execute when leaving */


[player, blocker4prompt, 3,
    {
    ["Press","to clear",500] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock_4.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, blocker1prompt, 3,
    {
    ["Press","to clear",500] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock_1.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, starterpistolstation, 3,
    {
    ["Press","for starter pistol",nil] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\starterGun.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, doubleshottystation, 3,
    {
    ["Press","to buy ish54",500] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\buyISH54.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
uiSleep 5;
[player, randomsidearmstation, 3,
    {
    ["Press","for random sidearm",800] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\randomhandgun.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, m1garandstation, 3,
    {
    ["Press","to buy m1",500] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\buyM14.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, no4sniperstation, 3,
    {
    ["Press","to buy No4",500] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\buyNo4.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, vz61station, 3,
    {
    ["Press","to buy vz61",800] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\buyvz61.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, m50smgstation, 3,
    {
    ["Press","to buy m50",800] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\buyM50.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, rearmstation, 3,
    {
    ["Press","to buy rearm",700] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\promptRearm.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
uiSleep 5;
[player, randomweaponstation, 3,
    {
    ["Press","for random gun",950] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\randomweapon.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, huntingshottystation, 3,
    {
    ["Press","to buy hunting shotgun",450] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\buyKozlice.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, m16station, 3,
    {
    ["Press","to buy m16",800] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\buyxm117.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, l2mgstation, 3,
    {
    ["Press","to buy L2",800] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\buyFAL.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
uiSleep 5;
[player, stockmarketstation, 3,
    {
    ["Press","to buy, hold to sell"] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\buyStocks.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, grenadestation, 3,
    {
    ["Press","to buy grenade",500] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\randomGrenade.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, firesupportstation, 3,
    {
    ["Press","to buy fire support",30000] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\randomFireSupport.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, launcherstation, 3,
    {
    ["Press","to buy launcher",1000] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\randomlauncher.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
uiSleep 3;
[player, claymorestation, 3,
    {
    ["Press","to buy claymore",1000] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\buyClaymore.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, maxammostation, 3,
    {
    ["Press","for max ammo", 4000] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\fullAmmo.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
};
uiSleep 3;
[player, blocker5prompt, 3,
    {
    ["Press","to clear",750] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock_5.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, blocker6prompt, 3,
    {
    ["Press","to clear",1500] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock_6.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, blocker10prompt, 3,
    {
    ["Press","to clear",1500] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock_10.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, blocker7prompt, 3,
    {
    ["Press","to clear",1500] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock_7.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, blocker3prompt, 3,
    {
    ["Press","to clear",1000] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock_3.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, blocker2prompt, 3,
    {
    ["Press","to clear",750] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock_2.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, blocker0prompt, 3,
    {
    ["Press","to clear",1000] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, blocker9prompt, 3,
    {
    ["Press","to clear",1000] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock_9.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, blocker8prompt, 3,
    {
    ["Press","to clear",1000] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\roadblocks\buyRoadblock_8.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
[player, randomlonggunstation, 3,
    {
    ["Press","for random rifle",nil] remoteExec ["BAC_fnc_showMessage",player];
    execVM "scripts\randomweapons\randomLongguns.sqf";
    },
    {
    ["", "", nil, true] remoteExec ["BAC_fnc_showMessage",player];
    removeAllUserActionEventHandlers ["User10", "Activate"];
    }
] call BAC_fnc_proximityTrigger;
//////////////////////////////////////////////////////////////////////////////





// Sync to server's round count if it already exists
[] spawn {
    waitUntil { !isNil "BAC_zombRoundCount" };
    [BAC_zombRoundCount] call BAC_fnc_updateRoundHUD;
};

//######################### VOICELINES ##############################

// Map param index to pack names
private _voicePacks = ["jim", "bob", "sam"];

// Find player slot index (adjust if not straight player1/player2)
private _uid = getPlayerUID player;
private _slotIndex = (allPlayers findIf {_uid == getPlayerUID _x});

// Fallback
if (_slotIndex < 0) then {_slotIndex = 0;};
// Fetch param value
private _paramIndex = switch (_slotIndex) do {
    case 0: {paramsArray select 0}; // P1_VoicePack
    case 1: {paramsArray select 1}; // P2_VoicePack
    case 2: {paramsArray select 2}; // P3_VoicePack
    default {0}; // fallback jim
};

// Assign the voicePack variable
player setVariable ["voicePack", _voicePacks select _paramIndex, true];
// Debug
//systemChat format ["[VoicePacks] %1 assigned pack '%2'", name player, _voicePacks select _paramIndex];
//play voiceline when reloading
//NUMBER - 1 = local only, 2 = global say3D
player addEventHandler [
    "MagazineReloading",
    {
        private _unit = _this select 0;   // the unit that reloaded
        [_unit, "reload", 2, 0.5] call BAC_fnc_playVoiceLine;
    }
];
addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer", "_instigator"];

    // Did THIS local player get credited? (handles vehicles via _instigator)
    if (_killer isEqualTo player || {_instigator isEqualTo player}) then {

        // OPTIONAL: only count enemy kills
        // if (side group _unit == side group player) exitWith {};

        // show red kill marker
        [player, "taunt", 2, 0.01] call BAC_fnc_playVoiceLine;
    };
}];

/*
    Damage listener for voice lines
    Runs locally on each client
*/
[] spawn {
    private _lastDamage = damage player;

    while {true} do {
        private _curDamage = damage player;

        // clamp tiny float values
        if (_curDamage < 0.001) then { _curDamage = 0; };

        // --- Detect damage increase
        if (_curDamage > _lastDamage + 0.01) then {
            //systemChat format ["[DamageListener] Player took damage! Old: %1 New: %2", _lastDamage, _curDamage];

            // Trigger hurt voiceline (locality = 2 means global positional)
            [player, "hurt", 2, 1] call BAC_fnc_playVoiceLine;
        };

        _lastDamage = _curDamage;
        sleep 0.25;  // check 4 times per second for responsiveness
    };
};

// Watcher loop covers scripted setDamage
[] spawn {
    private _last = damage player;
    while {alive player} do {
        private _cur = damage player;
        if (_cur != _last) then {
            _last = _cur;
            if (_cur >= 0.4 && !(player getVariable ["BAC_isDowned", false])) then {
                [player, "downed", 2, 1] call BAC_fnc_playVoiceLine;
            };
        };
        uiSleep 0.25;
    };
};

//######################### VOICELINES ##############################

// Initialize score variable
player setVariable ["BAC_score", 0, true];  // last 'true' makes it JIP-safe

player addEventHandler ["Killed", {
    params ["_unit", "_killer"];

    if (_killer isEqualTo player) then {
        private _score = player getVariable ["BAC_score", 0];
        _score = _score + 100;   // +100 points per kill
        player setVariable ["BAC_score", _score, true];

        // Update HUD
        [_score] call BAC_fnc_updateScoreHUD;
    };
}];

// Create HUD
[] execVM "scripts\HUD\createScoreHUD.sqf";

// Initialize score
player setVariable ["BAC_score", 0, true];

player addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

	// Attach hit detection to bullet
	_projectile addEventHandler ["HitPart", {
		params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius", "_surfaceType", "_instigator"];

		if (_projectileOwner == player && !isNull _hitEntity && _hitEntity isKindOf "Man" && {alive _hitEntity}) then {
			        private _score = player getVariable ["BAC_score", 0];
                    _score = _score + 10;   // adjust per kill value
                    player setVariable ["BAC_score", _score, true];
                    [_score] call BAC_fnc_updateScoreHUD;
		};				
	}];
}];

// Add score when local player kills something
addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer", "_instigator"];
    // Did THIS local player get credited? (handles vehicles via _instigator)
    if (_killer isEqualTo player) then {
        private _score = player getVariable ["BAC_score", 0];
        _score = _score + 100;   // adjust per kill value
        player setVariable ["BAC_score", _score, true];
        [_score] call BAC_fnc_updateScoreHUD;
    };
}];


// firemode HUD
[] spawn {
    waitUntil { !isNull (findDisplay 46) };
    private _disp = findDisplay 46;

    // --- Create firemode HUD control ---
    private _ctrl = _disp ctrlCreate ["RscStructuredText", 2203];
    _ctrl ctrlSetPosition [
        safezoneX + safezoneW - 0.27,  // X pos
        safezoneY + safezoneH - 0.46,  // Y pos (slightly above grenades)
        0.20,                          // width
        0.12                           // height
    ];
    _ctrl ctrlCommit 0;

    uiNamespace setVariable ["BAC_FiremodeHUD_ctrl", _ctrl];

    // Update when weapon or firemode changes
    player addEventHandler ["WeaponChanged", { [] call BAC_fnc_updateFiremodeHUD }];
    player addEventHandler ["Fired",          { [] call BAC_fnc_updateFiremodeHUD }]; // safety net
    player addEventHandler ["Reloaded",       { [] call BAC_fnc_updateFiremodeHUD }];

    // Fallback loop
    [] spawn {
        while {true} do {
            [] call BAC_fnc_updateFiremodeHUD;
            sleep 0.5;
        };
    };
};

//grenade counter UI
[] spawn {
    waitUntil { !isNull (findDisplay 46) };
    private _disp = findDisplay 46;

    // --- Create grenade HUD control ---
    private _ctrl = _disp ctrlCreate ["RscStructuredText", 2201];
    _ctrl ctrlSetPosition [
		safezoneX + safezoneW - 0.23,  // X pos higher = left
		safezoneY + safezoneH - 0.14,  // Y pos higher = up
		0.20,                          // width
		0.10                           // height
    ];
    _ctrl ctrlCommit 0;

    uiNamespace setVariable ["BAC_GrenadeHUD_ctrl", _ctrl];

    // Auto-update
    player addEventHandler ["Take", { [] call BAC_fnc_updateGrenadeHUD }];
    player addEventHandler ["Put", { [] call BAC_fnc_updateGrenadeHUD }];
    player addEventHandler ["WeaponChanged", { [] call BAC_fnc_updateGrenadeHUD }];

    // Fallback loop
    [] spawn {
        while {true} do {
            [] call BAC_fnc_updateGrenadeHUD;
            sleep 1;
        };
    };
};

// claymore counter UI
[] spawn {
    waitUntil { !isNull (findDisplay 46) };
    private _disp = findDisplay 46;

    // --- Create mine HUD control ---
    private _ctrl = _disp ctrlCreate ["RscStructuredText", 2202];
    _ctrl ctrlSetPosition [
		safezoneX + safezoneW - 0.32,  // X pos higher = left
		safezoneY + safezoneH - 0.14,  // Y pos higher = up
		0.20,                          // width
		0.10                           // height
    ];
    _ctrl ctrlCommit 0;

    uiNamespace setVariable ["BAC_MineHUD_ctrl", _ctrl];

    // Auto-update when inventory changes
    player addEventHandler ["Take", { [] call BAC_fnc_updateMineHUD }];
    player addEventHandler ["Put", { [] call BAC_fnc_updateMineHUD }];

    // Fallback updater
    [] spawn {
        while {true} do {
            [] call BAC_fnc_updateMineHUD;
            sleep 1;
        };
    };
};

//round counter & ammo pool
[] spawn {
    waitUntil { !isNull (findDisplay 46) };
    private _disp = findDisplay 46;

    // --- Create HUD control ---
    private _ctrl = _disp ctrlCreate ["RscStructuredText", 2200];
	_ctrl ctrlSetPosition [
		safezoneX + safezoneW - 0.28,  // X pos higher = left
		safezoneY + safezoneH - 0.30,  // Y pos higher = up
		0.38,                          // width
		0.13                           // height
	];
    _ctrl ctrlCommit 0;

    uiNamespace setVariable ["BAC_AmmoHUD_ctrl", _ctrl];
	
	[] spawn BAC_fnc_updateAmmoHUD;
    // --- Auto-update on relevant events ---
    player addEventHandler ["Fired", { [] spawn { sleep 0.5; [] spawn BAC_fnc_updateAmmoHUD } }];
    player addEventHandler ["Reloaded", { [] spawn { sleep 0.5; [] spawn BAC_fnc_updateAmmoHUD } }];
    player addEventHandler ["Take", { [] spawn BAC_fnc_updateAmmoHUD }];
    player addEventHandler ["Put", { [] spawn BAC_fnc_updateAmmoHUD }];
    player addEventHandler ["WeaponChanged", { [] spawn BAC_fnc_updateAmmoHUD }];

        // Fallback updater
    [] spawn {
        while {true} do {
            [] spawn BAC_fnc_updateAmmoHUD;
            sleep 0.2;
        };
    };
};

// score popup near crosshair
[] spawn {
    // Get player's main display
    waitUntil {!isNull (findDisplay 46)};
    private _disp = findDisplay 46;

    // Create a structured text control for money popup
    private _ctrl = _disp ctrlCreate ["RscStructuredText", 2222];
    _ctrl ctrlSetPosition [
        safezoneX + safezoneW / 2 + 0.05,   // right of center
        safezoneY + safezoneH / 2 - 0.03,   // vertically aligned with hitmarker
        0.2,                                // width
        0.05                                // height
    ];
    _ctrl ctrlCommit 0;

    // Store for later access
    uiNamespace setVariable ["BAC_moneyCtrl", _ctrl];
};


/*
    Passive Health Regen with Delay
    Runs locally for each player.

    - If player damage is > 0 and < downed threshold → slowly heals over time.
    - Regen pauses for 5 seconds after taking new damage.
    - Only shows ONE message when health is fully restored.
*/

[] spawn {
    private _regenRate       = 0.05;  // heal amount per second (damage scale)
    private _downedThreshold = 0.4;   // stop healing at this value (downed triggers separately)
    private _delayTime       = 5;     // seconds to wait after taking new damage

    private _lastDamage = damage player;
    private _nextHeal   = time + _delayTime;
    private _wasHealing = false;

    while {true} do {
        private _curDamage = damage player;

        // Normalize near-zero floats
        if (_curDamage < 0.001) then { _curDamage = 0; };

        // --- Detect new damage taken
        if (_curDamage > _lastDamage + 0.001) then {
            _nextHeal = time + _delayTime;
            _wasHealing = false; // reset
        };

        // --- Heal if allowed
        if (time >= _nextHeal && {_curDamage > 0 && _curDamage < _downedThreshold}) then {
            private _newDamage = (_curDamage - _regenRate) max 0;

            if (_newDamage < 0.001) then {
                _newDamage = 0;
                if (_wasHealing) then {
                   //systemChat "[Regen] Health fully restored!";
                    _wasHealing = false;
                };
            } else {
                _wasHealing = true; // regen active
            };

            player setDamage _newDamage;
        };

        _lastDamage = damage player;
        sleep 1; // regen tick interval
    };
};




/*
    Local Downed State Watcher
    Runs on each client.

    - If damage >= 0.4 and < 1 → clamps to 0.4 and calls setDowned
    - If damage < 0.4 → resets BAC_isDowned flag if previously set
    - If damage >= 1 → lethal, do nothing (respawn will happen)
*/

/*
    Downed State Watcher
    Runs locally for each player.
    - Only observes damage, never heals or modifies it.
    - Calls fn_setDowned when player hits threshold.
*/

[] spawn {
    private _downedThreshold = 0.4;

    while {true} do {
        if (alive player) then {
            private _dmg = damage player;

            // --- Downed condition: in range, and not already flagged
            if (_dmg >= _downedThreshold && _dmg < 1) then {
                if !(player getVariable ["BAC_isDowned", false]) then {
                    [player] remoteExec ["BAC_fnc_setDowned", 2];
                    //systemChat ">>> setDowned (watcher)";
                };
            };

            // --- Death condition: do nothing, vanilla respawn handles it
            if (_dmg >= 1) then {
                // no action needed
            };
        };

        sleep 0.2;  // 5 checks per second
    };
};

/*
    Passive Health Regen with Delay
    Runs locally for each player.

    - Always running in background.
    - Disabled while "downed" (BAC_isDowned = true).
    - If player damage is > 0 and < downed threshold → slowly heals over time.
    - Regen pauses for 5 seconds after taking new damage.
    - Only shows ONE message when health is fully restored.
*/

[] spawn {
    private _regenRate       = 0.05;  // heal amount per second (damage scale)
    private _downedThreshold = 0.4;   // stop healing at this value (downed handled separately)
    private _delayTime       = 5;     // seconds to wait after taking new damage

    private _lastDamage = damage player;
    private _nextHeal   = time + _delayTime;
    private _wasHealing = false;

    while {true} do {
        private _curDamage = damage player;

        // --- Pause regen if player is "downed"
        if (player getVariable ["BAC_isDowned", false]) then {
            _lastDamage = _curDamage;  // keep damage tracking in sync
            sleep 1;
            continue;                  // skip this tick, loop continues
        };

        // --- Normalize near-zero floats
        if (_curDamage < 0.001) then { _curDamage = 0; };

        // --- Detect new damage taken
        if (_curDamage > _lastDamage + 0.001) then {
            _nextHeal = time + _delayTime;
            _wasHealing = false; // reset healing state
        };

        // --- Apply regen if eligible
        if (time >= _nextHeal && {_curDamage > 0 && _curDamage < _downedThreshold}) then {
            private _newDamage = (_curDamage - _regenRate) max 0;

            if (_newDamage < 0.001) then {
                _newDamage = 0;
                if (_wasHealing) then {
                    //systemChat "[Regen] Health fully restored!";
                    _wasHealing = false;
                };
            } else {
                _wasHealing = true;
            };

            player setDamage _newDamage;
        };

        _lastDamage = damage player;
        sleep 1; // regen tick
    };
};
