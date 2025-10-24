/*
    slideScript.sqf
    Local slide mechanic triggered by crouch input while sprinting.
    Supports extended slide duration.
*/

// =======================
// CONFIGURABLE SETTINGS
// =======================
_slideVelocity = 8;   // Forward push strength
_slideDuration = 3;   // Slide time in seconds
// =======================

addMissionEventHandler ["EachFrame", {
    private _unit = player;

    if (!alive _unit) exitWith {};

    private _sprint   = inputAction "turbo" > 0;   // Sprint key
    private _crouch   = inputAction "Crouch" > 0;  // Crouch key
    private _stance   = stance _unit;

    // --- Midair slide prep ---
    if (_crouch && _sprint && {_stance == "STAND" && !isTouchingGround _unit}) then {
        [] spawn {
            private _u = player;
            waitUntil {sleep 0.01; isTouchingGround _u || !alive _u};
            if (alive _u && stance _u == "CROUCH") then {
                private _dir = getDir _u;
                private _time = time + _slideDuration; // SLIDE DURATION
                while {time < _time && alive _u} do {
                    _u setVelocity [
                        (sin _dir) * _slideVelocity, // SLIDE VELOCITY X
                        (cos _dir) * _slideVelocity, // SLIDE VELOCITY Y
                        (velocity _u select 2)
                    ];
                    sleep 0.05;
                };
            };
        };
    };

    // --- Ground slide ---
    if (_crouch && _sprint && {_stance == "STAND" && isTouchingGround _unit}) then {
        [] spawn {
            private _u = player;
            private _dir = getDir _u;
            private _time = time + _slideDuration; // SLIDE DURATION
            while {time < _time && alive _u} do {
                _u setVelocity [
                    (sin _dir) * _slideVelocity, // SLIDE VELOCITY X
                    (cos _dir) * _slideVelocity, // SLIDE VELOCITY Y
                    (velocity _u select 2)
                ];
                sleep 0.05;
            };
        };
    };
}];
