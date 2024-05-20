const express = require("express");
const phan_quyen = require('../controllers/phan_quyen.controller');

const router = express.Router();


//
router.route("/").get(phan_quyen.findALL).post(phan_quyen.create);
router.route("/:id").get(phan_quyen.findOne).put(phan_quyen.update).delete(phan_quyen.delete);

module.exports = router;