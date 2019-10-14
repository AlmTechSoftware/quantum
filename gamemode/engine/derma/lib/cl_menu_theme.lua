--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local theme ={}
local scale = Quantum.Client.ResolutionScale
local padding = math.Round( 10 * scale )
local padding_s = math.Round( 4 * scale )


local blur = Material("pp/blurscreen")
local function renderBlur( p, a, d )
    local x, y = p:LocalToScreen( 0, 0 )
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )
	
	for i = 1, d do
		blur:SetFloat( "$blur", (i / d) * a )
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
end

function theme.panel( p, color )
    local w, h = p:GetSize()
    local clr = color || Color( 0, 0, 0, 100 )
    local bclr = Color( 50, 50, 50, 105 ) 

    draw.RoundedBox( 6, 0, 0, w, h, bclr ) -- border
    draw.RoundedBox( 4, padding_s/2, padding_s/2, w - padding_s, h - padding_s, clr ) -- inner
end

function theme.blurpanel( p, color )
    local w, h = p:GetSize()
    local clr = color || Color( 0, 0, 0, 100 )
    local bclr = Color( 50, 50, 50, 105 ) 
    renderBlur( p, 2, 7 )

    draw.RoundedBox( 6, 0, 0, w, h, bclr ) -- border
    draw.RoundedBox( 4, padding_s/2, padding_s/2, w - padding_s, h - padding_s, clr ) -- inner
end

function theme.button( b, color )
    local w, h = b:GetSize()
    local clr = color || Color( 235, 64, 52, 255 )
    local bclr = Color( 50, 50, 50, 255 ) 

    if( b:IsHovered() ) then
        bclr = Color( 205, 205, 205, 255 )
    else
        bclr = Color( 50, 50, 50, 255 ) 
    end
    draw.RoundedBox( 6, 0, 0, w, h, bclr ) -- border
    draw.RoundedBox( 4, padding_s/2, padding_s/2, w - padding_s, h - padding_s, clr ) -- inner
end

function theme.sharpbutton( b, inClr )
    local w, h = b:GetSize()
    inClr = inClr || Color( 235, 64, 52, 255 )

    if( b:IsHovered() ) then
        surface.SetDrawColor( 205, 205, 205, 255 )
    else
        surface.SetDrawColor( 50, 50, 50, 255 )
    end

    
    surface.DrawRect( 0, 0, w, h )

    surface.SetDrawColor( inClr )
    surface.DrawRect( padding_s/2, padding_s/2, w - padding_s, h - padding_s )
end

return theme