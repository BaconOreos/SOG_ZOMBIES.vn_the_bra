/*
    Function: BAC_fnc_showMessageGeneric

    Params:
        0: STRING - _text (required)
        1: STRING - _colorHex (default "#FFFFFF")
        2: NUMBER - _size (default 2.5)
        3: BOOL - _hide (default false)

    Example:
        ["Revive in progress...", "#d68b50", 3] remoteExec ["TAG_fnc_showMessage", player1];
        ["Press User10 to Interact", "#cccccc", 2.5] remoteExec ["TAG_fnc_showMessage", player1];
        ["", "", 0, true] remoteExec ["TAG_fnc_showMessage", player1]; // hides
*/

//FONTS
//"tt2020base_vn"
//"tt2020base_vn_bold"
//"tt2020style_e_vn"
//"tt2020style_e_vn_bold"
//font='tt2020base_vn_bold'

params [
    ["_text", "", [""]],
    ["_colorHex", "#FFFFFF", [""]],
    ["_size", 2.5, [0]],
    ["_hide", false, [false]]
];

disableSerialization;
private _display = findDisplay 46; // main game UI

// --- Always clear previous message ---
private _oldCtrl = uiNamespace getVariable ["myMessageCtrl", controlNull];
if !(isNull _oldCtrl) then {
    ctrlDelete _oldCtrl;
    uiNamespace setVariable ["myMessageCtrl", controlNull];
};

// --- If hide flag set, just exit ---
if (_hide) exitWith {};

// --- Build structured text ---
private _structuredText = format [
    "<t align='center' color='%2' font='tt2020base_vn_bold' size='%3'>%1</t>",
    _text,
    _colorHex,
    _size
];

// --- Create fresh control ---
private _ctrl = _display ctrlCreate ["RscStructuredText", 12345];
uiNamespace setVariable ["myMessageCtrl", _ctrl];

_ctrl ctrlSetStructuredText parseText _structuredText;

// Positioning (center of screen)
private _w = 1.2;
private _h = 0.3;
private _x = safezoneX + (safezoneW / 2) - (_w / 2);
private _y = safezoneY + (safezoneH / 2) - (_h / 2);

_ctrl ctrlSetPosition [_x, _y, _w, _h];
_ctrl ctrlCommit 0;
