-- this is fuel to engines logic

-- controls
defineProperty("fire_valve_1", globalPropertyi("tu154b2/custom/switchers/fuel/fire_valve_1")) -- пожарный кран
defineProperty("fire_valve_2", globalPropertyi("tu154b2/custom/switchers/fuel/fire_valve_2")) -- пожарный кран
defineProperty("fire_valve_3", globalPropertyi("tu154b2/custom/switchers/fuel/fire_valve_3")) -- пожарный кран

-- pumps
defineProperty("pump_tank1_1_work", globalPropertyi("tu154b2/custom/fuel/pump_tank1_1_work"))
defineProperty("pump_tank1_2_work", globalPropertyi("tu154b2/custom/fuel/pump_tank1_2_work"))
defineProperty("pump_tank1_3_work", globalPropertyi("tu154b2/custom/fuel/pump_tank1_3_work"))
defineProperty("pump_tank1_4_work", globalPropertyi("tu154b2/custom/fuel/pump_tank1_4_work"))

-- mixture hamdles
defineProperty("eng_mix_1", globalProperty("sim/cockpit2/engine/actuators/mixture_ratio[0]")) -- положение рычагов смеси в симе
defineProperty("eng_mix_2", globalProperty("sim/cockpit2/engine/actuators/mixture_ratio[1]")) -- положение рычагов смеси в симе
defineProperty("eng_mix_3", globalProperty("sim/cockpit2/engine/actuators/mixture_ratio[2]")) -- положение рычагов смеси в симе

-- animation
defineProperty("fuel_cutoff_1", globalPropertyf("tu154b2/custom/controlls/fuel_cutoff_1")) -- рычаг пожарного крана
defineProperty("fuel_cutoff_2", globalPropertyf("tu154b2/custom/controlls/fuel_cutoff_2")) -- рычаг пожарного крана
defineProperty("fuel_cutoff_3", globalPropertyf("tu154b2/custom/controlls/fuel_cutoff_3")) -- рычаг пожарного крана

-- time
defineProperty("frame_time", globalPropertyf("tu154b2/custom/time/frame_time")) -- flight time

-- results
defineProperty("eng_fuel_press_1", globalPropertyi("tu154b2/custom/fuel/eng_fuel_press_1")) -- топливо может быть подано в двигатель. без учета стоп-кранов
defineProperty("eng_fuel_press_2", globalPropertyi("tu154b2/custom/fuel/eng_fuel_press_2")) -- топливо может быть подано в двигатель. без учета стоп-кранов
defineProperty("eng_fuel_press_3", globalPropertyi("tu154b2/custom/fuel/eng_fuel_press_3")) -- топливо может быть подано в двигатель. без учета стоп-кранов

defineProperty("fire_vlv_open_1", globalPropertyf("tu154b2/custom/fuel/fire_vlv_open_1")) -- пожарный кран открыт
defineProperty("fire_vlv_open_2", globalPropertyf("tu154b2/custom/fuel/fire_vlv_open_2")) -- пожарный кран открыт
defineProperty("fire_vlv_open_3", globalPropertyf("tu154b2/custom/fuel/fire_vlv_open_3")) -- пожарный кран открыт

defineProperty("engine_1_fuel", globalPropertyf("sim/operation/failures/rel_fuepmp0")) -- полное перекрытие топлива в двигатели
defineProperty("engine_2_fuel", globalPropertyf("sim/operation/failures/rel_fuepmp1")) -- полное перекрытие топлива в двигатели
defineProperty("engine_3_fuel", globalPropertyf("sim/operation/failures/rel_fuepmp2")) -- полное перекрытие топлива в двигатели

defineProperty("engine_1_fuel2", globalPropertyf("sim/operation/failures/rel_ele_fuepmp0")) -- полное перекрытие топлива в двигатели
defineProperty("engine_2_fuel2", globalPropertyf("sim/operation/failures/rel_ele_fuepmp1")) -- полное перекрытие топлива в двигатели
defineProperty("engine_3_fuel2", globalPropertyf("sim/operation/failures/rel_ele_fuepmp2")) -- полное перекрытие топлива в двигатели


defineProperty("rt1_stop", globalPropertyi("tu154b2/custom/SC/engine/rt_stop1"))
defineProperty("rt2_stop", globalPropertyi("tu154b2/custom/SC/engine/rt_stop2"))
defineProperty("rt3_stop", globalPropertyi("tu154b2/custom/SC/engine/rt_stop3"))


-- failures
defineProperty("eng_fuel_pmp_fail_1", globalPropertyi("tu154b2/custom/failures/eng_fuel_pmp_fail_1"))
defineProperty("eng_fuel_pmp_fail_2", globalPropertyi("tu154b2/custom/failures/eng_fuel_pmp_fail_2"))
defineProperty("eng_fuel_pmp_fail_3", globalPropertyi("tu154b2/custom/failures/eng_fuel_pmp_fail_3"))

