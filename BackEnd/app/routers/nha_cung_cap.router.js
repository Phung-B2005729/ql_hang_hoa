const express = require("express");
const nha_cung_cap = require("../controllers/nha_cung_cap.controller");

const router = express.Router();

router.route("/").get(nha_cung_cap.findALL).post(nha_cung_cap.create);

router.route("/:id").get(nha_cung_cap.findOne).put(nha_cung_cap.update).delete(nha_cung_cap.delete);

module.exports = router;