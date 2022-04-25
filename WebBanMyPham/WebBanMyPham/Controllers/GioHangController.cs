using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebBanMyPham.Models;

namespace WebBanMyPham.Controllers
{
    public class GioHangController : Controller
    {
        //
        // GET: /GioHang/

        public ActionResult GioHang()
        {
            ViewBag.Message = ViewBag.Info = string.Empty;

            if (Session["HoaDon"] == null)
                return RedirectToAction("MessageEmpty");
            List<HoaDon> lstHD = LayHoaDon();

            if (ckSL)
            {
                ViewBag.Message = string.Format("Sản phẩm {0}... không đủ số lượng", tenSP.Substring(0, 30));
                ViewBag.Info = "ERR";

                ckSL = false;
            }

            ViewBag.TongSoLuong = TongSoLuong();
            ViewBag.TongThanhTien = TongThanhTien();

            return View(lstHD);
        }

        private int TongSoLuong()
        {
            int tsl = 0;
            List<HoaDon> lstGioHang = Session["HoaDon"] as List<HoaDon>;
            if (lstGioHang != null)
            {
                tsl = lstGioHang.Sum(sp => sp.Sp.SoLuong);
            }
            return tsl;
        }

        private double TongThanhTien()
        {
            double ttt = 0;
            List<HoaDon> lstGioHang = Session["HoaDon"] as List<HoaDon>;
            if (lstGioHang != null)
            {
                ttt += lstGioHang.Sum(sp => sp.Sp.Gia * sp.Sp.SoLuong);
            }
            return ttt;
        }

        public ActionResult MessageEmpty()
        {
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

        DatabaseDataContext db = new DatabaseDataContext();

        public ActionResult ThemGioHang(string ms, string strURL)
        {
            List<HoaDon> lstHoaDon = LayHoaDon();
            HoaDon hd = lstHoaDon.Find(sp => sp.Sp.Id == ms);

            if (hd == null)
            {
                hd = new HoaDon();

                // get sp
                SanPham sp_ = db.SANPHAMs.Join(db.DONGIAs,
                                    sp => sp.ID,
                                    donGia => donGia.ID_SP,
                                    (sp, donGia) => new SanPham
                                    {
                                        Id = sp.ID,
                                        TenSP = sp.TENSP,
                                        SoLuong = int.Parse(sp.SOLUONG.Value.ToString()),
                                        HinhAnh = sp.HINHANH,
                                        Gia = double.Parse(donGia.GIA.Value.ToString())
                                    }).Single(sp => sp.Id == ms);

                hd.Sp = new SanPham();
                hd.Sp.Id = sp_.Id;
                hd.Sp.TenSP = sp_.TenSP;
                hd.Sp.Gia = sp_.Gia;
                hd.Sp.HinhAnh = sp_.HinhAnh;
                hd.Sp.SoLuong = 1;

                lstHoaDon.Add(hd);
            }
            else
            {
                hd.Sp.SoLuong++;
            }

            return Redirect(strURL);
        }

        public ActionResult XoaGioHang_All()
        {
            //lấy giỏ hàng
            List<HoaDon> lstGioHang = LayHoaDon();
            lstGioHang.Clear();
            Session["HoaDon"] = null;
            return RedirectToAction("Index", "Home");
        }

        public ActionResult GioHangPartial()
        {
            ViewBag.TongSoLuong = TongSoLuong();
            ViewBag.TongThanhTien = TongThanhTien();
            return PartialView();
        }

        public ActionResult XoaGioHang(string MaSP)
        {
            List<HoaDon> lstGioHang = LayHoaDon();
            HoaDon hd = lstGioHang.Single(sp => sp.Sp.Id == MaSP);
            //nếu có thì tiến hành xóa
            if (hd != null)
            {
                lstGioHang.RemoveAll(sp => sp.Sp.Id == MaSP);
            }
            //nếu giỏ hàng rỗng
            if (lstGioHang.Count == 0)
            {
                Session["HoaDon"] = null;

                return RedirectToAction("Index", "Home");
            }
            return RedirectToAction("GioHang");
        }

        static bool ckSL = false;
        static string tenSP = string.Empty;

        public ActionResult CapNhatGioHang(string MaSP, FormCollection f)
        {
            ckSL = false;
            List<HoaDon> lstGioHang = LayHoaDon();
            HoaDon sp = lstGioHang.Single(s => s.Sp.Id == MaSP);

            // kiểm tra số lượng sản phẩm
            int? slSP = db.SANPHAMs.Where(s => s.ID == MaSP).Select(s => s.SOLUONG).Single();

            //nếu có thì tiến hành cập nhật
            if (sp != null)
            {

                if (slSP < int.Parse(f["txtSoLuong"].ToString()))
                {
                    ckSL = true;
                    tenSP = sp.Sp.TenSP;
                }
                else sp.Sp.SoLuong = int.Parse(f["txtSoLuong"].ToString());
            }
            return RedirectToAction("GioHang");
        }

        public ActionResult DatHang()
        {
            // xử lí theo quy trình
            return RedirectToAction("TTGioHang", "ThongTinGioHang");
        }

        public ActionResult HoaDon()
        {
            if (Session["HoaDon"] == null)
                return RedirectToAction("MessageEmpty");
            List<HoaDon> lstHD = LayHoaDon();
            var ttND = Session["ThongTinNguoiDung"] as ThongTinNguoiDung;

            lstHD.ForEach(hd =>
            {
                hd.TenKH = ttND.HoTen;
            });

            ViewBag.TongSoLuong = TongSoLuong();
            ViewBag.TongThanhTien = TongThanhTien();

            return View(lstHD);
        }
    }
}
