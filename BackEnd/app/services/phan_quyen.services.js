// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class PhanQuyenService {
    constructor(client){
        this.collectionPhanQuyen = client.db('qlhanghoa').collection("phan_quyen");
    }
    extractPhanQuyenData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const phan_quyen = {
            ten_quyen: payload.ten_quyen
        }
        Object.keys(phan_quyen).forEach((key)=>{
            phan_quyen[key] === undefined && delete phan_quyen[key]
        });
        return phan_quyen;
    }
    
    async create(payload){   
        const phan_quyen = this.extractPhanQuyenData(payload);
        console.log("loaihang " + phan_quyen.ten_quyen);
        try {
         const ketqua = await this.collectionPhanQuyen.insertOne(phan_quyen);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionPhanQuyen.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionPhanQuyen.findOne({
            _id: ObjectId.isValid(id) ? new ObjectId(id): null
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionPhanQuyen.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
            _id: ObjectId.isValid(id) ? new ObjectId(id): null,
        };
        console.log("fileder" + filter);
        const update = this.extractPhanQuyenData(payload);
        console.log(update);
        const result = await this.collectionPhanQuyen.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionPhanQuyen.findOneAndDelete({
        _id: ObjectId.isValid(id) ? new ObjectId(id): null,
       });
       console.log("resu " +result);
       return result;
    }
}
module.exports = PhanQuyenService;