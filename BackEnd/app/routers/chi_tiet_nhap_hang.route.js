const express = require("express");
const chi_tiet_nhap_hang = require("../controllers/chi_tiet_nhap_hang.controller");

const router = express.Router();

router.route("/").get(chi_tiet_nhap_hang.findALL).post(chi_tiet_nhap_hang.create);

router.route("/:so_lo/:ma_phieu_nhap/:ma_hang_hoa").get(chi_tiet_nhap_hang.findOne);

router.route("/:id").get(chi_tiet_nhap_hang.findById).put(chi_tiet_nhap_hang.update).delete(chi_tiet_nhap_hang.delete);

module.exports = router;