const express = require("express");
const cua_hang = require("../controllers/cua_hang.controller");

const router = express.Router();

router.route("/").get(cua_hang.findALL).post(cua_hang.create);

router.route("/:id").get(cua_hang.findOne).put(cua_hang.update).delete(cua_hang.delete);

module.exports = router;