const ApiError = require("../config/api_error");
const PhieuNhapService = require("../services/phieu_nhap.services");
const ChiTietPhieuNhapService = require("../services/chi_tiet_nhap_hang.services");
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
            let ma_phieu_nhap = "PN000001";
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
                    ma_phieu_nhap = "PN" + sl;
                    console.log('Lặp ' + ma_phieu_nhap);
                    // kiểm tra sự tồn tại
                   exitsPhieuNhap3 = await phieuNhapService.findOne({ma_phieu_nhap: ma_phieu_nhap});
                  }   
                
            }
            console.log("ma_nhap" + ma_phieu_nhap);
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
       
        let ma_cua_hang = req.query.ma_cua_hang;
        let ma_nhan_vien = req.query.ma_nhan_vien;
        let thong_tin_nha_cung_cap = req.query.thong_tin_nha_cung_cap;
        const ngay_bat_dau = req.query.ngay_bat_dau;
        const ngay_ket_thuc = req.query.ngay_ket_thuc;
        let thong_tin_hang_hoa = req.query.thong_tin_hang_hoa;
        let thong_tin_lo_hang = req.query.thong_tin_lo_hang;
        let trang_thai = req.query.trang_thai;
        let thong_tin_phieu_nhap = req.query.thong_tin_phieu_nhap;

        let filter = {};
        if(ngay_bat_dau && ngay_ket_thuc && ngay_bat_dau!='' && ngay_ket_thuc!=''){
            console.log(new Date(ngay_bat_dau))
            console.log(new Date(ngay_ket_thuc))
         let t1 = { ngay_lap_phieu: {
            $gte: new Date(ngay_bat_dau),
            $lte: new Date(ngay_ket_thuc)
          }
        }
        filter = {...filter, ...t1}
        }
       
         if(ma_cua_hang && ma_cua_hang!='Tất cả' && ma_cua_hang!=''){
           
            let t1 = {
               ma_cua_hang: ma_cua_hang
            }
            filter = {...filter, ...t1}
        }
        if(ma_nhan_vien && ma_nhan_vien!='Tất cả' && ma_nhan_vien!=''){
           
            let t1 = {
               ma_nhan_vien: ma_nhan_vien
            }
            filter = {...filter, ...t1}
        }
        if(trang_thai && trang_thai!='Tất cả' && trang_thai!=''){
           
            let t1 = {
               trang_thai: trang_thai
            }
            filter = {...filter, ...t1}
        }

        if(thong_tin_nha_cung_cap && thong_tin_nha_cung_cap!='Tất cả' && thong_tin_nha_cung_cap!=''){
            console.log('vào ncc');
            console.log(thong_tin_nha_cung_cap);
            thong_tin_nha_cung_cap = helper.escapeStringRegexp(thong_tin_nha_cung_cap);
            let t1 = {
                $or: [
                    {
                        'chi_tiet_phieu_nhap_info.nha_cung_cap_info.ten_nha_cung_cap' : {
                $regex: new RegExp(thong_tin_nha_cung_cap), $options: "i"
                    }
                },
               
                {
                    ma_nha_cung_cap : {
                        $regex: new RegExp(thong_tin_nha_cung_cap), $options: "i"
                            }
                }
            ]
            }
           
            if (Object.keys(filter).length > 0) {
                filter = {
                    $and: [
                        filter,
                        t1
                    ]
                };
            } else {
                filter = t1;
            }
        }
       
        if(thong_tin_hang_hoa && thong_tin_hang_hoa!=''){
            console.log('vào hàng');
            thong_tin_hang_hoa = helper.escapeStringRegexp(thong_tin_hang_hoa);
            console.log(thong_tin_hang_hoa);
        let t1 = {
                $or: [
                  { 'chi_tiet_phieu_nhap_info.hang_hoa_info.ten_hang_hoa': { $regex: new RegExp(thong_tin_hang_hoa, "i") } },
                  { 'chi_tiet_phieu_nhap_info.ma_hang_hoa': { $regex: new RegExp(thong_tin_hang_hoa, "i") } },
                  { 'chi_tiet_phieu_nhap_info.so_lo': { $regex: new RegExp(thong_tin_hang_hoa, "i") } }
                ]
            
            
              
        }
      
        if (Object.keys(filter).length > 0) {
            filter = {
                $and: [
                    filter,
                    t1
                ]
            };
        } else {
            filter = t1;
        }
    }
    console.log('thông tin lô ' + thong_tin_lo_hang);
   /* if(thong_tin_lo_hang!=null && thong_tin_lo_hang!=''){
        console.log('vào lô');
        thong_tin_lo_hang = helper.escapeStringRegexp(thong_tin_lo_hang);
    let t1 = {
        $or: [
            {
                'chi_tiet_phieu_nhap_info.han_su_dung' : {
        $regex: new RegExp(thong_tin_lo_hang), $options: "i"
            }
        },
        {
            'chi_tiet_phieu_nhap_info.so_lo' : {
                $regex: new RegExp(thong_tin_lo_hang), $options: "i"
                    }
        },
         ]
    }
     if (Object.keys(filter).length > 0) {
                filter = {
                    $and: [
                        filter,
                        t1
                    ]
                };
            } else {
                filter = t1;
            }
} */
if(thong_tin_phieu_nhap && thong_tin_phieu_nhap!=''){
        thong_tin_phieu_nhap = helper.escapeStringRegexp(thong_tin_phieu_nhap);
        let t1 = {
            ma_phieu_nhap: {
                $regex: new RegExp(thong_tin_phieu_nhap), $options: "i"
            }
        }
        filter = {...filter, ...t1}
    } 
    console.log(filter);
        let pro = {
            ma_phieu_nhap: 1, // tự động
            ngay_lap_phieu: 1,
            tong_tien: 1,
            trang_thai: 1,
            // forgi
            ma_nha_cung_cap: 1,
            ma_cua_hang: 1,
            ma_nhan_vien: 1,
            'nha_cung_cap_info.ten_nha_cung_cap': 1,
           // 'chi_tiet_phieu_nhap_info.ma_hang_hoa': 1,
            'chi_tiet_phieu_nhap_info.so_luong': 1,
           // 'chi_tiet_phieu_nhap_info.so_lo': 1,
            'chi_tiet_phieu_nhap_info.han_su_dung': 1,
            'chi_tiet_phieu_nhap_info.hang_hoa_info.ten_hang_hoa': 1
        }
            documents = await phieuNhapService.findLooUp(filter, pro, false);
            return res.send(documents);
    }catch(e){
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    } 
}

