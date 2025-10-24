/*
    File: fn_gameOverSequence.sqf
    Runs when all players are dead / none exist.
*/

if (!isServer) exitWith {};   // run only on server

// cache the round count (server always knows it)
private _lastRound = missionNamespace getVariable ["BAC_zombRoundCount", 0];

// broadcast the cinematic sequence to every client
[_lastRound] remoteExec ["BAC_fnc_gameOverClient", 0, true];
diag_log "GameOverSequence calls fn_gameOverClient"
