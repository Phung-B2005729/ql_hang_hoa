// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class ThuongHieuService {
    constructor(client){
        this.collectionThuongHieu = client.db('qlhanghoa').collection("thuong_hieu");
    }
    extractThuongHieuData(payload){
        // lay du lieu doi tuong thuong_hieu va loai bo cac thuoc tinh undefined
        const thuong_hieu = {
            ten_thuong_hieu: payload.ten_thuong_hieu
        }
        Object.keys(thuong_hieu).forEach((key)=>{
            thuong_hieu[key] === undefined && delete thuong_hieu[key]
        });
        return thuong_hieu;
    }
    
    async create(payload){   
        const thuong_hieu = this.extractThuongHieuData(payload);
        console.log("thuong_hieu " + thuong_hieu.tenloai);
        try {
         const ketqua = await this.collectionThuongHieu.insertOne(thuong_hieu);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionThuongHieu.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionThuongHieu.findOne({
            _id: ObjectId.isValid(id) ? new ObjectId(id): null
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionThuongHieu.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
            _id: ObjectId.isValid(id) ? new ObjectId(id): null,
        };
        console.log("fileder" + filter);
        const update = this.extractThuongHieuData(payload);
        console.log(update);
        const result = await this.collectionThuongHieu.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionThuongHieu.findOneAndDelete({
        _id: ObjectId.isValid(id) ? new ObjectId(id): null,
       });
       console.log("resu " +result);
       return result;
    }
}
module.exports = ThuongHieuService;