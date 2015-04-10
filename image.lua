local FN = require "lib.resources.fn"
local Transition  = require "lib.resources.transition"
return function (name, dir, options)
    local res = display.newImage(name, dir)
    FN.tableExtend(options, {
	    type = "image",
	    transition = nil,
	    removeEventListeners = function(self)
	      self._functionListeners = nil
	      self._tableListeners = nil
	    end,
	    destroy = function(self)
	    	if FN.isNil(self) then return end
	        self.transition.clear()
	        self:removeEventListeners()
	        self:removeSelf( )
	        self = nil
	    end
	})
	FN.tableExtend(res, options)
    return Transition(res)
end