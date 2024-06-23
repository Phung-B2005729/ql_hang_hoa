// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class LoHangService {
    constructor(client){
        this.collectionLoHang = client.db('qlhanghoa').collection("lo_hang");
    }
    extractLoHangData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const lo_hang = {
             so_lo: payload.so_lo, 
             ma_hang_hoa: payload.ma_hang_hoa,
             ngay_san_xuat: payload.ngay_san_xuat, // không theo lô thì không có ngày sản xuất và hạn sử dụng
             han_su_dung: payload.han_su_dung,  
             ngay_tao: payload.ngay_tao ?? new Date(), 
             tong_so_luong: payload.tong_so_luong,
             trang_thai: payload.trang_thai // 'còn hàng','đã trả hàng'
        }
        Object.keys(lo_hang).forEach((key)=>{
            lo_hang[key] === undefined && delete lo_hang[key]
        });
        return lo_hang;
    }
    
    async create(payload){   
        const lo_hang = this.extractLoHangData(payload);
       
        try {
         const ketqua = await this.collectionLoHang.insertOne(lo_hang);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async sumTongSoLuong(filter){ // danh sách loại hàng 
        const pipeline = [
            {
              $match: {
                filter
              }
            },
             {
                  "$group": {
                      "_id": null,
                      "so_luong": {
                          "$sum": "$tong_so_luong"
                      }
                  }
              }
          ]
          
        const cursor = await this.collectionLoHang.aggregate(pipeline);
        return await cursor.toArray();
    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionLoHang.find(filter);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionLoHang.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { so_lo: id }
            ]
        });
    }
    async findLookUp(filter, project){ // danh sách loại hàng 
        console.log('gọi');
        console.log(filter);
        const pipeline = [
            {
                $lookup: {
                    from: 'ton_kho_lo_hang',
                    //"$ma_hang_hoa": Định nghĩa biến maHangHoa và gán giá trị của nó là giá trị của trường ma_hang_hoa trong tài liệu hiện tại.
                    //"$so_lo": Định nghĩa biến soLo và gán giá trị của nó là giá trị của trường so_lo trong tài liệu hiện tại.
                    let: { maHangHoa: "$ma_hang_hoa", soLo: "$so_lo" },
                    pipeline: [
                        {
                            $match: {
                                $expr: {
                                    $and: [
                                        { $eq: ["$ma_hang_hoa", "$$maHangHoa"] },
                                        { $eq: ["$so_lo", "$$soLo"] }
                                    ]
                                }
                            }
                        }
                    ],
                    as: "ton_kho"
                }
            },
            {
                $match: filter
            },
            {
                $sort: {
                    ma_hang_hoa: 1,
                    lo_hang: 1
                }
            }
          ]
          if(project){
            pipeline.push({
                $project: project
            })
          }
        const cursor = await this.collectionLoHang.aggregate(pipeline);
        return await cursor.toArray();
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionLoHang.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { so_lo: id }
            ],
        };
        console.log("fileder" + filter);
        const update = this.extractLoHangData(payload);
        console.log(update);
        const result = await this.collectionLoHang.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionLoHang.findOneAndDelete({
       $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
            ],
       });
       console.log("resu " +result);
       return result;
    }
    async deleteMany(filter) {
        console.log('Calling deleteMany with filter: ', filter);
        try {
            const result = await this.collectionLoHang.deleteMany(filter);
            console.log('Delete result: ', result);
            return result;
        } catch (error) {
            console.error('Error in deleteMany: ', error);
            throw error;
        }
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
         
        const cursor =  await this.collectionLoHang.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = LoHangService;