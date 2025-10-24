/*
    Vanilla stance reset (no CBA)
    Only triggers if player is ALREADY prone before pressing prone again
*/

private _wasProne = false;

addMissionEventHandler ["EachFrame", {
    private _unit = player;
    if (!alive _unit) exitWith {};

    private _isProne = stance _unit isEqualTo "PRONE";
    private _pronePressed = (inputAction "Prone" > 0) or (inputAction "MoveDown" > 0);

    // Trigger only if: was prone last frame, is still prone, and prone key just pressed
    if (_wasProne && _isProne && _pronePressed && {isTouchingGround _unit}) then {
        [_unit] spawn {
            params ["_unit"];

            private _weaponType = currentWeapon _unit;
            if (_weaponType isEqualTo "") exitWith {};

            private _animCrouch = "";
            private _animStand  = "";

            if (_weaponType isEqualTo (primaryWeapon _unit)) then {
                _animCrouch = "AmovPknlMstpSrasWrflDnon";
                _animStand  = "AmovPercMstpSrasWrflDnon";
            } else {
                _animCrouch = "AmovPknlMstpSrasWpstDnon";
                _animStand  = "AmovPercMstpSrasWpstDnon";
            };

            [_unit, _animCrouch] remoteExec ["switchMove", 0, true];
            sleep 0.1;
            [_unit, _animStand] remoteExec ["switchMove", 0, true];
        };
    };

    // Update memory for next frame
    _wasProne = _isProne;
}];
