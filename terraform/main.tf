# main.tf
provider "aws" {
  region = "REGION" # Change to relevant region
}

resource "aws_instance" "ec2_instance" {
  ami           = "AMI"  # Change to preferred Linux image 
  instance_type = "t2.micro"
  key_name      = "KEY_PAIR_NAME"  # Change to relevant EC2 key pair

  tags = {
    Name = "ansible-ec2-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y ansible
              EOF
}

# output.tf
output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

# ansible_playbook.tf
resource "null_resource" "run_ansible_playbook" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -i '${self.public_ip},' -u ubuntu -i ${self.public_ip}, --private-key=PRIVATE_KEY_PATH -e 'ansible_python_interpreter=/usr/bin/python3' ../ansible_docker_dotnet/site.yml"
    working_dir = "../ansible_docker_dotnet"
  }
}
