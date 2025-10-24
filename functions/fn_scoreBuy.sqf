/*
    functions\fn_scoreBuy.sqf
    [_cost] call BAC_fnc_scoreBuy;

    Subtracts cost from player's score if they can afford it.
    Returns true if purchase succeeded, false if not.
*/

params ["_cost"];

// Get current score
private _score = player getVariable ["BAC_score", 0];

// Check if player can afford
if (_score >= _cost) then {
    _score = _score - _cost;
    player setVariable ["BAC_score", _score, true];

    // Update HUD
    [_score] call BAC_fnc_updateScoreHUD;

    //hint format ["Purchase successful! -%1 points", _cost];
    true
} else {
    //hint "Not enough points!";
    false
};
