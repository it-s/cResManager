local FN = require "lib.resources.fn"

local function enque (que, next)
end

return function (obj)
	local obj = obj
	local que = {}
	local transition = {
		current = nil,
		que = que,
		to = function() print (obj.x) end,
		from = function() end,
		enque = function(next)
			table.insert(que, next)
		end,
		next = function() end,
		start = function() end,
		pause = function(tag)
			
		end,
		stop = function()

		end,
		clear = function()
			obj.transition.stop()
			obj.transition.current = nil
			obj.transition.que = {}
		end,
	}
	obj["transition"] = transition
	return obj
end