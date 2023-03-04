-- Fight information referenced from:
-- https://www.warcrafttavern.com/wotlk/guides/naxxramas-25/


ClassColors = {
    ["Death Knight"] = { r = 0.77, g = 0.12, b = 0.23 },
    ["Druid"] = { r = 1.00, g = 0.49, b = 0.04 },
    ["Hunter"] = { r = 0.67, g = 0.83, b = 0.45 },
    ["Mage"] = { r = 0.25, g = 0.78, b = 0.92 },
    ["Paladin"] = { r = 0.96, g = 0.55, b = 0.73 },
    ["Priest"] = { r = 1.00, g = 1.00, b = 1.00 },
    ["Rogue"] = { r = 1.00, g = 0.90, b = 0.41 },
    ["Shaman"] = { r = 0.00, g = 0.44, b = 0.87 },
    ["Warlock"] = { r = 0.53, g = 0.53, b = 0.93 },
    ["Warrior"] = { r = 0.78, g = 0.61, b = 0.43 },
}

-- Main key is the NPC ID. If you search wowhead it'll be the id in the URL
-- Within this:
--    Text - This is information for all. Basic short description of mechanice.
--    Class (e.g. Rogue) - Any information specific to the class
--    Role [TANK, HEALER, DAMAGER] - Information specific to a role. Need role defined in group or raid

BossTipInfo = {
    -- This first one is provided as an example and easy test within Stormwind
    [1325] = {
        Text = "Jasper is a shady dealer of poisons in the secretive SI:7 area of Stormwind city.",
        Rogue = "This guy provides poisons for you",
    },
    [15956] = { -- Anub'Rekhan Naxxramas 15956
        Text = "Don't stand in front of Crypt Guards unless you are off-tank. " ..
            "Don't line up with others to avoid Impale hitting multiple targets. " ..
            "Stay away from boss during Locust Swarm. " ..
            "Help handle Corpse Scarabs however you can.",
        TANK = "Main-Tank:\n" ..
            "Kite during Locust Swarm, staying at least 30-yards away from Anub'Rekhan. " ..
            "Avoid being in front of the Crypt Guards so you don't get hit by Cleave.\n" ..
            "Off-Tank:\n" ..
            "Keep the Crypt Guards facing away from everyone but yourself. " ..
            "Pick up Corpse Scarabs whenever possible. " ..
            "Run to the opposite side of where your main-tank goes during Locust SwarmLocust Swarm",
        HEALER = "Stay at least 30-yards away from Anub'Rekhan during Locust Swarm",
        DAMAGER = "Prioritize Crypt Guards during Locust Swarm. " ..
            "Stay at least 30-yards away from Anub'Rekhan during Locust Swarm."
    },
    [16028] = { -- Patchwerk Naxxramas 16028
        Text = "Basic tank and spank, DPS check.\n" ..
            "Clear the room thoroughly before engaging, fight away from the green river and slimes. " ..
            "If you aren't a tank, make sure you are not in front of the boss!" ..
            "Save your cooldowns to make sure they're up for Frenzy.",
        TANK = "Keep your eye on threat, you need to be in the top 3. " ..
            "Make sure your health is always high, use Healthstones and self heals if necessary — a tank death likely means a wipe. " ..
            "Use defensive cooldowns to deal with Hateful StrikeHateful Strikes. " ..
            "FrenzyFrenzy is the most important time for defensives. You'll want to use your biggest defensive cooldowns when Patchwerk enrages! " ..
            "If you reach the BerserkBerserk phase, use defensives and keep your health high, this is now a dire situation and Patchwerk can no longer be taunted",
        HEALER = "Be proactive with healing, every swing will take a big chunk out of your tanks.",
        DAMAGER = "This fight is all about doing as much damage as you possibly can — " ..
            "you only have to worry about your damage and threat here",
    },
    [15990] = { -- Kel'Thuzad Naxxramas 15990
        Text = "Phase 1\n" ..
            "Avoid getting close to Soul Weaver and Soldier of the Frozen Wastes, deal with them exclusively at range. " ..
            "Try to stay close to the center of the room to not accidentally pull enemies into melee range.\n" ..
            "Phase 2\n" ..
            "Make sure you are always 10-yards away from other players. " ..
            "If you are closer to the melee stacks, make sure they have room to get away from their stack. " ..
            "Always be ready to interrupt FrostboltFrostbolt, even if you are not assigned to interrupting. " ..
            "Always be ready to crowd-control targets hit by Chains of Kel'ThuzadChains of Kel'Thuzad if you are able to. " ..
            "Save your cooldowns for 45% Health, including BloodlustBloodlust/HeroismHeroism.",
        
    }
}

local function OnTooltipSetUnit(self)
    -- Don't show massive tooltips in combat
    if(UnitAffectingCombat("player")) then return; end

    local _, unit = self:GetUnit();

    if (unit) then
        -- THe NPC ID is hidden away within the unit guid, so get it from there
        local _, _, _, _, _, npcID = strsplit('-', UnitGUID(unit))
        if (npcID) then
            local info = BossTipInfo[tonumber(npcID)];
            if (info) then
                -- Look for generic information
                if (info.Text) then
                    self:AddLine(info["Text"], 0.0, 0.55, 0.5, true);
                end

                local class = UnitClass("player");
                local classColor = ClassColors[class];
                if (classColor) then
                    -- Look for role information
                    local role = UnitGroupRolesAssigned("player");
                    if (role == "NONE") then role = "DAMAGER"; end
                    if (info[role]) then
                        self:AddLine(info[role], classColor.r, classColor.g, classColor.b, true);
                    end

                    -- Look for class information
                    if (info[class]) then
                        self:AddLine(class .. ": " .. info[class], classColor.r, classColor.g, classColor.b, true);
                    end
                end

                self:Show();
            end
        end
    end
end

GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit);
