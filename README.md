# AWS Serverless Microservices

This module allows you to create a VPC, public and private subnets, a internet gateway, the main route table for the VPC and a NAT with a fix IP address on AWS.

## Compatibility

This module is meant for use with Terraform 1.1.9+ and tested using Terraform 1.2+. If you find incompatibilities using Terraform >=1.1.9, please open an issue.

## Usage

There are multiple examples included in the [examples](./examples/) folder but simple usage is as follows:

```hcl
module "network" {
  source          = "./modules/network"
  name            = "my-vpc"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = public_subnets = [
    {
      suffix = "web-1"
      az     = "eu-west-1a"
      cidr   = "10.0.0.0/28"
    },
    {
      suffix = "web-2"
      az     = "eu-west-1b"
      cidr   = "10.0.1.0/28"
    },
  ]
  private_subnets = [
    {
      suffix = "backend-1"
      az     = "eu-west-1a"
      cidr   = "10.0.2.0/28"
    },
    {
      suffix = "backend-2"
      az     = "eu-west-1b"
      cidr   = "10.0.3.0/28"
    },
  ]

  labels = {
    VPC        = "my-vpc"
    Environment = "dev"
  }
}
```

## Features

The AWS Network module will take the following actions:

1. Create a VPC.
2. Create an Internet Gateway.
3. Create the main route table routing all the outbound traffic to the Internet Gateway
4. Create public subnets, if requested.
5. Create private subnets, if requested.
6. Create a NAT with a fixed IP address, if requested and public subnets has been requested.
7. Create a fixed IP address for the NAT.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The VPC name and the prefix to be used for all the depending resources such as subnets. | `string` | n/a | yes |
| vpc_cidr | VPC IP address range. | `string` | `10.0.0.0/16` | no |
| public_subnets | Public subnets information. | <pre>list(object({<br>    suffix = string<br>    az     = string<br>    cidr   = string<br>  }))</pre> | `[]` | no |
| private_subnets | Private subnets information. | <pre>list(object({<br>    suffix = string<br>    az     = string<br>    cidr   = string<br>  }))</pre> | `[]` | no |
| enable_nat | Indicates if a NAT must be deployed or not. | `bool` | `true` | no |
| labels | The tags to be added to all the resources creates by this module. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The identifier of the VPC recently created. |
| public_subnets | The public subnets map object recently created. |
| private_subnets | The private subnets map object recently created. |


## Requirements

### Software

-   [Terraform](https://www.terraform.io/downloads.html) >= 1.1.9
-   [terraform-provider-aws] plugin ~> 4.13.0


### Permissions

In order to execute this module you must have a Role with the
following policies:

- `NetworkAdministrator`