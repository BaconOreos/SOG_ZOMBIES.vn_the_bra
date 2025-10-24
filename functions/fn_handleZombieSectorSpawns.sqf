/*
    fn_handleZombieSectorSpawns.sqf
    Teleports a zombie to a random unlocked spawn.

    Params:
        0: OBJECT - zombie unit
*/

params ["_unit"];

// Retrieve available spawns
private _availableSpawns = missionNamespace getVariable ["BAC_availableSpawns", []];
if (_availableSpawns isEqualTo []) exitWith {
    diag_log "⚠️ No available spawns! Zombie not teleported.";
};

// Retrieve the last used spawns (stored as an array)
private _lastSpawns = missionNamespace getVariable ["BAC_lastZombieSpawns", []];

// --- Determine how many recent spawns to avoid based on availability ---
private _avoidCount = switch (count _availableSpawns) do {
    case 0;
    case 1: {0};
    case 2: {1};
    case 3: {2};
    default {3};
};

// Get the list of spawns to avoid (latest entries)
private _spawnsToAvoid = _lastSpawns select [0, _avoidCount];

// --- Pick a spawn that isn’t in the recent history ---
private _chosenMarker = selectRandom _availableSpawns;
private _tries = 0;

while {(_chosenMarker in _spawnsToAvoid) && {_tries < 20}} do {
    _chosenMarker = selectRandom _availableSpawns;
    _tries = _tries + 1;
};

// --- Update the history ---
private _newHistory = [_chosenMarker] + _lastSpawns;  // prepend newest
_newHistory resize 3;  // keep only the last 3
missionNamespace setVariable ["BAC_lastZombieSpawns", _newHistory, true];

// --- Teleport zombie ---
_unit setPos (getMarkerPos _chosenMarker);

// --- Debug info ---
diag_log format [
    "[DEBUG] Zombie teleported to %1 | Avoided: %2 | History: %3 | Available: %4",
    _chosenMarker, _spawnsToAvoid, _newHistory, _availableSpawns
];



/*
    fn_handleZombieSectorSpawns.sqf
    Teleports a zombie to a random unlocked spawn.
    
    Params:
        0: OBJECT - zombie unit
*/

// Define the debug message
//private _message = "[DEBUG] handleZombieSectorSpawns called.";
// Use remoteExec to send the message to all clients
//[_message] remoteExec ["systemChat", 0];

/* params ["_unit"];

//_unit setPos (getMarkerPos (selectRandom BAC_randomTeleports));

private _availableSpawns = missionNamespace getVariable ["BAC_availableSpawns", []];

// Fallback if no zones unlocked
if (_availableSpawns isEqualTo []) exitWith {
    diag_log "⚠️ No available spawns! Zombie not teleported.";
};

// Pick a random spawn marker
private _chosenMarker = selectRandom _availableSpawns;
diag_log ["[DEBUG] handleZombieSectorSpawns called. Available spawns: %1", _availableSpawns];
//systemChat format ["[DEBUG] handleZombieSectorSpawns called. Available spawns: %1", _availableSpawns];
_unit setPos (getMarkerPos _chosenMarker);
 */