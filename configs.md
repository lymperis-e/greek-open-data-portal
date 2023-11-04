I am running a node/react app. It is configured to run with yarn and pm2, and uses the following config scripts:

ecosystem.config.js
```javascript
/*global __dirname*/
const path = require('path');

// Pass through additional arguments that might ultimately have come from
// something like `yarn start -- --port 3009`
const argpos = process.argv.indexOf('--');
const args = argpos > -1 ? process.argv.slice(argpos + 1) : [];

module.exports = {
  apps : [{
    name: path.basename(__dirname),
    script: require.resolve('terriajs-server'),

    // Options reference: https://pm2.io/doc/en/runtime/reference/ecosystem-file/
    // passed to app, so any valid arguments in options.js are allowed.
    args: args.join(' '),
    instances: 4,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'development'
    },
    env_production: {
      NODE_ENV: 'production'
    }
  }]
};
```


ecosystem-production.config.js
```javascript
const dev = require('./ecosystem.config.js');
const os = require('os');

// You can start a production server with:
//    ./node_modules/.bin/pm2 start ecosystem-production.config.js --update-env --env production
// Or configure it to run automatically as a daemon (systemd, upstart, launchd, rcd) with:
//    ./node_modules/.bin/pm2 startup systemd

const devApp = dev.apps[0];

module.exports = {
    apps: [
        {
            ...devApp,
            name: devApp.name + '-production',
            args: '--config-file productionserverconfig.json',
            instances: 5//Math.max(4, os.cpus().length)
        }
    ]
};
```

productionserverconfig.json
```json
{
    "port": 3001,
    "allowProxyFor" : [
        "mapsengine.google.com",
        "s3-ap-southeast-2.amazonaws.com",
        "data.osmbuildings.org"
    ]
}
```

The server runs with the command `./node_modules/.bin/pm2 start ecosystem-production.config.js --update-env --env production`


Create a Vite config and any other necessary steps to run the app with npm + vite instead of pm2+yarn