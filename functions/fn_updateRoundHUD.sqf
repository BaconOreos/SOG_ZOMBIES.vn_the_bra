/*
    functions\fn_updateRoundHUD.sqf
    Updates the HUD with the current game round number.
*/


params ["_roundNum"];

private _ctrl = uiNamespace getVariable ["BAC_RoundHUD_ctrl", controlNull];
if (!isNull _ctrl) then {
    _ctrl ctrlSetStructuredText parseText format [
        "<t size='10' font='tt2020base_vn_bold' color='#FF0000'> %1</t>",
        _roundNum
    ];
};


/* params ["_roundNum"];
//Font size 1 ≈ box height 0.05
//Font size 2 ≈ box height 0.1
private _ctrl = uiNamespace getVariable ["BAC_RoundHUD_ctrl", controlNull];
if (!isNull _ctrl) then {
    _ctrl ctrlSetStructuredText parseText format [
        "<t size='6' color='#FF0000'> %1</t>",
        _roundNum
    ];
}; */
