CREATE TABLE [dbo].[FactFleetTelemetryGold] (
    [TelemetryKey]             BIGINT        NULL,
    [EventTimestamp]           DATETIME2 (6) NULL,
    [DateKey]                  INT           NOT NULL,
    [BusLineKey]               INT           NOT NULL,
    [StationKey]               INT           NOT NULL,
    [TripId]                   VARCHAR (50)  NULL,
    [ScheduleTime]             DATETIME2 (6) NULL,
    [BusState]                 VARCHAR (30)  NULL,
    [TimeToNextStationSeconds] INT           NULL,
    [DelayMinutes]             INT           NULL,
    [EventCount]               INT           NULL,
    [SourceCopies]             BIGINT        NULL,
    [DuplicateExcessRows]      BIGINT        NULL
);


GO