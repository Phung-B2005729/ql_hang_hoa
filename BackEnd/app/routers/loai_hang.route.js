const express = require("express");
const loai_hang = require("../controllers/loai_hang.controller");

const router = express.Router();

router.route("/").get(loai_hang.findALL).post(loai_hang.create);

router.route("/:id").get(loai_hang.findOne).put(loai_hang.update).delete(loai_hang.delete);

module.exports = router;