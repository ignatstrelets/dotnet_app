resource "aws_autoscaling_group" "dotnet-app-server-asg" {
  max_size = 4
  min_size = 1
  desired_capacity = 1
  default_cooldown = 120
  launch_template {
    id = aws_launch_template.ubuntu-dotnet-promtail.id
  }
  vpc_zone_identifier = [data.aws_subnet.public.availability_zone_id]
  load_balancers = [aws_elb.elb.id]
}

resource "aws_autoscaling_policy" "increment" {
  autoscaling_group_name = aws_autoscaling_group.dotnet-app-server-asg.name
  name = "increment"
  policy_type = "StepScaling"
  adjustment_type = "ChangeInCapacity"
  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment = 1
  }
}

resource "aws_autoscaling_policy" "decrement" {
  autoscaling_group_name = aws_autoscaling_group.dotnet-app-server-asg.name
  name = "decrement"
  policy_type = "StepScaling"
  adjustment_type = "ChangeInCapacity"
  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment = -1
  }
}

resource "aws_cloudwatch_metric_alarm" "greater_than_80" {
  alarm_name          = "greater_than_80"
  namespace   = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic = "Average"
  threshold = 80
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period = 120
  alarm_actions = [aws_autoscaling_policy.increment.arn]
}

resource "aws_cloudwatch_metric_alarm" "less_than_20" {
  alarm_name          = "less_than_20"
  namespace   = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic = "Average"
  threshold = 20
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period = 120
  alarm_actions = [aws_autoscaling_policy.decrement.arn]
}