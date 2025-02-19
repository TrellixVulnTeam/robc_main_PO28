aws_profile 		= "superhero"
aws_region 		= "us-east-1"
localip 		= "177.228.64.228"
db_instance_class 	= "db.t1.micro"
dbname			= "superherodb"
dbuser			= "superhero"
dbpassword		= "superheropass"	
key_name		= "robc"
public_key_path		= "/home/rcarreon/.ssh/rcarreon_aws.pem"
domain_name		= "linuxsuperhero"
dev_instance_type	= "t2.micro"
dev_ami			= "ami-b73b63a0"
elb_healthy_threshold	= "2"
elb_unhealthy_threshold	= "2"
elb_timeout		= "3"
elb_interval		= "60"
asg_max 		= "2"
asg_min 		= "1"
asg_grace 		= "300"
asg_hct 		= "EC2"
asg_cap 		= "2"
lc_instance_type	= "t2.micro"
delegation_set 		= "N3GTFFZIMK1OM"

