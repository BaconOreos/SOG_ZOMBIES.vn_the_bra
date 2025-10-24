/*
    fn_interactPrompt.sqf
    Displays an interaction prompt to the local player
*/




//FONTS
//"tt2020base_vn"
//"tt2020base_vn_bold"
//"tt2020style_e_vn"
//"tt2020style_e_vn_bold"
//font='tt2020base_vn_bold'



/*
    fn_interactPrompt.sqf
    Displays or hides an interaction prompt for the local player.
*/

params ["_text", ["_cost", -1], ["_hide", false]];   // _hide = optional, default false

private _user10Key = actionKeysImages "User10";

// If hide flag is true → clear the prompt and exit
if (_hide) exitWith {
    titleText ["", "PLAIN NOFADE", -1, false, true];
};

// Build text
private _displayText = if (_cost >= 0) then {
    format [
        "<t color='#cccccc' font='tt2020base_vn_bold' size='4'>Press</t><t color='#d68b50' font='tt2020base_vn_bold' size='5'> %1</t><t color='#cccccc' font='tt2020base_vn_bold' size='4'> %2 [Cost: %3]</t>",
        _user10Key, _text, _cost
    ]
} else {
    format [
        "<t color='#cccccc' font='tt2020base_vn_bold' size='4'>Press</t><t color='#d68b50' font='tt2020base_vn_bold' size='5'> %1</t><t color='#cccccc' font='tt2020base_vn_bold' size='4'> %2</t>",
        _user10Key, _text
    ]
};

titleText [_displayText, "PLAIN NOFADE", -1, false, true];




/* params ["_text", ["_cost", -1]];   // default cost = -1 (means none)

private _user10Key = actionKeysImages "User10";

// Build text
private _displayText = if (_cost >= 0) then {
    format [
        "<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> %2 [Cost: %3]</t>",
        _user10Key, _text, _cost
    ]
} else {
    format [
        "<t color='#cccccc' size='4'>Press</t><t color='#d68b50' size='5'> %1</t><t color='#cccccc' size='4'> %2</t>",
        _user10Key, _text
    ]
};

titleText [_displayText, "PLAIN NOFADE", -1, false, true]; */
