USE master
IF EXISTS(SELECT * FROM sys.databases WHERE name='WEBBANMP')
BEGIN
        DROP DATABASE WEBBANMP
END
CREATE DATABASE WEBBANMP
GO
USE WEBBANMP
GO

-- tạo bảng
-- GR ADMIN(00): CONTROL ALL
-- GR NHÂN VIÊN(01): HỖ TRỢ KHÁCH HÀNG XỬ LÝ ĐƠN HÀNG
-- GR KHÁCH HÀNG(02): NGƯỜI DÙNG
CREATE TABLE GRTK (
    ID INT IDENTITY NOT NULL,
    TEN NVARCHAR(50), -- TÊN GR
    CODEGR CHAR(2),
    CONSTRAINT PK_GR PRIMARY KEY (ID) 
)
CREATE TABLE TAIKHOAN (
    ID VARCHAR(15) NOT NULL, -- CREATE AUTO
    USERNAME VARCHAR(50), -- CHECK USERNAME THEO GROUP
    PW VARBINARY(50), -- MÃ HÓA + salt
    ID_GR INT REFERENCES GRTK(ID),
    CONSTRAINT PK_TK PRIMARY KEY (ID)
)
CREATE TABLE THONGTINTAIKHOAN (
    ID VARCHAR(20) NOT NULL, -- CREATE AUTO
    HOTEN NVARCHAR(50), -- HỌ TÊN
    NGSINH DATE, -- NGÀY SINH
    GTINH BIT, -- 1: NAM, 0: NỮ, NULL: CHƯA BIẾT(QUY VỀ 0)
    NGTAO DATE, -- NGÀY TẠO
    EMAIL VARCHAR(50), -- ĐỊA CHỈ EMAIL
    SDT VARCHAR(11), -- SDT
    DCHI NVARCHAR(50), -- ĐỊA CHỈ NHÀ / ĐỊA CHỈ GIAO
    ID_TAIKHOAN VARCHAR(15) REFERENCES TAIKHOAN(ID),
    CONSTRAINT PK_TTTK PRIMARY KEY (ID)
)
CREATE TABLE KHACHHANG (
    ID VARCHAR(10) NOT NULL, -- CREATE AUTO
    ID_TK VARCHAR(15),
    CONSTRAINT PK_KH PRIMARY KEY (ID),
    CONSTRAINT FK_KH_TK FOREIGN KEY (ID_TK) REFERENCES TAIKHOAN(ID)
)
CREATE TABLE NHANVIEN (
    ID VARCHAR(10) NOT NULL, -- CREATE AUTO
    ID_TK VARCHAR(15),
    CONSTRAINT PK_NV PRIMARY KEY (ID),
    CONSTRAINT FK_NV_TK FOREIGN KEY (ID_TK) REFERENCES TAIKHOAN(ID)
)
CREATE TABLE LOAISP ( -- _________________________________
    ID VARCHAR(6) NOT NULL,
    TENLOAI NVARCHAR(50),
    CONSTRAINT PK_LSP PRIMARY KEY (ID)
)
CREATE TABLE DANHMUC (
    ID INT IDENTITY NOT NULL,
    TENDANHMUC NVARCHAR(50),
    CONSTRAINT PK_DMUC PRIMARY KEY (ID)
)
CREATE TABLE CHITIETDANHMUC (
	ID_DANHMUC INT NOT NULL REFERENCES DANHMUC(ID),
	ID_LOAISP VARCHAR(6) NOT NULL REFERENCES LOAISP(ID),
	CONSTRAINT PL_CTTDM PRIMARY KEY (ID_DANHMUC, ID_LOAISP)
)
CREATE TABLE SANPHAM ( -- _________________________________
    ID VARCHAR(5) NOT NULL, -- CREATE AUTO
    TENSP NVARCHAR(100), -- TÊN SẢN PHẨM
    MOTA NVARCHAR(MAX), -- MÔ TẢ
    SOLUONG INT, -- SỐ LƯỢNG TỒN KHO
    -- DONGIA FLOAT, -- ĐƠN GIÁ
    NSX NVARCHAR(30), -- NHÀ SẢN XUẤT
    HINHANH VARCHAR(50),
    ID_LOAI VARCHAR(6) REFERENCES LOAISP(ID),
    CONSTRAINT PK_SP PRIMARY KEY (ID)
)
CREATE TABLE SALE (
    ID INT IDENTITY NOT NULL,
    GIATRI FLOAT, -- GIÁ TRỊ SALE
    ID_SP VARCHAR(5) REFERENCES SANPHAM(ID),
    NGCAPNHAT DATETIME, -- NGÀY CẬP NHẬT SALE LẤY NGÀY GẦN NHẤT
    CONSTRAINT PK_SALE PRIMARY KEY (ID)
)
CREATE TABLE DONGIA (
    ID INT IDENTITY NOT NULL,
    ID_SP VARCHAR(5) REFERENCES SANPHAM(ID),
    GIA FLOAT, -- GIÁ
    NGCAPNHAT DATETIME, -- NGÀY CẬP NHẬT - LẤY NGÀY MỚI NHẤT
    CONSTRAINT PK_DG PRIMARY KEY (ID, ID_SP)
)
CREATE TABLE HOADON (
    ID VARCHAR(10) NOT NULL, -- CREATE AUTO
    NGTAO DATE, -- NGÀY TẠO HÓA ĐƠN
    DONGIA FLOAT, -- TỔNG (SỐ LƯỢNG * ĐƠN GIÁ)
    TINHTRANG NVARCHAR(50), -- CHƯA GIAO, ĐÃ GIAO
    ID_KH VARCHAR(10) REFERENCES KHACHHANG(ID),
    ID_NV VARCHAR(10) REFERENCES NHANVIEN(ID),
    CONSTRAINT PK_HD PRIMARY KEY (ID)
)
CREATE TABLE CHITIETHD (
    ID INT IDENTITY NOT NULL,
    ID_HD VARCHAR(10) REFERENCES HOADON(ID),
    ID_SP VARCHAR(5) REFERENCES SANPHAM(ID),
    SOLUONG INT, -- SỐ LƯỢNG > 0, số lượng bán
    CONSTRAINT PK_CTHD PRIMARY KEY (ID, ID_HD) 
)
CREATE TABLE PHIEUNHAP (
    ID VARCHAR(10) NOT NULL, -- CREATE AUTO
    NGTAO DATE, -- NGÀY TẠO PHIẾU NHẬP
    DONGIA FLOAT, -- TỔNG (SỐ LƯỢNG * ĐƠN GIÁ)
    ID_KH VARCHAR(10) REFERENCES KHACHHANG(ID),
    CONSTRAINT PK_PN PRIMARY KEY (ID)
)
CREATE TABLE CHITIETPN (
    ID INT IDENTITY NOT NULL,
    ID_PN VARCHAR(10) REFERENCES PHIEUNHAP(ID),
    ID_SP VARCHAR(5) REFERENCES SANPHAM(ID),
    SOLUONG INT, -- SỐ LƯỢNG > 0, số lượng bán
    CONSTRAINT PK_CTPN PRIMARY KEY (ID, ID_PN) 
)
CREATE TABLE THONGKETRUYCAP (
    ID INT IDENTITY NOT NULL,
    ISONL BIT, -- KIỂM TRA CÒN ONL - DEFAULT: 1(ON)
    NGGHI DATETIME, -- NGÀY GHI NHẬN
    NGOFF DATETIME, -- KHI NGƯỜI DÙNG KẾT THÚC PHIÊN
    CONSTRAINT PK_TKTC PRIMARY KEY (ID)   
)
GO

-- CREATE TABLE VIEW 
CREATE VIEW rndVIEW
AS
SELECT RAND() rndResult
GO

