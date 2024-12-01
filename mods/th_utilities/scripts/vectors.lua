---Set vector coordinates to arguments.
---@param vector table Vector to set coordinates into.
---@param x number Vector X coordinate.
---@param y number Vector Y coordinate.
---@param z number Vector Z coordinate.
---@return table vector Mutated source vector.
vector.set = function(vector, x, y, z)
	vector.x = x
	vector.y = y
	vector.z = z
	return vector
end

vector.normalize_self = function(vector)
	local length = vector.x * vector.x + vector.y * vector.y + vector.z * vector.z
	if length > 0 then
		length = math.sqrt(length)
		vector.x = vector.x / length
		vector.y = vector.y / length
		vector.z = vector.z / length
	end
	return vector
end