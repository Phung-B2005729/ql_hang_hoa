const ApiError = require("../config/api_error");
const MongoDB = require("../utils/mongodb.util");
require('dotenv').config()

const {uploadImage } = require("../services/hinh_anh.services");


exports.uploadSigle = async (req, res, next) => {
    try {
      const buildImage = await uploadImage(req.file, 'single'); 
      res.send(buildImage)
  } catch(err) {
    return next(new ApiError(500, err));
  }
  };

exports.uploadMultiple = async (req, res, next) => {
    const files = req.files; // Lấy danh sách các file đã tải lên
  
    // Kiểm tra xem danh sách files có tồn tại không
    if (!files || files.length === 0) {
        return res.status(400).json({ message: 'No files were uploaded.' });
    }
    try {
        const buildImage = await uploadImage(files, 'multiple'); 
        res.send(buildImage)
    } catch (err) {
        return next(new ApiError(500, err));
    }
  };




