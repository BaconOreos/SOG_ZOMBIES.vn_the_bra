//https://community.bistudio.com/wiki/titleText
//https://community.bistudio.com/wiki/Title_Effect_Type

//https://community.bistudio.com/wiki/Structured_Text#Special_characters

//use html reprensation/entity for special characters, and not all are compatible with arma https://htmlsymbols.net/math/circled-times

//shows the interaction prompt "Press X to Activate"



// Get the key name for User10 
_user10Key = actionKeysImages "User10";

titleText [format ["<t color='#cccccc' size='4'>Press</t><t color='#40ccd0' size='5'> %1</t><t color='#cccccc' size='4'> to rebuild barricade</t>", _user10Key], "PLAIN NOFADE", -1, false, true];


//https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#UserAction_Event_Handlers
//https://community.bistudio.com/wiki/inputAction/actions

//adds event handler to check for input (custom user input 10) and executes code if input is pressed
removeAllUserActionEventHandlers ["User10", "Activate"];
addUserActionEventHandler ["User10", "Activate", {
    params ["_activated"];
    
    if (_activated) then {
					[] spawn {
							{
							//_x enableSimulation true;
							_x hideObject false;
							} forEach (getMissionLayerEntities "zomb_barricade_0" select 0);

							cutText ["<br/><br/><br/><t color='#ffffff' size='4'>well done</t><t color='#40ccd0' size='5'> you</t><t color='#ffffff' size='5'></t>", "PLAIN NOFADE", -1, false, true];
							uiSleep 1;
							cutText ["<br/><br/><br/><t color='##00FF00' size='5'></t>", "PLAIN", -1, true, true];
							}
    };
}];
