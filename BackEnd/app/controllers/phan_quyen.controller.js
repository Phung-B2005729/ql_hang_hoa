const ApiError = require("../config/api_error");
const PhanQuyenService = require("../services/phan_quyen.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");


exports.create = async (req, res, next) => {
    if(req.body.ten_quyen==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const phanQuyenService = new PhanQuyenService(MongoDB.client);
          const exitsPhanQuyen = await phanQuyenService.findOne({ten_quyen: req.body.ten_quyen});
          if(exitsPhanQuyen){
              console.log(exitsPhanQuyen);
              return next(new ApiError(401, "Data đã tồn tại"));
          }
            const document = await phanQuyenService.create(req.body);
            return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const phanQuyenService = new PhanQuyenService(MongoDB.client);
        const ten_quyen = req.query.ten_quyen;
        const filter = {};
        if(ten_quyen){
                    ten_quyen = helper.escapeStringRegexp(ten_quyen);
                        let t1 = {
                            ten_quyen : {
                            $regex: new RegExp(ten_quyen), $options: "i"
                        }
                    }
            filter = {...filter, ...t1}
         }
            documents = await phanQuyenService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const phanQuyenService = new PhanQuyenService(MongoDB.client);
        const document = await phanQuyenService.findById(req.params.id);
        if(!document){
            return next(new ApiError(404, "Không tìm thấy data"));
        }
        return res.send(document);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    }
}
exports.update = async (req,res, next) => {
    if(Object.keys(req.body).length == 0){
     return next(new ApiError(400,"Data to update can not be empty"));
    }
    try{
     const phanQuyenService = new PhanQuyenService(MongoDB.client);
     const document = await phanQuyenService.update(req.params.id, req.body);
     if(!document){
         return next(new ApiError(404,"not found"));
     }
     return res.send({
         message: "updated successfully"
     });
    }catch(err){
     return next(new ApiError(500, `Lỗi server update with id=${req.params.id}`));
    }
 };
 
 exports.delete = async (req,res, next) => {
   
     try{
         const phanQuyenService = new PhanQuyenService(MongoDB.client);
         const document = await phanQuyenService.delete(req.params.id);
         if(!document){
             return next(new ApiError(404, "not found"));
         }
         return res.send({
             message: " deleted succesfully"
         });
     }catch(err){
         return next(new ApiError(500, `Could not delete with id=${req.params.id}`));
     }
 }


