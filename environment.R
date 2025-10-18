# file for creating an environment for an agent simulation:

create_environment <- function(){
  # instantiate door and interactables:
  revolving_door <- predped::rectangle(
    center=c(0,0),
    size=c(0.5,2.5),
    moveable=TRUE,
    interactable=FALSE
  )
  interactable_top <- predped::rectangle(
    center=c(0,7.4),
    size=c(9,.2),
    forbidden=1:3
  )
  interactable_bottom <- predped::rectangle(
    center=c(0,-7.4),
    size=c(9,.2),
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
    )
  )
  return(environment)
}
