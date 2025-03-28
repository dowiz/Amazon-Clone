// Provider
provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

// Create ec2 instance
resource "aws_instance" "Jenkins" {
  availability_zone      = "eu-north-1a"
  ami                    = "ami-08eb150f611ca277f"
  instance_type          = "t3.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.JenkinsTerraformSG.id]

  // Create main disk
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    tags = {
      "name" = "root disk"
    }
  }

  tags = {
    Name = "Jenkins"
  }

  // User script
  user_data = file("files/install_jenkins_and_docker.sh")
}


// Create security group
resource "aws_security_group" "JenkinsTerraformSG" {
  name        = "JenkinsTerraformSG"
  description = "Allow 22, 80, 443, 1433, 5034, 8080 inbound traffic"
}

// Define the ingress rules
resource "aws_security_group_rule" "ingress_rules" {
  for_each = {
    "ssh"           = { from_port = 22, to_port = 22, description = "Allow SSH" }
    "http"          = { from_port = 80, to_port = 80, description = "Allow HTTP" }
    "https"         = { from_port = 443, to_port = 443, description = "Allow HTTPS" }
    "mssql"         = { from_port = 1433, to_port = 1433, description = "Allow MSSQL" }
    "grafana"       = { from_port = 3000, to_port = 3000, description = "Allow Grafana" }
    "backend"       = { from_port = 5034, to_port = 5034, description = "Allow Backend" }
    "jenkins"       = { from_port = 8080, to_port = 8080, description = "Allow Jenkins" }
    "sonarqube"     = { from_port = 9000, to_port = 9000, description = "Allow SonarQube" }
    "prometheus"    = { from_port = 9090, to_port = 9090, description = "Allow Prometheus" }
    "node_exporter" = { from_port = 9100, to_port = 9100, description = "Allow Node Exporter" }
  }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.JenkinsTerraformSG.id
  description       = each.value.description
}

// Define the egress rule
resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.JenkinsTerraformSG.id
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.Jenkins.id
  allocation_id = var.elastic_ip_Allocation_ID
}

resource "null_resource" "print_ip" {
  provisioner "local-exec" {
    command = "echo Jenkins Public (elastic) IP: ${aws_eip_association.eip_assoc.public_ip}"
  }
}

