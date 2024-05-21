const ApiError = require("../config/api_error");
const ThuongHieuService = require("../services/thuong_hieu.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");


exports.create = async (req, res, next) => {
    if(req.body.ten_thuong_hieu==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const thuongHieuService = new ThuongHieuService(MongoDB.client);
          const exitsThuongHieu = await thuongHieuService.findOne({ten_thuong_hieu: req.body.ten_thuong_hieu});
          if(exitsThuongHieu){
              console.log(exitsThuongHieu);
              return next(new ApiError(401, "Data đã tồn tại"));
          }
            const document = await thuongHieuService.create(req.body);
            return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const thuongHieuService = new ThuongHieuService(MongoDB.client);
        const ten_thuong_hieu = req.query.ten_thuong_hieu;
        const filter = {};
        if(ten_thuong_hieu){
                    ten_thuong_hieu = helper.escapeStringRegexp(ten_thuong_hieu);
                        let t1 = {
                            ten_thuong_hieu : {
                            $regex: new RegExp(ten_thuong_hieu), $options: "i"
                        }
                    }
            filter = {...filter, ...t1}
         }
            documents = await thuongHieuService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const thuongHieuService = new ThuongHieuService(MongoDB.client);
        const document = await thuongHieuService.findById(req.params.id);
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
     const thuongHieuService = new ThuongHieuService(MongoDB.client);
     const document = await thuongHieuService.update(req.params.id, req.body);
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
         const thuongHieuService = new ThuongHieuService(MongoDB.client);
         const document = await thuongHieuService.delete(req.params.id);
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


