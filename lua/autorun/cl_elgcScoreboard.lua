if SERVER then
	resource.AddFile("materials/elgcscoreboard/logo_el.png")
	AddCSLuaFile()
return end

elgcScoreboard = {}
elgcScoreboard.isOpen = false
elgcScoreboard.quickCommands = {}

local function StencilStart()
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS ) 	
	render.SetStencilReferenceValue( 1 )
	render.SetColorModulation( 1, 1, 1 )
end

local function StencilReplace()
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilReferenceValue(0)
end

local function StencilEnd()
	render.SetStencilEnable( false )
end

local function DrawCircle(posx, posy, radius, progress, color)
	local poly = { }
	local v = 220
	poly[1] = {x = posx, y = posy}
	for i = 0, v*progress+0.5 do
		poly[i+2] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
	end
	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(poly)
end

local function addQuickCommand(name, permission, clickfunction)
	if type(name) != "string" or type(permission) != "string" or type(clickfunction) != "function" then return end
	local info = {name, permission, clickfunction}
	elgcScoreboard.quickCommands[table.Count(elgcScoreboard.quickCommands) + 1] = info
end

local function hasQuickCommands()
	for _, cmdTable in pairs(elgcScoreboard.quickCommands) do
		if ULib.ucl.query(LocalPlayer(), cmdTable[2], true) then
			return true
		end
	end
	return false
end

local function getButtons()
	local ammount = 0
	for _, cmdTable in pairs(elgcScoreboard.quickCommands) do
		if ULib.ucl.query(LocalPlayer(), cmdTable[2], true) then
			ammount = ammount + 1
		end
	end
	return ammount
end

local function generateQuickCommands(pnl, a, ply)
	if hasQuickCommands() then
		local y = a
		local maxcolls = 8
		local buttons = getButtons()
		local totalbuttons = buttons
		local coll = 1
		
		local colls = 0
		local buttonwide = 0
		
		if buttons == 0 then return
		elseif buttons >= maxcolls then colls = maxcolls
		else colls = buttons end
		buttonwide = (pnl:GetWide() - 15) / maxcolls
		buttons = buttons - colls
		
		for cmdNumber = 1, totalbuttons do
			local cmdTable = elgcScoreboard.quickCommands[cmdNumber]
			
			local button = vgui.Create("DButton", pnl)
			button:SetFontInternal("elgcScoreboard_font3")
			button:SetText(cmdTable[1])
			button:SizeToContents()
			button:SetSize(buttonwide - 5, button:GetTall() + 10)
			button:SetPos(10 + ((maxcolls - colls) * buttonwide) / 2 + buttonwide * coll - buttonwide, y)
			button.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(33, 33, 33, 255))
				--draw.RoundedBox(0, 3, 3, w - 6, h - 6, Color(54, 54, 54, 255))
			end
			button.PerformLayout = function(self) self:SetFGColor(Color(255, 255, 255, 255)) end
			button.DoClick = function() cmdTable[3](ply) end
			
			coll = coll + 1
			if coll > colls then
				coll = 1
				y = y + button:GetTall() + 5
				if buttons == 0 then return
				elseif buttons >= maxcolls then colls = maxcolls
				else colls = buttons end
				buttons = buttons - colls
				if buttons == 0 then
					local bu = vgui.Create("DPanel", pnl)
					bu:SetSize(pnl:GetWide(), 10)
					bu:SetPos(0, y + button:GetTall())
					bu:SetMouseInputEnabled(false)
					bu.Paint = function() return true end
					local a, b = bu:GetPos()
					if b + bu:GetTall() < pnl:GetTall() then
						pnl:SetSize(pnl:GetWide(), b + bu:GetTall())
					end
				end
			end
		end
	end
