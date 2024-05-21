const ApiError = require("../config/api_error");
const TonKhoLoHangService = require("../services/ton_kho_lo_hang.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");



exports.create = async (req, res, next) => {
    if(req.body.so_lo==null || req.body.ma_cua_hang==null || req.body.so_luong_ton==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
          if(req.body.so_lo && req.body.ma_cua_hang){
            const exitsTonKho = await tonKhoLoHangService.findOne({so_lo: req.body.so_lo, ma_cua_hang: req.body.ma_cua_hang});
            if(exitsTonKho){
                console.log(exitsTonKho);
                return next(new ApiError(401, "Kho lô hàng tại cửa hàng đã tồn tại"));
            }
          }
        const document = await tonKhoLoHangService.create(req.body);
        return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
        const ma_cua_hang = req.query.ma_cua_hang; // tìm theo ma_cua_hang
        const so_lo = req.query.so_lo; // tìm theo số lô
        let filter = {};
        if(ma_cua_hang){
                        let t1 = {
                            ma_cua_hang : ma_cua_hang
                    }
            filter = {...filter, ...t1}
         }
         if(so_lo){
            let t1 = {
                so_lo : so_lo
            }
            filter = {...filter, ...t1}
        }
            documents = await tonKhoLoHangService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
        const ma_cua_hang = req.params.ma_cua_hang; // tìm theo ma_cua_hang
        const so_lo = req.params.so_lo; // tìm theo số lô
        let filter = {};
        if(ma_cua_hang){
                        let t1 = {
                            ma_cua_hang : ma_cua_hang
                    }
            filter = {...filter, ...t1}
         }
         if(so_lo){
            let t1 = {
                so_lo : so_lo
            }
            filter = {...filter, ...t1}
        }
        const document = await tonKhoLoHangService.findOne(filter);
        
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
        const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
        const document = await tonKhoLoHangService.findById(req.params.id);
        
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
     const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
     
     const document = await tonKhoLoHangService.update(req.params.id, req.body);
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

 exports.updateLoHangCuaHang = async (req,res, next) => {
    if(Object.keys(req.body).length == 0){
     return next(new ApiError(400,"Data to update can not be empty"));
    }
    try{
     const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
     
     const document = await tonKhoLoHangService.updateLoHangCuaHang(req.params.so_lo, req.params.ma_cua_hang, payload)
     if(!document){
         return next(new ApiError(404,"not found"));
     }
     return res.send({
         message: "updated successfully"
     });
    }catch(err){
     return next(new ApiError(500, `Lỗi server update with so_lo=${req.params.so_lo} and ma_cua_hang==${req.params.ma_cua_hang}`));
    }
 };
 
 exports.delete = async (req,res, next) => {
   
     try{
         const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
         const document = await tonKhoLoHangService.delete(req.params.id);
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


