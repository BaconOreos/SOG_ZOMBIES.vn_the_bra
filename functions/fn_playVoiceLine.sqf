/*
    fn_playVoiceLine.sqf
    Usage:
        [unit, context, locality, chance] call BAC_fnc_playVoiceLine;

    0: OBJECT - unit
    1: STRING - context (reload, hurt, downed, etc.)
    2: NUMBER - 1 = local only, 2 = global positional
    3: NUMBER (optional) - chance (0.0 = never, 1.0 = always). Default = 0.3
*/

params ["_unit", "_context", ["_locality", 2], ["_chance", 0.3]];

// --- Roll chance
if ((random 1) > _chance) exitWith {
    diag_log format ["[VoicePacks] Skipped context '%1' (rolled above chance %2)", _context, _chance];
};

// --- Get unit’s pack
private _pack = _unit getVariable ["voicePack", "jim"];

// --- Lookup sound classnames
private _varName = format ["VoicePack_%1_%2", _pack, _context];
private _sounds = missionNamespace getVariable [_varName, []];

// --- Exit if none found
if (_sounds isEqualTo [] || {count _sounds == 0}) exitWith {
    diag_log format ["[VoicePacks] No sounds found for %1_%2", _pack, _context];
};

// --- Pick random classname
private _soundClass = selectRandom _sounds;
diag_log format ["[VoicePacks] %1 says '%2' (%3, chance %4)", name _unit, _soundClass, _context, _chance];

// --- Local or Global playback
switch (_locality) do {
    case 1: {
        // Local only, straight to player
        playSound _soundClass;
    };
    case 2: {
        // Global positional playback (all clients hear it from _unit)
        [_unit, _soundClass] remoteExec ["BAC_fnc_playVoice3D", 0];
    };
};



















/*
    fn_playVoiceLine.sqf
    Usage:
        [unit, context, locality] call BAC_fnc_playVoiceLine;
    0: OBJECT - unit
    1: STRING - context (reload, hurt, downed, etc.)
    2: NUMBER - 1 = local only, 2 = global positional
*/

/* params ["_unit", "_context", ["_locality", 2]];


// --- Chance for a voice line to play (0.0 = never, 1.0 = always)
missionNamespace setVariable ["VOICE_LINE_CHANCE", 0.33];

// --- Roll chance (percentage based)
private _chance = missionNamespace getVariable ["VOICE_LINE_CHANCE", 1]; // default 100%
if ((random 1) > _chance) exitWith {
    //systemChat format ["[VoicePacks] Skipped context '%1' (rolled above chance %2)", _context, _chance];
};

// --- Get unit’s pack
private _pack = _unit getVariable ["voicePack", "jim"];

// --- Lookup sound classnames
private _varName = format ["VoicePack_%1_%2", _pack, _context];
private _sounds = missionNamespace getVariable [_varName, []];

// --- Exit if none found
if (_sounds isEqualTo [] || {count _sounds == 0}) exitWith {
    diag_log format ["[VoicePacks] No sounds found for %1_%2", _pack, _context];
    //systemChat format ["[VoicePacks] No sounds found for %1_%2", _pack, _context];
};

// --- Pick random classname
private _soundClass = selectRandom _sounds;
diag_log format ["[VoicePacks] %1 says '%2' (%3)", name _unit, _soundClass, _context];
//systemChat format ["[VoicePacks] %1 says '%2' (%3)", name _unit, _soundClass, _context];

// --- Local or Global playback
switch (_locality) do {
    case 1: {
        // Local only, straight to player
        playSound _soundClass;
    };
    case 2: {
        // Global positional playback (all clients hear it from _unit)
        [_unit, _soundClass] remoteExec ["BAC_fnc_playVoice3D", 0];
    };
};
 */