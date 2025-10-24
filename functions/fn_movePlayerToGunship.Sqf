/*
    Function: BAC_fnc_movePlayerToGunship
    Safely moves the caller into the gunship, retrying until successful.
*/
params ["_caller", "_netId"];

private _plane = objNull;
//systemChat "[BAC] Attempting to move you into the AC-119...";

// --- Wait until plane is known locally ---
private _timeout = time + 15;
waitUntil {
    _plane = objectFromNetId _netId;
    (!isNull _plane) || (time > _timeout)
};

if (isNull _plane) exitWith {
    //systemChat "[BAC] Could not find the gunship object on your client.";
    //hint "ERROR: Could not find gunship!";
};

//systemChat format ["[BAC] Found gunship: %1", typeOf _plane];

// --- Wait until the plane is fully initialized and has crew ---
private _done = false;
private _retries = 0;
private _maxRetries = 20;  // Increased from 15

while {!_done && {_retries < _maxRetries}} do {
    if (alive _plane && !isNull driver _plane) then {  // Make sure pilot exists
        
        // Try gunner first (main position)
        if (!_done) then {
            _caller moveInGunner _plane;
            sleep 0.3;  // Give it a moment
            if (vehicle _caller == _plane) then {
                _done = true;
                //systemChat "[BAC] Seated as gunner";
            };
        };
        
        // Try moving into turrets
        if (!_done) then {
            private _turrets = allTurrets _plane;
            //systemChat format ["[BAC] Found %1 turrets", count _turrets];
            if (count _turrets > 0) then {
                {
                    if (!_done) then {
                        _caller moveInTurret [_plane, _x];
                        sleep 0.3;
                        if (vehicle _caller == _plane) then {
                            _done = true;
                            //systemChat format ["[BAC] Seated in turret %1", _x];
                        };
                    };
                } forEach _turrets;
            };
        };
        
        // Try commander as fallback
        if (!_done) then {
            _caller moveInCommander _plane;
            sleep 0.3;
            if (vehicle _caller == _plane) then {
                _done = true;
                //systemChat "[BAC] Seated as commander";
            };
        };
        
        // Try cargo as last resort
        if (!_done) then {
            _caller moveInCargo _plane;
            sleep 0.3;
            if (vehicle _caller == _plane) then {
                _done = true;
                //systemChat "[BAC] Seated in cargo";
            };
        };
    } else {
        //systemChat format ["[BAC] Waiting for pilot... (retry %1/%2)", _retries + 1, _maxRetries];
    };
    
    if (!_done) then {
        _retries = _retries + 1;
        sleep 1;
    };
};

if (_done) then {
    // Check which position the player is in
    private _role = assignedVehicleRole _caller;
    private _roleText = "";
    
    if ((_role select 0) == "driver") then {
        _roleText = "pilot/copilot";
    } else {
        if ((_role select 0) == "gunner") then {
            _roleText = "gunner";
        } else {
            if ((_role select 0) == "turret") then {
                _roleText = format ["turret %1", _role select 1];
            } else {
                if ((_role select 0) == "commander") then {
                    _roleText = "commander";
                } else {
                    if ((_role select 0) == "cargo") then {
                        _roleText = "cargo";
                    } else {
                        _roleText = str _role;
                    };
                };
            };
        };
    };
    
    //hint format ["You are now in the AC-119 gunship!\nPosition: %1", _roleText];
    //systemChat format ["[BAC] Successfully seated as %1.", _roleText];
	setViewDistance 2000;
    setObjectViewDistance [2000, 2000];
	[] spawn {
		sleep 60;
		setViewDistance 100;
		setObjectViewDistance [100, 100];
	};

} else {
    //hint "Failed to seat you in the AC-119 after multiple retries.";
    //systemChat format ["[BAC] Seat transfer failed after %1 retries.", _maxRetries];
};