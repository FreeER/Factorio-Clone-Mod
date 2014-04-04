if data.raw.item.dna then
      dnaIngredients =
      {
        {"iron-plate", 50}, {"science-pack-1", 20}, {"dna", 100}, {"computer", 1}
      }
    else
      dnaIngredients =
        {
          {"iron-plate", 50}, {"science-pack-1", 20}
        }
    end

data:extend(
{
  {
    type = "recipe",
    name = "cloning-tank",
    enabled = "false",
    ingredients = dnaIngredients,
    time_needed = 20,
    result = "cloning-tank"
  }
})
