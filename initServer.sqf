//initServer.sqf
//systemChat ">>> initServer.sqf START";
diag_log ">>> initServer.sqf START";

publicVariable "screenMonitor";

/* // Initialize global spawn marker list (server only)
if (isServer) then {
    if (isNil "BAC_zombieSpawnMarkers") then {
        BAC_zombieSpawnMarkers = ["zomb_spawn_1"]; // initial/default spawner marker(s)
        publicVariable "BAC_zombieSpawnMarkers";
    };
}; */


BAC_zombRoundCount = 1; 
publicVariable "BAC_zombRoundCount";



/*
    Initializes starting zombie sector and spawn system
*/
// Starter zone spawn markers
private _initSpawnPoints = ["teleport_1"];
// Unlock starter zone (use call, not execVM)
["zone1", _initSpawnPoints] call BAC_fnc_ZombieSectorUnlock;


[] spawn {
	uiSleep 6;
	[] execVM "scripts\roundSystem.sqf";
    [] execVM "scripts\zombieRelocator.sqf"; //teleports zombies too far from players
    // Start stock market simulation
    [] execVM "scripts\stockMarketServer.sqf";
	};


//checks if all players are dead or downed to end the scenario
[] spawn {
    private _gameEnded = false;

    while {!_gameEnded} do {
        [] call BAC_fnc_checkPlayersAlive;

        // If the game has ended, set the flag and break
        if (missionNamespace getVariable ["BAC_gameOver", false]) then {
            _gameEnded = true;
        };
        sleep 2;
    };
};

//adds 50 points to all players for uncredited kills
addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer", "_instigator"];

    // Only care about Opfor AI
    if (side _unit isEqualTo east && { _unit isKindOf "Man" }) then {
        
        // Case 1: A player killed it → handled elsewhere
        if (!isNull _instigator && isPlayer _instigator) exitWith {};

        // Case 2: Died from environment, mines, vehicles, etc.
        {
            private _score = _x getVariable ["BAC_playerScore", 0];
            _score = _score + 50;
            _x setVariable ["BAC_playerScore", _score, true];
            [_score] remoteExec ["BAC_fnc_updateScoreHUD", -2];
        } forEach allPlayers;
    };
}];

// initServer.sqf
// One-Shot Kill Script (players only, with debug output)
// List of one-shot weapons
private _oneShotWeapons = [
    "vn_vz54","vn_m9130","vn_m4956","vn_m40a1","vn_m38",
    "vn_m36","vn_m1903","vn_m1891","vn_k98k","vnx_no4_sniper"
];
//,"vn_svd","vn_sks","vn_m1_garand"
missionNamespace setVariable ["ARMA_oneShotWeapons", _oneShotWeapons, true];

// Define function in missionNamespace (so all code can access it)
missionNamespace setVariable ["ARMA_fnc_installEH", {
    params ["_unit"];

    if (_unit getVariable ["ARMA_oneShotEH_Installed", false]) exitWith {};

    _unit addEventHandler ["HandleDamage", {
    params ["_unit","_selection","_damage","_source","_projectile","_instigator"];

    private _weapList = missionNamespace getVariable ["ARMA_oneShotWeapons", []];

    // Safely resolve shooter
    private _shooter = objNull;
    if (_instigator isEqualType objNull) then { _shooter = _instigator };
    if (isNull _shooter && {_source isEqualType objNull}) then { _shooter = _source };

    if (!isNull _shooter && isPlayer _shooter && alive _shooter) then {
        private _w = currentWeapon _shooter;

        if (_w in _weapList) then {
            // Debug output
            /* diag_log format [
                "[OneShot] %1 killed %2 with %3 (instant kill applied).",
                name _shooter, name _unit, _w
            ];
            systemChat format [
                "[OneShot] %1 killed %2 with %3 (instant kill applied).",
                name _shooter, name _unit, _w
            ]; */

            1 // Force fatal damage
        } else {
            _damage
        };
    } else {
        _damage
    };
}];

    _unit setVariable ["ARMA_oneShotEH_Installed", true, true];
}];

// Apply to all current units
{
    [_x] call (missionNamespace getVariable "ARMA_fnc_installEH");
} forEach allUnits;

// Apply to future units via loop
[] spawn {
    while {true} do {
        {
            if (!(_x getVariable ["ARMA_oneShotEH_Installed", false])) then {
                [_x] call (missionNamespace getVariable "ARMA_fnc_installEH");
            };
        } forEach allUnits;
        sleep 3;
    };
};