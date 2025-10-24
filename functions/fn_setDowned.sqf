/*
    fn_setDowned.sqf
    Function: BAC_fnc_setDowned
    Purpose: Puts a player into a custom "downed" state.

    Parameters:
        0: OBJECT - _unit
            The player unit that should be forced into the downed state.

    Notes:
        - Only works on player units (AI are ignored).
        - Marks the unit with variable "BAC_isDowned" = true (global).
        - Player becomes invincible, cannot move, and is ignored by AI/zombies.
        - Player is forced into sitting/crippled animations, with restricted input.
        - A revive proximity check is started so other players can revive them.
        - On server, this triggers BAC_fnc_checkPlayersAlive to handle game-over logic.

    Example:
        [player] call BAC_fnc_setDowned;   // Down the local player
        [p1] remoteExec ["BAC_fnc_setDowned", 2]; // Force p1 into downed state from server
*/

params ["_unit"];

//systemChat format ["DEBUG: fn_setDowned called on %1", name _unit];
diag_log ["DEBUG: fn_setDowned called on %1", name _unit];
diag_log format ["[BAC DEBUG] fn_setDowned executed for %1 (%2)", name _unit, _unit];

if (!isPlayer _unit) exitWith {};
if (_unit getVariable ["BAC_isDowned", false]) exitWith {};

_unit setVariable ["BAC_isDowned", true, true];
//"BAC_isDowned" → the variable name stored on the unit.
//true → sets the variable’s value to true.
//true → makes the variable public, meaning the change is broadcast to all clients and the server via the network.

// Save original group (server keeps track)
if (isServer) then {
    _unit setVariable ["BAC_originalGroup", group _unit, true];
};

// Save current loadout at time of going down
_unit setVariable ["BAC_savedLoadout", getUnitLoadout _unit, true];


// Switch to civilian group → zombies & AI ignore
/* private _civGroup = createGroup [resistance, true];
[_unit] joinSilent _civGroup; */

//make captive so zombies ignore
_unit setCaptive true;


// Invincible while downed
_unit allowDamage false;
_unit setDamage 0;


// Allowed "downed" animations
private _allowedAnims = [
    // Rifle prone sit + turns
    "AadjPpneMstpSrasWrflDup",
    "AadjPpneMstpSrasWrflDup_turnL",
    "AadjPpneMstpSrasWrflDup_turnR",

    // Rifle prone crawl
    "AadjPpneMwlkSrasWrflDup_r",
    "AadjPpneMwlkSrasWrflDup_l",
    "AadjPpneMwlkSrasWrflDup_fr",
    "AadjPpneMwlkSrasWrflDup_fl",
    "AadjPpneMwlkSrasWrflDup_f",
    "AadjPpneMwlkSrasWrflDup_br",
    "AadjPpneMwlkSrasWrflDup_bl",
    "AadjPpneMwlkSrasWrflDup_b",

    // Pistol prone sit + turns
    "AadjPpneMstpSrasWpstDup",
    "AadjPpneMstpSrasWpstDup_turnL",
    "AadjPpneMstpSrasWpstDup_turnR",

    // Pistol prone crawl (discovered + expanded)
    "AadjPpneMwlkSrasWpstDup_r",
    "AadjPpneMwlkSrasWpstDup_l",
    "AadjPpneMwlkSrasWpstDup_fr",
    "AadjPpneMwlkSrasWpstDup_fl",
    "AadjPpneMwlkSrasWpstDup_f",
    "AadjPpneMwlkSrasWpstDup_br",
    "AadjPpneMwlkSrasWpstDup_bl",
    "AadjPpneMwlkSrasWpstDup_b",

    // Extra variants caught in debug (pistol set)
    "AadjPpneMstpSrasWpstDup_b",
    "AadjPpneMstpSrasWpstDup_f",
    "AadjPpneMstpSrasWpstDup_l",
    "AadjPpneMstpSrasWpstDup_r",
    "AadjPpneMstpSrasWpstDup_fr",
    "AadjPpneMstpSrasWpstDup_fl",
    "AadjPpneMstpSrasWpstDup_turnR",
    "AadjPpneMstpSrasWpstDup_turnL",
    
    "aadjppnemwklsraswpstdup",
    "aadjppnemwklsraswpstdup_f",
    "aadjppnemwklsraswpstdup_b",
    "aadjppnemwklsraswpstdup_r",
    "aadjppnemwklsraswpstdup_l",
    "aadjppnemwklsraswpstdup_fl",
    "aadjppnemwklsraswpstdup_fr",
    "aadjppnemwklsraswpstdup_br",
    "aadjppnemwklsraswpstdup_bl"
];



