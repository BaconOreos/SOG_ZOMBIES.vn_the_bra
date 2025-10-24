_user10Key = actionKeysImages "User10";

//titleText [format ["<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> to pick up a rifle</t>", _user10Key], "PLAIN NOFADE", -1, false, true];
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
		[] spawn {
				private _weapon = selectRandom ["vn_vz54", "vn_svd", "vn_sks", "vn_m9130", "vn_m4956", "vn_m40a1", "vn_m38", "vn_m36", "vn_m1903", "vn_m1891", "vn_m1_garand", "vn_k98k", "vnx_no4_sniper" ];
				
				player playAction "gestureFreeze";
				//removeAllMagazines player;
				player addWeapon _weapon;
                uiSleep 0.2;
                [] call BAC_fnc_keepOnlyCompatibleMags;
                
				private _compatMag = compatibleMagazines _weapon select 0;
				player addMagazines [_compatMag, 3];
				player addPrimaryWeaponItem _compatMag;


				execVM "scripts\notSoFullAmmo.sqf";

				/* cutText ["<br/><br/><br/><t color='#ff6600' size='4'>Picked up " + _weapon + "</t>", "PLAIN", -1, true, true];
				uiSleep 1;
				cutText ["<br/><br/><br/><t color='#00FF00' size='5'></t>", "PLAIN", -1, true, true]; */
				}
    };
}];

