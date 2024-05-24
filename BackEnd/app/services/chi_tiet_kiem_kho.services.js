// KiemKho them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class ChiTietKiemKhoService {
    constructor(client){
        this.collectionChiTietKiemKho = client.db('qlhanghoa').collection("chi_tiet_kiem_kho");
    }
    extractChiTietKiemKhoData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const chi_tiet_kiem_kho = {
             so_lo: payload.so_lo,
             ma_phieu_kiem_kho: payload.ma_phieu_kiem_kho,
             so_luong_thuc_te : payload.so_luong_thuc_te,
             so_luong_ton_kho: payload.so_luong_ton_kho, 
        }
        Object.keys(chi_tiet_kiem_kho).forEach((key)=>{
            chi_tiet_kiem_kho[key] === undefined && delete chi_tiet_kiem_kho[key]
        });
        return chi_tiet_kiem_kho;
    }
    
    async create(payload){   
        const chi_tiet_kiem_kho = this.extractChiTietKiemKhoData(payload);
       
        try {
         const ketqua = await this.collectionChiTietKiemKho.insertOne(chi_tiet_kiem_kho);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionChiTietKiemKho.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionChiTietKiemKho.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { so_lo: id }
            ]
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionChiTietKiemKho.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
          
                _id: ObjectId.isValid(id) ? new ObjectId(id) : null ,
            
        };
        console.log("fileder" + filter);
        const update = this.extractChiTietKiemKhoData(payload);
        console.log(update);
        const result = await this.collectionChiTietKiemKho.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionChiTietKiemKho.findOneAndDelete({
       _id: ObjectId.isValid(id) ? new ObjectId(id) : null 
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
         
        const cursor =  await this.collectionChiTietKiemKho.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = ChiTietKiemKhoService;