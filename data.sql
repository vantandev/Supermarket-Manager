CREATE DATABASE QLSieuThi
GO
USE [QLSieuThi]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Get_MaDonHang_Next]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_Get_MaDonHang_Next](@MaHD NVARCHAR(50))
RETURNS NVARCHAR(50) 
AS
BEGIN
	SET @MaHD+='%'; 
    DECLARE @MaHD_Next VARCHAR(15)
    SELECT @MaHD_Next = (
        SELECT TOP 1 MaHD
        FROM HoaDon    
        WHERE MaHD like @MaHD
		ORDER BY MaHD DESC
    )    
	DECLARE  @n INT
	SET @n = CONVERT(INT, RIGHT(@MaHD_Next,3)) +1
	SET @MaHD_Next = LEFT(@MaHD,10) + RIGHT('000'+CONVERT(varchar(3),@n),3)
    RETURN @MaHD_Next
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetUnsignString]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetUnsignString](@strInput NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
AS
BEGIN     
    IF @strInput IS NULL RETURN @strInput
    IF @strInput = '' RETURN @strInput
    DECLARE @RT NVARCHAR(4000)
    DECLARE @SIGN_CHARS NCHAR(136)
    DECLARE @UNSIGN_CHARS NCHAR (136)

    SET @SIGN_CHARS       = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ'+NCHAR(272)+ NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'

    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
    SET @COUNTER = 1
 
    WHILE (@COUNTER <=LEN(@strInput))
    BEGIN   
      SET @COUNTER1 = 1
      --Tim trong chuoi mau
       WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1)
       BEGIN
     IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) )
     BEGIN           
          IF @COUNTER=1
              SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1)                   
          ELSE
              SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER)    
              BREAK         
               END
             SET @COUNTER1 = @COUNTER1 +1
       END
      --Tim tiep
       SET @COUNTER = @COUNTER +1
    END
    RETURN @strInput
