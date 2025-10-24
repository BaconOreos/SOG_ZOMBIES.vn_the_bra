/*
	// file gameOverClient.sqf
    Params:
        0: NUMBER - last round survived
*/
params ["_lastRound"];

playMusic ["vn_prairie_fire", 0];
5 fadeSound 0;
1 fadeMusic 11;

uiSleep 4;

// Fade to black
[0, "BLACK", 4, 1, "", "", 1] spawn BIS_fnc_fadeEffect;

uiSleep 5;

// Show text
titleText [
    format [
        "<t color='#ffffff' font='tt2020base_vn_bold' size='4'>You lasted</t><t color='#ffffff' font='tt2020base_vn_bold' size='5'> %1</t><t color='#ffffff' font='tt2020base_vn_bold' size='4'> rounds</t>",
        _lastRound
    ],
    "PLAIN NOFADE",
    -1,
    false,
    true
];

uiSleep 6;

// End mission
//https://community.bistudio.com/wiki/BIS_fnc_endMission
["end1", true, false, false] call BIS_fnc_endMission;
