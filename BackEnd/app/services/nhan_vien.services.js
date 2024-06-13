// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class NhanVienService {
    constructor(client){
        this.collectionNhanVien = client.db('qlhanghoa').collection("nhan_vien");
    }
    extractNhanVienData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const nhan_vien = {
             ma_nhan_vien: payload.ma_nhan_vien, // tự động
             ten_nhan_vien: payload.ten_nhan_vien,
             dia_chi: payload.dia_chi,
             sdt: payload.sdt,
             email: payload.email,
             stk: payload.stk,
             gioi_tinh: payload.gioi_tinh,
             chuc_vu: payload.chuc_vu,
             trang_thai: payload.trang_thai,
             tai_khoan: payload.tai_khoan, // object tài khoản
             ma_cua_hang: payload.ma_cua_hang
        }
        Object.keys(nhan_vien).forEach((key)=>{
            nhan_vien[key] === undefined && delete nhan_vien[key]
        });
        return nhan_vien;
    }
    
    async create(payload){   
        const nhan_vien = this.extractNhanVienData(payload);
        console.log("loaihang " + nhan_vien.ten_nhan_vien);
        try {
         const ketqua = await this.collectionNhanVien.insertOne(nhan_vien);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionNhanVien.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionNhanVien.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_nhan_vien: id }
            ]
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionNhanVien.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_nhan_vien: id }
            ],
        };
        console.log("fileder" + filter);
        const update = this.extractNhanVienData(payload);
        console.log(update);
        const result = await this.collectionNhanVien.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionNhanVien.findOneAndDelete({
       $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_nhan_vien: id }
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
         
        const cursor =  await this.collectionNhanVien.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = NhanVienService;