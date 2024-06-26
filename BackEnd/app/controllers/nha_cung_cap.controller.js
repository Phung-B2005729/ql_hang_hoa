const ApiError = require("../config/api_error");
const NhaCungCapService = require("../services/nha_cung_cap.services");
const PhieuNhapService = require("../services/phieu_nhap.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");
const { sdtSchema } = require("../validation/index");


exports.create = async (req, res, next) => {
    if(req.body.ten_nha_cung_cap==null || req.body.dia_chi==null || req.body.sdt==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const nhaCungCapService = new NhaCungCapService(MongoDB.client);
          if(req.body.ma_nha_cung_cap){
            const exitsNhaCungCap2 = await nhaCungCapService.findOne({ma_nha_cung_cap: req.body.ma_nha_cung_cap});
            if(exitsNhaCungCap2){
                console.log(exitsNhaCungCap2);
                return next(new ApiError(401, "Mã nhà cung cấp đã tồn tại"));
            }
          }
          const exitsNhaCungCap = await nhaCungCapService.findOne({ten_nha_cung_cap: req.body.ten_nha_cung_cap});
          if(exitsNhaCungCap){
              console.log(exitsNhaCungCap);
              return next(new ApiError(401, "Data đã tồn tại"));
          }
          const { error } = sdtSchema.validate(req.body.sdt);
          if (error) {
            return next(new ApiError(400, error.message));
          }
         
          if(!req.body.ma_nha_cung_cap){
            // sinh mã
            
            let countDocument = await nhaCungCapService.countDocument({});
            let ma_nha_cung_cap = "NCC000001";
            if(countDocument && countDocument.length > 0){
                console.log('có count');
                
                let count = countDocument[0].countDocument;
                console.log(count);
                let sl = null;
                let exitsNhaCungCap3 = true;
                  while(exitsNhaCungCap3){
                   
                    // nếu tồn tại thì lặp tiếp
                    console.log(count);
                    count = count + 1;
                    console.log("sl " + sl);
                    sl = "000000" + count;
                    console.log("sl " + sl);
                    sl =  sl.slice(-6);
                    ma_nha_cung_cap = "NCC" + sl;
                    console.log('Lặp ' + ma_nha_cung_cap);
                    // kiểm tra sự tồn tại
                   exitsNhaCungCap3 = await nhaCungCapService.findOne({ma_nha_cung_cap: ma_nha_cung_cap});
                  }   
                
            }
            console.log("ma_nha_cung_cap" + ma_nha_cung_cap);
            req.body.ma_nha_cung_cap = ma_nha_cung_cap;
          }
            const document = await nhaCungCapService.create(req.body);
            
            return res.send(req.body.ma_nha_cung_cap);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const nhaCungCapService = new NhaCungCapService(MongoDB.client);
        let ten_nha_cung_cap = req.query.ten_nha_cung_cap;
        let filter = {};
        if(ten_nha_cung_cap){
                    ten_nha_cung_cap = helper.escapeStringRegexp(ten_nha_cung_cap);
                        let t1 = {
                            ten_nha_cung_cap : {
                            $regex: new RegExp(ten_nha_cung_cap), $options: "i"
                        }
                    }
            filter = {...filter, ...t1}
         }
        
         let pro = {
            ma_nha_cung_cap: 1, // tự động
            ten_nha_cung_cap: 1,
            dia_chi: 1,
            email: 1,
            cong_ty: 1,
            sdt: 1,
            'phieu_nhap_info.ma_cua_hang': 1,
            'phieu_nhap_info.tong_tien': 1,
            'phieu_nhap_info.trang_thai': 1,
            'phieu_nhap_info.ngayLapPhieu' : 1,
         }
            documents = await nhaCungCapService.findLookup(filter, pro);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const nhaCungCapService = new NhaCungCapService(MongoDB.client);
     
        let pro = {
            ma_nha_cung_cap: 1, // tự động
            ten_nha_cung_cap: 1,
            dia_chi: 1,
            email: 1,
            cong_ty: 1,
            sdt: 1,
            ghi_chu: 1,
            'phieu_nhap_info.ma_cua_hang': 1,
            'phieu_nhap_info.tong_tien': 1,
            'phieu_nhap_info.trang_thai': 1,
            'phieu_nhap_info.ngay_lap_phieu' : 1,
            'phieu_nhap_info.ma_nhan_vien': 1,
            'phieu_nhap_info.ma_phieu_nhap': 1,

            'phieu_nhap_info.nhan_vien_info.ten_nhan_vien': 1,
         }
         let   document = await nhaCungCapService.findLookup({
            ma_nha_cung_cap: req.params.id
         }, pro);
     
        if(!document || (document && document.length==0)){
            return next(new ApiError(404, "Không tìm thấy data"));
        }
        return res.send(document[0]);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    }
}
exports.update = async (req,res, next) => {
    if(Object.keys(req.body).length == 0){
     return next(new ApiError(400,"Data to update can not be empty"));
    }
    try{
     const nhaCungCapService = new NhaCungCapService(MongoDB.client);
     if(req.body.sdt){
     const { error } = sdtSchema.validate(req.body.sdt);
     if (error) {
       return next(new ApiError(400, error.message));
     }
    }
     const document = await nhaCungCapService.update(req.params.id, req.body);
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
         const nhaCungCapService = new NhaCungCapService(MongoDB.client);
         // nhà cung cấp đã có dữ liệu phiếu nhập không thể xoá
         const phieuNhapService = new PhieuNhapService(MongoDB.client);
         const phieNhap = await phieuNhapService.findOne({
            ma_nha_cung_cap: req.params.id
         });
         if(phieNhap!=null){
            //console.log(phieNhap);
            return next(new ApiError(401, "Nhà cung cấp đã có dữ liệu phiếu nhập không thể xoá"));
         }
         const document = await nhaCungCapService.delete(req.params.id);
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


