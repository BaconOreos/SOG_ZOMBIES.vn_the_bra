/*
    initDownedSystem.sqf
    Sets up the downed system for both client and server.
*/

// --- CLIENT SIDE (HandleDamage intercepts bullets, explosions, etc.)
if (hasInterface) then {
    player addEventHandler ["HandleDamage", {
        params ["_unit", "_selection", "_damage", "_source", "_projectile"];
        private _newDmg = damage _unit + _damage;

        if (_newDmg >= 0.4 && !(_unit getVariable ["BAC_isDowned", false])) then {
            [_unit] remoteExec ["BAC_fnc_setDowned", 2];  // run downed state on server
            _unit setDamage 0.4;                          // clamp to downed threshold
            0                                             // block lethal damage
        } else {
            // Clamp so engine never sees lethal values
            (_damage min (0.4 - (damage _unit)) max 0)
        };
    }];
};

// --- SERVER SIDE (HandleDamage for zombies/setDamage etc.)
if (isServer) then {
    addMissionEventHandler ["EntityCreated", {
        params ["_entity"];

        if (isPlayer _entity) then {
            _entity addEventHandler ["HandleDamage", {
                params ["_unit", "_selection", "_damage", "_source", "_projectile"];
                private _newDmg = damage _unit + _damage;

                if (_newDmg >= 0.4 && !(_unit getVariable ["BAC_isDowned", false])) then {
                    [_unit] remoteExec ["BAC_fnc_setDowned", 2];
                    _unit setDamage 0.4;
                    0
                } else {
                    (_damage min (0.4 - (damage _unit)) max 0)
                };
            }];
        };
    }];
};

/* // --- Failsafe (if somehow fully dead, recreate + down)
[] spawn {
    while {true} do {
        {
            if (!alive _x && isPlayer _x) then {
                private _name = vehicleVarName _x;
                private _side = side _x;
                private _pos  = getPosATL _x;
                private _dir  = getDir _x;
                private _type = typeOf _x;

                deleteVehicle _x;

                private _grp = createGroup [_side, true];
                private _newUnit = _grp createUnit [_type, _pos, [], 0, "NONE"];
                _newUnit setDir _dir;

                missionNamespace setVariable [_name, _newUnit, true];
                _newUnit setVehicleVarName _name;

                [_newUnit] remoteExec ["selectPlayer", _x];
                _newUnit setDamage 0.4;
                [_newUnit] remoteExec ["BAC_fnc_setDowned", 2];
            };
        } forEach allPlayers;

        sleep 1;
    };
}; */
