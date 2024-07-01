const express = require("express");
const phieu_nhap = require("../controllers/phieu_nhap.controller");

const router = express.Router();

router.route("/").get(phieu_nhap.findALL).post(phieu_nhap.create);
router.route("/tong_quan").get(phieu_nhap.findTongQuan);
router.route("/phieu_tam").get(phieu_nhap.findPhieuTamGanDay);

router.route("/:id").get(phieu_nhap.findOne).put(phieu_nhap.update).delete(phieu_nhap.delete);

module.exports = router;