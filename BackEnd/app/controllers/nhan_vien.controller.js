const ApiError = require("../config/api_error");
const NhanVienService = require("../services/nhan_vien.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");
const { sdtSchema, emailSchema } = require("../validation/index");


exports.create = async (req, res, next) => {
    if(req.body.ten_nhan_vien==null || req.body.sdt==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const nhanVienService = new NhanVienService(MongoDB.client);
          if(req.body.ma_nhan_vien){
            const exitsNhanVien2 = await nhanVienService.findOne({ma_nhan_vien: req.body.ma_nhan_vien});
            if(exitsNhanVien2){
                console.log(exitsNhanVien2);
                return next(new ApiError(401, "Mã nhân viên đã tồn tại"));
            }
          }
          const exitsNhanVien = await nhanVienService.findOne({ten_nhan_vien: req.body.ten_nhan_vien});
          if(exitsNhanVien){
              console.log(exitsNhanVien);
              return next(new ApiError(401, "Data đã tồn tại"));
          }
          const { error } = sdtSchema.validate(req.body.sdt);
          if (error) {
            return next(new ApiError(400, error.message));
          }
          if(req.body.email){
          const { error } = emailSchema.validate(req.body.email);
            if (error) {
                return next(new ApiError(400, error.message));
            }
        }
         
          if(!req.body.ma_nhan_vien){
            // sinh mã
            
            let countDocument = await nhanVienService.countDocument({});
            let ma_nhan_vien = "NV000001";
            if(countDocument && countDocument.length > 0){
                console.log('có count');
                
                let count = countDocument[0].countDocument;
                console.log(count);
                let sl = null;
                let exitsNhanVien3 = true;
                  while(exitsNhanVien3){
                   
                    // nếu tồn tại thì lặp tiếp
                    console.log(count);
                    count = count + 1;
                    console.log("sl " + sl);
                    sl = "000000" + count;
                    console.log("sl " + sl);
                    sl =  sl.slice(-6);
                    ma_nhan_vien = "NV" + sl;
                    console.log('Lặp ' + ma_nhan_vien);
                    // kiểm tra sự tồn tại
                   exitsNhanVien3 = await nhanVienService.findOne({ma_nhan_vien: ma_nhan_vien});
                  }   
                
            }
            console.log("ma_nhan_vien" + ma_nhan_vien);
            req.body.ma_nhan_vien = ma_nhan_vien;
          }
            const document = await nhanVienService.create(req.body);
            
            return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const nhanVienService = new NhanVienService(MongoDB.client);
        let ten_nhan_vien = req.query.ten_nhan_vien;
        let filter = {};
        if(ten_nhan_vien){
                    ten_nhan_vien = helper.escapeStringRegexp(ten_nhan_vien);
                        let t1 = {
                            ten_nhan_vien : {
                            $regex: new RegExp(ten_nhan_vien), $options: "i"
                        }
                    }
            filter = {...filter, ...t1}
         }
            documents = await nhanVienService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const nhanVienService = new NhanVienService(MongoDB.client);
        const document = await nhanVienService.findById(req.params.id);
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
     const nhanVienService = new NhanVienService(MongoDB.client);
     if(req.body.sdt){
     const { error } = sdtSchema.validate(req.body.sdt);
     if (error) {
       return next(new ApiError(400, error.message));
     }
    }
     const document = await nhanVienService.update(req.params.id, req.body);
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
         const nhanVienService = new NhanVienService(MongoDB.client);
         const document = await nhanVienService.delete(req.params.id);
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


