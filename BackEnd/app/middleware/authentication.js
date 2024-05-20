const jwt = require('jsonwebtoken');
const MongoDB = require("../utils/mongodb.util");
const UserService = require("../services/user.services");

async function authentication(req, res, next) {
  const authHeader = req.headers.authorization || req.headers.Authorization;

  if (authHeader?.startsWith('Bearer') && authHeader) {
    const token = authHeader.split(' ')[1];
    //console.log(token);

    try {
      const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);

      if (!decoded || !decoded.id) {
        req.user={}
        return res.status(403).json("Token is not valid");
      }

      const userService = new UserService(MongoDB.client);
      const user = await userService.findById(decoded.id,{password: 0, refresh_token: 0 })
      console.log("user", user);
      

      if (user) {
        req.user = user;
        next();
      
      } else {
        req.user={}
        res.status(403).json("Token is not valid");
      }
    } catch (error) {
      req.user={}
      res.status(403).json("Token is not valid");
    }
  } else {
    req.user={}
    res.status(401).json("You're not authenticated");
  }
}

module.exports = authentication;
