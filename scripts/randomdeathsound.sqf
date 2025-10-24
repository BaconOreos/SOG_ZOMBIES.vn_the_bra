this addEventHandler ["Killed", {  
    params ["_unit"]; 
    _deathsound = ["death1", "death2", "death3", "death4", "death5", "death6", "death7"]; 
    private _dummy = "#particlesource" createVehicleLocal ASLToAGL getPosWorld _unit;  
    _dummy say3D [selectRandom _deathsound, 1000, 1];  
    _dummy spawn {  
         sleep 5; 
         deleteVehicle _this;  
    }; 
}];






{_x setPos getMarkerPos([selectRandom ["death1", "death2", "death3", "death4", "death5", "death6", "death7"])}
["death1", "death2", "death3", "death4", "death5", "death6", "death7"]
