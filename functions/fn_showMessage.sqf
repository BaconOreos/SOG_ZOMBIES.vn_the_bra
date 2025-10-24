/*
    Function: TAG_fnc_showMessage

    Params:
        0: STRING - _textPrefix (default "Press")
        1: STRING - _textSuffix (default "")
        2: NUMBER/STRING - _cost (optional, default "")
        3: BOOL - _hide (optional, default false)

    Example:
        ["Press", "to Heal", 50] remoteExec ["TAG_fnc_showMessage", player1];
        ["Hold", "to Open"] remoteExec ["TAG_fnc_showMessage", player1];
        ["", "", nil, true] remoteExec ["TAG_fnc_showMessage", player1]; // hides
*/


//FONTS
//"tt2020base_vn"
//"tt2020base_vn_bold"
//"tt2020style_e_vn"
//"tt2020style_e_vn_bold"
//font='tt2020base_vn_bold'

params [
    ["_textPrefix", "Press", [""]],
    ["_textSuffix", "", [""]],
    ["_cost", "", ["", 0]],
    ["_hide", false, [false]]
];

disableSerialization;
private _display = findDisplay 46; // main game UI

// --- Always clear any previous control ---
private _oldCtrl = uiNamespace getVariable ["myMessageCtrl", controlNull];
if !(isNull _oldCtrl) then {
    ctrlDelete _oldCtrl;
    uiNamespace setVariable ["myMessageCtrl", controlNull];
};

// --- Handle hide flag ---
if (_hide) exitWith {};

// Get player's bound key for User10
private _user10Key = actionKeysImages "User10";

// Build cost text (only if provided and not empty)
private _costText = "";
if (!isNil "_cost" && !(_cost isEqualTo "")) then {
    _costText = format [" [Cost: %1]", _cost];
};

// Final structured text
private _structuredText = format [
    "<t align='center'>\
        <t color='#cccccc' font='tt2020base_vn_bold' size='2.5'>%1</t>\
        <t color='#d68b50' font='tt2020base_vn_bold' size='3'> %2</t>\
        <t color='#cccccc' font='tt2020base_vn_bold' size='2.5'> %3%4</t>\
    </t>",
    _textPrefix,
    _user10Key,
    _textSuffix,
    _costText
];

// --- Create fresh control ---
private _ctrl = _display ctrlCreate ["RscStructuredText", 12345];
uiNamespace setVariable ["myMessageCtrl", _ctrl];

_ctrl ctrlSetStructuredText parseText _structuredText;

// Positioning
private _w = 1.2;// Width of the control
private _h = 0.3;// Height of the control
private _x = safezoneX + (safezoneW / 2) - (_w / 2);// Calculate the X position: Centered horizontally in the safe zone
private _y = safezoneY + (safezoneH / 2) - (_h / 2) + 0.4;// Calculate the Y position: Centered vertically in the safe zone
// Set the position of the control using the calculated X and Y, width, and height
_ctrl ctrlSetPosition [_x, _y, _w, _h];
_ctrl ctrlCommit 0;



//OLD function
/*
    Function: TAG_fnc_showMessage

    Params:
        0: STRING - _textPrefix (default "Press")
        1: STRING - _textSuffix (default "")
        2: NUMBER/STRING - _cost (optional, default "")
        3: BOOL - _hide (optional, default false)

    Example:
        ["Press", "to Heal", 50] remoteExec ["TAG_fnc_showMessage", player1];
        ["Hold", "to Open"] remoteExec ["TAG_fnc_showMessage", player1];
        [" ", " ", nil, true] remoteExec ["TAG_fnc_showMessage", player1]; // hides
*/

/* params [
    ["_textPrefix", "Press", [""]],
    ["_textSuffix", "", [""]],
    ["_cost", "", ["", 0]],
    ["_hide", false, [false]]
];

// If hide is true → clear the UI and exit
if (_hide) exitWith {
    disableSerialization;
    private _ctrl = uiNamespace getVariable ["myMessageCtrl", controlNull];
    if !(isNull _ctrl) then {
        ctrlDelete _ctrl;
        uiNamespace setVariable ["myMessageCtrl", controlNull];
    };
};


// Get player's bound key for User10
private _user10Key = actionKeysImages "User10";

// Build cost text (only if provided and not empty)
private _costText = "";
if (!isNil "_cost" && !(_cost isEqualTo "")) then {
    _costText = format [" [Cost: %1]", _cost];
};

// Final structured text (centered)
private _structuredText = format [
    "<t align='center'>\
        <t color='#cccccc' font='tt2020base_vn_bold' size='2.5'>%1</t>\
        <t color='#d68b50' font='tt2020base_vn_bold' size='3'> %2</t>\
        <t color='#cccccc' font='tt2020base_vn_bold' size='2.5'> %3%4</t>\
    </t>",
    _textPrefix,
    _user10Key,
    _textSuffix,
    _costText
];

// --- UI Drawing ---
disableSerialization;
private _display = findDisplay 46; // main game UI
private _ctrl = _display ctrlCreate ["RscStructuredText", 12345]; // fixed ID so we can reuse

uiNamespace setVariable ["myMessageCtrl", _ctrl];

_ctrl ctrlSetStructuredText parseText _structuredText;

// Positioning (centered horizontally, near bottom)
private _w = 1.2;   // width of box
private _h = 0.3;   // height of box
private _x = safezoneX + (safezoneW / 2) - (_w / 2); // center X
private _y = safezoneY + (safezoneH / 2) - (_h / 2);           // near bottom

_ctrl ctrlSetPosition [
    _x, // center horizontally
    _y, // vertical offset from bottom
    _w, // width
    _h  // height
];
_ctrl ctrlCommit 0;
 */