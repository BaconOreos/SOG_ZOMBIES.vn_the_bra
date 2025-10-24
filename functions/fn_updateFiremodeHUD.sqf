/*
    fn_updateFiremodeHUD.sqf
    Shows current firemode in HUD using icons.
*/


//FONTS
//"tt2020base_vn"
//"tt2020base_vn_bold"
//"tt2020style_e_vn"
//"tt2020style_e_vn_bold"
//font='tt2020base_vn_bold'

// --- Get UI control ---
private _ctrl = uiNamespace getVariable ["BAC_FiremodeHUD_ctrl", controlNull];
if (isNull _ctrl) exitWith {};

// --- Get current weapon + firemode ---
private _weapon = currentWeapon player;
if (_weapon isEqualTo "") exitWith {
    _ctrl ctrlSetStructuredText parseText "<t size='1.6' color='#777777'>-</t>"; // no weapon
};

private _mode = currentWeaponMode player;   // e.g. "Single", "FullAuto", "Burst", custom
private _icon = "";
private _text = "";

// --- Map firemodes to icons ---
switch (true) do {
    case (_mode isEqualTo "Single"):          { _icon = "images\semi.paa"; };
	case (_mode isEqualTo "single"):          { _icon = "images\semi.paa"; };
    case (_mode isEqualTo "Burst"):           { _icon = "images\burst.paa"; };
    case (_mode isEqualTo "FullAuto"):        { _icon = "images\fullauto.paa"; };
    case (_mode isEqualTo "FullAutoFast"):    { _icon = "images\fullautofast.paa"; };
    case (_mode find "melee" > -1):           { _text = "<t size='1.8' color='#b6098bff'></t>"; };
    default { _text = format ["<t size='1.2' font='tt2020base_vn' color='#cccccc'>%1</t>", _mode]; };
};

// --- Build output ---
if (_icon != "") then {
    _text = format ["<img image='%1' size='3'/>", _icon];
};

_ctrl ctrlSetStructuredText parseText _text;
