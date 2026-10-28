CREATE TABLE [dbo].[StgFleetTelemetry] (
    [EventTimestamp]    DATETIME2 (6)  NULL,
    [TripId]            VARCHAR (50)   NULL,
    [BusLine]           INT            NULL,
    [StationNumber]     INT            NULL,
    [ScheduleTime]      DATETIME2 (6)  NULL,
    [BusState]          VARCHAR (30)   NULL,
    [TimeToNextStation] VARCHAR (50)   NULL,
    [PropertiesJson]    VARCHAR (2000) NULL
);


GO