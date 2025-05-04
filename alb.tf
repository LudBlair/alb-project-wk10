# Create Application Load Balancer
resource "aws_lb" "alb1" {
  name                       = "alb-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg2.id]
  subnets                    = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  enable_deletion_protection = false

}

# Target group for the application load balancer
resource "aws_lb_target_group" "tg1" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"

  }
  depends_on = [module.vpc]
}

# attach instances to target group

resource "aws_lb_target_group_attachment" "tga1" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.server1.id
  port             = 80

}

resource "aws_lb_target_group_attachment" "tga2" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.server2.id
  port             = 80

}


# Create listener
resource "aws_lb_listener" "list1" {
  load_balancer_arn = aws_lb.alb1.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}