# Data sources for archive_file
data "archive_file" "deps_layer_code_zip" {
    type        = "zip"
    source_dir  = "${path.module}/../dist/src/layers/deps-layer/"
    output_path = "${path.module}/../dist/deps.zip"
}

data "archive_file" "utils_layer_code_zip" {
    type        = "zip"
    source_dir  = "${path.module}/../dist/src/layers/util-layer/"
    output_path = "${path.module}/../dist/utils.zip"
}

data "archive_file" "sample_lambda_zip" {
    type        = "zip"
    source_dir  = "${path.module}/../dist/src/handlers/sample-lambda/"
    output_path = "${path.module}/../dist/sample-lambda.zip"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
    name = "lambda-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

# Attach AWSLambdaBasicExecutionRole policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda layers
resource "aws_lambda_layer_version" "lambda_deps_layer" {
    layer_name          = "shared_deps"
    filename            = data.archive_file.deps_layer_code_zip.output_path
    source_code_hash    = data.archive_file.deps_layer_code_zip.output_base64sha256
    compatible_runtimes = ["nodejs20.x"]
}

resource "aws_lambda_layer_version" "lambda_utils_layer" {
    layer_name          = "shared_utils"
    filename            = data.archive_file.utils_layer_code_zip.output_path
    source_code_hash    = data.archive_file.utils_layer_code_zip.output_base64sha256
    compatible_runtimes = ["nodejs20.x"]
}

# Lambda function
resource "aws_lambda_function" "sample_lambda" {
    function_name           = "sample-lambda"
    runtime                 = "nodejs20.x"
    handler                 = "index.handler"
    role                    = aws_iam_role.lambda_role.arn
    filename                = data.archive_file.sample_lambda_zip.output_path
    source_code_hash        = data.archive_file.sample_lambda_zip.output_base64sha256

    layers = [
        aws_lambda_layer_version.lambda_deps_layer.arn,
        aws_lambda_layer_version.lambda_utils_layer.arn
    ]
}
