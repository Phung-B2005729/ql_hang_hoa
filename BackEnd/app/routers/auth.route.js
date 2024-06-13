const express = require('express')
const router = express.Router();
const authContrller = require('../controllers/auth.controller')
const authenticationMiddleware = require('../middleware/authentication');

//
router.post('/login', authContrller.login);
router.post('/refresh', authContrller.refresh);


router.post('/logout', authenticationMiddleware, authContrller.logout);
router.get('/getuser', authenticationMiddleware, authContrller.user);


module.exports = router;