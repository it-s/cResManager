local _c = require "lib.tlc.tlc-min"

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

R:getTypeRoot = function (type)
	if not _c.isDefined(type) then
		type = R.TYPE_GENERIC
	end
	if type == self.TYPE_GENERIC then
		return self
	else
		return self[type]
	end
end

--Object definition

-- TODO add a possibility to add a whole collection of type at aonce
R:add = function (name, object, type)
	local root = nil
	if not _c.isDefined(type) and
		_c.tableHasKey(object, "type") then
		type = object.type
	else
		type = self.TYPE_GENERIC
	end
	root = self:getTypeRoot(type)

	root[name] = object
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


-- Object lifecycle

R:init = function(name, type, namespace)
	local store = self:getStore(namespace)
	local object = self:get(name, type)
	return store[name] = object()
end

R:existis = function(name, namespace)
	local store = self:getStore(namespace)
	return _c.tableHasKey(store, name)
end

R:_ = function (name, namespace)
	local store = self:getStore(namespace)
	return store[name]
end

R:empty = function ( namespace )
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

R:destroy = function ( namespace )
	local store = self:getStore(namespace)
	self:empty(namespace)
	store = nil
end

return R