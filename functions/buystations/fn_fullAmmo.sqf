/*
    File: fn_fullAmmo.sqf
    Description: Refills ammo for all players
*/

{
    private _equippedPrimary  = primaryWeapon _x;
    private _equippedLauncher = secondaryWeapon _x;
    private _equippedPistol   = handgunWeapon _x;

    // Primary
    if (_equippedPrimary != "") then {
        private _compatMag = (compatibleMagazines _equippedPrimary) select 0;
        _x addMagazines [_compatMag, 10];
        _x addPrimaryWeaponItem _compatMag;
    };

    // Launcher
    if (_equippedLauncher != "") then {
        private _compatMagLauncher = (compatibleMagazines _equippedLauncher) select 0;
        _x addMagazines [_compatMagLauncher, 1];
        _x addSecondaryWeaponItem _compatMagLauncher;
    };

    // Handgun
    if (_equippedPistol != "") then {
        private _compatMagPistol = (compatibleMagazines _equippedPistol) select 0;
        _x addMagazines [_compatMagPistol, 6];
        _x addHandgunItem _compatMagPistol;
    };

    // Grenades
    private _grenade = selectRandom [
        "vn_m67_grenade_mag",
        "vn_m61_grenade_mag",
        "vn_molotov_grenade_mag",
        "MiniGrenade",
        "vn_mine_m18_range_mag"
    ];
    _x addMagazines [_grenade, 2];

    // Feedback text
    if (isPlayer _x) then {
        cutText [
            "<br/><br/><br/><t color='#00FF00' size='5'>FULL AMMO</t>",
            "PLAIN", -1, true, true
        ];
        uiSleep 1;
        cutText ["", "PLAIN", -1, true, true];
    };
} forEach allPlayers;
