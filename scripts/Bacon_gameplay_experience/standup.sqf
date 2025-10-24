//forces standup when sprinting from crouch
[] spawn {
		while {true} do {
						_iscrouching = stance player == "CROUCH";		//refer to this https://community.bistudio.com/wiki/stance
						_isnotcrouching = stance player == "STAND";
						
						_sprint = inputAction "turbo" > 0;				//refer to this https://community.bistudio.com/wiki/inputAction/actions
						
						
						if (_iscrouching && _sprint) then 
													{
													player playAction "PlayerStand";	//forces player to stand up when sprinting //https://community.bistudio.com/wiki/action
													sleep 0.5;
													player playActionNow "";
													}								 	//https://community.bistudio.com/wiki/inputAction/actions

						};					
};




//player action ["Stand", player]; https://community.bistudio.com/wiki/action


//player playAction "PlayerStand﻿﻿"; from https://forums.bohemia.net/forums/topic/180475-stance-command-and-setstance/
