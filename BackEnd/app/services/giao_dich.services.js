// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class GiaoDichService {
    constructor(client){
        this.collectionGiaoDich = client.db('qlhanghoa').collection("giao_dich");
    }
    extractGiaoDichData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const giao_dich = {
        //     ma_giao_dich: payload.ma_giao_dich, // dùng object ID
             thoi_gian_giao_dich: payload.thoi_gian_giao_dich ?? new Date(), 
             loai_giao_dich: payload.loai_giao_dich,
             so_luong_giao_dich: payload.so_luong_giao_dich,  // + thêm vào, - bán ra/phân phối ra
             so_luong_ton: payload.so_luong_ton,  // số lượng trong kho khi giao dịch xảy ra
             gia_von: payload.gia_von, // giá vốn hiện tại
             // fogin
             so_lo: payload.so_lo, // lô hàng giao dịch
             ma_hang_hoa: payload.ma_hang_hoa,
             ma_cua_hang: payload.ma_cua_hang,  // giao dịch tại cửa hàng
             ma_nhan_vien: payload.ma_nhan_vien, // nhân viên cập nhật thay đổi (nếu có)
             ma_phieu_nhap: payload.ma_phieu_nhap, // thông tin nhập hàng (nếu loại giao dịch là nhập)
             ma_phieu_kiem_kho: payload.ma_phieu_kiem_kho, // thông tin nhập hàng (nếu loại giao dịch là nhập)
             ma_hoa_don: payload.ma_hoa_don, // thông tin hoá đơn (nếu loại giao dịch là bán ra/xuất phân phối)
        }
        Object.keys(giao_dich).forEach((key)=>{
            giao_dich[key] === undefined && delete giao_dich[key]
        });
        return giao_dich;
    }
    
    async create(payload){   
        const giao_dich = this.extractGiaoDichData(payload);
      
        try {
         const ketqua = await this.collectionGiaoDich.insertOne(giao_dich);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionGiaoDich.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionGiaoDich.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { so_lo: id }
            ]
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionGiaoDich.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
           _id: ObjectId.isValid(id) ? new ObjectId(id) : null 
        };
        console.log("fileder" + filter);
        const update = this.extractGiaoDichData(payload);
        console.log(update);
        const result = await this.collectionGiaoDich.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionGiaoDich.findOneAndDelete({
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
         
        const cursor =  await this.collectionGiaoDich.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = GiaoDichService;