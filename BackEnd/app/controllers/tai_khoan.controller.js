// change
// find one
const ApiError = require("../config/api_error");
const UserService = require("../services/tai_khoan.services");
const MongoDB = require("../utils/mongodb.util"); 
const bcrypt = require('bcrypt')

exports.create = async (req, res, next) => {
      try{
        if(!req.body.user_name || !req.body.password || !req.body.confirm_password){
          return next(new ApiError(400, "Data not empty"));
        }
        if((req.user.tai_khoan && req.user.tai_khoan.phan_quyen!=0) || !req.user || !req.user.tai_khoan){
          return next(new ApiError(402, "Bạn không có quyền admin để cấp tài khoản cho người dùng khác"));
        }
        console.log(req.body.user_name);
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
exports.findAll = async (req, res, next) => {
 
  try{
    const userService = new UserService(MongoDB.client);

    if(req.body.password!=req.body.confirm_password){
      return next(new ApiError(402, "confirm pass không đúng"));
    }
    const document = await userService.find({}, {password: 0});
   
    return res.send(document);

  }catch(e){
    return next(new ApiError(500, "An error ocurred while creating the account"));
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