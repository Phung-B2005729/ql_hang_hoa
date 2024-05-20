const express = require("express");
const thuong_hieu = require("../controllers/thuong_hieu.controller");

const router = express.Router();

router.route("/").get(thuong_hieu.findALL).post(thuong_hieu.create);

router.route("/:id").get(thuong_hieu.findOne).put(thuong_hieu.update).delete(thuong_hieu.delete);

module.exports = router;