Perlin = {}

local rand_const = vector.new(17.0, 59.4, 15.0)

local function random3(pos, out)
	local j = 4096.0 * math.sin(vector.dot(pos, rand_const))
	out.z = math.fract(512.0 * j) - 0.5
	j = j * 0.125
	out.x = math.fract(512.0 * j) - 0.5
	j = j * 0.125
	out.y = math.fract(512.0 * j) - 0.5
	vector.normalize_self(out)
end

local function fill_vector(pos, x, y, z)
	vector.set(pos, x, y, z)
	random3(pos, pos)
end

Perlin.new = function(seed)
	local noise = {}
	local lastPos = vector.new(-640000, -640000, -640000)

	local cell = {}
	for i = 1, 8 do
		cell[i] = vector.zero()
	end

	local offset1 = vector.new(seed, seed * 2.0, seed * 3.0)
	random3(offset1, offset1)
	offset1.x = offset1.x * 65536
	offset1.y = offset1.y * 65536
	offset1.z = offset1.z * 65536

	local offset2 = vector.add(offset1, 1.0)
	local dir = vector.zero()

	noise.get = function(x, y, z)
		local ix = math.floor(x)
		local iy = math.floor(y)
		local iz = math.floor(z)

		if lastPos.x ~= ix or lastPos.y ~= iy or lastPos.z ~= iz then
			vector.set(lastPos, ix, iy, iz)
			fill_vector(cell[1], offset1.x + ix, offset1.y + iy, offset1.z + iz)
			fill_vector(cell[2], offset2.x + ix, offset1.y + iy, offset1.z + iz)
			fill_vector(cell[3], offset1.x + ix, offset2.y + iy, offset1.z + iz)
			fill_vector(cell[4], offset2.x + ix, offset2.y + iy, offset1.z + iz)
			fill_vector(cell[5], offset1.x + ix, offset1.y + iy, offset2.z + iz)
			fill_vector(cell[6], offset2.x + ix, offset1.y + iy, offset2.z + iz)
			fill_vector(cell[7], offset1.x + ix, offset2.y + iy, offset2.z + iz)
			fill_vector(cell[8], offset2.x + ix, offset2.y + iy, offset2.z + iz)
		end

		local dx = x - ix
		local dy = y - iy
		local dz = z - iz
		
		local a = vector.dot(cell[1], vector.set(dir, dx, dy, dz))
		local b = vector.dot(cell[2], vector.set(dir, dx - 1, dy, dz))
		local c = vector.dot(cell[3], vector.set(dir, dx, dy - 1, dz))
		local d = vector.dot(cell[4], vector.set(dir, dx - 1, dy - 1, dz))
		local e = vector.dot(cell[5], vector.set(dir, dx, dy, dz - 1))
		local f = vector.dot(cell[6], vector.set(dir, dx - 1, dy, dz - 1))
		local g = vector.dot(cell[7], vector.set(dir, dx, dy - 1, dz - 1))
		local h = vector.dot(cell[8], vector.set(dir, dx - 1, dy - 1, dz - 1))
		
		dx = math.smooth_step(dx)
		dy = math.smooth_step(dy)
		dz = math.smooth_step(dz)
		
		a = math.lerp(a, b, dx)
		b = math.lerp(c, d, dx)
		c = math.lerp(e, f, dx)
		d = math.lerp(g, h, dx)
		
		a = math.lerp(a, b, dy)
		b = math.lerp(c, d, dy)
		
		a = math.lerp(a, b, dz)
		
		return math.clamp(a * 1.6, -1.0, 1.0)
	end

	return noise
end