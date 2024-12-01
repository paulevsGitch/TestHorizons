---Merges one table into another one with deep copy
---@param merge_to table table in which values will be merged
---@param merge_from table table from which values will be merged
table.merge_into = function(merge_to, merge_from)
	for k, v in pairs(merge_from) do
		if type(v) == "table" then
			local v_to = merge_to[k]
			if v_to and type(v_to) == "table" then
				table.merge_into(v_to, v)
				v = v_to
			end
		end
		merge_to[k] = v
	end
end