// nhap them sua xoa
// truy xuat id 
const { ObjectId } = require("mongodb");
class NhaCungCapService {
    constructor(client){
        this.collectionPhieuNhap = client.db('qlhanghoa').collection("phieu_nhap");
    }
    extractPhieuNhapData(payload){
        // lay du lieu doi tuong loaihang va loai bo cac thuoc tinh undefined
        const phieu_nhap = {
            ma_phieu_nhap: payload.ma_phieu_nhap, // tự động
            ngay_lap_phieu: new Date(),
            gia_giam: payload.gia_giam,
            tong_tien: payload.tong_tien,
            trang_thai: payload.trang_thai,
            // forgi
            ma_nha_cung_cap: payload.ma_nha_cung_cap,
            ma_cua_hang: payload.ma_cua_hang,
            ma_nhan_vien: payload.ma_nhan_vien,
        }
        Object.keys(phieu_nhap).forEach((key)=>{
            phieu_nhap[key] === undefined && delete phieu_nhap[key]
        });
        return phieu_nhap;
    }
    
    async create(payload){   
        const phieu_nhap = this.extractPhieuNhapData(payload);
       
        try {
         const ketqua = await this.collectionPhieuNhap.insertOne(phieu_nhap);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }

    }
    async find(filter){ // danh sách loại hàng 
        const cursor = await this.collectionPhieuNhap.find(filter);
        return await cursor.toArray();
    }
    async findLooUp(filter, project, findOne){ // danh sách loại hàng 
        const pipeline = [
            {
                $lookup: {
                  from: 'nha_cung_cap',
                  localField: "ma_nha_cung_cap",
                  foreignField: "ma_nha_cung_cap",
                  as: "nha_cung_cap_info"
                }
              },
             
              {
                $lookup: {
                  from: 'chi_tiet_nhap_hang',
                  localField: "ma_phieu_nhap",
                  foreignField: "ma_phieu_nhap",
                  as: "chi_tiet_phieu_nhap_info",
                  pipeline: [
                    {
                        $lookup: {
                            from: 'hang_hoa',
                            //"$ma_hang_hoa": Định nghĩa biến maHangHoa và gán giá trị của nó là giá trị của trường ma_hang_hoa trong tài liệu hiện tại.
                            //"$so_lo": Định nghĩa biến soLo và gán giá trị của nó là giá trị của trường so_lo trong tài liệu hiện tại.
                            let: { maHangHoa: "$ma_hang_hoa"},
                            pipeline: [
                                {
                                    $match: {
                                        $expr: {
                                            $and: [
                                                { $eq: ["$ma_hang_hoa", "$$maHangHoa"] },
                                            ]
                                        }
                                    }
                                }
                            ],
                            as: "hang_hoa_info"
                        }
                    },
                  ]
                }
              },
              
        ]
        if(findOne==true){
            pipeline.push({
                $lookup: {
                    from: 'nhan_vien',
                    localField: "ma_nhan_vien",
                    foreignField: "ma_nhan_vien",
                    as: "nhan_vien_info"
                  }
            })
            pipeline.push({
                $lookup: {
                    from: 'cua_hang',
                    localField: "ma_cua_hang",
                    foreignField: "ma_cua_hang",
                    as: "cua_hang_info"
                  }
            })
        }
        if(filter){
            pipeline.push({
                $match: filter
            })
        }
        if(project){
            pipeline.push({
                $project: project
            })
        }
        pipeline.push({
            $sort: {ngay_lap_phieu: -1, ma_phieu_nhap: 1}
        })
        const cursor = await this.collectionPhieuNhap.aggregate(pipeline);
        return await cursor.toArray();
    }
    async findById(id){ // tên loại hàng theo id 
        console.log("goi ham findById " +id);
        return await this.collectionPhieuNhap.findOne({
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_phieu_nhap: id }
            ]
        });
    }
    async findOne(filter){ // danh sách loại hàng 
       return await this.collectionPhieuNhap.findOne(filter);
    }
    
    async update(id, payload){
        console.log(id);
        const filter = {
           $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_phieu_nhap: id }
            ],
        };
        console.log("fileder" + filter);
        const update = this.extractPhieuNhapData(payload);
        console.log(update);
        const result = await this.collectionPhieuNhap.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionPhieuNhap.findOneAndDelete({
       $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { ma_phieu_nhap: id }
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
         
        const cursor =  await this.collectionPhieuNhap.aggregate(pipeline);
        return cursor.toArray();
    }
}
module.exports = NhaCungCapService;