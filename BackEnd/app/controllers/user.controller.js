const ApiError = require("../config/api_error");
const UserService = require("../services/user.services");
const MongoDB = require("../utils/mongodb.util"); 
const helper = require("../helper/index");
const { registerSchema, loginSchema } = require("../validation/user.validation");
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt')

exports.register = async (req, res, next) => {
  console.log(req.body.user_name);
      try{
        if(!req.body.user_name || !req.body.password || !req.body.confirm_password || !req.body.phan_quyen){
          return next(new ApiError(400, "Data not empty"));
        }
        console.log('Insert controller');
        const userService = new UserService(MongoDB.client);

        if(req.body.password!=req.body.confirm_password){
          return next(new ApiError(402, "confirm pass không đúng"));
        }

        const existinguser_name = await userService.findOne({user_name : req.body.user_name});

        if (existinguser_name) {
            return next(new ApiError(401, "user_name đã được sử dụng."));
          }
        
       //
        req.body.password = await bcrypt.hash(req.body.password, 10);
        console.log(req.body);
        const document = await userService.create(req.body);
        return res.send(document.insertedId);

      }catch(e){
        return next(new ApiError(500, "An error ocurred while creating the account"));
      }
    }

    

 // login logout
 exports.login = async (req, res, next) => {
  console.log('Gọi login');
  try {
      const userService = new UserService(MongoDB.client);
      console.log('Gọi login');
   //  const {user_name, password} = req.body;
   const { error } = loginSchema.validate(req.body);
   if (error) {
     return next(new ApiError(400, error.message));
   }
     
      const user = await userService.findOne({user_name: req.body.user_name});
     
      if(!user){
          return next(new ApiError(401, "user_name or password is incorrect"))
      }
      if(user.trang_thai!=1){
        return next(new ApiError(405, "Tài khoản bị vô hiệu hoá"));
      }

      const match = await bcrypt.compare(req.body.password, user.password)
      if(!match)   return next(new ApiError(401, "user_name or password is incorrect"))
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
      await userService.updateAccessToken(user._id, {refresh_token: refreshToken});
      
      // Lưu refreshToken vào cookie
      res.cookie('refresh_token', refreshToken, {httpOnly: true, sameSite: 'strict', secure: true})
      //
      res.send({access_token: accessToken})

    }catch(error){
      return next(new ApiError(500, "Lỗi server"));
     }
  
}

 exports.logout = async (req, res, next) => {
  console.log('Gọi logout');
  try {
    const userService = new UserService(MongoDB.client);
    const cookies = req.cookies

    if(!cookies.refresh_token) return res.sendStatus(204)
  
    const refreshToken = cookies.refresh_token

    const user = await userService.findOne({refresh_token: refreshToken})
  
    if(!user){
      res.clearCookie('refresh_token', {httpOnly: true, sameSite: 'strict', secure: true})
      return res.sendStatus(204)
    }
  
   // user.refresh_token = null
    await userService.updateAccessToken(user._id, {refresh_token: null});
  
    res.clearCookie('refresh_token', {httpOnly: true, sameSite: 'strict', secure: true})
    res.sendStatus(204)

  }catch(e){
    return next(new ApiError(500, "Lỗi server"));
  }
}

//
exports.refresh = async (req, res, next) => {
  try {
      const refreshToken = req.cookies.refresh_token;
      console.log("reshet -----------", refreshToken);
      if (!refreshToken) return res.status(401).json("Bạn chưa đăng nhập");

      const userService = new UserService(MongoDB.client);

      const user = await userService.findOne({ refresh_token: refreshToken });
      console.log(user);
      if (!user) return res.sendStatus(403);
       console.log(!user);
       jwt.verify(
        refreshToken,
        process.env.REFRESH_TOKEN_SECRET,
        (err, decoded) => {
         
          console.log("dk---", user._id.toString() !== decoded.id)
          if(err || user._id.toString() !== decoded.id) return res.sendStatus(403)
            
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
    const user = req.user;
    return res.send(user);
    }catch(e){
        return next(new ApiError(500, "Lỗi server"));
    }
  }
exports.update = async (req, res, next) => {
  if(Object.keys(req.body).length == 0){
    return next(new ApiError(400,"Data to update can not be empty"));
   }
   try{
    const userService = new UserService(MongoDB.client);
    console.log("goi ham update " + req.params.id + " " + req.body);
    // update này không update mật khẩu
    if(req.body.password) req.body.password = await bcrypt.hash(req.body.password, 10);
    const document = await userService.update(req.params.id, req.body);
    
    return res.send({
        message: "updated successfully"
    });
   }catch(err){
    return next(new ApiError(500, `Lỗi server update contact with id=${req.params.id}`));
   }
}
//




 exports.delete = async (req,res, next) => {
   
     try{
         const userService = new UserService(MongoDB.client);
        
         const document = await userService.delete(req.params.id);
      
         return res.send({
             message: " deleted succesfully"
         });
     }catch(err){
         return next(new ApiError(500, `Could not delete with id=${req.params.id}`));
     }
 }

 



