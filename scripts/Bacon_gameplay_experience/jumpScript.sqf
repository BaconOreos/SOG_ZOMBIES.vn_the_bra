/*
    jumpScript.sqf
    Local, physics-only jump on User12 (no hold).
    Dolphin dive added: sprint + prone key = forward dive into prone.
*/

player setVariable ["canJump", true];
player setVariable ["canDive", true];

// ---------------------
// Normal Jump (User12)
// ---------------------
addUserActionEventHandler ["User12", "Activate", {
    params ["_activated"];

    if (_activated) then {
        private _unit = player;

        if (_unit getVariable ["canJump", true]) then {
            _unit setVariable ["canJump", false];

            private _vel = velocity _unit;

            // vertical boost
            _unit setVelocity [
                _vel select 0,
                _vel select 1,
                (_vel select 2) + 4.5
            ];

            // forward push after landing
            [_unit] spawn {
                params ["_u"];
                waitUntil {sleep 0.01; isTouchingGround _u || !alive _u};
                if (alive _u) then {
                    private _dir = getDir _u;
                    private _vel = velocity _u;
                    _u setVelocity [
                        (sin _dir) * 6,
                        (cos _dir) * 6,
                        _vel select 2
                    ];
                };
            };

            // cooldown
            [_unit] spawn {
                params ["_u"];
                sleep 0.8;
                _u setVariable ["canJump", true];
            };
        };
    };
}];
//https://community.bistudio.com/wiki/inputAction/actions
// ---------------------
// Dolphin Dive
// ---------------------
[] spawn {
    while {true} do {
        sleep 0.01;

        private _unit = player;
        if (!alive _unit) exitWith {};

        private _prone1 = inputAction "Prone" > 0;
        private _prone2 = inputAction "MoveDown" > 0;
        private _sprint = inputAction "turbo" > 0;

        if (_sprint && (_prone1 || _prone2)) then {
            if (_unit getVariable ["canDive", true]) then {
                _unit setVariable ["canDive", false];

                // Launch forward/upward
                private _dir = getDir _unit;
                _unit setVelocity [
                    (sin _dir) * 10,   // forward push
                    (cos _dir) * 10,
                    4.5                 // upward boost
                ];

                // Pick dive animation
                private _weapon = currentWeapon _unit;
                if (_weapon isKindOf ["Pistol", configFile >> "CfgWeapons"]) then {
                    _unit switchMove "AmovPpneMstpSrasWpstDnon"; // pistol dive
                } else {
                    _unit switchMove "AmovPpneMstpSrasWrflDnon"; // rifle dive
                };

                // Lock until they hit ground
                [_unit] spawn {
                    params ["_u"];
                    waitUntil {sleep 0.01; isTouchingGround _u || !alive _u};
                    if (alive _u) then {
                        private _weapon = currentWeapon _u;
                        if (_weapon isKindOf ["Pistol", configFile >> "CfgWeapons"]) then {
                            _u playMove "AmovPpneMstpSrasWpstDnon"; // prone idle, pistol
                        } else {
                            _u playMove "AmovPpneMstpSrasWrflDnon"; // prone idle, rifle
                        };
                    };
                    sleep 2; // cooldown
                    _u setVariable ["canDive", true];
                };
            };
        };
    };
};
