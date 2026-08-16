-- this is start-up panel

-- controls and gauges
defineProperty("starter_press", globalPropertyf("tu154b2/custom/gauges/eng/starter_press")) -- давление в системе запуска

defineProperty("starter_cap", globalPropertyi("tu154b2/custom/switchers/eng/starter_cap")) -- крышка панели запуска
defineProperty("starter_switch", globalPropertyi("tu154b2/custom/switchers/eng/starter_switch")) -- выключатель запуска
defineProperty("starter_eng_select", globalPropertyi("tu154b2/custom/switchers/eng/starter_eng_select")) -- выбор двигателя
defineProperty("starter_mode", globalPropertyi("tu154b2/custom/switchers/eng/starter_mode")) -- режим запуска

defineProperty("starter_start", globalPropertyi("tu154b2/custom/buttons/eng/starter_start")) -- кнопка запуска
defineProperty("starter_stop", globalPropertyi("tu154b2/custom/buttons/eng/starter_stop")) -- преркащения запуска

defineProperty("flight_start_1", globalPropertyi("tu154b2/custom/buttons/eng/flight_start_1")) -- запуск в полете
defineProperty("flight_start_2", globalPropertyi("tu154b2/custom/buttons/eng/flight_start_2")) -- запуск в полете
defineProperty("flight_start_3", globalPropertyi("tu154b2/custom/buttons/eng/flight_start_3")) -- запуск в полете

defineProperty("reserv_pump_test", globalPropertyi("tu154b2/custom/buttons/eng/reserv_pump_test")) -- проверка резерв топл насоса



-- lamps
defineProperty("apd_work_1", globalPropertyf("tu154b2/custom/lights/small/apd_work_1")) -- АПД работает
defineProperty("apd_work_2", globalPropertyf("tu154b2/custom/lights/small/apd_work_2")) -- АПД работает
defineProperty("apd_work_3", globalPropertyf("tu154b2/custom/lights/small/apd_work_3")) -- АПД работает


-- sources
defineProperty("bus27_volt_left", globalPropertyf("tu154b2/custom/elec/bus27_volt_left")) -- напряжение сети 27
defineProperty("bus27_volt_right", globalPropertyf("tu154b2/custom/elec/bus27_volt_right")) -- напряжение сети 27
defineProperty("bus36_volt_left", globalPropertyf("tu154b2/custom/elec/bus36_volt_left")) -- напряжение сети 36в лев
defineProperty("bus36_volt_right", globalPropertyf("tu154b2/custom/elec/bus36_volt_right")) -- напряжение сети 36в лев
-- time
defineProperty("frame_time", globalPropertyf("tu154b2/custom/time/frame_time")) -- flight time

defineProperty("starter_pressure", globalPropertyf("tu154b2/custom/start/starter_pressure")) -- двление в системе запуска

defineProperty("apd_working_1", globalPropertyf("tu154b2/custom/start/apd_working_1")) -- работа системы запуска
defineProperty("apd_working_2", globalPropertyf("tu154b2/custom/start/apd_working_2")) -- работа системы запуска
defineProperty("apd_working_3", globalPropertyf("tu154b2/custom/start/apd_working_3")) -- работа системы запуска
defineProperty("airstart", globalPropertyi("tu154b2/custom/engines/airstart"))
defineProperty("heat", globalPropertyi("sim/custom/b2/heating_starter"))

defineProperty("pilot_Z", globalPropertyf("sim/aircraft/view/acf_peZ"))
defineProperty("pilot_X", globalPropertyf("sim/aircraft/view/acf_peX"))
defineProperty("pilot_head", globalPropertyi("sim/graphics/view/pilots_head_psi"))



local switcher_sound_L = loadSample(moduleDirectory .. '/Custom Sounds/metal_switch_L.wav')
local skrip_sound_L = loadSample(moduleDirectory .. '/Custom Sounds/new_snds/lustra_skrip_L.wav')
local button_sound_L = loadSample(moduleDirectory .. '/Custom Sounds/plastic_btn_L.wav')

local switcher_sound_R = loadSample(moduleDirectory .. '/Custom Sounds/metal_switch_R.wav')
local skrip_sound_R = loadSample(moduleDirectory .. '/Custom Sounds/new_snds/lustra_skrip_R.wav')
local button_sound_R = loadSample(moduleDirectory .. '/Custom Sounds/plastic_btn_R.wav')

