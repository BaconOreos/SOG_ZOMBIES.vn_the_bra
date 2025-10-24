/*
    fn_ZombieSectorUnlock.sqf
    Called when a zone is unlocked.

    Params:
        0: STRING - zone name (e.g. "zone1")
        1: ARRAY  - marker names for teleport points in that zone

    Example:
        ["zone1", ["teleport_1","teleport_2"]] call BAC_fnc_ZombieSectorUnlock;
*/

params ["_zoneName", "_markerArray"];

// Safety: ensure _markerArray is an array
if !(typeName _markerArray isEqualTo "ARRAY") then {
    _markerArray = [_markerArray];
};

// Save marker array for this zone
missionNamespace setVariable [format ["BAC_zoneMarkers_%1", _zoneName], _markerArray];

// Add zone to unlocked list if not already there
private _unlocked = missionNamespace getVariable ["BAC_unlockedZones", []];
_unlocked pushBackUnique _zoneName;
missionNamespace setVariable ["BAC_unlockedZones", _unlocked];
publicVariable "BAC_unlockedZones";

// Notify indexer to rebuild available spawns
[] call BAC_fnc_ZombieSectorSpawnsIndex;

// Debug logging
private _totalSpawns = count (missionNamespace getVariable ["BAC_availableSpawns", []]);
diag_log format [
    "✅ Zone %1 unlocked! Added %2 new spawns. Total available: %3",
    _zoneName, count _markerArray, _totalSpawns
];
