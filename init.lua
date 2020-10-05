-- This Lua module is invoked by LDoc to save output
-- in JSON format, which is then used by ldoc2mkdoc

local json = require("json")

function filterEntryItem(_entry, item)
	if item["params"] then
		local params = item["params"]
		local paramsList = {}
		local paramsMap = params["map"] or {}
		for k, v in pairs(params) do
			if tonumber(k) then
				paramsList[tonumber(k)] = v
			end
		end
		item["paramsList"] = paramsList
		item["paramsMap"] = paramsMap
	end
end

local seen = {}
local function recurse(v, name)
	if type(v) == "table" then
		if seen[v] then
			return "RECURSIVE"
		else
			seen[v] = true
			for k, v2 in pairs(v) do
				v[k] = recurse(v2, name .. "." .. tostring(k))
			end
			seen[v] = nil
		end
	elseif type(v) == "function" then
		return "FUNCTION"
	end
	return v
end

return {
	filter = function (t)
		recurse(t, "root")
		for _, entry in pairs(t) do
			for __, item in pairs(entry["items"]) do
				filterEntryItem(entry, item)
			end
		end
		print(json.encode.encode(t))
	end
}
