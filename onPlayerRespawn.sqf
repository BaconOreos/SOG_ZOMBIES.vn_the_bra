player setCustomAimCoef 0; 
player enableAimPrecision false; 
player enableFatigue false; 
player enableStamina false; 
player setAnimSpeedCoef 1.5; 
player setUnitRecoilCoefficient 0.8;
player setAnimSpeedCoef 1.3;

player setUnitLoadout(player getVariable["Saved_Loadout",[]]); //retrieves the loadout saved on death
player setVariable ["BAC_isDowned", false, true];

[] execVM "scripts\Bacon_gameplay_experience\jumpScript.sqf";

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