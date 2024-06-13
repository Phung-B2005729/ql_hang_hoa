const { ObjectId } = require("mongodb");
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

class TaiKhoanService {
    constructor(client){
        this.collectionUser = client.db('qlhanghoa').collection("tai_khoan");
    }
    extractUserData(payload){
        console.log("gọi")
        // lay du lieu doi tuong user va loai bo cac thuoc tinh undefined
        const user = {
            user_name: payload.user_name,
            password: payload.password,
            phan_quyen: payload.phan_quyen ?? 1, //0,1,2,
            trang_thai: payload.trang_thai ?? 1, // mac dinh la 1 binh thuong - 0 la bi khoa
            refresh_token: payload.refresh_token
        }
       console.log(payload.user_name)
       Object.keys(user).forEach((key)=>{
        user[key] === undefined && delete user[key]
       });
        return user;
    }

    async create(payload){
        console.log(payload);
        const user = await this.extractUserData(payload);
        console.log(user);
        try {
         const ketqua = await this.collectionUser.insertOne(user);
         console.log('Insert thành công');
         return ketqua;
        }
        catch(err){
            console.log("Lỗi khi thêm " , err);
            throw err;
        }
    }
    async createMany(payload){
          const documents = [];
          for(const pay of payload){
            const user = this.extractUserData(pay);
            user.password = await bcrypt.hash(user.password, 10)
            documents.push(user);
          }
          try{
            const ketqua = await this.collectionUser.insertMany(documents)
            console.log('Insertmany thành công');
            return ketqua;
          }
          catch(e){
            console.log("Lỗi insertmany", e);
            throw e;
          }
    }
    //
    async find(filter, project){
        const cursor = project ? await this.collectionUser.find(filter, {projection: project }) : await this.collectionUser.find(filter);
        return await cursor.toArray();
    }



    //
    async findById(id, project) {
        console.log("goi ham findById 1 ----------" + id);
        return await this.collectionUser.findOne(
            {  $or: [
                { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
                { username: id }
            ] },
            {projection: project }
        );
    }

    //
    async findOne(filter,project){
        return await this.collectionUser.findOne(filter,{projection: project });
        
    }
    //
    async findByUserName(name,project){
        return await this.find({
            username: {
                $regex: new RegExp(name), $options: "i"
            }
        }, {projection: project });
    }
    //
    async update(id, payload){
        console.log("id", + id);
        const filter = {
            $or: [
            { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
            { username: id }
        ]
        };
        console.log("fileder" + filter);
        const update = this.extractUserData(payload);
        console.log(update);
        const result = await this.collectionUser.findOneAndUpdate(
            filter, 
            { $set: update}, 
            {returnDocument: "after"}
        );
        console.log(result);
        return result;
    }
    
    //
    async delete(id){
        console.log('goi ham delete conver  ' + id);
       const result = await this.collectionUser.findOneAndDelete({
        $or: [
            { _id: ObjectId.isValid(id) ? new ObjectId(id) : null },
            { username: id }
        ]
       });
       console.log("resu " +result);
       return result;
    }
    //
    async deleteAll(){
        const resutl = await this.collectionUser.deleteMany({});
        return resutl.deleteCount;
    }
}

module.exports = TaiKhoanService;