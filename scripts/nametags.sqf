/*
    Simple Nametag System
    Shows player names above their heads (including yourself)
    Put this in initPlayerLocal.sqf or run via execVM
*/

    // FONTS
    // "PuristaMedium" (default)
    // "tt2020base_vn"
    // "tt2020base_vn_bold"
    // "tt2020style_e_vn"
    // "tt2020style_e_vn_bold"
/*
    Simple Nametag System (clean + optimized)
    Shows player names above their heads with fade/scale by distance
    Run from initPlayerLocal.sqf: [] execVM "scripts\nametags.sqf";
    
    FONTS:
    - "PuristaMedium" (default)
    - "tt2020base_vn"
    - "tt2020base_vn_bold"
    - "tt2020style_e_vn"
    - "tt2020style_e_vn_bold"
*/

private _color   = missionNamespace getVariable ["NT_Color", [1,1,0,1]];
private _font    = missionNamespace getVariable ["NT_Font", "PuristaMedium"];
private _size    = missionNamespace getVariable ["NT_Size", 0.05];
private _maxDist = missionNamespace getVariable ["NT_MaxDist", 100];

// Type safety
if !(_color isEqualType []) then { _color = [1,1,0,1]; };
if !(_font isEqualType "") then { _font = "PuristaMedium"; };
if !(_size isEqualType 0) then { _size = 0.05; };
if !(_maxDist isEqualType 0) then { _maxDist = 100; };

addMissionEventHandler ["Draw3D", {
    {
        if (alive _x) then {
            private _pos = ASLToAGL eyePos _x vectorAdd [0,0,0.3];
            private _dist = player distance _x;

            // ----------------------------
            // SELF NAME TAG (for testing)
            // Comment this block out when no longer needed
            if (_x isEqualTo player) then {
                _pos = ASLToAGL eyePos _x vectorAdd [0,0,0.7];
                _dist = 1;  // force close distance so it never fades
            };
            // ----------------------------

            if (_dist < (missionNamespace getVariable ["NT_MaxDist", 100])) then {
                private _t = _dist / (missionNamespace getVariable ["NT_MaxDist", 100]);

                private _alpha = 1 - _t;
                private _scaledSize = (missionNamespace getVariable ["NT_Size", 0.05]) * (1 - 0.5 * _t);

                private _baseColor = missionNamespace getVariable ["NT_Color", [1,1,0,1]];
                private _rgba = +_baseColor; 
                _rgba set [3, _alpha];

                drawIcon3D [
                    "",
                    _rgba,
                    _pos,
                    0,0,0,
                    name _x,
                    2,
                    _scaledSize,
                    missionNamespace getVariable ["NT_Font", "PuristaMedium"]
                ];
            };
        };
    } forEach allPlayers;
}];

//systemChat "Nametags enabled!";
















// Draw nametag above your own head
/* addMissionEventHandler ["Draw3D", { 
    drawIcon3D ["", [1,1,0,1], ASLToAGL eyePos player vectorAdd [0,0,0.3], 0,0,0, name player, 2, 0.05, "tt2020base_vn"]; 
}];

// Draw nametags above all other players
addMissionEventHandler ["Draw3D", { 
    { 
        if (_x != player && alive _x) then { 
            drawIcon3D ["", [1,1,0,1], ASLToAGL eyePos _x vectorAdd [0,0,0.3], 0,0,0, name _x, 2, 0.05, "tt2020base_vn"]; 
        }; 
    } forEach allPlayers; 
}];

systemChat "Nametags enabled!"; */