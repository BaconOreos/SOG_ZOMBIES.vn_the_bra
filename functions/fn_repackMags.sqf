/*
    File: fn_repackMags.sqf
    Purpose: Repack mags in player inventory (keeps loaded mag untouched).
*/

private _mags = magazinesAmmo player;   // [["magClass", ammoCount], ...]

/* --- Detect currently loaded mag --- */
private _loadedMag = [];
{
    private _ws = weaponState _x;
    if !(_ws isEqualTo []) then {
        private _magClass = _ws select 3;
        private _ammo     = _ws select 4;
        if (_magClass != "") then {
            _loadedMag = [_magClass, _ammo];
        };
    };
} forEach [primaryWeapon player, secondaryWeapon player, handgunWeapon player];

/* --- Build grouped list excluding loaded mag --- */
private _grouped = createHashMap;

{
    private _magClass = _x select 0;
    private _ammo     = _x select 1;

    // skip if this is the loaded mag (we leave it in the gun)
    if (_loadedMag isNotEqualTo [] && { _magClass == (_loadedMag select 0) && _ammo == (_loadedMag select 1) }) then {
        _loadedMag = []; // only skip *once* for that specific mag
    } else {
        if (isNil { _grouped get _magClass }) then {
            _grouped set [_magClass, []];
        };
        _grouped set [_magClass, (_grouped get _magClass) + [_ammo]];
    };
} forEach _mags;

/* --- Process each mag type --- */
{
    private _magClass = _x;
    private _ammoArray = _grouped get _magClass;

    private _capacity = getNumber (configFile >> "CfgMagazines" >> _magClass >> "count");
    if (_capacity <= 0) then { continue };

    private _totalAmmo = 0;
    { _totalAmmo = _totalAmmo + _x } forEach _ammoArray;

    // Remove existing reserve mags of this type
    { player removeMagazine _magClass } forEach _ammoArray;

    // Add back optimized mags
    while { _totalAmmo > 0 } do {
        private _toLoad = _capacity min _totalAmmo;
        player addMagazine [_magClass, _toLoad];
        _totalAmmo = _totalAmmo - _toLoad;
    };
} forEach (keys _grouped);
