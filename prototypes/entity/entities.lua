function pipecoverspictures()
  return {
    north =
    {
      filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
      priority = "extra-high",
      width = 44,
      height = 32
    },
    east =
    {
      filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
      priority = "extra-high",
      width = 32,
      height = 32
    },
    south =
    {
      filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
      priority = "extra-high",
      width = 46,
      height = 52
    },
    west =
    {
      filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
      priority = "extra-high",
      width = 32,
      height = 32
    }
  }
end

function assembler2pipepictures()
  return
  {
    north =
    {
      filename = "__base__/graphics/entity/assembling-machine-2/pipe-north.png",
      priority = "extra-high",
      width = 41,
      height = 40,
      shift = {0.09375, 0.4375}
    },
    east =
    {
      filename = "__base__/graphics/entity/assembling-machine-2/pipe-east.png",
      priority = "extra-high",
      width = 41,
      height = 40,
      shift = {-0.71875, 0}
    },
    south =
    {
      filename = "__base__/graphics/entity/assembling-machine-2/pipe-south.png",
      priority = "extra-high",
      width = 41,
      height = 40,
      shift = {0.0625, -1}
    },
    west =
    {
      filename = "__base__/graphics/entity/assembling-machine-2/pipe-west.png",
      priority = "extra-high",
      width = 41,
      height = 40,
      shift = {0.78125, 0.03125}
    }
  }
end

local tank = {}
if data.raw.fluid["dna"] then
  tank.fluid_boxes =
    {
      {
        production_type = "input",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0, -1.5} }}
      },
      -- {
        -- production_type = "output",
        -- pipe_picture = assembler2pipepictures(),
        -- pipe_covers = pipecoverspictures(),
        -- base_area = 10,
        -- base_level = 1,
        -- pipe_connections = {{ type="output", position = {0, 1.5} }}
      -- },
      off_when_no_fluid_recipe = true
    }
else
  tank.fluid_boxes = nil
end

data:extend({
  {
    type = "assembling-machine",
    name = "cloning-tank",
    icon = "__clone__/graphics/icons/cloning-tank.png",
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "cloning-tank"},
    max_health = 50,
    corpse = "big-remnants",
    fluid_boxes = tank.fluid_boxes,
    collision_box = {{-0.75, -0.95}, {0.75, 0.95}},
    selection_box = {{-0.85, -1.05}, {0.85, 1.05}},
    animation =
    {
      --filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2.png",
      filename = "__clone__/graphics/entity/cloning-tank/cloning-tank.png",
      priority = "high",
      -- frame_width = 113,
      -- frame_height = 99,
      -- frame_count = 32,
      -- line_length = 8,
      frame_width = 50,
      frame_height = 73,
      frame_count = 1,
      line_length = 1,
      shift = {0, -0.04}
    },
    crafting_categories = {"cloning"},
    crafting_speed = 0.75,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      --emissions = 0.04 / 2.5
    },
    energy_usage = "150kW",
    ingredient_count = 1,
    --module_slots = 2,
    --allowed_effects = {"consumption", "speed", "productivity", "pollution"}
  },
  
  {
    type = "container",
    name = "player-remains",
    order = "playerremains",
    icon = "__clone__/graphics/icons/skeleton.png",
    flags = {"placeable-neutral", "player-creation"},
    max_health = 500000,
    --collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    inventory_size = 48,
    picture =
    {
      filename = "__clone__/graphics/entity/skeletons/skeleton_05.png",
      priority = "extra-high",
      width = 100,
      height = 100,
      shift = {0.3, 0}
    }
  }
})
