_G.xero = {}

function xero.loadscript(path)
	-- load the song directory
	local songdir = GAMESTATE:GetCurrentSong():GetSongDir()
	-- attempt to load lua file
	local mylua, err = loadfile('.' .. songdir .. path)
	if err then
		-- try additional song folders
		local additionalsongfolders = PREFSMAN:GetPreference('AdditionalSongFolders')
		-- cut off 'Songs/' from the path
		local _,index = string.find(songdir,'Songs/')
		local songloc = string.sub(songdir,index)
		
		-- for every songfolder in the additionalsongfolders
		for songfolder in string.gfind(additionalsongfolders,'[^,]+') do
			local err
			
			-- attempt to load file
			mylua, err = loadfile(songfolder .. songloc .. path)
			if not err then break end
		end
	end
	-- report error if nothing was found
	if not mylua then
		SCREENMAN:SystemMessage(err)
		return
	else
		local success, result = pcall(mylua)
		if success then
			return result
		else
			SCREENMAN:SystemMessage(result)
			return
		end
	end
end

return Def.ActorFrame {
	InitCommand = function(self)
		xero.foreground = self
		self:sleep(9e9)
	end,
	xero.loadscript('outfox/std.lua'),
	xero.loadscript('outfox/template.lua'),
	xero.loadscript('outfox/ease.lua'),
	xero.loadscript('outfox/plugins.lua'),
	xero.loadscript('outfox/modport.lua'),
	xero.loadscript('lua/mods.lua'),
}
