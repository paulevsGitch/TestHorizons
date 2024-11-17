math.lerp = math.lerp or function(a, b, delta)
	return a + delta * (b - a)
end

math.smooth_step = math.smooth_step or function(x)
	return x * x * x * (x * (x * 6 - 15) + 10)
end

math.clamp = math.clamp or function(value, minimum, maximum)
	if value < minimum then
		return minimum
	elseif value > maximum then
		return maximum
	else
		return value
	end
end

math.fract = math.fract or function (value)
	return value - math.floor(value)
end

math.fractal_call = math.fractal_call or function(func_to_call, iterations, x, y, z)
	local result = 0.0
	for i = 1, iterations do
		result = math.lerp(func_to_call(x, y, z), result, i * 0.5)
		x = x * 2.0
		y = y * 2.0
		if z then
			z = z * 2.0
		end
	end
	return result
end