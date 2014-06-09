if data.raw.fluid["dna"] then dnaPrereqs = {"dna"} else dnaPrereqs = {"alien-technology"} end

data:extend({
  {
    type = "technology",
    name = "cloning",
    icon = "__clone__/graphics/technology/cloning-tank.png",
    effects =
    {
      {type = "unlock-recipe", recipe = "cloning-tank"},
      {type = "unlock-recipe", recipe = "maintain_clone"}
    },
    prerequisites = dnaPrereqs,
    unit =
    {
      count = 50,
      ingredients =
      {
        {"science-pack-1", 6},
        {"science-pack-2", 6}
      },
      time = 30
    }
  }
})
