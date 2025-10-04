# Strapi 部署项目

基于 Strapi v5.25.0 的 Docker 部署项目，用于 LazyCat 平台。

## 快速部署

### 1. 构建镜像

```bash
docker build -t strapi:5.25.0 .
```

### 2. 环境变量配置

必需的环境变量：

```bash
# 数据库配置
DATABASE_CLIENT=postgres
DATABASE_HOST=<数据库地址>
DATABASE_PORT=5432
DATABASE_NAME=strapi
DATABASE_USERNAME=<数据库用户名>
DATABASE_PASSWORD=<数据库密码>

# 密钥配置（使用下面的命令生成）
ADMIN_JWT_SECRET=<管理员JWT密钥>
JWT_SECRET=<JWT密钥>
APP_KEYS=<应用密钥1>,<应用密钥2>
API_TOKEN_SALT=<API Token盐值>
TRANSFER_TOKEN_SALT=<Transfer Token盐值>
ENCRYPTION_KEY=<加密密钥>

# 运行环境
NODE_ENV=development
```

### 3. 生成密钥

```bash
ADMIN_JWT_SECRET=$(openssl rand -base64 32 | tr -d '\n')
JWT_SECRET=$(openssl rand -base64 32 | tr -d '\n')
APP_KEYS=$(openssl rand -base64 32 | tr -d '\n'),$(openssl rand -base64 32 | tr -d '\n')
API_TOKEN_SALT=$(openssl rand -base64 16 | tr -d '\n')
TRANSFER_TOKEN_SALT=$(openssl rand -base64 16 | tr -d '\n')
ENCRYPTION_KEY=$(openssl rand -base64 32 | tr -d '\n')
```

### 4. 容器配置

- **端口**: 1337
- **依赖**: PostgreSQL 数据库

## 访问地址

- 管理面板: `http://your-domain:1337/admin`
- API 端点: `http://your-domain:1337/api`

## 首次使用

1. 访问管理面板创建管理员账户
2. 在 Content-Type Builder 创建内容类型
3. 在 Content Manager 添加内容
4. 在 Settings → Roles → Public 配置 API 权限

## 生产环境

修改 `Dockerfile` 最后两行：

```dockerfile
ENV NODE_ENV=production
CMD ["npm", "run", "start"]
```

并设置环境变量 `NODE_ENV=production`

## 技术栈

- Strapi v5.25.0
- Node.js 20-alpine
- PostgreSQL（外部服务）

## 许可证

基于 Strapi 官方项目定制，遵循 [MIT License](https://github.com/strapi/strapi/blob/main/LICENSE)。
