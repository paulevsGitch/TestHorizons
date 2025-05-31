local function title_case(first, rest)
	return string.upper(first) .. string.lower(rest)
end

---Transforms `snake_case` into `Title Case`.
---@param str string Source string to transfrom.
---@return string string Transformed string.
string.snake_to_title = function (str)
	-- Local to prevent 2 values output
	local result = string.gsub(str, "_", " ")
	result = string.gsub(result, "(%a)([%w_']*)", title_case)
	return result
end

---Checks if string starts with pattern.
---@param str string Source string to check.
---@param pattern string Pattern string to check.
---@return boolean
string.starts_with = function (str, pattern)
	return string.sub(str, 1, string.len(pattern)) == pattern
end

---Removes specified amount of last characters in string
---@param str string Source string to transfrom.
---@param count integer Amount of characters to remove.
---@return string
string.remove_last = function (str, count)
	return string.sub(str, 1, string.len(str) - count)
end

---Find the last index of given pattern. Returns -1 if pattern don't exist in the string.
---@param str string Source string.
---@param pattern string Pattern to search.
---@return integer
string.last_index_of = function (str, pattern)
	local index = string.match(str, ".*" .. pattern .. "()")
	if index then
		return index - 1
	else
		return -1
	end
end