exports.findOne =  async (req, res, next) => {  // 
    try{
        const phieuNhapService = new PhieuNhapService(MongoDB.client);
        let pro = {
            ma_phieu_nhap: 1, // tự động
            ngay_lap_phieu: 1,
            tong_tien: 1,
            trang_thai: 1,
            gia_giam: 1,
           
            // forgi
            ma_nha_cung_cap: 1,
            ma_cua_hang: 1,
            ma_nhan_vien: 1,
            'nhan_vien_info.ten_nhan_vien': 1,
            'cua_hang_info.ten_cua_hang': 1,
            'nha_cung_cap_info.ten_nha_cung_cap': 1,
            'chi_tiet_phieu_nhap_info.ma_hang_hoa': 1,
            'chi_tiet_phieu_nhap_info.so_lo': 1,
            'chi_tiet_phieu_nhap_info.so_luong': 1,
            'chi_tiet_phieu_nhap_info.don_gia_nhap': 1,
            'chi_tiet_phieu_nhap_info.han_su_dung': 1,
            'chi_tiet_phieu_nhap_info.hang_hoa_info.ten_hang_hoa': 1,
            'chi_tiet_phieu_nhap_info.hang_hoa_info.don_vi_tinh': 1
        }
        const document = await phieuNhapService.findLooUp({
            ma_phieu_nhap:
            req.params.id}, pro, true);
           
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
         const phieu = await phieuNhapService.findById(req.params.id);
         if(phieu && phieu.trang_thai!='Phiếu tạm'){
            return next(new ApiError(402, "Bạn chỉ có thể xoá những phiếu tạm"));
         }
         const document = await phieuNhapService.delete(req.params.id);
         if(!document){
             return next(new ApiError(404, "not found"));
         }
         const chiTietPhieuNhapService = new ChiTietPhieuNhapService(MongoDB.client);
         const document2 = chiTietPhieuNhapService.deleteMany({
            ma_phieu_nhap: req.params.id
         })
         return res.send({
             message: " deleted succesfully"
         });
     }catch(err){
         return next(new ApiError(500, `Could not delete with id=${req.params.id}`));
     }
 }


