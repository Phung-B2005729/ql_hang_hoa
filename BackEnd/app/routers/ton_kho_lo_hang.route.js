const express = require("express");
const ton_kho_lo_hang = require("../controllers/ton_kho_lo_hang.controller");

const router = express.Router();

router.route("/").get(ton_kho_lo_hang.findALL).post(ton_kho_lo_hang.create);

router.route("/:so_lo/:ma_cua_hang").get(ton_kho_lo_hang.findOne).put(ton_kho_lo_hang.updateLoHangCuaHang);

router.route("/:id").get(ton_kho_lo_hang.findById).put(ton_kho_lo_hang.update).delete(ton_kho_lo_hang.delete);

module.exports = router;