/*
    zombieRelocator.sqf
    Server-side script that periodically checks OPFOR units.
    If a zombie is farther than 100m from any player, teleport it
    to a valid spawn point using BAC_fnc_handleZombieSectorSpawns.

    Runs indefinitely during the mission.
*/
//systemChat "zombierelocator launched";
/*
    zombieRelocator.sqf
    Server-side loop to recycle stray zombies.
*/

while {true} do {
    sleep 10;  // check every 10 seconds

    private _zombies = allUnits select { side _x isEqualTo east && alive _x };

    //systemChat format ["[Relocator] Checking %1 zombies...", count _zombies];

    {
        private _unit = _x;

        // Find distance to nearest player
        private _nearestDist = 99999;
        {
            if (isPlayer _x && alive _x) then {
                private _dist = _unit distance _x;
                if (_dist < _nearestDist) then {
                    _nearestDist = _dist;
                };
            };
        } forEach allPlayers;

        // If no players in mission, skip
        if (_nearestDist isEqualTo 99999) exitWith {};

        // Debug each zombie
        //systemChat format ["[Relocator] %1 is %2m from nearest player", _unit, round _nearestDist];

        // If too far, relocate
        if (_nearestDist > 50) then {
            [_unit] call BAC_fnc_handleZombieSectorSpawns;
            //systemChat format ["[Relocator] Teleported %1 (was %2m away)", _unit, round _nearestDist];
        };

    } forEach _zombies;
};

