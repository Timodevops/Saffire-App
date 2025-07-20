# AWS Budget to monitor monthly spending for EC2
resource "aws_budgets_budget" "saffire-dev_budget" {
  name         = "AppBudget"
  budget_type  = "COST"
  limit_amount = "500"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 100.0
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    # List of subscribers for the notification
    subscriber_email_addresses = ["timoige87@gmail.com"]
  }

  tags = {
    Name = "saffire-dev_budget"
  }
}