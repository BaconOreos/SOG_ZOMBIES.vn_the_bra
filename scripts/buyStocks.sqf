/*
    buyStocks.sqf
    Client-side only. Trigger OnActivation calls this.
    Tap User10 = BUY
    Hold User10 (> _holdTime) = SELL
*/

if (!hasInterface) exitWith {};

// Key binding
private _user10Key = actionKeysImages "User10";
//systemChat format [">>> Stock station active! Press %1 to interact.", _user10Key];

// Add EH
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];
    if (!_activated) exitWith {};

    [] spawn {
        private _holdTime = 0.4;
        private _startTime = time;

        // wait until released OR hold threshold
        waitUntil {
            sleep 0.01;
            !(inputAction "User10" > 0) || (time - _startTime > _holdTime)
        };

        if (time - _startTime > _holdTime) then {
            // HOLD → sell
            ["sell"] call BAC_fnc_stockInteract;
            //systemChat "Stock: Sell action requested (hold).";
        } else {
            // TAP → buy
            ["buy"] call BAC_fnc_stockInteract;
            //systemChat "Stock: Buy action requested (tap).";
        };
    };
}];
