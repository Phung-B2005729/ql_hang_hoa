const ApiError = require("../config/api_error");
const CuaHangService = require("../services/cua_hang.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");
const { sdtSchema } = require("../validation/index");


exports.create = async (req, res, next) => {
    if(req.body.ten_cua_hang==null || req.body.dia_chi==null || req.body.sdt==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const cuaHangService = new CuaHangService(MongoDB.client);
          if(req.body.ma_cua_hang){
            const exitsCuaHang2 = await cuaHangService.findOne({ma_cua_hang: req.body.ma_cua_hang});
            if(exitsCuaHang2){
                console.log(exitsCuaHang2);
                return next(new ApiError(401, "Mã cửa hàng đã tồn tại"));
            }
          }
          const exitsCuaHang = await cuaHangService.findOne({ten_cua_hang: req.body.ten_cua_hang});
          if(exitsCuaHang){
              console.log(exitsCuaHang);
              return next(new ApiError(401, "Data đã tồn tại"));
          }
          const { error } = sdtSchema.validate(req.body.sdt);
          if (error) {
            return next(new ApiError(400, error.message));
          }
         
          if(!req.body.ma_cua_hang){
            // sinh mã
            
            let countDocument = await cuaHangService.countDocument({});
            let ma_cua_hang = "CN000001";
            if(countDocument && countDocument.length > 0){
                console.log('có count');
                
                let count = countDocument[0].countDocument;
                console.log(count);
                let sl = null;
                let exitsCuaHang3 = true;
                  while(exitsCuaHang3){
                   
                    // nếu tồn tại thì lặp tiếp
                    console.log(count);
                    count = count + 1;
                    console.log("sl " + sl);
                    sl = "000000" + count;
                    console.log("sl " + sl);
                    sl =  sl.slice(-6);
                    ma_cua_hang = "CN" + sl;
                    console.log('Lặp ' + ma_cua_hang);
                    // kiểm tra sự tồn tại
                   exitsCuaHang3 = await cuaHangService.findOne({ma_cua_hang: ma_cua_hang});
                  }   
                
            }
            console.log("ma_cua_hang" + ma_cua_hang);
            req.body.ma_cua_hang = ma_cua_hang;
          }
            const document = await cuaHangService.create(req.body);
            
            return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const cuaHangService = new CuaHangService(MongoDB.client);
        let ten_cua_hang = req.query.ten_cua_hang;
        let filter = {};
        if(ten_cua_hang){
                    ten_cua_hang = helper.escapeStringRegexp(ten_cua_hang);
                        let t1 = {
                            ten_cua_hang : {
                            $regex: new RegExp(ten_cua_hang), $options: "i"
                        }
                    }
            filter = {...filter, ...t1}
         }
            documents = await cuaHangService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const cuaHangService = new CuaHangService(MongoDB.client);
        const document = await cuaHangService.findById(req.params.id);
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
     const cuaHangService = new CuaHangService(MongoDB.client);
     if(req.body.sdt){
        const { error } = sdtSchema.validate(req.body.sdt);
        if (error) {
          return next(new ApiError(400, error.message));
        }
       }
     const document = await cuaHangService.update(req.params.id, req.body);
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
         const cuaHangService = new CuaHangService(MongoDB.client);
         const document = await cuaHangService.delete(req.params.id);
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


