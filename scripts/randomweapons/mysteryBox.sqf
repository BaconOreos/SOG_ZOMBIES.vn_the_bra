// Key binding visual (User10 key)
_user10Key = actionKeysImages "User10";

// Define the cost of this buy station
private _cost = 950;

// Store the cost globally so the handler can access it later
missionNamespace setVariable ["BAC_buyCost", _cost];

// Show the prompt with the cost
titleText [format [
    "<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> to buy a random gun [Cost: %2]</t>",
    _user10Key,
    missionNamespace getVariable ["BAC_buyCost", 0]   // ✅ safe fetch
], "PLAIN NOFADE", -1, false, true];

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
                    "vn_xm16e1","vn_xm177e1","vn_xm177_short","vn_vz61","vn_type64_smg","vn_type56",
                    "vn_sten","vn_rpd_shorty_01","vn_rpd_shorty","vn_ppsh41","vn_pps52","vn_pps43",
                    "vn_pk","vn_mpu","vn_mp40","vn_mg42","vn_mc10","vn_mat49","vn_m79","vn_m63a",
                    "vn_m60_shorty","vn_m3a1","vn_m2carbine","vn_m1928_tommy","vn_m1918","vn_m1897",
                    "vn_m16","vn_m14a1_shorty","vn_m1carbine","vn_m45","vn_l4","vn_l2a3","vn_l1a1_01",
                    "vn_kbkg","vn_k50m","vn_izh54_shorty","vn_gau5a","vn_f1_smg","vn_dp28","vn_ak_01",
                    "vnx_fm2429","vnx_l1a1_05","vnx_m45_sf","vnx_m12_smg_fold","vnx_m50_smg_fold","vnx_m77e_shorty"
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
                cutText ["<br/><br/><br/><t color='#ff4444' size='4'>Not enough points</t>", "PLAIN", -1, true, true];
            };
        };
    };
}];














