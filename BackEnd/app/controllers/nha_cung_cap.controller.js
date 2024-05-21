const ApiError = require("../config/api_error");
const NhaCungCapService = require("../services/nha_cung_cap.services");
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
            
            return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const nhaCungCapService = new NhaCungCapService(MongoDB.client);
        const ten_nha_cung_cap = req.query.ten_nha_cung_cap;
        const filter = {};
        if(ten_nha_cung_cap){
                    ten_nha_cung_cap = helper.escapeStringRegexp(ten_nha_cung_cap);
                        let t1 = {
                            ten_nha_cung_cap : {
                            $regex: new RegExp(ten_nha_cung_cap), $options: "i"
                        }
                    }
            filter = {...filter, ...t1}
         }
            documents = await nhaCungCapService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const nhaCungCapService = new NhaCungCapService(MongoDB.client);
        const document = await nhaCungCapService.findById(req.params.id);
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


