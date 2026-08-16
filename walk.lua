--[[require("bit")

local band = bit.band

local view_id = 0

local CAMERA_STATUS_TRANSISION_IN_PROGRESS = 16 -- bit 5 indicates that a transition is in progress
local CAMERA_STATUS_CONTROL_PANEL_OPEN = 8 -- Bit 4 indicates that the control panel is open
local AIRPORT_CAMERA = 4		-- Bit 3 of the camera status indicates it is an airport camera
local CAMERA_SELECTED = 2		-- Bit 2 indicates the camera is selected
local CAMERA_PRESENT = 1		-- Bit 1 indicates camera is present
local CAMERA_PRESENT_AND_SELECTED = CAMERA_SELECTED + CAMERA_PRESENT

local CAMERA_X = globalPropertyf("SRS/X-Camera/integration/effect_script_x_offset")
local CAMERA_Y = globalPropertyf("SRS/X-Camera/integration/effect_script_y_offset")
local CAMERA_Z = globalPropertyf("SRS/X-Camera/integration/effect_script_z_offset")
local CAMERA_ROLL = globalPropertyf("SRS/X-Camera/integration/effect_script_roll_offset")
local CAMERA_HEADING = globalPropertyf("SRS/X-Camera/integration/effect_script_heading_offset")
local CAMERA_PITCH = globalPropertyf("SRS/X-Camera/integration/effect_script_pitch_offset")
local CAMERA_STATUS = globalPropertyf("SRS/X-Camera/integration/effect_script_id")

local GLOBAL_STATUS = globalPropertyf("SRS/X-Camera/integration/overall_status")]]

--[[
	WalkAround plugin for Xplane-12
	Version 2.3 29/01/2023
	CopyRight by Raoul Origa
]]

cameraHeading = 0.0
cameraPitch = 0.0
cameraDistance = 200.0
cameraAdvance = 0.2

local walkSpeed = 5
--local walkDirection = heading
local forward = 0.1
local forwardX = 0.1
local forwardZ = 0.1
local back = 0.1
local left = 0.1
local right = 0.1

local tmp = 0

local black	    = {0, 0, 0, 1}
local cyan	    = {0, 1, 1, 1}
local magenta	= {1, 0, 1, 1}
local yellow	= {1, 1, 0, 1}
local red       = {1, 0, 0, 1}
local white     = {1, 1, 1, 1}

local fnt = loadFont('basic_font.fnt')
local enabled = "Start Walking"

local cameraShake = "Disable"

function draw()
	drawRectangle ( -35, 19, 250, 35, white)
	drawRectangle ( -95, -30, 370, 40, white)
	drawRectangle ( -100, 90, 390, 200, white)
	drawText(fnt, 90, 25, enabled, 30, false, false, 0, black)
	drawText(fnt, 90, -10, "Follow me on my youtube chanel", 15, false, false, 0, black)
	drawText(fnt, 90, -25, "https://www.youtube.com/@plane.spotting", 15, false, false, 0, black)
	drawText(fnt, 100, 320, "WalkAround", 50, false, false, 0, white)
	drawText(fnt, 85, 260, "Description", 20, false, false, 0, red)
	drawText(fnt, 95, 230, "W, S, A, D is for movement", 20, false, false, 0, black)
	drawText(fnt, 27, 200, "F is for crouch", 20, false, false, 0, black)
	drawText(fnt, 80, 170, "Esc for disable the walk", 20, false, false, 0, black)
	drawText(fnt, 93, 140, "For start click start walk", 20, false, false, 0, black)
	drawText(fnt, 300, -75, "Version: 2.3.2", 10, false, false, 0, white)
	drawText(fnt, 300, -90, "29/01/2023", 10, false, false, 0, white)
	drawText(fnt, -100, -90, "by Raoul Origa", 10, false, false, 0, white)
end
local test = get("sim/flightmodel/parts/tire_y_no_deflection")

--local p_mtrs = 

local elevation

--local elevation = get(globalPropertyf("sim/graphics/view/view_elevation_agl_mtrs"))
local cabinHeight = get(globalPropertyf("sim/aircraft/view/acf_door_y"))
local currentHeight = 0
local initialPilotHeight = get(globalPropertyf("sim/graphics/view/pilots_head_y"))
local statusHeight = 1

local maxHeight = 1.75
local minHeight = 0.7
local middleHeight = (maxHeight + minHeight) / 2

local walk = 0

local iswalking = false

local path = ""
local xCamera = findPluginByPath (path)

walkSound = loadSample("Sounds/WalkSound.wav")

if isProperty(globalPropertyf("sim/graphics/view/view_elevation_agl_mtrs")) then
	logDebug("metri")
	elevation = get(globalPropertyf("sim/graphics/view/view_elevation_agl_mtrs"))
else
	logDebug("piedi")
	elevation = get(globalPropertyf("sim/flightmodel/position/y_agl")) * 0.3048 + maxHeight
end

local switch = {
	[1] = function()    -- for case 1
		currentHeight = (initialPilotHeight - elevation) + maxHeight
		statusHeight = statusHeight + 1
	end,
	[2] = function()    -- for case 2
		currentHeight = (initialPilotHeight - elevation) + middleHeight
		statusHeight = statusHeight + 1
	end,
	[3] = function()    -- for case 3
		currentHeight = (initialPilotHeight - elevation) +  minHeight
		statusHeight = 1
	end
}

switch[statusHeight]()

