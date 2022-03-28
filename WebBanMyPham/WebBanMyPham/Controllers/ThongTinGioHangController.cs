using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebBanMyPham.Controllers
{
    public class ThongTinGioHangController : Controller
    {
        //
        // GET: /ThongTinGioHang/

        public ActionResult Index()
        {
            return View();
        }
        public ActionResult TTGioHang()
        {
            return View();
        }

        public ActionResult TTGioHangParti()
        {
            return View();
        }
    }


    
}