end

	addQuickCommand("PM", "ulx psay", function(ply)
		Derma_StringRequest("Send a private message to " .. ply:Nick(), "Please insert a message...", "", function(text)
			if string.Trim(text) != "" then
				RunConsoleCommand("ulx", "psay", ply:Nick(), text)
			end
		end, function() end, "Send", "Cancel")
	end)
	
	addQuickCommand("Kick", "ulx kick", function(ply)
		RunConsoleCommand("ulx", "kick", ply:Nick())
	end)
	
	addQuickCommand("Jail", "ulx jail", function(ply)
		RunConsoleCommand("ulx", "jail", ply:Nick(), "0")
	end)
	
	addQuickCommand("Jail TP", "ulx jailtp", function(ply)
		RunConsoleCommand("ulx", "jailtp", ply:Nick(), "0")
	end)
	
	addQuickCommand("Unjail", "ulx unjail", function(ply)
		RunConsoleCommand("ulx", "unjail", ply:Nick(), "0")
	end)
	
	addQuickCommand("Gag", "ulx gag", function(ply)
		RunConsoleCommand("ulx", "gag", ply:Nick())
	end)
	
	addQuickCommand("Ungag", "ulx ungag", function(ply)
		RunConsoleCommand("ulx", "ungag", ply:Nick())
	end)
	
	addQuickCommand("Mute", "ulx mute", function(ply)
		RunConsoleCommand("ulx", "mute", ply:Nick())
	end)
	
	addQuickCommand("Unmute", "ulx unmute", function(ply)
		RunConsoleCommand("ulx", "unmute", ply:Nick())
	end)
	
	addQuickCommand("Gimp", "ulx gimp", function(ply)
		RunConsoleCommand("ulx", "gimp", ply:Nick())
	end)
	
	addQuickCommand("Ungimp", "ulx ungimp", function(ply)
		RunConsoleCommand("ulx", "ungimp", ply:Nick())
	end)
	
	addQuickCommand("Armor", "ulx armor", function(ply)
		RunConsoleCommand("ulx", "armor", ply:Nick(), "100")
	end)
	
	addQuickCommand("Heal", "ulx hp", function(ply)
		RunConsoleCommand("ulx", "hp", ply:Nick(), ply:GetMaxHealth())
	end)
	
	addQuickCommand("Blind", "ulx blind", function(ply)
		RunConsoleCommand("ulx", "blind", ply:Nick())
	end)
	
	addQuickCommand("Unblind", "ulx unblind", function(ply)
		RunConsoleCommand("ulx", "unblind", ply:Nick())
	end)
	
	addQuickCommand("Cloak", "ulx cloak", function(ply)
		RunConsoleCommand("ulx", "cloak", ply:Nick())
	end)
	
	addQuickCommand("Uncloak", "ulx uncloak", function(ply)
		RunConsoleCommand("ulx", "uncloak", ply:Nick())
	end)
	
	addQuickCommand("Freeze", "ulx freeze", function(ply)
		RunConsoleCommand("ulx", "freeze", ply:Nick())
	end)
	
	addQuickCommand("Unfreeze", "ulx unfreeze", function(ply)
		RunConsoleCommand("ulx", "unfreeze", ply:Nick())
	end)
	
	addQuickCommand("God", "ulx god", function(ply)
		RunConsoleCommand("ulx", "god", ply:Nick())
	end)
	
	addQuickCommand("Ungod", "ulx ungod", function(ply)
		RunConsoleCommand("ulx", "ungod", ply:Nick())
	end)
	
	addQuickCommand("Ignite", "ulx ignite", function(ply)
		RunConsoleCommand("ulx", "ignite", ply:Nick())
	end)
	
	addQuickCommand("Unignite", "ulx unignite", function(ply)
		RunConsoleCommand("ulx", "unignite", ply:Nick())
	end)
	
	addQuickCommand("Slay", "ulx slay", function(ply)
		RunConsoleCommand("ulx", "slay", ply:Nick())
	end)
	
	addQuickCommand("Slap", "ulx slap", function(ply)
		RunConsoleCommand("ulx", "slap", ply:Nick(), 0)
	end)
	
	addQuickCommand("Ragdoll", "ulx ragdoll", function(ply)
		RunConsoleCommand("ulx", "ragdoll", ply:Nick())
	end)
	
	addQuickCommand("Unragdoll", "ulx unragdoll", function(ply)
		RunConsoleCommand("ulx", "unragdoll", ply:Nick())
	end)
	
	addQuickCommand("Goto", "ulx goto", function(ply)
		RunConsoleCommand("ulx", "goto", ply:Nick())
	end)
	
	addQuickCommand("Bring", "ulx bring", function(ply)
		RunConsoleCommand("ulx", "bring", ply:Nick())
	end)
	
	addQuickCommand("Return", "ulx return", function(ply)
		RunConsoleCommand("ulx", "return", ply:Nick())
	end)
	
	addQuickCommand("Noclip", "ulx noclip", function(ply)
		RunConsoleCommand("ulx", "noclip", ply:Nick())
	end)
	
	addQuickCommand("Spectate", "ulx spectate", function(ply)
		RunConsoleCommand("say", "/spectate " .. ply:Nick())
	end)

surface.CreateFont("elgcScoreboard_titleFont", {
	font = "Roboto Bold",
	size = math.Round(40 * (ScrH() / 720), 0),
	antialias = true,
})

