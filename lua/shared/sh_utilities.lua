
if SERVER then
    util.AddNetworkString("brew_draw_brewUI")
    util.AddNetworkString("brew_store_Entity")
    util.AddNetworkString("brew_draw_StatusUI")

    util.AddNetworkString("brew_drop_item")

	util.AddNetworkString("brew_effect_cleared")
	util.AddNetworkString("brew_clear_single_effect")

	util.AddNetworkString("brew_draw_ingredient_info")

	util.AddNetworkString("brew_player_died")

	util.AddNetworkString("brew_Play_Sound")


else

surface.CreateFont( "Brew_StatusFont", {
	font = "Impact", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() * 26 / 1920,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "Brew_UIFont", {
	font = "DermaLarge", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() * 33 / 1920,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )
surface.CreateFont( "Brew_UIFont_Small", {
	font = "DermaLarge", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = ScrW() * 16 / 1920,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

end