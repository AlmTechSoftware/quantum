--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local main = {}

local theme = Quantum.Client.Menu.GetAPI( "theme" )
local surebox = Quantum.Client.Menu.GetAPI( "sure" )

local scenes = {
	["rp_truenorth_v1a_livin"] = {
		[1] = {
			[1] = {
				fov = 60,
				velocity = 1,
				pos1 = Vector( 3473.962158, -5456.522949, 4205.845703 ),
				ang1 = Angle( 6.283165, -108.298935, 0.000000 )
			}
		},
		[2] = {
			[1] = {
				fov = 70,
				velocity = 1,
				pos1 = Vector( 10481.976562, -6193.810059, 5464.451172 ),
				ang1 = Angle( 3.220725, 103.288849, 0.000000 )
			}
		},
		[3] = {
			[1] = {
				fov = 85,
				velocity = 1,
				pos1 = Vector( 6285.742676, -14192.770508, 53.289391 ),
				ang1 = Angle( -0.052740, 158.862747, 0.000000 )
			}
		},
		[4] = {
			 [1] = {
				 fov = 85,
				 velocity = 1,
				 pos1 = Vector( -11803.785156, -13864.571289, -39.331917 ),
				 ang1 = Angle( 7.180876, 118.805817, 0.000000 )
			 }
		}
	},
	["rp_dunwood_eu"] = {
		[1] = {
			[1] = {
				fov = 80,
				velocity = 1,
				pos1 = Vector( 3845.0456542969, 10594.700195313, 1220.03125 ),
				ang1 = Angle( -43.528274536133, -141.58242797852, 0 )
			}
		}
	},
	["rp_southside_day"] = {
		[1] = {
			[1] = {
				fov = 70,
				velocity = 1,
				pos1 = Vector( 4344.45703125, 4380.2880859375, 74.674728393555 ),
				ang1 = Angle( 0.37715777754784, 122.66827392578, 0 )
			}
		}
	}
}

