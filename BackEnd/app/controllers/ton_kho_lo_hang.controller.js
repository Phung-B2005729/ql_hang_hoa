const ApiError = require("../config/api_error");
const TonKhoLoHangService = require("../services/ton_kho_lo_hang.services");
const LoHangService = require("../services/lo_hang.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");



exports.create = async (req, res, next) => {
    if(req.body.so_lo==null || req.body.ma_cua_hang==null || req.body.so_luong_ton==null || req.body.ma_hang_hoa==null){
        return next(new ApiError(400, "Data can not be empty"));
    }
    else{
        try{
          const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
          if(req.body.so_lo && req.body.ma_cua_hang && req.body.ma_hang_hoa){
            const exitsTonKho = await tonKhoLoHangService.findOne({so_lo: req.body.so_lo, ma_cua_hang: req.body.ma_cua_hang, ma_hang_hoa: req.body.ma_hang_hoa});
            if(exitsTonKho){
                console.log(exitsTonKho);
                return next(new ApiError(401, "Kho lô hàng tại cửa hàng đã tồn tại"));
            }
          }
        const document = await tonKhoLoHangService.create(req.body);
        return res.send(document.insertedId);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = []
    try{
        const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
        const ma_cua_hang = req.query.ma_cua_hang; // tìm theo ma_cua_hang
        const so_lo = req.query.so_lo; // tìm theo số lô
        const ma_hang_hoa = req.query.ma_hang_hoa;
       let so_ngay = req.query.so_ngay;
      

        let filter = {}; 
        if(ma_cua_hang && so_lo!='' && so_lo!='Tất cả'){
                        let t1 = {
                            ma_cua_hang : ma_cua_hang
                    }
            filter = {...filter, ...t1}
         }
         if(so_lo && so_lo!='' && so_lo!='Tất cả'){
            let t1 = {
                so_lo : so_lo
            }
            filter = {...filter, ...t1}
        }
        if(ma_hang_hoa && ma_hang_hoa!='' && ma_hang_hoa!='Tất cả'){
            let t1 = {
                ma_hang_hoa: ma_hang_hoa
            }
            filter = {...filter, ...t1}
        }

        if(so_ngay){
            let soNgayNumber = parseInt(so_ngay, 10);
            let han_su_dung = await helper.khoangNgayDenHan(soNgayNumber);
            if(han_su_dung){
                let t1 = {
                    han_su_dung: {
                        $lte: han_su_dung,
                    }
                }
                filter = {...filter, ...t1}
            }
        }
        console.log(filter);

        let project = {
            so_lo: 1,
            han_su_dung: 1,
            ma_cua_hang: 1,
            so_luong_ton : 1,
            ma_hang_hoa: 1,
            'hang_hoa_info.ten_hang_hoa': 1,
            'hang_hoa_info.don_vi_tinh': 1,
        }
            documents = await tonKhoLoHangService.findLookup(filter, project);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
        const ma_cua_hang = req.params.ma_cua_hang; // tìm theo ma_cua_hang
        const so_lo = req.params.so_lo; // tìm theo số lô
        const ma_hang_hoa = req.params.ma_hang_hoa;
        let filter = {};
        if(ma_cua_hang){
                        let t1 = {
                            ma_cua_hang : ma_cua_hang
                    }
            filter = {...filter, ...t1}
         }
         if(so_lo){
            let t1 = {
                so_lo : so_lo
            }
            filter = {...filter, ...t1}
        }
        if(ma_hang_hoa){
            let t1 = {
                ma_hang_hoa : ma_hang_hoa
            }
            filter = {...filter, ...t1}
        }
        const document = await tonKhoLoHangService.findOne(filter);
        
        if(!document){
            return next(new ApiError(404, "Không tìm thấy data"));
        }
        return res.send(document);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    }
}
exports.findById =  async (req, res, next) => {  // 
    try{
        const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
        const document = await tonKhoLoHangService.findById(req.params.id);
        
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
     const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
     
     const document = await tonKhoLoHangService.update(req.params.id, req.body);
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
 exports.updateTheoLoSoHangHoaCuaHang = async (req,res, next) => {
    if(Object.keys(req.body).length == 0){
     return next(new ApiError(400,"Data to update can not be empty"));
    }
    try{
        let filter = {
            so_lo: req.params.so_lo,
            ma_cua_hang: req.params.ma_cua_hang,
            ma_hang_hoa: req.params.ma_hang_hoa
         }
     const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
     
     const document = await tonKhoLoHangService.updateFilter(filter, req.body);
     if(!document){
         return next(new ApiError(404,"not found"));
     }
     return res.send({
         message: "updated successfully"
     });
    }catch(err){
        return next(new ApiError(500, `Lỗi server update with so_lo=${req.params.so_lo} and ma_hang_hoa==${req.params.ma_hang_hoa} ma_cua_hang==${req.params.ma_cua_hang}`));
    }
 };

 exports.themSoLuongTonKho = async (req,res, next) => {
    if(Object.keys(req.body).length == 0){
     return next(new ApiError(400,"Data to update can not be empty"));
    }
    let document = null;
    try{
     const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
     const loHangService = new LoHangService(MongoDB.client);
     let filter = {
        so_lo: req.params.so_lo,
        ma_cua_hang: req.params.ma_cua_hang,
        ma_hang_hoa: req.params.ma_hang_hoa
     }
     // tìm lô này
     const tonKho = await tonKhoLoHangService.findOne(filter);
     if(tonKho){
        req.body.so_luong_ton = req.body.so_luong_ton + tonKho.so_luong_ton;
        console.log(' tổng số lượng tồn');
        console.log(req.body.so_luong_ton);
       document = await tonKhoLoHangService.updateFilter(filter, req.body);
       console.log('đã cập nhật tồn kho');
    }else{
        // kho của lô chưa có tạo lô mới và thêm mới tồn kho
      const themLo = await loHangService.create(req.body);
      console.log('thêm lô');
      
      // thêm lô mới
      // thêm tồn kho mới
     
         document = await tonKhoLoHangService.create(req.body);
      
    
    }
     if(!document){
         return next(new ApiError(404,"not found"));
     }
     document = await loHangService.findLookUp({
        so_lo: req.params.so_lo,
        ma_hang_hoa: req.params.ma_hang_hoa
     }, {
        so_lo: 1,
        ma_hang_hoa: 1,
        ngay_san_xuat: 1,
        han_su_dung: 1,
        trang_thai: 1,
        "ton_kho.ma_cua_hang": 1,
        "ton_kho.so_luong_ton" : 1,
     });
     console.log('gọi lookup hiển thị lô');
     if(!document){
        return next(new ApiError(404,"không tìm thấy lô hàng"));
    }
    return res.send(document[0]);
    // trả về danh sách tồn kho của lô hàng này;
    }catch(err){
     return next(new ApiError(500, `Lỗi server update with so_lo=${req.params.so_lo} and ma_hang_hoa==${req.params.ma_hang_hoa} ma_cua_hang==${req.params.ma_cua_hang}`));
    }
 };
 
 exports.giamSoLuongTonKho = async (req,res, next) => {
    if(Object.keys(req.body).length == 0){
     return next(new ApiError(400,"Data to update can not be empty"));
    }
    // trả về thông tin lô hàng;
    let document = null;
    try{
     const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
     const loHangService = new LoHangService(MongoDB.client);
     let filter = {
        so_lo: req.params.so_lo,
        ma_cua_hang: req.params.ma_cua_hang,
        ma_hang_hoa: req.params.ma_hang_hoa
     }
     // tìm lô này
     const tonKho = await tonKhoLoHangService.findOne(filter);
     if(!tonKho){
        return next(new ApiError(404,"Không tìm thấy dữ liệu tồn kho"));
     }
   
        req.body.so_luong_ton =  (tonKho.so_luong_ton - req.body.so_luong_ton) < 0 ? 0 : (tonKho.so_luong_ton - req.body.so_luong_ton);
        console.log(' tổng số lượng tồn');
        console.log(req.body.so_luong_ton);
       document = await tonKhoLoHangService.updateFilter(filter, req.body);
       console.log('đã cập nhật tồn kho');

     if(!document){
         return next(new ApiError(404,"not found"));
     }
     document = await loHangService.findLookUp({
        so_lo: req.params.so_lo,
        ma_hang_hoa: req.params.ma_hang_hoa
     }, {
        so_lo: 1,
        ma_hang_hoa: 1,
        ngay_san_xuat: 1,
        han_su_dung: 1,
        trang_thai: 1,
        "ton_kho.ma_cua_hang": 1,
        "ton_kho.so_luong_ton" : 1,
     });
     console.log('gọi lookup hiển thị lô');
     if(!document){
        return next(new ApiError(404,"không tìm thấy lô hàng"));
    }
    return res.send(document[0]);
    // trả về danh sách tồn kho của lô hàng này;
    }catch(err){
     return next(new ApiError(500, `Lỗi server update with so_lo=${req.params.so_lo} and ma_hang_hoa==${req.params.ma_hang_hoa} ma_cua_hang==${req.params.ma_cua_hang}`));
    }
 };
 exports.delete = async (req,res, next) => {
   
     try{
         const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
         const document = await tonKhoLoHangService.delete(req.params.id);
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

 exports.countTonKho = async (req, res, next) => {
    let documents = []
    try{
        const tonKhoLoHangService = new TonKhoLoHangService(MongoDB.client);
        const ma_cua_hang = req.query.ma_cua_hang; // tìm theo ma_cua_hang
        const so_lo = req.query.so_lo; // tìm theo số lô
        const ma_hang_hoa = req.query.ma_hang_hoa;
        let filter = {};
        if(ma_cua_hang && so_lo!='' && so_lo!='Tất cả'){
                        let t1 = {
                            ma_cua_hang : ma_cua_hang
                    }
            filter = {...filter, ...t1}
         }
         if(so_lo && so_lo!='' && so_lo!='Tất cả'){
            let t1 = {
                so_lo : so_lo
            }
            filter = {...filter, ...t1}
        }
        if(ma_hang_hoa && ma_hang_hoa!='' && ma_hang_hoa!='Tất cả'){
            let t1 = {
                ma_hang_hoa: ma_hang_hoa
            }
            filter = {...filter, ...t1}
        }

       
            documents = await tonKhoLoHangService.sumSoLuongTonKho(filter);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}


