---Linearly interpolates one value into another.
---@param a number Float value A.
---@param b number Float value B.
---@param delta number Float delta from 0.0 to 1.0 (can be greater - it will extrapolate in that case).
---@return number number Interpolated float number
math.lerp = function(a, b, delta)
	return a + delta * (b - a)
end

---Smooth step for range 0.0 to 1.0, used to smooth delta in some cases.
---@param x number Float delta from 0.0 to 1.0.
---@return number number Smoothed float number.
math.smooth_step = function(x)
	return x * x * x * (x * (x * 6 - 15) + 10)
end

---Clamps value between minimum and maximum.
---@param value number Value to clamp.
---@param minimum number Minimum value.
---@param maximum number Maximum value.
---@return number number Clamped number.
math.clamp = function(value, minimum, maximum)
	if value < minimum then
		return minimum
	elseif value > maximum then
		return maximum
	else
		return value
	end
end

---Calculates value fraction (2.56 -> 0.56, -1.28 -> 0.72).
---@param value number Input value.
---@return number number Value fraction.
math.fract = function (value)
	return value - math.floor(value)
end