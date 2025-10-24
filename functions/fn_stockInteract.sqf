/*
    fn_stockInteract.sqf
    Player interaction with stock market
    Tap = Buy 1 share at current price
    Hold = Sell all owned shares at current price
*/

params ["_actionType"];  // "buy" or "sell"

// How many shares this player owns
private _shares = player getVariable ["BAC_stockShares", 0];

// Base cost per share
private _baseCost = 500;

// Current market percentage (from server)
private _change = missionNamespace getVariable ["BAC_stockChange", 0];

// Current share price
private _sharePrice = _baseCost * (1 + (_change / 100));
_sharePrice = _sharePrice max 1;  // avoid zero/negative
_sharePrice = round _sharePrice;

// === BUY ===
if (_actionType isEqualTo "buy") then {
    if ([_sharePrice] call BAC_fnc_scoreBuy) then {
        _shares = _shares + 1;  // bought one share
        player setVariable ["BAC_stockShares", _shares, true];
        //systemChat format ["Bought 1 share @ %1 pts. Total shares: %2", _sharePrice, _shares];
    } else {
        //systemChat "Not enough points to buy a share!";
    };
};

// === SELL ===
if (_actionType isEqualTo "sell") then {
    if (_shares > 0) then {
        private _payout = _shares * _sharePrice;
        player setVariable ["BAC_stockShares", 0, true];

        // Add payout to player's score
        private _score = player getVariable ["BAC_score", 0];
        _score = _score + _payout;
        player setVariable ["BAC_score", _score, true];

        // Update HUD + popup
        [_score] call BAC_fnc_updateScoreHUD;
        [_payout] call BAC_fnc_moneyPopup;

        //systemChat format ["Sold %1 shares @ %2 each → %3 pts", _shares, _sharePrice, _payout];
    } else {
        //systemChat "You have no shares to sell!";
    };
};
