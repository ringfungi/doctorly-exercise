# doctorly-exercise

# Task 1

This Ansible playbook deploys a docker stack locally to run a .NET core Hello World type of app and a MySQL database. Ensure that Docker and Docker Compose are installed on your machine.

Run the playbook using the following command:

`ansible-playbook site.yml`

NOTE: Not extensibly tested. Encountered an docker-compose issue running the playbook on my machine that I had no  time to properly debug

# Task 2
> How would you structure your Terraform project if you have multiple environments
and use different cloud providers?

```bash
terraform/
|-- environments/
|   |-- staging/
|   |   |-- main.tf
|   |   |-- ...
|   |   `-- providers.tf
|   |-- prod/
|   |   |-- main.tf
|   |   |-- ...
|   |   `-- providers.tf
|-- modules/
|   |-- aws/
|   |   |-- main.tf
|   |   |-- ...
|   |-- azure/
|   |   |-- main.tf
|   |   |-- ...
|-- global/
|   |-- main.tf
|   |-- ...
|-- providers.tf
|-- ...
```

This would be the generic directory tree for a terraform project with multiple envs and cloud providers. The environments/ directory contains subdirectories for each env, which in turn have their own Terraform configuration files.
The modules/ directory contains reusable modules for different cloud providers.
The global/ directory contains Terraform files for common resources across all envs.
The providers.tf file defines the cloud providers and their configurations and which modules to use for each provider.
The variables.tf file contains variables that are common across envs, but with potentially different vaules for each env.

## Terraform 

The Terraform script provided creates a Ubuntu AWS EC2 instance, installs Ansible executes the previously created playbook. It defines an AWS provider specifying the desired region anf creates an EC2 instance with the specified AMI, instance type and key pair. It also includes user data, a bash script to update the package list and install Ansible that runs on instance launch. It declares an output variable that provides the public IP address of the EC2 instance. Lastly, the null_resource uses the local-exec provisioner to run the ansible-playbook command on the EC2 instance, taking in the previously outputted public IP address.

To run it, replace the placeholders `REGION`, `AMI`, `KEY_PAIR_NAME` and `PRIVATE_KEY_PATH` with your own and then execute the following commands:

``terraform init``

And then:

``terraform apply``

# Task 3

> If you have multiple Ubuntu prod instances, how would you monitor them? What would be your
monitoring strategy?

I'd go with Datadog, since that's the monitoring platform I'm most comfortable with. In order to monitor multiple Ubuntu production instances with Datadog, I'd have to set up a Datadog agent on each instance to collect metrics and logs, using my Datadog API key. The collected metrics could include CPU and memory use, disk I/O and network traffic, and application metrics such as latency, error rates and cache hit rate, for example.

I'd also enable APM to trace requests and understand/visualize service dependencies.

I'd set up alerts for critical metrics/events, such as server response time exceeding a certain threshold, DB connection errors, etc., and would configure them to be sent through email, Slack or other relevant channels.

For log collection, a potential solution could be agent-based logging, collecting logs from log files on the instances. It'd be importante to define log retention policies to manage storage costs and ensure compliance.

If there are any SLOs defined, it'd be important to create dashboards to visualize key metrics/performance indicators, so SLIs regarding the state of the instances could be monitored and assessed at a glance. 

If the instances are hosted on a cloud provider (AWS, for example), I'd integrate Datadog with cloud monitoring services such as AWS CloudWatch using a plugin, in order to unify all the metrics.
