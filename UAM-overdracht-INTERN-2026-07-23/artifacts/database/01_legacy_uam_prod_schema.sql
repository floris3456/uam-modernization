-- UAM legacy production schema export
-- Source: GGWVSQLA002 / IAM
-- CapturedAtUtc: 2026-07-23T19:37:15.2820596Z
-- Read-only export; contains schema only.

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActionLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ActionLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ActionType] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[TableName] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[RecordID] [varchar](128) COLLATE Latin1_General_CI_AS NULL,
	[ChangedFields] [nvarchar](max) COLLATE Latin1_General_CI_AS NULL,
	[UserName] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Timestamp] [datetime] NULL,
 CONSTRAINT [PK__ActionLo__5E5499A8FE30DAA7] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ActionLog__Times__39FAD09E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ActionLog] ADD  CONSTRAINT [DF__ActionLog__Times__39FAD09E]  DEFAULT (getdate()) FOR [Timestamp]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceApplicationMatches]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceApplicationMatches](
	[DeviceApplicationMatchID] [int] IDENTITY(1,1) NOT NULL,
	[DeviceApplicationID] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DeviceApplicationDomainExpression] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[DeviceApplicationProcessnameExpression] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[WhenCreated] [datetime] NULL,
	[Enabled] [bit] NULL,
 CONSTRAINT [PK_DeviceApplicationMatches] PRIMARY KEY CLUSTERED 
(
	[DeviceApplicationMatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceApplicationMatches_WhenCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceApplicationMatches] ADD  CONSTRAINT [DF_DeviceApplicationMatches_WhenCreated]  DEFAULT (getdate()) FOR [WhenCreated]
END


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceApplicationMatches_Enabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceApplicationMatches] ADD  CONSTRAINT [DF_DeviceApplicationMatches_Enabled]  DEFAULT ((1)) FOR [Enabled]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceBrowserLogging]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceBrowserLogging](
	[datetimestamp] [datetime] NULL,
	[computername] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[username] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[userdomain] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[browser] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[datetime] [datetime2](7) NULL,
	[domain] [varchar](2000) COLLATE Latin1_General_CI_AS NULL,
	[url] [varchar](2000) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceBrowserLogging_datetimestamp]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceBrowserLogging] ADD  CONSTRAINT [DF_DeviceBrowserLogging_datetimestamp]  DEFAULT (getdate()) FOR [datetimestamp]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceBrowserLogging_Archive]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceBrowserLogging_Archive](
	[datetimestamp] [datetime] NULL,
	[computername] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[username] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[userdomain] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[browser] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[datetime] [datetime2](7) NULL,
	[domain] [varchar](2000) COLLATE Latin1_General_CI_AS NULL,
	[url] [varchar](2000) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END

SET ANSI_PADDING ON


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DeviceBrowserLogging_Archive]') AND name = N'IX_DeviceBrowserLogging_Archive_username')
CREATE NONCLUSTERED INDEX [IX_DeviceBrowserLogging_Archive_username] ON [dbo].[DeviceBrowserLogging_Archive]
(
	[username] ASC
)
INCLUDE([domain]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceBrowserLogging2Exclude]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceBrowserLogging2Exclude](
	[DeviceBrowserLogging2ExcludeID] [int] IDENTITY(1,1) NOT NULL,
	[DomainExpression] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[URLexpression] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[Description] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Group] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Remarks] [varchar](200) COLLATE Latin1_General_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateBy] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Enabled] [bit] NULL,
 CONSTRAINT [PK_DeviceBrowserLogging2Exclude] PRIMARY KEY CLUSTERED 