local panel_x=0.7595827
local panel_z=-20.73633
local dist_gain=5


local function inn_balance (src_x, src_z, x, z , cam_hdg)

	local hdg_rad = math.rad(cam_hdg)
	-- local x_s = acf_x + src_x * math.cos(hdg_rad) - src_z * math.sin(hdg_rad)
	-- local z_s = acf_z + src_x * math.sin(hdg_rad) + src_z * math.cos(hdg_rad)
	local dist = math.sqrt(math.pow(src_x - x, 2) + math.pow(src_z - z, 2))
	
	if dist < 1 then dist = 1 end
	
	local angle2source = cam_hdg + math.deg(math.atan2(x - src_x, z - src_z)) -- angle from camera to the source
	while angle2source > 180 do angle2source = angle2source - 360 end
	while angle2source < -180 do angle2source = angle2source + 360 end
	local ch_L = (0.2/math.pow(dist,2) + (1 + math.sin(math.rad(angle2source))) ) 
	local ch_R = (0.2/math.pow(dist,2) + (1 + math.sin(math.rad(-angle2source))) )
	if ch_L > 1 then ch_L = 1 end
	if ch_R > 1 then ch_R = 1 end

	
	-- local ch_L = 0.4 + (1 + math.sin(math.rad(cam_hdg))) * 0.7 * 0.6 + (1 - dist / 20)	
	
	-- local ch_R = 0.4 + (1 + math.sin(math.rad(-cam_hdg))) * 0.7 * 0.6 + (1 - dist / 20)
	
	return ch_L, ch_R
end


-- sounds
local switcher_sound = loadSample(moduleDirectory .. '/Custom Sounds/metal_switch.wav')
local cap_sound = loadSample(moduleDirectory .. '/Custom Sounds/cap.wav')
local button_sound = loadSample(moduleDirectory .. '/Custom Sounds/plastic_btn.wav')
local lustra_skrip_sound = loadSample(moduleDirectory .. '/Custom Sounds/new_snds/lustra_skrip.wav') --

local passed = 0

local starter_cap_last = get(starter_cap)

local starter_switch_last = get(starter_switch)
local starter_eng_select_last = get(starter_eng_select)
local starter_mode_last = get(starter_mode)

local starter_start_last = get(starter_start)
local starter_stop_last = get(starter_stop)
local flight_start_1_last = get(flight_start_1)
local flight_start_2_last = get(flight_start_2)
local flight_start_3_last = get(flight_start_3)
local heat_last=get(heat)
local reserv_pump_test_last = get(reserv_pump_test)

