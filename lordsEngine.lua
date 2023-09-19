
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
		Shape = "Square",
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
		Shape = "Square",
	})

	function update()
		engine.tick()
	end
	
	Pasting this in will make a yellow square appear on the left side of the screen
	<----->
	
	Collision Detection
	instance:IsTouching(instance)
]]

video = gdt.VideoChip0

game = {}

game.workspace = {}

game.setup = function(obj)
	video = obj
end

globalTickCount = 0

local function uuid()
		math.randomseed(globalTickCount)
		local random = math.random
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
		globalTickCount += 1
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

function is_colliding(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x1 + w1 > x2 and
        y1 < y2 + h2 and y1 + h1 > y2
end

function findSelf(tbl)
	for i,v in pairs(game.workspace) do
			if v.Name == tbl.Name then
					return v
			end
	end
end

game.Instance = {}
game.Instance.New = function(tbl)
	local instance = tbl
	
	if instance.Name == nil then
		--- Generate Random Id ---
		instance.Name = uuid()
		print(instance.Name)
	end
	
	instance.Spawn = function()
		--print("Spawning "..tbl.Name)
		table.insert(game.workspace,instance)
		
		for i,v in pairs(game.workspace) do
				if v.Name == tbl.Name then
						return v
				end
		end
		
	end
	
	function instance:Destroy()
		for i,v in pairs(game.workspace) do
				if v.Name == tbl.Name then
						table.remove(game.workspace,i)
				end
		end
	end
	
	function instance:IsTouching(self)
		
		if self.Shape == "Square" then
			
			local colliding = {}
			
			local x1,y1 = self.Position.X,self.Position.Y
			local w1,h1 = self.Size.X,self.Size.Y
			for i,v in pairs(game.workspace) do
				local x2,y2 = v.Position.X,v.Position.Y
				local w2,h2 = v.Size.X,v.Size.Y
				if is_colliding(x1, y1, w1, h1, x2, y2, w2, h2) then
					table.insert(colliding,v)
				end
			end
			table.remove(colliding,1)
			
			return colliding
		end
	end
	
	return instance.Spawn()
end

function drawobj(tbl)
	local sizeAndPos1 = vec2(tbl.Position.X-tbl.Size.X,tbl.Position.Y-tbl.Size.Y)
	local sizeAndPos2 = vec2(tbl.Position.X+tbl.Size.X,tbl.Position.Y+tbl.Size.Y)
	if tbl.Shape == "Circle" then
		video:FillCircle(tbl.Position,tbl.Size.X,tbl.Colour)
	elseif tbl.Shape == "Square" then
		video:FillRect(sizeAndPos1,sizeAndPos2,tbl.Colour)
	end
	--- Do velocity junk bum
	tbl.Position = tbl.Position + vec2(tbl.Velocity.X/100,tbl.Velocity.Y/100)
end

game.tick = function()
 globalTickCount += 1
	video:Clear(color.black)
	--- Draw instances ---
	
	for i,v in pairs(game.workspace) do
			drawobj(v)
	end
end

return game
