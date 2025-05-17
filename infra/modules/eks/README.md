# Terraform AWS EKS Cluster

本项目通过 Terraform 创建一个简单的 AWS EKS 集群，包括基础网络资源（VPC、子网、路由表、Internet Gateway、NAT Gateway）和 EKS 集群及节点组。

## 文件结构

- `main.tf`          : Provider 和可用区数据源配置
- `variables.tf`     : 变量定义
- `network.tf`       : VPC、子网、路由表、IGW、NAT 等网络资源
- `eks.tf`           : EKS 集群、节点组、IAM 角色、策略绑定、安全组

## 使用步骤

1. 初始化 Terraform 工作目录：

   ```bash
   terraform init
