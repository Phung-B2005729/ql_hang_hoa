const ApiError = require("../config/api_error");
const TaiKhoanService = require("../services/tai_khoan.services");
const MongoDB = require("../utils/mongodb.util"); 
const helper = require("../helper/index");
const { registerSchema, loginSchema } = require("../validation/index");
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt')
    
 // login logout
 exports.login = async (req, res, next) => {
  console.log('Gọi login');
  try {
      const taiKhoanService = new TaiKhoanService(MongoDB.client);
      console.log('Gọi login');
   //  const {user_name, password} = req.body;
   const { error } = loginSchema.validate(req.body);
   console.log(req.body);
   if (error) {
     return next(new ApiError(400, error.message));
   }
     
      const user = await taiKhoanService.findOne({user_name: req.body.user_name});
     
      if(!user){
          return next(new ApiError(401, "user_name hoặc mật khẩu không chính xác"))
      }
      if(user.trang_thai!=1){
        return next(new ApiError(405, "Tài khoản bị vô hiệu hoá"));
      }

      const match = await bcrypt.compare(req.body.password, user.password);
      if(!match)   return next(new ApiError(401, "user_name hoặc mật khẩu không chính xác"))
     // console.log( process.env.ACCESS_TOKEN_SECRET)
      const accessToken = jwt.sign(
        {
          id: user._id
        },
        process.env.ACCESS_TOKEN_SECRET,
        {
          expiresIn: '1800s'
        }
      )
    
      const refreshToken = jwt.sign(
        {
          id: user._id
        },
        process.env.REFRESH_TOKEN_SECRET,
        {
          expiresIn: '1d'
        }
      )
   
      console.log(user)
      await taiKhoanService.update(user._id, {refresh_token: refreshToken});
      
      // Lưu refreshToken vào cookie

      res.cookie('refresh_token', refreshToken, {httpOnly: true, sameSite: 'strict', secure: true})
      //
      res.send({access_token: accessToken, refresh_token: refreshToken});

    }catch(error){
      return next(new ApiError(500, "Lỗi server"));
     }
  
}

exports.logout = async (req, res, next) => {
  console.log('Gọi logout');
  try {
    const taiKhoanService = new TaiKhoanService(MongoDB.client);
    const refreshToken = req.cookies.refresh_token || req.body.refresh_token;

    if (!refreshToken) {
      res.clearCookie('refresh_token', { httpOnly: true, sameSite: 'strict', secure: true });
      return res.sendStatus(204); // No Content
    }

    const user = await taiKhoanService.findOne({ refresh_token: refreshToken });

    if (!user) {
      res.clearCookie('refresh_token', { httpOnly: true, sameSite: 'strict', secure: true });
      return res.sendStatus(204); // No Content
    }

    await taiKhoanService.update(user._id, { refresh_token: null });
    console.log('Gọi update');

    res.clearCookie('refresh_token', { httpOnly: true, sameSite: 'strict', secure: true });
    return res.sendStatus(200); // OK

  } catch (e) {
    console.error(e); // Log chi tiết lỗi
    return next(new ApiError(500, "Lỗi server"));
  }
}


//
exports.refresh = async (req, res, next) => {
  try {
      const refreshToken = req.cookies.refresh_token ?? req.body.refresh_token;
      console.log("reshet -----------", refreshToken);
      if (!refreshToken) return next(new ApiError(401, "Bạn chưa đăng nhập"));

      const taiKhoanService = new TaiKhoanService(MongoDB.client);

      const user = await taiKhoanService.findOne({ refresh_token: refreshToken });
      console.log(user);
      if (!user) return next(new ApiError(403, "refresh_token hoặc user không tồn tại"));
      

      //
       jwt.verify(
        refreshToken,
        process.env.REFRESH_TOKEN_SECRET,
        (err, decoded) => {
         
          console.log("dk---", user._id.toString() !== decoded.id)
          if(err || user._id.toString() !== decoded.id) return next(new ApiError(403, "user_id không hợp lệ"));
            
          const accessToken = jwt.sign(
            { id: decoded.id },
            process.env.ACCESS_TOKEN_SECRET,
            { expiresIn: '1d' }
          )
    
          res.send({access_token: accessToken})
        }
      )
  } catch (e) {
      return next(new ApiError(500, "Lỗi server"));
  }
};


  
//  
exports.user =  async (req, res, next) => {
    try{
      // getuser
    const user = req.user;
    return res.send(user);
    }catch(e){
        return next(new ApiError(500, "Lỗi server"));
    }
  }

 



