//init.sqf
//systemChat ">>> init.sqf START";
diag_log ">>> init.sqf START";

setViewDistance 100;
0 setFog [1,0,0]; //https://community.bistudio.com/wiki/setFog
setTerrainGrid 100;
setObjectViewDistance [100, 100];

// will make east friendly to west and vice versa
east setFriend [resistance, 1];
resistance setFriend [east, 1];

[] spawn {
    sleep 1;
	diag_log "init.sqf is starting mapOverlay.sqf";
    [] execVM "scripts\HUD\mapOverlay.sqf";
	diag_log "init.sqf is starting fn_initVoicePacks.sqf";
	[] execVM "functions\fn_initVoicePacks.sqf";
	[] execVM "scripts\fireSupportSystem.sqf";
	//diag_log "init.sqf is starting InitDownedSystem.sqf";
	//[] execVM "scripts\initDownedSystem.sqf";
};

BAC_fnc_spawnC119 = {
    params ["_pos", "_caller"];
    [_pos, _caller] execVM "scripts\c119gunship.sqf";
};
publicVariable "BAC_fnc_spawnC119";


//ALL THE PLAYER VARIABLES HERE


[] spawn {

if (isNil "p1") then {
    // Code to execute if p1 does not exist
} else {
    p1 setCustomAimCoef 0.2;
	p1 enableAimPrecision false;
	p1 enableFatigue false;
	p1 enableStamina false;
	p1 setAnimSpeedCoef 1.5;
	p1 setUnitRecoilCoefficient 0.8;
	p1 setSpeaker "NoVoice";
};

if (isNil "p2") then {
    // Code to execute if p1 does not exist
} else {
    p2 setCustomAimCoef 0.2;
	p2 enableAimPrecision false;
	p2 enableFatigue false;
	p2 enableStamina false;
	p2 setAnimSpeedCoef 1.5;
	p2 setUnitRecoilCoefficient 0.8;
	p2 setSpeaker "NoVoice";
};

if (isNil "p3") then {
    // Code to execute if p1 does not exist
} else {
    p3 setCustomAimCoef 0.2;
	p3 enableAimPrecision false;
	p3 enableFatigue false;
	p3 enableStamina false;
	p3 setAnimSpeedCoef 1.5;
	p3 setUnitRecoilCoefficient 0.8;
	p3 setSpeaker "NoVoice";
};

if (isNil "p4") then {
    // Code to execute if p1 does not exist
} else {
    p4 setCustomAimCoef 0.2;
	p4 enableAimPrecision false;
	p4 enableFatigue false;
	p4 enableStamina false;
	p4 setAnimSpeedCoef 1.5;
	p4 setUnitRecoilCoefficient 0.8;
	p4 setSpeaker "NoVoice";
};

if (isNil "p5") then {
    // Code to execute if p1 does not exist
} else {
    p5 setCustomAimCoef 0.2;
	p5 enableAimPrecision false;
	p5 enableFatigue false;
	p5 enableStamina false;
	p5 setAnimSpeedCoef 1.5;
	p5 setUnitRecoilCoefficient 0.8;
	p5 setSpeaker "NoVoice";
};

if (isNil "p6") then {
    // Code to execute if p1 does not exist
} else {
    p6 setCustomAimCoef 0.2;
	p6 enableAimPrecision false;
	p6 enableFatigue false;
	p6 enableStamina false;
	p6 setAnimSpeedCoef 1.5;
	p6 setUnitRecoilCoefficient 0.8;
	p6 setSpeaker "NoVoice";
};

if (isNil "p7") then {
    // Code to execute if p1 does not exist
} else {
    p7 setCustomAimCoef 0.2;
	p7 enableAimPrecision false;
	p7 enableFatigue false;
	p7 enableStamina false;
	p7 setAnimSpeedCoef 1.5;
	p7 setUnitRecoilCoefficient 0.8;
	p7 setSpeaker "NoVoice";
};

if (isNil "p8") then {
    // Code to execute if p1 does not exist
} else {
    p8 setCustomAimCoef 0.2;
	p8 enableAimPrecision false;
	p8 enableFatigue false;
	p8 enableStamina false;
	p8 setAnimSpeedCoef 1.5;
	p8 setUnitRecoilCoefficient 0.8;
	p8 setSpeaker "NoVoice";
};

if (isNil "p9") then {
    // Code to execute if p1 does not exist
} else {
    p9 setCustomAimCoef 0.2;
	p9 enableAimPrecision false;
	p9 enableFatigue false;
	p9 enableStamina false;
	p9 setAnimSpeedCoef 1.5;
	p9 setUnitRecoilCoefficient 0.8;
	p9 setSpeaker "NoVoice";
};


};
