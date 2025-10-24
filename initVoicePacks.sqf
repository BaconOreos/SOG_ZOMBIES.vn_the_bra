// initVoicePacks.sqf
// Build missionNamespace lookup tables for voice packs (only from sounds\voicepacks)

{
    private _class = configName _x;
    private _config = _x;

    if (isClass _config && isArray (_config >> "sound")) then {
        private _sound = getArray (_config >> "sound"); 
        if ((count _sound) > 0) then {
            private _path = _sound select 0; // sound path (string)

            // Only process sounds from our voicepacks folder
            if (["sounds/voicepacks", toLower _path] call BIS_fnc_inString) then {
                private _parts = _class splitString "_"; // ["jim","reload","ting8"]
                if (count _parts >= 2) then {
                    private _pack = _parts select 0;     // "jim"
                    private _context = _parts select 1;  // "reload"
                    private _key = format ["VoicePack_%1_%2", _pack, _context];

                    private _arr = missionNamespace getVariable [_key, []];
                    _arr pushBack _path; // just store the path
                    missionNamespace setVariable [_key, _arr];
                };
            };
        };
    };
} forEach ("true" configClasses (configFile >> "CfgSounds"));

//systemChat "[VoicePacks] Voicepack initialization complete.";
