const ApiError = require("../config/api_error");
const LoaiHangService = require("../services/loai_hang.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");


exports.create = async (req, res, next) => {
    if(req.body.ten_loai==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const loaiHangService = new LoaiHangService(MongoDB.client);
          const exitsLoaiHang = await loaiHangService.findOne({ten_loai: req.body.ten_loai});
          if(exitsLoaiHang){
              console.log(exitsLoaiHang);
              return next(new ApiError(401, "Loại hàng đã tồn tại"));
          }
            const document = await loaiHangService.create(req.body);
            return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm một loại hàng"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const loaiHangService = new LoaiHangService(MongoDB.client);
        let ten_loai = req.query.ten_loai;
        let filter = {};
        if(ten_loai){
                    ten_loai = helper.escapeStringRegexp(ten_loai);
                        let t1 = {
                            ten_loai : {
                            $regex: new RegExp(ten_loai), $options: "i"
                        }
                    }
            filter = {...filter, ...t1}
         }
      
            documents = await loaiHangService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const loaiHangService = new LoaiHangService(MongoDB.client);
        const document = await loaiHangService.findById(req.params.id);
        if(!document){
            return next(new ApiError(404, "Không tìm thấy loại hàng"));
        }
        return res.send(document);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách loại hàng"));
    }
}
exports.update = async (req,res, next) => {
    if(Object.keys(req.body).length == 0){
     return next(new ApiError(400,"Data to update can not be empty"));
    }
    try{
     const loaiHangService = new LoaiHangService(MongoDB.client);
     const document = await loaiHangService.update(req.params.id, req.body);
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
         const loaiHangService = new LoaiHangService(MongoDB.client);
         const document = await loaiHangService.delete(req.params.id);
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


