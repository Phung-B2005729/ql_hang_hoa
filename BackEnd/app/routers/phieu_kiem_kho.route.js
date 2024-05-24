const express = require("express");
const phieu_kiem_kho = require("../controllers/phieu_kiem_kho.controller");

const router = express.Router();

router.route("/").get(phieu_kiem_kho.findALL).post(phieu_kiem_kho.create);

router.route("/:id").get(phieu_kiem_kho.findOne).put(phieu_kiem_kho.update).delete(phieu_kiem_kho.delete);

module.exports = router;