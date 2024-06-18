const ApiError = require("../config/api_error");
const HangHoaService = require("../services/hang_hoa.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");
const { sdtSchema, emailSchema } = require("../validation/index");


exports.create = async (req, res, next) => {
    if(req.body.ten_hang_hoa==null || req.body.loai_hang==null || req.body.thuong_hieu==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const hangHoaService = new HangHoaService(MongoDB.client);
          if(req.body.ma_hang_hoa){
            const exitsHangHoa2 = await hangHoaService.findOne({ma_hang_hoa: req.body.ma_hang_hoa});
            if(exitsHangHoa2){
                console.log(exitsHangHoa2);
                return next(new ApiError(401, "Mã hàng hoá đã tồn tại"));
            }
          }
          const exitsHangHoa = await hangHoaService.findOne({ten_hang_hoa: req.body.ten_hang_hoa});
          if(exitsHangHoa){
              console.log(exitsHangHoa);
              return next(new ApiError(401, "Data đã tồn tại"));
          }
         
         
          if(!req.body.ma_hang_hoa){
            // sinh mã
            
            let countDocument = await hangHoaService.countDocument({});
            let ma_hang_hoa = "SP000001";
            if(countDocument && countDocument.length > 0){
                console.log('có count');
                
                let count = countDocument[0].countDocument;
                console.log(count);
                let sl = null;
                let exitsHangHoa3 = true;
                  while(exitsHangHoa3){
                    // nếu tồn tại thì lặp tiếp
                    console.log(count);
                    count = count + 1;
                    console.log("sl " + sl);
                    sl = "000000" + count;
                    console.log("sl " + sl);
                    sl =  sl.slice(-6);
                    ma_hang_hoa = "SP" + sl;
                    console.log('Lặp ' + ma_hang_hoa);
                    // kiểm tra sự tồn tại
                   exitsHangHoa3 = await hangHoaService.findOne({ma_hang_hoa: ma_hang_hoa});
                  }   
                
            }
            console.log("ma_hang_hoa" + ma_hang_hoa);
            req.body.ma_hang_hoa = ma_hang_hoa;
          }
            const document = await hangHoaService.create(req.body);
            
            return res.send(req.body.ma_hang_hoa);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const hangHoaService = new HangHoaService(MongoDB.client);
        let ten_hang_hoa = req.query.ten_hang_hoa;
        let filter = {};
        if(ten_hang_hoa){
                    ten_hang_hoa = helper.escapeStringRegexp(ten_hang_hoa);
                        let t1 = {
                            ten_hang_hoa : {
                            $regex: new RegExp(ten_hang_hoa), $options: "i"
                        }
                    }
            filter = {...filter, ...t1}
         }
            documents = await hangHoaService.find(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const hangHoaService = new HangHoaService(MongoDB.client);
        const document = await hangHoaService.findById(req.params.id);
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
     const hangHoaService = new HangHoaService(MongoDB.client);
     console.log('update');
     console.log(req.body);
     const document = await hangHoaService.update(req.params.id, req.body);
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
         const hangHoaService = new HangHoaService(MongoDB.client);
         const document = await hangHoaService.delete(req.params.id);
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


