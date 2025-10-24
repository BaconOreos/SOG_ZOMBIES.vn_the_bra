
player addEventHandler ["Reloaded", {
  enableCamShake true; 
  setCamShakeParams [0, 0, 0, 10, true]; 		// setCamShakeParams [posCoef, vertCoef, horzCoef, bankCoef, interpolation]
  addCamShake [0.2, 0.8, 30]; 					// addCamShake [power, duration, frequency]
  
}];


[] spawn {
		while {true} do {
						_reloading = inputAction "reloadMagazine" > 0;

						if (_reloading) then
												{
												enableCamShake true; 
												setCamShakeParams [0, 0, 0, 10, true];			//setCamShakeParams [posCoef, vertCoef, horzCoef, bankCoef, interpolation]
												addCamShake [0.15, 1, 30];					//addCamShake [power, duration, frequency] Duration in seconds divided by 2
												sleep 0.5;
												resetCamShake;
												sleep 1.1;										//delay: Number - in seconds.
												addCamShake [0.2, 1, 30];
												sleep 0.5;
												resetCamShake;
												};
						}
};


