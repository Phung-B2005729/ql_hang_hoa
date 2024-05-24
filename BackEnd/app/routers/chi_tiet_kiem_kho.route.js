const express = require("express");
const chi_tiet_kiem_kho = require("../controllers/chi_tiet_kiem_kho.controller");

const router = express.Router();

router.route("/").get(chi_tiet_kiem_kho.findALL).post(chi_tiet_kiem_kho.create);

router.route("/:so_lo/:ma_phieu_nhap").get(chi_tiet_kiem_kho.findOne);

router.route("/:id").get(chi_tiet_kiem_kho.findById).put(chi_tiet_kiem_kho.update).delete(chi_tiet_kiem_kho.delete);

module.exports = router;