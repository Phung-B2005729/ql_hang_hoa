const ApiError = require("../config/api_error");
const GiaoDichSerivce = require("../services/giao_dich.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");
const { sdtSchema } = require("../validation/index");


exports.create = async (req, res, next) => {
    if(req.body.so_lo==null || req.body.ma_cua_hang==null || 
        req.body.loai_giao_dich==null || req.body.so_luong_giao_dich==null || 
        req.body.so_luong_ton==null || req.body.gia_von==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const giaoDichSerivce = new GiaoDichSerivce(MongoDB.client);
            const document = await giaoDichSerivce.create(req.body); 
            return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const giaoDichSerivce = new GiaoDichSerivce(MongoDB.client);
        const so_lo = req.query.so_lo;
        const ma_hang_hoa = req.query.ma_hang_hoa;
        const ma_cua_hang = req.query.ma_cua_hang;
        const ma_nhan_vien = req.query.ma_nhan_vien;
        const loai_giao_dich = req.query.loai_giao_dich;
        const filter = {};
        if(so_lo){
         
                        let t1 = {
                            so_lo : so_lo
                    }
            filter = {...filter, ...t1}
         }
         if(ma_cua_hang){
         
            let t1 = {
                ma_cua_hang : ma_cua_hang
        }
        filter = {...filter, ...t1}
       }
    if(ma_hang_hoa){
         
            let t1 = {
                ma_hang_hoa : ma_hang_hoa
        }
        filter = {...filter, ...t1}
    }
    if(ma_nhan_vien){
         
        let t1 = {
            ma_nhan_vien : ma_nhan_vien
        }
       filter = {...filter, ...t1}
    }
    if(loai_giao_dich){
         
        let t1 = {
            loai_giao_dich : loai_giao_dich
        }
        filter = {...filter, ...t1}
    }

            documents = await giaoDichSerivce.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

// khoảng thời gian giao dich

exports.findOne =  async (req, res, next) => {  // 
    try{
        const giaoDichSerivce = new GiaoDichSerivce(MongoDB.client);
        const document = await giaoDichSerivce.findById(req.params.id);
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
     const giaoDichSerivce = new GiaoDichSerivce(MongoDB.client);
    
     const document = await giaoDichSerivce.update(req.params.id, req.body);
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
         const giaoDichSerivce = new GiaoDichSerivce(MongoDB.client);
         const document = await giaoDichSerivce.delete(req.params.id);
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