defineProperty("eng_fuel_fluctuation_1", globalPropertyi("sim/operation/failures/rel_fuelfl0"))
defineProperty("eng_fuel_fluctuation_2", globalPropertyi("sim/operation/failures/rel_fuelfl1"))
defineProperty("eng_fuel_fluctuation_3", globalPropertyi("sim/operation/failures/rel_fuelfl2"))


--defineProperty("igniter_on_1", globalPropertyi("sim/cockpit2/engine/actuators/igniter_on[0]"))

defineProperty("fuel_in_1", globalPropertyi("tu154b2/custom/start/fuel_in_1")) -- подача топлива от системы запуска
defineProperty("fuel_in_2", globalPropertyi("tu154b2/custom/start/fuel_in_2")) -- подача топлива от системы запуска
defineProperty("fuel_in_3", globalPropertyi("tu154b2/custom/start/fuel_in_3")) -- подача топлива от системы запуска


defineProperty("elevation", globalPropertyf("sim/flightmodel2/position/pressure_altitude"))
defineProperty("fill_1", globalPropertyf("tu154b2/custom/fuel/line_1_filled"))
defineProperty("fill_2", globalPropertyf("tu154b2/custom/fuel/line_2_filled"))
defineProperty("fill_3", globalPropertyf("tu154b2/custom/fuel/line_3_filled"))

defineProperty("pilot_Z", globalPropertyf("sim/aircraft/view/acf_peZ"))
defineProperty("pilot_X", globalPropertyf("sim/aircraft/view/acf_peX"))
defineProperty("pilot_head", globalPropertyi("sim/graphics/view/pilots_head_psi"))



-- Smart Copilot
defineProperty("ismaster", globalPropertyf("scp/api/ismaster")) -- Master. 0 = plugin not found, 1 = slave 2 = master
defineProperty("hascontrol_1", globalPropertyf("scp/api/hascontrol_1")) -- Have control. 0 = plugin not found, 1 = no control 2 = has control


local rod_on_L = loadSample(moduleDirectory .. '/Custom Sounds/ROD_ON_L.wav')
local rod_off_L = loadSample(moduleDirectory .. '/Custom Sounds/ROD_OFF_L.wav')
local rod_on_R = loadSample(moduleDirectory .. '/Custom Sounds/ROD_ON_R.wav')
local rod_off_R = loadSample(moduleDirectory .. '/Custom Sounds/ROD_OFF_R.wav')

local panel_x=0.60329795
local panel_z=-21.737131
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


local valve_1 = 0.7
local valve_2 = 0.7
local valve_3 = 0.7

local press_count_1 = 1
local press_count_2 = 1
local press_count_3 = 1

local mix_1_last = get(eng_mix_1)
local mix_2_last = get(eng_mix_2)
local mix_3_last = get(eng_mix_3)


