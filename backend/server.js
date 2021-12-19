'use strict';

const express = require('express');

// Constants
const PORT = 3000;
const HOST = '0.0.0.0';

// App
const app = express();

app.get("/getData", (req, res) => {
  console.log('Called path /getData');
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  res.send({ msg: 'Hi from the Node Backend!' });
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);