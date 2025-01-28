# Infrastructure Description Schema

## Overview
This schema provides a standardized way to describe cloud infrastructure components and their relationships. It follows a hierarchical structure that groups resources by their logical function and physical placement.

## Schema Structure

### Root Element
```json
{
  "Resources": [] 
}
```

### Resource Types
Resources are defined with these standard attributes:
- `Type`: Primary classification (VPC, Compute, Database, etc.)
- `Count`: Number of instances required
- `Subtypes`: Array of logical groupings within the resource

### Taxonomy

1. **Infrastructure Boundaries**
   - VPC (Virtual Private Cloud)
     - Defines the network boundary
     - Contains all other resources

2. **Logical Groupings for VPCs (Subtypes)**
   - CICD: CI/CD infrastructure components
   - Application: Production application infrastructure
   
3. **Resource Categories**
   - Network Resources
     - AvailabilityZone
     - Subnet (Public/Private)
   - Compute Resources
     - EC2 instances
     - Specific instance types (t2.micro, t3.micro, etc.)
   - Database Resources
     - Type: Database
     - For Managed Databases:
       - Subtype: RDS, Aurora, etc.
       - Engine: postgres, mysql, mariadb, etc.
     - For Non-Managed Databases:
       - Subtype: Direct database type (MongoDB, Cassandra, etc.)

## Schema Rules

1. **Hierarchy**
   - Resources must belong to a Subtype
   - Subtypes must belong to a primary Resource
   
2. **Required Fields**
   - Type
   - Count
   - Subtype (for grouped resources)


## Example Usage

```json
{
  "Resources": [
    {
      "Type": "VPC",
      "Count": 1,
      "Subtypes": [
        {
          "Subtype": "Application",
          "Resources": [
            {
              "Type": "Compute",
              "Subtype": "EC2",
              "InstanceType": "t2.micro",
              "Count": 1
            }
          ]
        }
      ]
    }
  ]
}
```
