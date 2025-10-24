/*
    fn_updateStockDisplay.sqf
    Client-side stock market display
    Shows % change and current price per share
*/

if (!isNil {missionNamespace getVariable "BAC_drawStockEH"}) then {
    removeMissionEventHandler ["Draw3D", missionNamespace getVariable "BAC_drawStockEH"];
};

private _ehID = addMissionEventHandler ["Draw3D", {
    private _screen = missionNamespace getVariable ["screenMonitor", objNull];
    if (isNull _screen) exitWith {};

    private _pos = ASLToAGL getPosASL _screen;
    _pos set [2, (_pos select 2) + 1.2];

    private _percent = missionNamespace getVariable ["BAC_stockChange", 0];
    private _dist = player distance _screen;

    // Fade out with distance (0m → alpha 1, 10m → alpha 0)
    private _alpha = 1 - (_dist / 10);
    _alpha = _alpha max 0;
    _alpha = _alpha min 1;
    if (_alpha <= 0) exitWith {};

    // % color (green for +, red for -)
    private _colorPercent = if (_percent >= 0) then {[0,1,0,_alpha]} else {[1,0,0,_alpha]};

    // Grey for share cost (#cccccc)
    private _colorCost = [0.8, 0.8, 0.8, _alpha];

    // Compute current share price
    private _baseCost = 500;
    private _sharePrice = _baseCost * (1 + (_percent / 100));
    _sharePrice = _sharePrice max 1;
    _sharePrice = round _sharePrice;

    // Draw percentage text
    drawIcon3D [
        "",
        _colorPercent,
        _pos,
        0, 0, 0,
        format ["Stock: %1%2%%", if (_percent > 0) then {"+"} else {""}, _percent],
        2,
        0.05,
        "tt2020base_vn_bold",
        "center"
    ];

    // Draw current price text slightly below
    private _posCost = +_pos;
    _posCost set [2, (_posCost select 2) - 0.15];
    drawIcon3D [
        "",
        _colorCost,
        _posCost,
        0, 0, 0,
        format ["Share price: %1", _sharePrice],
        1.5,
        0.04,
        "tt2020base_vn_bold",
        "center"
    ];
}];

missionNamespace setVariable ["BAC_drawStockEH", _ehID];