// Animation enforcement loop with debug
[_unit, _allowedAnims] spawn {
    params ["_unit", "_allowedAnims"];
    private _lastAnim = "";

    while {alive _unit && (_unit getVariable ["BAC_isDowned", false])} do {
        private _anim = animationState _unit;
        _unit setAnimSpeedCoef 0.0001;
        _unit setDamage 0;

        // Log changes only when it flips to something new
        if (_anim != _lastAnim) then {
            _lastAnim = _anim;

            if !(_anim in _allowedAnims) then {
                //systemChat format ["[DOWNED DEBUG] Invalid anim: %1", _anim];
                diag_log format ["[BAC DEBUG] %1 invalid anim while downed: %2", name _unit, _anim];

                [_unit, "AadjPpneMstpSrasWpstDup"] remoteExec ["switchMove", 0, true];
            } else {
                //systemChat format ["[DOWNED DEBUG] Valid anim: %1", _anim];
            };
        };

        uiSleep 0.1;
    };
};

//overlay when downed
/* private _ctrl = (uiNamespace getVariable "BloodOverlay") displayCtrl 1001;
_ctrl ctrlSetText "images\blood_overlay_03.paa"; */


// Movement disable
_unit disableAI "MOVE";
_unit disableAI "PATH";

// Input restriction
if (local _unit) then {
    _unit enableSimulation true;   // blocks WASD
    _unit switchCamera "INTERNAL";  // allows mouse look
};

if (isServer) then {
    [] spawn BAC_fnc_checkPlayersAlive;
};


// Start revive proximity check

[_unit] spawn {
    params ["_downed"];   // The player who is downed (passed into this script)

    private _reviveDist = 6;    // Maximum distance (in meters) a reviver must be from the downed player
    private _reviveTime = 3.5;      // Time (in seconds) the reviver must stay close to complete the revive

    // Loop runs as long as this player remains in the "downed" state
    while { _downed getVariable ["BAC_isDowned", false] } do {
        
        // Find all other players who could potentially revive
        private _nearRevivers = (allPlayers - [_downed]) select {
            alive _x                                         // must be alive
            && !(_x getVariable ["BAC_isDowned", false])     // cannot be downed themselves
            && {_x distance _downed < _reviveDist}           // must be within revive distance
        };

        // If there is at least one valid reviver nearby
        if !(_nearRevivers isEqualTo []) then {
            private _reviver = _nearRevivers select 0;   // pick the first valid reviver
            private _start = time;                       // record the time revive started

            // Loop while reviver stays in range, and until revive duration passes
            while { time - _start < _reviveTime && { _downed getVariable ["BAC_isDowned", false] } } do {
                
                // Cancel revive if reviver dies, gets downed, or leaves the revive radius
                if (!alive _reviver 
                    || _reviver getVariable ["BAC_isDowned", false] 
                    || {_reviver distance _downed > _reviveDist}) exitWith {
                    
                    // Hide revive messages from both players
                    ["", "", 0, true] remoteExec ["BAC_fnc_showMessageGeneric", [_downed, _reviver]];
                };

                // Show simple messages:
                // Reviver sees "Reviving..."
                ["Reviving...", "#cccccc", 2.5] remoteExec ["BAC_fnc_showMessageGeneric", _reviver];
                // Downed player sees "Being Revived..."
                ["Being Revived...", "#cccccc", 2.5] remoteExec ["BAC_fnc_showMessageGeneric", _downed];

                uiSleep 0.2; // update messages every 0.2 seconds
            };

            // Success: reviver stayed within range for full duration
            if (_downed getVariable ["BAC_isDowned", false] 
                && {alive _reviver} 
                && {_reviver distance _downed <= _reviveDist}) then {
                
                // Clear revive messages from both players
                ["", "", 0, true] remoteExec ["BAC_fnc_showMessageGeneric", [_downed, _reviver]];

                // Call revive function on the downed player (server-side)
                [_downed] remoteExec ["BAC_fnc_revivePlayer", 2];

                break; // end loop since revive succeeded
            };
        };

        uiSleep 1; // check again after 1 second if no reviver found
    };
};





// Downed stance watchdog
[_unit] spawn {
    params ["_unit"];

    private _watchInterval = 1; // check every 1 second
    private _validDownStances = [
        "PRONE",
        "CROUCH"  // optional if you want semi-prone
    ];

    while {alive _unit && {_unit getVariable ["BAC_isDowned", false]}} do {

        // Re-check animation state and stance
        private _anim = animationState _unit;
        private _stance = stance _unit;

        // If they're somehow standing, or animation not allowed, reset them
        if (_stance == "STAND" || {!(_anim in [
            "AadjPpneMstpSrasWpstDup",
            "AadjPpneMstpSrasWpstDup_turnL",
            "AadjPpneMstpSrasWpstDup_turnR"
        ])}) then {

            diag_log format ["[BAC DEBUG] Watchdog: Resetting %1 (stance=%2, anim=%3)", name _unit, _stance, _anim];

            // Force switch back to crippled anim
            [_unit, "AadjPpneMstpSrasWpstDup"] remoteExec ["switchMove", 0, true];

            // Freeze player in place again
            _unit setAnimSpeedCoef 0.0001;
            _unit disableAI "MOVE";
            _unit disableAI "PATH";

            // Prevent movement drift
            _unit setVelocity [0,0,0];
        };

        uiSleep _watchInterval;
    };
};
