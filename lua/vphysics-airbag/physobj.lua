VA.PhysObj = VA.PhysObj or {}

function VA.PhysObj.IsFinite (physObj)
	if not physObj:IsValid () then return true end
	
	if not VA.Vector.IsFinite (physObj:GetPos           ()) then return false end
	if not VA.Angle.IsFinite  (physObj:GetAngles        ()) then return false end
	if not VA.Vector.IsFinite (physObj:GetVelocity      ()) then return false end
	if not VA.Vector.IsFinite (physObj:GetAngleVelocity ()) then return false end
	
	return true
end

function VA.PhysObj.IsSane (physObj)
	if not physObj:IsValid () then return true end
	
	if not VA.Vector.IsSanePosition (physObj:GetPos           ()) then return false end
	if not VA.Angle.IsSane          (physObj:GetAngles        ()) then return false end
	if not VA.Vector.IsFinite       (physObj:GetVelocity      ()) then return false end
	if not VA.Vector.IsFinite       (physObj:GetAngleVelocity ()) then return false end
	
	return true
end

function VA.PhysObj.IsOctreeSane (physObj)
	if not physObj:IsValid () then return true end
	
	if not VA.Vector.IsSanePosition (physObj:GetPos           ()) then return false end
	
	return true
end

function VA.PhysObj.Defuse (physObj, disableMotionWhenDone)
	VA.PhysObj.Print (physObj)
	if not physObj:IsValid () then return end
	
	local finished = true
	
	local position        = physObj:GetPos           ()
	local angle           = physObj:GetAngles        ()
	local velocity        = physObj:GetVelocity      ()
	local angularVelocity = physObj:GetAngleVelocity ()
	
	local i = 0
	while i < 5 and
		  (not VA.Vector.IsFinite (position       ) or
		   not VA.Angle.IsFinite  (angle          ) or
		   not VA.Vector.IsFinite (velocity       ) or
		   not VA.Vector.IsFinite (angularVelocity)) do
		i = i + 1
		
		-- If position is not zeroed before angle,
		-- *** ERROR *** Excessive sizelevel (##) for element spam can happen with ragdolls
		if not VA.Vector.IsFinite (position) then
			physObj:SetPos (vector_origin)
			VA.Print ("\t        { [Iteration " .. i .. "] Position zeroed, was [" .. tostring (position) .. "]. }")
			finished = false
		end
		
		if not VA.Angle.IsFinite  (angle) then
			physObj:SetAngles (angle_zero)
			VA.Print ("\t        { [Iteration " .. i .. "] Angle zeroed, was (" .. tostring (angle) .. "). }")
			finished = false
		end
		
		-- If angle is not zeroed before position, position
		-- may instantly snap back to a non-finite value.
		position = physObj:GetPos ()
		if not VA.Vector.IsFinite (position) then
			physObj:SetPos (vector_origin)
			VA.Print ("\t        { [Iteration " .. i .. "] Position zeroed, was [" .. tostring (position) .. "]. }")
			finished = false
		end
		if not VA.Vector.IsFinite (velocity) then
			physObj:SetVelocity (vector_origin)
			VA.Print ("\t        { [Iteration " .. i .. "] Velocity zeroed, was [" .. tostring (velocity) .. "]. }")
			finished = false
		end
		
		if VA.Vector.IsFinite (physObj:GetPos ()) and
		   VA.Angle.IsFinite (physObj:GetAngles ()) and
		   not VA.Vector.IsFinite (angularVelocity) then
			local motionEnabled = physObj:IsMotionEnabled ()
			physObj:EnableMotion (true)
			physObj:EnableMotion (false)
			physObj:EnableMotion (motionEnabled)
			VA.Print ("\t        { [Iteration " .. i .. "] Angular velocity zeroed, was [" .. tostring (angularVelocity) .. "]. }")
			finished = false
		end
		
		position        = physObj:GetPos           ()
		angle           = physObj:GetAngles        ()
		velocity        = physObj:GetVelocity      ()
		angularVelocity = physObj:GetAngleVelocity ()
	end
	
	if not VA.Vector.IsFinite (angularVelocity) then
		VA.Print ("\t        { [Iteration " .. i .. "] Cannot zero angular velocity ([" .. tostring (angularVelocity) .. "])! }")
	end
	
	if (not VA.Vector.IsFinite (position       ) or
		not VA.Angle.IsFinite  (angle          ) or
		not VA.Vector.IsFinite (velocity       ) or
		not VA.Vector.IsFinite (angularVelocity)) then
		VA.Print ("\t        { ABORTING, PhysObj still not finite after 5 iterations. }")
	elseif disableMotionWhenDone then
		physObj:EnableMotion (false)
	end
end

function VA.PhysObj.Print (physObj)
	if physObj:IsValid () then
		VA.Print ("\tPhysObj { " .. physObj:GetMass() .. " kg at [" .. tostring(physObj:GetPos()) .. "] ∠(" .. tostring(physObj:GetAngles()) .. ") }")
		VA.Print ("\t        { moving at [" .. tostring(physObj:GetVelocity()) .. "] ∠[" .. tostring(physObj:GetAngleVelocity()) .. "] }")
	else
		VA.Print ("\tPhysObj { Invalid }")
	end
end