----------------------------------------------------------
--  ___   Proc                     _   ___   Func       --
-- | _ \_ _ ___  __   __ _ _ _  __| | | __|  _ _ _  __  --
-- |  _/ '_/ _ \/ _| / _` | ' \/ _` | | _| || | ' \/ _| --
-- |_| |_| \___/\__| \__,_|_||_\__,_| |_| \_,_|_||_\__| --
----------------------------------------------------------

-- function
CREATE FUNCTION fn_hash(@text VARCHAR(50))
RETURNS VARBINARY(MAX)
AS
BEGIN
	RETURN HASHBYTES('SHA2_256', @text);
END
GO

CREATE FUNCTION fn_getRandom ( -- TRẢ VỀ 1 SỐ NGẪU NHIÊN
	@min int, 
	@max int
)
RETURNS INT
AS
BEGIN
    RETURN FLOOR((SELECT rndResult FROM rndVIEW) * (@max - @min + 1) + @min);
END
GO

CREATE FUNCTION fn_getCodeGr(@tenGr VARCHAR(50)) -- TRẢ VỀ CODE GR
RETURNS CHAR(2)
AS
BEGIN
    DECLARE @CODEGR CHAR(2)
    SELECT @CODEGR = CODEGR FROM GRTK WHERE TEN = @tenGr

    RETURN @CODEGR
END
GO

CREATE FUNCTION fn_autoIDTK(@TENGR VARCHAR(50)) -- id TÀI KHOẢN
RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @ID VARCHAR(15)
	DECLARE @maCodeGr CHAR(2)
	DECLARE @IDGR INT

    -- LẤY MÃ GR
    SELECT @IDGR=ID, @maCodeGr = CODEGR FROM GRTK WHERE TEN = @TENGR

	IF (SELECT COUNT(ID) FROM TAIKHOAN WHERE ID_GR = @IDGR) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(ID, 3)) FROM TAIKHOAN WHERE ID_GR = @IDGR

    DECLARE @ngayTao VARCHAR(8) = convert(VARCHAR, getdate(), 112) -- format yyyymmdd
    DECLARE @stt VARCHAR(5) = CONVERT(VARCHAR, CONVERT(INT, @ID) + 1)

	SELECT @ID = CASE
		WHEN @ID >=  0 and @ID < 9 THEN @ngayTao + @maCodeGr + '00' + @stt
		WHEN @ID >=  9 THEN @ngayTao + @maCodeGr + '0' + @stt
		WHEN @ID >= 99 THEN @ngayTao + @maCodeGr + @stt
	END

	RETURN @ID
END
GO

CREATE FUNCTION fn_autoIDKH() -- id KHÁCH HÀNG
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @ID VARCHAR(10)

	IF (SELECT COUNT(ID) FROM KHACHHANG) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(ID, 3)) FROM KHACHHANG

    DECLARE @stt VARCHAR(5) = CONVERT(VARCHAR, CONVERT(INT, @ID) + 1)
    DECLARE @maCode CHAR(2) = 'KH'

	SELECT @ID = CASE
		WHEN @ID >=  0 and @ID < 9 THEN @maCode + '00' + @stt
		WHEN @ID >=  9 THEN @maCode + '0' + @stt
		WHEN @ID >= 99 THEN @maCode + @stt
	END

	RETURN @ID
END
GO

CREATE FUNCTION fn_autoIDNV() -- id NHÂN VIÊN
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @ID VARCHAR(10)

	IF (SELECT COUNT(ID) FROM NHANVIEN) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(ID, 3)) FROM NHANVIEN

    DECLARE @stt VARCHAR(5) = CONVERT(VARCHAR, CONVERT(INT, @ID) + 1)
    DECLARE @maCode CHAR(2) = 'NV'

	SELECT @ID = CASE
		WHEN @ID >=  0 and @ID < 9 THEN @maCode + '00' + @stt
		WHEN @ID >=  9 THEN @maCode + '0' + @stt
		WHEN @ID >= 99 THEN @maCode + @stt
	END

	RETURN @ID
END
GO

CREATE FUNCTION fn_autoIDHD() -- id HÓA ĐƠN
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @ID VARCHAR(10)

	IF (SELECT COUNT(ID) FROM HOADON) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(ID, 3)) FROM HOADON

    DECLARE @stt VARCHAR(5) = CONVERT(VARCHAR, CONVERT(INT, @ID) + 1)
    DECLARE @maCode CHAR(2) = 'HD'

	SELECT @ID = CASE
		WHEN @ID >=  0 and @ID < 9 THEN @maCode + '00' + @stt
		WHEN @ID >=  9 THEN @maCode + '0' + @stt
		WHEN @ID >= 99 THEN @maCode + @stt
	END

	RETURN @ID
END
GO

CREATE FUNCTION fn_autoIDLSP() -- id LOẠI SP 
RETURNS VARCHAR(6)
AS
BEGIN
	DECLARE @ID VARCHAR(6)

	IF (SELECT COUNT(ID) FROM LOAISP) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(ID, 3)) FROM LOAISP

    DECLARE @stt VARCHAR(3) = CONVERT(VARCHAR, CONVERT(INT, @ID) + 1)
    DECLARE @maCode CHAR(3) = 'LSP'

	SELECT @ID = CASE
		WHEN @ID >=  0 and @ID < 9 THEN @maCode + '00' + @stt
		WHEN @ID >=  9 THEN @maCode + '0' + @stt
		WHEN @ID >= 99 THEN @maCode + @stt
	END

	RETURN @ID
END
GO

CREATE FUNCTION fn_autoIDSP() -- id SP
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)

	IF (SELECT COUNT(ID) FROM SANPHAM) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(ID, 3)) FROM SANPHAM

    DECLARE @stt VARCHAR(3) = CONVERT(VARCHAR, CONVERT(INT, @ID) + 1)
    DECLARE @maCode CHAR(2) = 'SP'

	SELECT @ID = CASE
		WHEN @ID >=  0 and @ID < 9 THEN @maCode + '00' + @stt
		WHEN @ID >=  9 THEN @maCode + '0' + @stt
		WHEN @ID >= 99 THEN @maCode + @stt
	END

	RETURN @ID
END
GO

CREATE FUNCTION fn_autoIDTTND(
    @idLogin VARCHAR(15)
) -- id CỦA THÔNG TIN NGƯỜI DÙNG: IDLOGIN + mã rand
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @randNumber INT = DBO.fn_getRandom(100, 999)
    
    DECLARE @ID VARCHAR(20) = @idLogin + convert(CHAR, @randNumber)

	RETURN @ID
END
GO
-- proc 
CREATE PROC sp_getIDDMUC
@tenDMuc NVARCHAR(50)
AS
    DECLARE @IDDM INT
    SELECT @IDDM = ID FROM DANHMUC WHERE TENDANHMUC = @tenDMuc

    RETURN @IDDM
GO


CREATE PROC sp_getIDGR -- TRẢ VỀ ID GR
@tenGr NVARCHAR(50)
AS
    DECLARE @IDGR INT
    SELECT @IDGR = ID FROM GRTK WHERE TEN = @tenGr

    RETURN @IDGR 
GO

CREATE PROC sp_GetErrorInfo  
AS  
SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;
GO 

CREATE PROC sp_AddDMUC
@tenDanhMuc NVARCHAR(50)
AS
    BEGIN TRY
		IF EXISTS(SELECT * FROM DANHMUC WHERE TENDANHMUC = @tenDanhMuc)
			THROW 51000, N'Tên danh mục đã tồn tại.', 1;
		
		INSERT DANHMUC
		SELECT @tenDanhMuc
	END TRY
	BEGIN CATCH
		EXEC sp_GetErrorInfo;
	END CATCH
GO

CREATE PROC sp_AddLSP -- THÊM LOẠI SP
@tenLSP NVARCHAR(50),
@tenDanhMuc NVARCHAR(50)
AS 
    BEGIN TRY
        DECLARE @idDanhMuc INT
        EXEC @idDanhMuc = sp_getIDDMUC @tenDanhMuc

        IF EXISTS(SELECT * FROM CHITIETDANHMUC WHERE ID_DANHMUC = @idDanhMuc AND ID_LOAISP = (SELECT ID FROM LOAISP WHERE TENLOAI = @tenLSP))
			THROW 51000, N'Loại sản phẩm đã tồn tại.', 1;

		DECLARE @IDLSP VARCHAR(6) = DBO.fn_autoIDLSP()
		
		INSERT LOAISP
		SELECT @IDLSP, UPPER(@tenLSP); 

		INSERT CHITIETDANHMUC
		SELECT @idDanhMuc, @IDLSP
	END TRY
	BEGIN CATCH
		EXEC sp_GetErrorInfo;
	END CATCH
GO

--ID VARCHAR(5) NOT NULL, -- CREATE AUTO
--TENSP NVARCHAR(50), -- TÊN SẢN PHẨM
--MOTA NVARCHAR(MAX), -- MÔ TẢ
--SOLUONG INT, -- SỐ LƯỢNG TỒN KHO
---- DONGIA FLOAT, -- ĐƠN GIÁ
--NSX NVARCHAR(30), -- NHÀ SẢN XUẤT
--HINHANH VARCHAR(50),
--ID_LOAI VARCHAR(6) REFERENCES LOAISP(ID),
CREATE PROC sp_AddSP
@tenSP NVARCHAR(50),
@moTa NVARCHAR(MAX),
@soLuong INT,
@gia FLOAT,
@nxs NVARCHAR(30),
@urlImage VARCHAR(50),
@tenLSP NVARCHAR(50)
AS
	BEGIN TRY
		DECLARE @IDSP VARCHAR(15) = DBO.fn_autoIDSP() -- id SP

		IF EXISTS(SELECT * FROM SANPHAM WHERE TENSP = @tenSP)
			THROW 51000, N'Sản phẩm đã tồn tại.', 1;

		DECLARE @IDLSP VARCHAR(6)
		SELECT @IDLSP = ID FROM LOAISP WHERE TENLOAI = @tenLSP
		
		INSERT SANPHAM(ID, TENSP, MOTA, SOLUONG, NSX, HINHANH, ID_LOAI)
		VALUES (@IDSP, @tenSP, @moTa, @soLuong, @nxs, @urlImage, @IDLSP)

		INSERT DONGIA(ID_SP, GIA)
		VALUES (@IDSP, @gia)
	END TRY
	BEGIN CATCH
		EXEC sp_GetErrorInfo;
	END CATCH
GO

-- ID VARCHAR(20)
-- HOTEN NVARCHAR(50), -- HỌ TÊN
-- NGSINH DATE, -- NGÀY SINH
-- GTINH BIT, -- 1: NAM, 0: NỮ, NULL: CHƯA BIẾT(QUY VỀ 0)
-- NGTAO DATE, -- NGÀY TẠO
-- EMAIL VARCHAR(50), -- ĐỊA CHỈ EMAIL
-- SDT VARCHAR(11), -- SDT
-- DCHI NVARCHAR(50)
CREATE PROC sp_AddAcc
@userName VARCHAR(50), -- THÔNG TIN TÀI KHOẢN
@pw VARCHAR(50),
@GRNAME NVARCHAR(50),
@hoTen NVARCHAR(50),
@ngSinh DATE,
@gioiTinh NVARCHAR(5),
@email VARCHAR(50),
@sdt VARCHAR(11),
@dChi NVARCHAR(50)
AS
	BEGIN TRY
		DECLARE @ID VARCHAR(15) = DBO.fn_autoIDTK(@GRNAME) -- id login

		DECLARE	@createPW VARBINARY(MAX) = SubString(DBO.fn_hash(@ID), 1, len(DBO.fn_hash(@ID))/2) + DBO.fn_hash(@pw + @ID)

		DECLARE @IDGR INT
		EXEC @IDGR = sp_getIDGR @GRNAME -- id gr

        IF (UPPER(@GRNAME) = N'KHÁCH HÀNG')
        BEGIN
            SET @userName = NULL;
            SET @createPW = NULL;
        END

		IF EXISTS(SELECT * FROM TAIKHOAN WHERE ID_GR = @IDGR AND USERNAME = @userName)
			THROW 51000, N'Username đã tồn tại.', 1;

		-- tạo tài khoản
		INSERT TAIKHOAN
		SELECT @ID, @userName, @createPW, @IDGR; 

        DECLARE @GTINH BIT = 0
        IF (UPPER(@gioiTinh) = N'NAM')
            SET @GTINH = 1;

        -- tạo thông tin người dùng
        INSERT THONGTINTAIKHOAN(ID, HOTEN, NGSINH, GTINH, EMAIL, SDT, DCHI, ID_TAIKHOAN)
        VALUES(DBO.fn_autoIDTTND(@ID), UPPER(@hoTen), @ngSinh, @GTINH, @email, @sdt, @dChi, @ID)
	END TRY
	BEGIN CATCH
		EXEC sp_GetErrorInfo;
	END CATCH
GO

-- TẠO RÀNG BUỘC
ALTER TABLE THONGTINTAIKHOAN
ADD CONSTRAINT DF_NGTAO_TTTK DEFAULT GETDATE() FOR NGTAO

ALTER TABLE DONGIA
ADD CONSTRAINT DF_NGCAPNHAT_DG DEFAULT GETDATE() FOR NGCAPNHAT

ALTER TABLE SALE
ADD CONSTRAINT DF_NGCAPNHAT_S DEFAULT GETDATE() FOR NGCAPNHAT

ALTER TABLE KHACHHANG
ADD CONSTRAINT DF_ID_KH DEFAULT DBO.fn_autoIDKH() FOR ID

ALTER TABLE NHANVIEN 
ADD CONSTRAINT DF_ID_NV DEFAULT DBO.fn_autoIDNV() FOR ID

ALTER TABLE HOADON 
ADD CONSTRAINT DF_NGTAO_HD DEFAULT GETDATE() FOR NGTAO,
    CONSTRAINT DF_TT DEFAULT N'CHƯA GIAO' FOR TINHTRANG,
    CONSTRAINT DF_ID DEFAULT DBO.fn_autoIDHD() FOR ID

ALTER TABLE CHITIETHD
ADD CONSTRAINT CK_SL CHECK (SOLUONG > 0)

ALTER TABLE THONGKETRUYCAP
ADD CONSTRAINT DF_NGGHI DEFAULT GETDATE() FOR NGGHI,
    CONSTRAINT DF_ISONL DEFAULT 1 FOR ISONL

GO

--------------------------------
--  ___           _   data    --
-- |   \   __ _  | |_   __ _  --
-- | |) | / _` | |  _| / _` | --
-- |___/  \__,_|  \__| \__,_| --
--------------------------------

-- BẢNG TB_GRTK
INSERT GRTK VALUES(N'ADMIN', '00')
INSERT GRTK VALUES(N'NHÂN VIÊN', '01')
INSERT GRTK VALUES(N'KHÁCH HÀNG', '02')

-- BẢNG TAIKHOAN
EXEC sp_AddAcc 'admin', 'admin@123456789', N'ADMIN', N'Admin', '2-5-2001', N'nam', 'admin@gmail.com', '000000000', null
EXEC sp_AddAcc 'tuhueson', 'tuhueson@123456789', N'Nhân viên', N'Từ Huệ Sơn', '2-5-2001', N'nam', 'tuhueson@gmail.com', '000000000', null
EXEC sp_AddAcc 'leductai', 'leductai@123456789', N'Nhân viên', N'Lê Đức Tài', '12-4-2001', N'nam', 'leductai@gmail.com', '000000000', null
EXEC sp_AddAcc 'huynhmytran', 'huynhmytran@123456789', N'Nhân viên', N'Huỳnh Mỹ Trân', '9-2-2001', N'nữ', 'huynhmytran@gmail.com', '000000000', null
EXEC sp_AddAcc 'tranthanhtam', 'tranthanhtam@123456789', N'Nhân viên', N'Trần Thành Tâm', '12-21-2001', N'nam', 'tranthanhtam@gmail.com', '000000000', null

-- BẢNG DANH MỤC
EXEC sp_AddDMUC N'Chăm sóc da' 
EXEC sp_AddDMUC N'Chăm sóc cơ thể' 
EXEC sp_AddDMUC N'Chăm sóc tóc' 
EXEC sp_AddDMUC N'Trang điểm' 

-- BẢNG LOẠI SP
-- chăm sóc da
EXEC sp_AddLSP N'Tẩy trang', N'Chăm sóc da'
EXEC sp_AddLSP N'Sữa rửa mặt', N'Chăm sóc da'
EXEC sp_AddLSP N'Tẩy tế bào chết', N'Chăm sóc da'
EXEC sp_AddLSP N'Toner', N'Chăm sóc da'
EXEC sp_AddLSP N'Serum', N'Chăm sóc da'
EXEC sp_AddLSP N'Kem dưỡng', N'Chăm sóc da'
EXEC sp_AddLSP N'Dưỡng mắt', N'Chăm sóc da'
EXEC sp_AddLSP N'Son dưỡng', N'Chăm sóc da'
EXEC sp_AddLSP N'Xịt khoáng', N'Chăm sóc da'
EXEC sp_AddLSP N'Mặt nạ', N'Chăm sóc da'
EXEC sp_AddLSP N'Chống nắng', N'Chăm sóc da'
-- chăm sóc cơ thể
EXEC sp_AddLSP N'Sữa tắm', N'Chăm sóc cơ thể'
EXEC sp_AddLSP N'Tẩy tế bào chết', N'Chăm sóc cơ thể'
EXEC sp_AddLSP N'Lotion', N'Chăm sóc cơ thể'
EXEC sp_AddLSP N'Kem dưỡng da tay', N'Chăm sóc cơ thể'
EXEC sp_AddLSP N'Sản phẩm khử mùi', N'Chăm sóc cơ thể'
EXEC sp_AddLSP N'Nước hoa', N'Chăm sóc cơ thể'
-- Chăm sóc tóc
EXEC sp_AddLSP N'Dầu gội', N'Chăm sóc tóc'
EXEC sp_AddLSP N'Dầu xả', N'Chăm sóc tóc'
EXEC sp_AddLSP N'Kem ủ tóc', N'Chăm sóc tóc'
EXEC sp_AddLSP N'Đặc trị tóc', N'Chăm sóc tóc'
EXEC sp_AddLSP N'Nhuộm tóc', N'Chăm sóc tóc'
-- Trang điểm
EXEC sp_AddLSP N'Kem lót', N'Trang điểm'
EXEC sp_AddLSP N'Kem nền', N'Trang điểm'
EXEC sp_AddLSP N'Che khuyết điểm', N'Trang điểm'
EXEC sp_AddLSP N'Phấn phủ', N'Trang điểm'
EXEC sp_AddLSP N'Tạo khối', N'Trang điểm'
EXEC sp_AddLSP N'Kẻ chân mày', N'Trang điểm'
EXEC sp_AddLSP N'Phấn mắt', N'Trang điểm'
EXEC sp_AddLSP N'Kẻ mắt', N'Trang điểm'
EXEC sp_AddLSP N'Mascara', N'Trang điểm'
EXEC sp_AddLSP N'Má hồng', N'Trang điểm'
EXEC sp_AddLSP N'Son thỏi', N'Trang điểm'
EXEC sp_AddLSP N'Son kem', N'Trang điểm'

-- BẢNG SẢN PHẨM
-- EXEC sp_AddSP N'TÊN SP', N'MÔ TẢ', 5, 1000000, N'NHÀ SẢN XUẤT', 'URL_IMAGE', N'Tẩy trang'

--Chăm sóc da
EXEC sp_AddSP N'Nước Tẩy Trang L''Oreal Paris Skincare Make Up Remover Micellar Refreshing Tươi Mát 400ml', N'Làm sạch sâu. Giúp thông thoáng lỗ chân lông. Dưỡng ẩm cho da. Ngăn ngừa mụn. Thúc đẩy quá trình tái tạo tế bào da mới.', 15, 500000, N'Mỹ', 'TayTrang1.jpg', N'Tẩy trang'
EXEC sp_AddSP N'Nước Tẩy trang dưỡng trắng Senka All Clear Water Micellar Formula White (230ml)', N'Làm sạch sâu. Giúp thông thoáng lỗ chân lông. Dưỡng ẩm cho da. Ngăn ngừa mụn. Thúc đẩy quá trình tái tạo tế bào da mới.', 20, 400000, N'Nhật', 'TayTrang2.jpg', N'Tẩy trang'
EXEC sp_AddSP N'Nước Tẩy Trang Dành Cho Da Nhạy Cảm Bioderma Sensibio H20 250ml', N'Làm sạch sâu. Giúp thông thoáng lỗ chân lông. Dưỡng ẩm cho da. Ngăn ngừa mụn. Thúc đẩy quá trình tái tạo tế bào da mới.', 10, 600000, N'Pháp', 'TayTrang3.jpg', N'Tẩy trang'
EXEC sp_AddSP N'Nước Làm Sạch Sâu Và Tẩy Trang La Roche-Posay Dành Cho Da Nhạy Cảm 400ml', N'Làm sạch sâu. Giúp thông thoáng lỗ chân lông. Dưỡng ẩm cho da. Ngăn ngừa mụn. Thúc đẩy quá trình tái tạo tế bào da mới.', 12, 450000, N'Pháp', 'TayTrang4.jpg', N'Tẩy trang'
EXEC sp_AddSP N'Nước Tẩy Trang Cocoon Rose Hoa Hồng Làm Sạch Da Và Cấp Ẩm 500ml', N'Làm sạch sâu. Giúp thông thoáng lỗ chân lông. Dưỡng ẩm cho da. Ngăn ngừa mụn. Thúc đẩy quá trình tái tạo tế bào da mới.', 16, 230000, N'Việt Nam', 'TayTrang5.jpg', N'Tẩy trang'
EXEC sp_AddSP N'Nước Tẩy trang Yves Rocher Pure Blue Gentle Makeup Remover 200ml', N'Làm sạch sâu. Giúp thông thoáng lỗ chân lông. Dưỡng ẩm cho da. Ngăn ngừa mụn. Thúc đẩy quá trình tái tạo tế bào da mới.', 22, 550000, N'Mỹ', 'TayTrang6.jpg', N'Tẩy trang'

EXEC sp_AddSP N'Sữa Rửa Mặt Cosrx Pure Fit Cica Cleanser 150ml', N'Tác dụng hỗ trợ ngăn ngừa và điều trị mụn. Se khít lỗ chân lông.Cân bằng độ ẩm cho da. Giúp da hấp thu dưỡng chất tốt hơn trong các bước dưỡng sau đó', 10, 500000, N'Mỹ', 'Srm1.jpg', N'Sữa rửa mặt'
EXEC sp_AddSP N'Gel Rửa Mặt Cosrx Good Morning Low PH Cleanser 150ml', N'Tác dụng hỗ trợ ngăn ngừa và điều trị mụn. Se khít lỗ chân lông.Cân bằng độ ẩm cho da. Giúp da hấp thu dưỡng chất tốt hơn trong các bước dưỡng sau đó', 15, 300000, N'Mỹ', 'Srm2.jpg', N'Sữa rửa mặt'
EXEC sp_AddSP N'Sữa Rửa Mặt Làm Sạch Sâu Và Tẩy Da Chết Skinfood Black Sugar Perfect Scrub Foam 180g', N'Tác dụng hỗ trợ ngăn ngừa và điều trị mụn. Se khít lỗ chân lông.Cân bằng độ ẩm cho da. Giúp da hấp thu dưỡng chất tốt hơn trong các bước dưỡng sau đó', 25, 250000, N'Mỹ', 'Srm3.jpg', N'Sữa rửa mặt'
EXEC sp_AddSP N'Sữa Rửa Mặt Dr. Belmeur Daily Repair Foam Cleanser', N'Tác dụng hỗ trợ ngăn ngừa và điều trị mụn. Se khít lỗ chân lông.Cân bằng độ ẩm cho da. Giúp da hấp thu dưỡng chất tốt hơn trong các bước dưỡng sau đó', 12, 350000, N'Pháp', 'Srm4.jpg', N'Sữa rửa mặt'
EXEC sp_AddSP N'Sữa rửa mặt tạo bọt Cerave Foaming Facial Cleanser', N'Tác dụng hỗ trợ ngăn ngừa và điều trị mụn. Se khít lỗ chân lông.Cân bằng độ ẩm cho da. Giúp da hấp thu dưỡng chất tốt hơn trong các bước dưỡng sau đó', 20, 100000, N'Mỹ', 'Srm5.jpg', N'Sữa rửa mặt'
EXEC sp_AddSP N'Sữa Rửa Mặt Sủi Bọt Some By Mi Bye Blackhead 30Days Greentea Tox Trị Mụn Đầu Đen 120ml', N'Tác dụng hỗ trợ ngăn ngừa và điều trị mụn. Se khít lỗ chân lông.Cân bằng độ ẩm cho da. Giúp da hấp thu dưỡng chất tốt hơn trong các bước dưỡng sau đó', 6, 300000, N'Mỹ', 'Srm6.jpg', N'Sữa rửa mặt'

EXEC sp_AddSP N'Tẩy Da Chết Mặt Cocoon Coffee Face Polish 150ml', N'Làm thông thoáng lỗ chân lông. Ngăn ngừa khuyết điểm trên da. Tẩy da chết làm đều màu da', 15, 100000, N'Việt Nam', 'TBC1.jpg', N'Tẩy tế bào chết'
EXEC sp_AddSP N'Tẩy Tế Bào Chết Naruko Tea Tree', N'Làm thông thoáng lỗ chân lông. Ngăn ngừa khuyết điểm trên da. Tẩy da chết làm đều màu da', 12, 200000, N'Mỹ', 'TBC2.jpg', N'Tẩy tế bào chết'
EXEC sp_AddSP N'Tẩy Da Chết Huxley Secret Of Sahara Scrub Mask', N'Làm thông thoáng lỗ chân lông. Ngăn ngừa khuyết điểm trên da. Tẩy da chết làm đều màu da', 22, 300000, N'Pháp', 'TBC3.jpg', N'Tẩy tế bào chết'
EXEC sp_AddSP N'Gel tẩy tế bào chết Bioderma cho làn da thanh khiết và mịn màng hơn.', N'Làm thông thoáng lỗ chân lông. Ngăn ngừa khuyết điểm trên da. Tẩy da chết làm đều màu da', 10, 250000, N'Anh', 'TBC4.jpg', N'Tẩy tế bào chết'
EXEC sp_AddSP N'Tẩy Tế Bào Chết Da Mặt Rosette Peeling Gel', N'Làm thông thoáng lỗ chân lông. Ngăn ngừa khuyết điểm trên da. Tẩy da chết làm đều màu da', 6, 150000, N'Nhật', 'TBC5.jpg', N'Tẩy tế bào chết'
EXEC sp_AddSP N'Gel Tẩy Da Chết Mamonde Aqua Peel Peeling Gel Plum Blossom 100ml', N'Làm thông thoáng lỗ chân lông. Ngăn ngừa khuyết điểm trên da. Tẩy da chết làm đều màu da', 8, 400000, N'Hàn Quốc', 'TBC6.jpg', N'Tẩy tế bào chết'

EXEC sp_AddSP N'Toner Some By Mi Super Matcha Pore Tightening Cải Thiện Làn Da 150ml', N'Dưỡng ẩm. Làm sáng da', 15, 160000, N'Hàn Quốc', 'Toner1.jpg', N'Toner'
EXEC sp_AddSP N'Dung Dịch Trị Mụn Obagi Medical Salicylic Acid', N'Dưỡng ẩm. Làm sáng da', 25, 400000, N'Mỹ', 'Toner2.jpg', N'Toner'
EXEC sp_AddSP N'Nước Hoa Hồng I''m from Chiết Xuất Gạo Dưỡng Sáng Da 150ml', N'Dưỡng ẩm. Làm sáng da', 12, 300000, N'Hàn Quốc', 'Toner3.jpg', N'Toner'
EXEC sp_AddSP N'Nước Hoa Hồng Muji Moisture Toner 200ml', N'dDưỡng ẩm. Làm sáng da', 10, 200000, N'Nhật', 'Toner4.jpg', N'Toner'
EXEC sp_AddSP N'Nước Hoa Hồng Không Cồn Thayers Cucumber 355ml', N'Dưỡng ẩm. Làm sáng da', 8, 2300000, N'Mỹ', 'Toner5.jpg', N'Toner'
EXEC sp_AddSP N'Nước hoa hồng Skin1004 Madagascar Centella Toning Toner 210ml', N'Dưỡng ẩm. Làm sáng da', 9, 100000, N'Hàn Quốc', 'Toner6.jpg', N'Toner'

EXEC sp_AddSP N'Tinh Chất Làm Dịu Da COSRX PURE FIT CICA SERUM 30ml', N'Chống lão hóa. hạn chế nếp nhăn và tình trạng chảy xệ của da.', 10, 180000, N'Hàn Quốc', 'Serum1.jpg', N'Serum'
EXEC sp_AddSP N'Tinh Chất The Ordinary Hyaluronic Acid 2% + B5', N'Chống lão hóa. hạn chế nếp nhăn và tình trạng chảy xệ của da.', 14, 160000, N'Canada', 'Serum2.jpg', N'Serum'
EXEC sp_AddSP N'Tinh Chất The Ordinary Amino Acids + B5', N'Chống lão hóa. Hạn chế nếp nhăn và tình trạng chảy xệ của da.', 23, 200000, N'Canada', 'Serum3.jpg', N'Serum'
EXEC sp_AddSP N'Tinh Chất Some By Mi Trị Mụn Và Dưỡng Da 30 Ngày Miracle Serum 50ml', N'Chống lão hóa. Hạn chế nếp nhăn và tình trạng chảy xệ của da.', 21, 400000, N'Hàn Quốc', 'Serum4.jpg', N'Serum'
EXEC sp_AddSP N'Tinh Chất Dưỡng Ẩm Chiết Xuất Xương Rồng Huxley Essence; Grab Water 30ml', N'Chống lão hóa. Hạn chế nếp nhăn và tình trạng chảy xệ của da.', 11, 300000, N'Hàn Quốc', 'Serum5.jpg', N'Serum'
EXEC sp_AddSP N'Tinh chất rau má trị mụn Skin1004 Madagascar Centella Ampoule', N'Chống lão hóa. Hạn chế nếp nhăn và tình trạng chảy xệ của da.', 16, 230000, N'Hàn Quốc', 'Serum6.jpg', N'Serum'

EXEC sp_AddSP N'Kem Dưỡng Ngải Cứu I''m From Mugwort Cream', N'Ngăn ngừa khô da. Làm chậm tiến trình lão hóa. Ngăn ngừa và hỗ trợ điều trị mụn. Bảo vệ da khỏi các tác nhân bên ngoài. Ngăn ngừa kích ứng da. Kiểm soát dầu thừa hiệu quả', 15, 1000000, N'Hàn Quốc', 'KemDuong1.jpg', N'Kem dưỡng'
EXEC sp_AddSP N'Kem Dưỡng Da I''M From Honey Glow Cream', N'Ngăn ngừa khô da. Làm chậm tiến trình lão hóa. Ngăn ngừa và hỗ trợ điều trị mụn. Bảo vệ da khỏi các tác nhân bên ngoài. Ngăn ngừa kích ứng da. Kiểm soát dầu thừa hiệu quả', 12, 2000000, N'Anh', 'KemDuong2.jpg', N'Kem dưỡng'
EXEC sp_AddSP N'Kem Dưỡng Cosrx Snail 92 All In One Cream', N'Ngăn ngừa khô da. Làm chậm tiến trình lão hóa. Ngăn ngừa và hỗ trợ điều trị mụn. Bảo vệ da khỏi các tác nhân bên ngoài. Ngăn ngừa kích ứng da. Kiểm soát dầu thừa hiệu quả', 22, 3000000, N'Pháp', 'KemDuong3.jpg', N'Kem dưỡng'
EXEC sp_AddSP N'Kem Dưỡng Cosrx Green Tea Aqua Soothing Gel Cream', N'Ngăn ngừa khô da. Làm chậm tiến trình lão hóa. Ngăn ngừa và hỗ trợ điều trị mụn. Bảo vệ da khỏi các tác nhân bên ngoài. Ngăn ngừa kích ứng da. Kiểm soát dầu thừa hiệu quả', 8, 1500000, N'Nhật', 'KemDuong4.jpg', N'Kem dưỡng'
EXEC sp_AddSP N'Kem Dưỡng Some By Mi Trị Mụn Và Dưỡng Da 30 Ngày Miracle Cream', N'Ngăn ngừa khô da. Làm chậm tiến trình lão hóa. Ngăn ngừa và hỗ trợ điều trị mụn. Bảo vệ da khỏi các tác nhân bên ngoài. Ngăn ngừa kích ứng da. Kiểm soát dầu thừa hiệu quả', 10, 2400000, N'Mỹ', 'KemDuong5.jpg', N'Kem dưỡng'
EXEC sp_AddSP N'Kem Dưỡng Some By Mi Snail Truecica Miracle Repair Cream Phục Hồi Da', N'Ngăn ngừa khô da. Làm chậm tiến trình lão hóa. Ngăn ngừa và hỗ trợ điều trị mụn. Bảo vệ da khỏi các tác nhân bên ngoài. Ngăn ngừa kích ứng da. Kiểm soát dầu thừa hiệu quả', 3, 1200000, N'Nhật', 'KemDuong6.jpg', N'Kem dưỡng'

EXEC sp_AddSP N'Thanh Lăn Trị Thâm Bọng Mắt Eveline Bio Hyaluron 4D', N'là sản phẩm chuyên dùng để chăm sóc cho vùng da quanh mắt, giúp bạn giữ độ ẩm, làm giảm quầng thâm, bọng mắt và cải thiện các vùng da bị nếp nhăn.', 13, 500000, N'Mỹ', 'KemMat1.jpg', N'Dưỡng mắt'
EXEC sp_AddSP N'Kem dưỡng mắt Propolis Essential Eye Cream', N'là sản phẩm chuyên dùng để chăm sóc cho vùng da quanh mắt, giúp bạn giữ độ ẩm, làm giảm quầng thâm, bọng mắt và cải thiện các vùng da bị nếp nhăn.', 20, 500000, N'Nhật', 'KemMat2.jpg', N'Dưỡng mắt'
EXEC sp_AddSP N'Kem Dưỡng Mắt AHC Time Rewind Real Eye Cream', N'là sản phẩm chuyên dùng để chăm sóc cho vùng da quanh mắt, giúp bạn giữ độ ẩm, làm giảm quầng thâm, bọng mắt và cải thiện các vùng da bị nếp nhăn.', 9, 450000, N'Nhật', 'KemMat3.jpg', N'Dưỡng mắt'
EXEC sp_AddSP N'Kem Dưỡng Mắt AHC Youth Lasting Real Eye Cream', N'là sản phẩm chuyên dùng để chăm sóc cho vùng da quanh mắt, giúp bạn giữ độ ẩm, làm giảm quầng thâm, bọng mắt và cải thiện các vùng da bị nếp nhăn.', 15, 300000, N'Pháp', 'KemMat4.jpg', N'Dưỡng mắt'
EXEC sp_AddSP N'Kem Dưỡng Mắt Bioderma Sensibio Eye Contour Gel', N'là sản phẩm chuyên dùng để chăm sóc cho vùng da quanh mắt, giúp bạn giữ độ ẩm, làm giảm quầng thâm, bọng mắt và cải thiện các vùng da bị nếp nhăn.', 23, 400000, N'Mỹ', 'KemMat5.jpg', N'Dưỡng mắt'
EXEC sp_AddSP N'Kem dưỡng giúp giảm nếp nhăn quầng thâm & bọng mắt Vichy Liftactiv Supreme Eyes', N'là sản phẩm chuyên dùng để chăm sóc cho vùng da quanh mắt, giúp bạn giữ độ ẩm, làm giảm quầng thâm, bọng mắt và cải thiện các vùng da bị nếp nhăn.', 14, 300000, N'Canada', 'KemMat6.jpg', N'Dưỡng mắt'

EXEC sp_AddSP N'Son dưỡng Môi Burt''s Bees Beeswax Lip Balm with Vitamin E & Peppermint', N'Dưỡng ẩm và ngăn chặn môi nứt nẻ. Chống lão hóa môi. Ngăn chặn ánh nắng mặt trời làm hại môi', 25, 400000, N'Mỹ', 'LipBalm1.jpg', N'Son dưỡng'
EXEC sp_AddSP N'Son Dưỡng Môi Burt''s Bee Moisturizing Lip Balm Pomegranate', N'Dưỡng ẩm và ngăn chặn môi nứt nẻ. Chống lão hóa môi. Ngăn chặn ánh nắng mặt trời làm hại môi', 15, 500000, N'Mỹ', 'LipBalm2.jpg', N'Son dưỡng'
EXEC sp_AddSP N'Son Dưỡng Môi Burt''s Bees Mango Moisturizing Lip Balm', N'Dưỡng ẩm và ngăn chặn môi nứt nẻ. Chống lão hóa môi. Ngăn chặn ánh nắng mặt trời làm hại môi', 35, 350000, N'Mỹ', 'LipBalm3.jpg', N'Son dưỡng'
EXEC sp_AddSP N'Son Dưỡng Dầu Dừa Cocoon Ben Tre Coconut Lip Balm With Shea Butter & Vitamin E 5g', N'Dưỡng ẩm và ngăn chặn môi nứt nẻ. Chống lão hóa môi. Ngăn chặn ánh nắng mặt trời làm hại môi', 23, 450000, N'Việt Nam', 'LipBalm4.jpg', N'Son dưỡng'
EXEC sp_AddSP N'Son Dưỡng Môi Yves Rocher Hương Cherry', N'Dưỡng ẩm và ngăn chặn môi nứt nẻ. Chống lão hóa môi. Ngăn chặn ánh nắng mặt trời làm hại môi', 14, 410000, N'Pháp', 'LipBalm5.jpg', N'Son dưỡng'
EXEC sp_AddSP N'Son dưỡng DHC Lip Cream', N'Dưỡng ẩm và ngăn chặn môi nứt nẻ. Chống lão hóa môi. Ngăn chặn ánh nắng mặt trời làm hại môi', 15, 230000, N'Nhật', 'LipBalm6.jpg', N'Son dưỡng'

EXEC sp_AddSP N'Nước Xịt Khoáng La Roche-Posay Giúp Làm Dịu & Bảo Vệ Da 50ml', N'Cấp ẩm tức thời. Xịt khoáng làm dịu da. Bảo vệ da khỏi các tác nhân bên ngoài. Xịt khoáng giúp giữ lớp trang điểm bền hơn.Làm sạch da tạm thời.', 15, 300000, N'Anh', 'XitKhoang1.jpg', N'Xịt khoáng'
EXEC sp_AddSP N'Nước Xịt Khoáng Dưỡng Da Vichy Thermale 300ml', N'Cấp ẩm tức thời. Xịt khoáng làm dịu da. Bảo vệ da khỏi các tác nhân bên ngoài. Xịt khoáng giúp giữ lớp trang điểm bền hơn. Làm sạch da tạm thời.', 25, 400000, N'Pháp', 'XitKhoang2.jpg', N'Xịt khoáng'
EXEC sp_AddSP N'Nước Xịt Khoáng Evoluderm Cấp Ẩm Làm Dịu Da 400m', N'Cấp ẩm tức thời. Xịt khoáng làm dịu da. Bảo vệ da khỏi các tác nhân bên ngoài. Xịt khoáng giúp giữ lớp trang điểm bền hơn. Làm sạch da tạm thời.', 12, 350000, N'Pháp', 'XitKhoang3.jpg', N'Xịt khoáng'
EXEC sp_AddSP N'Nước Xịt Khoáng Bioderma Hydrabio Brume 300ml', N'Cấp ẩm tức thời. Xịt khoáng làm dịu da. Bảo vệ da khỏi các tác nhân bên ngoài. Xịt khoáng giúp giữ lớp trang điểm bền hơn. Làm sạch da tạm thời.', 9, 320000, N'Nhật', 'XitKhoang4.jpg', N'Xịt khoáng'
EXEC sp_AddSP N'Nước Xịt Khoáng Avene 300ml ', N'Cấp ẩm tức thời. Xịt khoáng làm dịu da. Bảo vệ da khỏi các tác nhân bên ngoài. Xịt khoáng giúp giữ lớp trang điểm bền hơn. Làm sạch da tạm thời.', 10, 280000, N'Mỹ', 'XitKhoang5.jpg', N'Xịt khoáng'
EXEC sp_AddSP N'Nước Xịt Khoáng Dưỡng Da Bio-Essence Water 300ml', N'Cấp ẩm tức thời. Xịt khoáng làm dịu da. Bảo vệ da khỏi các tác nhân bên ngoài. Xịt khoáng giúp giữ lớp trang điểm bền hơn. Làm sạch da tạm thời.', 22, 290000, N'Hàn Quốc', 'XitKhoang6.jpg', N'Xịt khoáng'

EXEC sp_AddSP N'Mặt Nạ Some By Mi Super Matcha Pore Clean Clay Từ Đất Sét Cải Thiện Vấn Đề Của Da 100g', N'Làm sạch da. Giữ ẩm. Cung cấp dưỡng chất và kết hợp điều trị một số vấn đề về da. Thư giãn', 5, 400000, N'Hàn Quốc', 'MN1.jpg', N'Mặt nạ'
EXEC sp_AddSP N'Mặt Nạ Đất sét Amazon Red Clay', N'Làm sạch da. Giữ ẩm. Cung cấp dưỡng chất và kết hợp điều trị một số vấn đề về da. Thư giãn', 15, 300000, N'Hàn Quốc', 'MN2.jpg', N'Mặt nạ'
EXEC sp_AddSP N'Mặt Nạ Đất Sét Rare Earth Deep Pore Cleansing Masque', N'Làm sạch da. Giữ ẩm. Cung cấp dưỡng chất và kết hợp điều trị một số vấn đề về da. Thư giãn', 25, 250000, N'Anh', 'MN3.jpg', N'Mặt nạ'
EXEC sp_AddSP N'Mặt Nạ BNBG Vita Genic Whitening Jelly Mask Dưỡng Trắng 30ml', N'Làm sạch da. Giữ ẩm. Cung cấp dưỡng chất và kết hợp điều trị một số vấn đề về da. Thư giãn', 19, 290000, N'Hàn Quốc', 'MN4.jpg', N'Mặt nạ'
EXEC sp_AddSP N'Mặt Nạ BNBG Vita Tea Tree Healing Face Mask Pack Thải Độc Da Giảm Mụn 30ml', N'Làm sạch da. Giữ ẩm. Cung cấp dưỡng chất và kết hợp điều trị một số vấn đề về da. Thư giãn', 20, 190000, N'Hàn Quốc', 'MN5.jpg', N'Mặt nạ'
EXEC sp_AddSP N'Mặt Nạ Làm Dịu, Ngừa Mụn Skin1004 Madagascar Centella Watergel Sheet Ampoule Mask 25ml', N'Làm sạch da. Giữ ẩm.Cung cấp dưỡng chất và kết hợp điều trị một số vấn đề về da. Thư giãn', 22, 330000, N'Hàn Quốc', 'MN6.jpg', N'Mặt nạ'

EXEC sp_AddSP N'Kem Chống Nắng La Roche-Posay Anthelios Shaka Fluid Không Nhờn Rít SPF50+ (UVB + UVA) 50ml', N'Ngăn ngừa bức xạ UV. Tránh lão hóa sớm. Làm giảm nguy cơ cháy nắng. Ngừa các vết sạm da', 10, 190000, N'Pháp', 'KCN1.jpg', N'Chống nắng'
EXEC sp_AddSP N'Kem Chống nắng Skin1004 Madagascar Centella Air-Fit SunCream SPF50+ PA++++', N'Ngăn ngừa bức xạ UV. Tránh lão hóa sớm. Làm giảm nguy cơ cháy nắng. Ngừa các vết sạm da', 12, 230000, N'Hàn Quốc', 'KCN2.jpg', N'Chống nắng'
EXEC sp_AddSP N'Sữa Chống Nắng Dưỡng Da Anessa Perfect UV SPF50+/PA++++ 60ml', N'Ngăn ngừa bức xạ UV. Tránh lão hóa sớm. Làm giảm nguy cơ cháy nắng. Ngừa các vết sạm da', 22, 200000, N'Nhật ', 'KCN3.jpg', N'Chống nắng'
EXEC sp_AddSP N'Tinh Chất Chống Nắng Anessa Dành Cho Da Nhạy Cảm & Trẻ Em UV SPF35/PA+++ 60ml', N'Ngăn ngừa bức xạ UV. Tránh lão hóa sớm. Làm giảm nguy cơ cháy nắng. Ngừa các vết sạm da', 6, 100000, N'Nhật ', 'KCN4.jpg', N'Chống nắng'
EXEC sp_AddSP N'Tinh Chất chống nắng Skin Aqua-Tone Up UV 50g', N'Ngăn ngừa bức xạ UV. Tránh lão hóa sớm. Làm giảm nguy cơ cháy nắng. Ngừa các vết sạm da', 10, 250000, N'Nhật', 'KCN5.jpg', N'Chống nắng'
EXEC sp_AddSP N'Kem Chống Nắng L''Oreal Paris Skincare UV Perfect Aqua Essence Dưỡng Ẩm 30ml', N'Ngăn ngừa bức xạ UV. Tránh lão hóa sớm. Làm giảm nguy cơ cháy nắng. Ngừa các vết sạm da', 8, 250000, N'Indonesia', 'KCN6.jpg', N'Chống nắng'

-- chăm sóc tóc
EXEC sp_AddSP N'Xit Dưỡng Tóc Tsubaki Premium Repair Hair Water',N'Giúp cung cấp độ ẩm làm mềm mượt tự nhiên.Dưỡng tóc với những hạt nano giúp mái tóc mềm mịn.Giữ độ ẩm và giúp cho mái tóc luôn sáng bóng, óng ả.',20,100000,N'Anh','DTToc1.jpg',N'Đặc trị tóc'
EXEC sp_AddSP N'Xịt Dưỡng Tóc Hairburst Volume and Growth Elixir',N'Cải thiện độ chắc khỏe và chất lượng của từng sợi tóc.Chứa chiết xuất đậu hữu cơ giúp làm giảm rụng tóc, cải thiện mật độ của tóc và kéo dài vòng đời của tóc.Hỗ trợ bảo vệ tóc trước tác động của nhiệt độ cao, tia cực tím và ô nhiễm môi trường.',20,100000,N'Anh','DTToc2.jpg',N'Đặc trị tóc'
EXEC sp_AddSP N'hai Nước Dưỡng Tóc Cocoon Tinh Dầu Bưởi Pomelo Hair Tonic',N'Giảm gãy rụng và phục hồi hư tổn.Tăng cường độ bóng và chắc khỏe của tóc.Cung cấp dưỡng chất giúp tóc suôn mượt và mềm mại.',20,110000,N'Anh','DTToc3.jpg',N'Đặc trị tóc'
EXEC sp_AddSP N'Dầu Dưỡng Tóc L''Oreal Tinh Dầu Hoa Tự Nhiên 100mlElseve Extraodinary Oil',N'Chiết xuất từ 6 loại hoa thiên nhiên giúp nuôi dưỡng mái tóc mềm mại, suôn mượt.Thành phần dưỡng ẩm giúp phục hồi tóc khô xơ, hư tổn.Nuôi dưỡng tóc chắc khỏe, bồng bềnh, giảm thiểu tình trạng rụng tóc.',20,120000,N'Đức','DTToc4.jpg',N'Đặc trị tóc'
EXEC sp_AddSP N'Tinh dầu dưỡng tóc Argan Oil of Morocco Healing Dry Oil',N'Không gây bết dính giống như dầu dừa, nên khi thoa lên tóc sẽ không gây nhờn rít mà lại thẩm thấu cực nhanh vào tóc giúp phục hồi từ sâu bên trong, làm cho tóc được phục hồi và trẻ lại hết xơ rối và vô cùng óng ả.',20,180000,N'Anh','DTToc5.jpg',N'Đặc trị tóc'
EXEC sp_AddSP N'Dầu Dưỡng Tóc Mise En Scène Perfect Serum Rose',N'Ngăn chặn tác động của bụi mịn bằng cách tạo thành một lớp bảo vệ tóc phủ lên bề mặt để bụi mịn không bị hấp thụ vào giữa các lớp biểu bì đang mở của các sợi tóc hư tổn.',20,190000,N'Anh','DTToc6.jpg',N'Đặc trị tóc'

EXEC sp_AddSP N'Dầu Gội Đầu OGX Biotin Collagen',N'Giảm tóc hư tổn và khô xơ do sử dụng hóa chất',50,200000,N'Nhật Bản','DG1.jpg',N'Dầu gội'
EXEC sp_AddSP N'Dầu Gội TRESemmé Keratin Smooth',N'Giúp phục hồi hư tổn bề mặt tóc tức thời và nuôi dưỡng sâu giúp tái cấu trúc sợi tóc từ bên trong, cho mái tóc bạn chắc khỏe dài lâu.Sau mỗi lần gội, tóc bạn được phục hồi hư tổn, đẹp và chắc khỏe.',50,220000,N'Mỹ','DG2.jpg',N' Dầu gội'
EXEC sp_AddSP N'Dầu Gội Tsubaki',N'Chiết xuất tinh dầu hoa trà Nhật giúp làm giảm tình trạng tóc bết dính để mái tóc trông bồng bềnh hơn.Hương thơm bưởi tươi và bạc hà tươi mát, giúp mang lại cảm giác thoải mái, thư giãn.',60,230000,N'Nhật Bản','DG3.jpg',N' Dầu gội'
EXEC sp_AddSP N'Dầu Gội Love Beauty And Planet',N'Giảm tóc hư tổn và khô xơ giúp tóc bồng bếnh',50,290000,N'Mỹ','DG4.jpg',N' Dầu gội'
EXEC sp_AddSP N'Dầu Gội MISE EN SCENE PERFECT SERUM',N'Hoạt chất Bio-Serum từ thiên nhiên như hướng dương, trà xanh giúp ngăn gãy rụng từ gốc, cho tóc chắc khỏe gấp 5 lần.',50,250000,N'Việt Nam','DG5.jpg',N' Dầu gội'
EXEC sp_AddSP N'Dầu Gội Dove',N'Phục hồi tóc hư tổn, hỗ trợ ngăn ngừa gàu, giảm thiểu tình trạng rụng tóc.',50,300000,N'Nhật Bản','DG6.jpg',N' Dầu gội'

EXEC sp_AddSP N'Dầu Xả OGX Keratin Vào Nếp Suôn Mượt',N'Protein Keratin đóng vai trò như lớp sừng bảo vệ tóc khỏi các tác nhân tổn thương và đảm bảo độ hoàn thiện cho cấu trúc tóc, mang lại những lọn tóc quyến rũ, gợn sóng, đầy sức sống.',30,200000,N'Việt Nam','DX1.jpg',N' Dầu xả'
EXEC sp_AddSP N'Dầu Xả OGX Argan Oil Giúp Phục Hồi Tóc Hư Tổn',N'Công thức chứa dầu Argan từ vùng Moroc giàu dưỡng chất như các chất chống oxy hóa, vitamin và khoáng chất quý giá giúp hỗ trợ phục hồi hư tổn cho mái tóc.',30,100000,N'Nhật Bản','DX2.jpg',N' Dầu xả'
EXEC sp_AddSP N'Dầu Xả OGX Biotin & Collagen Làm Dày Tóc',N'Kết hợp giữa Biotin và Collagen giúp nhân đôi khả năng cải thiện những khuyết điểm về tóc, đảm bảo phát triển khỏe mạnh, bảo vệ tóc khỏi những tác động có hại từ bên ngoài.',30,200000,N'Việt Nam','DX3.jpg',N' Dầu xả'
EXEC sp_AddSP N'Dầu Xả Love Beauty And Planet Phục Hồi Hư Tổn',N'Murumuru là người "chị em" của dầu dừa. Bơ murumuru được trích từ chất béo trắng có trong hạt cọ murumuru ở vùng Amazon. Chất béo này nổi tiếng với khả năng dưỡng ẩm sâu.',30,400000,N'Hàn Quốc','DX4.jpg',N' Dầu xả'
EXEC sp_AddSP N'Dầu Xả Dove Giúp Tóc Bóng Mượt Chiết Xuất Hoa Sen Và Dầu',N'Nuôi dưỡng tóc từ gốc đến ngọn.Phục hồi cấu trúc sợi tóc.Hương hoa xanh và hương trái cây hòa quyện mang lại cảm giác thanh mát tươi mớ',20,500000,N'Việt Nam','DX5.jpg',N' Dầu xả'
EXEC sp_AddSP N'Dầu Xả TRESemmé Gừng & Trà Xanh Detox Tóc Chắc Khỏe',N'Công thức chứa thành phần thiên nhiên gồm Gừng và Trà Xanh, giúp Detox* và nuôi dưỡng tóc, giúp khôi phục lại mái tóc chắc khỏe đẹp chuẩn Sàn diễn.',30,200000,N'Nhật Bản','DX6.jpg',N' Dầu xả'

EXEC sp_AddSP N'Kem Ủ TRESemmé Vào Nếp Mềm Mượt Tóc',N'Phục hồi Protein nuôi dưỡng tóc mềm mượt, khỏe mạnh.',50,200000,N'Mỹ','KemU1.jpg',N' Kem ủ tóc'
EXEC sp_AddSP N'Kem Ủ Tóc Cao Cấp TSUBAKI Phục Hồi Hư Tổn',N'Kết hợp các thành phần làm đẹp giàu dưỡng chất như tinh dầu hoa trà, protein ngọc trai, khoáng chất mật ong, Amino Acid, Glycerin… dưới dạng kích thước nhỏ, có khả năng thẩm thấu trực tiếp vào tóc để nuôi dưỡng và phục hồi lại mái tóc bóng mượt, khỏe mạnh.',50,210000,N'Mỹ','KemU2.jpg',N' Kem ủ tóc'
EXEC sp_AddSP N'Kem Ủ L''Oréal Paris Ngăn Rụng Tóc',N'Bổ sung Arginine cùng axit amin giúp cải thiện, phục hồi và nuôi dưỡng mái tóc gãy rụng. Chắc chắn sẽ mang đến cho bạn mái tóc chắc khỏe, suôn mượt tràn đầy sức sống.',50,200000,N'Mỹ','KemU3.jpg',N' Kem ủ tóc'
EXEC sp_AddSP N'Kem Ủ Tóc Ogx Renewing Argan Oil Of Morocco',N'chiết xuất tinh dầu Argan có tác dụng dưỡng ẩm, làm suôn mượt và làm mềm mái tóc khô rối, dễ gãy, tăng cường tính năng chăm sóc nhằm mang lại cho bạn một mái tóc óng ả và dễ vào nếp.',50,200000,N'Mỹ','KemU4.jpg',N' Kem ủ tóc'
EXEC sp_AddSP N'Kem ủ tóc Tigi Bed Head Treatment Đỏ',N'Phục hồi Protein nuôi dưỡng tóc mềm mượt, khỏe mạnh.',50,260000,N'Mỹ','KemU5.jpg',N' Kem ủ tóc'
EXEC sp_AddSP N'Kem Ủ L''Oréal Paris Hỗ Trợ Phục Hồi Tóc Hư Tổn ',N'Giúp nuôi dưỡng tóc, đầy lùi 5 dấu hiệu hư tổn: Khô xơ, chẻ ngọn, gãy rụng, xỉn màu, thô cứng.',50,270000,N'Mỹ','KemU6.jpg',N' Kem ủ tóc'

EXEC sp_AddSP N'Thuốc Nhuộm Tóc Beautylabo Vanity Color Màu Nâu Rêu',N'Bảo vệ màu nhuộm lâu phai nhờ hợp chất Taurine & Theanine.',20,200000,N'Hàn Quốc','TNT1.jpg',N' Nhuộm tóc'
EXEC sp_AddSP N'Thuốc Nhuộm Tóc Beautylabo Vanity Color Màu Đen Khói',N'công thức độc đáo dạng tạo bọt chuyên biệt giúp bạn dễ dàng nhuộm tóc tại nhà, cho mái tóc nhuộm đều màu tuyệt đẹp .',10,200000,N'Hàn Quốc','TNT2.jpg',N' Nhuộm tóc'
EXEC sp_AddSP N'Thuốc Nhuộm Tóc Tạo Bọt Beautylabo Hồng Đào Sakura ',N' Thuốc nhuộm dạng dịch lỏng nên rất dễ thẩm thấu tới tận chân tóc, đảm bảo cho mái tóc đẹp, đều màu.',30,400000,N'Hàn Quốc','TNT3.jpg',N' Nhuộm tóc'
EXEC sp_AddSP N'Thuốc Nhuộm Tóc Beautylabo Vanity Color Màu Đen Khói',N'Công nghệ độc quyền bảo vệ nuôi dưỡng tóc 360 độ với gói cân bằng độ pH đưa tóc về trạng thái chuẩn sau khi nhuộm nhằm tránh hư tổn, kết hợp với gói serum sau nhuộm cung cấp dưỡng chất mang lại mái tóc suôn mềm óng ả.',30,200000,N'Nhật Bản','TNT4.jpg',N' Nhuộm tóc'
EXEC sp_AddSP N'Thuốc Nhuộm Tóc Beautylabo Vanity Color Màu Nâu Tây Lạnh',N'Bảng màu nhuộm thời trang cá tính, theo xu hướng.Hiệu qủa vượt trội từ công thức nhuộm cải tiến.',40,130000,N'Hàn Quốc','TNT5.jpg',N' Nhuộm tóc'
EXEC sp_AddSP N'Thuốc Nhuộm Tóc Tạo Bọt Beautylabo Nâu Chocolate', N'Không lưu lai thuốc thừa sau khi nhuộm.Thành phần an toàn da đầu, không gây kích ứng da.',30,100000,N'Mỹ','TNT6.jpg',N' Nhuộm tóc'

-- SELECT * FROM SANPHAM JOIN DONGIA ON SANPHAM.ID = DONGIA.ID_SP -- SHOW