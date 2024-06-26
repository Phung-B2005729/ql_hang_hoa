// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class HangHoaService {
    constructor(client){
        this.collectionHangHoa = client.db('qlhanghoa').collection("hang_hoa");
    }
    extractHangHoaData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const hang_hoa = {
             ma_hang_hoa: payload.ma_hang_hoa, // tự động
             ten_hang_hoa: payload.ten_hang_hoa,
             don_gia_ban: payload.don_gia_ban, // giá bán chung tất cả cửa hàng
             gia_von: payload.gia_von,
             mo_ta: payload.mo_ta,
         
             ton_nhieu_nhat: payload.ton_nhieu_nhat,
             don_vi_tinh: payload.don_vi_tinh, // đơn vị tính chung 
             loai_hang: payload.loai_hang,
             thuong_hieu: payload.thuong_hieu,
             hinh_anh: payload.hinh_anh,
           //  danh_sach_anh: payload.danh_sach_anh,
             trang_thai: payload.trang_thai ?? 'Đang kinh doanh',
             quan_ly_theo_lo: payload.quan_ly_theo_lo,
        }
        Object.keys(hang_hoa).forEach((key) => {
            if (hang_hoa[key] === undefined || hang_hoa[key] === null) {
                delete hang_hoa[key];
            } });
        return hang_hoa;
    }
    
    async create(payload){   
        const hang_hoa = this.extractHangHoaData(payload);
        console.log("loaihang " + hang_hoa.ten_hang_hoa);
        try {
         const ketqua = await this.collectionHangHoa.insertOne(hang_hoa);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter, project){ // danh sách loại hàng 
        const cursor = await this.collectionHangHoa.find(filter).project(project);
        return await cursor.toArray();
    }
    async findLookUp(filter, project){ // danh sách loại hàng 
        console.log('gọi');
        console.log(filter);
        const pipeline = [
            /*{
                $lookup: {
                  from: 'ton_kho_lo_hang',
                  localField: "ma_hang_hoa",
                  foreignField: "ma_hang_hoa",
                  as: "ton_kho"
                }
              }, */
              {
                $lookup: {
                  from: 'lo_hang',
                  localField: "ma_hang_hoa",
                  foreignField: "ma_hang_hoa",
                  as: "lo_hang",
                  pipeline: [
                    {
                        $lookup: {
                            from: 'ton_kho_lo_hang',
                            //"$ma_hang_hoa": Định nghĩa biến maHangHoa và gán giá trị của nó là giá trị của trường ma_hang_hoa trong tài liệu hiện tại.
                            //"$so_lo": Định nghĩa biến soLo và gán giá trị của nó là giá trị của trường so_lo trong tài liệu hiện tại.
                            let: { maHangHoa: "$ma_hang_hoa", soLo: "$so_lo" },
                            pipeline: [
                                {
                                    $match: {
                                        $expr: {
                                            $and: [
                                                { $eq: ["$ma_hang_hoa", "$$maHangHoa"] },
                                                { $eq: ["$so_lo", "$$soLo"] }
                                            ]
                                        }
                                    }
                                }
                            ],
                            as: "ton_kho"
                        }
                    }
                  ]
                }
              },
              

            {
                $match: filter
            },
            {
                $sort: {
                    ma_hang_hoa: 1,
                    "ton_kho.ma_cua_hang": 1,
                    "ton_kho.so_luong_ton": 1
                }
            }
          ]
          if(project){
            pipeline.push({
                $project: project
            })
          }
        const cursor = await this.collectionHangHoa.aggregate(pipeline);
        return await cursor.toArray();
    }
    async findOneLookUp(filter, project){ // danh sách loại hàng 
        console.log('gọi');
        console.log(filter);
        const pipeline = [
              {
                $lookup: {
                  from: 'lo_hang',
                  localField: "ma_hang_hoa",
                  foreignField: "ma_hang_hoa",
                  as: "lo_hang",
                  pipeline: [
                    {
                        $lookup: {
                            from: 'ton_kho_lo_hang',
                            //"$ma_hang_hoa": Định nghĩa biến maHangHoa và gán giá trị của nó là giá trị của trường ma_hang_hoa trong tài liệu hiện tại.
                            //"$so_lo": Định nghĩa biến soLo và gán giá trị của nó là giá trị của trường so_lo trong tài liệu hiện tại.
                            let: { maHangHoa: "$ma_hang_hoa", soLo: "$so_lo" },
                            pipeline: [
                                {
                                    $match: {
                                        $expr: {
                                            $and: [
                                                { $eq: ["$ma_hang_hoa", "$$maHangHoa"] },
                                                { $eq: ["$so_lo", "$$soLo"] }
                                            ]
                                        }
                                    }
                                }
                            ],
                            as: "ton_kho"
                        }
                    }
                  ]
                }
              },
              

            {
                $match: filter
            },
            {
                $sort: {
                    ma_hang_hoa: 1,
                    "ton_kho.ma_cua_hang": 1,
                    "ton_kho.so_luong_ton": 1
                }
            }
          ]
          if(project){
            pipeline.push({
                $project: project
            })
          }
        const cursor = await this.collectionHangHoa.aggregate(pipeline);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionHangHoa.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_hang_hoa: id }
            ]
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionHangHoa.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_hang_hoa: id }
            ],
        };
        console.log("fileder" + filter);
        const update = this.extractHangHoaData(payload);
        console.log(update);
        const result = await this.collectionHangHoa.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionHangHoa.findOneAndDelete({
       $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_hang_hoa: id }
            ],
       });
       console.log("resu " +result);
       return result;
    }
    async countDocument(filter1){
        console.log('gọi count');
        const pipeline = [];
      if(filter1){
              pipeline.push(
                  {
                  $match: filter1
              });    
      }
      pipeline.push({
                $count: "countDocument"
            });
         
        const cursor =  await this.collectionHangHoa.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = HangHoaService;