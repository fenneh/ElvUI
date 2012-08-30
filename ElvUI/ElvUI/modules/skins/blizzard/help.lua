local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.help ~= true then return end
	local frames = {
		"HelpFrameLeftInset",
		"HelpFrameMainInset",
		"HelpFrameKnowledgebase",
		"HelpFrameHeader",
		"HelpFrameKnowledgebaseErrorFrame",
	}
	
	local buttons = {
		"HelpFrameAccountSecurityOpenTicket",
		"HelpFrameOpenTicketHelpTopIssues",
		"HelpFrameOpenTicketHelpOpenTicket",
		"HelpFrameKnowledgebaseSearchButton",
		"HelpFrameKnowledgebaseNavBarHomeButton",
		"HelpFrameCharacterStuckStuck",
		"GMChatOpenLog",
		"HelpFrameTicketSubmit",
		"HelpFrameTicketCancel",
	}
	
	-- 4.3.4 patch
	if E.wowbuild >= 15595 then
		tinsert(buttons, "HelpFrameButton16")
		tinsert(buttons, "HelpFrameSubmitSuggestionSubmit")
		tinsert(buttons, "HelpFrameReportBugSubmit")
	end
	
	-- skin main frames
	for i = 1, #frames do
		_G[frames[i]]:StripTextures(true)
		_G[frames[i]]:CreateBackdrop("Default")
	end
	
	HelpFrameHeader:SetFrameLevel(HelpFrameHeader:GetFrameLevel() + 2)
	HelpFrameKnowledgebaseErrorFrame:SetFrameLevel(HelpFrameKnowledgebaseErrorFrame:GetFrameLevel() + 2)
	
	HelpFrameReportBugScrollFrame:StripTextures()
	HelpFrameReportBugScrollFrame:CreateBackdrop("Default")
	HelpFrameReportBugScrollFrame.backdrop:Point("TOPLEFT", -4, 4)
	HelpFrameReportBugScrollFrame.backdrop:Point("BOTTOMRIGHT", 6, -4)
	for i=1, HelpFrameReportBug:GetNumChildren() do
		local child = select(i, HelpFrameReportBug:GetChildren())
		if not child:GetName() then
			child:StripTextures()
		end
	end
	
	S:HandleScrollBar(HelpFrameReportBugScrollFrameScrollBar)
	
	HelpFrameSubmitSuggestionScrollFrame:StripTextures()
	HelpFrameSubmitSuggestionScrollFrame:CreateBackdrop("Default")
	HelpFrameSubmitSuggestionScrollFrame.backdrop:Point("TOPLEFT", -4, 4)
	HelpFrameSubmitSuggestionScrollFrame.backdrop:Point("BOTTOMRIGHT", 6, -4)
	for i=1, HelpFrameSubmitSuggestion:GetNumChildren() do
		local child = select(i, HelpFrameSubmitSuggestion:GetChildren())
		if not child:GetName() then
			child:StripTextures()
		end
	end
	
	S:HandleScrollBar(HelpFrameSubmitSuggestionScrollFrameScrollBar)

	HelpFrameTicketScrollFrame:StripTextures()
	HelpFrameTicketScrollFrame:CreateBackdrop("Default")
	HelpFrameTicketScrollFrame.backdrop:Point("TOPLEFT", -4, 4)
	HelpFrameTicketScrollFrame.backdrop:Point("BOTTOMRIGHT", 6, -4)
	for i=1, HelpFrameTicket:GetNumChildren() do
		local child = select(i, HelpFrameTicket:GetChildren())
		if not child:GetName() then
			child:StripTextures()
		end
	end	
	
	S:HandleScrollBar(HelpFrameKnowledgebaseScrollFrame2ScrollBar)
	
	-- skin sub buttons
	for i = 1, #buttons do
		_G[buttons[i]]:StripTextures(true)
		S:HandleButton(_G[buttons[i]], true)
		
		if _G[buttons[i]].text then
			_G[buttons[i]].text:ClearAllPoints()
			_G[buttons[i]].text:SetPoint("CENTER")
			_G[buttons[i]].text:SetJustifyH("CENTER")				
		end
	end
	
	-- skin main buttons
	for i = 1, 6 do
		local b = _G["HelpFrameButton"..i]
		S:HandleButton(b, true)
		b.text:ClearAllPoints()
		b.text:SetPoint("CENTER")
		b.text:SetJustifyH("CENTER")
	end	
	
	-- skin table options
	for i = 1, HelpFrameKnowledgebaseScrollFrameScrollChild:GetNumChildren() do
		local b = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
		b:StripTextures(true)
		S:HandleButton(b, true)
	end
	
	-- skin misc items
	HelpFrameKnowledgebaseSearchBox:ClearAllPoints()
	HelpFrameKnowledgebaseSearchBox:Point("TOPLEFT", HelpFrameMainInset, "TOPLEFT", 13, -10)
	HelpFrameKnowledgebaseNavBarOverlay:Kill()
	HelpFrameKnowledgebaseNavBar:StripTextures()
	
	HelpFrame:StripTextures(true)
	HelpFrame:CreateBackdrop("Transparent")
	S:HandleEditBox(HelpFrameKnowledgebaseSearchBox)
	S:HandleScrollBar(HelpFrameKnowledgebaseScrollFrameScrollBar, 5)
	S:HandleScrollBar(HelpFrameTicketScrollFrameScrollBar, 4)
	S:HandleCloseButton(HelpFrameCloseButton, HelpFrame.backdrop)	
	S:HandleCloseButton(HelpFrameKnowledgebaseErrorFrameCloseButton, HelpFrameKnowledgebaseErrorFrame.backdrop)
	
	--Hearth Stone Button
	HelpFrameCharacterStuckHearthstone:StyleButton()
	HelpFrameCharacterStuckHearthstone:SetTemplate("Default", true)
	HelpFrameCharacterStuckHearthstone.IconTexture:SetInside()
	HelpFrameCharacterStuckHearthstone.IconTexture:SetTexCoord(unpack(E.TexCoords))
	
	local function navButtonFrameLevel(self)
		for i=1, #self.navList do
			local navButton = self.navList[i]
			local lastNav = self.navList[i-1]
			if navButton and lastNav then
				navButton:SetFrameLevel(lastNav:GetFrameLevel() - 2)
			end
		end			
	end
	
	hooksecurefunc("NavBar_AddButton", function(self, buttonData)
		local navButton = self.navList[#self.navList]
		
		
		if not navButton.skinned then
			S:HandleButton(navButton, true)
			navButton.skinned = true
			
			navButton:HookScript("OnClick", function()
				navButtonFrameLevel(self)
			end)
		end
		
		navButtonFrameLevel(self)
	end)
	
	S:HandleButton(HelpFrameGM_ResponseNeedMoreHelp)
	S:HandleButton(HelpFrameGM_ResponseCancel)
	for i=1, HelpFrameGM_Response:GetNumChildren() do
		local child = select(i, HelpFrameGM_Response:GetChildren())
		if child and child:GetObjectType() == "Frame" and not child:GetName() then
			child:SetTemplate("Default")
		end
	end
end

S:RegisterSkin('ElvUI', LoadSkin)