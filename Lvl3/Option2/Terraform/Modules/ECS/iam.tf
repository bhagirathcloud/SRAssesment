resource "aws_iam_instance_profile" "ecs_profile" {
  name_prefix = "${replace(format("%.102s", replace("tf-ECSProfile-${var.name}-", "_", "-")), "/\\s/", "-")}"
  role        = "${aws_iam_role.ecs_role.name}"
  path        = "${var.iam_path}"
}

resource "aws_iam_role" "ecs_role" {
  name_prefix = "${replace(format("%.32s", replace("tf-ECSInRole-${var.name}-", "_", "-")), "/\\s/", "-")}"
  path        = "${var.iam_path}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
      "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com"]

    },
    "Effect": "Allow",
    "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs_policy" {
  name_prefix = "${replace(format("%.102s", replace("tf-ECSInPol-${var.name}-", "_", "-")), "/\\s/", "-")}"
  description = "A terraform created policy for ECS"
  path        = "${var.iam_path}"
  count       = "${length(var.custom_iam_policy) > 0 ? 0 : 1}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "custom_ecs_policy" {
  name_prefix = "${replace(format("%.102s", replace("tf-ECSInPol-${var.name}-", "_", "-")), "/\\s/", "-")}"
  description = "A terraform created policy for ECS"
  path        = "${var.iam_path}"
  count       = "${length(var.custom_iam_policy) > 0 ? 1 : 0}"

  policy = "${var.custom_iam_policy}"
}

resource "aws_iam_policy_attachment" "attach_ecs" {
  name       = "ecs-attachment"
  roles      = ["${aws_iam_role.ecs_role.name}"]
  policy_arn = "${element(concat(aws_iam_policy.ecs_policy.*.arn, aws_iam_policy.custom_ecs_policy.*.arn), 0)}"
}



