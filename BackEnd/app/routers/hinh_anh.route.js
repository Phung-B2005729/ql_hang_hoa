const express = require("express");
const { upload, uploadMultiple } = require('../middleware/multer')
const hinh_anh = require("../controllers/hinh_anh.controller");

const router = express.Router();

router.post('/upload_sigle', upload, hinh_anh.uploadSigle);
router.post('/upload_multiple', uploadMultiple, hinh_anh.uploadMultiple);


module.exports = router;