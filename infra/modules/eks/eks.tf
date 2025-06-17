resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "eks_cluster_policy" {
  name       = "${var.project}-eks-cluster-policy"
  roles      = [aws_iam_role.eks_cluster_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_role" {
  name = "${var.project}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "eks_node_policies" {
  for_each   = toset(var.eks_node_policies)
  name       = "${var.project}-eks-node-${replace(basename(each.value), "arn:aws:iam::aws:policy/", "")}"
  roles      = [aws_iam_role.eks_node_role.name]
  policy_arn = each.value
}

resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-eks-sg"
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = concat(aws_subnet.public_subnet[*].id, aws_subnet.private_subnet[*].id)
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  tags = {
    Name = "${var.project}-eks-cluster"
  }

  depends_on = [
    aws_iam_policy_attachment.eks_cluster_policy,
  ]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.project}-eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.private_subnet[*].id
  capacity_type   = "SPOT"
  instance_types  = ["t2.small"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_policy_attachment.eks_node_policies,
  ]

  tags = {
    Name = "${var.project}-eks-node-group"
  }
}
