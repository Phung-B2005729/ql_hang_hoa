// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class TonKhoLoHangService {
    constructor(client){
        this.collectionTonKhoLoHangHang = client.db('qlhanghoa').collection("ton_kho_lo_hang");
    }
    extractTonKhoLoHangData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const ton_kho_lo_hang = {
             so_lo: payload. so_lo,
             ma_cua_hang: payload.ma_cua_hang,
             so_luong_ton : payload.so_luong_ton,
        }
        Object.keys(ton_kho_lo_hang).forEach((key)=>{
            ton_kho_lo_hang[key] === undefined && delete ton_kho_lo_hang[key]
        });
        return ton_kho_lo_hang;
    }
    
    async create(payload){   
        const ton_kho_lo_hang = this.extractTonKhoLoHangData(payload);
       
        try {
         const ketqua = await this.collectionTonKhoLoHangHang.insertOne(ton_kho_lo_hang);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionTonKhoLoHangHang.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionTonKhoLoHangHang.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { so_lo: id },
                {ma_cua_hang: id}

            ]
        });
    }
    
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionTonKhoLoHangHang.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
                _id: ObjectId.isValid(id) ? new ObjectId(id) : null,
        };
        console.log("fileder" + filter);
        const update = this.extractTonKhoLoHangData(payload);
        console.log(update);
        const result = await this.collectionTonKhoLoHangHang.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async updateLoHangCuaHang(so_lo, ma_cua_hang, payload){
        console.log(id);
        const filter = {
            so_lo: so_lo,
            ma_cua_hang: ma_cua_hang
        };
        console.log("fileder" + filter);
        const update = this.extractTonKhoLoHangData(payload);
        console.log(update);
        const result = await this.collectionTonKhoLoHangHang.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionTonKhoLoHangHang.findOneAndDelete({
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
         
        const cursor =  await this.collectionTonKhoLoHangHang.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = TonKhoLoHangService;