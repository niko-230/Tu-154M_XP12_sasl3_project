-- vapp_calc.lua
-- Real M-sourced dynamic approach-speed (Vзп) calculator, weight- and flap-corrected.
-- Source: "Tu-154M practical aerodynamic_Russian - 1997.pdf" (in the M donor repo),
-- table "Скорости захода на посадку в зависимости от посадочной массы и угла
-- отклонения закрылков (предкрылки выпущены)" -- user-uploaded 2026-08-19.
-- Structured after VisualFLT UNS donor's T154.ipad.lua pattern (dynamic weight-linked
-- VAPP), but this uses the real table values above instead of that project's own
-- (different-tuning) constants.

-- Real table: landing mass band midpoint (tonnes) -> {flap_angle -> Vзп km/h}
-- Row keys are the midpoint of each 2-tonne band from the source table (68-70 -> 69, etc).
local vapp_table = {
	{69,  {[0]=315, [15]=270, [28]=255, [36]=250, [45]=245}},
	{71,  {[0]=320, [15]=275, [28]=260, [36]=255, [45]=250}},
	{73,  {[0]=325, [15]=275, [28]=265, [36]=255, [45]=255}},
	{75,  {[0]=330, [15]=280, [28]=265, [36]=260, [45]=255}},
	{77,  {[0]=335, [15]=285, [28]=270, [36]=265, [45]=260}},
	{79,  {[0]=340, [15]=290, [28]=275, [36]=265, [45]=265}},
	{81,  {[0]=340, [15]=290, [28]=275, [36]=270, [45]=267}},
	{83,  {[0]=345, [15]=295, [28]=280, [36]=275, [45]=270}},
	{85,  {[0]=350, [15]=300, [28]=285, [36]=275, [45]=274}},
	{87,  {[0]=355, [15]=300, [28]=285, [36]=280, [45]=276}},
	{89,  {[0]=360, [15]=305, [28]=290, [36]=285, [45]=280}},
}
local flap_detents = {0, 15, 28, 36, 45}

-- linear interpolate y for x within a sorted list of {x, y} pairs, clamped at the ends
local function interp_pairs(pairs, x)
	if x <= pairs[1][1] then return pairs[1][2] end
	local n = #pairs
	if x >= pairs[n][1] then return pairs[n][2] end
	for i = 1, n-1 do
		local x0, y0 = pairs[i][1], pairs[i][2]
		local x1, y1 = pairs[i+1][1], pairs[i+1][2]
		if x >= x0 and x <= x1 then
			return y0 + (y1-y0) * (x-x0) / (x1-x0)
		end
	end
	return pairs[n][2]
end

-- Vзп(mass_t, flap_deg): full 2D interpolation -- first across flap angle within a mass
-- row (so any real flap position 0-45 gets a sensible value, not just the 5 detents),
-- then across mass rows for the given actual current landing mass in tonnes.
local function vapp_lookup(mass_t, flap_deg)
	local function row_vapp_at_flap(row, fd)
		local pairs = {}
		for _, d in ipairs(flap_detents) do
			table.insert(pairs, {d, row[d]})
		end
		return interp_pairs(pairs, fd)
	end

	if mass_t <= vapp_table[1][1] then
		return row_vapp_at_flap(vapp_table[1][2], flap_deg)
	end
	local n = #vapp_table
	if mass_t >= vapp_table[n][1] then
		return row_vapp_at_flap(vapp_table[n][2], flap_deg)
	end
	for i = 1, n-1 do
		local m0, row0 = vapp_table[i][1], vapp_table[i][2]
		local m1, row1 = vapp_table[i+1][1], vapp_table[i+1][2]
		if mass_t >= m0 and mass_t <= m1 then
			local v0 = row_vapp_at_flap(row0, flap_deg)
			local v1 = row_vapp_at_flap(row1, flap_deg)
			local f = (mass_t - m0) / (m1 - m0)
			return v0 + (v1 - v0) * f
		end
	end
	return row_vapp_at_flap(vapp_table[n][2], flap_deg)
end

-- Live inputs: real current gross weight (kg -> tonnes) and real current flap angle.
-- sim/flightmodel/weight/m_total is X-Plane's native live total-mass dataref -- always
-- correct regardless of any custom payload dataref sync issues found earlier today.
defineProperty("weight_total_kg", globalPropertyf("sim/flightmodel/weight/m_total"))
defineProperty("flap_angle_live", globalPropertyf("sim/flightmodel/controls/wing1l_fla1def")) -- matches flap_inn_L usage elsewhere in this project (real actual flap angle, not a custom anim dataref)

-- Output: live-computed real Vзп for the current actual weight and flap position,
-- and the 5 reference detent values at the current weight (for a chart-style EFB display).
createGlobalPropertyf("tu154b2/custom/efb/vapp_current", 0)
createGlobalPropertyf("tu154b2/custom/efb/vapp_0", 0)
createGlobalPropertyf("tu154b2/custom/efb/vapp_15", 0)
createGlobalPropertyf("tu154b2/custom/efb/vapp_28", 0)
createGlobalPropertyf("tu154b2/custom/efb/vapp_36", 0)
createGlobalPropertyf("tu154b2/custom/efb/vapp_45", 0)

defineProperty("vapp_current", globalPropertyf("tu154b2/custom/efb/vapp_current"))
defineProperty("vapp_0_out",  globalPropertyf("tu154b2/custom/efb/vapp_0"))
defineProperty("vapp_15_out", globalPropertyf("tu154b2/custom/efb/vapp_15"))
defineProperty("vapp_28_out", globalPropertyf("tu154b2/custom/efb/vapp_28"))
defineProperty("vapp_36_out", globalPropertyf("tu154b2/custom/efb/vapp_36"))
defineProperty("vapp_45_out", globalPropertyf("tu154b2/custom/efb/vapp_45"))

function update()
	local mass_t = (get(weight_total_kg) or 0) / 1000
	local flap_deg = get(flap_angle_live) or 0

	set(vapp_current, vapp_lookup(mass_t, flap_deg))
	set(vapp_0_out,  vapp_lookup(mass_t, 0))
	set(vapp_15_out, vapp_lookup(mass_t, 15))
	set(vapp_28_out, vapp_lookup(mass_t, 28))
	set(vapp_36_out, vapp_lookup(mass_t, 36))
	set(vapp_45_out, vapp_lookup(mass_t, 45))
end