surface.CreateFont("elgcScoreboard_font", {
	font = "Roboto Bold",
	size = math.Round(15 * (ScrH() / 720), 0),
	antialias = true,
})

surface.CreateFont("elgcScoreboard_font2", {
	font = "Roboto Bold",
	size = math.Round(25 * (ScrH() / 720), 0),
	antialias = true,
})

surface.CreateFont("elgcScoreboard_font3", {
	font = "Roboto Bold",
	size = math.Round(20 * (ScrH() / 720), 0),
	antialias = true,
})

function elgcScoreboard.Load()
	
	hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
	hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
	
	function GAMEMODE.ScoreboardShow()
		if IsValid(elgcScoreboard.frame) then elgcScoreboard.frame:Close() end
		elgcScoreboard.buildFrame()
		elgcScoreboard.frame:AlphaTo(255, 0.1)
		gui.EnableScreenClicker(true)
		elgcScoreboard.frame:SetMouseInputEnabled(true)
		elgcScoreboard.frame:SetKeyboardInputEnabled(false)
	end
	
	function GAMEMODE.ScoreboardHide()
		if IsValid(elgcScoreboard.frame) then
			elgcScoreboard.frame:AlphaTo(255, 0.1, 0, function() if IsValid(elgcScoreboard.frame) then elgcScoreboard.frame:Close() end end)
			gui.EnableScreenClicker(false)
			elgcScoreboard.frame:SetMouseInputEnabled(false)
			elgcScoreboard.frame:SetKeyboardInputEnabled(false)
		end
	end
	
end

