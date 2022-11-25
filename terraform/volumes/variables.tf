variable "volumes" {
  description = "Volumes"
  type = map(
    object({
      name = string,
      description = string,
      size = number
    })
  )
  default = {
    vol1 = {
          name            = "SpottedPortal_Vol"
          description     = "Volume associated to the instance Spotted Portal, SPOTTED Project (ENG)."
          size            = 20
      }
    vol2 = {
          name            = "Idra_Vol"
          description     = "Volume associated to the instance Idra, SPOTTED Project (ENG)."
          size            = 40
    }
  }
}
