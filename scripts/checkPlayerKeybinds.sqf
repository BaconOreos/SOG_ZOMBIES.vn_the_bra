/*
    File: checkPlayerKeybinds.sqf
    Description: Checks if User10 is bound. If not, shows a warning message.
*/

private _unbound = [];

{
    private _keys = actionKeys _x;
    if (_keys isEqualTo []) then {
        _unbound pushBack _x;
    };
} forEach ["User10", "User11", "User12", "User13"];

if !(_unbound isEqualTo []) then {
    private _message = format ["Keys not bound: %1, your gameplay experience may vary", _unbound joinString ", "];
    [_message, "#cccccc", 1.5] remoteExec ["BAC_fnc_showMessageGeneric", player];
};
