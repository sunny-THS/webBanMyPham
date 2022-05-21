using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System;
using NUnit.Framework;
using System.Collections.Generic;

namespace TestProject_WebBanMP
{
    [TestClass]
    public class UnitTestGioHang
    {
        [TestMethod]
        [DataTestMethod]
        [DynamicData(nameof(TestData_GioHang), DynamicDataSourceType.Method)]
        public void TC1_GioHang_xml(string pSoLuong)
        {
            TestGioHang dangNhapThanhCong = new TestGioHang();
            dangNhapThanhCong.SetUp();
            dangNhapThanhCong.testGioHang(pSoLuong);
            dangNhapThanhCong.TearDown();
        }
        #region bộ dữ liệu test
        static IEnumerable<object[]> TestData_GioHang()
        {
            yield return new Object[] { "1e" }; // nhập sai định dạng
            yield return new Object[] { "-" }; // nhập sai định dạng
            yield return new Object[] { "1" }; // biên dưới
            yield return new Object[] { "0" }; // biên dưới -
            yield return new Object[] { "99" }; // biên trên (nếu số lượng tồn kho đủ)
            yield return new Object[] { "100" }; // biên trên +
            yield return new Object[] { "60" }; // nhập giá trị trong dãy cho phép
            yield return new Object[] { "15" }; // nhập giá trị < số lượng tồn kho (ở đây số lượng tồn kho là 15)
            yield return new Object[] { "16" }; // nhập giá trị > số lượng tồn kho một đơn vị (ở đây số lượng tồn kho là 15)
        }
        #endregion
    }
}
