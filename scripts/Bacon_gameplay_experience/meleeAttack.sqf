/*
    meleeKeybind.sqf
    Vanilla melee system bound to User13.
    Plays a gesture and kills the nearest enemy in front within 3m.
    Call with [] execVM "meleeKeybind.sqf"; from initPlayerLocal.sqf
    Each hit deals 0.3 damage and awards +10 points on hit.
    Kills are credited via EntityKilled EH for +100 points.
*/

_user13Key = actionKeysImages "User13";

// Add event handler for melee key
addUserActionEventHandler ["User13", "Activate", {
    params ["_activated"];

    if (!_activated) exitWith {};

    private _now = time;
    private _lastMelee = player getVariable ["BAC_lastMelee", 0];
    private _cooldown = 1.5; // seconds

    // Prevent spamming
    if ((_now - _lastMelee) < _cooldown) exitWith {
        //playSound "AddItemFailed"; // optional feedback
    };

    player setVariable ["BAC_lastMelee", _now];

    enableCamShake true;
    setCamShakeParams [0, 2, 2, 10, true];

    [] spawn {
        // Play melee gesture
        player playActionNow selectRandom [
            "vn_bayonet_buttstrike",
            "vn_bayonet_bayonetstrike",
            "vn_bayonet_knife_swing"
        ];

        addCamShake [0.65, 0.5, 15];
        playSound selectRandom ["melee", "melee_2", "melee_3"];
        sleep 0.1;

        private _range = 3;
        private _pos = getPosATL player;

        // Nearby men
        private _candidates = _pos nearEntities ["CAManBase", _range];

        // Filter enemies only
        private _enemies = _candidates select {
            alive _x && side _x != side player && {_x != player}
        };

        if (_enemies isEqualTo []) exitWith {};

        // Get the one most in front of the player
        private _dir = eyeDirection player;
        private _bestDot = 0.5;
        private _target = objNull;

        {
            private _to = getPosATL _x vectorDiff _pos;
            private _dist = vectorMagnitude _to;
            if (_dist > 0) then {
                private _toNorm = _to vectorMultiply (1 / _dist);
                private _dot = _dir vectorDotProduct _toNorm;
                if (_dot > _bestDot) then {
                    _bestDot = _dot;
                    _target = _x;
                };
            };
        } forEach _enemies;

        if (isNull _target) exitWith {};

        // Calculate new damage
        private _currentDamage = damage _target;
        private _newDamage = _currentDamage + 0.5;

        if (_newDamage >= 1) then {
            // Lethal hit
            _target setDamage 1;

            private _score = player getVariable ["BAC_score", 0];
            _score = _score + 100;
            player setVariable ["BAC_score", _score, true];
            [_score] call BAC_fnc_updateScoreHUD;
            [100] call BAC_fnc_moneyPopup;

            cutRsc ["Hitmarker_Kill", "PLAIN", 0.7, false, true];
        } else {
            // Non-lethal hit
            _target setDamage _newDamage;

            private _score = player getVariable ["BAC_score", 0];
            _score = _score + 10;
            player setVariable ["BAC_score", _score, true];
            [_score] call BAC_fnc_updateScoreHUD;
            [10] call BAC_fnc_moneyPopup;

            cutRsc ["Hitmarker", "PLAIN", 0.7, false, true];
        };
    };
}];
