const ApiError = require("../config/api_error");
const LoHangService = require("../services/lo_hang.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");



exports.create = async (req, res, next) => {
    if(req.body.so_lo==null || req.body.ma_hang_hoa==null || req.body.ngay_san_xuat==null || req.body.han_su_dung==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const loHangService = new LoHangService(MongoDB.client);
          if(req.body.so_lo){
            const exitsHangHoa2 = await loHangService.findOne({so_lo: req.body.so_lo});
            if(exitsHangHoa2){
                console.log(exitsHangHoa2);
                return next(new ApiError(401, "Số lô đã tồn tại"));
            }
          }
        const document = await loHangService.create(req.body);
        return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const loHangService = new LoHangService(MongoDB.client);
        const ma_hang_hoa = req.query.ma_hang_hoa; // tìm theo ma_hang_hoa
      
        let filter = {};
        if(ma_hang_hoa){
                        let t1 = {
                            ma_hang_hoa : ma_hang_hoa
                    }
            filter = {...filter, ...t1}
         }
         
            documents = await loHangService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const loHangService = new LoHangService(MongoDB.client);
        const document = await loHangService.findById(req.params.id);
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
     const loHangService = new LoHangService(MongoDB.client);
    
     const document = await loHangService.update(req.params.id, req.body);
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
         const loHangService = new LoHangService(MongoDB.client);
         const document = await loHangService.delete(req.params.id);
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


