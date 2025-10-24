/*
    Function: TAG_fnc_clearMessage

    Deletes any active message prompt(s) created by TAG_fnc_showMessage.
    Looks for the fixed IDC (12345) and removes it if present.
*/

disableSerialization;

private _ctrl = uiNamespace getVariable ["myMessageCtrl", controlNull];
if !(isNull _ctrl) then {
    ctrlDelete _ctrl;
};

uiNamespace setVariable ["myMessageCtrl", controlNull];
