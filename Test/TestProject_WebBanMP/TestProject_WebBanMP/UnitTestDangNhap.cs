using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System;
using NUnit.Framework;
using System.Collections.Generic;

namespace TestProject_WebBanMP
{
    [TestClass]
    public class UnitTestDangNhap
    {
        #region Sai thông tin đăng nhập
        [TestMethod]
        public void TC1_DangNhapThatBai()
        {
            DangNhapThatBaiTest dangNhapThatBaiTest = new DangNhapThatBaiTest();
            dangNhapThatBaiTest.SetUp();
            dangNhapThatBaiTest.dangNhapThatBai();
            dangNhapThatBaiTest.TearDown();
        }
        [TestMethod]
        public void TC2_DangNhapThatBai()
        {
            DangNhapThatBaiTest dangNhapThatBaiTest = new DangNhapThatBaiTest();

            string username = "username";
            string password = "password";
            dangNhapThatBaiTest.SetUp();
            dangNhapThatBaiTest.dangNhapThatBai(username, password);
            dangNhapThatBaiTest.TearDown();
        }
        #endregion

        #region Nhập thiếu thông tin đăng nhập
        [TestMethod]
        public void TC3_NhapThieuTT_DN() // username is empty
        {
            NhapThieuThongTinTest nhapThieuTT = new NhapThieuThongTinTest();
            nhapThieuTT.SetUp();
            nhapThieuTT.nhapThieuThongTin(string.Empty, "123");
            nhapThieuTT.TearDown();
        }
        [TestMethod]
        public void TC4_NhapThieuTT_DN() // pw is empty
        {
            NhapThieuThongTinTest nhapThieuTT = new NhapThieuThongTinTest();
            nhapThieuTT.SetUp();
            nhapThieuTT.nhapThieuThongTin("tuhueson", string.Empty);
            nhapThieuTT.TearDown();
        }
        #endregion

        #region Đăng nhập thành công
        [TestMethod]
        [TestCategory("Passed")]
        public void TC5_DangNhapThanhCong()
        {
            DangNhapThanhCongTest dangNhapThanhCong = new DangNhapThanhCongTest();
            dangNhapThanhCong.SetUp();
            dangNhapThanhCong.dangNhapThanhCong("tuhueson", "123456789");
            dangNhapThanhCong.TearDown();
        }

        [TestMethod]
        [TestCategory("Failed")]
        public void TC6_DangNhapThanhCong()
        {
            DangNhapThanhCongTest dangNhapThanhCong = new DangNhapThanhCongTest();
            dangNhapThanhCong.SetUp();
            dangNhapThanhCong.dangNhapThanhCong("tuhueson", "1234567899");
            dangNhapThanhCong.TearDown();
        }
        #endregion

        [TestMethod]
        [DataTestMethod]
        [DynamicData(nameof(TestData_DangNhap), DynamicDataSourceType.Method)]
        public void TC7_DangNhap_xml(string pUsername, string pPw, string pKq)
        {
            string username = pUsername;
            string pw = pPw;
            string kq = pKq;

            TestDangNhap dangNhapThanhCong = new TestDangNhap();
            dangNhapThanhCong.SetUp();
            dangNhapThanhCong.dangNhap(username, pw, kq);
            dangNhapThanhCong.TearDown();
        }

        #region bộ dữ liệu test
        static IEnumerable<object[]> TestData_DangNhap()
        {
            yield return new Object[] { "abc", "aaaa", "ssss" }; // fail
            yield return new Object[] { "tuhueson", string.Empty, "Vui lòng nhập đủ thông tin" }; // pass
            yield return new Object[] { string.Empty, "tuhueson", string.Empty }; // fail
            yield return new Object[] { string.Empty, "tuhueson", "Vui lòng nhập đủ thông tin" }; // pass
            yield return new Object[] { "tuhueson", "123456789", string.Empty }; // pass
            yield return new Object[] { "tuhueson", "12345697899", "ssss" }; // fail
            yield return new Object[] { "tuhueson", "12345697899", "Thông tin đăng nhập không chính xác." }; // pass
        }
        #endregion
    }
}