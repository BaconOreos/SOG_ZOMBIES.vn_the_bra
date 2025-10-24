
params [["_blockerLayer", "", [""]]];

// Get all entities from the layer
private _entities = getMissionLayerEntities _blockerLayer select 0;

// Delete all objects in that layer
{
    if (!isNull _x) then {
        _x hideObject true;
        deleteVehicle _x;
    };
} forEach _entities;

// Local feedback message
/* cutText [
    format ["<br/><br/><br/><t color='#cccccc' size='4'>%1 cleared</t>", _blockerLayer],
    "PLAIN",
    -1,
    true,
    true
];
uiSleep 1;
cutText ["", "PLAIN", -1, true, true]; */
