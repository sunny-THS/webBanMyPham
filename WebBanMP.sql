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
    TEN VARCHAR(50), -- TÊN GR
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
    ID VARCHAR(5) NOT NULL,
    TENLOAI NVARCHAR(50),
    CONSTRAINT PK_LSP PRIMARY KEY (ID)
)
CREATE TABLE SANPHAM ( -- _________________________________
    ID VARCHAR(10) NOT NULL, -- CREATE AUTO
    TENSP NVARCHAR(50), -- TÊN SẢN PHẨM
    MOTA NVARCHAR(MAX), -- MÔ TẢ
    SOLUONG INT, -- SỐ LƯỢNG TỒN KHO
    -- DONGIA FLOAT, -- ĐƠN GIÁ
    NSX NVARCHAR(30), -- NHÀ SẢN XUẤT
    ID_LOAI VARCHAR(5) REFERENCES LOAISP(ID),
    CONSTRAINT PK_SP PRIMARY KEY (ID)
)
CREATE TABLE SALE (
    ID INT IDENTITY NOT NULL,
    GIATRI FLOAT, -- GIÁ TRỊ SALE
    ID_SP VARCHAR(10) REFERENCES SANPHAM(ID),
    NGCAPNHAT DATETIME, -- NGÀY CẬP NHẬT SALE LẤY NGÀY GẦN NHẤT
    CONSTRAINT PK_SALE PRIMARY KEY (ID)
)
CREATE TABLE DONGIA (
    ID INT IDENTITY NOT NULL,
    ID_SP VARCHAR(10) REFERENCES SANPHAM(ID),
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
    ID_SP VARCHAR(10) REFERENCES SANPHAM(ID),
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
    ID_SP VARCHAR(10) REFERENCES SANPHAM(ID),
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

	IF (SELECT COUNT(ID) FROM TAIKHOAN) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(ID, 3)) FROM TAIKHOAN

    DECLARE @ngayTao VARCHAR(8) = convert(VARCHAR, getdate(), 112) -- format yyyymmdd
    DECLARE @stt VARCHAR(5) = CONVERT(VARCHAR, CONVERT(INT, @ID) + 1)
    DECLARE @maCodeGr CHAR(2)

    -- LẤY MÃ GR
    SELECT @maCodeGr = CODEGR FROM GRTK WHERE TEN = @TENGR

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
CREATE PROC sp_getIDGR -- TRẢ VỀ ID GR
@tenGr VARCHAR(50)
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

CREATE PROC sp_AddAcc
@userName VARCHAR(50),
@pw VARCHAR(50),
@GRNAME NVARCHAR(50)
AS
	BEGIN TRY
		DECLARE @ID VARCHAR(15) = DBO.fn_autoIDTK(@GRNAME)

		DECLARE	@createPW VARBINARY(MAX) = SubString(DBO.fn_hash(@ID), 1, len(DBO.fn_hash(@ID))/2) + DBO.fn_hash(@pw + @ID)

		DECLARE @IDGR INT
		EXEC @IDGR = sp_getIDGR @GRNAME

		IF EXISTS(SELECT * FROM TAIKHOAN WHERE ID_GR = @IDGR AND USERNAME = @userName)
			THROW 51000, N'Username đã tồn tại.', 1;
		
		INSERT TAIKHOAN
		SELECT @ID, @userName, @createPW, @IDGR; 
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
EXEC sp_AddAcc 'admin', 'admin@123456789', N'ADMIN' 