local FN	 = require "lib.resources.fn"
local config = require "RES.config"

local RES 	 = {
	strings = require "RES.strings",
	animation = require "RES.animation",
	images = require "RES.images",
	sounds = require "RES.sounds",
	music = require "RES.music"
}

local Resources = {
	STRINGS = "strings",
	ANIMATIONS = "animations",
	IMAGES 	= "images",
	SOUNDS 	= "sounds",
	MUSIC 	= "music",
	config = config
}

Resources.get = function( ID, ... )
	local store = FN.ifThen( FN.isString(arg[1]), arg[1], FN.ifThen(FN.isString(arg[2]), arg[2], config.defaultStore ))
	local options = FN.ifThen( FN.isTable(arg[1]), arg[1], {} )
	if FN.isDefined(RES[store][ID]) then return RES[store][ID](options)
	else return error("Error loading resource '" .. ID .. "' from " .. store .. ". Please check your setup.") end
end
Resources.gets = function(list)
	if not FN.isTable(list) then error("Table expected, got " .. type(list)) end
	local iterator = FN.Iterator(list)
	while (iterator.hasNext()) do

	end
end
Resources._ = Resources.get

Resources.getString = function(ID, options)
	return Resources.get(ID, options, Resources.STRINGS)
end
Resources.getImage = function(ID, options)
	return Resources.get(ID, options, Resources.IMAGES)
end

return Resources