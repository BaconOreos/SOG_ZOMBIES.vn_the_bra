//https://community.bistudio.com/wiki/BIS_fnc_spawnObjects

_table = createVehicle ["Land_CampingTable_F",position player,[], 0, "FLY"];
private _randomPos = [(random 0.2) -0.1, (random 0.2) -0.1, 0];
_objects = [[_table, "TOP"], "Box_NATO_Wps_F", 3, _randomPos,(random 20)-10] call BIS_fnc_spawnObjects;


/* //_shopPosition = getPos shop;
private _objects = [
    [shop, "TOP"],         // position: relative to 'shop' object, on TOP
    "vn_xm177_short",      // className of the object
    1,                     // count: only one object
    [0,0,0],               // offsetMatrix: no offset
    0,                     // offsetDir: no rotation
    {0},                   // dirNoise: always 0 (no randomness)
    false                  // enableSimulation: keep simulation off
] call BIS_fnc_spawnObjects; */
