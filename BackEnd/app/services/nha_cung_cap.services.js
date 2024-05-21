// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class NhaCungCapService {
    constructor(client){
        this.collectionNhaCungCap = client.db('qlhanghoa').collection("nha_cung_cap");
    }
    extractNhaCungCapData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const nha_cung_cap = {
             ma_nha_cung_cap: payload.ma_nha_cung_cap, // tự động
             ten_nha_cung_cap: payload.ten_nha_cung_cap,
            dia_chi: payload.dia_chi,
            sdt: payload.sdt,
         
        }
        Object.keys(nha_cung_cap).forEach((key)=>{
            nha_cung_cap[key] === undefined && delete nha_cung_cap[key]
        });
        return nha_cung_cap;
    }
    
    async create(payload){   
        const nha_cung_cap = this.extractNhaCungCapData(payload);
        console.log("loaihang " + nha_cung_cap.ten_nha_cung_cap);
        try {
         const ketqua = await this.collectionNhaCungCap.insertOne(nha_cung_cap);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionNhaCungCap.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionNhaCungCap.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_nha_cung_cap: id }
            ]
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionNhaCungCap.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_nha_cung_cap: id }
            ],
        };
        console.log("fileder" + filter);
        const update = this.extractNhaCungCapData(payload);
        console.log(update);
        const result = await this.collectionNhaCungCap.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionNhaCungCap.findOneAndDelete({
       $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_nha_cung_cap: id }
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
         
        const cursor =  await this.collectionNhaCungCap.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = NhaCungCapService;