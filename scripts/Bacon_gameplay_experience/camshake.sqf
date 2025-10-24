
player addEventHandler ["Fired", {
	_firegun = inputAction "defaultAction" > 0;
  enableCamShake true; 
  setCamShakeParams [0, 2, 2, 10, true]; 						//setCamShakeParams [posCoef, vertCoef, horzCoef, bankCoef, interpolation]
  
		if (_firegun) then  
						{     
						addCamShake [0.65, 0.5, 15]; 								// addCamShake [power, duration, frequency]
						}
						//else
						//{ 
						//resetCamShake;
						//};
}];
