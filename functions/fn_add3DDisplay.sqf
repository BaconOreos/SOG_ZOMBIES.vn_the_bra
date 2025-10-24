// fn_add3DDisplay.sqf

fn_add3DDisplay = {
    // Parameters
    private ["_object", "_text", "_size"];
    
    // Get parameters from array
    _object = _this select 0;
    _text = _this select 1;
    _size = _this select 2;
    
    // Create the 3D draw with proper parameters
    private["_draw3D"];
    _draw3D = [
        _object,           // Object to attach to
        _text,             // Text to display
        [0.5, 0.5],       // Position (centered)
        [1, 1, 1, 1],     // Color (white with full opacity)
        0,                // Shadow
        _size,            // Text size
        "PuristaMedium",  // Font
        "center"          // Alignment
    ] call BIS_fnc_draw3D;
    
    _draw3D
};