local function check_controls()

	local starter_cap_sw = get(starter_cap)
	
	local starter_switch_sw = get(starter_switch)
	local starter_eng_select_sw = get(starter_eng_select)
	local starter_mode_sw = get(starter_mode)
	local heat_sw=get(heat)
    
	local dist = -get(pilot_Z) + 9 
    
    
	----------------
	if starter_cap_sw - starter_cap_last ~= 0 then 
		local z_pos=get(pilot_Z)
		local z_pos=get(pilot_Z)
		local x_pos=get(pilot_X)
		local plt_hdg=get(pilot_head)
		local gain_L, gain_R = inn_balance (panel_x, panel_z, x_pos, z_pos , plt_hdg)
		gain_L=gain_L*1000
		gain_R=gain_R*1000
		local dist=1
		if z_pos-panel_z~=0 then
			dist=math.min(1,1/math.sqrt(math.pow(z_pos-panel_z,2)+math.pow(x_pos-panel_x,2))/dist_gain)
		end
		setSampleGain(skrip_sound_L,gain_L*dist)
		setSampleGain(skrip_sound_R,gain_R*dist)
		playSample(skrip_sound_L, false)
		playSample(skrip_sound_R, false)
	end
	
	----------------
	local switch_change = starter_switch_sw + starter_eng_select_sw + starter_mode_sw + heat_sw
	
	switch_change = switch_change - starter_switch_last - starter_eng_select_last - starter_mode_last - heat_last
	
	if switch_change ~= 0 then 
		local z_pos=get(pilot_Z)
		local z_pos=get(pilot_Z)
		local x_pos=get(pilot_X)
		local plt_hdg=get(pilot_head)
		local gain_L, gain_R = inn_balance (panel_x, panel_z, x_pos, z_pos , plt_hdg)
		gain_L=gain_L*1000
		gain_R=gain_R*1000
		local dist=1
		if z_pos-panel_z~=0 then
			dist=math.min(1,1/math.sqrt(math.pow(z_pos-panel_z,2)+math.pow(x_pos-panel_x,2))/dist_gain)
		end
		setSampleGain(switcher_sound_L,gain_L*dist)
		setSampleGain(switcher_sound_R,gain_R*dist)
		playSample(switcher_sound_L, false)
		playSample(switcher_sound_R, false)
	end
	
	----------------
	local starter_start_sw = get(starter_start)
	local starter_stop_sw = get(starter_stop)
	local flight_start_1_sw = get(flight_start_1)
	local flight_start_2_sw = get(flight_start_2)
	local flight_start_3_sw = get(flight_start_3)
	local reserv_pump_test_sw = get(reserv_pump_test)
	
	local button_change = starter_start_sw + starter_stop_sw + flight_start_1_sw + flight_start_2_sw + flight_start_3_sw + reserv_pump_test_sw
	
	button_change = button_change - starter_start_last - starter_stop_last - flight_start_1_last - flight_start_2_last - flight_start_3_last - reserv_pump_test_last
	
	if button_change ~= 0 then
	local z_pos=get(pilot_Z)
		local z_pos=get(pilot_Z)
		local x_pos=get(pilot_X)
		local plt_hdg=get(pilot_head)
		local gain_L, gain_R = inn_balance (panel_x, panel_z, x_pos, z_pos , plt_hdg)
		gain_L=gain_L*1000
		gain_R=gain_R*1000
		local dist=1
		if z_pos-panel_z~=0 then
			dist=math.min(1,1/math.sqrt(math.pow(z_pos-panel_z,2)+math.pow(x_pos-panel_x,2))/dist_gain)
		end
		setSampleGain(button_sound_L,gain_L*dist)
		setSampleGain(button_sound_R,gain_R*dist)
		playSample(button_sound_L, false)
		playSample(button_sound_R, false)
	end
	
	starter_cap_last = starter_cap_sw
	
	starter_switch_last = starter_switch_sw
	starter_eng_select_last = starter_eng_select_sw
	starter_mode_last = starter_mode_sw
	
	starter_start_last = starter_start_sw
	starter_stop_last = starter_stop_sw
	flight_start_1_last = flight_start_1_sw
	flight_start_2_last = flight_start_2_sw
	flight_start_3_last = flight_start_3_sw
	reserv_pump_test_last = reserv_pump_test_sw
	heat_last=heat_sw
end

local apd_1_timeout=0
local apd_2_timeout=0
local apd_3_timeout=0

local function lamps()
	--local test_btn = get(test_lamps)
	local lamps_brt = math.max((math.max(get(bus27_volt_left), get(bus27_volt_right)) - 10) / 18.5, 0)
	if (get(apd_working_1) ==1 or get(airstart)==1) and apd_1_timeout<1 then
		apd_1_timeout=1
	elseif apd_1_timeout>0 and get(apd_working_1) ==0 then
		apd_1_timeout=apd_1_timeout-passed/2
	end
	
	if get(apd_working_2) ==1 and apd_2_timeout<1 then
		apd_2_timeout=1
	elseif apd_2_timeout>0 and get(apd_working_2) ==0 then
		apd_2_timeout=apd_2_timeout-passed/2
	end
	
	if get(apd_working_3) ==1 and apd_3_timeout<1 then
		apd_3_timeout=1
	elseif apd_3_timeout>0 and get(apd_working_3) ==0 then
		apd_3_timeout=apd_3_timeout-passed/2
	end

	local apd_work_1_brt = bool2int(apd_1_timeout>0) * lamps_brt 
	set(apd_work_1, apd_work_1_brt)	
	
	local apd_work_2_brt = bool2int(apd_2_timeout>0) * lamps_brt 
	set(apd_work_2, apd_work_2_brt)	
	
	local apd_work_3_brt = bool2int(apd_3_timeout>0) * lamps_brt 
	set(apd_work_3, apd_work_3_brt)	
	

end

local start_press_act = 0

function update()

	passed = get(frame_time)
	check_controls()
	lamps()
	
	local start_press = 0
	if get(bus36_volt_left) > 30 and get(bus36_volt_right) > 30 then start_press = get(starter_pressure) end
	start_press_act = start_press_act + (start_press - start_press_act) * passed * 2
	
	set(starter_press, start_press_act)
	

end



