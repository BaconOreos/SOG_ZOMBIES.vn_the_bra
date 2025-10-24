/*
    fn_ZombieSectorSpawnsIndex.sqf
    Updates the master list of available zombie spawns
*/

private _allUnlocked = missionNamespace getVariable ["BAC_unlockedZones", []];
private _allSpawns = [];

{
    private _zoneMarkers = missionNamespace getVariable [format ["BAC_zoneMarkers_%1", _x], []];
    { _allSpawns pushBack _x } forEach _zoneMarkers;
} forEach _allUnlocked;

// Save master list
missionNamespace setVariable ["BAC_availableSpawns", _allSpawns];
publicVariable "BAC_availableSpawns";

// Debug info
diag_log format [
    "📌 Available zombie spawns updated: %1 total | Type: %2 | Content: %3",
    count _allSpawns,
    typeName _allSpawns,
    _allSpawns
];
