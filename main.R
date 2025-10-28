setwd("C:/Users/13579681/Desktop/MSc/3/Modelling Minds - From Neural Circuits to Mobile Agents/assignments/entrance-dynamics/")
library(predped) 
library(parallel)
library(ggplot2)

source("environment.R")
source("agent_spawning.R")


# Simulation Parameters ----
angles <- seq(0, 2 * pi, 0.02)
# if script is run multiple times
seed <- 1
num_agents <- 50
rotate_door <- TRUE
one_dir_flow <- FALSE
simulation_iterations <- 500

parameters <- load_parameters()[["params_archetypes"]]
archetypes  <- c("BaselineEuropean","DrunkAussie")
weights <- c(1, 0)

gif_dir <- "gifs/"
data_dir <- "data/"


# Create environment ----
abc_entrance <- create_environment(one_directional_flow=one_dir_flow)
plot(
  abc_entrance,
  plot_forbidden=TRUE,
  forbidden.color= "red"
) + 
  geom_hline(yintercept=6.5, linetype="dashed", ) +
  geom_hline(yintercept=-6.5, linetype="dashed") +
  geom_hline(yintercept=5, linetype="dotted", ) +
  geom_hline(yintercept=-5, linetype="dotted")


# Create model ----
model <- predped::predped(
  setting = abc_entrance,
  archetypes = archetypes,
  weights = weights
)


# Add custom agents at randomized spawn positions ----
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
  "_onedir", one_dir_flow,
  "_iter", simulation_iterations,
  ".gif",
  sep=""
)
gifski::save_gif(lapply(plt, print), file.path(path), delay = 1/20)
