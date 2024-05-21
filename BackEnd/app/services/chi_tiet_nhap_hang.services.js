// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class ChiTietNhapHangService {
    constructor(client){
        this.collectionChiTietNhapHang = client.db('qlhanghoa').collection("chi_tiet_nhap_hang");
    }
    extractChiTietNhapData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const chi_tiet_nhap_hang = {
             so_lo: payload.so_lo,
             ma_phieu_nhap: payload.ma_phieu_nhap,
             so_luong : payload.so_luong,
             don_gia_nhap: payload.don_gia_nhap, 
        }
        Object.keys(chi_tiet_nhap_hang).forEach((key)=>{
            chi_tiet_nhap_hang[key] === undefined && delete chi_tiet_nhap_hang[key]
        });
        return chi_tiet_nhap_hang;
    }
    
    async create(payload){   
        const chi_tiet_nhap_hang = this.extractChiTietNhapData(payload);
       
        try {
         const ketqua = await this.collectionChiTietNhapHang.insertOne(chi_tiet_nhap_hang);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionChiTietNhapHang.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionChiTietNhapHang.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { so_lo: id }
            ]
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionChiTietNhapHang.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
          
                _id: ObjectId.isValid(id) ? new ObjectId(id) : null ,
            
        };
        console.log("fileder" + filter);
        const update = this.extractChiTietNhapData(payload);
        console.log(update);
        const result = await this.collectionChiTietNhapHang.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionChiTietNhapHang.findOneAndDelete({
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
         
        const cursor =  await this.collectionChiTietNhapHang.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = ChiTietNhapHangService;