function update()

	local passed = get(frame_time)
	
	-- mixture logic
	local mix_1 = get(eng_mix_1)
	local mix_2 = get(eng_mix_2)
	local mix_3 = get(eng_mix_3)
	
	-- set animation
	set(fuel_cutoff_1, mix_1)
	set(fuel_cutoff_2, mix_2)
	set(fuel_cutoff_3, mix_3)
	
	-- set sound
	if mix_1 ~= mix_1_last and mix_1 == 1 then 
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
		setSampleGain(rod_on_L,gain_L*dist)
		setSampleGain(rod_on_R,gain_R*dist)
		playSample(rod_on_L, false)
		playSample(rod_on_R, false)
	elseif mix_1 ~= mix_1_last and mix_1_last == 1 then 
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
		setSampleGain(rod_off_L,gain_L*dist)
		setSampleGain(rod_off_R,gain_R*dist)
		playSample(rod_off_L, false)
		playSample(rod_off_R, false)
	end
	
	if mix_2 ~= mix_2_last and mix_2 == 1 then 
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
		setSampleGain(rod_on_L,gain_L*dist)
		setSampleGain(rod_on_R,gain_R*dist)
		playSample(rod_on_L, false)
		playSample(rod_on_R, false)
	elseif mix_2 ~= mix_2_last and mix_2_last == 1 then 
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
		setSampleGain(rod_off_L,gain_L*dist)
		setSampleGain(rod_off_R,gain_R*dist)
		playSample(rod_off_L, false)
		playSample(rod_off_R, false)
	end
	
	if mix_3 ~= mix_3_last and mix_3 == 1 then 
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
		setSampleGain(rod_on_L,gain_L*dist)
		setSampleGain(rod_on_R,gain_R*dist)
		playSample(rod_on_L, false)
		playSample(rod_on_R, false)
	elseif mix_3 ~= mix_3_last and mix_3_last == 1 then 
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
		setSampleGain(rod_off_L,gain_L*dist)
		setSampleGain(rod_off_R,gain_R*dist)
		playSample(rod_off_L, false)
		playSample(rod_off_R, false)
	end
	
	
	
	mix_1_last = mix_1
	mix_2_last = mix_2
	mix_3_last = mix_3
	
	
	-- fire valves logic
	valve_1 = valve_1 + (get(fire_valve_1) * 2 - 1) * passed * 0.5
	valve_2 = valve_2 + (get(fire_valve_2) * 2 - 1) * passed * 0.5
	valve_3 = valve_3 + (get(fire_valve_3) * 2 - 1) * passed * 0.5

	-- set limits
	if valve_1 > 1 then valve_1 = 1
	elseif valve_1 < 0 then valve_1 = 0 end
	
	if valve_2 > 1 then valve_2 = 1
	elseif valve_2 < 0 then valve_2 = 0 end
	
	if valve_3 > 1 then valve_3 = 1
	elseif valve_3 < 0 then valve_3 = 0 end
	
	-- calculate pressure
	local press_1 = get(eng_fuel_press_1)
	local press_2 = get(eng_fuel_press_2)
	local press_3 = get(eng_fuel_press_3)
	local filled_1=get(fill_1)
	local filled_2=get(fill_2)
	local filled_3=get(fill_3)
	
	if get(pump_tank1_1_work) + get(pump_tank1_2_work) + get(pump_tank1_3_work) + get(pump_tank1_4_work) > 0 then
		if filled_1<1 then
			filled_1=filled_1+passed/2
		end
		if valve_1 > 0.7 then
			press_count_1 = press_count_1 + passed * 0.2
			if press_count_1 > 1 then
				press_count_1 = 1 
				press_1 = 1 
			end
		else 
			press_count_1 = 0
			press_1 = 0 
		end
		if filled_2<1 then
			filled_2=filled_2+passed/2
		end
		if valve_2 > 0.7 then 
			press_count_2 = press_count_2 + passed * 0.2
			if press_count_2 > 1 then 
				press_count_2 = 1
				press_2 = 1
			end
		else 
			press_count_2 = 0 
			press_2 = 0 
		end
		if filled_3<1 then
			filled_3=filled_3+passed/2
		end
		if valve_3 > 0.7 then 
			press_count_3 = press_count_3 + passed * 0.2
			if press_count_3 > 1 then 
				press_count_3 = 1 
				press_3 = 1 
			end
		else press_count_3 = 0 press_3 = 0 end
		
		
	else
		press_1 = 0
		press_2 = 0
		press_3 = 0
		
		press_count_1 = 0
		press_count_2 = 0
		press_count_3 = 0
	end


local MSL = get(elevation)*0.3048

local MASTER = get(ismaster) ~= 1	
	

if MASTER then	

	
	-- cut fuel when fire valves and mixture levers are closed
	if mix_1 < 0.6 or valve_1 < 0.5 or get(fuel_in_1) == 0 or (press_1 == 0 and (get(eng_fuel_pmp_fail_1) == 1 or MSL > 9500)) or get(rt1_stop)==1 then 
		set(engine_1_fuel, 6) set(engine_1_fuel2, 6)
	else set(engine_1_fuel, 0) set(engine_1_fuel2, 0) end
	
	if mix_2 < 0.6 or valve_2 < 0.5 or get(fuel_in_2) == 0 or (press_2 == 0 and (get(eng_fuel_pmp_fail_2) == 1 or MSL > 9500)) or get(rt2_stop)==1 then 
		set(engine_2_fuel, 6) set(engine_2_fuel2, 6)
	else set(engine_2_fuel, 0) set(engine_2_fuel2, 0) end
	
	if mix_3 < 0.6 or valve_3 < 0.5 or get(fuel_in_3) == 0 or (press_3 == 0 and (get(eng_fuel_pmp_fail_3) == 1 or MSL > 9500)) or get(rt3_stop)==1 then 
		set(engine_3_fuel, 6) set(engine_3_fuel2, 6)
	else set(engine_3_fuel, 0) set(engine_3_fuel2, 0) end
	
	
	-- set fuel fluctuation
	set(eng_fuel_fluctuation_1, 6 * bool2int(press_1 == 0 and MSL > 7000))
	set(eng_fuel_fluctuation_2, 6 * bool2int(press_2 == 0 and MSL > 7000))
	set(eng_fuel_fluctuation_3, 6 * bool2int(press_3 == 0 and MSL > 7000))
	
	-- set results
	set(eng_fuel_press_1, press_1)
	set(eng_fuel_press_2, press_2)
	set(eng_fuel_press_3, press_3)
	
	set(fire_vlv_open_1, valve_1)
	set(fire_vlv_open_2, valve_2)
	set(fire_vlv_open_3, valve_3)
	
	set(fill_1,filled_1)
	set(fill_2,filled_2)
	set(fill_3,filled_3)

end


end