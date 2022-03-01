
if SERVER then
    util.AddNetworkString("brew_draw_brewUI")
    util.AddNetworkString("brew_store_Entity")
    util.AddNetworkString("brew_draw_StatusUI")

    util.AddNetworkString("brew_drop_item")

	util.AddNetworkString("brew_effect_cleared")


else

surface.CreateFont( "Brew_StatusFont", {
	font = "Impact", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 26,
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