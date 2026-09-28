locals {
  subnets = {
    public_az1 = {
      cidr = "10.0.1.0/24"
      az   = var.availablity_zones[0]
      tier = "public"
    }

    public_az2 = {
      cidr = "10.0.2.0/24"
      az   = var.availablity_zones[1]
      tier = "public"
    }

    frontend_az1 = {
      cidr = "10.0.11.0/24"
      az   = var.availablity_zones[0]
      tier = "frontend"
    }

    frontend_az2 = {
      cidr = "10.0.12.0/24"
      az   = var.availablity_zones[1]
      tier = "frontend"
    }

    backend_az1 = {
      cidr = "10.0.21.0/24"
      az   = var.availablity_zones[0]
      tier = "backend"
    }

    backend_az2 = {
      cidr = "10.0.22.0/24"
      az   = var.availablity_zones[1]
      tier = "backend"
    }

    database_az1 = {
      cidr = "10.0.31.0/24"
      az   = var.availablity_zones[0]
      tier = "database"
    }

    database_az2 = {
      cidr = "10.0.32.0/24"
      az   = var.availablity_zones[1]
      tier = "database"
    }
  }
}

resource "aws_subnet" "subnets" {
  for_each = local.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "production-3tier-${each.key}"
    Tier = each.value.tier
  }
}