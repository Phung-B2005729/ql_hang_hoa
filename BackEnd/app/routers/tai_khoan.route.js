const express = require('express')
const router = express.Router();
const taiKhoanController = require('../controllers/tai_khoan.controller');
//public

// tạo tài khoản
router.route("/").post(taiKhoanController.create).get(taiKhoanController.findAll);

router.route("/admin/change_password").put(taiKhoanController.adminChangePassword);
router.route("/admin/delete/:id").put(taiKhoanController.adminDeleteTaiKhoan);

router.route("/:id").put(taiKhoanController.update).delete(taiKhoanController.delete);

router.route("/:id/change_password").put(taiKhoanController.changePassword);


module.exports = router;