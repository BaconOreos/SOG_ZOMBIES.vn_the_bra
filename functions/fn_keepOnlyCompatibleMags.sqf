/*
    File: fn_keepOnlyCompatibleMags.sqf
    Author: You
    Description:
        Removes all magazines from the player that are not compatible with
        their currently equipped weapons or explicitly whitelisted.

    Usage:
        [] call fn_keepOnlyCompatibleMags;
*/

params [["_unit", player]];   // Allow passing another unit, defaults to player

// Always-keep magazines (example: hand grenades, smokes, etc.)
private _alwaysWhitelist = [
    "HandGrenade",
    "MiniGrenade",
    "SmokeShell",
    "SmokeShellRed",
    "SmokeShellGreen",
    "SmokeShellBlue",
    "SmokeShellYellow",
    "SmokeShellOrange",
    "SmokeShellPurple",
	"vn_m67_grenade_mag",
	"vn_m61_grenade_mag",
	"vn_molotov_grenade_mag",
	"vn_mine_m18_range_mag"
];

// Get equipped weapons
private _weapons = [
    primaryWeapon _unit,
    handgunWeapon _unit,
    secondaryWeapon _unit
];

// Build whitelist of compatible magazines
private _whitelist = _alwaysWhitelist + (
    flatten (_weapons apply { compatibleMagazines _x })
);

// Get all magazines currently held
private _allMags = magazines _unit;

// Remove any mags not in whitelist
{
    if (!(_x in _whitelist)) then {
        _unit removeMagazines _x;
    };
} forEach _allMags;
