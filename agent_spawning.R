# create agents and initialize at random positions for a simulation:

# Helpers ----

# get random spawn position for an agent:
get_spawn_position <- function(){
  if(sample(c(0,1),1)==1){
    # spawn in top region
    y <- runif(1, 2.5, 7)
  }else{
    # spawn in bottom region
    y <- runif(1, -7, -2.5)
  }
  pos <- c(runif(1, -5, 5), y)
  return(pos)
}


# returns FALSE if position is too close to position of other agents
valid_spawn_position <- function(pos, agents){
  if(length(agents)==0){
    return(TRUE)
  }
  for(agent in agents){
    dist <- raster::pointDistance(pos, as.vector(center(agent)), FALSE)
    if(dist <= (agent@radius * 2)){
      return(FALSE)
    }
  }
  return(TRUE)
}


get_agent_coordinates <- function(agents){
  # store x, y coordinates for sanity check:
  x <- c()
  y <- c()
  for(agent in agents){
    pos <- as.vector(center(agent))
    x <- append(x, pos[1])
    y <- append(y, pos[2])
  }
  return(list(x=x,y=y))
}


# Main function ----
create_agent_population <- function(num_agents, model, seed=1){
  set.seed(seed)
  my_agents <- list()
  for (i in 1:num_agents){
    while(TRUE){
      pos <- get_spawn_position()
      if(valid_spawn_position(pos, my_agents)){
        break
      }
    }
    my_agents[[i]] <- add_agent(model, position=pos)
  }
  return(my_agents)
}