END
GO
/****** Object:  Table [dbo].[ChiTietHD]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietHD](
	[MaHD] [nvarchar](50) NOT NULL,
	[MaMH] [nvarchar](50) NOT NULL,
	[SoLuong] [int] NOT NULL,
	[DonGia] [float] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiTietPN]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietPN](
	[MaPN] [nchar](10) NULL,
	[MaMH] [nvarchar](50) NOT NULL,
	[SoLuong] [int] NULL,
	[DonGia] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DonViTinh]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DonViTinh](
	[MaDVT] [varchar](10) NOT NULL,
	[TenDVT] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDVT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HoaDon]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDon](
	[MaHD] [nvarchar](50) NOT NULL,
	[MaKH] [varchar](20) NOT NULL,
	[NgayTao] [date] NOT NULL,
	[MaNV] [nvarchar](20) NOT NULL,
	[TongTien] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhachHang](
	[MaKH] [varchar](20) NOT NULL,
	[TenKH] [nvarchar](50) NOT NULL,
	[GioiTinh] [bit] NULL,
	[DiaChi] [nvarchar](50) NULL,
	[SDT] [varchar](10) NOT NULL,
	[Email] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoaiHang]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoaiHang](
	[MaLH] [varchar](10) NOT NULL,
	[TenLH] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MatHang]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MatHang](
	[MaMH] [nvarchar](50) NOT NULL,
	[TenMH] [nvarchar](50) NOT NULL,
	[MaQH] [varchar](20) NULL,
	[MaDVT] [varchar](10) NOT NULL,
	[GiaBan] [int] NULL,
	[SoLuong] [int] NULL,
	[MaLH] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhaCungCap]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhaCungCap](
	[MaNCC] [nchar](10) NOT NULL,
	[TenNCC] [nvarchar](50) NOT NULL,
	[DiaChi] [nvarchar](50) NOT NULL,
	[SDT] [varchar](20) NULL,
	[Email] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[MaNV] [nvarchar](20) NOT NULL,
	[TenHienThi] [nvarchar](50) NULL,
	[GioiTinh] [nvarchar](20) NULL,
	[DiaChi] [nvarchar](50) NULL,
	[SDT] [nvarchar](10) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[Quyen] [nvarchar](20) NULL,
	[TenDangNhap] [varchar](50) NOT NULL,
	[MatKhau] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhieuNhap]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhieuNhap](
	[MaPN] [nchar](10) NOT NULL,
	[MaNCC] [nchar](10) NOT NULL,
	[NgayNhap] [date] NOT NULL,
	[MaNV] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaPN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuayHang]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuayHang](
	[MaQH] [varchar](20) NOT NULL,
	[TenQH] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaQH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD001', N'SP013', 1, 3000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD001', N'SP002', 4, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD001', N'SP004', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD002', N'SP002', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD002', N'SP009', 4, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD002', N'SP009', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD002', N'SP010', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD003', N'SP003', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD004', N'SP010', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD005', N'SP001', 1, 26000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD006', N'SP009', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD007', N'SP002', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD008', N'SP008', 1, 25000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD009', N'SP014', 1, 10000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD010', N'SP001', 1, 26000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD011', N'SP005', 1, 200000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD012', N'SP011', 1, 12000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD013', N'SP001', 1, 26000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD014', N'SP003', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD015', N'SP009', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD016', N'SP014', 1, 10000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD017', N'SP002', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD018', N'SP001', 1, 26000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD019', N'SP004', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD020', N'SP011', 1, 12000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD021', N'SP002', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD022', N'SP004', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD022', N'SP010', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD022', N'SP014', 1, 10000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD022', N'SP002', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD022', N'SP001', 1, 26000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD023', N'SP003', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD023', N'SP004', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD023', N'SP009', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD023', N'SP014', 1, 10000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD023', N'SP002', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD024', N'SP003', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD024', N'SP004', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD024', N'SP005', 1, 200000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD024', N'SP013', 1, 3000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD025', N'SP004', 5, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD026', N'SP005', 3, 200000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD027', N'SP003', 5, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD028', N'SP008', 9, 25000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD029', N'SP005', 5, 200000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD030', N'SP004', 3, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD030', N'SP003', 3, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD030', N'SP011', 2, 12000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD031', N'SP008', 2, 25000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD031', N'SP015', 2, 30000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD033', N'SP010', 2, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD033', N'SP014', 2, 10000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD033', N'SP015', 1, 30000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD033', N'SP008', 1, 25000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD034', N'SP005', 2, 200000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD034', N'SP009', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD034', N'SP014', 2, 10000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD034', N'SP001', 1, 26000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD035', N'SP008', 1, 25000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD035', N'SP009', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD035', N'SP013', 1, 3000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD040', N'SP004', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD041', N'SP003', 2, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD042', N'SP011', 2, 12000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD045', N'SP004', 2, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD045', N'SP010', 2, 40000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD045', N'SP014', 1, 10000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD045', N'SP009', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD045', N'SP001', 1, 26000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD048', N'SP005', 2, 200000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD049', N'SP005', 2, 200000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD050', N'SP011', 3, 12000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD050', N'SP016', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD050', N'SP013', 5, 3000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD050', N'SP003', 2, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD050', N'SP004', 3, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD051', N'SP009', 12, 21000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD051', N'SP018', 5, 5000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD051', N'SP019', 5, 7000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD052', N'SP015', 4, 30000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD052', N'SP008', 2, 25000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD032', N'SP008', 2, 25000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD032', N'SP014', 2, 10000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD032', N'SP009', 1, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD036', N'SP009', 40, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD037', N'SP003', 2, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD038', N'SP002', 2, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD039', N'SP005', 5, 200000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD043', N'SP011', 2, 12000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD044', N'SP004', 2, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD046', N'SP003', 1, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD046', N'SP009', 10, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD046', N'SP001', 5, 26000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD047', N'SP009', 10, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD047', N'SP001', 6, 26000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD047', N'SP011', 1, 12000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD052', N'SP004', 4, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD053', N'SP016', 3, 20000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD053', N'SP004', 2, 15000)
INSERT [dbo].[ChiTietHD] ([MaHD], [MaMH], [SoLuong], [DonGia]) VALUES (N'HD053', N'SP019', 5, 7000)
GO
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN001     ', N'SP001', 20, 23000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN002     ', N'SP003', 50, 22500)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN002     ', N'SP005', 20, 180000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN002     ', N'SP004', 100, 7000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN003     ', N'SP009', 100, 15000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN003     ', N'SP013', 100, 2000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN003     ', N'SP002', 100, 15000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN004     ', N'SP015', 1000, 20000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN004     ', N'SP003', 100, 22500)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN004     ', N'SP002', 100, 15000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN004     ', N'SP013', 100, 2000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN004     ', N'SP001', 100, 21500)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN005     ', N'SP010', 100, 16000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN006     ', N'SP015', 100, 20000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN007     ', N'SP001', 100, 21500)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN008     ', N'SP002', 100, 15000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN009     ', N'SP008', 100, 15000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN010     ', N'SP011', 398, 9000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN010     ', N'SP014', 79, 7000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN011     ', N'SP001', 8, 21500)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN012     ', N'SP002', 12, 15000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN013     ', N'SP005', 7, 180000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN014     ', N'SP005', 2, 180000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN015     ', N'SP003', 7, 8000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN016     ', N'SP016', 7, 19000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN017     ', N'SP016', 3, 18000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN018     ', N'SP004', 8, 13000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN019     ', N'SP017', 20, 3000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN020     ', N'SP004', 20, 20000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN020     ', N'SP003', 2, 20000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN020     ', N'SP009', 20, 30000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN021     ', N'SP005', 50, 12000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN022     ', N'SP018', 100, 3000)
INSERT [dbo].[ChiTietPN] ([MaPN], [MaMH], [SoLuong], [DonGia]) VALUES (N'PN023     ', N'SP019', 100, 4000)
GO
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (N'DVT01', N'Thùng')
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (N'DVT02', N'Lon')
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (N'DVT03', N'Chai')
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (N'DVT04', N'Bịch')
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (N'DVT05', N'Hộp')
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (N'DVT06', N'Cái')
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (N'DVT07', N'Két')
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (N'DVT08', N'Trái')
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (N'DVT09', N'Hộp')
GO
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD001', N'KH01     ', CAST(N'2020-02-01' AS Date), N'NV02', 98000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD002', N'KH02     ', CAST(N'2020-03-01' AS Date), N'NV02', 135000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD003', N'KH03     ', CAST(N'2020-04-01' AS Date), N'NV02', 15000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD004', N'KH05     ', CAST(N'2020-09-01' AS Date), N'NV02', 20000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD005', N'KH05     ', CAST(N'2020-10-01' AS Date), N'NV02', 26000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD006', N'KH01     ', CAST(N'2020-11-01' AS Date), N'NV02', 20000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD007', N'KH01     ', CAST(N'2020-11-01' AS Date), N'NV02', 20000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD008', N'KH05     ', CAST(N'2020-01-01' AS Date), N'NV02', 25000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD009', N'KH06     ', CAST(N'2020-01-01' AS Date), N'NV02', 10000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD010', N'KH01     ', CAST(N'2020-05-01' AS Date), N'NV02', 26000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD011', N'KH04     ', CAST(N'2020-02-01' AS Date), N'NV02', 200000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD012', N'KH06     ', CAST(N'2020-02-01' AS Date), N'NV02', 12000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD013', N'KH04     ', CAST(N'2021-01-01' AS Date), N'NV02', 26000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD014', N'KH01     ', CAST(N'2021-01-01' AS Date), N'NV02', 15000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD015', N'KH06     ', CAST(N'2021-01-01' AS Date), N'NV02', 20000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD016', N'KH05     ', CAST(N'2021-01-02' AS Date), N'NV04', 10000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD017', N'KH04     ', CAST(N'2020-12-20' AS Date), N'NV04', 20000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD018', N'KH08     ', CAST(N'2020-12-21' AS Date), N'NV04', 26000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD019', N'KH08     ', CAST(N'2020-12-22' AS Date), N'NV04', 15000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD020', N'KH01     ', CAST(N'2020-12-23' AS Date), N'NV04', 32000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD021', N'KH02     ', CAST(N'2020-12-23' AS Date), N'NV04', 20000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD022', N'KH02     ', CAST(N'2020-12-10' AS Date), N'NV04', 91000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD023', N'KH03     ', CAST(N'2020-12-01' AS Date), N'NV02', 62000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD024', N'KH02     ', CAST(N'2020-12-24' AS Date), N'NV04', 233000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD025', N'KH01', CAST(N'2021-11-18' AS Date), N'AD', 75000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD026', N'KH07', CAST(N'2021-11-19' AS Date), N'AD', 600000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD027', N'KH04', CAST(N'2021-11-19' AS Date), N'AD', 75000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD028', N'KH07', CAST(N'2021-11-19' AS Date), N'AD', 225000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD029', N'KH07', CAST(N'2021-11-19' AS Date), N'AD', 1000000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD030', N'KH03', CAST(N'2021-11-20' AS Date), N'NV02', 114000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD031', N'KH02', CAST(N'2021-11-20' AS Date), N'NV02', 110000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD032', N'KH05', CAST(N'2021-11-20' AS Date), N'AD', 90000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD033', N'KH03', CAST(N'2021-11-20' AS Date), N'NV02', 115000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD034', N'KH07', CAST(N'2021-11-20' AS Date), N'NV02', 466000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD035', N'KH07', CAST(N'2021-11-20' AS Date), N'NV02', 48000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD036', N'KH09', CAST(N'2021-11-20' AS Date), N'NV02', 800000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD037', N'KH09', CAST(N'2021-11-20' AS Date), N'AD', 30000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD038', N'KH03', CAST(N'2021-11-20' AS Date), N'NV02', 40000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD039', N'KH08', CAST(N'2021-11-20' AS Date), N'NV02', 1000000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD040', N'KH08', CAST(N'2021-11-20' AS Date), N'NV02', 15000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD041', N'KH08', CAST(N'2021-11-20' AS Date), N'NV02', 30000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD042', N'KH07', CAST(N'2021-11-20' AS Date), N'NV02', 24000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD043', N'KH08', CAST(N'2021-11-20' AS Date), N'NV02', 24000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD044', N'KH03', CAST(N'2021-11-20' AS Date), N'NV02', 30000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD045', N'KH07', CAST(N'2021-11-20' AS Date), N'AD', 126000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD046', N'KH09', CAST(N'2021-11-20' AS Date), N'NV02', 345000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD047', N'KH09', CAST(N'2021-11-20' AS Date), N'NV02', 368000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD048', N'KH03', CAST(N'2021-12-14' AS Date), N'AD', 400000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD049', N'KH02', CAST(N'2021-12-14' AS Date), N'AD', 400000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD050', N'KH03', CAST(N'2021-12-15' AS Date), N'AD', 146000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD051', N'KH09', CAST(N'2021-12-23' AS Date), N'NV02', 312000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD052', N'KH09', CAST(N'2021-12-23' AS Date), N'NV02', 230000)
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [NgayTao], [MaNV], [TongTien]) VALUES (N'HD053', N'KH09', CAST(N'2021-12-23' AS Date), N'NV04', 125000)
GO
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [GioiTinh], [DiaChi], [SDT], [Email]) VALUES (N'KH01', N'Phan khách Duy', 0, N'Quận 9 , Hồ Chí Minh', N'0333533883', N'duyphan@gmail.com')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [GioiTinh], [DiaChi], [SDT], [Email]) VALUES (N'KH02', N'Đặng đình Duy', 0, N'Ba Đình, Hà Nội', N'0333533893', N'duydang@gmail.com')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [GioiTinh], [DiaChi], [SDT], [Email]) VALUES (N'KH03', N'Trần huỳnh Lưu', 0, N'Quận 4, Hồ Chí Minh', N'0325895852', N'luutran@gmail.com')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [GioiTinh], [DiaChi], [SDT], [Email]) VALUES (N'KH04', N'Lê gia Minh', 0, N'Quận 8, Hồ Chí Minh', N'0365895532', N'minhle@gmail.com')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [GioiTinh], [DiaChi], [SDT], [Email]) VALUES (N'KH05', N'Võ đoàn hoàng Long', 0, N'Quận 2, Hồ Chí Minh', N'0365895748', N'longvo@gmail.com')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [GioiTinh], [DiaChi], [SDT], [Email]) VALUES (N'KH06', N'Lê âu Hải', 0, N'Quận 8, Hồ Chí Minh', N'0365895857', N'haile@gmail.com')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [GioiTinh], [DiaChi], [SDT], [Email]) VALUES (N'KH07', N'Đoàn phước Nhật', 0, N'Quận 5, Hồ Chí Minh', N'0321515648', N'nhatdoan@gmail.com')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [GioiTinh], [DiaChi], [SDT], [Email]) VALUES (N'KH08', N'Phan tấn Hoàng', 0, N'Quận 8, Hồ Chí Minh', N'0321515338', N'hoangphan@gmail.com')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [GioiTinh], [DiaChi], [SDT], [Email]) VALUES (N'KH09', N'Phạm Quốc Trung ', 1, N'An Chấn, Tuy An, Phú Yên', N'0328644258', N'trungcobia@gmail.com')
GO
INSERT [dbo].[LoaiHang] ([MaLH], [TenLH]) VALUES (N'LH001', N'Hàng tổng hợp')
INSERT [dbo].[LoaiHang] ([MaLH], [TenLH]) VALUES (N'LH002 ', N'Hóa mỹ phẩm')
INSERT [dbo].[LoaiHang] ([MaLH], [TenLH]) VALUES (N'LH003', N'Thực phẩm khô')
INSERT [dbo].[LoaiHang] ([MaLH], [TenLH]) VALUES (N'LH004', N'Sữa và Sản phẩm từ sữa')
INSERT [dbo].[LoaiHang] ([MaLH], [TenLH]) VALUES (N'LH005', N'Snack')
INSERT [dbo].[LoaiHang] ([MaLH], [TenLH]) VALUES (N'LH006', N'Nước giải khát')
INSERT [dbo].[LoaiHang] ([MaLH], [TenLH]) VALUES (N'LH007', N'Trái cây')
INSERT [dbo].[LoaiHang] ([MaLH], [TenLH]) VALUES (N'LH008', N'Gia vị')
INSERT [dbo].[LoaiHang] ([MaLH], [TenLH]) VALUES (N'LH009', N'Bia và Rượu')
GO
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP001', N'Dầu ăn', N'QH05', N'DVT03', 26000, 210, N'LH003')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP002', N'Nước rửa chén sunlight', N'QH05', N'DVT03', 20000, 300, N'LH001')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP003', N'Đường', N'QH05', N'DVT04', 15000, 140, N'LH008')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP004', N'Tương ớt', N'QH05', N'DVT03', 15000, 101, N'LH003')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP005', N'Dầu gội', N'QH05', N'DVT03', 15000, 58, N'LH002 ')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP008', N'Hạt nêm', N'QH05', N'DVT04', 25000, 82, N'LH008')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP009', N'Bia tiger', N'QH04', N'DVT02', 21000, 36, N'LH009')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP010', N'Xà phòng', N'QH05', N'DVT05', 20000, 93, N'LH001')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP011', N'Trà xanh 0 độ', N'QH04', N'DVT03', 12000, 386, N'LH006')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP013', N'Táo', N'QH05', N'DVT08', 3000, 292, N'LH007')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP014', N'Sting', N'QH04', N'DVT03', 10000, 68, N'LH006')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP015', N'Trà Xanh', N'QH04', N'DVT09', 30000, 1093, N'LH006')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP016', N'Trà Olong', N'QH04', N'DVT03', 20000, 6, N'LH006')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP017', N'Trà chanh', N'QH04', N'DVT03', 20000, 20, N'LH006')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP018', N'Osi tôm ', N'QH01', N'DVT04', 5000, 95, N'LH005')
INSERT [dbo].[MatHang] ([MaMH], [TenMH], [MaQH], [MaDVT], [GiaBan], [SoLuong], [MaLH]) VALUES (N'SP019', N'Osi cua', N'QH01', N'DVT04', 7000, 90, N'LH005')
GO
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [SDT], [Email]) VALUES (N'NCC001    ', N'Bốn Phương', N'Quận 1, Hồ Chí Minh', N'0935847521', N'bonphuong@gmail.com')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [SDT], [Email]) VALUES (N'NCC002    ', N'Phú Sơn', N'Quận 3, Hồ Chí Minh', N'0935847543', N'phuson@gmail.com')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [SDT], [Email]) VALUES (N'NCC003    ', N'Hưng Thịnh', N'Quận 8, Hồ Chí Minh', N'0935847590', N'hungthinh@gmail.com')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [SDT], [Email]) VALUES (N'NCC004    ', N'Hồng Kông', N'Quận 9, Hồ Chí Minh', N'0935847555', N'khanhan@gmail.com')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [SDT], [Email]) VALUES (N'NCC005    ', N'Kinh Đô', N'Bắc Giang', N'0935847577', N'kinhdo@gmail.com')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [SDT], [Email]) VALUES (N'NCC006    ', N'Phương Nam', N'Đà Nẵng', N'0935847500', N'phuongnam@gmail.com')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [SDT], [Email]) VALUES (N'NCC007    ', N'Cao Thắng', N'Quảng Ninh', N'032568596', N'caothang@gmail.com')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [SDT], [Email]) VALUES (N'NCC008    ', N'Thịnh Phát', N'Quận 2, Hồ Chí Minh', N'032698485', N'thinhphat@gmail.com')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [SDT], [Email]) VALUES (N'NCC009    ', N'Mai Thảo', N'Ba Đình, Hà Nội', N'0325698489', N'maithao@gmail.com')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [SDT], [Email]) VALUES (N'NCC010    ', N'Thương Tín', N'Ba Vì, Hà Nội', N'0925998485', N'thuongtin@gmail.com')
GO
INSERT [dbo].[NhanVien] ([MaNV], [TenHienThi], [GioiTinh], [DiaChi], [SDT], [Email], [Quyen], [TenDangNhap], [MatKhau]) VALUES (N'AD', N'Admin', N'Nam', N'Hồ Chí Minh', N'0333533893', N'admin@gmail.com', N'Quản lý', N'admin', N'123')
INSERT [dbo].[NhanVien] ([MaNV], [TenHienThi], [GioiTinh], [DiaChi], [SDT], [Email], [Quyen], [TenDangNhap], [MatKhau]) VALUES (N'NV01', N'Bùi Văn Tân', N'Nam', N'Hồ Chí Minh', N'0382753698', N'tan@gmail.com', N'Bán hàng', N'tan', N'123')
INSERT [dbo].[NhanVien] ([MaNV], [TenHienThi], [GioiTinh], [DiaChi], [SDT], [Email], [Quyen], [TenDangNhap], [MatKhau]) VALUES (N'NV02', N'Nguyễn Công Chí', N'Nam', N'Quảng Bình', N'0925698489', N'chi@gmail.com', N'Thủ kho', N'chi', N'123')
INSERT [dbo].[NhanVien] ([MaNV], [TenHienThi], [GioiTinh], [DiaChi], [SDT], [Email], [Quyen], [TenDangNhap], [MatKhau]) VALUES (N'NV04', N'Huỳnh Xuân Lãm', N'Nam', N'Hải Dương', N'0925698485', N'lam@gmail.com', N'Bán hàng', N'lam', N'123')
INSERT [dbo].[NhanVien] ([MaNV], [TenHienThi], [GioiTinh], [DiaChi], [SDT], [Email], [Quyen], [TenDangNhap], [MatKhau]) VALUES (N'NV05', N'Hồ Ngọc Thống ', N'Nam', N'Bình Thuận', N'0925698485', N'thong@gmail.com', N'Bán hàng', N'thong', N'123')
GO
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN001     ', N'NCC001    ', CAST(N'2020-12-31' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN002     ', N'NCC002    ', CAST(N'2020-12-31' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN003     ', N'NCC003    ', CAST(N'2020-12-31' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN004     ', N'NCC004    ', CAST(N'2021-01-01' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN005     ', N'NCC005    ', CAST(N'2021-01-01' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN006     ', N'NCC006    ', CAST(N'2021-01-01' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN007     ', N'NCC007    ', CAST(N'2021-01-01' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN008     ', N'NCC008    ', CAST(N'2021-01-01' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN009     ', N'NCC009    ', CAST(N'2021-01-01' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN010     ', N'NCC010    ', CAST(N'2021-01-01' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN011     ', N'NCC003    ', CAST(N'2021-11-23' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN012     ', N'NCC002    ', CAST(N'2021-11-23' AS Date), N'AD')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN013     ', N'NCC005    ', CAST(N'2021-11-24' AS Date), N'AD')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN014     ', N'NCC003    ', CAST(N'2021-11-24' AS Date), N'AD')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN015     ', N'NCC006    ', CAST(N'2021-11-25' AS Date), N'AD')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN016     ', N'NCC005    ', CAST(N'2021-11-26' AS Date), N'AD')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN017     ', N'NCC004    ', CAST(N'2021-11-26' AS Date), N'AD')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN018     ', N'NCC005    ', CAST(N'2021-11-26' AS Date), N'AD')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN019     ', N'NCC003    ', CAST(N'2021-11-26' AS Date), N'AD')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN020     ', N'NCC002    ', CAST(N'2021-11-26' AS Date), N'AD')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN021     ', N'NCC007    ', CAST(N'2021-12-22' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN022     ', N'NCC005    ', CAST(N'2021-12-22' AS Date), N'NV01')
INSERT [dbo].[PhieuNhap] ([MaPN], [MaNCC], [NgayNhap], [MaNV]) VALUES (N'PN023     ', N'NCC008    ', CAST(N'2021-12-22' AS Date), N'NV01')
GO
INSERT [dbo].[QuayHang] ([MaQH], [TenQH]) VALUES (N'QH01', N'Quầy hàng 1')
INSERT [dbo].[QuayHang] ([MaQH], [TenQH]) VALUES (N'QH02', N'Quầy hàng 2')
INSERT [dbo].[QuayHang] ([MaQH], [TenQH]) VALUES (N'QH03', N'Quầy hàng 3')
INSERT [dbo].[QuayHang] ([MaQH], [TenQH]) VALUES (N'QH04', N'Quầy hàng 4')
INSERT [dbo].[QuayHang] ([MaQH], [TenQH]) VALUES (N'QH05', N'Quầy hàng 5')
INSERT [dbo].[QuayHang] ([MaQH], [TenQH]) VALUES (N'QH06', N'Quầy hàng 6')
GO
ALTER TABLE [dbo].[ChiTietHD]  WITH CHECK ADD FOREIGN KEY([MaHD])
REFERENCES [dbo].[HoaDon] ([MaHD])
GO
ALTER TABLE [dbo].[ChiTietHD]  WITH CHECK ADD FOREIGN KEY([MaMH])
REFERENCES [dbo].[MatHang] ([MaMH])
GO
ALTER TABLE [dbo].[ChiTietPN]  WITH CHECK ADD FOREIGN KEY([MaMH])
REFERENCES [dbo].[MatHang] ([MaMH])
GO
ALTER TABLE [dbo].[ChiTietPN]  WITH CHECK ADD FOREIGN KEY([MaPN])
REFERENCES [dbo].[PhieuNhap] ([MaPN])
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD FOREIGN KEY([MaKH])
REFERENCES [dbo].[KhachHang] ([MaKH])
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD FOREIGN KEY([MaNV])
REFERENCES [dbo].[NhanVien] ([MaNV])
GO
ALTER TABLE [dbo].[MatHang]  WITH CHECK ADD FOREIGN KEY([MaDVT])
REFERENCES [dbo].[DonViTinh] ([MaDVT])
GO
ALTER TABLE [dbo].[MatHang]  WITH CHECK ADD FOREIGN KEY([MaQH])
REFERENCES [dbo].[QuayHang] ([MaQH])
GO
ALTER TABLE [dbo].[MatHang]  WITH CHECK ADD FOREIGN KEY([MaLH])
REFERENCES [dbo].[LoaiHang] ([MaLH])
GO
ALTER TABLE [dbo].[PhieuNhap]  WITH CHECK ADD FOREIGN KEY([MaNCC])
REFERENCES [dbo].[NhaCungCap] ([MaNCC])
GO
ALTER TABLE [dbo].[PhieuNhap]  WITH CHECK ADD FOREIGN KEY([MaNV])
REFERENCES [dbo].[NhanVien] ([MaNV])
GO






-- Hàm nội thủ tục

/****** Object:  StoredProcedure [dbo].[USP_Chitietpn]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[USP_Chitietpn](
   @mapn nchar (10)
)
as
select ChiTietPN.MaPN,ChiTietPN.MaMH,MatHang.TenMH,ChiTietPN.SoLuong,ChiTietPN.DonGia,PhieuNhap.MaNV,NhanVien.TenHienThi,NhanVien.Quyen,PhieuNhap.MaNCC,NhaCungCap.TenNCC,PhieuNhap.NgayNhap
from  ChiTietPN inner join MatHang on ChiTietPN.MaMH = MatHang.MaMH inner join PhieuNhap on ChiTietPN.MaPN = PhieuNhap.MaPN inner join NhanVien on NhanVien.MaNV = PhieuNhap.MaNV inner join NhaCungCap on PhieuNhap.MaNCC = NhaCungCap.MaNCC
where ChiTietPN.MaPN = @mapn
GO
/****** Object:  StoredProcedure [dbo].[USP_getMucgia]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[USP_getMucgia](@mamh varchar (20),@đvt varchar (10))
as
select Giaban
from MatHang
where MaMH = @mamh and DonVi = @đvt 
GO
/****** Object:  StoredProcedure [dbo].[USP_Inhoadon]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[USP_Inhoadon](
     @mahd nvarchar (50)
) 
as
select HoaDon.MaHD,TenKH,KhachHang.SDT,KhachHang.DiaChi,Email,HoaDon.NgayTao,NhanVien.MaNV,NhanVien.TenHienThi,MatHang.TenMH,ChiTietHD.SoLuong,ChiTietHD.DonGia
from HoaDon inner join KhachHang on HoaDon.MaKH = KhachHang.MaKH inner join NhanVien on NhanVien.MaNV = HoaDon.MaNV inner join ChiTietHD on ChiTietHD.MaHD = HoaDon.MaHD inner join MatHang on MatHang.MaMH = ChiTietHD.MaMH
where HoaDon.MaHD =  @mahd
GO
/****** Object:  StoredProcedure [dbo].[USP_Inhoadonn]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[USP_Inhoadonn](
  @mahd nvarchar (50)
)
as
select HoaDon.MaHD,TenKH,KhachHang.SDT,KhachHang.DiaChi,KhachHang.Email,HoaDon.NgayTao,NhanVien.MaNV,NhanVien.TenHienThi,MatHang.TenMH,ChiTietHD.SoLuong,ChiTietHD.DonGia
from HoaDon inner join KhachHang on HoaDon.MaKH = KhachHang.MaKH inner join NhanVien on NhanVien.MaNV = HoaDon.MaNV inner join ChiTietHD on ChiTietHD.MaHD = HoaDon.MaHD inner join MatHang on MatHang.MaMH = ChiTietHD.MaMH
where HoaDon.MaHD = @mahd
GO





/****** Object:  StoredProcedure [dbo].[USP_ThongKe7Ngay]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ThongKe7Ngay]
@ngaybd date, @ngaykt date
AS
BEGIN
	select DAY(NgayTao) AS 'Ngay', sum(HoaDon.TongTien) AS 'TongTien'
	from HoaDon
	where @ngaybd <= HoaDon.NgayTao and @ngaykt >= HoaDon.NgayTao
	group by NgayTao 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThongKeDoanhThuTrongThang]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ThongKeDoanhThuTrongThang]
@ngaybd date, @ngaykt date
AS
BEGIN
	select NgayTao AS 'Ngay', sum(HoaDon.TongTien) AS 'TongTien'
	from HoaDon
	where @ngaybd <= HoaDon.NgayTao and @ngaykt >= HoaDon.NgayTao
	group by NgayTao 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKhanghoa]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[USP_TKhanghoa]
as
select MatHang.MaMH as [Mã hàng hóa],MatHang.TenMH as [Tên hàng hóa],DonViTinh.TenDVT as [Đơn vị tính],sum(ChitietPN.Soluong) as [Số lượng nhập],MatHang.SoLuong as [Số lượng tồn], (sum(ChitietPN.Soluong) - MatHang.SoLuong) as [Số lượng bán],MatHang.GiaBan as [Giá bán]
from MatHang inner join ChiTietPN on MatHang.MaMH = ChiTietPN.MaMH inner join DonViTinh on DonViTinh.MaDVT = MatHang.DonVi
group by MatHang.MaMH,MatHang.SoLuong,MatHang.TenMH,MatHang.DonVi,DonViTinh.TenDVT,MatHang.GiaBan
GO
/****** Object:  StoredProcedure [dbo].[USP_TKKH]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TKKH]
AS
BEGIN
select KhachHang.MaKH as [Mã khách hàng], KhachHang.TenKH as [Tên khách hàng], KhachHang.SDT as [Số điện thoại],SUM(HoaDon.TongTien) AS [Tổng Tiền], COUNT(HoaDon.MaHD) AS [Số lần mua hàng]
from HoaDon, KhachHang
where KhachHang.MaKH = HoaDon.MaKH
group by KhachHang.TenKH, KhachHang.MaKH, KhachHang.SDT, KhachHang.DiaChi, KhachHang.Email
order by SUM(HoaDon.TongTien) desc
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKKhachHang]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TKKhachHang]
AS
BEGIN
select KhachHang.MaKH as [Mã khách hàng], KhachHang.TenKH as [Tên khách hàng], KhachHang.SDT as [Số điện thoại],SUM(HoaDon.TongTien) AS [Tổng Tiền], COUNT(HoaDon.MaHD) AS [Số lần mua hàng]
from HoaDon, KhachHang
where KhachHang.MaKH = HoaDon.MaKH
group by KhachHang.TenKH, KhachHang.MaKH, KhachHang.SDT, KhachHang.DiaChi, KhachHang.Email
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKMatHang]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[USP_TKMatHang]
as
select MatHang.MaMH as [Mã hàng hóa],MatHang.TenMH as [Tên hàng hóa],TenDVT as [Đơn vị],sum(ChitietPN.Soluong) as [Số lượng nhập],MatHang.SoLuong as [Số lượng tồn], (sum(ChitietPN.Soluong) - MatHang.SoLuong) as [Số lượng bán],MatHang.GiaBan as [Giá bán]
from MatHang inner join ChiTietPN on MatHang.MaMH = ChiTietPN.MaMH inner join DonViTinh on MatHang.MaDVT = DonViTinh.MaDVT
group by MatHang.MaMH,MatHang.SoLuong,MatHang.TenMH,TenDVT,MatHang.GiaBan
GO
/****** Object:  StoredProcedure [dbo].[USP_tkPhieunhap]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[USP_tkPhieunhap]
as
select MaPN as [Mã phiểu nhập], NgayNhap as[ Ngày nhập hàng],TenNCC as [Nhà cung cấp],TenHienThi as [Nhân viên nhập]
from PhieuNhap inner join NhaCungCap on PhieuNhap.MaNCC = NhaCungCap.MaNCC inner join NhanVien on PhieuNhap.MaNV = NhanVien.MaNV
GO
/****** Object:  StoredProcedure [dbo].[USP_XemChiTietPN]    Script Date: 12/23/2021 4:06:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[USP_XemChiTietPN](
   @mapn nchar (10)
)
as
select ChiTietPN.MaPN,ChiTietPN.MaMH,MatHang.TenMH,ChiTietPN.SoLuong,ChiTietPN.DonGia,PhieuNhap.MaNV,NhanVien.TenHienThi,NhanVien.Quyen,PhieuNhap.MaNCC,NhaCungCap.TenNCC,PhieuNhap.NgayNhap
from  ChiTietPN inner join MatHang on ChiTietPN.MaMH = MatHang.MaMH inner join PhieuNhap on ChiTietPN.MaPN = PhieuNhap.MaPN inner join NhanVien on NhanVien.MaNV = PhieuNhap.MaNV inner join NhaCungCap on PhieuNhap.MaNCC = NhaCungCap.MaNCC
where ChiTietPN.MaPN = @mapn
GO
