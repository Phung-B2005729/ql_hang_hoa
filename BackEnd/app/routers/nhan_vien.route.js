const express = require("express");
const nhan_vien = require("../controllers/nhan_vien.controller");

const router = express.Router();

router.route("/").get(nhan_vien.findALL).post(nhan_vien.create);

router.route("/:id").get(nhan_vien.findOne).put(nhan_vien.update).delete(nhan_vien.delete);

module.exports = router;