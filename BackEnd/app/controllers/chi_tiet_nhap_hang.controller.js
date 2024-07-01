const ApiError = require("../config/api_error");
const ChiTietNhapHangService = require("../services/chi_tiet_nhap_hang.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");



exports.create = async (req, res, next) => {

    if(req.body.ma_phieu_nhap==null || req.body.so_luong==null || req.body.don_gia_nhap==null || req.body.ma_hang_hoa==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const chiTietNhapHangService = new ChiTietNhapHangService(MongoDB.client);
          if(req.body.ma_phieu_nhap && req.body.ma_hang_hoa){
            const exitsChiTiet2 = await chiTietNhapHangService.findOne({ma_phieu_nhap: req.body.ma_phieu_nhap, ma_hang_hoa: req.body.ma_hang_hoa});
            if(exitsChiTiet2){
                console.log(exitsChiTiet2);
                return next(new ApiError(401, "Mã phiếu nhập và số lô đã tồn tại"));
            }
          }
        const document = await chiTietNhapHangService.create(req.body);
        return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const chiTietNhapHangService = new ChiTietNhapHangService(MongoDB.client);
        const ma_phieu_nhap = req.query.ma_phieu_nhap; // tìm theo ma_phieu_nhap
        const so_lo = req.query.so_lo; // tìm theo số lô
        const ma_hang_hoa = req.query.ma_hang_hoa;
        let filter = {};
        if(ma_phieu_nhap && ma_phieu_nhap!='' && ma_phieu_nhap!='Tất cả'){
                        let t1 = {
                            ma_phieu_nhap : ma_phieu_nhap
                    }
            filter = {...filter, ...t1}
         }
         if(so_lo && so_lo!='' && so_lo!='Tất cả'){
            let t1 = {
                'lo_nhap.so_lo' : so_lo
            }
            filter = {...filter, ...t1}
        }
        if(ma_hang_hoa && ma_hang_hoa!='' && ma_hang_hoa!='Tất cả'){
            let t1 = {
                ma_hang_hoa : ma_hang_hoa
            }
            filter = {...filter, ...t1}
        }
            documents = await chiTietNhapHangService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}
exports.findOne =  async (req, res, next) => {  // 
    try{
        const chiTietNhapHangService = new ChiTietNhapHangService(MongoDB.client);
        const ma_phieu_nhap = req.params.ma_phieu_nhap; // tìm theo ma_phieu_nhap
        const so_lo = req.params.so_lo; // tìm theo số lô
        const ma_hang_hoa = req.params.ma_hang_hoa;
        let filter = {};
        if(ma_phieu_nhap){
                        let t1 = {
                            ma_phieu_nhap : ma_phieu_nhap
                    }
            filter = {...filter, ...t1}
         }
         if(ma_hang_hoa){
            let t1 = {
                ma_hang_hoa : ma_hang_hoa
        }
filter = {...filter, ...t1}
}
         if(so_lo){
            let t1 = {
                so_lo : so_lo
            }
            filter = {...filter, ...t1}
        }
        const document = await chiTietNhapHangService.findOne(filter);
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
        const chiTietNhapHangService = new ChiTietNhapHangService(MongoDB.client);
        const document = await chiTietNhapHangService.findById(req.params.id);
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
     const chiTietNhapHangService = new ChiTietNhapHangService(MongoDB.client);
     
     const document = await chiTietNhapHangService.update(req.params.id, req.body);
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
         const chiTietNhapHangService = new ChiTietNhapHangService(MongoDB.client);
         const document = await chiTietNhapHangService.delete(req.params.id);
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

 exports.deleteMany = async (req,res, next) => {
   
    try{
        const chiTietNhapHangService = new ChiTietNhapHangService(MongoDB.client);
        const document = await chiTietNhapHangService.deleteMany({
            ma_phieu_nhap: req.params.ma_phieu_nhap
        })
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



