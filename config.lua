--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

local aspectRatio = display.pixelHeight / display.pixelWidth
local width = 360
local height = width * aspectRatio

application =
{
	content =
	{
		width = width,
		height = height, 
		scale = "letterbox",
		fps = 60,
		
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
	},
}
