module.exports = {
    devServer: {
      proxy: {
        '^/api': {
          target: 'http://localhost:8080',
          changeOrigin: true
        },
        '^/auth': {
          target: 'http://localhost:8080',
          changeOrigin: true
        }
      }
    }
  };
  