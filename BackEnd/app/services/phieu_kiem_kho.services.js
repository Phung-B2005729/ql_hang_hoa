// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class NhaCungCapService {
    constructor(client){
        this.collectionPhieuNhap = client.db('qlhanghoa').collection("phieu_nhap");
    }
    extractPhieuNhapData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const phieu_nhap = {
            ma_phieu_kiem_kho: payload.ma_phieu_kiem_kho, // tự động
            ngay_kiem_kho: new Date(),
            // forgi
            ma_cua_hang: payload.ma_cua_hang,
            ma_nhan_vien: payload.ma_nhan_vien,
        }
        Object.keys(phieu_nhap).forEach((key)=>{
            phieu_nhap[key] === undefined && delete phieu_nhap[key]
        });
        return phieu_nhap;
    }
    
    async create(payload){   
        const phieu_nhap = this.extractPhieuNhapData(payload);
       
        try {
         const ketqua = await this.collectionPhieuNhap.insertOne(phieu_nhap);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionPhieuNhap.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionPhieuNhap.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_phieu_kiem_kho: id }
            ]
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionPhieuNhap.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_phieu_kiem_kho: id }
            ],
        };
        console.log("fileder" + filter);
        const update = this.extractPhieuNhapData(payload);
        console.log(update);
        const result = await this.collectionPhieuNhap.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionPhieuNhap.findOneAndDelete({
       $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_phieu_kiem_kho: id }
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
         
        const cursor =  await this.collectionPhieuNhap.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = NhaCungCapService;