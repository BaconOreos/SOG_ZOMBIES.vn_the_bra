player addEventHandler ["Fired", {
	_this # 0 setWeaponReloadingTime [_this # 0, _this # 2, 1/10];
}];
