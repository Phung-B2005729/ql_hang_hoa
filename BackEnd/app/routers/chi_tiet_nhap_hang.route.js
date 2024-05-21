const express = require("express");
const chi_tiet_nhap_hang = require("../controllers/chi_tiet_nhap_hang.controller");

const router = express.Router();

router.route("/").get(chi_tiet_nhap_hang.findALL).post(chi_tiet_nhap_hang.create);

router.route("/:id").get(chi_tiet_nhap_hang.findOne).put(chi_tiet_nhap_hang.update).delete(chi_tiet_nhap_hang.delete);

module.exports = router;