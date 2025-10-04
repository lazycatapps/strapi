export default (config) => {
  return {
    ...config,
    server: {
      ...config.server,
      allowedHosts: ['strapi', 'localhost', '.localhost'],
    },
  };
};
