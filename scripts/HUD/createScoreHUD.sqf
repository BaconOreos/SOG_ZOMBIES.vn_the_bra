/*
    scripts\createScoreHUD.sqf
    Creates the player's score HUD (bottom-left).
*/

waitUntil { !isNull (findDisplay 46) };

private _disp = findDisplay 46;
private _ctrl = _disp ctrlCreate ["RscStructuredText", 2100];

private _w = 0.5;
private _h = 0.3;

_ctrl ctrlSetPosition [
    safezoneX + safezoneW - _w - 0.10,   // right edge - width - margin
    safezoneY + safezoneH - _h - 0.30,   // bottom edge - height - margin
    _w,
    _h
];
_ctrl ctrlCommit 0;

// Save reference to the control
uiNamespace setVariable ["BAC_scoreHUD_ctrl", _ctrl];

// Initialize with 0 points
[0] call BAC_fnc_updateScoreHUD;
