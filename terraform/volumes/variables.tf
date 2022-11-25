variable "openstack_user_name" {}

variable "openstack_tenant_name" {}

variable "openstack_password" {}

variable "openstack_auth_url" {}

variable "openstack_region" {}

variable "openstack_domain_name" {}

variable "openstack_flavor" {}

#Component	Partner Owner	RAM (in GB)	CPU	STORAGE (in GB)	Note
#medium #SPOTTED PORTAL	ENG	2	2	20	considering the front-end and a custom developed back-end component
#large #IDRA	ENG	8	4	40	this setup includes all Idra components and the NGSI Broker manager (https://github.com/OPSILab/NGSI-LDBrokerManager)
#medium #CONTEXT BROKER	ENG	4	2	20	https://fiware-orion.readthedocs.io/en/master/admin/diagnosis.html#resource-availability
#special one 8vcpus y 32gb ram #OBJECT STORAGE	ENG	32	8	400 (4 disk * 100GB each)	https://blog.min.io/best-practices-minio-virtualized/
#small #DATA MODEL MAPPER	ENG	2	1	10
#PROCESSING SUB-SYSTEM	LAT40

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
