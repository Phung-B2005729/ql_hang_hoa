const express = require("express");
const hang_hoa = require("../controllers/hang_hoa.controller");
const { upload, uploadMultiple } = require('../middleware/multer');

const router = express.Router();

router.route("/").get(hang_hoa.findALL).post(uploadMultiple, hang_hoa.create);

router.route("/:id").get(hang_hoa.findOne).put(hang_hoa.update).delete(hang_hoa.delete);

module.exports = router;