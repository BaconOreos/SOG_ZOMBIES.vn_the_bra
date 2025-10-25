/*
    File: showOpforUnits.sqf
    Description: Draws a floating "O" above OPFOR units if there are 5 or fewer alive on the map.
    OPFOR Marker Display
    Shows a red "O" above OPFOR units if there are 5 or fewer alive on the map.
    Client-local draw3D system, modeled after working nametag logic.
*/

private _color   = [1,0,0,1];         // Red
private _font    = "PuristaMedium";   // Font
private _size    = 0.05;              // Text size
private _maxDist = 300;               // Optional max render distance

addMissionEventHandler ["Draw3D", {
    // Select alive OPFOR units
    private _opforUnits = allUnits select {side _x == east && alive _x};

    // Only draw if 5 or fewer alive
    if ((count _opforUnits) <= 5) then {
        {
            private _dist = player distance _x;
            if (_dist <  _maxDist) then {
                private _pos = ASLToAGL eyePos _x vectorAdd [0,0,0.6];

                // Fade with distance (optional)
                private _t = _dist / _maxDist;
                private _alpha = 1 - _t;
                private _rgba = +_color;
                _rgba set [3, _alpha];

                private _scaledSize = _size * (1 - 0.5 * _t);

                drawIcon3D [
                    "",         // No texture
                    _rgba,      // Color (with fade)
                    _pos,       // Position above head
                    0, 0, 0,
                    "O",        // Text
                    2,          // Shadow (outline)
                    _scaledSize,
                    _font,
                    "center"
                ];
            };
        } forEach _opforUnits;
    };
}];
