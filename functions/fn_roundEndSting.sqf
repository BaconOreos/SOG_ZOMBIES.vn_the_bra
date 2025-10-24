
/*
    File: fn_roundEndSting.sqf
    Description: Plays a fixed round-end sting.
*/
//systemChat "roundEndSting function started";
[] spawn {

1 fadeMusic 5;
playMusic ["vn_tequila_highway", 2.5];
uiSleep 1.5;
1.5 fadeMusic 0;
uiSleep 1.5;
playMusic "";

};



/* 	//fn_roundEndSting.sqf
	1 fadeMusic 5;
	//playMusic ["vn_up_here_looking_down", 47];
	playMusic ["vn_tequila_highway", 2.5];
	uiSleep 1.5;
	1.5 fadeMusic 0;
	uiSleep 1.5;
	playMusic ""; */
