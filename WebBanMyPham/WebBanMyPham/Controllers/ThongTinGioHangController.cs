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

        private void getDataKV()
        {
            List<TINHTHANH> lstTinhThanh = db.TINHTHANHs.ToList();
            List<QUANHUYEN> lstQH = new List<QUANHUYEN>();
            List<XAPHUONG> lstXP = new List<XAPHUONG>();
            List<PPVC> lstPPVC = db.PPVCs.ToList();

            SelectList sl = new SelectList(lstTinhThanh, "ID", "TEN");
            SelectList qh = new SelectList(lstQH, "ID", "TEN");
            SelectList xp = new SelectList(lstXP, "ID", "TEN");
            SelectList ppvc = new SelectList(lstPPVC, "ID", "TEN");


            ViewBag.LstTinhThanh = sl;
            ViewBag.LstQH = qh;
            ViewBag.LstXP = xp;
            ViewBag.LstPPVC = ppvc;
        }

        public ActionResult TTGioHang()
        {
            if (Session["ThongTinNguoiDung"] != null)
                return RedirectToAction("TTGioHangUser", "ThongTinGioHang");
            getDataKV();

            return View();
        }

        public List<HoaDon> LayHoaDon()
        {
            List<HoaDon> lstHoaDon = Session["HoaDon"] as List<HoaDon>;
            if (lstHoaDon == null)
            {
                //nếu lstGioHang chưa tồn tại thì khởi tạo
                lstHoaDon = new List<HoaDon>();
                Session["HoaDon"] = lstHoaDon;
            }
            return lstHoaDon;
        }

        public JsonResult XacNhanHD(string pHoTen, string pEmail, string pSDT, string pDC, int pTP, int pQH, int pXP, int pPPVC)
        {
            ThongTinNguoiDung ttND = new ThongTinNguoiDung();
            // check người dùng  hay không
            if (Session["ThongTinNguoiDung"] == null)
            {
                ttND = new ThongTinNguoiDung
                {
                    HoTen = pHoTen,
                    Email = pEmail,
                    Sdt = pSDT
                };
                Session["ThongTinNguoiDung"] = ttND;

                
                // thêm khách hàng mới (không tài khoản)
                db.sp_AddAcc(string.Empty, string.Empty, "Khách Hàng", ttND.HoTen, null, null, ttND.Email, ttND.Sdt, pDC, false);
            }
                
            else
                ttND = Session["ThongTinNguoiDung"] as ThongTinNguoiDung;

            //=======================================================
            // add địa chỉ
            db.DIACHIGHs.InsertOnSubmit(new DIACHIGH { 
                IDTINH = pTP,
                IDHUYEN = pQH,
                IDXA = pXP,
                SONHA = pDC
            });
            db.SubmitChanges();

            // get id dc
            int iddc = db.DIACHIGHs.Count();
           //=======================================================

            List<HoaDon> lstGioHang = LayHoaDon(); // lấy lst hóa đơn 

            // get mã hóa đơn
            string maHD = db.fn_autoIDHD();


            lstGioHang.ForEach(gh =>
            {
                db.sp_AddHD(maHD, ttND.HoTen, ttND.Tk == null ? string.Empty : ttND.Tk.Username, gh.Sp.TenSP, gh.Sp.SoLuong, iddc, pPPVC, ttND.Tk != null);

            });
            Session["IDHD"] = maHD;

            // xuất hóa đơn
            return Json("Success", JsonRequestBehavior.AllowGet);// RedirectToAction("HoaDon", "GioHang");
        }


        public ActionResult TTGioHangUser()
        {
            getDataKV();

            return View();
        }

        public ActionResult TTGioHangParti()
        {
            return View();
        }
    }


    
}
