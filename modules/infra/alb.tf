# ALB is pretty straightforward, it consists of two listeners, one for HTTP and one for HTTPS, where the HTTP listener redirects to the HTTPS listener,
# which funnels traffic to the target group. This target group is later used by the ECS service to propagate the available tasks to.
# resource "aws_alb" "alb" {
#   name                       = "${var.app_name}-${var.app_environment}-alb"
#   internal                   = false
#   load_balancer_type         = "application"
#   security_groups            = [aws_security_group.alb.id]
#   subnets                    = aws_subnet.public.*.id
#   enable_deletion_protection = false
#
#   tags = {
#     Name        = "${var.app_name}-alb",
#     Environment = var.app_environment
#   }
# }
#
# resource "aws_alb_target_group" "alb-tg" {
#   name        = "${var.app_name}-${var.app_environment}-alb-tg"
#   port        = var.infra_params.app_port #8080
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = aws_vpc.main_vpc.id
#   depends_on  = [aws_alb.alb]
#
#   health_check {
#     healthy_threshold   = "3"
#     interval            = "300"
#     protocol            = "HTTP"
#     matcher             = "200-299"
#     timeout             = "3"
#     path                = "/api/health"
#     unhealthy_threshold = 5
#   }
#
#   tags = {
#     Name        = "${var.app_name}-alb-tg",
#     Environment = var.app_environment
#   }
# }
#
# # Create a HTTP listener. Listen port 80, then redirects HTTP to HTTPS
# # By configuring ALB with listeners that redirect HTTP (port 80) to HTTPS (port 443), all HTTP requests will be redirected to HTTPS,
# # ensuring that SSL/TLS is used for all communications.
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_alb.alb.id
#   port              = "80"
#   protocol          = "HTTP"
#
#   default_action {
#     type = "redirect"
#     target_group_arn = aws_alb_target_group.alb-tg.id
#     type             = "forward"
#
#     redirect {
#       port        = 443
#       protocol    = "HTTP"
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_alb.alb.id
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.infra_params.alb_tls_cert_arn
#
#   default_action {
#     target_group_arn = aws_alb_target_group.alb-tg.id
#     type             = "forward"
#   }
# }
resource "aws_alb" "alb" {
  name                       = "${var.app_name}-${var.app_environment}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = aws_subnet.public.*.id
  enable_deletion_protection = false

  tags = {
    Name        = "${var.app_name}-alb",
    Environment = var.app_environment
  }
}

resource "aws_alb_target_group" "alb-tg" {
  name        = "${var.app_name}-${var.app_environment}-alb-tg"
  port        = var.infra_params.app_port #8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main_vpc.id
  depends_on  = [aws_alb.alb]

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "3"
    path                = "/api/health"
    unhealthy_threshold = 5
  }

  tags = {
    Name        = "${var.app_name}-alb-tg",
    Environment = var.app_environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb-tg.id
    type             = "forward"
  }
}
