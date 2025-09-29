# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  provider = aws.primary
  name     = "DR-Alerts"
}

# SNS Subscription to send email alerts
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "vimalgrm@gmail.com"
}

# CloudWatch Alarm for S3 replication failures
resource "aws_cloudwatch_metric_alarm" "s3_replication_failure" {
  provider            = aws.primary
  alarm_name          = "S3ReplicationFailure"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ReplicationFailures"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_actions       = [aws_sns_topic.alerts.arn]
}
