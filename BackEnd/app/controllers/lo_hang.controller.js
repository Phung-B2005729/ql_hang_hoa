const ApiError = require("../config/api_error");
const LoHangService = require("../services/lo_hang.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");



exports.create = async (req, res, next) => {
    if(req.body.so_lo==null || req.body.ma_hang_hoa==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const loHangService = new LoHangService(MongoDB.client);
          if(req.body.so_lo && req.body.ma_hang_hoa){
            const exitsHangHoa2 = await loHangService.findOne({so_lo: req.body.so_lo, ma_hang_hoa: req.body.ma_hang_hoa});
            if(exitsHangHoa2){
                console.log(exitsHangHoa2);
                return next(new ApiError(401, "Số lô của hàng hoá đã tồn tại"));
            }
          }
        const document = await loHangService.create(req.body);
        return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const loHangService = new LoHangService(MongoDB.client);
        const ma_hang_hoa = req.query.ma_hang_hoa; // tìm theo ma_hang_hoa
        const ma_cua_hang = req.query.ma_cua_hang;
        console.log(ma_cua_hang);
        let filter = {};
        let project = {
            so_lo: 1,
          //  "ton_kho.ma_cua_hang": 1,
          //  "ton_kho.so_luong_ton" : 1,
            ma_hang_hoa: 1,
            ngay_san_xuat: 1,
            han_su_dung: 1,
            trang_thai: 1,
            ton_kho: 1,
        }
        if(ma_hang_hoa!=null && ma_hang_hoa!='Tất cả' && ma_hang_hoa!=''){
                        let t1 = {
                            ma_hang_hoa : ma_hang_hoa
                    }
            filter = {...filter, ...t1}
         }
         if(ma_cua_hang!='Tất cả' && ma_cua_hang!=null && ma_cua_hang!=''){
            let t1 = {
                ton_kho: {
                    $filter: {
                      input: "$ton_kho",
                      as: "tk",
                      cond: { $eq: ["$$tk.ma_cua_hang", ma_cua_hang] }
                    }
                  },
            }
            project= {
                ...project, ...t1
            }
            
        }

        
        console.log(project);

         
            documents = await loHangService.findLookUp(filter, project);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const loHangService = new LoHangService(MongoDB.client);
        const document = await loHangService.findLookUp({
            so_lo: req.params.id
        });
        if(!document){
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
     const loHangService = new LoHangService(MongoDB.client);
    
     const document = await loHangService.update(req.params.id, req.body);
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
         const loHangService = new LoHangService(MongoDB.client);
         const document = await loHangService.delete(req.params.id);
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


