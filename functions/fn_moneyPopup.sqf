/*
    [amount] call BAC_fnc_moneyPopup;
    New popup always spawns at top.
    Older popups slide downward when a new one is created.
    Max 5 active at once.
*/

params ["_amount"];

private _disp = findDisplay 46;
if (isNull _disp) exitWith {};

private _popups = uiNamespace getVariable ["BAC_activePopups", []];

// === Limit active popups to 5 ===
if ((count _popups) >= 5) exitWith {};

private _idc = 2222 + round (random 1000);  // unique IDC in safe range
private _ctrl = _disp ctrlCreate ["RscStructuredText", _idc];

// Base position (right of crosshair)
private _baseX = safezoneX + safezoneW / 2 + 0.03;
private _baseY = safezoneY + safezoneH / 2 - 0.03;

// Start at base (newest popup always here)
_ctrl ctrlSetPosition [_baseX, _baseY, 0.2, 0.05];
_ctrl ctrlCommit 0;

// Text (light grey)
private _sign = if (_amount >= 0) then {"+"} else {""};
_ctrl ctrlSetStructuredText parseText format [
    "<t align='left' size='1.2' color='#cccccc'>%1%2</t>",
    _sign, _amount
];

// Add new popup to list
_popups pushBack _ctrl;
uiNamespace setVariable ["BAC_activePopups", _popups];

// === Move only older popups down ===
{
    private _i = _forEachIndex + 1;   // start offset at 1 (skip newest)
    private _c = _x;
    if (_c isEqualTo _ctrl) exitWith {}; // skip newest popup
    private _offset = _i * 0.04;      // vertical spacing
    _c ctrlSetPosition [_baseX, _baseY + _offset, 0.2, 0.05];
    _c ctrlCommit 0.2;
} forEach _popups;

// === Animate fade out for the new popup ===
_ctrl ctrlSetFade 0;
_ctrl ctrlCommit 0;
_ctrl ctrlSetFade 1;
_ctrl ctrlCommit 1.5;

// Cleanup after fade
[_ctrl] spawn {
    params ["_ctrl"];
    sleep 1.6;
    ctrlDelete _ctrl;

    private _popups = uiNamespace getVariable ["BAC_activePopups", []];
    _popups deleteAt (_popups find _ctrl);
    uiNamespace setVariable ["BAC_activePopups", _popups];
};
