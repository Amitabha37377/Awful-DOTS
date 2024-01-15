function createBezierLUT(points, pointCount)
	pointCount = pointCount or 100
	local lut = {}

	for t = 0, 1, 1 / pointCount do
		local a = (1 - t) * (1 - t) * (1 - t)
		local b = (1 - t) * (1 - t) * t
		local c = (1 - t) * t * t
		local d = t * t * t
		local x = a * points[1][1] + 3 * b * points[2][1] + 3 * c * points[3][1] + d * points[4][1]
		local y = a * points[1][2] + 3 * b * points[2][2] + 3 * c * points[3][2] + d * points[4][2]

		table.insert(lut, { x, y })
	end

	return lut
end

local createEase = function(lutOptions)
	local lut
	return function(t)
		if not lut then
			lut = {}
			for _, args in ipairs(lutOptions) do
				local subLut = createBezierLUT(args)
				for _, point in ipairs(subLut) do
					table.insert(lut, point)
				end
			end
		end

		local closestPoint
		for _, point in ipairs(lut) do
			if point[1] >= t then
				closestPoint = point
				break
			end
		end

		-- some of the most cursed lua syntax I've seen
		local closestY = closestPoint and closestPoint[2] or 1
		return closestY
	end
end

-- local M = {}

-- M.easeEmphasized = createEase({
-- 	{
-- 		{ 0,     0 },
-- 		{ 0.05,  0 },
-- 		{ 0.133, 0.06 },
-- 		{ 0.166, 0.4 },
-- 	},
-- 	{
-- 		{ 0.166, 0.4 },
-- 		{ 0.208, 0.82 },
-- 		{ 0.25,  1 },
-- 		{ 1,     1 },
-- 	},
-- })

-- M.easeEmphasizedDecel = M.createEase({
-- 	{
-- 		{ 0,    0 },
-- 		{ 0.05, 0.7 },
-- 		{ 0.1,  1 },
-- 		{ 1,    1 },
-- 	},
-- })

-- M.easeEmphasizedAccel = M.createEase({
-- 	{
-- 		{ 0,   0 },
-- 		{ 0.3, 0 },
-- 		{ 0.8, 0.15 },
-- 		{ 1,   1 },
-- 	},
-- })

-- M.easeStandard = M.createEase({
-- 	{
-- 		{ 0,   0 },
-- 		{ 0.2, 0 },
-- 		{ 0,   1 },
-- 		{ 1,   1 },
-- 	},
-- })

-- M.easeStandardDecel = M.createEase({
-- 	{
-- 		{ 0, 0 },
-- 		{ 0, 0 },
-- 		{ 0, 1 },
-- 		{ 1, 1 },
-- 	},
-- })

-- M.easeStandardAccel = M.createEase({
-- 	{
-- 		{ 0,   0 },
-- 		{ 0.3, 0 },
-- 		{ 1,   1 },
-- 		{ 1,   1 },
-- 	},
-- })


return createEase
