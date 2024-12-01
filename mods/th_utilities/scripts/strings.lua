local function titleCase(first, rest)
	return string.upper(first) .. string.lower(rest)
end

---Transforms `snake_case` into `Title Case`.
---@param str string Source string to transfrom.
---@return string string Transformed string.
string.snake_to_title = function (str)
	-- Local to prevent 2 values output
	local result = string.gsub(str, "_", " ")
	result = string.gsub(result, "(%a)([%w_']*)", titleCase)
	return result
end