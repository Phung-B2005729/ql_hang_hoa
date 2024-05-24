const ApiError = require("../config/api_error");
const ChiTietKiemKhoService = require("../services/chi_tiet_kiem_kho.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");



exports.create = async (req, res, next) => {
    if(req.body.so_lo==null || req.body.ma_phieu_kiem_kho==null || req.body.so_luong_thuc_te==null || req.body.so_luong_ton_kho==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const chiTietKiemKhoService = new ChiTietKiemKhoService(MongoDB.client);
          if(req.body.so_lo && req.body.ma_phieu_kiem_kho){
            const exitsChiTiet2 = await chiTietKiemKhoService.findOne({so_lo: req.body.so_lo, ma_phieu_kiem_kho: req.body.ma_phieu_kiem_kho});
            if(exitsChiTiet2){
                console.log(exitsChiTiet2);
                return next(new ApiError(401, "Mã phiếu nhập và số lô đã tồn tại"));
            }
          }
        const document = await chiTietKiemKhoService.create(req.body);
        return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const chiTietKiemKhoService = new ChiTietKiemKhoService(MongoDB.client);
        const ma_phieu_kiem_kho = req.query.ma_phieu_kiem_kho; // tìm theo ma_phieu_kiem_kho
        const so_lo = req.query.so_lo; // tìm theo số lô
        let filter = {};
        if(ma_phieu_kiem_kho){
                        let t1 = {
                            ma_phieu_kiem_kho : ma_phieu_kiem_kho
                    }
            filter = {...filter, ...t1}
         }
         if(so_lo){
            let t1 = {
                so_lo : so_lo
            }
            filter = {...filter, ...t1}
        }
            documents = await chiTietKiemKhoService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}
exports.findOne =  async (req, res, next) => {  // 
    try{
        const chiTietKiemKhoService = new ChiTietKiemKhoService(MongoDB.client);
        const ma_phieu_kiem_kho = req.params.ma_phieu_kiem_kho; // tìm theo ma_phieu_kiem_kho
        const so_lo = req.params.so_lo; // tìm theo số lô
        let filter = {};
        if(ma_phieu_kiem_kho){
                        let t1 = {
                            ma_phieu_kiem_kho : ma_phieu_kiem_kho
                    }
            filter = {...filter, ...t1}
         }
         if(so_lo){
            let t1 = {
                so_lo : so_lo
            }
            filter = {...filter, ...t1}
        }
        const document = await chiTietKiemKhoService.findOne(filter);
        if(!document){
            return next(new ApiError(404, "Không tìm thấy data"));
        }
        return res.send(document);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    }
}

exports.findById =  async (req, res, next) => {  // 
    try{
        const chiTietKiemKhoService = new ChiTietKiemKhoService(MongoDB.client);
        const document = await chiTietKiemKhoService.findById(req.params.id);
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
     const chiTietKiemKhoService = new ChiTietKiemKhoService(MongoDB.client);
     
     const document = await chiTietKiemKhoService.update(req.params.id, req.body);
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
         const chiTietKiemKhoService = new ChiTietKiemKhoService(MongoDB.client);
         const document = await chiTietKiemKhoService.delete(req.params.id);
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


