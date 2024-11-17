table.merge_into = table.merge_into or function(merge_to, merge_from)
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