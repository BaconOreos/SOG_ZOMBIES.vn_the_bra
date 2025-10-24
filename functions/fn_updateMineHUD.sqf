
/*
    fn_updateMineHUD.sqf
    Shows count of "vn_mine_m18_range_mag" in HUD.
*/

// --- Get UI control ---
private _ctrl = uiNamespace getVariable ["BAC_MineHUD_ctrl", controlNull];
if (isNull _ctrl) exitWith {};

// --- Target classname ---
private _mineClass = "vn_mine_m18_range_mag";

// --- Count mines in inventory ---
private _mineCount = { _x == _mineClass } count (magazines player);

// --- Display formatting ---
private _text = "";

if (_mineCount <= 0) then {
    _text = "<t size='1.4' color='#777777'></t><img image='images\claymore_grey.paa' size='2'/>";       // greyed out (none)
} else {
    if (_mineCount == 1) then {
        _text = "<t size='1.4' color='#b6098bff'></t><img image='images\claymore.paa' size='2'/>";   // 1 mine
    } else {
        _text = "<t size='1.4' color='#b6098bff'></t><img image='images\claymore.paa' size='2'/><t size='1.8' color='#cccccc'> +</t>";  // more than 1
    };
};

_ctrl ctrlSetStructuredText parseText _text;
