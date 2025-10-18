setwd("C:/Users/13579681/Desktop/MSc/3/Modelling Minds - From Neural Circuits to Mobile Agents/assignments/entrance-dynamics/")
library(predped) 
library(parallel)

source("environment.R")
source("agent_spawning.R")

# Simulation Parameters ----
angles <- seq(0, 2 * pi, 0.02)
seed <- 1
num_agents <- 50
rotate_door <- FALSE
simulation_iterations <- 300

parameters <- load_parameters()[["params_archetypes"]]
archetypes  <- c("BaselineEuropean","DrunkAussie")
weights <- c(0.75, 0.25)

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
# base::plot(agent_coords[["x"]], agent_coords[["y"]], main="Agent spawn positions")

# Simulation ----

# setup function that runs every iteration
update_sim <- function(state){
  if(rotate_door){
    # get appropriate angle index based on iteration
    index <- iteration(state) - (iteration(state) %/% (length(angles))) * length(angles)
    index <- index + 1
    orientation(objects(state@setting)[[1]]) <- angles[index]
  }
  # reset goals so that agents continually move through the door:
  for (i in seq_along(agents(state))){
    agent_i <- agents(state)[[i]]

    if(center(agent_i)[2] > 5){
      goals(agent_i) <- list(goal(position = c(runif(1, -2, 2), -6.5)))
    }
    else if(center(agent_i)[2] < -5){
      goals(agent_i) <- list(goal(position = c(runif(1, -2, 2), 6.5)))
    }
    agents(state)[[i]] <- agent_i
  }
  return(state)
}

# run simulation
trace <- predped::simulate(
  model,
  print_iteration = TRUE,
  individual_differences = FALSE,
  iteration = simulation_iterations,
  initial_agents = init_agents,
  fx = update_sim
)

# plot and save to .gif
plt <- plot(trace)
path <- paste0(
  gif_dir, 
  "sim_entrance", 
  "_agents", num_agents,
  "_rotatedoor", rotate_door,
  "_iter", simulation_iterations,
  ".gif",
  sep=""
)
gifski::save_gif(lapply(plt, print), file.path(path), delay = 1/20)


# goal stack:
# goal <- list(
#   list(
#     goal(position = c(0,0), id = "placeholder")
#   ),
#   list(
#     goal(...)
#   )
# )

# goals(agent)