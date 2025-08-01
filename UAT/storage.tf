
# S3 Bucket for application storage with private access
resource "aws_s3_bucket" "saffire-uat_bucket" {
  bucket = "saffire-uat-app-logs-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "saffire-uay-app-logs"
  }
}

# Enforce ownership controls on the bucket
resource "aws_s3_bucket_ownership_controls" "saffire-uat_bucket_ownership_controls" {
  bucket = aws_s3_bucket.saffire-uat_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# IAM Role to manage S3 bucket
resource "aws_iam_role" "s3_management_role" {
  name = "CloudIAMRoleName"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for the IAM Role to allow access to the S3 bucket
resource "aws_iam_policy" "s3_management_policy" {
  name        = "S3ManagementPolicy"
  description = "Policy for S3 management role to manage bucket access."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "${aws_s3_bucket.saffire-uat_bucket.arn}",
          "${aws_s3_bucket.saffire-uat_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Attach the policy to the IAM Role
resource "aws_iam_role_policy_attachment" "s3_management_role_attachment" {
  role       = aws_iam_role.s3_management_role.name
  policy_arn = aws_iam_policy.s3_management_policy.arn
}

# Define a bucket policy to enforce ownership and access permissions
resource "aws_s3_bucket_policy" "saffire-uat_bucket_policy" {
  bucket = aws_s3_bucket.saffire-uat_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow specific IAM role access
      {
        Sid       = "AllowS3Management",
        Effect    = "Allow",
        Principal = { "AWS" : aws_iam_role.s3_management_role.arn },
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "${aws_s3_bucket.saffire-uat_bucket.arn}",
          "${aws_s3_bucket.saffire-uat_bucket.arn}/*"
        ]
      },
      # Allow CloudTrail to write logs to this bucket
      {
        Sid    = "AllowCloudTrailWrite",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.saffire-uat_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}


# EBS Volume for additional storage attached to the web server
resource "aws_ebs_volume" "saffire-uat-app_web_ebs" {
  availability_zone = "us-west-2a" # Corrected spelling
  size              = 10           # Size in GB
  tags = {
    Name = "saffire-uat-app-web-ebs"
  }
}