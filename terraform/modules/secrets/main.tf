resource "aws_secretsmanager_secret" "this" {
  name                    = "${var.project}/${var.environment}/${var.secret_name_suffix}"
  recovery_window_in_days = 0

  tags = {
    Name = "${var.project}-${var.secret_name_suffix}-${var.environment}"
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(var.secret_payload)
}
