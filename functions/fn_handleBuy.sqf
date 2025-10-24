/*
    File: fn_handleBuy.sqf
    Handles the buy action: deducts points, gives items, or shows error.
*/

params ["_type", "_station"];

// Example cost per type
private _costs = [
    ["randomGrenade", 200],
    ["randomWeapon", 950],
    ["randomLauncher", 1500]
];
private _cost = _costs select { _x select 0 == _type } param [0, ["",999999]] select 1;

// Check points
if !( [ _cost ] call BAC_fnc_scoreBuy ) exitWith {
    cutText ["<br/><br/><br/><t color='#ff4444' size='4'>Not enough points</t>", "PLAIN", -1, true, true];
};

// Grant reward depending on type
switch (_type) do {
    case "randomGrenade": {
        private _grenade = selectRandom ["vn_m67_grenade_mag","vn_m61_grenade_mag","vn_molotov_grenade_mag","MiniGrenade"];
        player addMagazines [_grenade, 1];
        cutText [format ["<br/><br/><br/><t color='#ff6600' size='4'>Picked up %1</t>", _grenade], "PLAIN", -1, true, true];
    };

    case "randomWeapon": {
        private _weapon = selectRandom ["vn_m16","vn_m14a1_shorty","vn_m60_shorty","vn_ppsh41"];
        removeAllWeapons player;
        player addWeapon _weapon;

        private _mag = (compatibleMagazines _weapon) select 0;
        player addMagazines [_mag, 3];
        player addPrimaryWeaponItem _mag;

        cutText [format ["<br/><br/><br/><t color='#ff6600' size='4'>Picked up %1</t>", _weapon], "PLAIN", -1, true, true];
    };

    case "randomLauncher": {
        private _launcher = selectRandom ["vn_rpg7","vn_m72","vn_m20a1b1_01"];
        removeAllWeapons player;
        player addWeapon _launcher;

        private _mag = (compatibleMagazines _launcher) select 0;
        player addMagazines [_mag, 1];
        player addSecondaryWeaponItem _mag;

        cutText [format ["<br/><br/><br/><t color='#ff6600' size='4'>Picked up %1</t>", _launcher], "PLAIN", -1, true, true];
    };
};
