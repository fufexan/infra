<h1 align="center">fufexan/infra</h1>

# 🗒 About

Declarative server management using NixOS & Terraform.

## ⚙️ Servers

### arm-server

OCI `VM.Standard.A1.Flex` with 4 OCPUs and 24G RAM. Currently manually managed,
planning management using Terraform.

Hosts a Minecraft and a Matrix Synapse server.

### eta

OCI `VM.Standard.E2.1.Micro` with 1 OCPU and 1G RAM. Used for testing purposes,
like deploying small services.

Managed with Terraform.

### homesv

Dell Latitude D630 with a Core 2 Duo and 2G DDR2. My only home server, runs a
Samba and Transmission server. Mostly used for file access across the house.
