using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebBanMyPham.Models
{
    public class HoaDon
    {
        string maHD, tenKH;// nhập khi thanh toán
        DateTime ngayCapNhat;
        string ppvc;
        string diaChi;

        public string DiaChi
        {
            get { return diaChi; }
            set { diaChi = value; }
        }

        public string Ppvc
        {
            get { return ppvc; }
            set { ppvc = value; }
        }

        public DateTime NgayCapNhat
        {
            get { return ngayCapNhat; }
            set { ngayCapNhat = value; }
        }

        SanPham sp;

        double gia;

        public double Gia
        {
            get { return gia; }
            set { gia = value; }
        }

        public SanPham Sp
        {
            get { return sp; }
            set { sp = value; }
        }

        public string TenKH
        {
            get { return tenKH; }
            set { tenKH = value; }
        }

        public string MaHD
        {
            get { return maHD; }
            set { maHD = value; }
        }
    }
}