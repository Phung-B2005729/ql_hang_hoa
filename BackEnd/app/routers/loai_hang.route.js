const express = require("express");
const loaihang = require("../controllers/loaihang.controller");

const router = express.Router();

router.route("/").get(loaihang.findALL).post(loaihang.create);

router.route("/:id").get(loaihang.findOne).put(loaihang.update).delete(loaihang.delete);

module.exports = router;