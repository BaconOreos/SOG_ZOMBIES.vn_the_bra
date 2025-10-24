/*
    stockMarketServer.sqf
    Server-side stock market simulator
    Updates percentage every 6s
*/

while {true} do {
    private _change = round (random 100 - 50);  // -50% to +50%

    // Broadcast the new percentage
    missionNamespace setVariable ["BAC_stockChange", _change, true];

    // Debug
    diag_log format ["[STOCK SIM] New market change: %1%%", _change];
    //[format ["Stock market updated: %1%%", _change]] remoteExec ["systemChat", 0];

    sleep 6;
};
