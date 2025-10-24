/*
    scripts\stockInteractSetup.sqf
    Adds buy/sell keybinds for stock station
    - Press User10 → Buy
    - Hold User10 → Sell
*/

removeAllUserActionEventHandlers ["User10", "Activate"];
removeAllUserActionEventHandlers ["User10", "Hold"];

addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];
    if (_activated) then { ["buy"] call BAC_fnc_stockInteract; };
}];

addUserActionEventHandler ["User10", "Hold", {
    params ["_holding"];
    if (_holding) then { ["sell"] call BAC_fnc_stockInteract; };
}];
