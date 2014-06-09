data:extend(
{
  {
    type = "item",
    name = "cloning-tank",
    icon = "__clone__/graphics/icons/cloning-tank.png",
    flags = {"goes-to-quickbar"},
    subgroup = "defensive-structure",
    order = "c[fluid]-a[cloning-tank]",
    place_result = "cloning-tank",
    stack_size = 10
  }
})

if not data.raw.item["waste"] then -- if waste has not been added by another mod
  data:extend({
    {
      type = "item",
      name = "Clonewaste",
      icon = "__clone__/graphics/icons/cloning-tank.png",
      flags = {"goes-to-quickbar"},
      subgroup = "intermediate-product",
      order = "a[items]-a[Clonewaste]",
      stack_size = 1000
    }
  })
end
