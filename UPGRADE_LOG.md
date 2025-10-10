# Strapi 升级日志

## 升级到 v5.27.0

**升级日期**: 2025-10-10

### 升级前版本

- **package.json**: 5.25.0
- **lzc-manifest.yml**: 5.25.0

### 升级后版本

- **package.json**: 5.27.0
- **lzc-manifest.yml**: 5.27.0

### 升级步骤

1. **检查当前版本**
   - 检查了 package.json 中的 Strapi 依赖版本
   - 检查了 lzc-manifest.yml 中的应用版本
   - 确认当前版本为 5.25.x

2. **更新版本号**
   - 更新 package.json 中的三个 Strapi 依赖包到 5.27.0:
     - @strapi/strapi: 5.25.0 → 5.27.0
     - @strapi/plugin-users-permissions: 5.25.0 → 5.27.0
     - @strapi/typescript-utils: 5.25.0 → 5.27.0

   - 更新 lzc-manifest.yml:
     - version: 5.25.0 → 5.27.0
     - CURRENT_VERSION: 5.25.0 → 5.27.0

3. **安装依赖**
   - 由于本地 Node.js 版本 (v24.9.0) 超出 Strapi 要求 (<=22.x.x)
   - 使用 Docker 容器 (node:22-alpine) 进行依赖安装
   - 安装命令: `npm install --legacy-peer-deps`

4. **构建验证**
   - 使用 Docker 构建完整镜像
   - 构建命令: `docker build -t strapi-test:5.27.0 .`

### 修改的文件

- `package.json` - 更新 Strapi 依赖版本
- `lzc-manifest.yml` - 更新应用版本和 setup_script 中的 CURRENT_VERSION

### 注意事项

1. **Node.js 版本要求**
   - Strapi 5.27.0 要求 Node.js >= 18.0.0 且 <= 22.x.x
   - 本地开发环境如果使用 v24+，需要使用 Docker 或切换 Node 版本

2. **Docker 构建**
   - Dockerfile 使用 node:22-alpine 基础镜像，符合版本要求
   - 构建过程包含完整的依赖安装和应用构建

3. **升级脚本**
   - 创建了 `upgrade-to-5.27.0.sh` 脚本记录升级步骤
   - 脚本支持自动备份和版本验证

### 下一步操作

1. 等待 Docker 构建完成
2. 测试构建的镜像
3. 验证应用功能正常
4. 提交代码更改

### 有用的命令

```bash
# 检查 Strapi 版本
npm list @strapi/strapi

# 在 Docker 中运行测试
docker run --rm strapi-test:5.27.0 npm run build

# 构建生产镜像
make build

# 查看构建日志
docker logs <container_id>
```

### 参考链接

- [Strapi GitHub Releases](https://github.com/strapi/strapi/releases)
- [Strapi v5.27.0 Release Notes](https://github.com/strapi/strapi/releases/tag/v5.27.0)
- [Strapi 官方文档](https://docs.strapi.io/)
