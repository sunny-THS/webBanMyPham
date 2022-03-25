using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebBanMyPham.Models
{
    public class ThongTinNguoiDung
    {
        string hoTen, email, sdt, gioiTinh;
        TaiKhoan tk;
        DateTime ngaySinh;

        public TaiKhoan Tk
        {
            get { return tk; }
            set { tk = value; }
        }

        public DateTime NgaySinh
        {
            get { return ngaySinh; }
            set { ngaySinh = value; }
        }

        public string Sdt
        {
            get { return sdt; }
            set { sdt = value; }
        }

        public string Email
        {
            get { return email; }
            set { email = value; }
        }

        public string GioiTinh
        {
            get { return gioiTinh; }
            set { gioiTinh = value; }
        }

        public string HoTen
        {
            get { return hoTen; }
            set { hoTen = value; }
        }
    }
}