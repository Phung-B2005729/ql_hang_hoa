const express = require('express')
const router = express.Router();
const taiKhoanController = require('../controllers/tai_khoan.controller');
//public

// tạo tài khoản
router.route("/").get(taiKhoanController.findAll).post(taiKhoanController.create);

router.route("/:id").put(taiKhoanController.update).delete(taiKhoanController.delete);


module.exports = router;