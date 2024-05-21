const express = require("express");
const giao_dich = require("../controllers/giao_dich.controller");

const router = express.Router();

router.route("/").get(giao_dich.findALL).post(giao_dich.create);

router.route("/:id").get(giao_dich.findOne).put(giao_dich.update).delete(giao_dich.delete);

module.exports = router;