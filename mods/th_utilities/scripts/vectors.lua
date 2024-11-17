vector.set = vector.set or function(vector, x, y, z)
	vector.x = x
	vector.y = y
	vector.z = z
	return vector
end

vector.normalize_self = vector.normalize_self or function(vector)
	local length = vector.x * vector.x + vector.y * vector.y + vector.z * vector.z
	if length > 0 then
		length = math.sqrt(length)
		vector.x = vector.x / length
		vector.y = vector.y / length
		vector.z = vector.z / length
	end
	return vector
end