# main.tf
provider "aws" {
  region = "us-east-1" # Change to relevant region
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0a55ba1c20b74fc30"  # Change to preferred Linux image 
  instance_type = "t4g.micro"
  key_name      = "test_kp"  # Change to relevant EC2 key pair

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
    command     = "ansible-playbook -i '${aws_instance.ec2_instance.public_ip},' -u ubuntu -i ${aws_instance.ec2_instance.public_ip}, --private-key=./test_kp.pem -e 'ansible_python_interpreter=/usr/bin/python3' ../ansible_docker_dotnet/site.yml"
    working_dir = "../ansible_docker_dotnet"
  }
}
