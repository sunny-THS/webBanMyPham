using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System;
using NUnit.Framework;
using System.Collections.Generic;

namespace TestProject_WebBanMP
{
    [TestClass]
    public class UnitTestDatHang
    {
        [TestMethod]
        [DataTestMethod]
        [DynamicData(nameof(TestData_DatHang), DynamicDataSourceType.Method)]
        public void TC1_DatHang_xml(string pHoTen, string pEmail, string pSDT, string pDiaChi, string? KQLoi = null, int isKhuVuc = 3)
        {
            TestDatHang dangNhapThanhCong = new TestDatHang();
            dangNhapThanhCong.SetUp();
            dangNhapThanhCong.testDatHang(pHoTen, pEmail, pSDT, pDiaChi, isKhuVuc, KQLoi);
            dangNhapThanhCong.TearDown();
        }
        #region bộ dữ liệu test
        static IEnumerable<object[]> TestData_DatHang()
        {
            #region Thông tin thiếu
            yield return new Object[] { string.Empty, "tuhueson@gmail", "0938252793", "140 Lê Trọng Tấn", "Vui lòng nhập đầy đủ thông tin!" };
            yield return new Object[] { "Lư Phước Toàn", string.Empty, "0786147068", "140 Lê Trọng Tấn", "Vui lòng nhập đầy đủ thông tin!" };
            yield return new Object[] { "Trần Thành Tâm", "tam555969@gmail.com", string.Empty, "140 Lê Trọng Tấn", "Vui lòng nhập đầy đủ thông tin!" };
            yield return new Object[] { "Huỳnh Mỹ Trân", "tinamytran2014@gmail.com", "0867866470", string.Empty, "Vui lòng nhập đầy đủ thông tin!" };
            #endregion

            #region Không nhập khu vực
            yield return new Object[] { "Huỳnh Mỹ Trân", "tinamytran2014@gmail.com", "0867866470", "140 Lê Trọng Tấn", "Vui lòng chọn tỉnh/thành", 0 };
            yield return new Object[] { "Huỳnh Mỹ Trân", "tinamytran2014@gmail.com", "0867866470", "140 Lê Trọng Tấn", "Vui lòng chọn quận/huyện", 1 };
            yield return new Object[] { "Huỳnh Mỹ Trân", "tinamytran2014@gmail.com", "0867866470", "140 Lê Trọng Tấn", "Vui lòng chọn xã/phường", 2 };
            #endregion

            #region Nhập sai định email
            yield return new Object[] { "Nguyễn Trung Hậu", "trunghau123h@gmail", "0833424890", "140 Lê Trọng Tấn", "Email không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Trung Hậu", "trunghau123h@", "0833424890", "140 Lê Trọng Tấn", "Email không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Trung Hậu", "trunghau123h@@gmail.com", "0833424890", "140 Lê Trọng Tấn", "Email không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Trung Hậu", "trunghau123h@..gmail.com", "0833424890", "140 Lê Trọng Tấn", "Email không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Trung Hậu", "tr@unghau123h@gmail.com", "0833424890", "140 Lê Trọng Tấn", "Email không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Nguyễn Trung Hậu", ".trunghau123h@gmail.com", "0833424890", "140 Lê Trọng Tấn", "Email không hợp lệ.Vui lòng nhập lại." };
            #endregion

            #region Nhập sai định dạng số điện thoại
            yield return new Object[] { "Lê Đức Tài", "093letai654@gmail.com", "093860865", "140 Lê Trọng Tấn", "Số điện thoại không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Lê Đức Tài", "093letai654@gmail.com", "A093860865", "140 Lê Trọng Tấn", "Số điện thoại không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Lê Đức Tài", "093letai654@gmail.com", "$093860865", "140 Lê Trọng Tấn", "Số điện thoại không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Lê Đức Tài", "093letai654@gmail.com", "09386086511", "140 Lê Trọng Tấn", "Số điện thoại không hợp lệ.Vui lòng nhập lại." };
            yield return new Object[] { "Lê Đức Tài", "093letai654@gmail.com", "9386086511", "140 Lê Trọng Tấn", "Số điện thoại không hợp lệ.Vui lòng nhập lại." };
            #endregion

            yield return new Object[] { "Trần Thành Tâm", "tam555969@gmail.com", "0965320412", "140 Lê Trọng Tấn" };

        }
        #endregion
    }
}
