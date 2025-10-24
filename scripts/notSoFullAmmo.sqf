

private _equippedPrimary = primaryWeapon player;
private _equippedLauncher = secondaryWeapon player;
private _equippedPistol = handgunWeapon player;


if (primaryWeapon player != "") then {
    private _compatMag = compatibleMagazines _equippedPrimary select 0;
	player addMagazines [_compatMag, 3];
	player addPrimaryWeaponItem _compatMag;
};

if (secondaryWeapon player != "") then {
    private _compatMagLauncher = compatibleMagazines _equippedLauncher select 0;
	player addMagazines [_compatMagLauncher, 1];
	player addSecondaryWeaponItem _compatMagLauncher;
};

if (handgunWeapon player != "") then {
    private _compatMagPistol = compatibleMagazines _equippedPistol select 0;
	player addMagazines [_compatMagPistol, 1];
	player addHandgunItem _compatMagPistol;
};


private _grenade = selectRandom ["vn_m67_grenade_mag", "vn_m61_grenade_mag", "vn_molotov_grenade_mag", "MiniGrenade", "vn_mine_m18_range_mag"];
player addMagazines [_grenade, 0];





/* cutText ["<br/><br/><br/><t color='#00FF00' size='5'>NOT SO FULL AMMO</t>", "PLAIN", -1, true, true];
uiSleep 1;
cutText ["<br/><br/><br/><t color='#00FF00' size='5'></t>", "PLAIN", -1, true, true]; */


/* 
To execute a block of code conditionally based on whether the result of primaryWeapon is not null, you can use an if statement to check the result. If the weapon is valid (i.e., not an empty string), you can wrap your executable code inside curly brackets. Here’s how you can achieve that in SQF:

sqf

// Get the primary weapon of the player
_pWeap = primaryWeapon player;

// Check if the primary weapon is not an empty string
if (!isNil {_pWeap} && _pWeap != "") then {
    // Place your executable code here
    {
        // Your code to execute if the primary weapon is valid
    };
};

// Continue with the next line of code

Explanation:

    Retrieve the Primary Weapon: The variable _pWeap stores the result of primaryWeapon player.
    Condition Check: The if statement checks if _pWeap is not nil and not an empty string. This ensures that the block of code only executes if there is a valid primary weapon.
    Curly Brackets: The code inside the curly brackets will only run if the condition is met.
    Continuation: After the conditional block, the script will continue to the next line of code regardless of whether the condition was true or false. 
*/
