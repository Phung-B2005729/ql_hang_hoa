// khai báo thư viện
require('dotenv').config();
const express = require("express"); // khai su dung modul express
const cors = require("cors");
const cookieParser = require('cookie-parser');

// khai báo đường dẫn khác
const ApiError = require("./app/config/api_error");
const authenticationMiddleware = require('./app/middleware/authentication');


// khai báo đường dẫn route
  // user đăng nhập
const authRouter = require("./app/routers/auth.route");
 // tài khoản
const taiKhoanRouter = require("./app/routers/tai_khoan.route"); 

  // hàng hoá
const hangHoaRouter = require("./app/routers/hang_hoa.route");
const thuongHieuRouter = require("./app/routers/thuong_hieu.route");
const loaiHangRouter = require("./app/routers/loai_hang.route");
const hinhAnhRouter = require("./app/routers/hinh_anh.route");
 // lô hàng
const loHangRouter = require("./app/routers/lo_hang.route");
const tongKhoLoHangRouter = require("./app/routers/ton_kho_lo_hang.route");
const giaoDichRouter = require("./app/routers/giao_dich.route");
  // cửa hàng
const cuaHangRouter = require("./app/routers/cua_hang.route");
const nhanVienRouter = require("./app/routers/nhan_vien.route");
 // nhập hàng
const nhaCungRouter = require("./app/routers/nha_cung_cap.router");
const phieuNhapRouter = require("./app/routers/phieu_nhap.route");
const chiTietNhapHangRouter = require("./app/routers/chi_tiet_nhap_hang.route");
const phieuKiemKhoRouter = require("./app/routers/phieu_kiem_kho.route");
const chiTietKiemKhoRouter = require("./app/routers/chi_tiet_kiem_kho.route");

// su dung thuvien-midd
const app = express();

app.use(cors());

app.use(express.json());

app.use(cookieParser());



//tài khoản
app.use("/api/tai_khoan", taiKhoanRouter);
//user đăng nhập
app.use("/api", authRouter);

// hàng hoá
app.use("/api/hang_hoa", hangHoaRouter);
app.use("/api/loai_hang", loaiHangRouter);
app.use("/api/thuong_hieu", thuongHieuRouter);
app.use("/api/hinh_anh", hinhAnhRouter);
// lô hang
app.use("/api/lo_hang", loHangRouter);
app.use("/api/ton_kho_lo_hang", tongKhoLoHangRouter);
app.use("/api/giao_dich", giaoDichRouter);
// chi nhánh
app.use("/api/cua_hang", cuaHangRouter);
app.use("/api/nhan_vien", nhanVienRouter);
// nhập hàng
app.use("/api/nha_cung_cap", nhaCungRouter);
app.use("/api/phieu_nhap", phieuNhapRouter);
app.use("/api/chi_tiet_nhap_hang", chiTietNhapHangRouter);

//
app.use("/api/phieu_kiem_kho", phieuKiemKhoRouter);
app.use("/api/chi_tiet_kiem_kho", chiTietKiemKhoRouter);



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




