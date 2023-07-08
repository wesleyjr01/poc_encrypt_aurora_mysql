
resource "aws_kms_key" "snapshot_encrypt_kms_key" {
  # This will be created at account 131578276461
  # Allow access to account 931366402038
  description             = "KMS Key used to encrypt a MysQL Aurora Cluster snapshot."
  deletion_window_in_days = 10
  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-policy",
  "Statement": [
    {
      "Sid": "Allow * to source account",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::131578276461:root"
      },
      "Action": [
        "kms:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow Account 931366402038 to use key",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::931366402038:root"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_kms_alias" "this" {
  name          = "alias/snapshot_encrypt_kms_key"
  target_key_id = aws_kms_key.snapshot_encrypt_kms_key.key_id
}


resource "aws_rds_cluster" "cluster_that_generates_unencrypted_snapshot" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-mysql"
  engine_version          = var.engine_version
  engine_mode             = "provisioned"
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = true # double check this

  master_username    = "foo1234AF"
  master_password    = "foo1234A!pwd"
  port               = 3306
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # kms_key_id         = aws_kms_key.snapshot_encrypt_kms_key.arn
  # storage_encrypted  = true

  
  #   vpc_security_group_ids = ""
  #   db_subnet_group_name = 
  #   db_instance_parameter_group_name = 
  #   iam_roles = ?
  #   snapshot_identifier = # Specifies whether or not to create this cluster from a snapshot. 


  # Restore from s3
  #   s3_import {
  #     source_engine         = "mysql"
  #     source_engine_version = "5.6"
  #     bucket_name           = "mybucket"
  #     bucket_prefix         = "backups"
  #     ingestion_role        = "arnawsiam:1234567890role/role-xtrabackup-rds-restore"
  #   }
}

## Instances Definitions
# resource "aws_rds_cluster_instance" "this" {
#   count              = 2
#   identifier         = "aurora-cluster-demo-${count.index}"
#   cluster_identifier = aws_rds_cluster.default.id
#   instance_class     = "db.t2.micro"
#   engine             = aws_rds_cluster.default.engine
#   engine_version     = aws_rds_cluster.default.engine_version
# }