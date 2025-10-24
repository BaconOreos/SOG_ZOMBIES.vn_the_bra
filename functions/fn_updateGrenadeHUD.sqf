
/*
    fn_updateGrenadeHUD.sqf
    Shows grenade count in HUD using icons.
*/

// --- Get UI control ---
private _ctrl = uiNamespace getVariable ["BAC_GrenadeHUD_ctrl", controlNull];
if (isNull _ctrl) exitWith {};

// --- Define known grenade classnames (add/remove as needed) ---
private _grenadeClasses = [
    "vn_m67_grenade_mag", "vn_m61_grenade_mag",
    "vn_molotov_grenade_mag", "MiniGrenade",
    "vn_m18_white_mag","vn_m18_green_mag",
    "vn_m18_red_mag","vn_m18_yellow_mag",
    "vn_m18_purple_mag"
];

// --- Count grenades in inventory ---
private _grenadeCount = 0;
{
    if (_x in _grenadeClasses) then {
        _grenadeCount = _grenadeCount + 1;
    };
} forEach magazines player;

// --- Display formatting ---
private _maxSlots    = 3;
private _slotsFilled = _grenadeCount min _maxSlots;

private _text = "";
for "_i" from 1 to _slotsFilled do {
    _text = _text + "<t size='1.4' color='#b6098bff'></t><img image='images\grenade.paa' size='2'/>"; // filled slot
};
for "_i" from (_slotsFilled + 1) to _maxSlots do {
    _text = _text + "<t size='1.4' color='#777777'></t><img image='images\grenade_grey.paa' size='2'/>"; // empty slot
};
if (_grenadeCount > _maxSlots) then {
    _text = _text + "<t size='1.8' color='#cccccc'>+</t>"; // extra grenades indicator
};

_ctrl ctrlSetStructuredText parseText _text;
