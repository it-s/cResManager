local _c = require "lib.tlc.tlc-min"
_c.isDestructable = function(obj)
	return _c.isTable(obj) and _c.tableHasKey(obj, "destroy")
end

local R = {
	_store = {},
	_namespace = "",
	TYPE_ANIMATION = "animations",
	TYPE_IMAGE = "images",
	TYPE_SOUND = "sounds",
	TYPE_MUSIC = "tracks",
	TYPE_GENERIC = -1,
	animations = {},
	images = {},
	sounds = {},
	tracks = {},

	baseImagesDirectory = "res/images/",
	baseSoundDirectory = "res/sounds/",
	baseMusicDirectory = "res/music/"
}

R:options = function (options)
	if _c.isNil(options) or not _c.isObject(options) then return error("Options is Nil, or not a table") end
	_c.tableExtend(self, options)
end

R:getTypeRoot = function (type)
	if _c.isNil(type) then
		type = R.TYPE_GENERIC
	end
	if type == self.TYPE_GENERIC then
		return self
	else
		return self[type]
	end
end

--Object definition

-- add ( objectList, type )
-- add ( name, object, type )
R:add = function ( ... )
	local root = nil
	local name = nil
	local object = nil
	local type = nil

	if #arg == 2 then
		object 	= arg[1]
		type 	= arg[2]
		root 	= self:getTypeRoot(type)
		root 	= object
		return true
	elseif #arg == 3 then
		name 	= arg[1]
		object 	= arg[2]
		type 	= arg[3]
		root 	= self:getTypeRoot(type)
		if _c.tableHasKey(root, name) then return error( "Resource " .. name .. " of type " .. type .. " is already defined." ) end
		root[name] = object
		return true
	end	
	return false
end

R:has = function (name, type)
	local root = self:getTypeRoot(type)
	return _c.tableHasKey(root, name)
end

R:get = function(name, type)
	local root = self:getTypeRoot(type)
	local object = root[name]
	if not _c.isDefined (object) then
		return error( "Object [" .. name .."] of type "..type.." not found in resource collection." )
	end
	return object
end

--Namespace & Store

R:namespace = function(namespace)
	if _c.isDefined ( namespace ) then
		self:createStore (namespace)
		self._namespace = namespace
	end
	return self._namespace
end

R:createStore = function (namespace)
	if not _c.tableHasKey(self._store, namespace) then
		self._store[namespace] = {}
	end
end

R:getStore = function (namespace)
	if _c.isDefined ( namespace ) then
		self:createStore (namespace)
	else
		namespace = self:namespace()
	end
	return self._store[namespace]
end

R:emptyStore = function ( namespace )
	local store = self:getStore(namespace)
	local iterator = _c.Iterator(store)
	while (iterator.hasNext) do
		local object = iterator.next()
		if _c.tableHasKey(object, "destroy") then
			object:destroy()
		end
	end
	store = {}
end


-- Object lifecycle

R:init = function(name, type, namespace)
	local store = self:getStore(namespace)
	local object = self:get(name, type)
	local instance = object()
	instance._id = _c.increment(#store)
	instance._name = name
	table.insert(store, instance)
	return instance
end

-- R:existis = function(name, namespace)
-- 	local store = self:getStore(namespace)
-- 	return _c.tableHasKey(store, name)
-- end

-- R:_ = function (name, namespace)
-- 	local store = nil
-- 	if self:existis(name, namespace) then
-- 		store = self:getStore(namespace)
-- 		return store[name]
-- 	else
-- 		return error( "Object [" .. name .."] is not found at namespace " .. namespace .."." )
-- 	end
-- end

-- destroy(object)
-- destroy(namespace)
R:destroy = function ( var )
	if _c.isTable(var) then
		local id = var._id
		if _c.isDestructable(var) then
			var:destroy()
		end		
		table.remove( id ) = nil
	elseif _c.isString(var) then
		local store = self:getStore(var)
		self:emptyStore(var)
		store = nil
		return true
	end
	return false
end

return R