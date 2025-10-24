// ===========================
// Round System Script (Server-Side)
// ===========================
// Call with: execVM "scripts\roundSystem.sqf"; on initServer.sqf

private _round = BAC_zombRoundCount;  
private _enemyArray = [];  
private _enemyCap = 50;  
private _baseEnemies = 10;  
private _increment = 2;  
private _spawnDelay = 1; // time between spawns

// ================================
// DIFFICULTY LEVELS
// ================================
private _hordelevel1 = [2];
private _hordelevel2 = [2,2,2,2,2,3];
private _hordelevel3 = [2,2,2,3];
private _hordelevel4 = [2,2,3];
private _hordelevel5 = [2,2,3,3,4,5];
private _hordelevel6 = [3,4,5];

// ================================
// UNIT POOL
// ================================
private _unitPool = [
    "vn_o_men_nva_43","vn_o_men_nva_14","vn_o_men_nva_32","vn_o_men_nva_37","vn_o_men_nva_38",
    "vn_o_men_nva_07","vn_o_men_nva_11","vn_o_men_nva_10","vn_o_men_nva_08","vn_o_men_nva_12",
    "vn_o_men_nva_09","vn_o_men_nva_13","vn_o_men_vc_local_14","vn_o_men_vc_local_07","vn_o_men_vc_local_11",
    "vn_o_men_vc_local_10","vn_o_men_vc_local_08","vn_o_men_vc_local_15","vn_o_men_vc_local_18","vn_o_men_vc_local_25",
    "vn_o_men_nva_marine_08","vn_o_men_nva_marine_08","vn_o_men_nva_marine_09","vn_o_men_nva_marine_02","vn_o_men_nva_marine_10"
];

while {true} do {

    // ================================
    // START OF A NEW ROUND
    // ================================
    BAC_zombRoundCount = _round;
    publicVariable "BAC_zombRoundCount";

    // Show HUD + announcement
    [_round] remoteExecCall ["BAC_fnc_updateRoundHUD", 0];
    [format["<t color='#FF0000' font='tt2020base_vn_bold' size='5'>Round %1</t>", _round]] remoteExec ["BIS_fnc_dynamicText", 0];

    private _waveSpawnPos = getPos waveSpawner;

    // === Calculate enemy count (scales with players) ===
    private _playerCount = count allPlayers;
    private _enemyCount = _baseEnemies;

    if (_round > 2) then {
        _enemyCount = _baseEnemies + ((_round - 2) * _increment) + (2 * _playerCount);
    };
    if (_enemyCount > _enemyCap) then { _enemyCount = _enemyCap; };

    // ================================
    // SPAWN ENEMIES
    // ================================
    _enemyArray = [];
    private _grp = createGroup east;

    // === LEADER (spawns first in main group) ===
    private _spawnOffsetL = [
        (random 10) - 5,
        (random 10) - 5,
        0
    ];
    private _spawnPosL = _waveSpawnPos vectorAdd _spawnOffsetL;

    private _leader = _grp createUnit ["vn_o_men_nva_01", _spawnPosL, [], 5, "FORM"];
    wave_leader = _leader;
    publicVariable "wave_leader";
    _enemyArray pushBack _leader;

    // Random difficulty per leader
    private _randomDifficultyL = switch (true) do {
        case (_round < 2): { selectRandom _hordelevel1 };
        case (_round < 3): { selectRandom _hordelevel2 };
        case (_round < 5): { selectRandom _hordelevel3 };
        case (_round < 10): { selectRandom _hordelevel4 };
        case (_round < 25): { selectRandom _hordelevel5 };
        default { selectRandom _hordelevel6 };
    };

    // Apply leader logic
    [_leader, 10000] execVM "scripts\taskRushScripts\fn_taskRush.sqf";
    [_leader, _randomDifficultyL] call WBK_LoadAIThroughEden;
    _leader allowDamage true;
    [_leader] call BAC_fnc_handleZombieSectorSpawns;
    removeAllMagazines _leader;
    _leader lockInventory true;

    // ================================
    // REST OF THE UNITS (spawn trickle)
    // ================================
    for "_i" from 2 to _enemyCount do {
        private _randomUnitSelector = selectRandom _unitPool;

        // random offset around the wave spawner
        private _spawnOffset = [
            (random 10) - 5,
            (random 10) - 5,
            0
        ];
        private _spawnPos = _waveSpawnPos vectorAdd _spawnOffset;

        // single-unit groups for immediate activation
        private _grpUnit = createGroup east;
        private _unit = _grpUnit createUnit [_randomUnitSelector, _spawnPos, [], 5, "FORM"];
        _enemyArray pushBack _unit;

        // Random difficulty per unit
        private _randomDifficulty = switch (true) do {
            case (_round < 2): { selectRandom _hordelevel1 };
            case (_round < 3): { selectRandom _hordelevel2 };
            case (_round < 5): { selectRandom _hordelevel3 };
            case (_round < 10): { selectRandom _hordelevel4 };
            case (_round < 25): { selectRandom _hordelevel5 };
            default { selectRandom _hordelevel6 };
        };

        // Apply per-unit functions
        [_unit, 10000] execVM "scripts\taskRushScripts\fn_taskRush.sqf";
        [_unit, _randomDifficulty] call WBK_LoadAIThroughEden;
        _unit allowDamage true;
        removeAllMagazines _unit;
        _unit lockInventory true;

        // Small delay to prevent simultaneous teleports
        sleep (random 0.3);

        [_unit] call BAC_fnc_handleZombieSectorSpawns;

        // Trickled spawn delay (between units)
        sleep _spawnDelay;
    };

    // ================================
    // END OF THE ROUND (wait for all dead)
    // ================================
    waitUntil {
        sleep 1;
        ({alive _x} count _enemyArray) isEqualTo 0
    };
    if (isServer) then {
    { deleteGroup _x } forEach allGroups select { count units _x == 0 };
    };

    [] call BAC_fnc_cleanupDroppedItems;
    [] remoteExec ["BAC_fnc_roundEndSting", 0];
    [] call BAC_fnc_reviveAll;

    _round = _round + 1;
    sleep 5;
};
