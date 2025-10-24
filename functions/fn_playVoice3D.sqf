/*
    RemoteExec helper for positional playback
    Params: [unit, soundClass]
*/
params ["_unit", "_soundClass"];

if (!isNull _unit && {_soundClass != ""}) then {
    _unit say3D _soundClass;
};
