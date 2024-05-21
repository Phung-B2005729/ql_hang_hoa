// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class CuaHangService {
    constructor(client){
        this.collectionCuaHang = client.db('qlhanghoa').collection("cua_hang");
    }
    extractCuaHangData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const cua_hang = {
            ma_cua_hang: payload.ma_cua_hang,
            ten_cua_hang: payload.ten_cua_hang,
            dia_chi : payload.dia_chi,
            loai_cua_hang: payload.loai_cua_hang ?? "Chi nhánh",
            sdt: payload.sdt
        }
        Object.keys(cua_hang).forEach((key)=>{
            cua_hang[key] === undefined && delete cua_hang[key]
        });
        return cua_hang;
    }
    
    async create(payload){   
        const cua_hang = this.extractCuaHangData(payload);
        console.log("loaihang " + cua_hang.ten_cua_hang);
        try {
         const ketqua = await this.collectionCuaHang.insertOne(cua_hang);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionCuaHang.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionCuaHang.findOne({
            $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_cua_hang: id }
            ]
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionCuaHang.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
            $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_cua_hang: id }
            ]
        };
        console.log("fileder" + filter);
        const update = this.extractCuaHangData(payload);
        console.log(update);
        const result = await this.collectionCuaHang.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionCuaHang.findOneAndDelete({ 
        $or: [
        { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
        { ma_cua_hang: id }
    ]
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
         
        const cursor =  await this.collectionCuaHang.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = CuaHangService;