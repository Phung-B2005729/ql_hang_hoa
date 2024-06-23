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
            if(!req.body.ma_cap_nhat && req.body.loai_giao_dich && req.body.loai_giao_dich=='Cập nhật'){
                // sinh mã cập nhật
                
                let countDocument = await giaoDichSerivce.countDocument({});
                let ma_cap_nhat = "CB000001";
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
                        ma_cap_nhat = "SP" + sl;
                        console.log('Lặp ' + ma_cap_nhat);
                        // kiểm tra sự tồn tại
                       exitsHangHoa3 = await giaoDichSerivce.findOne({ma_cap_nhat: ma_cap_nhat});
                      }   
                    
                }
                console.log("ma_hang_hoa" + ma_cap_nhat);
                req.body.ma_cap_nhat = ma_cap_nhat;
              }

              if(!req.body.ma_xuat_kho && req.body.loai_giao_dich && req.body.loai_giao_dich=='Xuất kho'){
                // sinh mã cập nhật
                
                let countDocument = await giaoDichSerivce.countDocument({});
                let ma_xuat_kho = "XK000001";
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
                        ma_xuat_kho = "SP" + sl;
                        console.log('Lặp ' + ma_xuat_kho);
                        // kiểm tra sự tồn tại
                       exitsHangHoa3 = await giaoDichSerivce.findOne({ma_xuat_kho: ma_xuat_kho});
                      }   
                    
                }
                console.log("ma_hang_hoa" + ma_xuat_kho);
                req.body.ma_xuat_kho = ma_xuat_kho;
              }
         
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
        const ma_cua_hang_chuyen_den = req.query.ma_cua_hang_chuyen_den;
        const ma_nhan_vien = req.query.ma_nhan_vien;
        const loai_giao_dich = req.query.loai_giao_dich;
        let filter = {};
        if(so_lo && so_lo!='Tất cả' && so_lo!=''){
         
                        let t1 = {
                            so_lo : so_lo
                    }
            filter = {...filter, ...t1}
         }
         if(ma_cua_hang && ma_cua_hang!='' && ma_cua_hang!='Tất cả'){
         
            let t1 = {
                ma_cua_hang : ma_cua_hang
        }
        filter = {...filter, ...t1}
       }
    if(ma_hang_hoa && ma_hang_hoa!='' && ma_hang_hoa!='Tất cả'){
         
            let t1 = {
                ma_hang_hoa : ma_hang_hoa
        }
        filter = {...filter, ...t1}
    }
    if(ma_nhan_vien && ma_nhan_vien!='' && ma_nhan_vien!='Tất cả'){
         
        let t1 = {
            ma_nhan_vien : ma_nhan_vien
        }
       filter = {...filter, ...t1}
    }
    if(loai_giao_dich && loai_giao_dich!='' && loai_giao_dich!='Tất cả'){
         
        let t1 = {
            loai_giao_dich : loai_giao_dich
        }
        filter = {...filter, ...t1}
    }
    if(ma_cua_hang_chuyen_den && ma_cua_hang_chuyen_den!='' && ma_cua_hang_chuyen_den!='Tất cả'){
        let t1 = {
            ma_cua_hang_chuyen_den : ma_cua_hang_chuyen_den
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


