const ApiError = require("../config/api_error");
const NhanVienService = require("../services/nhan_vien.services");
const MongoDB = require("../utils/mongodb.util");
const helper = require("../helper/index");
const { sdtSchema, emailSchema } = require("../validation/index");
const PhieuNhapService = require("../services/phieu_nhap.services");


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
            
            return res.send(req.body.ma_nhan_vien);
        }catch(e){
            return next(new ApiError(500, "Lỗi server trong quá trình thêm"));
        }
    }
}
exports.findALL = async (req, res, next) => {
    let documents = [];
    try {
        const nhanVienService = new NhanVienService(MongoDB.client);
        let thong_tin_chung = req.query.thong_tin_chung;
        let ma_cua_hang = req.query.ma_cua_hang;
        let chuc_vu = req.query.chuc_vu;
        let chua_tai_khoan = req.query.chua_tai_khoan; // =1 thì mới tìm kiếm
        let co_tai_khoan = req.query.co_tai_khoan; 
       // let tai_khoan = req.query.tai_khoan; // có tài khoản = 0; = 1
        let trang_thai = req.query.trang_thai; // giá trị của trang_thai là 1 list
        let filter = {};

        if (thong_tin_chung && thong_tin_chung !== '' && thong_tin_chung !== 'null') {
            thong_tin_chung = helper.escapeStringRegexp(thong_tin_chung);
            let t1 = {
                $or: [
                    {
                        ten_nhan_vien: {
                            $regex: new RegExp(thong_tin_chung), $options: "i"
                        }
                    },
                    {
                        sdt: {
                            $regex: new RegExp(thong_tin_chung), $options: "i"
                        }
                    },
                    {
                        ma_nhan_vien: {
                            $regex: new RegExp(thong_tin_chung), $options: "i"
                        }
                    },
                    {
                        dia_chi: {
                            $regex: new RegExp(thong_tin_chung), $options: "i"
                        }
                    }
                ]
            };
            filter = { ...filter, ...t1 };
        }

        if (trang_thai && Array.isArray(trang_thai) && trang_thai.length > 0) {
            filter.trang_thai = { $in: trang_thai };
        }

        if (ma_cua_hang && ma_cua_hang !== '' && ma_cua_hang !== 'null' && ma_cua_hang!='Tất cả') {
            filter.ma_cua_hang = ma_cua_hang;
        }

        if (chuc_vu && Array.isArray(chuc_vu) && chuc_vu.length > 0) {
            filter.chuc_vu = { $in: chuc_vu };
        }

        if (co_tai_khoan=='1' && chua_tai_khoan!='1') {
            filter.tai_khoan = { $exists: true };
        }
        if(chua_tai_khoan=='1' && co_tai_khoan!='1'){
            t1 = {
                $or: [
                    {tai_khoan: { $exists: false } },
                    {'tai_khoan.user_name': { $exists: false }}
                ]
            }
            filter = {...filter, ...t1}
         /*   filter.tai_khoan = {
                $or: [
                    { $exists: false },
                    { $eq: null }
                ]}; */
        }

        let pro = {
            ma_nhan_vien: 1, // tự động
            ten_nhan_vien: 1,
            dia_chi: 1,
            sdt: 1,
            email: 1,
            stk: 1,
            gioi_tinh: 1,
            chuc_vu: 1,
            trang_thai: 1,
            ghi_chu: 1,
            tai_khoan: 1, // object tài khoản
            ma_cua_hang: 1,
            'cua_hang_info.ten_cua_hang': 1
        };
        documents = await nhanVienService.findLookUp(filter, pro);
        return res.send(documents);
    } catch (e) {
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    }
};

exports.findOne =  async (req, res, next) => {  // 
    try{
        const nhanVienService = new NhanVienService(MongoDB.client);
       
       
        let pro = {
            ma_nhan_vien: 1, // tự động
            ten_nhan_vien: 1,
            dia_chi: 1,
            sdt: 1,
            email: 1,
            stk: 1,
            gioi_tinh: 1,
            ghi_chu: 1,
            chuc_vu: 1,
            trang_thai: 1,
            tai_khoan: 1, // object tài khoản
            ma_cua_hang: 1,
            'cua_hang_info.ten_cua_hang' : 1
         }
          let  document = await nhanVienService.findLookUp({
                ma_nhan_vien: req.params.id
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
     const nhanVienService = new NhanVienService(MongoDB.client);
    console.log('gọi update');
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
         const phieuNhapService = new PhieuNhapService(MongoDB.client);
         const phieNhap = await phieuNhapService.findOne({
            ma_nhan_vien: req.params.id
         });
         if(phieNhap!=null){
            //console.log(phieNhap);
            return next(new ApiError(401, "Nhân viên đã có dữ liệu phiếu nhập không thể xoá"));
         }
         const document = await nhanVienService.delete(req.params.id);
        
         return res.send({
             message: " deleted succesfully"
         });
     }catch(err){
         return next(new ApiError(500, `Could not delete with id=${req.params.id}`));
     }
 }


