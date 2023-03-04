ClassColors = {
    ["Death Knight"] = {r=0.77, g=0.12, b=0.23},
    ["Druid"] = {r=1.00, g=0.49, b=0.04},
    ["Hunter"] = {r=0.67, g=0.83, b=0.45},
    ["Mage"] = {r=0.25, g=0.78, b=0.92},
    ["Paladin"] = {r=0.96, g=0.55, b=0.73},
    ["Priest"] = {r=1.00, g=1.00, b=1.00},
    ["Rogue"] = {r=1.00, g=0.90, b=0.41},
    ["Shaman"] = {r=0.00, g=0.44, b=0.87},
    ["Warlock"] = {r=0.53, g=0.53, b=0.93},
    ["Warrior"] = {r=0.78, g=0.61, b=0.43},
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
    [16028] = { -- PATCHWERK NAXXRAMAS
        Text = "Basic tank and spank. Kind of a DPS check",
    },
}

local function OnTooltipSetUnit(self)
    local _, unit = self:GetUnit();

    if (unit) then
        -- THe NPC ID is hidden away within the unit guid, so get it from there
        local _, _, _, _, _, npcID = strsplit('-', UnitGUID(unit))
        if (npcID) then
            local info = BossTipInfo[tonumber(npcID)];
            if (info) then
                -- Look for generic information
                if(info.Text) then
                    self:AddLine(info["Text"], 0.0, 0.55, 0.5, true);
                end

                -- Look for class information
                local class = UnitClass("player");
                if(info[class]) then
                    local classColor = ClassColors[class];
                    if (classColor) then
                        self:AddLine(class..": ".. info[class], classColor.r, classColor.g, classColor.b, true);
                    end
                end

                -- Look for role information
                local role = UnitGroupRolesAssigned("player");
                if(info[role]) then
                    self:AddLine(info[role], 0.0, 0.55, 0.5, true);
                end
                self:Show()
            end
        end
    end
end

GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit);
