// change
// find one
const ApiError = require("../config/api_error");
const UserService = require("../services/tai_khoan.services");
const MongoDB = require("../utils/mongodb.util"); 
const bcrypt = require('bcrypt')
const helper = require('../helper/index');

exports.create = async (req, res, next) => {
      try{
        console.log(req.body);
        if(!req.body.user_name || !req.body.password || !req.body.confirm_password || !req.body.user_name_admin || !req.body.admin_password){
          return next(new ApiError(400, "Data not empty"));
        }
        const userService = new UserService(MongoDB.client);

        const useradmin = await userService.findOne({user_name : req.body.user_name_admin});
      if(!useradmin){
        console.log('Lỗi 401');
        return next(new ApiError(401,"Username admin không tồn tại"));
      }
      console.log(useradmin);

        // kiểm tra mật khẩu và quyền
        if(useradmin.phan_quyen!=0){
          return next(new ApiError(402,"Bạn không có quyền cấp tài khaoản cho người dùng khác"));
        }
        console.log('qua kiểm tra admin tới mật khẩu');
        const matchadmin = await bcrypt.compare(req.body.admin_password, useradmin.password);
          console.log('kiểm tra mật khẩu')
        if(!matchadmin){
          console.log('Lỗi user 403')
          return next(new ApiError(403,"Mật khẩu admin không chính xác"));
        }


        console.log(req.body.user_name);
        console.log('Insert controller');
        
        if(req.body.password!=req.body.confirm_password){
          return next(new ApiError(402, "Mật khẩu xác nhận không chính xác"));
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
  try {
    console.log('API called to find all users');

    const userService = new UserService(MongoDB.client); 
    let thong_tin_chung = req.query.thong_tin_chung;

    let pro = {
      user_name: 1,
      phan_quyen: 1,
      trang_thai:  1, 
      'nhan_vien_info.ten_nhan_vien': 1,
      'nhan_vien_info.ma_nhan_vien': 1,
      'nhan_vien_info.sdt': 1,
      'nhan_vien_info.chuc_vu': 1,
      'nhan_vien_info.trang_thai': 1,
    };

    let filter = {};

    if (req.query.thong_tin_chung && req.query.thong_tin_chung !== '' && req.query.thong_tin_chung !== 'null') {
      thong_tin_chung = helper.escapeStringRegexp(req.query.thong_tin_chung);
      let t1 = {
        $or: [
          {
            'nhan_vien_info.ten_nhan_vien': {
              $regex: new RegExp(thong_tin_chung), $options: "i"
            }
          },
          {
            'nhan_vien_info.ma_nhan_vien': {
              $regex: new RegExp(thong_tin_chung), $options: "i"
            }
          },
          {
            user_name: {
              $regex: new RegExp(thong_tin_chung), $options: "i"
            }
          },
        ]
      };
      filter = { ...filter, ...t1 };
    }

    console.log('Received query params:');
    console.log('trang_thai:', req.query.trang_thai);
    console.log('phan_quyen:', req.query.phan_quyen);

    let trang_thai = Array.isArray(req.query.trang_thai)
      ? req.query.trang_thai.map(Number)
      : req.query.trang_thai
        ? req.query.trang_thai.split(',').map(Number)
        : [];

    let phan_quyen = Array.isArray(req.query.phan_quyen)
      ? req.query.phan_quyen.map(Number)
      : req.query.phan_quyen
        ? req.query.phan_quyen.split(',').map(Number)
        : [];

    console.log('Parsed trang_thai:', trang_thai);
    console.log('Parsed phan_quyen:', phan_quyen);

    if (trang_thai.length > 0) {
      filter.trang_thai = { $in: trang_thai };
    }

    if (phan_quyen.length > 0) {
      filter.phan_quyen = { $in: phan_quyen };
    }

    console.log('Constructed filter:', filter);

    const document = await userService.findLookup(filter, pro);
    console.log('Query result:', document);

    return res.send(document);
  } catch (e) {
    console.error('Error occurred:', e);
    return next(new ApiError(500, "An error occurred while fetching the accounts"));
  }
};

exports.update = async (req, res, next) => {
        if(Object.keys(req.body).length == 0){
          return next(new ApiError(400,"Data to update can not be empty"));
         }
         try{
          const userService = new UserService(MongoDB.client);
          if(!req.params.id || !req.body.user_name_admin || !req.body.admin_password){
            return next(new ApiError(400,"Data to update can not be empty"));
           }
         
          // kiểm tra pass của admin xem quyền có phải quản lý hay không
          // xử lý admin
          const useradmin = await userService.findOne({user_name : req.body.user_name_admin});
          console.log(req.body.user_name_admin + " user name admin -------");
          console.log('admin --- '+ useradmin);
          if(!useradmin){
            console.log('Lỗi 401');
            return next(new ApiError(401,"Username admin không tồn tại"));
          }
          
           // kiểm tra mật khẩu và quyền
           if(useradmin.phan_quyen!=0){
            return next(new ApiError(402,"User không có quyền xoá tài khoản người dùng khác"));
           }
          
           const matchadmin = await bcrypt.compare(req.body.admin_password, useradmin.password);
          
           
          
           if(!matchadmin){
            console.log('Lỗi user 403')
            return next(new ApiError(403,"Mật khẩu admin không chính xác"));
           }
           
          console.log("goi ham update " + req.params.id + " " + req.body);
          // update này không update mật khẩu
       //   if(req.body.password) req.body.password = await bcrypt.hash(req.body.password, 10);
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
exports.adminDeleteTaiKhoan = async (req,res, next) => {
   
  try{
    console.log('gọi delette');
    console.log(req.body);
    console.log(req.params.id);
    if(!req.params.id || !req.body.user_name_admin || !req.body.admin_password){
      return next(new ApiError(400,"Data to update can not be empty"));
     }
     const userService = new UserService(MongoDB.client);
    // kiểm tra pass của admin xem quyền có phải quản lý hay không
    // xử lý admin
    const useradmin = await userService.findOne({user_name : req.body.user_name_admin});
    console.log(req.body.user_name_admin + " user name admin -------");
    console.log('admin --- '+ useradmin);
    if(!useradmin){
      console.log('Lỗi 401');
      return next(new ApiError(401,"Username admin không tồn tại"));
    }
    
     // kiểm tra mật khẩu và quyền
     if(useradmin.phan_quyen!=0){
      return next(new ApiError(402,"User không có quyền xoá tài khoản người dùng khác"));
     }
    
     const matchadmin = await bcrypt.compare(req.body.admin_password, useradmin.password);
    
     
    
     if(!matchadmin){
      console.log('Lỗi user 403')
      return next(new ApiError(403,"Mật khẩu admin không chính xác"));
     }
     
     console.log('gọi delete');
     console.log(req.params.id);
      const document = await userService.delete(req.params.id);
      console.log(document);
   
      return res.send(document);
  }catch(err){
      return next(new ApiError(500, `Could not delete with id=${req.params.id}`));
  }
}

//
exports.changePassword = async (req, res, next) => {
  console.log("gọi chang");
 
   if(!req.body.user_name || !req.body.password || !req.body.confirm_password || !req.body.old_password){
    return next(new ApiError(400,"Data to update can not be empty"));
   }
  // console.log(req.body.username);
   if(req.body.password !== req.body.confirm_password){
    return next(new ApiError(400,"Mật khẩu xác nhận không chính xác"));
   }
   try{
    const userService = new UserService(MongoDB.client);
    // extis
   
    const user = await userService.findOne({user_name : req.body.user_name});
   
    if(!user){
      return next(new ApiError(402,"userName không tồn tại"));
    }
   
    const match = await bcrypt.compare(req.body.old_password, user.password);
 
    if(!match){
      return next(new ApiError(405,"Mật khẩu củ không chính xác"));
    }
    // gọi update
  //  console.log(existingusername)
  console.log("goi ham change update " + req.params.id + " " + req.body);
  req.body.password = await bcrypt.hash(req.body.password, 10);
  const document = await userService.update(req.params.id, req.body);
  if(!document){
      return next(new ApiError(404,"not found update"));
  }
  return res.send({
      message: "Change successfully"
  });
 }catch(err){
  return next(new ApiError(500, `Lỗi server change pass with id=${req.params.id}`));
 }
}
//
exports.adminChangePassword = async (req, res, next) => {

try{
// user pass admin, user pass h thay đổi
 if(!req.body.user_name || !req.body.password || !req.body.user_name_admin || !req.body.admin_password){
  return next(new ApiError(400,"Data to update can not be empty"));
 }
 const userService = new UserService(MongoDB.client);
 
// kiểm tra pass của admin xem quyền có phải quản lý hay không
// xử lý admin
const useradmin = await userService.findOne({user_name : req.body.user_name_admin});
console.log(req.body.user_name_admin + " user name admin -------");
console.log('admin --- '+ useradmin);
if(!useradmin){
  console.log('Lỗi 401');
  return next(new ApiError(401,"Username admin không tồn tại"));
}

 // kiểm tra mật khẩu và quyền
 if(useradmin.phan_quyen!=0){
  return next(new ApiError(402,"User không có quyền cấp mật khẩu cho người dùng khác"));
 }

 const matchadmin = await bcrypt.compare(req.body.admin_password, useradmin.password);

 

 if(!matchadmin){
  console.log('Lỗi user 403')
  return next(new ApiError(403,"Mật khẩu admin không chính xác"));
 }

 // đã xử lý xong
 // kiểm tra sự tồn tại của user thay đổi
 const user = await userService.findOne({user_name : req.body.user_name});

 if(!user){
  console.log('Lỗi user')
  return next(new ApiError(405,"UserName không tồn tại"));
 }
  // gọi update
console.log("goi ham cấp mật khẩu" + req.body.user_name + " " + req.body);
req.body.password = await bcrypt.hash(req.body.password, 10);
const document = await userService.update(req.body.user_name, req.body);
if(!document){
    return next(new ApiError(404,"not found update"));
}
return res.send({
    message: "Change successfully"
});
}catch(err){
return next(new ApiError(500, `Lỗi server admin change pass`));
}
}