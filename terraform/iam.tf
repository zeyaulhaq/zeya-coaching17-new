# -------------------------------------------------------------------
# 1. TRUST POLICY - WHO is allowed to use (assume) this role
# -------------------------------------------------------------------
data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# -------------------------------------------------------------------
# 2. THE ROLE ITSELF
# -------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_role" {
  name               = "${local.prefix}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Name = "${local.prefix}-ecs-task-role"
  }
}

# -------------------------------------------------------------------
# 3. PERMISSIONS POLICY - WHAT the role is allowed to do
# -------------------------------------------------------------------
data "aws_iam_policy_document" "ecs_task_permissions" {

  # S3: list the contents of my buckets
  statement {
    sid       = "S3ListMyBuckets"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.prefix}-*"]
  }

  # S3: read and write files (objects) inside my buckets
  statement {
    sid       = "S3ReadWriteObjects"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::${local.prefix}-*/*"]
  }

  # DynamoDB: read and write items in my tables
  statement {
    sid = "DynamoDBReadWrite"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:table/${local.prefix}-*"
    ]
  }
}

# -------------------------------------------------------------------
# 4. ATTACH the permissions to the role
# -------------------------------------------------------------------
resource "aws_iam_role_policy" "ecs_task_permissions" {
  name   = "${local.prefix}-ecs-task-permissions"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_permissions.json
}