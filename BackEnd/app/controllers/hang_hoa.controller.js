const ApiError = require("../config/api_error");
const HangHoaService = require("../services/hang_hoa.services");
const ChiTietNhapHangService = require("../services/chi_tiet_nhap_hang.services");
const MongoDB = require("../utils/mongodb.util");
const GiaoDichSerivce = require("../services/giao_dich.services");
const LoHangService = require("../services/lo_hang.services");
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
    let documents = [];
    try {
        console.log('gọi');
        let project = {
            ten_hang_hoa: 1,
            ma_hang_hoa: 1,
            don_gia_ban: 1,
            gia_von: 1,
            hinh_anh: 1,
            quan_ly_theo_lo: 1,
           // lo_hang: 1,
            don_vi_tinh: 1,
            'loai_hang': 1,
            'thuong_hieu.ten_thuong_hieu': 1,
           // ton_kho: 1,
           "lo_hang.so_lo": 1,
           "lo_hang.ngay_san_xuat": 1,
           "lo_hang.han_su_dung": 1,
           "lo_hang.trang_thai": 1,
           "lo_hang.ton_kho.ma_cua_hang": 1,
           "lo_hang.ton_kho.so_luong_ton": 1,
           "lo_hang.tong_so_luong": 1
        };
        console.log(project);

        const hangHoaService = new HangHoaService(MongoDB.client);
        let ma_cua_hang = req.query.ma_cua_hang;
        let filter = {};

       /* if (ma_cua_hang && ma_cua_hang !== 'Tất cả') {
            console.log('gọi 2');
          /*  let t1 = {
                ton_kho: {
                    $filter: {
                        input: "$ton_kho",
                        as: "tk",
                        cond: { $eq: ["$$tk.ma_cua_hang", ma_cua_hang] }
                    }
                }
            };
            project = { ...project, ...t1 }; 
            let t2 = {
                "lo_hang.ton_kho.ma_cua_hang": ma_cua_hang
            };
            filter = { ...filter, ...t2 };
            console.log(filter); // Check filter content
        } */

      

        console.log(project); // Check project content
        documents = await hangHoaService.findLookUp(filter, project);
        return res.send(documents);
    } catch (e) {
        return next(new ApiError(500, "Lỗi server trong quá trình lấy danh sách"));
    }
};

exports.findOne =  async (req, res, next) => {  // 
    try{
        const hangHoaService = new HangHoaService(MongoDB.client);
        const document = await hangHoaService.findLookUp({
            ma_hang_hoa: req.params.id
        })
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
         const chiTietNhapHangService = new ChiTietNhapHangService(MongoDB.client);
         const nhapHang =  await chiTietNhapHangService.findOne({
            ma_hang_hoa: req.params.id
         });
         if(nhapHang){
            console.log(nhapHang);
            return next(new ApiError(402, "Hàng hoá đã có dữ liệu phiếu nhập bạn không thể xoá"));
         }
        let document = await hangHoaService.delete(req.params.id);
         if(!document){
             return next(new ApiError(404, "Không tìm thấy mã hàng hoá"));
         }
         const loHangService = new LoHangService(MongoDB.client);
         const giaoDichSerivce = new GiaoDichSerivce(MongoDB.client);
         // xoá các giao dịch, xoá các lô hàng
         document = await loHangService.deleteMany({
            ma_hang_hoa: req.params.id
         });
         document = await giaoDichSerivce.deleteMany({
            ma_hang_hoa: req.params.id
         });

         return res.send({
             message: " deleted succesfully"
         });

     }catch(err){
         return next(new ApiError(500, `Could not delete with id=${req.params.id}`));
     }
 }


