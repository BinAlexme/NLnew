local strafer		= Menu.Switch("Legit Auto-Strafe", "Legit Strafer", false, "Bind this to your jump button.")
local wasd		= Menu.Switch("Legit Auto-Strafe", "WASD Check", true, "Do not strafe when you pressing WASD.")
local limit		= Menu.SliderInt("Legit Auto-Strafe", "Velocity Limit", 3, 1, 255, "Force disable strafing when vlocity less than in this slider.")
local vel		= Menu.Text("Legit Auto-Strafe", "1-3: standing, 3-150: walking, 150+: running.")
local autostrafe	= Menu.FindVar("Miscellaneous", "Main", "Movement", "Auto Strafe")

local ui_callback = function()
	local new_state = strafer:Get()

	limit:SetVisible(new_state)
	wasd:SetVisible(new_state)
	vel:SetVisible(new_state)
end
ui_callback()
strafer:RegisterCallback(ui_callback)

Cheat.RegisterCallback("pre_prediction", function(cmd)
	if autostrafe:Get() then return end
	if not strafer:Get() then return end

	local v1 = bit.band(cmd.buttons, 8) == 8
	local v2 = bit.band(cmd.buttons, 16) == 16
	local v3 = bit.band(cmd.buttons, 512) == 512
	local v4 = bit.band(cmd.buttons, 1024) == 1024
	local in_move = (v1 or v2 or v3 or v4)

	local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
	local velocity = Vector.new(localplayer:GetProp("DT_BasePlayer", "m_vecVelocity[0]"), localplayer:GetProp("DT_BasePlayer", "m_vecVelocity[1]"), localplayer:GetProp("DT_BasePlayer", "m_vecVelocity[2]")):Length2D()
	local onground = (bit.band(localplayer:GetProp("DT_BasePlayer", "m_fFlags"), 1) == 1)

	if localplayer:GetProp("DT_BasePlayer", "m_iHealth") <= 0 then return end
	if velocity < limit:Get() then return end
	if onground == true then return end
	if wasd:Get() then if in_move then return end end

	if cmd.mousedx > 1 or cmd.mousedx < -1 then
		if cmd.mousedx < 1 then cmd.sidemove = -450 end
		if cmd.mousedx > 1 then cmd.sidemove =  450 end
	end
end)