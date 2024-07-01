

const moment = require('moment');
exports.escapeStringRegexp = (string) => {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}


exports.khoangNgayDenHan = async (songay) => {
      let toDay = new Date();
      toDay.setDate(toDay.getDate() + songay);
       let han_su_dung = moment(toDay).format('YYYY-MM-DD');
    return han_su_dung;
       
}