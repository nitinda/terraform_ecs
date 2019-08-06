# resource "aws_security_group" "demo_ecs_ec2_ebs_security_group_alb" {
#     name = "terraform-demo-ecs-ec2-ebs-alb-sg"
#     description = "ALB Security Group"
#     vpc_id = "${var.vpc_id}"
#     tags = "${merge(var.common_tags, map(
#         "Name", "terraform-demo-ecs-ec2-ebs-alb-sg",
#     ))}"    
#     ingress {
#         from_port   = 443
#         to_port     = 443
#         protocol    = "tcp"
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#     }
#     ingress {
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#     }
#     egress {
#         # allow all traffic to private SN
#         from_port   = "0"
#         to_port     = "0"
#         protocol    = "-1"
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#     }
# }