function main.open(dt)

	if( !f ) then
		
		if( IsValid( Quantum.Client.CurMenu ) ) then Quantum.Client.CurMenu:Close() end
		Quantum.Client.IsInMenu = true -- hide the hud

		local resScale = Quantum.Client.ResolutionScale
		local sw, sh = ScrW(), ScrH()
		local padding = 10 * resScale
		local padding_s = 4 * resScale

		local buttonWidth = 400 * resScale
		local buttonColor = Color( 20, 20, 20, 180 )
		local buttonTextColor = Color( 255, 255, 255, 255 )
		local buttonFont = "q_button_l"

		surface.SetFont( buttonFont )
		local x, buttonHeight = surface.GetTextSize( "AAAAA" )
		buttonHeight = buttonHeight + padding/2
		x = nil

		local f = vgui.Create( "DFrame" )
		f:SetSize( sw, sh )
		f:SetTitle( "" )
		f:SetDraggable( false )
		f:ShowCloseButton( false )
		f:MakePopup()
		f.Paint = function( self ) 
			theme.renderblur( self, 2, 7 )
		end

		if( scenes[ string.lower(game.GetMap()) ] != nil ) then
			Quantum.Client.Cam.Start( scenes[string.lower(game.GetMap())][math.random( 1, table.Count(scenes[string.lower(game.GetMap())])) ], false )
		else
			Quantum.Error( "There are no scenes for this map! Aborting scene..." )
		end

		local version = vgui.Create( "DLabel", f )
		version:SetText( "Quantum Version: " .. Quantum.Version )
		version:SetFont( "q_text2" )
		version:SetTextColor( Color( 255, 255, 255, 80 ) )
		version:SizeToContents()
		version.w, version.h = version:GetSize()
		version:SetPos( padding, padding )

		local tFrame = vgui.Create( "DPanel", f )
		tFrame:SetSize( sw, 150 * resScale )
		tFrame.w, tFrame.h = tFrame:GetSize()
		tFrame:SetPos( 0, sh/4.5 - tFrame.h/2 )
		tFrame.Paint = function( self, w, h )
			theme.titleframe( self )
		end

		local title = vgui.Create( "DLabel", tFrame )
		title:SetText( Quantum.ServerTitle || "[ERROR COULD NOT FIND TITLE]" )
		title:SetFont( "q_title" )
		title:SetTextColor( Color( 255, 255, 255, 225 ) )
		title:SizeToContents()
		title.w, title.h = title:GetSize()
		title.Paint = function( self )
			--theme.blurpanel( self, Color( 0, 0, 0, 150 ) )
		end

		local sub = vgui.Create( "DLabel", tFrame )
		sub:SetText( "Run by Quantum, created by AlmTech" )
		sub:SetFont( "q_subtitle" )
		sub:SetTextColor( Color( 255, 255, 255, 150 ) )
		sub:SizeToContents()
		sub.w, sub.h = sub:GetSize()
		sub.Paint = function( self )
			--theme.blurpanel( self, Color( 0, 0, 0, 90 ) )
		end

		---- Align it ----
		title:SetPos( tFrame.w/2 - title.w/2, tFrame.h/2 - ( title.h + sub.h )/2 )
		title.x, title.y = title:GetPos()

		sub:SetPos( tFrame.w/2 - sub.w/2, title.y + sub.h + padding*2 )
		sub.x, sub.y = sub:GetPos()


		---- BUTTONS ----
		local xbasepos = 0 --padding*6
		local ybasepos = sh*0.775 - padding*20
		local ypos = ybasepos

		local contBtnAlign = 4

		-- resume button 

		if( dt.cont.resume ) then
			local res = vgui.Create( "DButton", f )
			res:SetText( "" )
			res.txt = "Resume Game"

			res:SetSize( buttonWidth, buttonHeight )
			res.w, res.h = res:GetSize()

			res:SetPos( xbasepos, ypos )
			res.x, res.y = res:GetPos()

			res.Paint = function( self )
				theme.fadebutton( self, 1, nil, buttonFont, buttonTextColor )
			end
			res.DoClick = function( self )
				surface.PlaySound( "UI/buttonclick.wav" )
				f:Close()
				Quantum.Client.Cam.Stop() 
				Quantum.Client.IsInMenu = false
			end
			res.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
			res:SetContentAlignment( contBtnAlign )

			ypos = ypos + res.h + padding * 1.5
		end

		-- play button
		local play = vgui.Create( "DButton", f )
		
		play:SetText( "" ) -- why cant we just set the texts posistion :(
		play.txt = "Play"

		play:SetSize( buttonWidth, buttonHeight )
		play.w, play.h = play:GetSize()

		if( dt.cont.resume ) then
			play.txt = "Change Character"
		end

		play:SetTextColor( buttonTextColor )

		play:SetPos( xbasepos, ypos )

		play.Paint = function( self )
			--theme.sharpbutton( self, buttonColor )
			theme.fadebutton( self, 1, nil, buttonFont, buttonTextColor )
		end

		play.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			f:Close()
			Quantum.Client.Menu.Menus["character"].open( dt )
		end
		play.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
		play:SetContentAlignment( contBtnAlign )

		ypos = ypos + play.h + padding * 1.5

		-- Settings button
		local settings = vgui.Create( "DButton", f )
		settings:SetText( "" )
		settings.txt = "Settings"

		settings:SetSize( buttonWidth, buttonHeight )
		settings.w, settings.h = settings:GetSize()

		settings:SetPos( xbasepos, ypos )
		settings.x, settings.y = settings:GetPos()

		settings.Paint = function( self )
			--theme.sharpbutton( self, buttonColor )
			theme.fadebutton( self, 1, nil, buttonFont, buttonTextColor )
		end
		settings.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
		end
		settings.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
		settings:SetContentAlignment( contBtnAlign )

		ypos = ypos + settings.h + padding * 1.5

		-- Workshop button
		local ws = vgui.Create( "DButton", f )
		ws:SetText( "" )
		ws.txt = "Steam Workshop"

		ws:SetSize( buttonWidth, buttonHeight )
		ws.w, ws.h = ws:GetSize()

		ws:SetPos( xbasepos, ypos )
		ws.x, ws.y = ws:GetPos()

		ws.Paint = function( self )
			--theme.sharpbutton( self, buttonColor )
			theme.fadebutton( self, 1, nil, buttonFont, buttonTextColor )
		end
		ws.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			gui.OpenURL( Quantum.WorkshopLink )
		end
		ws.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
		ws:SetContentAlignment( contBtnAlign )

		ypos = ypos + ws.h + padding * 1.5

		-- Discord server invite button
		local inv = vgui.Create( "DButton", f )
		inv:SetText( "" )
		inv.txt = "Discord Invite"

		inv:SetSize( buttonWidth, buttonHeight )
		inv.w, inv.h = inv:GetSize()

		inv:SetPos( xbasepos, ypos )
		inv.x, inv.y = inv:GetPos()

		inv.Paint = function( self )
			--theme.sharpbutton( self, buttonColor )
			theme.fadebutton( self, 1, nil, buttonFont, buttonTextColor )
		end
		inv.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			gui.OpenURL( Quantum.DiscordInvite )
		end
		inv.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
		inv:SetContentAlignment( contBtnAlign )

		ypos = ypos + inv.h + padding * 1.5

		-- Quit button
		local quit = vgui.Create( "DButton", f )
		quit:SetText( "" )
		quit.txt = "Disconnect"

		quit:SetSize( buttonWidth, buttonHeight )
		quit.w, quit.h = quit:GetSize()

		quit:SetPos( xbasepos, ypos )
		quit.x, quit.y = quit:GetPos()

		quit.Paint = function( self )
			--theme.sharpbutton( self, buttonColor )
			theme.fadebutton( self, 1, nil, buttonFont, buttonTextColor )
		end
		quit.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			surebox.open( "You are about to leave the server.", self:GetParent(), function() 
				LocalPlayer():ConCommand("disconnect")
			end)
		end
		quit.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
		quit:SetContentAlignment( contBtnAlign )

	end
end

return main