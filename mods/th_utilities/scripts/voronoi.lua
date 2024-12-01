Voronoi = {}

local function random2(x, y, out)
	local j = 4096.0 * math.sin(x * 17.0 + y * 59.4)
	out.x = math.fract(512.0 * j) - 0.5
	j = j * 0.125
	out.y = math.fract(512.0 * j) - 0.5
end

Voronoi.new = function(seed)
	local noise = {}
	local lastPos = {}
	local values = {}

	for i = 1, 9 do
		values[i] = {x = 0.0, y = 0.0}
	end

	local offset = {}
	random2(seed, seed * 3.0, offset)
	offset.x = offset.x * 65536
	offset.y = offset.y * 65536

	noise.get_2d = function(x, y)
		local ix = math.floor(x)
		local iy = math.floor(y)

		if ix ~= lastPos.x or iy ~= lastPos.y then
			lastPos.x = ix
			lastPos.y = iy
			for i = 0, 8 do
				local px = (i % 3) - 1
				local py = math.floor(i / 3) - 1
				local pos = values[i + 1]
				random2(px + ix + offset.x, py + iy + offset.y, pos)
				pos.x = pos.x + px
				pos.y = pos.y + py
			end
		end

		local dx = x - ix
		local dy = y - iy

		local distance = 10.0

		for i = 1, 9 do
			local pos = values[i]
			local px = pos.x - dx
			local py = pos.y - dy
			local dist2 = px * px + py * py
			if dist2 < distance then
				distance = dist2
			end
		end
		
		return math.min(math.sqrt(distance), 1.0)
	end

	return noise
end