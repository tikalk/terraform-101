/**
 * Get AWS info.
 */
data "aws_caller_identity" "current" {}

/** 
 * Make current vpc's az's available
 */
data "aws_availability_zones" "available" {}


