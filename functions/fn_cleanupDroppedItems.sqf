/*
    Function: BAC_fnc_cleanupDroppedItems
    -------------------------------------
    Deletes all dropped ground items (weapons, magazines, items, etc.) from the world.

    Safe for dedicated servers and multiplayer missions.

    Usage:
        [] call BAC_fnc_cleanupDroppedItems;

    Returns:
        Number of deleted objects
*/

if (!isServer) exitWith {0}; // Only the server performs cleanup

private _deleted = 0;
private _targets = [];

// Collect relevant dropped object types
{
    _targets append (allMissionObjects _x);
} forEach [
    "WeaponHolderSimulated",
    "GroundWeaponHolder",
    "WeaponHolder",
    "WeaponHolderCargo"
];

// Filter & delete
{
    if (!isNull _x && {isNull attachedTo _x}) then {
        deleteVehicle _x;
        _deleted = _deleted + 1;
    };
} forEach _targets;

// Log and optional feedback
diag_log format ["[BAC CLEANUP] Deleted %1 dropped items at %2", _deleted, time];

// Optional: show a message to all players (uncomment if wanted)
// ["Cleanup Complete", format ["Deleted %1 dropped items.", _deleted]] remoteExec ["hint", 0];

_deleted
