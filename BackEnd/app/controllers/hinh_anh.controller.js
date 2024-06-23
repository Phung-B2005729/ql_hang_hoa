const ApiError = require("../config/api_error");
const MongoDB = require("../utils/mongodb.util");
require('dotenv').config()

const {uploadImage, deleteImage } = require("../services/hinh_anh.services");
const HangHoaService = require("../services/hang_hoa.services");


exports.uploadSingle = async (req, res, next) => {
    try {
     console.log(req.file);
     console.log('gọi upload sige');
      const buildImage = await uploadImage(req.file, 'single'); 
      console.log(buildImage);
      res.send(buildImage)
     
  } catch(err) {
    console.log(err);
    return next(new ApiError(500, err));
  }
  };

exports.uploadMultiple = async (req, res, next) => {
    const files = req.files; // Lấy danh sách các file đã tải lên
    console.log(req.files);
    // Kiểm tra xem danh sách files có tồn tại không
    if (!files || files.length === 0) {
        return next(new ApiError(400, 'No file upload'));
    }
    try {
        const buildImage = await uploadImage(files, 'multiple'); 
        res.send(buildImage)
    } catch (err) {
        return next(new ApiError(500, err));
    }
  };

exports.deleteImag = async (req, res, next) => {
    if(!req.params.ten_anh){
        console.log('chưa thêm vào tên ảnh');
        return next(new ApiError(400, 'No find name image'));
    }
    const hangHoaService = new HangHoaService(MongoDB.client);
    // kiểm tra
    let hang_hoa = await hangHoaService.findOne({
        'hinh_anh.ten_anh': req.params.ten_anh
    });
    if(hang_hoa!=null){
        console.log('Ảnh được sử dụng cho 1 hơn nhiều sản phẩm')
       // tồn tại và không xoá
       res.send('Ảnh được sử dụng cho 1 hơn nhiều sản phẩm');
    }else{
    try {
         await deleteImage(req.params.ten_anh);
        res.send('deleted');
    } catch (err) {
        return next(new ApiError(500, err));
    }
}
}




