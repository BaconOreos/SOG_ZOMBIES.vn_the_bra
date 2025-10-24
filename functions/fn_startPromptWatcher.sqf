/*
    Function: BAC_fnc_startPromptWatcher
    Starts a local watcher that hides the prompt
    once the player leaves the trigger area.

    Args:
      0: POSITION (center of trigger)
      1: ARRAY - triggerArea [a, b, angle, isRect]
*/

params ["_pos","_area"];
_area params ["_a","_b","_angle","_rect"];

// Kill old watcher if still running
private _old = uiNamespace getVariable ["BAC_promptWatcher", scriptNull];
if (!isNull _old) then { terminate _old };

uiNamespace setVariable ["BAC_promptWatcher",
    [_pos,_a,_b,_angle,_rect] spawn {
        params ["_pos","_a","_b","_angle","_rect"];
        while { player inArea [_pos,_a,_b,_angle,_rect] && alive player } do {
            sleep 0.1;
        };
        ["","","",true] call BAC_fnc_showMessage;
    }
];
