resource "aws_security_group" "alb" {
  name   = "alb-sg-${var.env}"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  name               = "bg-alb-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_tg.arn
  }
}

resource "aws_lb_target_group" "blue_tg" {
  name     = "blue-tg-${var.env}"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
  target_type = "instance"
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group" "green_tg" {
  name     = "green-tg-${var.env}"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
  target_type = "instance"
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

data "aws_instances" "blue_nodes" {
  filter {
    name   = "tag:kubernetes.io/cluster/${module.eks_blue.cluster_id}"
    values = ["owned"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instances" "green_nodes" {
  filter {
    name   = "tag:kubernetes.io/cluster/${module.eks_green.cluster_id}"
    values = ["owned"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

resource "aws_lb_target_group_attachment" "blue_attach" {
  for_each = toset(data.aws_instances.blue_nodes.ids)
  target_group_arn = aws_lb_target_group.blue_tg.arn
  target_id        = each.key
  port             = 30080
}

resource "aws_lb_target_group_attachment" "green_attach" {
  for_each = toset(data.aws_instances.green_nodes.ids)
  target_group_arn = aws_lb_target_group.green_tg.arn
  target_id        = each.key
  port             = 30080
}
