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
             so_lo: payload.so_lo,
             han_su_dung: payload.han_su_dung,
             ma_cua_hang: payload.ma_cua_hang,
             so_luong_ton : payload.so_luong_ton,
             ma_hang_hoa: payload.ma_hang_hoa,
        }
         Object.keys(ton_kho_lo_hang).forEach((key) => {
            if (ton_kho_lo_hang[key] === undefined || ton_kho_lo_hang[key] === null) {
                delete ton_kho_lo_hang[key];
            }   });
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
    async sumSoLuongTonKho(filter){ // danh sách loại hàng 
        const pipeline = [
            {
              $match: filter
            },
             {
                  "$group": {
                      "_id": null,
                      "so_luong": {
                          "$sum": "$so_luong_ton"
                      }
                  }
              }
          ]
          
        const cursor = await this.collectionTonKhoLoHangHang.aggregate(pipeline);
        return await cursor.toArray();
    }
    async findLookup(filter,pro){ // danh sách loại hàng 
        const pipeline = [
            {
                $lookup: {
                  from: 'hang_hoa',
                  localField: "ma_hang_hoa",
                  foreignField: "ma_hang_hoa",
                  as: "hang_hoa_info"
                }
              },
            {
              $match: filter
            },
          ]
          if(pro){
            pipeline.push({
                $project: pro
            });
          }
          pipeline.push({
            $sort: {han_su_dung: 1,so_luong_ton: -1 , ma_hang_hoa: 1, 
            }
          })
          
        const cursor = await this.collectionTonKhoLoHangHang.aggregate(pipeline);
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
    async updateFilter(filter1, payload){
       // console.log(id);
        const filter = filter1;
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