function update()
	if iswalking == true and settings.sound == true then
		if not isSamplePlaying(walkSound) then playSample(walkSound) end
	else
		stopSample(walkSound)
	end

	print("mtrs:" .. get(globalPropertyf("sim/graphics/view/view_elevation_agl_mtrs")))
	print("agl:" .. get(globalPropertyf("sim/flightmodel/position/y_agl")) * 0.3048 + maxHeight)
end

local function process_key(char, vkey, shift, ctrl, alt, event)
	if event == KB_DOWN_EVENT then
		if char == SASL_KEY_ESCAPE or char == SASL_KEY_RETURN then
			enabled = "Start Walking"
			return true
		end
		
		local acf_peY = globalPropertyf("sim/graphics/view/pilots_head_y")

		if vkey == SASL_VK_F then
			local f = switch[statusHeight]
			if f then
				f()
			end
			set(acf_peY, currentHeight)
		end
	end

	if event == KB_UP_EVENT then
		iswalking = false
		walk = 0
	end

	if event == KB_HOLD_EVENT then
		if vkey == SASL_VK_W then
			--local inclination = globalPropertyf("sim/graphics/view/pilots_head_phi")
			local acf_peX = globalPropertyf("sim/graphics/view/pilots_head_x")
			local acf_peZ = globalPropertyf("sim/graphics/view/pilots_head_z")
			local acf_peY = globalPropertyf("sim/graphics/view/pilots_head_y")
			local heading = globalPropertyf("sim/graphics/view/pilots_head_psi")
			local roll = globalPropertyf("sim/graphics/view/field_of_view_roll_deg")
			local distance = .04

			local x = get(acf_peX)
			local z = get(acf_peZ)
			local angle = math.rad( get(heading ) - 90 )
			local sinX = x + distance * math.cos( angle )
			local sinZ = z + distance * math.sin( angle )
			set(acf_peZ, sinZ)
			set(acf_peX, sinX)
			--set(inclination, angle * math.cos(angle) * 2)
			set(roll, 0)
			iswalking = true
			if settings.walk_movement == true then 
				local sinWalk = math.sin(walk)
				set(acf_peY, currentHeight + (sinWalk * .015))
			end
			walk = walk + .6
		end

		if vkey == SASL_VK_S then
			--local inclination = globalPropertyf("sim/graphics/view/pilots_head_phi")
			local acf_peX = globalPropertyf("sim/graphics/view/pilots_head_x")
			local acf_peZ = globalPropertyf("sim/graphics/view/pilots_head_z")
			local acf_peY = globalPropertyf("sim/graphics/view/pilots_head_y")
			local heading = globalPropertyf("sim/graphics/view/pilots_head_psi")
			local roll = globalPropertyf("sim/graphics/view/field_of_view_roll_deg")
			local distance = .04

			local x = get(acf_peX)
			local z = get(acf_peZ)
			local angle = math.rad( get(heading ) - 90 )
			local sinX = x - distance * math.cos( angle )
			local sinZ = z - distance * math.sin( angle )
			set(acf_peZ, sinZ)
			set(acf_peX, sinX)
			--set(inclination, 0)
			set(roll, 0)
			iswalking = true
			if settings.walk_movement == true then
				local sinWalk = math.sin(walk)
				set(acf_peY, currentHeight + (sinWalk * .03))
			end
			walk = walk + .6
		end

		if vkey == SASL_VK_D then
			local inclination = globalPropertyf("sim/graphics/view/pilots_head_phi")
			local acf_peX = globalPropertyf("sim/graphics/view/pilots_head_x")
			local acf_peZ = globalPropertyf("sim/graphics/view/pilots_head_z")
			local acf_peY = globalPropertyf("sim/graphics/view/pilots_head_y")
			local heading = globalPropertyf("sim/graphics/view/pilots_head_psi")
			local roll = globalPropertyf("sim/graphics/view/field_of_view_roll_deg")
			local distance = .04

			local x = get(acf_peX)
			local z = get(acf_peZ)
			local angle = math.rad( get(heading ) )
			local sinX = x + distance * math.cos( angle )
			local sinZ = z + distance * math.sin( angle )
			set(acf_peZ, sinZ)
			set(acf_peX, sinX)
			set(inclination, 0)
			set(roll, 0)
			iswalking = true
			if settings.walk_movement == true then
				local sinWalk = math.sin(walk)
				set(acf_peY, currentHeight + (sinWalk * .03))
			end
			walk = walk + .6
		end

		if vkey == SASL_VK_A then
			--local inclination = globalPropertyf("sim/graphics/view/pilots_head_phi")
			local acf_peX = globalPropertyf("sim/graphics/view/pilots_head_x")
			local acf_peZ = globalPropertyf("sim/graphics/view/pilots_head_z")
			local acf_peY = globalPropertyf("sim/graphics/view/pilots_head_y")
			local heading = globalPropertyf("sim/graphics/view/pilots_head_psi")
			local roll = globalPropertyf("sim/graphics/view/field_of_view_roll_deg")
			local distance = .04

			local x = get(acf_peX)
			local z = get(acf_peZ)
			local angle = math.rad( get(heading ) )
			local sinX = x - distance * math.cos( angle )
			local sinZ = z - distance * math.sin( angle )
			set(acf_peZ, sinZ)
			set(acf_peX, sinX)
			--set(inclination, 0)
			set(roll, 0)
			iswalking = true
			if settings.walk_movement == true then
				local sinWalk = math.sin(walk)
				set(acf_peY, currentHeight + (sinWalk * .03))
			end
			walk = walk + .6
		end
	end

	return false
end

function onMouseDown(button)
	enabled = "Stop Walking"
	register_handler(process_key)
	return true
end