function onCreate()
	addCharacterToList("greenw","boyfirend")
	setProperty("deathExplo.x",280)

end

function onStepHit()
	if curStep == 34 then
		setProperty("defaultCamZoom",1.05)
	end

	
	if curStep == 769 then
		setProperty("baseY",350)

	end

end