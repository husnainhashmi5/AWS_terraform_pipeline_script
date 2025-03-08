
# ECS Auto Scale target
resource "aws_appautoscaling_target" "asg-ecs-target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  tags = {
    Name        = "${var.app_name}-asg-ecs-target"
    Environment = var.app_environment
  }
}

# You can have multiple rules on when to scale the number of tasks, namely based on either memory usage or cpu utilization. For demonstration purposes
resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.asg-ecs-target.resource_id
  scalable_dimension = aws_appautoscaling_target.asg-ecs-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.asg-ecs-target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.asg-ecs-target.resource_id
  scalable_dimension = aws_appautoscaling_target.asg-ecs-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.asg-ecs-target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}
