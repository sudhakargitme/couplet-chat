#!/bin/bash

# starting the server
cd /usr/coupletapp && pm2 start index.js

# starting the client
cd /usr/coupletapp/client/src && pm2 start App.js