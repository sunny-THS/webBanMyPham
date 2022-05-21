using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System;
using NUnit.Framework;
using System.Collections.Generic;

namespace TestProject_WebBanMP
{
    [TestClass]
    public class UnitTestDangKy
    {
        #region Đăng ký thất bại
        [TestMethod]
        public void TC1_DangKyThatBai()
        {
            TestDangKy dangKyThatBai = new TestDangKy();
            dangKyThatBai.SetUp();
            dangKyThatBai.dangKy();
            dangKyThatBai.TearDown();
        }
        #endregion
        #region Nhập thiếu một thông tin
        [TestMethod]
        public void TC2_DangKy()
        {
            string username = "admin";
            string password = "admin";
            string email = "email@gmail.com";
            string sdt = "0938252793";
            string ngSinh = "2001/05/02";
            string kq = "Vui lòng nhập đầy đủ thông tin!";
            string hoTen = string.Empty;

            TestDangKy dangKyThatBai = new TestDangKy();
            dangKyThatBai.SetUp();
            dangKyThatBai.dangKy(username, hoTen, password, email, ngSinh, sdt, kq);
            dangKyThatBai.TearDown();
        }
        #endregion
        #region Nhập sai định dạng email
        [TestMethod]
        public void TC3_DangKy()
        {
            string username = "admin";
            string password = "admin";
            string email = "email@";
            string sdt = "0938252793";
            string ngSinh = "2001/05/02";
            string kq = "Email không hợp lệ.Vui lòng nhập lại.";
            string hoTen = "Từ Huệ Sơn";

            TestDangKy dangKyThatBai = new TestDangKy();
            dangKyThatBai.SetUp();
            dangKyThatBai.dangKy(username, hoTen, password, email, ngSinh, sdt, kq);
            dangKyThatBai.TearDown();
        }
        #endregion
        #region Nhập sai định dạng sdt
        [TestMethod]
        public void TC4_DangKy()
        {
            string username = "admin";
            string password = "admin";
            string email = "email@gmai.com";
            string sdt = "093825279";
            string ngSinh = "2001/05/02";
            string kq = "Số điện thoại không hợp lệ.Vui lòng nhập lại.";
            string hoTen = "Từ Huệ Sơn";

            TestDangKy dangKyThatBai = new TestDangKy();
            dangKyThatBai.SetUp();
            dangKyThatBai.dangKy(username, hoTen, password, email, ngSinh, sdt, kq);
            dangKyThatBai.TearDown();
        }
        #endregion
        #region Nhập sai định dạng ngày sinh
        [TestMethod]
        public void TC5_DangKy()
        {
            string username = "admin";
            string password = "admin";
            string email = "email@gmai.com";
            string sdt = "0938252793";
            string ngSinh = "31022001";
            string kq = "Định dạng ngày sinh không hợp lệ";
            string hoTen = "Từ Huệ Sơn";

            TestDangKy dangKyThatBai = new TestDangKy();
            dangKyThatBai.SetUp();
            dangKyThatBai.dangKy(username, hoTen, password, email, ngSinh, sdt, kq);
            dangKyThatBai.TearDown();
        }
        #endregion
        #region Đăng ký thành công
        [TestMethod]
        public void TC6_DangKy()
        {
            string username = "admin"; // thay đôi
            string password = "admin";
            string email = "email@gmai.com";
            string sdt = "0938252793";
            string ngSinh = "2001/05/02";
            string kq = "Đăng ký thành công";
            string hoTen = "Nguyễn Văn Tèo"; // thay đôi

            TestDangKy dangKyThatBai = new TestDangKy();
            dangKyThatBai.SetUp();
            dangKyThatBai.dangKy(username, hoTen, password, email, ngSinh, sdt, kq);
            dangKyThatBai.TearDown();
        }
        #endregion

        [TestMethod]
        [DataTestMethod]
        [DynamicData(nameof(TestData_DangKy), DynamicDataSourceType.Method)]
        public void TC7_DangKy_xml(string pHoTen, string pUsername, string pPw, string pEmail, string pSDT, string pNgaySinh, string pKq)
        {
            string hoTen = pHoTen;
            string username = pUsername;
            string pw = pPw;
            string email = pEmail;
            string sdt = pSDT;
            string ngSinh = pNgaySinh;
            string kq = pKq;

            TestDangKy dangNhapThanhCong = new TestDangKy();
            dangNhapThanhCong.SetUp();
            dangNhapThanhCong.dangKy(username, hoTen, pw, email, ngSinh, sdt, kq);
            dangNhapThanhCong.TearDown();
        }


        #region bộ dữ liệu test
        static IEnumerable<object[]> TestData_DangKy() // hoTen, username, pw, email, sdt, ngaySinh, kq
        {
            yield return new Object[] { "Nguyễn Văn Kèo", string.Empty, "admin", "email@gmai.com", "0938252793", "05022001", "Vui lòng nhập đầy đủ thông tin!" };
            yield return new Object[] { "Nguyễn Văn Kèo", "admin", "admin", string.Empty, "0938252793", "05022001", "Vui lòng nhập đầy đủ thông tin!" };
            yield return new Object[] { string.Empty, "admin", "admin", "email@gmai.com", "0938252793", "05022001", "Vui lòng nhập đầy đủ thông tin!" };
            yield return new Object[] { "Nguyễn Văn Kèo", "admin", "admin", "email", "0938252793", "05022001", "Email không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Văn Kèo", "admin", "admin", "@gmail.com", "0938252793", "05022001", "Email không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Văn Kèo", "admin", "admin", "email@gmail", "0938252793", "05022001", "Email không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Văn Kèo", "admin", "admin", "email@gmail.com", "09382527931", "05022001", "Số điện thoại không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Văn Kèo", "admin", "admin", "email@gmail.com", "093825279", "05022001", "Số điện thoại không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Văn Kèo", "admin", "admin", "email@gmail.com", "A938252793", "05022001", "Số điện thoại không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Văn Kèo", "admin", "admin", "email@gmail.com", "0938252793", "31022001", "Định dạng ngày sinh không hợp lệ" };
            yield return new Object[] { "Nguyễn Văn Kèo", "tuhueson", "admin", "email@gmail.com", "0938252793", "05022001", "Username đã tồn tại. Vui lòng nhập lại" };
            yield return new Object[] { "Nguyễn Văn Kèo", "tuhueson", "admin", "email@gmail.com", "0938252793", "05022001", "Định dạng ngày sinh không hợp lệ" }; // fail
            yield return new Object[] { "Nguyễn Văn Kèo", "keoNguyenVan", "admin", "email@gmail.com", "0938252793", "05022001", "Đăng ký thành công" };
        }
        #endregion
    }
}
