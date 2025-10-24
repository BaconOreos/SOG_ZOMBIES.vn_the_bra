/*
    functions\fn_updateHUD.sqf
    Updates the player's score HUD.
*/

//FONTS
//"tt2020base_vn"
//"tt2020base_vn_bold"
//"tt2020style_e_vn"
//"tt2020style_e_vn_bold"
//font='tt2020base_vn_bold'
params ["_score"];

private _ctrl = uiNamespace getVariable ["BAC_scoreHUD_ctrl", controlNull];
if (!isNull _ctrl) then {
    _ctrl ctrlSetStructuredText parseText
        format ["<t size='4' align='right' color='#cccccc' font='tt2020base_vn_bold'> %1</t>", _score];
};
