//directionalDash.sqf


//directionalAssist_animBoost.sqf
// Short burst of movement by boosting animation speed instead of velocity
// Restores the player's original animSpeedCoef after boost

if (!isNil "BAC_dash_EH") then {
    removeMissionEventHandler ["EachFrame", BAC_dash_EH];
};

player setVariable ["BAC_canBoost", true];

BAC_dash_EH = addMissionEventHandler ["EachFrame", {
    private _u = player;
    if (!alive _u) exitWith {};

    if !(_u getVariable ["BAC_canBoost", true]) exitWith {};

    // Movement inputs
    private _fwd   = inputAction "MoveForward";
    private _back  = inputAction "MoveBack";
    private _left  = inputAction "TurnLeft";
    private _right = inputAction "TurnRight";

    // Only trigger if key pressed AND player is basically standing still
    private _speed = vectorMagnitude (velocity _u);
    if (_speed < 0.5 && ((_fwd > 0.1) || (_back > 0.1) || (_left > 0.1) || (_right > 0.1))) then {
        _u setVariable ["BAC_canBoost", false];

        [_u] spawn {
            params ["_unit"];

            private _boostCoef = 6;     // multiplier during boost
            private _dur       = 0.15;  // boost duration
            private _cd        = 0.2;   // cooldown

            // Save current coef
            private _origCoef = getAnimSpeedCoef _unit;

            // Apply burst
            _unit setAnimSpeedCoef _boostCoef;
            sleep _dur;

            // Restore original coef
            _unit setAnimSpeedCoef _origCoef;

            // Restore cooldown
            sleep _cd;
            _unit setVariable ["BAC_canBoost", true];
        };
    };
}];




//ANIMSPEED
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//VELOCITY


/* 
// Applies a short velocity assist ONLY when going from stopped to moving
// Temporarily prevents damage during dash to avoid micro-impacts

if (!isNil "BAC_dash_EH") then {
    removeMissionEventHandler ["EachFrame", BAC_dash_EH];
};

player setVariable ["BAC_canBoost", true];

BAC_dash_EH = addMissionEventHandler ["EachFrame", {
    private _u = player;
    if (!alive _u) exitWith {};

    if !(_u getVariable ["BAC_canBoost", true]) exitWith {};

    // Movement inputs
    private _fwd   = inputAction "MoveForward";
    private _back  = inputAction "MoveBack";
    private _left  = inputAction "TurnLeft";
    private _right = inputAction "TurnRight";

    // Only trigger if key pressed AND player is basically standing still
    private _speed = vectorMagnitude (velocity _u);
    if (_speed < 0.5 && ((_fwd > 0.1) || (_back > 0.1) || (_left > 0.1) || (_right > 0.1))) then {
        _u setVariable ["BAC_canBoost", false];

        private _dir = getDir _u;
        private _vec = [0,0,0];

        if (_fwd > 0.1)  then {_vec = _vec vectorAdd [sin _dir,  cos _dir, 0];};
        if (_back > 0.1) then {_vec = _vec vectorAdd [-(sin _dir), -(cos _dir), 0];};
        if (_left > 0.1) then {_vec = _vec vectorAdd [-(cos _dir),  (sin _dir), 0];};
        if (_right > 0.1)then {_vec = _vec vectorAdd [ (cos _dir), -(sin _dir), 0];};

        private _mag = vectorMagnitude _vec;
        if (_mag > 0) then {_vec = _vec vectorMultiply (1 / _mag);};

        [_u, _vec] spawn {
            params ["_unit","_vec"];

            private _spd = 6;     // boost strength
            private _dur = 0.04;  // duration (seconds)
            private _cd  = 0.1;   // cooldown

            // Save initial damage
            private _initialDmg = damage _unit;

            // Start micro-immunity
            [_unit, _initialDmg, _dur] spawn {
                params ["_u","_safeDmg","_time"];
                private _end = time + _time;
                while {time < _end && alive _u} do {
                    if (damage _u > _safeDmg) then {
                        _u setDamage _safeDmg;
                    };
                    sleep 0.01;
                };
            };

            // Apply dash
            private _end = time + _dur;
            while {time < _end && alive _unit} do {
                private _vel = velocity _unit;
                _unit setVelocity [
                    (_vel select 0) + (_vec select 0) * _spd,
                    (_vel select 1) + (_vec select 1) * _spd,
                    (_vel select 2) + 0.05   // micro-lift to prevent stumble
                ];
                sleep 0.01;
            };

            sleep _cd;
            _unit setVariable ["BAC_canBoost", true];
        };
    };
}]; */
