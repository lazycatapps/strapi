#!/bin/bash

# Strapi 升级脚本
# 从 v5.25.x 升级到 v5.27.0

set -e

echo "==================================="
echo "Strapi 升级脚本 - v5.25.x -> v5.27.0"
echo "==================================="
echo ""

# 检查 Node.js 版本
echo "检查 Node.js 版本..."
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
echo "当前 Node.js 版本: v$(node -v | cut -d'v' -f2)"
echo ""

# 步骤 1: 检查当前版本
echo "步骤 1: 检查当前版本"
echo "-----------------------------------"
echo "当前 package.json 中的 Strapi 版本:"
grep "@strapi/strapi" package.json | head -1
echo ""
echo "当前 lzc-manifest.yml 中的版本:"
grep "^version:" lzc-manifest.yml
echo ""

# 步骤 2: 备份当前配置
echo "步骤 2: 创建升级前的备份"
echo "-----------------------------------"
BACKUP_DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="backups/pre-5.27.0-upgrade_${BACKUP_DATE}"
mkdir -p "$BACKUP_DIR"

cp package.json "$BACKUP_DIR/"
cp lzc-manifest.yml "$BACKUP_DIR/"
echo "备份已创建在: $BACKUP_DIR"
echo ""

# 步骤 3: 更新 package.json 中的 Strapi 依赖
echo "步骤 3: 更新 package.json 中的 Strapi 依赖到 v5.27.0"
echo "-----------------------------------"
sed -i '' 's/"@strapi\/strapi": "5.25.0"/"@strapi\/strapi": "5.27.0"/' package.json
sed -i '' 's/"@strapi\/plugin-users-permissions": "5.25.0"/"@strapi\/plugin-users-permissions": "5.27.0"/' package.json
sed -i '' 's/"@strapi\/typescript-utils": "5.25.0"/"@strapi\/typescript-utils": "5.27.0"/' package.json
echo "✓ package.json 已更新"
echo ""

# 步骤 4: 更新 lzc-manifest.yml 中的版本号
echo "步骤 4: 更新 lzc-manifest.yml 中的版本号到 5.27.0"
echo "-----------------------------------"
sed -i '' 's/^version: 5.25.0$/version: 5.27.0/' lzc-manifest.yml
sed -i '' 's/CURRENT_VERSION="5.25.0"/CURRENT_VERSION="5.27.0"/' lzc-manifest.yml
echo "✓ lzc-manifest.yml 已更新"
echo ""

# 步骤 5: 安装新版本的依赖
echo "步骤 5: 安装新版本的依赖"
echo "-----------------------------------"
if [ "$NODE_VERSION" -gt 22 ]; then
    echo "⚠️  警告: 当前 Node.js 版本 ($NODE_VERSION) 超出 Strapi 要求 (<=22)"
    echo "推荐使用 Docker 进行构建和测试"
    echo ""
    echo "跳过本地依赖安装..."
else
    echo "正在运行 npm install..."
    npm install --legacy-peer-deps
    echo "✓ 依赖安装完成"
fi
echo ""

# 步骤 6: 验证升级
echo "步骤 6: 验证升级结果"
echo "-----------------------------------"
echo "新的 package.json 中的 Strapi 版本:"
grep "@strapi/strapi" package.json | head -1
echo ""
echo "新的 lzc-manifest.yml 中的版本:"
grep "^version:" lzc-manifest.yml
echo ""

# 步骤 7: Docker 构建
echo "步骤 7: 使用 Docker 构建镜像"
echo "-----------------------------------"
echo "正在构建 Docker 镜像..."
if docker build -t strapi:5.27.0 . ; then
    echo "✓ Docker 镜像构建成功"
else
    echo "✗ Docker 镜像构建失败"
    exit 1
fi
echo ""

echo "==================================="
echo "升级完成！"
echo "==================================="
echo ""
echo "下一步:"
echo "1. 查看备份: $BACKUP_DIR"
echo "2. 测试镜像: docker run --rm strapi:5.27.0 npm run build"
echo "3. 提交更改: git add . && git commit -m 'chore: upgrade Strapi to v5.27.0'"
echo "4. 构建生产版本: make build"
echo ""
echo "如果遇到问题，可以从备份恢复:"
echo "  cp $BACKUP_DIR/package.json ."
echo "  cp $BACKUP_DIR/lzc-manifest.yml ."
echo "  npm install --legacy-peer-deps"
echo ""
