module.exports = ({ env }) => ({
  vite: {
    server: {
      allowedHosts: env.array('ADMIN_ALLOWED_HOSTS', ['strapi', 'localhost', '.localhost']),
    },
  },
  auth: {
    secret: env('ADMIN_JWT_SECRET', 'default-admin-jwt-secret'),
    sessions: {
      cookieOptions: {
        secure: false,
        httpOnly: true,
        sameSite: 'lax',
      },
    },
  },
  apiToken: {
    salt: env('API_TOKEN_SALT', 'default-api-token-salt'),
  },
  transfer: {
    token: {
      salt: env('TRANSFER_TOKEN_SALT', 'default-transfer-token-salt'),
    },
  },
  encryptionKey: env('ENCRYPTION_KEY', 'default-encryption-key-must-be-at-least-16-chars'),
  flags: {
    nps: env.bool('FLAG_NPS', true),
    promoteEE: env.bool('FLAG_PROMOTE_EE', true),
  },
});
