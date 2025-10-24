/*
    fn_reviveAll.sqf
    Revives all currently downed players in the mission.

    Usage:
        [] call BAC_fnc_reviveAll;
*/

if (!isServer) exitWith {};  // only server should run this

{
    [_x] remoteExec ["BAC_fnc_revivePlayer", 2];
} forEach (allPlayers select { _x getVariable ["BAC_isDowned", false] });
