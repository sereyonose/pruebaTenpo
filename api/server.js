const express = require('express');
const { history } = require('./controllers/historial-controller');
const { login } = require('./controllers/login-controller');
const { logout } = require('./controllers/logout-controller');
const { register } = require('./controllers/registro-controller');
const { sum } = require('./controllers/suma-controller');
const cryptoUtil = require('./utils/cryptoUtil')

const PORT = 3000;
const HOST = '0.0.0.0';

const app = express();
app.use(express.json());

app.post('/register', register);

app.post('/login', login);

app.post('/addNumbers', (req, res, next) => {
  if (req.header('Authorization')
    && cryptoUtil.validateToken(req.header('Authorization'))) {
    next();
  }
  else {
    res.status(401).send();
  }
}, sum);

app.post('/logout', logout);
app.get('/history', (req, res, next) => {
  if (req.header('Authorization')
    && cryptoUtil.validateToken(req.header('Authorization'))) {
    next();
  }
  else {
    res.status(401).send();
  }
}, history);

const server = app.listen(PORT, HOST);

console.log(`Server running in host:${HOST} and port:${PORT}`);

module.exports = server;