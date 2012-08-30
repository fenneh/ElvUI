local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule('Chat')

E.Options.args.chat = {
	type = "group",
	name = L["Chat"],
	get = function(info) return E.db.chat[ info[#info] ] end,
	set = function(info, value) E.db.chat[ info[#info] ] = value end,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["CHAT_DESC"],
		},		
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			get = function(info) return E.private.chat.enable end,
			set = function(info, value) E.private.chat.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
		},				
		general = {
			order = 3,
			type = "group",
			name = L["General"],
			guiInline = true,
			args = {	
				url = {
					order = 1,
					type = 'toggle',
					name = L['URL Links'],
					desc = L['Attempt to create URL links inside the chat.'],
				},
				shortChannels = {
					order = 2,
					type = 'toggle',
					name = L['Short Channels'],
					desc = L['Shorten the channel names in chat.'],
				},		
				hyperlinkHover = {
					order = 3,
					type = 'toggle',
					name = L['Hyperlink Hover'],
					desc = L['Display the hyperlink tooltip while hovering over a hyperlink.'],
					set = function(info, value) 
						E.db.chat[ info[#info] ] = value 
						if value == true then
							CH:EnableHyperlink()
						else
							CH:DisableHyperlink()
						end
					end,
				},
				throttleInterval = {
					order = 4,
					type = 'range',
					name = L['Spam Interval'],
					desc = L['Prevent the same messages from displaying in chat more than once within this set amount of seconds, set to zero to disable.'],
					min = 0, max = 120, step = 1,
					set = function(info, value) 
						E.db.chat[ info[#info] ] = value 
						if value ~= 0 then
							CH:EnableChatThrottle()
						else
							CH:DisableChatThrottle()
						end
					end,					
				},
				scrollDownInterval = {
					order = 5,
					type = 'range',
					name = L['Scroll Interval'],
					desc = L['Number of time in seconds to scroll down to the bottom of the chat window if you are not scrolled down completely.'],
					min = 0, max = 120, step = 5,
					set = function(info, value) 
						E.db.chat[ info[#info] ] = value 
					end,					
				},		
				sticky = {
					order = 6,
					type = 'toggle',
					name = L['Sticky Chat'],
					desc = L['When opening the Chat Editbox to type a message having this option set means it will retain the last channel you spoke in. If this option is turned off opening the Chat Editbox should always default to the SAY channel.'],
					set = function(info, value)
						E.db.chat[ info[#info] ] = value 
					end,
				},	
				emotionIcons = {
					order = 9,
					type = 'toggle',
					name = L['Emotion Icons'],
					desc = L['Display emotion icons in chat.'],
					set = function(info, value)
						E.db.chat[ info[#info] ] = value 
					end,
				},		
				whisperSound = {
					order = 10,
					type = 'select', dialogControl = 'LSM30_Sound',
					name = L["Whisper Alert"],
					disabled = function() return not E.db.chat.whisperSound end,
					values = AceGUIWidgetLSMlists.sound,
					set = function(info, value) E.db.chat.whisperSound = value; end,
				},	
				keywordSound = {
					order = 11,
					type = 'select', dialogControl = 'LSM30_Sound',
					name = L["Keyword Alert"],
					disabled = function() return not E.db.chat.keywordSound end,
					values = AceGUIWidgetLSMlists.sound,
					set = function(info, value) E.db.chat.keywordSound = value; end,
				},
				panelBackdrop = {
					order = 100,
					type = 'select',
					name = L['Panel Backdrop'],
					desc = L['Toggle showing of the left and right chat panels.'],
					set = function(info, value) E.db.chat.panelBackdrop = value; E:GetModule('Layout'):ToggleChatPanels(); E:GetModule('Chat'):PositionChat(true) end,
					values = {
						['HIDEBOTH'] = L['Hide Both'],
						['SHOWBOTH'] = L['Show Both'],
						['LEFT'] = L['Left Only'],
						['RIGHT'] = L['Right Only'],
					},
				},	
				panelHeight = {
					order = 101,
					type = 'range',
					name = L['Panel Height'],
					desc = L['PANEL_DESC'],
					set = function(info, value) E.db.chat.panelHeight = value; E:GetModule('Chat'):PositionChat(true); end,
					min = 150, max = 600, step = 1,
				},				
				panelWidth = {
					order = 102,
					type = 'range',
					name = L['Panel Width'],
					desc = L['PANEL_DESC'],
					set = function(info, value) E.db.chat.panelWidth = value; E:GetModule('Chat'):PositionChat(true); local bags = E:GetModule('Bags'); bags:Layout(); bags:Layout(true); end,
					min = 150, max = 700, step = 1,
				},
				keywords = {
					order = 103,
					name = L['Keywords'],
					desc = L['List of words to color in chat if found in a message. If you wish to add multiple words you must seperate the word with a comma. To search for your current name you can use %MYNAME%.\n\nExample:\n%MYNAME%, ElvUI, RBGs, Tank'],
					type = 'input',
					width = 'full',
					set = function(info, value) E.db.chat[ info[#info] ] = value; CH:UpdateChatKeywords() end,
				},				
				panelBackdropNameLeft = {
					order = 104,
					type = 'input',
					width = 'full',
					name = L['Panel Texture (Left)'],
					desc = L['Specify a filename located inside the World of Warcraft directory. Textures folder that you wish to have set as a panel background.\n\nPlease Note:\n-The image size recommended is 256x128\n-You must do a complete game restart after adding a file to the folder.\n-The file type must be tga format.\n\nExample: Interface\\AddOns\\ElvUI\\media\\textures\\copy\n\nOr for most users it would be easier to simply put a tga file into your WoW folder, then type the name of the file here.'],
					set = function(info, value) 
						E.db.chat[ info[#info] ] = value
						E:UpdateMedia()
					end,
				},
				panelBackdropNameRight = {
					order = 105,
					type = 'input',
					width = 'full',
					name = L['Panel Texture (Right)'],
					desc = L['Specify a filename located inside the World of Warcraft directory. Textures folder that you wish to have set as a panel background.\n\nPlease Note:\n-The image size recommended is 256x128\n-You must do a complete game restart after adding a file to the folder.\n-The file type must be tga format.\n\nExample: Interface\\AddOns\\ElvUI\\media\\textures\\copy\n\nOr for most users it would be easier to simply put a tga file into your WoW folder, then type the name of the file here.'],
					set = function(info, value) 
						E.db.chat[ info[#info] ] = value
						E:UpdateMedia()
					end,
				},					
			},
		},
		fontGroup = {
			order = 120,
			type = 'group',
			guiInline = true,
			name = L['Fonts'],
			set = function(info, value) E.db.chat[ info[#info] ] = value; CH:SetupChat() end,
			args = {
				font = {
					type = "select", dialogControl = 'LSM30_Font',
					order = 1,
					name = L["Font"],
					values = AceGUIWidgetLSMlists.font,
				},
				fontOutline = {
					order = 2,
					name = L["Font Outline"],
					desc = L["Set the font outline."],
					type = "select",
					values = {
						['NONE'] = L['None'],
						['OUTLINE'] = 'OUTLINE',
						['MONOCHROME'] = 'MONOCHROME',
						['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
						['THICKOUTLINE'] = 'THICKOUTLINE',
					},
				},
				tabFont = {
					type = "select", dialogControl = 'LSM30_Font',
					order = 4,
					name = L["Tab Font"],
					values = AceGUIWidgetLSMlists.font,
				},
				tabFontSize = {
					order = 5,
					name = L["Tab Font Size"],
					type = "range",
					min = 6, max = 22, step = 1,
				},	
				tabFontOutline = {
					order = 6,
					name = L["Tab Font Outline"],
					desc = L["Set the font outline."],
					type = "select",
					values = {
						['NONE'] = L['None'],
						['OUTLINE'] = 'OUTLINE',
						['MONOCHROME'] = 'MONOCHROME',
						['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
						['THICKOUTLINE'] = 'THICKOUTLINE',
					},
				},	
			},
		},			
	},
}