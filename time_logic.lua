-- this is time logic for all scripts

-- sim time
--defineProperty("sim_run_time", globalPropertyf("sim/time/total_flight_time_sec")) -- sim time
defineProperty("M", globalPropertyf("sim/flightmodel/position/M"))  -- some momentum of aircraft. it's remein one value, when sim paused
defineProperty("sim_run_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time
defineProperty("pse", globalPropertyi("sim/time/paused"))


defineProperty("frame_time", globalPropertyf("tu154b2/custom/time/frame_time")) -- flight time

local time_last = get(sim_run_time)  -- time for previous frame
local last_m = get(M)
-- local frame_time_last=0
-- local frame_time_last2=0
-- local frame_time_last3=0
-- local frame_time_last4=0
-- local frame_time_last5=0

function update()
	-- time calculations
	local time_now = get(sim_run_time)
	local passed = math.abs(time_now - time_last)
	--local curent_m = get(M)
	--print(passed)
	--if curent_m - last_m == 0 then passed = 0 end
	if passed > 0.1 then passed = 0.1 end
	if pse==1 then--passed+frame_time_last+frame_time_last2+frame_time_last3+frame_time_last4+frame_time_last5==0 then
		set(frame_time, 0)
	else
		set(frame_time, passed)
	end
		
	-- last variables
	time_last = time_now
	-- frame_time_last = passed
	-- frame_time_last2 = frame_time_last
	-- frame_time_last3 = frame_time_last2
	-- frame_time_last4 = frame_time_last3
	-- frame_time_last5 = frame_time_last4
	--last_m = curent_m
	
end


