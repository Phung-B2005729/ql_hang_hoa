const express = require("express");
const lo_hang = require("../controllers/lo_hang.controller");

const router = express.Router();

router.route("/").get(lo_hang.findALL).post(lo_hang.create);

router.route("/:id").get(lo_hang.findOne).put(lo_hang.update).delete(lo_hang.delete);

module.exports = router;