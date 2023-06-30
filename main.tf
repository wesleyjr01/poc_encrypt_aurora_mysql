
resource "aws_kms_key" "this" {
  description              = "KMS key used by Aurora MySQL Cluster"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = false
  deletion_window_in_days  = 10
}


resource "aws_rds_cluster" "cluster_that_generates_the_snapshot" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-mysql"
  engine_version          = var.engine_version
  engine_mode             = "provisioned"
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = true # double check this

  master_username    = "foo1234AF"
  master_password    = "foo1234A!pwd"
  kms_key_id         = aws_kms_key.this.arn
  port               = 3306
  storage_encrypted  = true
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
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