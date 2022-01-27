local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )

	if SERVER and prefix == "sv_" then
		include( directory .. File )
		print( "[Potion Brewing] Loaded Server File: " .. File )
	elseif prefix == "sh_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
			print( "[Potion Brewing] Server Included: " .. File )
		end
		include( directory .. File )
		print( "[Potion Brewing] Loaded Shared File: " .. File )
	elseif prefix == "cl_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
			print( "[Potion Brewing] Server included: " .. File )
		elseif CLIENT then
			include( directory .. File )
			print( "[Potion Brewing] Loaded Client File: " .. File )
		end
	end
end

local function IncludeDir( directory )
	directory = directory .. "/"
	
	local files, directories = file.Find( directory .. "*", "LUA" )

	for k, v in ipairs( files ) do
		if string.EndsWith( v, ".lua" ) then
			AddFile( v, directory )
		end
	end

	for k, v in ipairs( directories ) do
		IncludeDir( directory .. v )
	end
end

IncludeDir( "shared")
IncludeDir( "client")
IncludeDir( "debug")