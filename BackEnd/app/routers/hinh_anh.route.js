const express = require("express");
const hinh_anh = require("../controllers/hinh_anh.controller");

const router = express.Router();

router.route("/").get(hinh_anh.findALL).post(hinh_anh.create);

router.route("/:id").get(hinh_anh.findOne).put(hinh_anh.update).delete(hinh_anh.delete);

module.exports = router;