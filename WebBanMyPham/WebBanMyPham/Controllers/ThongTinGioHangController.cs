using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebBanMyPham.Models;

namespace WebBanMyPham.Controllers
{
    public class ThongTinGioHangController : Controller
    {
        //
        // GET: /ThongTinGioHang/
        DatabaseDataContext db = new DatabaseDataContext();
        public ActionResult Index()
        {
            return View();
        }
        public void getQuanHuyen(int iTinhThanh)
        {
            List<QUANHUYEN> lstQH= db.QUANHUYENs.Where(item => item.ID_TINHTHANH == iTinhThanh).ToList();

            SelectList sl = new SelectList(lstQH, "ID", "TEN");

            ViewBag.QuanHuyen = sl;
        }
        public ActionResult TTGioHang()
        {
            List<TINHTHANH> lstTinhThanh = db.TINHTHANHs.ToList();

            SelectList sl = new SelectList(lstTinhThanh, "ID", "TEN");

            ViewBag.LstTinhThanh = sl;

            return View();
        }

        public ActionResult TTGioHangParti()
        {
            return View();
        }
    }


    
}
