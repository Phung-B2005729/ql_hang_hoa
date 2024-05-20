const ApiError = require("../config/api_error");
const PhieuNhapService = require("../services/phieu_nhap.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");
const { sdtSchema } = require("../validation/index");


exports.create = async (req, res, next) => {
    if(req.body.ma_nha_cung_cap==null || req.body.ma_nhan_vien==null || req.body.ma_cua_hang==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const phieuNhapService = new PhieuNhapService(MongoDB.client);
          if(req.body.ma_phieu_nhap){
            const exitsPhieuNhap2 = await phieuNhapService.findOne({ma_phieu_nhap: req.body.ma_phieu_nhap});
            if(exitsPhieuNhap2){
                console.log(exitsPhieuNhap2);
                return next(new ApiError(401, "Mã phiếu nhập đã tồn tại"));
            }
          }
         
     
          if(!req.body.ma_phieu_nhap){
            // sinh mã
            
            let countDocument = await phieuNhapService.countDocument({});
            let ma_phieu_nhap = "NCC000001";
            if(countDocument && countDocument.length > 0){
                console.log('có count');
                
                let count = countDocument[0].countDocument;
                console.log(count);
                let sl = null;
                let exitsPhieuNhap3 = true;
                  while(exitsPhieuNhap3){
                   
                    // nếu tồn tại thì lặp tiếp
                    console.log(count);
                    count = count + 1;
                    console.log("sl " + sl);
                    sl = "000000" + count;
                    console.log("sl " + sl);
                    sl =  sl.slice(-6);
                    ma_phieu_nhap = "NCC" + sl;
                    console.log('Lặp ' + ma_phieu_nhap);
                    // kiểm tra sự tồn tại
                   exitsPhieuNhap3 = await phieuNhapService.findOne({ma_phieu_nhap: ma_phieu_nhap});
                  }   
                
            }
            console.log("ma_nha_cung_cap" + ma_phieu_nhap);
            req.body.ma_phieu_nhap = ma_phieu_nhap;
          }
            const document = await phieuNhapService.create(req.body); 
            res.send(req.body.ma_phieu_nhap);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const phieuNhapService = new PhieuNhapService(MongoDB.client);
        const ngay_lap_phieu = req.query.ngay_lap_phieu;
        const filter = {};
        if(ngay_lap_phieu){
            ngay_lap_phieu = helper.escapeStringRegexp(ngay_lap_phieu);
                        let t1 = {
                            ngay_lap_phieu : {
                            $regex: new RegExp(ngay_lap_phieu), $options: "i"
                        }
                    }
            filter = {...filter, ...t1}
         }
            documents = await phieuNhapService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // lấy tên loại hàng theo id
    try{
        const phieuNhapService = new PhieuNhapService(MongoDB.client);
        const document = await phieuNhapService.findById(req.params.id);
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
     const phieuNhapService = new PhieuNhapService(MongoDB.client);
    
     const document = await phieuNhapService.update(req.params.id, req.body);
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
         const phieuNhapService = new PhieuNhapService(MongoDB.client);
         const document = await phieuNhapService.delete(req.params.id);
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


