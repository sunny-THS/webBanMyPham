using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Newtonsoft.Json;
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

        [HttpGet]
        public JsonResult GetQH(int thID)
        {
            var qh = db.QUANHUYENs.Where(c => c.ID_TINHTHANH.Equals(thID)).Select(item => new
            {
                item.TEN,
                item.ID
            }).OrderBy(c => c.TEN).ToList();

            var data = JsonConvert.SerializeObject(qh, Formatting.Indented,
                       new JsonSerializerSettings
                       {
                           ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                       });

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult GetXP(int qhID)
        {
            var qh = db.XAPHUONGs.Where(c => c.ID_QH.Equals(qhID)).Select(item => new
            {
                item.TEN,
                item.ID
            }).OrderBy(c => c.TEN).ToList();

            var data = JsonConvert.SerializeObject(qh, Formatting.Indented,
                       new JsonSerializerSettings
                       {
                           ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                       });

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public ActionResult TTGioHang()
        {
            List<TINHTHANH> lstTinhThanh = db.TINHTHANHs.ToList();
            List<QUANHUYEN> lstQH = new List<QUANHUYEN>();
            List<XAPHUONG> lstXP= new List<XAPHUONG>();

            SelectList sl = new SelectList(lstTinhThanh, "ID", "TEN");
            SelectList qh = new SelectList(lstQH, "ID", "TEN");
            SelectList xp = new SelectList(lstXP, "ID", "TEN");


            ViewBag.LstTinhThanh = sl;
            ViewBag.LstQH = qh;
            ViewBag.LstXP = xp;

            return View();
        }

        public ActionResult TTGioHangParti()
        {
            return View();
        }
    }


    
}
