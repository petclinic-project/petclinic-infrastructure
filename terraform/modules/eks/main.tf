# =========================================================
# IAM ROLE - EKS CONTROL PLANE
# =========================================================

resource "aws_iam_role" "eks_control_plane" {
  name = "${var.project}-eks-control-plane-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

# =========================================================
# IAM POLICIES - CONTROL PLANE
# =========================================================

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_control_plane.name
}

resource "aws_iam_role_policy_attachment" "eks_block_storage_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
  role       = aws_iam_role.eks_control_plane.name
}

resource "aws_iam_role_policy_attachment" "eks_load_balancing_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  role       = aws_iam_role.eks_control_plane.name
}

resource "aws_iam_role_policy_attachment" "eks_networking_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  role       = aws_iam_role.eks_control_plane.name
}

# =========================================================
# IAM ROLE - EKS WORKER NODES
# =========================================================

resource "aws_iam_role" "eks_nodes" {
  name = "${var.project}-eks-nodes-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })
}

# =========================================================
# IAM POLICIES - EKS WORKER NODES
# =========================================================

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

# =========================================================
# EKS CLUSTER
# =========================================================

resource "aws_eks_cluster" "main" {
  name     = "${var.project}-eks-${var.environment}"
  role_arn = aws_iam_role.eks_control_plane.arn
  version  = var.cluster_version

  bootstrap_self_managed_addons = true

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [var.cluster_sg_id]
    endpoint_private_access = true
    endpoint_public_access  = true

    # Development-friendly.
    # Later we can restrict access to office/VPN/public IPs only.
    public_access_cidrs = ["0.0.0.0/0"]
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }



  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_block_storage_policy,
    aws_iam_role_policy_attachment.eks_load_balancing_policy,
    aws_iam_role_policy_attachment.eks_networking_policy
  ]
}

# =========================================================
# EKS MANAGED NODE GROUP
# =========================================================

resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project}-general-${var.environment}"

  node_role_arn = aws_iam_role.eks_nodes.arn

  subnet_ids = var.subnet_ids

  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy
  ]
}

# =========================================================
# OIDC PROVIDER FOR IRSA
# =========================================================

data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    data.tls_certificate.eks.certificates[0].sha1_fingerprint
  ]

  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}
