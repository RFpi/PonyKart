local player = playerKart()

-- shows the instanced and static geometry and region node in a region
local function showGeom(regionName)
	setInstancedGeometryVisibility(regionName, true)
	setStaticGeometryVisibility(regionName, true)
	setRegionNodeVisibility(regionName, true)
end

-- hides the instanced and static geometry and region node in a region
local function hideGeom(regionName)
	setInstancedGeometryVisibility(regionName, false)
	setStaticGeometryVisibility(regionName, false)
	setRegionNodeVisibility(regionName, false)
end

-- shows an imposter billboard in a region
local function showImposter(regionName)
	setImposterVisibility(regionName, true)
end

-- hides an imposter billboard in a region
local function hideImposter(regionName)
	setImposterVisibility(regionName, false)
end

-- returns whether the given shape is the player's kart, since we only want the player to be affecting geometry
local function checkPlayer(shape)
	return player.Body == shape
end

-------------------------------------------

-- show buckets when entering, show bridge when leaving
local function startTriggerRegion(region, shape, flags)
	if checkPlayer(shape) then
		if isEnterFlag(flags) then
			showGeom("Buckets")
			hideImposter("Buckets")
		else
			showGeom("Bridge")
			hideImposter("Bridge")
		end
	end
end

-- show ramp when entering, hide barn and bridge when leaving
local function cliffTriggerRegion(region, shape, flags)
	if checkPlayer(shape) then
		if isEnterFlag(flags) then
			showGeom("Ramp")
			hideImposter("Ramp")
		else
			hideGeom("Barn")
			showImposter("Barn")
			
			hideGeom("Bridge")
			showImposter("Bridge")
		end
	end
end

-- show river when entering, hide start when leaving
local function bucketsTriggerRegion(region, shape, flags)
	if checkPlayer(shape) then
		if isEnterFlag(flags) then
			showGeom("River")
			hideImposter("River")
		else
			hideGeom("Start")
			showImposter("Start")
		end
	end
end

-- show treehouse when entering, hide cliff when leaving
local function rampTriggerRegion(region, shape, flags)
	if checkPlayer(shape) then
		if isEnterFlag(flags) then
			showGeom("Treehouse")
			hideImposter("Treehouse")
			
			hideGeom("Cliff")
			showImposter("Cliff")
		end
	end
end

-- hide buckets when entering, hide ramp when leaving
local function riverTriggerRegion(region, shape, flags)
	if checkPlayer(shape) then
		if isEnterFlag(flags) then
			hideGeom("Buckets")
			showImposter("Buckets")
		else
			hideGeom("Ramp")
			showImposter("Ramp")
		end
	end
end

-- show bridge when entering, hide river when leaving
local function treehouseTriggerRegion(region, shape, flags)
	if checkPlayer(shape) then
		if isEnterFlag(flags) then
			showGeom("Bridge")
			hideImposter("Bridge")
		else
			hideGeom("River")
			showImposter("River")
		end
	end
end

-- show barn when entering, hide treehouse when leaving
local function bridgeTriggerRegion(region, shape, flags)
	if checkPlayer(shape) then
		if isEnterFlag(flags) then
			showGeom("Barn")
			hideImposter("Barn")
		else
			hideGeom("Treehouse")
			showImposter("Treehouse")
		end
	end
end

-- show start and cliff when entering, hide bridge when leaving
local function barnTriggerRegion(region, shape, flags)
	if checkPlayer(shape) then
		if isEnterFlag(flags) then
			showGeom("Start")
			hideImposter("Start")
			
			showGeom("Cliff")
			hideImposter("Cliff")
		else
			hideGeom("Bridge")
			showImposter("Bridge")
		end
	end
end

-- none of our regions are rotated, so they all get the identity matrix
local iden = quat(0, 0, 0, 1)

-- create our regions!
createBoxTriggerRegion("startTriggerRegion", startTriggerRegion, vec(128.4655, 55.3625, 60.738), vec(-180.371, 43.273, 319.494), iden)
createBoxTriggerRegion("cliffTriggerRegion", cliffTriggerRegion, vec(65.189, 70.6485, 211.1895), vec(-318.423, 70.648, 75.149), iden)
createBoxTriggerRegion("bucketsTriggerRegion", bucketsTriggerRegion, vec(124.403, 63.056, 200.649), vec(-336.431, 52.028, -339.59), iden)
createBoxTriggerRegion("rampTriggerRegion", rampTriggerRegion, vec(168.823, 66.583, 155.504), vec(-242.448, 66.583, -696.777), iden)
createBoxTriggerRegion("riverTriggerRegion", riverTriggerRegion, vec(163.3765, 68.951, 157.602), vec(93.109, 56.093, -694.3), iden)
createBoxTriggerRegion("treehouseTriggerRegion", treehouseTriggerRegion, vec(100.9415, 72.3965, 237.368), vec(348.96, 72.397, -450.379), iden)
createBoxTriggerRegion("bridgeTriggerRegion", bridgeTriggerRegion, vec(178.2205, 54.084, 156.443), vec(149.331, 40.06, -53.333), iden)
createBoxTriggerRegion("barnTriggerRegion", barnTriggerRegion, vec(153.9025, 44.6625, 153.9025), vec(101.665, -33.559, 257.315), iden)

-- hide some things when we start up
hideGeom("Bridge")
showImposter("Bridge")
hideGeom("Treehouse")
showImposter("Treehouse")
hideGeom("River")
showImposter("River")
hideGeom("Ramp")
showImposter("Ramp")
hideGeom("Buckets")
showImposter("Buckets")