

net.Receive("brew_draw_brewUI", function(ply, len)   

	if net.ReadString() ~= "brewUI" then return end

	if not IsValid(brewFrame) then DrawBrewing()
	elseif IsValid(brewFrame) then brewFrame:Close() end

end)


net.Receive("brew_store_Entity", function(len, ply) 

	if net.ReadString() ~= "brew_store_ent" then return end
	local ent = net.ReadEntity()
	local tbl = net.ReadTable()

	DebugPrint("Sending " .. tostring(ent:GetClass()) .. " to client.\nEntity Model: " .. tostring(ent:GetModel()) .. "\nReagents in the ingredient: ")
	DebugPrintTable(tbl)

	CreateEntForStorage(ent:GetClass(), ent:GetModel(), tbl)





end)

net.Receive("brew_draw_StatusUI", function(len, ply)



	Brew_DrawStatus(net.ReadString(), net.ReadInt(32), net.ReadInt(32))


end)

net.Receive("brew_draw_ingredient_info", function(len, ply)

	local ent = net.ReadEntity()
	local tbl = net.ReadTable()

	DebugPrint("Client received information about: " .. tostring(ent))
	DebugPrintTable(tbl)

	ent.Reagents = tbl

end)