data:extend({
  {
    type = "container",
    name = "cloning-tank",
    icon = "__clone__/graphics/icons/cloning-tank.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "cloning-tank"},
    max_health = 50,
    corpse = "medium-remnants",
    collision_box = {{-0.5, -0.8}, {0.5, 0.8}},
    --fast_replaceable_group = "container",
    selection_box = {{-0.6, -0.9}, {0.6, 0.9}},
    inventory_size = 16,
    picture =
    {
      filename = "__clone__/graphics/entity/cloning-tank/cloning-tank.png",
      priority = "extra-high",
      width = 50,
      height = 73,
      shift = {-0.1, 0}
    }
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
