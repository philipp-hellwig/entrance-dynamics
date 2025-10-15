# file for creating an environment for an agent simulation:
library(m4ma)
library(predped)


create_environment <- function(){
  # instantiate door and interactables:
  revolving_door <- predped::rectangle(
    center=c(0,0),
    size=c(0.5,2.5),
    interactable=FALSE
  )
  interactable_top <- predped::rectangle(
    center=c(0,7),
    size=c(9,.5),
    forbidden=1:3
  )
  interactable_bottom <- predped::rectangle(
    center=c(0,-7),
    size=c(9,.5),
    forbidden=c(1,3,4)
  )
  
  # instantiate background and walls:
  environment <- predped::background(
    shape = predped::rectangle(
      center = c(0, 0),
      size = c(10, 15)
    ),
    objects = list(
      revolving_door,
      interactable_top,
      interactable_bottom,
      # non-interactable walls
      predped::rectangle(
        center=c(-3.1,0),
        size=c(3.6,1),
        interactable=FALSE
      ),
      predped::rectangle(
        center=c(3.1,0),
        size=c(3.6,1),
        interactable=FALSE
      ),
      predped::rectangle(
        center=c(1.5,0),
        size=c(0.5,3),
        interactable=FALSE
      ),
      predped::rectangle(
        center=c(-1.5,0),
        size=c(0.5,3),
        interactable=FALSE
      )
    ),
    entrance = c(0, -6),
    exit = c(0, 6),
    # limited_access = list(segment(from=c(0,0),to=c(2.5,0)), segment(from=c(0,0),to=c(-2.5,0)))
  )
  return(environment)
}