/*
    fn_checkPlayersAlive.sqf
    Runs on server to see if the game should end.
*/

if (!isServer) exitWith {};

private _activePlayers = allPlayers select {
    alive _x && !(_x getVariable ["BAC_isDowned", false])
};

if (_activePlayers isEqualTo []) then {
    if !(missionNamespace getVariable ["BAC_gameOver", false]) then {
        missionNamespace setVariable ["BAC_gameOver", true, true];
        [] call BAC_fnc_gameOverSequence;
        diag_log "#################  GAME ENDED  #################";
    };
};




/* if (!isServer) exitWith { diag_log "Not server, exiting checkPlayersAlive"; };

diag_log "Running checkPlayersAlive";

// Collect all living players
private _alivePlayers = allPlayers select { alive _x };
diag_log format ["Alive players: %1", _alivePlayers];

// If none alive → game over
if (_alivePlayers isEqualTo []) then {
    diag_log "No alive players, triggering game over";
    [] spawn BAC_fnc_gameOverSequence;
}; */

