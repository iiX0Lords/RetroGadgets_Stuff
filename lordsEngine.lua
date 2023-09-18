
--[[
  _                   _ _       ______             _            
 | |                 | ( )     |  ____|           (_)           
 | |     ___  _ __ __| |/ ___  | |__   _ __   __ _ _ _ __   ___ 
 | |    / _ \| '__/ _` | / __| |  __| | '_ \ / _` | | '_ \ / _ \
 | |___| (_) | | | (_| | \__ \ | |____| | | | (_| | | | | |  __/
 |______\___/|_|  \__,_| |___/ |______|_| |_|\__, |_|_| |_|\___|
                                              __/ |             
                                             |___/              
	
	Documentation
	
	Making an Instance Example
	<---------------------------->
	bird = engine.Instance.New({
		Name = "Duck", -- Needs to be unique otherwise you'll get bugs :)
		Position = vec2(15,video.Height/2),
		Colour = color.yellow,
		Size = vec2(2,2),
		Velocity = vec2(0,0),
	})

	All of the things inside the example table are required but you can always add your own :)
	
	
	Basic Example
	<------------------------------------>

	video = gdt.VideoChip0

	engine = require "lordEngine.lua"
	engine.setup(gdt.VideoChip0)

	bird = engine.Instance.New({
		Name = "Duck",
		Position = vec2(15,video.Height/2),
		Colour = color.yellow,
		Size = vec2(2,2),
		Velocity = vec2(0,0),
	})

	function update()
		engine.tick()
	end
	
	Pasting this in will make a yellow square appear on the left side of the screen
	
]]

video = gdt.VideoChip0

game = {}

game.workspace = {}

game.setup = function(obj)
	video = obj
end

game.Instance = {}
game.Instance.New = function(tbl)
	local instance = tbl
	instance.Spawn = function()
		print("Spawning "..tbl.Name)
		table.insert(game.workspace,instance)
		
		for i,v in pairs(game.workspace) do
				if v.Name == tbl.Name then
						return v
				end
		end
		
	end
	
	return instance.Spawn()
end

function drawobj(tbl)
	local sizeAndPos1 = vec2(tbl.Position.X-tbl.Size.X,tbl.Position.Y-tbl.Size.Y)
	local sizeAndPos2 = vec2(tbl.Position.X+tbl.Size.X,tbl.Position.Y+tbl.Size.Y)
	video:FillRect(sizeAndPos1,sizeAndPos2,tbl.Colour)
	--- Do velocity junk bum
	tbl.Position = tbl.Position + vec2(tbl.Velocity.X/100,tbl.Velocity.Y/100)
end

game.tick = function()
	video:Clear(color.black)
	--- Draw instances ---
	
	for i,v in pairs(game.workspace) do
			drawobj(v)
	end
end

return game
