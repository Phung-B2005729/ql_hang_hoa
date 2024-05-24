const ApiError = require("../config/api_error");
const PhieuKiemKhoService = require("../services/phieu_kiem_kho.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");
const { sdtSchema } = require("../validation/index");


exports.create = async (req, res, next) => {
    if(req.body.ma_nhan_vien==null || req.body.ma_cua_hang==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const phieuKiemKhoService = new PhieuKiemKhoService(MongoDB.client);
          if(req.body.ma_phieu_kiem_kho){
            const exitsphieuKiemKho2 = await phieuKiemKhoService.findOne({ma_phieu_kiem_kho: req.body.ma_phieu_kiem_kho});
            if(exitsphieuKiemKho2){
                console.log(exitsphieuKiemKho2);
                return next(new ApiError(401, "Mã phiếu nhập đã tồn tại"));
            }
          }
         
     
          if(!req.body.ma_phieu_kiem_kho){
            // sinh mã
            
            let countDocument = await phieuKiemKhoService.countDocument({});
            let ma_phieu_kiem_kho = "KK000001";
            if(countDocument && countDocument.length > 0){
                console.log('có count');
                
                let count = countDocument[0].countDocument;
                console.log(count);
                let sl = null;
                let exitsphieuKiemKho3 = true;
                  while(exitsphieuKiemKho3){
                   
                    // nếu tồn tại thì lặp tiếp
                    console.log(count);
                    count = count + 1;
                    console.log("sl " + sl);
                    sl = "000000" + count;
                    console.log("sl " + sl);
                    sl =  sl.slice(-6);
                    ma_phieu_kiem_kho = "KK" + sl;
                    console.log('Lặp ' + ma_phieu_kiem_kho);
                    // kiểm tra sự tồn tại
                   exitsphieuKiemKho3 = await phieuKiemKhoService.findOne({ma_phieu_kiem_kho: ma_phieu_kiem_kho});
                  }   
                
            }
            console.log("ma_kiem_kho" + ma_phieu_kiem_kho);
            req.body.ma_phieu_kiem_kho = ma_phieu_kiem_kho;
          }
            const document = await phieuKiemKhoService.create(req.body); 
            res.send(req.body.ma_phieu_kiem_kho);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const phieuKiemKhoService = new PhieuKiemKhoService(MongoDB.client);
        const ngay_lap_phieu = req.query.ngay_lap_phieu;
        const ma_cua_hang = req.query.ma_cua_hang;
        const ma_kiem_kho = req.query.ma_kiem_kho;
        let filter = {};
        if(ngay_lap_phieu){
         
                        let t1 = {
                            ngay_lap_phieu : ngay_lap_phieu
                    }
            filter = {...filter, ...t1}
         }
         if(ma_cua_hang){
         
            let t1 = {
                ma_cua_hang : ma_cua_hang
            }
        filter = {...filter, ...t1}
        }
       
            documents = await phieuKiemKhoService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const phieuKiemKhoService = new PhieuKiemKhoService(MongoDB.client);
        const document = await phieuKiemKhoService.findById(req.params.id);
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
     const phieuKiemKhoService = new PhieuKiemKhoService(MongoDB.client);
    
     const document = await phieuKiemKhoService.update(req.params.id, req.body);
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
         const phieuKiemKhoService = new PhieuKiemKhoService(MongoDB.client);
         const document = await phieuKiemKhoService.delete(req.params.id);
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


