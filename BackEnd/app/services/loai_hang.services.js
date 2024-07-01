// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class LoaiHangService {
    constructor(client){
        this.collectionLoaiHang = client.db('qlhanghoa').collection("loai_hang");
    }
    extractLoaiHangData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const loai_hang = {
            ten_loai: payload.ten_loai
        }
       Object.keys(loai_hang).forEach((key) => {
        if (loai_hang[key] === undefined || loai_hang[key] === null) {
            delete loai_hang[key];
        } });
        return loai_hang;
    }
    
    async create(payload){   
        const loai_hang = this.extractLoaiHangData(payload);
        console.log("loaihang " + loai_hang.ten_loai);
        try {
         const ketqua = await this.collectionLoaiHang.insertOne(loai_hang);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionLoaiHang.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionLoaiHang.findOne({
            _id: ObjectId.isValid(id) ? new ObjectId(id): null
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionLoaiHang.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
            _id: ObjectId.isValid(id) ? new ObjectId(id): null,
        };
        console.log("fileder" + filter);
        const update = this.extractLoaiHangData(payload);
        console.log(update);
        const result = await this.collectionLoaiHang.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionLoaiHang.findOneAndDelete({
        _id: ObjectId.isValid(id) ? new ObjectId(id): null,
       });
       console.log("resu " +result);
       return result;
    }
}
module.exports = LoaiHangService;