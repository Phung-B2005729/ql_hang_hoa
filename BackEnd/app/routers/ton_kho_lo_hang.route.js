const express = require("express");
const ton_kho_lo_hang = require("../controllers/ton_kho_lo_hang.controller");

const router = express.Router();

router.route("/").get(ton_kho_lo_hang.findALL).post(ton_kho_lo_hang.create);
router.route("/tong_so_luong").get(ton_kho_lo_hang.countTonKho);
router.route("/update/:so_lo/:ma_hang_hoa/:ma_cua_hang").put(ton_kho_lo_hang.updateTheoLoSoHangHoaCuaHang);

router.route("/:so_lo/:ma_hang_hoa/:ma_cua_hang").get(ton_kho_lo_hang.findOne).put(ton_kho_lo_hang.themSoLuongTonKho);

router.route("/giam_so_luong/:so_lo/:ma_hang_hoa/:ma_cua_hang").put(ton_kho_lo_hang.giamSoLuongTonKho);

router.route("/:id").get(ton_kho_lo_hang.findById).put(ton_kho_lo_hang.update).delete(ton_kho_lo_hang.delete);

module.exports = router;