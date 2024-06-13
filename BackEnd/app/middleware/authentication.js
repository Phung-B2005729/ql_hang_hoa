const jwt = require('jsonwebtoken');
const MongoDB = require("../utils/mongodb.util");
const UserService = require("../services/tai_khoan.services");
const NhanVienService = require("../services/nhan_vien.services");

async function authentication(req, res, next) {
  const authHeader = req.headers.authorization || req.headers.Authorization;

  if (authHeader?.startsWith('Bearer') && authHeader) {
    const token = authHeader.split(' ')[1];
    console.log(token);

    try {
      const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);

      if (!decoded || !decoded.id) {
        req.user={}
        return res.status(403).json("Token is not valid");
      }

      const userService = new UserService(MongoDB.client);
      const nhanVienService = new NhanVienService(MongoDB.client);
      const user = await userService.findById(decoded.id,{password: 0, refresh_token: 0})
     
      if (user) {
        const nhanvien = await nhanVienService.findById(user.user_name);
        let userInfo = {};
        if(nhanvien){
         userInfo.ho_ten = nhanvien.ten_nhan_vien;
         userInfo.ma_cua_hang = nhanvien.ma_cua_hang;
        }
       userInfo.tai_khoan = user;
       req.user  = userInfo;
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
