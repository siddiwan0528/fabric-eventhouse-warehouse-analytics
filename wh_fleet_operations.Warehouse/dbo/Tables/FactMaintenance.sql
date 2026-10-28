CREATE TABLE [dbo].[FactMaintenance] (
    [MaintenanceKey]    BIGINT          NOT NULL,
    [DateKey]           INT             NOT NULL,
    [BusLineKey]        INT             NOT NULL,
    [MaintenanceType]   VARCHAR (50)    NOT NULL,
    [DowntimeMinutes]   INT             NOT NULL,
    [MaintenanceCost]   DECIMAL (12, 2) NOT NULL,
    [MaintenanceStatus] VARCHAR (20)    NOT NULL
);


GO