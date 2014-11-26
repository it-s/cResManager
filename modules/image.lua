local module = {
	type = "image"
}

module:new = function(name, baseImagesDirectory)
	local res = display.newImage( baseImagesDirectory .. name)
	res.type = module.type
	res.transition = nil

	function res:removeEventListeners()
		self._functionListeners = nil
		self._tableListeners = nil
	end

	function res:destroy()
		if self.transition then transition.cancel( self.transition ) end
		self:removeEventListeners()
		self:removeSelf()
		self = nil
	end
	return res
end

return module