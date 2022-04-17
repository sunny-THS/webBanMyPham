using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebBanMyPham.Models;

namespace WebBanMyPham.Controllers
{
    public class QuanLyController : Controller
    {
        //
        // GET: /QuanLy/
        DatabaseDataContext db = new DatabaseDataContext();

        public ActionResult HoaDon()
        {
            if (Session["ThongTinAdmin"] == null)
                return RedirectToAction("Index", "Admin");

            List<HoaDon> lstHoaDon = db.HOADONs.Select(hd => new HoaDon
            {
                TenKH = db.THONGTINTAIKHOANs.Single(tttk => tttk.ID_TAIKHOAN == hd.KHACHHANG.TAIKHOAN.ID).HOTEN,
                Gia = hd.DONGIA.Value,
                NgayCapNhat = hd.NGTAO.Value,
                Ppvc = hd.PPVC.TEN,
                DiaChi = string.Format("{0}, {1}, {2}, {3}", hd.DIACHIGH.SONHA, hd.DIACHIGH.TINHTHANH.TEN, hd.DIACHIGH.QUANHUYEN.TEN, hd.DIACHIGH.XAPHUONG.TEN)
            }).ToList();

            ViewBag.TongThanhTien = lstHoaDon.Sum(hd => hd.Gia);

            return View(lstHoaDon);
        }
    }
}
