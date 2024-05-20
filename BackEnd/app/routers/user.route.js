const express = require('express')
const router = express.Router();
const userControllers = require('../controllers/user.controller')
const authenticationMiddleware = require('../middleware/authentication')
//public
router.post('/register', userControllers.register);
router.post('/login', userControllers.login);
router.post('/refresh', userControllers.refresh);


router.post('/logout', authenticationMiddleware, userControllers.logout);
router.get('/getuser', authenticationMiddleware, userControllers.user);


module.exports = router;