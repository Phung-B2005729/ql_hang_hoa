// khai báo thư viện
require('dotenv').config();
const express = require("express"); // khai su dung modul express
const cors = require("cors");
const cookieParser = require('cookie-parser');

// khai báo đường dẫn khác
const ApiError = require("./app/config/api_error");
const authenticationMiddleware = require('./app/middleware/authentication');


// khai báo đường dẫn route
const userRouter = require("./app/routers/user.route");
const thuongHieuRouter = require("./app/routers/thuong_hieu.route");
const loaiHangRouter = require("./app/routers/loai_hang.route");
const phanQuyenRouter = require("./app/routers/phan_quyen.route");
const cuaHangRouter = require("./app/routers/cua_hang.route");


// su dung thuvien-midd
const app = express();

app.use(cors());

app.use(express.json());

app.use(cookieParser());



//
app.use("/api/user", userRouter);
app.use("/api/loai_hang", loaiHangRouter);
app.use("/api/thuong_hieu", thuongHieuRouter);
app.use("/api/phan_quyen", phanQuyenRouter);
app.use("/api/cua_hang", cuaHangRouter);



//  loi truy cap dg link khac
app.use((req, res, next) => {
    return next(new ApiError(404, "Resource not found"));
});

//
app.use((err, req, res, next) => {
    return res.status(err.statusCode || 500).json({
        message: err.message || "Internal Server Error",
    });
});

module.exports = app;




