const ApiError = require("../config/api_error");
const HinhAnhService = require("../services/hinh_anh.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");


exports.create = async (req, res, next) => {
    if(req.body.link_anh==null || req.body.ma_hang_hoa==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const hinhAnhService = new HinhAnhService(MongoDB.client);
          const exitsHinhAnh = await hinhAnhService.findOne({link_anh: req.body.link_anh});
          if(exitsHinhAnh){
              console.log(exitsHinhAnh);
              return next(new ApiError(401, "link ảnh đã tồn tại"));
          }
            const document = await hinhAnhService.create(req.body);
            return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm mới"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const hinhAnhService = new HinhAnhService(MongoDB.client);
        const ma_hang_hoa = req.query.ma_hang_hoa;
        let filter = {};
        if(ma_hang_hoa){
            console.log(ma_hang_hoa);
                        let t1 = {
                            ma_hang_hoa : ma_hang_hoa
                    }
            filter = {...filter, ...t1}
            console.log(filter);
         }
      
            documents = await hinhAnhService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const hinhAnhService = new HinhAnhService(MongoDB.client);
        const document = await hinhAnhService.findById(req.params.id);
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
     const hinhAnhService = new HinhAnhService(MongoDB.client);
     const document = await hinhAnhService.update(req.params.id, req.body);
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
         const hinhAnhService = new HinhAnhService(MongoDB.client);
         const document = await hinhAnhService.delete(req.params.id);
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


