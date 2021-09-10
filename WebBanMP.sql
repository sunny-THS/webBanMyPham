IF EXISTS(SELECT * FROM sys.databases WHERE name='WEBBANMP')
BEGIN
        DROP DATABASE WEBBANMP
END
CREATE DATABASE WEBBANMP
GO
USE WEBBANMP
GO

-- tạo bảng
CREATE TABLE TAIKHOAN (
    ID VARCHAR(15) NOT NULL, -- CREATE AUTO
    USERNAME VARCHAR(50), -- CHECK USERNAME THEO GROUP
    PW VARCHAR(100), -- MÃ HÓA + salt
    CONSTRAINT PK_TK PRIMARY KEY (ID)
)
-- GR ADMIN(00): CONTROL ALL
-- GR NHÂN VIÊN(01): HỖ TRỢ KHÁCH HÀNG XỬ LÝ ĐƠN HÀNG
-- GR KHÁCH HÀNG(02): NGƯỜI DÙNG
CREATE TABLE GRTK (
    ID INT IDENTITY NOT NULL,
    TEN VARCHAR(50), -- TÊN GR
    CODEGR CHAR(2),
    CONSTRAINT PK_GR PRIMARY KEY (GR_ID) 
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
    ID_GR INT REFERENCES GRTK(ID),
    CONSTRAINT PK_TTTK PRIMARY KEY (ID)
)
CREATE TABLE KHACHHANG (
    ID VARCHAR(10) NOT NULL, -- CREATE AUTO
    ID_TTTK VARCHAR(20) NOT NULL,
    CONSTRAINT PK_KH PRIMARY KEY (ID, ID_TTTK)
)
CREATE TABLE LOAISP (
    ID VARCHAR(5) NOT NULL,
    TENLOAI NVARCHAR(50),
    CONSTRAINT PK_LSP PRIMARY KEY (ID)
)
CREATE TABLE SANPHAM (
    ID VARCHAR(10) NOT NULL, -- CREATE AUTO
    TENSP NVARCHAR(50), -- TÊN SẢN PHẨM
    MOTA NVARCHAR(MAX), -- MÔ TẢ
    SOLUONG INT, -- SỐ LƯỢNG
    DONGIA FLOAT, -- ĐƠN GIÁ
    NSX NVARCHAR(30), -- NHÀ SẢN XUẤT
    ID_LOAI VARCHAR(5) REFERENCES LOAISP(ID),
    CONSTRAINT PK_SP PRIMARY KEY (ID)
)
CREATE TABLE DONGIA (
    ID INT IDENTITY NOT NULL,
    ID_SP VARCHAR(10) NOT NULL REFERENCES SANPHAM(ID),
    GIA FLOAT, -- GIÁ
    NGCAPNHAT DATETIME, -- NGÀY CẬP NHẬT
    CONSTRAINT PK_DG PRIMARY KEY (ID, ID_SP)
)
GO

----------------------------------------------------------
--  ___   Proc                     _   ___   Func       --
-- | _ \_ _ ___  __   __ _ _ _  __| | | __|  _ _ _  __  --
-- |  _/ '_/ _ \/ _| / _` | ' \/ _` | | _| || | ' \/ _| --
-- |_| |_| \___/\__| \__,_|_||_\__,_| |_| \_,_|_||_\__| --
----------------------------------------------------------

-- proc 
CREATE PROC sp_getRandom
@min int, 
@max int
AS
    RETURN FLOOR(RAND() * (@max - @min + 1) + @min);
GO
CREATE PROC sp_getIDGR
@tenGr VARCHAR(50)
AS
    DECLARE @IDGR INT
    SELECT @IDGR = ID FROM GRTK WHERE TEN = @tenGr

    RETURN @IDGR 
GO

-- function
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

CREATE FUNCTION fn_autoIDTTND(
    @idLogin VARCHAR(15)
) -- id CỦA THÔNG TIN NGƯỜI DÙNG: IDLOGIN + mã rand
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @randNumber INT
    EXEC @randNumber = sp_getRandom 100, 999
    
    DECLARE @ID VARCHAR(20) = @idLogin + convert(CHAR, @randNumber)

	RETURN @ID
END
GO

-- TẠO RÀNG BUỘC
ALTER TABLE THONGTINTAIKHOAN
ADD CONSTRAINT DF_NGTAO DEFAULT GETDATE() FOR NGTAO

ALTER TABLE DONGIA
ADD CONSTRAINT DF_NGCAPNHAT DEFAULT GETDATE() FOR NGCAPNHAT

ALTER TABLE KHACHHANG
ADD CONSTRAINT DF_ID DEFAULT DBO.fn_autoIDKH() FOR ID
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
INSERT TAIKHOAN VALUES(DBO.fn_autoIDTK(N'ADMIN'), 'admin', '')