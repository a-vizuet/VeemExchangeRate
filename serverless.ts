import { functions } from '@functions/config';

const serverlessConfiguration = {
  service: 'veemexchangerate',
  frameworkVersion: '2',
  custom: {
    webpack: {
      webpackConfig: './webpack.config.js',
      includeModules: true,
    },
  },
  plugins: ['serverless-google-cloudfunctions', 'serverless-webpack'],
  provider: {
    name: 'google',
    runtime: 'nodejs16',
    region: 'us-central1',
    project: 'veemcurrencyquote',
  },
  functions,
};

module.exports = serverlessConfiguration;