function elgcScoreboard.buildFrame()
	elgcScoreboard.frame = vgui.Create("DFrame")
	elgcScoreboard.frame:SetTitle("")
	elgcScoreboard.frame:ShowCloseButton(false)
	elgcScoreboard.frame:SetDraggable(false)
	elgcScoreboard.frame:SetSize(ScrW() * 0.9, ScrH() * 0.9)
	elgcScoreboard.frame:Center()
	elgcScoreboard.frame:SetAlpha(0)
	
	surface.SetFont("elgcScoreboard_titleFont")
	local topBar = vgui.Create("DPanel", elgcScoreboard.frame)
	local sizeW, sizeH = surface.GetTextSize("ENCRYPTED")
	topBar:SetSize((sizeH * 2 + 30) + 10 + surface.GetTextSize("ENCRYPTED"), sizeH * 2 + 30)
	topBar:SetPos(elgcScoreboard.frame:GetWide() / 2 -  topBar:GetWide() / 2, 20)
	topBar.Paint = function(self, w, h)
		draw.SimpleText("ENCRYPTED", "elgcScoreboard_titleFont", w - sizeW / 2, h / 2 - sizeH / 2, Color(240, 240, 240, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("LASER", "elgcScoreboard_titleFont", w - sizeW / 2, h / 2 + sizeH / 2, Color(240, 240, 240, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end	
	local logo = vgui.Create("DImage", topBar)
	logo:SetImage("elgcScoreboard/logo.png")
	logo:SetSize(topBar:GetTall(), topBar:GetTall())
	logo.Think = function(self) self:SetAlpha(255) end
	
	elgcScoreboard.frame.Paint = function(self, w, h)
		draw.RoundedBox(0, 10, 0, w - 10, h, Color(33, 33, 33, 255))
		draw.RoundedBox(0, 10, 10, w - 20, topBar:GetTall() + 20, Color(54, 54, 54, 255))
	end
	
	elgcScoreboard.frame.PaintOver = function(self, w, h)
		draw.RoundedBox(0, 0, 0, 10, h, Color(33, 33, 33, 255))
	end
	
	local content = vgui.Create("DPanel", elgcScoreboard.frame)
	content:SetPos(10, 40 + topBar:GetTall())
	content:SetSize(elgcScoreboard.frame:GetWide() - 20, elgcScoreboard.frame:GetTall() - 50 - topBar:GetTall())
	content.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(54, 54, 54, 255)) end
	surface.SetFont("elgcScoreboard_font")
	local sizeW, sizeH = surface.GetTextSize("SMOKEWOW")
	local contentTopBar = vgui.Create("DPanel", content)
	contentTopBar:SetPos(10, 10)
	contentTopBar:SetSize(content:GetWide() - 20, sizeH + 16)
	contentTopBar.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(33, 33, 33, 255))
		draw.RoundedBox(0, 3, 3, w - 6, h - 6, Color(54, 54, 54, 255))
		draw.SimpleText("NAME", "elgcScoreboard_font", (h - sizeH), h / 2, Color(240, 240, 240, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("JOB", "elgcScoreboard_font", w / 2, h / 2, Color(240, 240, 240, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("PING", "elgcScoreboard_font", w - (h - sizeH) - surface.GetTextSize("PING"), h / 2, Color(240, 240, 240, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("DEATHS", "elgcScoreboard_font", w - (h - sizeH) - surface.GetTextSize("PING") - surface.GetTextSize("DEATHSA"), h / 2, Color(240, 240, 240, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("KILLS", "elgcScoreboard_font", w - (h - sizeH) - surface.GetTextSize("PING") - surface.GetTextSize("DEATHSA") - surface.GetTextSize("KILLSA"), h / 2, Color(240, 240, 240, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	local contentScroll = vgui.Create("DScrollPanel", content)
	contentScroll:SetSize(content:GetWide() - 20, content:GetTall() - 10 - contentTopBar:GetTall())
	contentScroll:SetPos(10, 10 + contentTopBar:GetTall())
	contentScroll:GetVBar():SetSize(0, 0)
	
	local function updatePlayers()
		contentScroll:Clear()
		for ID, ply in pairs(player.GetAll()) do
			local playerBar = vgui.Create("DButton", contentScroll)
			playerBar:SetSize(contentTopBar:GetSize())
			playerBar:SetSize(playerBar:GetWide(), playerBar:GetTall())
			playerBar:SetPos(0, 5 + (contentTopBar:GetTall() + 5) * (ID - 1))
			playerBar:SetText("")
			playerBar.Paint = function(self, w, h)
				if not IsValid(ply) then updatePlayers()
				return true end
				local jobColor = GAMEMODE:GetTeamColor(ply)
				draw.RoundedBox(0, 0, 0, w, h, Color(jobColor.r, jobColor.g, jobColor.b, 255))
				draw.RoundedBox(0, 3, 3, w - 6, h - 6, Color(54, 54, 54, 255))
				
				local name = string.upper(ply:Nick())
				if surface.GetTextSize(name) > self:GetWide() * 0.3 - self:GetTall() then
					while surface.GetTextSize(name) > self:GetWide() * 0.3 - self:GetTall() do
						name = string.sub(name, 1, string.len(name) - 1)
					end
					name = string.sub(name, 1, string.len(name) - 3) .. "..."
				end
				draw.SimpleText(name, "elgcScoreboard_font", playerBar:GetTall(), h / 2, Color(240, 240, 240, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				local name = string.upper(team.GetName(ply:Team()))
				if surface.GetTextSize(name) > self:GetWide() * 0.3 - self:GetTall() then
					while surface.GetTextSize(name) > self:GetWide() * 0.3 - self:GetTall() do
						name = string.sub(name, 1, string.len(name) - 1)
					end
					name = string.sub(name, 1, string.len(name) - 3) .. "..."
				end
				draw.SimpleText(name, "elgcScoreboard_font", w / 2, h / 2, Color(240, 240, 240, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(ply:Ping(), "elgcScoreboard_font", w - (h - sizeH) - surface.GetTextSize("PING") / 2, h / 2, Color(240, 240, 240, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(ply:Deaths(), "elgcScoreboard_font", w - (h - sizeH) - surface.GetTextSize("PINGA") - surface.GetTextSize("DEATHS") / 2, h / 2, Color(240, 240, 240, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(ply:Frags(), "elgcScoreboard_font", w - (h - sizeH) - surface.GetTextSize("PINGADEATHSA") - surface.GetTextSize("KILLS") / 2, h / 2, Color(240, 240, 240, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			playerBar.DoClick = function()
				local playerInfo = vgui.Create("DPanel", elgcScoreboard.frame)
				playerInfo:SetSize(elgcScoreboard.frame:GetWide() - 20, elgcScoreboard.frame:GetTall() - 50 - topBar:GetTall())
				playerInfo:SetPos(- playerInfo:GetWide(), 40 + topBar:GetTall())
				playerInfo.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(54, 54, 54, 255)) end
				
				surface.SetFont("elgcScoreboard_font2")
				local sizeW, sizeH = surface.GetTextSize("MADE BY SMOKEWOW")
				
				local s1, a = surface.GetTextSize(ply:Nick())
				local s2, a = surface.GetTextSize(ply:SteamID())
				local s3, a = surface.GetTextSize("$" .. ply:getDarkRPVar("money"))
				
				local lens = {s1, s2, s3}
				local textLen = lens[table.GetWinningKey(lens)]
				local totalSize = (20 + sizeH * 3) + 5 + textLen
				if totalSize > playerInfo:GetWide() - 20 then totalSize = playerInfo:GetWide() - 20 end
				
				local top = vgui.Create("DPanel", playerInfo)
				top:SetSize(totalSize, 20 + sizeH * 3)
				top:SetPos(playerInfo:GetWide() / 2 - top:GetWide() / 2, 10)
				top.Paint = function(self, w, h) return true end
				
				local steamAvatar = vgui.Create("AvatarImage", top)
				steamAvatar:SetSize(16 + sizeH * 3, 16 + sizeH * 3)
				steamAvatar:SetPos(2, 2)
				steamAvatar:SetPlayer(ply, 128)
				steamAvatar:SetMouseInputEnabled(false)
				steamAvatar.PaintOver = function(self, w, h)
					StencilStart()
					DrawCircle(w/2, h/2, w/2, 1, Color(0,0,0,1))
					StencilReplace()
					surface.SetDrawColor(Color(54, 54, 54, 255))
					surface.DrawRect(0, 0, w, h)
					StencilEnd()
				end
				
				local but1 = vgui.Create("DLabel", top)
				but1:SetText(ply:Nick())
				but1:SetFont("elgcScoreboard_font2")
				but1:SizeToContents()
				but1:SetSize(top:GetWide() - (25 + sizeH * 3), but1:GetTall())
				but1:SetTextColor(Color(255, 255, 255, 255))
				but1:SetMouseInputEnabled(false)
				but1:SetPos(25 + sizeH * 3, 5)
				
				local but2 = vgui.Create("DButton", top)
				but2:SetText(ply:SteamID())
				but2:SetFont("elgcScoreboard_font2")
				but2:SizeToContents()
				but2:SetText("")
				but2.Paint = function(self, w, h) draw.SimpleText(ply:SteamID(), "elgcScoreboard_font2", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
				but2:SetPos(25 + sizeH * 3, 10 + but1:GetTall())
				but2.DoClick = function() SetClipboardText(ply:SteamID()) end
				
				local but3 = vgui.Create("DLabel", top)
				but3:SetText("$" .. ply:getDarkRPVar("money"))
				but3:SetFont("elgcScoreboard_font2")
				but3:SizeToContents()
				but3:SetSize(top:GetWide() - (25 + sizeH * 3), but1:GetTall())
				but3:SetTextColor(Color(255, 255, 255, 255))
				but3:SetMouseInputEnabled(false)
				but3:SetPos(25 + sizeH * 3, top:GetTall() - 5 - but3:GetTall())
				
				local commandList = vgui.Create("DScrollPanel", playerInfo)
				commandList:SetPos(10, 20 + top:GetTall())
				commandList:SetSize(playerInfo:GetWide() - 20, playerInfo:GetTall() - 30 - top:GetTall())
				commandList.PaintOver = function(self, w, h)
					surface.SetDrawColor(Color(33, 33, 33, 255))
					surface.DrawOutlinedRect(0, 0, w, h)
				end
				commandList:GetVBar():SetSize(0, 0)
				generateQuickCommands(commandList, 10, ply)
				commandList:SetPos(10, 10 + top:GetTall() + (playerInfo:GetTall() - 10 - top:GetTall()) / 2 - commandList:GetTall() / 2)
				
				local x, y = commandList:GetPos()
				local x2, y2 = top:GetPos()
				top:SetPos(x2, y / 2 - top:GetTall() / 2)
				
				content:SetMouseInputEnabled(false)
				playerInfo:SetMouseInputEnabled(false)
				playerInfo:MoveTo(10, 40 + topBar:GetTall(), 0.3, 0, -1, function() playerInfo:SetMouseInputEnabled(true) end)
			end
			
			local steamAvatar = vgui.Create("AvatarImage", playerBar)
			steamAvatar:SetSize(playerBar:GetTall() - 10, playerBar:GetTall() - 10)
			steamAvatar:SetPos(5, 5)
			steamAvatar:SetPlayer(ply, 64)
			steamAvatar:SetMouseInputEnabled(false)
			steamAvatar.Think = function(self) self:SetAlpha(255) end
		end
		local space = vgui.Create("DButton", contentScroll)
		space:SetSize(100, 5)
		space:SetPos(0, 5 + (contentTopBar:GetTall() + 5) * (table.Count(player.GetAll())) - 5)
		space:SetText("")
		space.Paint = function() return true end
		space:SetMouseInputEnabled(false)
	end
	updatePlayers()
end

if not GAMEMODE then hook.Add("Initialize", "elgcScoreboard_Load", function() elgcScoreboard.Load() end)
else elgcScoreboard.Load() end 