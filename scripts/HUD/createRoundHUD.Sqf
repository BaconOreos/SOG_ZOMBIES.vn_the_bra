/*
    scripts\createRoundHUD.sqf
    Creates the round counter HUD control inside display 46, this is used to initialize and set the position of the hud
*/

//FONTS
//"tt2020base_vn"
//"tt2020base_vn_bold"
//"tt2020style_e_vn"
//"tt2020style_e_vn_bold"

waitUntil { !isNull (findDisplay 46) };

private _disp = findDisplay 46;
private _ctrl = _disp ctrlCreate ["RscStructuredText", 1100];   // unique IDC for round HUD

_ctrl ctrlSetPosition [
    safezoneX + 0.02,                  // a little off the left edge
    safezoneY + safezoneH - 0.35,      // above bottom
    1.00,                              // width
    0.50                                // height
];

_ctrl ctrlCommit 0;

// Default text
_ctrl ctrlSetStructuredText parseText "<t size='10' font='tt2020base_vn_bold' color='#FF0000'> 1</t>";

// Save control reference
uiNamespace setVariable ["BAC_RoundHUD_ctrl", _ctrl];
