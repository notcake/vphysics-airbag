local math_huge = math.huge

function VA.IsFinite (x)
	if x ~= x then return false end
	
	if x == math_huge then return false end
	if x == -math_huge then return false end
	
	return true
end

VA.Vector = VA.Vector or {}

local VA_IsFinite = VA.IsFinite

function VA.Vector.IsFinite (v)
	return VA_IsFinite (v [1]) and
	       VA_IsFinite (v [2]) and
		   VA_IsFinite (v [3])
end

function VA.Vector.IsSanePosition (v)
	return -16384 <= v [1] and v [1] <= 16483 and
	       -16384 <= v [2] and v [2] <= 16483 and
	       -16384 <= v [3] and v [3] <= 16483
end

VA.Angle = VA.Angle or {}

local VA_IsFinite = VA.IsFinite

function VA.Angle.IsFinite (a)
	return VA_IsFinite (a [1]) and
	       VA_IsFinite (a [2]) and
		   VA_IsFinite (a [3])
end

function VA.Angle.IsSane (a)
	return -360 <= a [1] and a [1] <= 360 and
	       -360 <= a [2] and a [2] <= 360 and
	       -360 <= a [3] and a [3] <= 360
end
