USE [master]
GO
/****** Object:  Database [Canteen_Management]    Script Date: 30/06/2021 3:01:48 AM ******/
CREATE DATABASE [Canteen_Management]
-- CONTAINMENT = NONE
-- ON  PRIMARY 
--( NAME = N'Canteen_Management', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Canteen_Management.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
-- LOG ON 
--( NAME = N'Canteen_Management_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Canteen_Management_log.ldf' , SIZE = 816KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Canteen_Management] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Canteen_Management].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Canteen_Management] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Canteen_Management] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Canteen_Management] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Canteen_Management] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Canteen_Management] SET ARITHABORT OFF 
GO
ALTER DATABASE [Canteen_Management] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Canteen_Management] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Canteen_Management] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Canteen_Management] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Canteen_Management] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Canteen_Management] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Canteen_Management] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Canteen_Management] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Canteen_Management] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Canteen_Management] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Canteen_Management] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Canteen_Management] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Canteen_Management] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Canteen_Management] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Canteen_Management] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Canteen_Management] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Canteen_Management] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Canteen_Management] SET RECOVERY FULL 
GO
ALTER DATABASE [Canteen_Management] SET  MULTI_USER 
GO
ALTER DATABASE [Canteen_Management] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Canteen_Management] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Canteen_Management] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Canteen_Management] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Canteen_Management] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Canteen_Management]
GO
/****** Object:  Table [dbo].[BatchDetails]    Script Date: 30/06/2021 3:01:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NOT NULL,
	[ItemName] [nvarchar](100) NOT NULL,
	[ItemQuantity] [int] NOT NULL,
	[ItemPrice] [float] NOT NULL,
	[OrderId] [int] NOT NULL,
	[OrderedOn] [datetime] NULL,
	[OrderedBy] [nvarchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CartItems]    Script Date: 30/06/2021 3:01:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CartItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[StockId] [int] NOT NULL,
	[UserName] [nvarchar](250) NULL,
	[ItemName] [nvarchar](200) NULL,
	[Quantity] [int] NULL DEFAULT ((1)),
	[Price] [float] NULL,
	[AddedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerOrderItems]    Script Date: 30/06/2021 3:01:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerOrderItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StockId] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[UserName] [nvarchar](250) NULL,
	[ItemName] [nvarchar](250) NULL,
	[Quantity] [int] NULL,
	[Price] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerOrders]    Script Date: 30/06/2021 3:01:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerOrders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CustomerName] [nvarchar](250) NULL,
	[OrderTotal] [float] NULL,
	[OrderedItems] [int] NULL,
	[OrderedOn] [datetime] NULL,
	[isConfirmed] [bit] NULL DEFAULT ((0)),
	[ProcessedBy] [int] NULL,
	[ProcessedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Stock]    Script Date: 30/06/2021 3:01:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stock](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [nvarchar](100) NOT NULL,
	[ItemImagePath] [nvarchar](250) NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitofMeasurement] [nvarchar](50) NOT NULL,
	[CostPricePerPiece] [float] NOT NULL,
	[MfgDt] [datetime] NOT NULL,
	[ExpDt] [datetime] NOT NULL,
	[AvailableQty] [int] NOT NULL,
	[LastOrderdOn] [date] NOT NULL,
	[LastOrderedQty] [int] NOT NULL,
	[BatchNo] [int] NULL,
	[ItemType] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[Threshold] [int] NOT NULL,
	[SellingPricePerPiece] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StockBatch]    Script Date: 30/06/2021 3:01:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockBatch](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TotalItems] [int] NOT NULL,
	[TotalQuantity] [int] NOT NULL,
	[TotalPrice] [float] NOT NULL,
	[isComplete] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserProfile]    Script Date: 30/06/2021 3:01:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserProfile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[FName] [nvarchar](50) NOT NULL,
	[LName] [nvarchar](50) NOT NULL,
	[UserImagePath] [nvarchar](250) NULL,
	[Age] [int] NULL,
	[Email] [nvarchar](100) NULL,
	[Address] [nvarchar](500) NULL,
	[MobileNo] [nvarchar](15) NULL,
	[Gender] [nchar](10) NULL,
	[City] [nvarchar](100) NULL,
	[State] [nvarchar](100) NULL,
	[Pincode] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 30/06/2021 3:01:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Role] [nvarchar](50) NOT NULL,
	[isActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[BatchDetails] ON 

INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (2, 2, N'Abc', 10, 100, 1003, CAST(N'2021-06-26 01:33:54.107' AS DateTime), N'pushkar@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (3, 1, N'Samosa', 10, 80, 1003, CAST(N'2021-06-26 01:34:00.253' AS DateTime), N'pushkar@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (4, 4, N'Popcorn1', 12, 120, 1004, CAST(N'2021-06-26 01:38:12.547' AS DateTime), N'pushkar@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (5, 5, N'Popcorn2', 25, 250, 1004, CAST(N'2021-06-26 01:38:12.547' AS DateTime), N'pushkar@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (6, 1, N'Samosa', 500, 4000, 1005, CAST(N'2021-06-26 01:42:53.677' AS DateTime), N'pushkar@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (7, 3, N'Popcorn', 200, 5000, 1005, CAST(N'2021-06-26 01:42:53.680' AS DateTime), N'pushkar@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (8, 3, N'Popcorn', 12, 300, 1006, CAST(N'2021-06-29 15:24:41.297' AS DateTime), N'pushkar@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (9, 1, N'Samosa', 2, 16, 1006, CAST(N'2021-06-29 15:24:41.337' AS DateTime), N'pushkar@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (10, 6, N'Noodles', 10, 300, 1007, CAST(N'2021-06-29 17:15:46.737' AS DateTime), N'pushkar@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (11, 2, N'Abc', 10, 100, 1007, CAST(N'2021-06-29 17:15:46.747' AS DateTime), N'pushkar@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (12, 2, N'Kachori', 10, 100, 1008, CAST(N'2021-06-30 00:47:06.320' AS DateTime), N'sayali@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (13, 4, N'Chole Bhature', 50, 500, 1008, CAST(N'2021-06-30 00:47:06.327' AS DateTime), N'sayali@mycanteen.com')
INSERT [dbo].[BatchDetails] ([Id], [ItemId], [ItemName], [ItemQuantity], [ItemPrice], [OrderId], [OrderedOn], [OrderedBy]) VALUES (14, 1, N'Samosa', 15, 120, 1008, CAST(N'2021-06-30 00:47:06.330' AS DateTime), N'sayali@mycanteen.com')
SET IDENTITY_INSERT [dbo].[BatchDetails] OFF
SET IDENTITY_INSERT [dbo].[CartItems] ON 

INSERT [dbo].[CartItems] ([Id], [UserId], [StockId], [UserName], [ItemName], [Quantity], [Price], [AddedOn]) VALUES (22, 4, 1, N'sarvesh@mycanteen.com', N'Samosa', 5, 50, CAST(N'2021-06-29 17:37:24.757' AS DateTime))
SET IDENTITY_INSERT [dbo].[CartItems] OFF
SET IDENTITY_INSERT [dbo].[CustomerOrderItems] ON 

INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (1, 3, 4, 4, N'sarvesh@mycanteen.com', N'Popcorn', 2, 100)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (2, 3, 5, 4, N'sarvesh@mycanteen.com', N'Popcorn', 1, 50)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (3, 1, 5, 4, N'sarvesh@mycanteen.com', N'Samosa', 1, 10)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (4, 1, 6, 4, N'sarvesh@mycanteen.com', N'Samosa', 2, 20)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (5, 4, 6, 4, N'sarvesh@mycanteen.com', N'Popcorn1', 1, 20)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (6, 1, 7, 5, N'rutika@mycanteen.com', N'Samosa', 2, 20)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (7, 3, 7, 5, N'rutika@mycanteen.com', N'Popcorn', 1, 50)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (8, 4, 8, 4, N'sarvesh@mycanteen.com', N'Popcorn1', 1, 20)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (9, 3, 9, 4, N'sarvesh@mycanteen.com', N'Popcorn', 1, 50)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (10, 1, 9, 4, N'sarvesh@mycanteen.com', N'Samosa', 1, 10)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (11, 5, 9, 4, N'sarvesh@mycanteen.com', N'Popcorn2', 1, 20)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (12, 1, 10, 8, N'ashwini@mycanteen.com', N'Samosa', 1, 10)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (13, 5, 10, 8, N'ashwini@mycanteen.com', N'Pizza', 1, 300)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (14, 6, 10, 8, N'ashwini@mycanteen.com', N'Noodles', 1, 40)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (15, 6, 11, 5, N'rutika@mycanteen.com', N'Noodles', 2, 80)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (16, 1, 11, 5, N'rutika@mycanteen.com', N'Samosa', 1, 10)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (17, 2, 11, 5, N'hritika@mycanteen.com', N'Kachori', 2, 30)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (18, 3, 12, 3, N'dipashri@mycanteen.com', N'Popcorn', 2, 100)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (19, 4, 13, 8, N'ashwini@mycanteen.com', N'Chole Bhature', 1, 90)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (20, 3, 13, 8, N'ashwini@mycanteen.com', N'Popcorn', 1, 50)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (21, 4, 14, 8, N'ashwini@mycanteen.com', N'Chole Bhature', 1, 90)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (22, 5, 14, 8, N'ashwini@mycanteen.com', N'Pizza', 2, 600)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (23, 3, 15, 8, N'ashwini@mycanteen.com', N'Popcorn', 1, 50)
INSERT [dbo].[CustomerOrderItems] ([Id], [StockId], [OrderId], [UserId], [UserName], [ItemName], [Quantity], [Price]) VALUES (24, 2, 16, 8, N'ashwini@mycanteen.com', N'Kachori', 2, 30)
SET IDENTITY_INSERT [dbo].[CustomerOrderItems] OFF
SET IDENTITY_INSERT [dbo].[CustomerOrders] ON 

INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (1, 3, N'Dipashri', 510, 4, CAST(N'2021-06-05 00:00:00.000' AS DateTime), 0, 1, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (3, 4, N'Sarvesh', 200, 5, CAST(N'2021-06-05 05:30:00.000' AS DateTime), 1, 2, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (4, 4, N'Sarvesh Chaudhari', 100, 2, CAST(N'2021-06-29 13:28:25.887' AS DateTime), 1, 2, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (5, 4, N'Sarvesh Chaudhari', 60, 2, CAST(N'2021-06-29 13:29:07.523' AS DateTime), 1, 2, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (6, 4, N'Sarvesh Chaudhari', 40, 3, CAST(N'2021-06-29 15:55:38.387' AS DateTime), 1, 1, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (7, 5, N'Rutika Patil', 70, 3, CAST(N'2021-06-29 16:56:32.073' AS DateTime), 1, 1, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (8, 4, N'Sarvesh Chaudhari', 20, 1, CAST(N'2021-06-29 16:57:49.987' AS DateTime), 1, NULL, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (9, 4, N'Sarvesh Chaudhari', 80, 3, CAST(N'2021-06-29 17:09:47.063' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (10, 8, N'Ashwini Patil', 350, 3, CAST(N'2021-06-30 00:26:01.757' AS DateTime), 1, 6, CAST(N'2021-06-30 00:27:38.327' AS DateTime))
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (11, 5, N'Hritika Patil', 120, 5, CAST(N'2021-06-30 00:34:35.453' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (12, 3, N'Dipashri Deshmukh', 100, 2, CAST(N'2021-06-30 00:35:44.413' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (13, 8, N'Ashwini Patil', 140, 2, CAST(N'2021-06-30 01:56:29.873' AS DateTime), 0, 6, CAST(N'2021-06-30 01:57:57.907' AS DateTime))
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (14, 8, N'Ashwini Patil', 690, 3, CAST(N'2021-06-30 01:58:17.467' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (15, 8, N'Ashwini Patil', 50, 1, CAST(N'2021-06-30 01:59:09.207' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[CustomerOrders] ([Id], [CustomerId], [CustomerName], [OrderTotal], [OrderedItems], [OrderedOn], [isConfirmed], [ProcessedBy], [ProcessedOn]) VALUES (16, 8, N'Ashwini Patil', 30, 2, CAST(N'2021-06-30 01:59:57.353' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomerOrders] OFF
SET IDENTITY_INSERT [dbo].[Stock] ON 

INSERT [dbo].[Stock] ([Id], [ItemName], [ItemImagePath], [Quantity], [UnitofMeasurement], [CostPricePerPiece], [MfgDt], [ExpDt], [AvailableQty], [LastOrderdOn], [LastOrderedQty], [BatchNo], [ItemType], [Description], [Threshold], [SellingPricePerPiece]) VALUES (1, N'Samosa', N'/Images/Samosa.jpg', 2, N'pcs', 8, CAST(N'2021-06-08 00:00:00.000' AS DateTime), CAST(N'2021-06-10 00:00:00.000' AS DateTime), 5, CAST(N'2021-06-30' AS Date), 15, 1008, N'Snacks', NULL, 10, 10)
INSERT [dbo].[Stock] ([Id], [ItemName], [ItemImagePath], [Quantity], [UnitofMeasurement], [CostPricePerPiece], [MfgDt], [ExpDt], [AvailableQty], [LastOrderdOn], [LastOrderedQty], [BatchNo], [ItemType], [Description], [Threshold], [SellingPricePerPiece]) VALUES (2, N'Kachori', N'/Images/Kachori.jpg', 2, N'pcs', 10, CAST(N'2021-06-24 00:00:00.000' AS DateTime), CAST(N'2021-07-08 00:00:00.000' AS DateTime), 30, CAST(N'2021-06-30' AS Date), 10, 1008, N'Snacks', N'dgguj
hhjkj', 12, 15)
INSERT [dbo].[Stock] ([Id], [ItemName], [ItemImagePath], [Quantity], [UnitofMeasurement], [CostPricePerPiece], [MfgDt], [ExpDt], [AvailableQty], [LastOrderdOn], [LastOrderedQty], [BatchNo], [ItemType], [Description], [Threshold], [SellingPricePerPiece]) VALUES (3, N'Popcorn', N'/Images/Popcorn.jpg', 100, N'grams', 25, CAST(N'2021-06-27 00:00:00.000' AS DateTime), CAST(N'2021-08-05 00:00:00.000' AS DateTime), 212, CAST(N'2021-06-29' AS Date), 12, 1006, N'Snacks', N'Popcorn', 2, 50)
INSERT [dbo].[Stock] ([Id], [ItemName], [ItemImagePath], [Quantity], [UnitofMeasurement], [CostPricePerPiece], [MfgDt], [ExpDt], [AvailableQty], [LastOrderdOn], [LastOrderedQty], [BatchNo], [ItemType], [Description], [Threshold], [SellingPricePerPiece]) VALUES (4, N'Chole Bhature', N'/Images/Chole.jpg', 1, N'plate', 10, CAST(N'2021-06-27 00:00:00.000' AS DateTime), CAST(N'2021-08-05 00:00:00.000' AS DateTime), 55, CAST(N'2021-06-30' AS Date), 50, 1008, N'Punjabi', NULL, 10, 90)
INSERT [dbo].[Stock] ([Id], [ItemName], [ItemImagePath], [Quantity], [UnitofMeasurement], [CostPricePerPiece], [MfgDt], [ExpDt], [AvailableQty], [LastOrderdOn], [LastOrderedQty], [BatchNo], [ItemType], [Description], [Threshold], [SellingPricePerPiece]) VALUES (5, N'Pizza', N'/Images/Pizza.jpg', 8, N'slices', 180, CAST(N'2021-06-24 00:00:00.000' AS DateTime), CAST(N'2021-07-08 00:00:00.000' AS DateTime), 30, CAST(N'2021-06-25' AS Date), 5, 1, N'Italian', NULL, 4, 300)
INSERT [dbo].[Stock] ([Id], [ItemName], [ItemImagePath], [Quantity], [UnitofMeasurement], [CostPricePerPiece], [MfgDt], [ExpDt], [AvailableQty], [LastOrderdOn], [LastOrderedQty], [BatchNo], [ItemType], [Description], [Threshold], [SellingPricePerPiece]) VALUES (6, N'Noodles', N'/Images/Noodles.jpg', 1, N'bowl', 30, CAST(N'2021-06-29 00:00:00.000' AS DateTime), CAST(N'2021-06-30 00:00:00.000' AS DateTime), 11, CAST(N'2021-06-29' AS Date), 10, 1007, N'Chinese', N'Hakka Noodles....', 5, 40)
SET IDENTITY_INSERT [dbo].[Stock] OFF
SET IDENTITY_INSERT [dbo].[StockBatch] ON 

INSERT [dbo].[StockBatch] ([Id], [TotalItems], [TotalQuantity], [TotalPrice], [isComplete]) VALUES (1, 0, 0, 0, 0)
INSERT [dbo].[StockBatch] ([Id], [TotalItems], [TotalQuantity], [TotalPrice], [isComplete]) VALUES (2, 0, 0, 0, 0)
INSERT [dbo].[StockBatch] ([Id], [TotalItems], [TotalQuantity], [TotalPrice], [isComplete]) VALUES (1003, 2, 20, 180, 1)
INSERT [dbo].[StockBatch] ([Id], [TotalItems], [TotalQuantity], [TotalPrice], [isComplete]) VALUES (1004, 2, 37, 370, 1)
INSERT [dbo].[StockBatch] ([Id], [TotalItems], [TotalQuantity], [TotalPrice], [isComplete]) VALUES (1005, 2, 700, 9000, 1)
INSERT [dbo].[StockBatch] ([Id], [TotalItems], [TotalQuantity], [TotalPrice], [isComplete]) VALUES (1006, 2, 14, 316, 1)
INSERT [dbo].[StockBatch] ([Id], [TotalItems], [TotalQuantity], [TotalPrice], [isComplete]) VALUES (1007, 2, 20, 400, 1)
INSERT [dbo].[StockBatch] ([Id], [TotalItems], [TotalQuantity], [TotalPrice], [isComplete]) VALUES (1008, 3, 75, 720, 1)
SET IDENTITY_INSERT [dbo].[StockBatch] OFF
SET IDENTITY_INSERT [dbo].[UserProfile] ON 

INSERT [dbo].[UserProfile] ([Id], [UserId], [FName], [LName], [UserImagePath], [Age], [Email], [Address], [MobileNo], [Gender], [City], [State], [Pincode]) VALUES (1, 4, N'Sarvesh', N'Chaudhari', NULL, NULL, N'sarvesh@mycanteen.com', NULL, N'8698187081', NULL, NULL, NULL, NULL)
INSERT [dbo].[UserProfile] ([Id], [UserId], [FName], [LName], [UserImagePath], [Age], [Email], [Address], [MobileNo], [Gender], [City], [State], [Pincode]) VALUES (2, 3, N'Dipashri', N'Deshmukh', N'/Profiles/DipashriDeshmukh.jpg', NULL, N'dipashri@mycanteen.com', NULL, N'7769827297', NULL, NULL, NULL, NULL)
INSERT [dbo].[UserProfile] ([Id], [UserId], [FName], [LName], [UserImagePath], [Age], [Email], [Address], [MobileNo], [Gender], [City], [State], [Pincode]) VALUES (3, 5, N'Hritika', N'Patil', N'/Profiles/HritikaPatil.jpg', NULL, N'rutika@mycanteen.com', NULL, N'8888888888', NULL, NULL, NULL, NULL)
INSERT [dbo].[UserProfile] ([Id], [UserId], [FName], [LName], [UserImagePath], [Age], [Email], [Address], [MobileNo], [Gender], [City], [State], [Pincode]) VALUES (4, 2, N'Dhanashri', N'Randive', N'/Profiles/DhanashriRandive.jpg', NULL, N'dhanashri@mycanteen.com', NULL, N'1234567890', NULL, NULL, NULL, NULL)
INSERT [dbo].[UserProfile] ([Id], [UserId], [FName], [LName], [UserImagePath], [Age], [Email], [Address], [MobileNo], [Gender], [City], [State], [Pincode]) VALUES (5, 1, N'Pushkar', N'Asapure', NULL, NULL, N'pushkar@mycanteen.com', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserProfile] ([Id], [UserId], [FName], [LName], [UserImagePath], [Age], [Email], [Address], [MobileNo], [Gender], [City], [State], [Pincode]) VALUES (6, 6, N'Suma', N'Eshava', N'/Profiles/SumaEshava.jpg', NULL, N'suma@mycanteen.com', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserProfile] ([Id], [UserId], [FName], [LName], [UserImagePath], [Age], [Email], [Address], [MobileNo], [Gender], [City], [State], [Pincode]) VALUES (7, 7, N'Sayali', N'Mahale', N'/Profiles/SayaliMahale.jpg', NULL, N'sayali@mycanteen.com', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserProfile] ([Id], [UserId], [FName], [LName], [UserImagePath], [Age], [Email], [Address], [MobileNo], [Gender], [City], [State], [Pincode]) VALUES (8, 8, N'Ashwini', N'Patil', N'/Profiles/AshwiniPatil.jpg', NULL, N'ashwini@mycanteen.com', NULL, N'7777777777', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[UserProfile] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [Username], [Password], [Role], [isActive]) VALUES (1, N'pushkar@mycanteen.com', N'push@123', N'Admin', 1)
INSERT [dbo].[Users] ([Id], [Username], [Password], [Role], [isActive]) VALUES (2, N'dhanashri@mycanteen.com', N'dhan@123', N'Staff', 1)
INSERT [dbo].[Users] ([Id], [Username], [Password], [Role], [isActive]) VALUES (3, N'dipashri@mycanteen.com', N'dip@123', N'Customer', 1)
INSERT [dbo].[Users] ([Id], [Username], [Password], [Role], [isActive]) VALUES (4, N'sarvesh@mycanteen.com', N'sarvesh', N'Customer', 1)
INSERT [dbo].[Users] ([Id], [Username], [Password], [Role], [isActive]) VALUES (5, N'hritika@mycanteen.com', N'hritika ', N'Customer', 1)
INSERT [dbo].[Users] ([Id], [Username], [Password], [Role], [isActive]) VALUES (6, N'suma@mycanteen.com', N'suma', N'Staff', 1)
INSERT [dbo].[Users] ([Id], [Username], [Password], [Role], [isActive]) VALUES (7, N'sayali@mycanteen.com', N'sayali', N'Admin', 1)
INSERT [dbo].[Users] ([Id], [Username], [Password], [Role], [isActive]) VALUES (8, N'ashwini@mycanteen.com', N'ashwini', N'Customer', 1)
SET IDENTITY_INSERT [dbo].[Users] OFF
ALTER TABLE [dbo].[BatchDetails]  WITH CHECK ADD FOREIGN KEY([ItemId])
REFERENCES [dbo].[Stock] ([Id])
GO
ALTER TABLE [dbo].[BatchDetails]  WITH CHECK ADD FOREIGN KEY([OrderId])
REFERENCES [dbo].[StockBatch] ([Id])
GO
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD FOREIGN KEY([StockId])
REFERENCES [dbo].[Stock] ([Id])
GO
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CustomerOrderItems]  WITH CHECK ADD FOREIGN KEY([OrderId])
REFERENCES [dbo].[CustomerOrders] ([Id])
GO
ALTER TABLE [dbo].[CustomerOrderItems]  WITH CHECK ADD FOREIGN KEY([StockId])
REFERENCES [dbo].[Stock] ([Id])
GO
ALTER TABLE [dbo].[CustomerOrderItems]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CustomerOrders]  WITH CHECK ADD FOREIGN KEY([ProcessedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CustomerOrders]  WITH CHECK ADD FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Stock]  WITH CHECK ADD FOREIGN KEY([BatchNo])
REFERENCES [dbo].[StockBatch] ([Id])
GO
ALTER TABLE [dbo].[UserProfile]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
USE [master]
GO
ALTER DATABASE [Canteen_Management] SET  READ_WRITE 
GO
