local dnaIngredients
local dnaCategory
if data.raw.fluid["dna"] then
    dnaIngredients =
      {
        {"iron-plate", 50}, {"science-pack-1", 20}, {type="fluid", name="dna", amount=100}, {"computer", 1}
      }
      dnaCategory = "crafting-with-fluid"
  else
    dnaIngredients =
      {
        {"iron-plate", 50}, {"science-pack-1", 20}
      }
    dnaCategory = "advanced-crafting"
end

data:extend(
{
  {
    type = "recipe",
    name = "cloning-tank",
    enabled = "false",
    ingredients = dnaIngredients,
    category = dnaCategory,
    time_needed = 20,
    result = "cloning-tank"
  },
  {
    type = "recipe-category",
    name = "cloning"
  },
  {
    type = "recipe",
    name = "maintain_clone",
    enabled = "false",
    ingredients = {{type="fluid", name="dna", amount=1}},
    category = "cloning",
    time_needed = 10,
    result = "Clonewaste"
  }
})
