library(predped) 
library(parallel)

source("environment.R")
source("agent_spawning.R")

# Simulation Parameters ----
angles <- seq(0, 2 * pi, 0.1)
seed <- 1
num_agents <- 30
archetypes = c("BaselineEuropean","DrunkAussie")
weights = c(0.75, 0.25)
parameters <- load_parameters()[["params_archetypes"]]
gif_dir <- "gifs/"
data_dir <- "data/"

# Create environment ----
abc_entrance <- create_environment()
plot(
  abc_entrance,
  plot_forbidden=TRUE,
  forbidden.color= "red"
)

# Create model ----
model <- predped::predped(
  setting = abc_entrance,
  archetypes = archetypes,
  weights = weights
)

# Add custom agents ----
init_agents <- create_agent_population(num_agents, model, seed=seed)

# plot spawn positions as sanity check:
agent_coords <- get_agent_coordinates(init_agents)
base::plot(agent_coords[["x"]], agent_coords[["y"]], main="Agent spawn positions")

# Simulation ----

# setup function that runs every iteration to rotate door:
rotate_door <- function(state){
  # get appropriate angle index based on iteration,
  # avoid indices larger than length of angles:
  index <- iteration(state) - (iteration(state) %/% (length(angles))) * length(angles)
  index <- index + 1
  # rotate door:
  orientation(objects(state@setting)[[1]]) <- angles[index]
  return(state)
}

# run simulation:
trace <- predped::simulate(
  model,
  print_iteration = TRUE,
  individual_differences = FALSE,
  iteration = 200,
  goal_number = 3,
  initial_agents = my_agents,
  fx = rotate_door
)

# plot and save to gif:
plt <- plot(trace)
path <- paste0(
  gif_dir,
  "revolving_doors_",
  num_agents,
  "_agents.gif",
  sep=""
)
gifski::save_gif(
  lapply(plt, print),
  file.path(path),
  delay = 1/20
)