(
	[DeviceBrowserLogging2ExcludeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceBrowserLogging2Exclude_WhenCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceBrowserLogging2Exclude] ADD  CONSTRAINT [DF_DeviceBrowserLogging2Exclude_WhenCreated]  DEFAULT (getdate()) FOR [CreateDate]
END


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceBrowserLogging2Exclude_CreateBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceBrowserLogging2Exclude] ADD  CONSTRAINT [DF_DeviceBrowserLogging2Exclude_CreateBy]  DEFAULT (suser_sname()) FOR [CreateBy]
END


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceBrowserLogging2Exclude_Enabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceBrowserLogging2Exclude] ADD  CONSTRAINT [DF_DeviceBrowserLogging2Exclude_Enabled]  DEFAULT ((1)) FOR [Enabled]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceLoggingErrors]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceLoggingErrors](
	[DatetimeStamp] [datetime] NULL,
	[Computername] [varchar](128) COLLATE Latin1_General_CI_AS NULL,
	[UserName] [varchar](128) COLLATE Latin1_General_CI_AS NULL,
	[UserDNSDomain] [varchar](128) COLLATE Latin1_General_CI_AS NULL,
	[LogLevel] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[ErrorMessage] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Script] [varchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[Line] [int] NULL,
	[Position] [int] NULL,
	[CallStack] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[uam_commandline] [varchar](250) COLLATE Latin1_General_CI_AS NULL,
	[UAM_CreationDate] [datetime] NULL,
	[UAM_Version] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[UAM_Settings] [varchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[WindowsVersion] [varchar](50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceLoggingSettings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceLoggingSettings](
	[Setting_code] [varchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
	[Setting_Description_short] [varchar](128) COLLATE Latin1_General_CI_AS NULL,
	[Setting_Description_long] [nvarchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[Setting_Group] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[Setting_Value] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Setting_measurement_unit] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Setting_ValueType] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Setting_Enabled] [bit] NULL,
 CONSTRAINT [PK_DeviceLoggingSettings2] PRIMARY KEY CLUSTERED 
(
	[Setting_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceLoggingSettings2_Setting_Enabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceLoggingSettings] ADD  CONSTRAINT [DF_DeviceLoggingSettings2_Setting_Enabled]  DEFAULT ((1)) FOR [Setting_Enabled]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceLoggingUserAdGroupMembers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceLoggingUserAdGroupMembers](
	[DeviceLoggingUserAdGroupMemberID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[AdUser_ObjectGuid] [uniqueidentifier] NULL,
	[AdGroup_ObjectGuid] [uniqueidentifier] NULL,
	[WhenCreated] [datetime] NULL
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceLoggingUserAdGroupMembers_WhenCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceLoggingUserAdGroupMembers] ADD  CONSTRAINT [DF_DeviceLoggingUserAdGroupMembers_WhenCreated]  DEFAULT (getdate()) FOR [WhenCreated]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceLoggingUsers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceLoggingUsers](
	[LoggingUserID] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[userdomain] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[computername] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[NonpersistentComputer] [bit] NULL,
	[startlogging] [bit] NULL,
	[LastWindowsProcessesLogDateTime] [datetime2](7) NULL,
	[LastRecentFilesLogDateTime] [datetime2](7) NULL,
	[LastBrowserEdgeLogDateTime] [datetime2](7) NULL,
	[LastBrowserFireFoxLogDateTime] [datetime2](7) NULL,
	[LastBrowserChromeLogDateTime] [datetime2](7) NULL,
	[LoggingStartedDateTime] [datetime2](7) NULL,
	[LoggingStartedUAMprocessPID] [int] NULL,
	[LoggingEndedDateTime] [datetime2](7) NULL,
	[LoggingStatus] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[whencreated] [datetime] NULL,
	[lastlogon] [datetime] NULL,
	[UAMProcessName] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[UAMVersion] [varchar](200) COLLATE Latin1_General_CI_AS NULL,
	[UAMCreated] [datetime] NULL,
	[UAMInstallDate] [datetime] NULL,
	[UAMStartedElevated] [bit] NULL,
	[UAMStartupDateTime] [datetime] NULL,
	[UAMShutdownDateTime] [datetime] NULL,
	[UAMprocessMaxMemoryMB] [float] NULL,
	[UAMprocessLastMemoryMB] [float] NULL,
	[CsVPath] [varchar](200) COLLATE Latin1_General_CI_AS NULL,
	[LastProcessLogDateTime] [datetime2](7) NULL,
	[LastBrowserLogDateTime] [datetime2](7) NULL,
	[LastRecentFilesAndFoldersDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_DeviceLoggingUsers] PRIMARY KEY CLUSTERED 
(
	[LoggingUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceLoggingUsers_whencreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceLoggingUsers] ADD  CONSTRAINT [DF_DeviceLoggingUsers_whencreated]  DEFAULT (getdate()) FOR [whencreated]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceLoggingUserSettings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceLoggingUserSettings](
	[DeviceLoggingUserSettingID] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[userdomain] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[computername] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Setting_code] [varchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
	[Setting_Value] [varchar](max) COLLATE Latin1_General_CI_AS NOT NULL,
	[Setting_Enabled] [bit] NULL,
	[Setting_ValueType] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK__DeviceLo__37B513C4E8C63330] PRIMARY KEY CLUSTERED 
(
	[DeviceLoggingUserSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__DeviceLog__Setti__2ACF3255]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceLoggingUserSettings] ADD  CONSTRAINT [DF__DeviceLog__Setti__2ACF3255]  DEFAULT ((1)) FOR [Setting_Enabled]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceProcess2Exclude]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceProcess2Exclude](
	[Process2ExcludeID] [int] IDENTITY(1,1) NOT NULL,
	[Processname] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[ProcessnameExpression] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[FullpathExecutable] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[FullpathExecutableExpression] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[Product] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[ProductExpression] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[Company] [varchar](200) COLLATE Latin1_General_CI_AS NULL,
	[CompanyExpression] [varchar](200) COLLATE Latin1_General_CI_AS NULL,
	[Description] [varchar](200) COLLATE Latin1_General_CI_AS NULL,
	[group] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[enabled] [bit] NULL,
	[createdate] [datetime2](7) NULL,
 CONSTRAINT [PK_DeviceProcess2Exclude] PRIMARY KEY CLUSTERED 
(
	[Process2ExcludeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceProcess2Exclude_enabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceProcess2Exclude] ADD  CONSTRAINT [DF_DeviceProcess2Exclude_enabled]  DEFAULT ((1)) FOR [enabled]
END


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceProcess2Exclude_createdate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceProcess2Exclude] ADD  CONSTRAINT [DF_DeviceProcess2Exclude_createdate]  DEFAULT (getdate()) FOR [createdate]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceProcessLogging]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceProcessLogging](
	[datetimestamp] [datetime] NULL,
	[computername] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[username] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[userdomain] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[starttime] [datetime2](7) NULL,
	[processname] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[FullpathExecutable] [varchar](2000) COLLATE Latin1_General_CI_AS NULL,
	[product] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[company] [varchar](200) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceProcessLogging_datetimestamp]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceProcessLogging] ADD  CONSTRAINT [DF_DeviceProcessLogging_datetimestamp]  DEFAULT (getdate()) FOR [datetimestamp]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceProcessLogging_Archive]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceProcessLogging_Archive](
	[datetimestamp] [datetime] NULL,
	[computername] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[username] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[userdomain] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[starttime] [datetime2](7) NULL,
	[processname] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[FullpathExecutable] [varchar](2000) COLLATE Latin1_General_CI_AS NULL,
	[product] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[company] [varchar](200) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceRecentFileAndFolderLogging]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceRecentFileAndFolderLogging](
	[datetimestamp] [datetime] NULL,
	[computername] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[username] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[userdomain] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[LastWriteTime] [datetime2](7) NULL,
	[LnkLastOpenedDateTime] [datetime2](7) NULL,
	[LnkCreatedDateTime] [datetime] NULL,
	[FileCreatedDateTime] [datetime] NULL,
	[FileModifiedDateTime] [datetime] NULL,
	[pathRecentfileandfolder] [varchar](2000) COLLATE Latin1_General_CI_AS NULL,
	[attributes] [varchar](255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceRecentFileAndFolderLogging_datetimestamp]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceRecentFileAndFolderLogging] ADD  CONSTRAINT [DF_DeviceRecentFileAndFolderLogging_datetimestamp]  DEFAULT (getdate()) FOR [datetimestamp]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceRecentFileAndFolderLogging_Archive]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceRecentFileAndFolderLogging_Archive](
	[datetimestamp] [datetime] NULL,
	[computername] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[username] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[userdomain] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[LastWriteTime] [datetime2](7) NULL,
	[LnkLastOpenedDateTime] [datetime2](7) NULL,
	[LnkCreatedDateTime] [datetime] NULL,
	[FileCreatedDateTime] [datetime] NULL,
	[FileModifiedDateTime] [datetime] NULL,
	[pathRecentfileandfolder] [varchar](2000) COLLATE Latin1_General_CI_AS NULL,
	[attributes] [varchar](255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceTypes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceTypes](
	[DeviceTypeID] [int] IDENTITY(1,1) NOT NULL,
	[DeviceTypeDescription] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DeviceType_OU] [varchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[DeviceTypeEnabled] [bit] NULL,
 CONSTRAINT [PK_DeviceTypes] PRIMARY KEY CLUSTERED 
(
	[DeviceTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceTypes_DeviceTypeEnabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceTypes] ADD  CONSTRAINT [DF_DeviceTypes_DeviceTypeEnabled]  DEFAULT ((1)) FOR [DeviceTypeEnabled]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceScripts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceScripts](
	[Script_GUID] [uniqueidentifier] NOT NULL,
	[Script_Description_short] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Script_Description_long] [nvarchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[Script_Code] [nvarchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Script_WorksOnComputerTypes] [varchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[Script_WhenCreated] [datetime] NULL,
	[Script_UserCreated] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[ScriptOutputType] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[ScriptEnabled] [bit] NULL,
 CONSTRAINT [PK_DeviceScripts] PRIMARY KEY CLUSTERED 
(
	[Script_GUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceScripts_ScriptEnabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceScripts] ADD  CONSTRAINT [DF_DeviceScripts_ScriptEnabled]  DEFAULT ((1)) FOR [ScriptEnabled]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceScriptSchedules]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceScriptSchedules](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[Script_GUID] [uniqueidentifier] NOT NULL,
	[ScheduleName] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[ScheduleType] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[CronExpression] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[IntervalMinutes] [int] NULL,
	[SpecificRunTime] [datetime] NULL,
	[ValidFrom] [datetime] NULL,
	[ValidUntil] [datetime] NULL,
	[NextRunTime] [datetime] NULL,
	[LastRunTime] [datetime] NULL,
	[ExecuteOnTheseDeviceOUs] [varchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[ExecuteOnTheseDevices] [varchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[ExecuteNotOnTheseDevices] [varchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[ScheduleEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_DeviceScriptSchedules] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DeviceScriptSchedules]') AND name = N'IX_DeviceScriptSchedules_NextRunTime')
CREATE NONCLUSTERED INDEX [IX_DeviceScriptSchedules_NextRunTime] ON [dbo].[DeviceScriptSchedules]
(
	[NextRunTime] ASC,
	[ScheduleEnabled] ASC
)
INCLUDE([Script_GUID],[ScheduleType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DeviceScriptSchedules_ScheduleEnabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeviceScriptSchedules] ADD  CONSTRAINT [DF_DeviceScriptSchedules_ScheduleEnabled]  DEFAULT ((1)) FOR [ScheduleEnabled]
END


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DeviceScriptSchedules_DeviceScripts]') AND parent_object_id = OBJECT_ID(N'[dbo].[DeviceScriptSchedules]'))
ALTER TABLE [dbo].[DeviceScriptSchedules]  WITH CHECK ADD  CONSTRAINT [FK_DeviceScriptSchedules_DeviceScripts] FOREIGN KEY([Script_GUID])
REFERENCES [dbo].[DeviceScripts] ([Script_GUID])
ON DELETE CASCADE

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DeviceScriptSchedules_DeviceScripts]') AND parent_object_id = OBJECT_ID(N'[dbo].[DeviceScriptSchedules]'))
ALTER TABLE [dbo].[DeviceScriptSchedules] CHECK CONSTRAINT [FK_DeviceScriptSchedules_DeviceScripts]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SystemLookups]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SystemLookups](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[Code] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[Description_Short] [varchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
	[Description_Long] [varchar](500) COLLATE Latin1_General_CI_AS NULL,
	[IsEnabled] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__SystemLoo__IsEna__533C4B0B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SystemLookups] ADD  DEFAULT ((1)) FOR [IsEnabled]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uam_log_minimal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[uam_log_minimal](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[userdomain] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[data_collection_type] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[data] [varchar](1500) COLLATE Latin1_General_CI_AS NOT NULL,
	[first_logged_datetime] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__uam_log___5E5499A8AFA101A3] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uam_log_minimal_dates]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[uam_log_minimal_dates](
	[LogID] [int] NOT NULL,
	[UsedOnDate] [date] NOT NULL,
 CONSTRAINT [PK_uam_log_minimal_dates] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC,
	[UsedOnDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_uam_log_minimal_dates]') AND parent_object_id = OBJECT_ID(N'[dbo].[uam_log_minimal_dates]'))
ALTER TABLE [dbo].[uam_log_minimal_dates]  WITH CHECK ADD  CONSTRAINT [FK_uam_log_minimal_dates] FOREIGN KEY([LogID])
REFERENCES [dbo].[uam_log_minimal] ([LogID])
ON DELETE CASCADE

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_uam_log_minimal_dates]') AND parent_object_id = OBJECT_ID(N'[dbo].[uam_log_minimal_dates]'))
ALTER TABLE [dbo].[uam_log_minimal_dates] CHECK CONSTRAINT [FK_uam_log_minimal_dates]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AdUsers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AdUsers](
	[SID] [nvarchar](max) COLLATE Latin1_General_CI_AS NULL,
	[SIDHistory] [nvarchar](max) COLLATE Latin1_General_CI_AS NULL,
	[LastKnownParent] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ObjectCategory] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[instanceType] [int] NULL,
	[ObjectClass] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[employeeType] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ObjectGUID] [uniqueidentifier] NULL,
	[objectSid] [nvarchar](max) COLLATE Latin1_General_CI_AS NULL,
	[servicePrincipalName] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[ServicePrincipalNames] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[UserPrincipalName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[DistinguishedName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[CN] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[CanonicalName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ou] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[PrimaryGroup] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[primaryGroupID] [int] NULL,
	[SamAccountName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Name] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[sAMAccountType] [int] NULL,
	[EmployeeID] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[EmployeeNumber] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[EmailAddress] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[mail] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[mailNickname] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Enabled] [bit] NULL,
	[Manager] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[AccountExpirationDate] [datetime2](7) NULL,
	[AccountLockoutTime] [datetime2](7) NULL,
	[AccountNotDelegated] [bit] NULL,
	[showInAddressBook] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[DisplayName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[displayNamePrintable] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[GivenName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Initials] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[State] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[StreetAddress] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[physicalDeliveryOfficeName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Office] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[roomNumber] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[PostalCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[City] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Country] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[countryCode] [int] NULL,
	[st] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[postOfficeBox] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[POBox] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[co] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Company] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Department] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Title] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[homeMDB] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[HomedirRequired] [bit] NULL,
	[HomeDrive] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[HomeDirectory] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ScriptPath] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ProfilePath] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[proxyAddresses] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[telephoneNumber] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[MobilePhone] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ipPhone] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[HomePhone] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[OfficePhone] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[otherTelephone] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[facsimileTelephoneNumber] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Fax] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[wWWHomePage] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[HomePage] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Description] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[info] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchWhenMailboxCreated] [datetime2](7) NULL,
	[msTSExpireDate] [datetime2](7) NULL,
	[whenCreated] [datetime2](7) NULL,
	[whenChanged] [datetime2](7) NULL,
	[lastLogoff] [datetime2](7) NULL,
	[lastLogon] [datetime2](7) NULL,
	[LockedOut] [bit] NULL,
	[lockoutTime] [bigint] NULL,
	[PasswordExpired] [bit] NULL,
	[PasswordLastSet] [datetime2](7) NULL,
	[PasswordNeverExpires] [bit] NULL,
	[PasswordNotRequired] [bit] NULL,
	[badPwdCount] [int] NULL,
	[BadLogonCount] [int] NULL,
	[CannotChangePassword] [bit] NULL,
	[AllowReversiblePasswordEncryption] [bit] NULL,
	[pwdLastSet] [datetime2](7) NULL,
	[extensionAttribute1] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute2] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute3] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute4] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute5] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute6] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute7] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute8] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute9] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute10] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute11] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute12] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute13] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute14] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensionAttribute15] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[kostenplaats] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[mAPIRecipient] [bit] NULL,
	[mDBOverQuotaLimit] [int] NULL,
	[mDBStorageQuota] [int] NULL,
	[mDBUseDefaults] [bit] NULL,
	[MNSLogonAccount] [bit] NULL,
	[msDS-KeyCredentialLink] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msDS-LastKnownRDN] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msDS-SupportedEncryptionTypes] [int] NULL,
	[msDS-User-Account-Control-Computed] [int] NULL,
	[msExchAddressBookFlags] [int] NULL,
	[msExchAddressBookPolicyLink] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchArchiveQuota] [bigint] NULL,
	[msExchArchiveWarnQuota] [bigint] NULL,
	[msExchBlockedSendersHash] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchBypassAudit] [bit] NULL,
	[msExchCalendarLoggingQuota] [int] NULL,
	[msExchDelegateListBL] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchDelegateListLink] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchDumpsterQuota] [int] NULL,
	[msExchDumpsterWarningQuota] [int] NULL,
	[msExchELCMailboxFlags] [int] NULL,
	[msExchGroupSecurityFlags] [int] NULL,
	[msExchHideFromAddressLists] [bit] NULL,
	[msExchHomeServerName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchMailboxAuditEnable] [bit] NULL,
	[msExchMailboxAuditLastAdminAccess] [datetime2](7) NULL,
	[msExchMailboxAuditLastDelegateAccess] [datetime2](7) NULL,
	[msExchMailboxAuditLogAgeLimit] [int] NULL,
	[msExchMailboxFolderSet] [int] NULL,
	[msExchMailboxTemplateLink] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchMDBRulesQuota] [int] NULL,
	[msExchMobileMailboxFlags] [int] NULL,
	[msExchModerationFlags] [int] NULL,
	[msExchPoliciesExcluded] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchPoliciesIncluded] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchPreviousRecipientTypeDetails] [bigint] NULL,
	[msExchProvisioningFlags] [int] NULL,
	[msExchRBACPolicyLink] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchRecipientDisplayType] [int] NULL,
	[msExchRecipientSoftDeletedStatus] [int] NULL,
	[msExchRecipientTypeDetails] [bigint] NULL,
	[msExchSafeRecipientsHash] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowCountryCode] [int] NULL,
	[msExchShadowDisplayName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowGivenName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowInfo] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowMailNickname] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowProxyAddresses] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowSn] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchTextMessagingState] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchThrottlingPolicyDN] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchTransportRecipientSettingsFlags] [int] NULL,
	[msExchUMDtmfMap] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchUMEnabledFlags2] [int] NULL,
	[msExchUserAccountControl] [int] NULL,
	[msExchUserBL] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchUserCulture] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchVersion] [bigint] NULL,
	[mSMQDigests] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[mSMQSignCertificates] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msTSLicenseVersion] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msTSLicenseVersion2] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msTSLicenseVersion3] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msTSManagingLS] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[publicDelegatesBL] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[sDRightsEffective] [int] NULL,
	[msExchCoManagedObjectsBL] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[authOrigBL] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[managedObjects] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[altRecipientBL] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchPreviousHomeMDB] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[mDBOverHardQuotaLimit] [int] NULL,
	[msExchSenderHintTranslations] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchSharingPolicyLink] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchAuditOwner] [int] NULL,
	[msExchOmaAdminWirelessEnable] [int] NULL,
	[deletedItemFlags] [int] NULL,
	[msExchSharingPartnerIdentities] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[altRecipient] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[deliverAndRedirect] [bit] NULL,
	[msExchGenericForwardingAddress] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowTitle] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchAuditAdmin] [int] NULL,
	[msExchAuditDelegateAdmin] [int] NULL,
	[msExchMailboxMoveTargetUserBL] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowDepartment] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowMobile] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowPostalCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowStreetAddress] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowTelephoneNumber] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchResourceDisplay] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchResourceMetaData] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchResourceSearchProperties] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msExchShadowPhysicalDeliveryOfficeName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchAuditDelegate] [int] NULL,
	[msRTCSIP-PrimaryUserAddress] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msRTCSIP-UserEnabled] [bit] NULL,
	[msExchResourceCapacity] [int] NULL,
	[msExchArchiveDatabaseLink] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchArchiveName] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[msDS-ExternalDirectoryObjectId] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchLitigationHoldDate] [datetime2](7) NULL,
	[msExchLitigationHoldOwner] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[msExchUserHoldPolicies] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[legacyExchangeDN] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[SmartcardLogonRequired] [bit] NULL,
	[UseDESKeyOnly] [bit] NULL,
	[userAccountControl] [int] NULL,
	[userCertificate] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[TrustedForDelegation] [bit] NULL,
	[TrustedToAuthForDelegation] [bit] NULL,
	[KerberosEncryptionType] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[PrincipalsAllowedToDelegateToAccount] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ProtectedFromAccidentalDeletion] [bit] NULL,
	[DoesNotRequirePreAuth] [bit] NULL,
	[targetAddress] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[desktopProfile] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[garbageCollPeriod] [int] NULL,
	[codePage] [int] NULL,
	[CompoundIdentitySupported] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[directReports] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[internetEncoding] [int] NULL,
	[protocolSettings] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[publicDelegates] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[authOrig] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[submissionContLength] [int] NULL,
	[_rowno] [int] IDENTITY(1,1) NOT NULL,
	[_firstdiscovered] [datetime] NULL,
	[_lastdiscovered] [datetime] NULL,
	[_remarks] [sysname] COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__AdUsers_n___last__06FD7CE1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AdUsers] ADD  DEFAULT (getdate()) FOR [_lastdiscovered]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GG_YF_Employments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GG_YF_Employments](
	[id] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[personCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[personId] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[contractCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[contractId] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[contractType] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[contractTypeName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[emailAddresses] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[employmentCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[employmentType] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[employmentTypeName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[workingAmount] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[company] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[organizationUnit] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[organizationUnitCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[organizationUnitName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[jobProfile] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[jobProfileName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[phoneNumbers] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[isActive] [bit] NULL,
	[validFrom] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[validUntil] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[originalHireDate] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[hireDate] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[dischargeDate] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[terminationReason] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[terminationReasonName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[classification] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[classificationName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[latestSync] [datetime2](7) NULL,
	[payrollClientCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[payrollInstitutionCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[extensions] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[_rowno] [int] IDENTITY(1,1) NOT NULL,
	[_firstdiscovered] [datetime] NULL,
	[_lastdiscovered] [datetime] NULL,
	[_remarks] [sysname] COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__GG_YF_Emp___last__154B9C38]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[GG_YF_Employments] ADD  DEFAULT (getdate()) FOR [_lastdiscovered]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GG_YF_EmploymentsExtensions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GG_YF_EmploymentsExtensions](
	[id] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[personCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[employmentCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[bo4FieldCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[fieldNameAlias] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[value] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[description] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[latestSync] [datetime2](7) NULL,
	[_rowno] [int] IDENTITY(1,1) NOT NULL,
	[_firstdiscovered] [datetime] NULL,
	[_lastdiscovered] [datetime] NULL,
	[_remarks] [sysname] COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__GG_YF_Emp___last__182808E3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[GG_YF_EmploymentsExtensions] ADD  DEFAULT (getdate()) FOR [_lastdiscovered]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GG_YF_OrganizationUnits]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GG_YF_OrganizationUnits](
	[id] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[parentOrgUnit] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[fullName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[shortName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[validFrom] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[validUntil] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[isBlocked] [bit] NULL,
	[address] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[costCenterCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[latestSync] [datetime2](7) NULL,
	[_rowno] [int] IDENTITY(1,1) NOT NULL,
	[_firstdiscovered] [datetime] NULL,
	[_lastdiscovered] [datetime] NULL,
	[_remarks] [sysname] COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__GG_YF_Org___last__0F92C2E2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[GG_YF_OrganizationUnits] ADD  DEFAULT (getdate()) FOR [_lastdiscovered]
END


SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vwt_hr_contracts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[vwt_hr_contracts](
	[company] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[personeelsnr] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[personeelsnr_orig] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Volgnummer_contract] [bigint] NULL,
	[remarks] [varchar](31) COLLATE Latin1_General_CI_AS NOT NULL,
	[Status_Contract] [varchar](29) COLLATE Latin1_General_CI_AS NOT NULL,
	[DagenVoorBegindatum] [int] NULL,
	[DagenNaEinddatum] [int] NULL,
	[DagenTotMaxEinddatum] [int] NULL,
	[Last_Einddatum_contracts] [date] NULL,
	[Begindatum_contract] [date] NULL,
	[Einddatum_contract] [date] NULL,
	[MeerdereContractenTegelijk] [int] NOT NULL,
	[Naam] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[initialen] [nvarchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Roepnaam] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Tussenvoegsel] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Achternaam] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Tussenvoegsel_partner] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Achternaam_partner] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Organisatorische_eenheid_omschrijving] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[functie_omschrijving] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Organisatorische_eenheid_code] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Functie_code] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ict_Voorzieningen] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ad_DisplayName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[SamAccountName] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[entra_logon_hoursago] [int] NULL,
	[ad_logon_hoursago] [int] NULL,
	[ad_enabled] [bit] NULL,
	[ad_ou] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ad_email] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ad_mobile] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Manager] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ad_whencreated] [datetime2](7) NULL,
	[ad_import_data] [datetime] NULL,
	[contracts_import_data] [datetime] NULL,
	[contracts_first_imported] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WIJ_AFAS_Employments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WIJ_AFAS_Employments](
	[Persoonsnummer] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Volgnummer_contract] [bigint] NULL,
	[ExternalID] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Medewerker] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Persoonsnummer_leidinggevende] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Medewerkernummer_leidinggevende] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Persoonsnummer_VervangendLeidinggevende] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Medewerkernummer_VervangendLeidinggevende] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Naam] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Begindatum_contract] [datetime2](7) NULL,
	[Einddatum_contract] [datetime2](7) NULL,
	[Dienstbetrekking] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Dienstverband] [bigint] NULL,
	[Type_contract] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Begindatum_functie] [datetime2](7) NULL,
	[Einddatum_functie] [datetime2](7) NULL,
	[Functie_code] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Functie_omschrijving] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Organisatorische_eenheid_code] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Organisatorische_eenheid_omschrijving] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[FTE] [float] NULL,
	[Uren_per_week] [float] NULL,
	[Parttime_percentage] [float] NULL,
	[Kostenplaats_code] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Kostenplaats_omschrijving] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Soort_medewerker] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Soort_medewerker_code] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Werkgever_code] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Werkgever_omschrijving] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ICT-voorziening] [bit] NULL,
	[_rowno] [int] IDENTITY(1,1) NOT NULL,
	[_firstdiscovered] [datetime] NULL,
	[_lastdiscovered] [datetime] NULL,
	[_remarks] [sysname] COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__WIJ_AFAS____last__20BD4EE4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[WIJ_AFAS_Employments] ADD  DEFAULT (getdate()) FOR [_lastdiscovered]
END

