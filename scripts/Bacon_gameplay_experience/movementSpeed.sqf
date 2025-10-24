//https://community.bistudio.com/wiki/inputAction/actions

//movementSpeed.sqf


_inputCheckBack = inputAction "MoveBack" > 0;
_inputCheckForward = inputAction "MoveBack" > 0;
_inputCheckLeft = inputAction "MoveBack" > 0;
_inputCheckRight = inputAction "MoveBack" > 0;


addUserActionEventHandler ["MoveForward", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
						player setAnimSpeedCoef 1.3;
						 };
}];

addUserActionEventHandler ["MoveBack", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
						player setAnimSpeedCoef 1.8;
						};
}];

addUserActionEventHandler ["TurnLeft" , "Activate", {
    params ["_activated"];
    
    if (_activated && !_inputCheckForward) then {
						player setAnimSpeedCoef 2.3;
						 };
}];

addUserActionEventHandler ["TurnRight", "Activate", {
    params ["_activated"];
    
    if (_activated && !_inputCheckForward) then {
						player setAnimSpeedCoef 2.3;
						 };
}];



//this works, attempt at correcting behavior of sidestep getting faster if done after backstep, slower if after forward step
/* addUserActionEventHandler ["MoveForward", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
        if (!_inputCheckLeft && !_inputCheckRight) then {
            player setAnimSpeedCoef 1.3;
        } else {
            if (_inputCheckLeft || _inputCheckRight) then {
                player setAnimSpeedCoef 1.8;
            };
        };
    };
}];

addUserActionEventHandler ["MoveBack", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
        if (!_inputCheckLeft && !_inputCheckRight) then {
            player setAnimSpeedCoef 1.8;
        } else {
            if (_inputCheckLeft || _inputCheckRight) then {
                player setAnimSpeedCoef 1.8;
            };
        };
    };
}];

addUserActionEventHandler ["TurnLeft", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
        if (!_inputCheckForward && !_inputCheckBack) then {
            player setAnimSpeedCoef 6;
        } else {
            if (_inputCheckBack) then {
                player setAnimSpeedCoef 1.3;
            };
        };
    };
}];

addUserActionEventHandler ["TurnRight", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
        if (!_inputCheckForward && !_inputCheckBack) then {
            player setAnimSpeedCoef 6;
        } else {
            if (_inputCheckBack) then {
                player setAnimSpeedCoef 1.3;
            };
        };
    };
}]; */



// this works
/* addUserActionEventHandler ["moveBack", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
					player setAnimSpeedCoef 0.1.7;
    };
}]; */


