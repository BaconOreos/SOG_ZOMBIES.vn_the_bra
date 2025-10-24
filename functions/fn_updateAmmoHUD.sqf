/*
    fn_updateAmmoHUD.sqf
    Displays ammo count for the currently held weapon:
    X = ammo in gun
    Y = total reserve ammo (all compatible mags in inventory, excluding loaded mag)
*/

private _ctrl = uiNamespace getVariable ["BAC_AmmoHUD_ctrl", controlNull];
if (isNull _ctrl) exitWith {};

// --- Current weapon ---
private _weapon = currentWeapon player;
if (_weapon isEqualTo "") exitWith {
    _ctrl ctrlSetStructuredText parseText
        "<t size='1.2' color='#FFFFFF' font='tt2020base_vn_bold'>No Weapon</t>";
};

// --- Get all compatible magazines for this weapon ---
private _compatibleMags = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");

// --- Get full magazine info from inventory ---
private _allMags = magazinesAmmoFull player;

// --- Track loaded mag & reserves ---
private _curMag        = currentMagazine player;
private _ammoInMag     = 0;
private _reserve       = 0;
private _loadedSkipped = false;

{
    private _magClass = _x select 0;   // magazine class
    private _rounds   = _x select 1;   // remaining rounds
    private _isLoaded = _x select 2;   // is currently loaded in a weapon?

    if (_magClass in _compatibleMags) then {
        if (_isLoaded && { _magClass == _curMag } && { !_loadedSkipped }) then {
            // This is the mag actually loaded into the current weapon
            _ammoInMag = _rounds;
            _loadedSkipped = true;
        } else {
            // All other compatible mags are reserve
            _reserve = _reserve + _rounds;
        };
    };
} forEach _allMags;

// --- Safety: if no loaded mag was found, fallback to engine’s ammo count ---
if (!_loadedSkipped) then {
    _ammoInMag = player ammo _weapon;
};

// --- Format HUD text ---
private _text = format [
    "<t size='3.8' color='#cccccc' font='tt2020base_vn_bold'>%1</t>" +
    "<t size='3' color='#cccccc' font='tt2020base_vn_bold'> / %2</t>",
    _ammoInMag,
    _reserve
];

_ctrl ctrlSetStructuredText parseText _text;
