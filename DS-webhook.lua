local enableLog =menu.Switch("Webhook", "Debug", false, "Will log in console everytime hook function is executed")
local webHookURL = menu.TextBox("Webhook", "Webhook URL", 148, "", "Enter your webhook URL")



local hitboxes = {'Head','Neck','Pelvis','Stomach',
                    'Lower Chest', 'Chest','Upper Chest',
                    'Right Thigh', 'Left Thigh','Right Calf',
                    'Left Calf','Right Foot','Left Foot','Right Hand',
                    'Left Hand','Right Upper Arm','Right Forearm','Left Upper Arm',
                    'Left Forearm'}
					
local reasons = {'Hit','Resolver','Spread','Occlusion','Prediction Error'}



local function round(num, n) 

    return math.floor(num * 10^(n or 0) + 0.5) / 10^(n or 0)
    
end

local function hook(msg)

    http.PostAsync(string.format("%s", webHookURL:GetString()), 
    
    string.format("content=%s",msg), 

    function(urlContent)
        if enableLog:GetBool() then
            print('Tried pushing to webhook.')
        end
    end)

end

 

local function rageShot(e)

    shotHitchance = e.hitchance
    shotBacktrack = e.backtrack
    shotHitbox = hitboxes[e.hitgroup]
    shotDamage = e.damage
    playerIndex = e.target_index
    shotStatus = reasons[e.reason+1]

    targetEntity = g_EntityList:GetClientEntity(playerIndex)
    targetPlayerObject = targetEntity:GetPlayer()
    targetName = targetPlayerObject:GetName()

    if not (shotStatus == reasons[1]) then

        message = string.format('**[Neverlose]** Missed %s | [hc] %s | [backtrack] %s | [hitgroup] %s | [damage] %s | missed due to: %s', targetName, shotHitchance,
        shotBacktrack, shotHitbox, shotDamage, shotStatus)

        if shotStatus == reasons[3] then

            spreadDegree = e.spread_degree

            message = string.format('**[Neverlose]** Missed %s | [hc] %s | [backtrack] %s | [hitgroup] %s | [damage] %s | missed due to: %s | [spread] %s', targetName, shotHitchance,
            shotBacktrack, shotHitbox, shotDamage, shotStatus, round(spreadDegree, 2))

        end

    else

        message = string.format('**[Neverlose]** Hit %s | [hc] %s | [backtrack] %s | [hitgroup] %s | [damage] %s', targetName, shotHitchance,
        shotBacktrack, shotHitbox, shotDamage)


    end

    hook(message)

end

cheat.RegisterCallback("registered_shot", rageShot)