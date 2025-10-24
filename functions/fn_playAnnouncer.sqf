/*
    BAC_fnc_playAnnouncer
    Play announcer-style voice lines (non-positional, loud)

    Usage:
        [unit, context, locality] call BAC_fnc_playAnnouncer;

    0: OBJECT - unit (used to pick their voicepack, but sound is global/local, not positional)
    1: STRING - context (e.g. "revived", "downed", "buyweapon")
    2: NUMBER - locality
       1 = local only
       2 = global (all players hear it)
*/

params ["_unit", "_context", ["_locality", 2]];

// --- Roll chance (80% chance by default, adjust as needed)
private _chance = 1;
if (random 1 > _chance) exitWith {
    systemChat format ["[Announcer] Skipped context '%1' (chance roll)", _context];
};

// --- Get the unit's voice pack
private _pack = _unit getVariable ["voicePack", "jim"];

// --- Get the context's sound list
private _varName = format ["VoicePack_%1_%2", _pack, _context];
private _sounds = missionNamespace getVariable [_varName, []];

// --- Exit early if nothing found
if (_sounds isEqualTo [] || {count _sounds == 0}) exitWith {
    systemChat format ["[Announcer] No sounds found for pack '%1', context '%2'", _pack, _context];
};

// --- Pick random sound
private _sound = selectRandom _sounds;
systemChat format ["[Announcer] Playing '%1' for context '%2'", _sound, _context];

// --- Play sound based on locality
switch (_locality) do {
    case 1: {  // Local only
        playSound _sound;
    };
    case 2: {  // Global for all players
        [_sound] remoteExec ["playSound", 0];
    };
};
