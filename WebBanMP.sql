IF EXISTS(SELECT * FROM sys.databases WHERE name='WEBBANMP')
BEGIN
        DROP DATABASE WEBBANMP
END
CREATE DATABASE WEBBANMP
GO
USE WEBBANMP
GO

-- tạo bảng
CREATE TABLE TB_LOGIN (
    LG_ID VARCHAR(15) NOT NULL, -- CREATE AUTO
    LG_USERNAME VARCHAR(50), -- CHECK USERNAME THEO GROUP
    LG_PW VARCHAR(100), -- MÃ HÓA 
    CONSTRAINT PK_LOGIN PRIMARY KEY (LG_ID)
)
CREATE TABLE TB_GRTK (
    GR_ID INT IDENTITY NOT NULL,
    GR_TEN NVARCHAR(50), -- TÊN GR
    CONSTRAINT PK_GR PRIMARY KEY (GR_ID) 
)
CREATE TABLE TB_THONGTINTAIKHOAN (
    TTTK_ID VARCHAR(20) NOT NULL, -- CREATE AUTO
    TTTK_HOTEN NVARCHAR(50), -- HỌ TÊN
    TTTK_NGSINH DATE, -- NGÀY SINH
    TTTK_GTINH BIT, -- 1: NAM, 0: NỮ, NULL: CHƯA BIẾT(QUY VỀ 0)
    TTTK_NGTAO DATE, -- NGÀY TẠO
    TTTK_EMAIL VARCHAR(50), -- ĐỊA CHỈ EMAIL
    TTTK_SDT VARCHAR(11), -- SDT
    TTTK_DCHI NVARCHAR(50), -- ĐỊA CHỈ NHÀ / ĐỊA CHỈ GIAO
    TTTK_ID_TAIKHOAN VARCHAR(15) REFERENCES TB_LOGIN(LG_ID),
    TTTK_ID_GR INT REFERENCES TB_GRTK(GR_ID),
    CONSTRAINT PK_TTTK PRIMARY KEY (TTTK_ID)
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

-- function
CREATE FUNCTION fn_autoIDLG(@maTK CHAR(2)) -- id login
-- @matk = 00 : admin (duy nhất)
-- @matk = 01 : nhân viên
-- @matk = 02 : khách hàng
RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @ID VARCHAR(15)

	IF (SELECT COUNT(LG_ID) FROM TB_LOGIN) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(LG_ID, 3)) FROM TB_LOGIN

    DECLARE @ngayTao VARCHAR(8) = convert(VARCHAR, getdate(), 112) -- format yyyymmdd
    DECLARE @stt VARCHAR(5) = CONVERT(VARCHAR, CONVERT(INT, @ID) + 1)

	SELECT @ID = CASE
		WHEN @ID >=  0 and @ID < 9 THEN @ngayTao + @maTK + '00' + @stt
		WHEN @ID >=  9 THEN @ngayTao + @maTK + '0' + @stt
		WHEN @ID >= 99 THEN @ngayTao + @maTK + @stt
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