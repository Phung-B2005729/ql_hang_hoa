// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class HinhAnhService {
    constructor(client){
        this.collectionHinhAnh = client.db('qlhanghoa').collection("hinh_anh");
    }
    extractHinhAnhData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const hinh_anh = {
             ten_hinh_anh: payload.ten_hinh_anh,
             link_anh: payload.link_anh,
             ma_hang_hoa: payload.ma_hang_hoa, 
        }
        Object.keys(hinh_anh).forEach((key)=>{
            hinh_anh[key] === undefined && delete hinh_anh[key]
        });
        return hinh_anh;
    }
    
    async create(payload){   
        const hinh_anh = this.extractHinhAnhData(payload);
        console.log("loaihang " + hinh_anh.ten_hinh_anh);
        try {
         const ketqua = await this.collectionHinhAnh.insertOne(hinh_anh);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionHinhAnh.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionHinhAnh.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_hinh_anh: id }
            ]
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionHinhAnh.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_hinh_anh: id }
            ],
        };
        console.log("fileder" + filter);
        const update = this.extractHinhAnhData(payload);
        console.log(update);
        const result = await this.collectionHinhAnh.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionHinhAnh.findOneAndDelete({
       $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_hinh_anh: id }
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
         
        const cursor =  await this.collectionHinhAnh.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = HinhAnhService;