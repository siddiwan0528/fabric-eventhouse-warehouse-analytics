CREATE TABLE [dbo].[FactFleetTelemetry] (
    [TelemetryKey]             BIGINT        NOT NULL,
    [EventTimestamp]           DATETIME2 (6) NOT NULL,
    [DateKey]                  INT           NOT NULL,
    [BusLineKey]               INT           NOT NULL,
    [StationKey]               INT           NOT NULL,
    [TripId]                   VARCHAR (30)  NOT NULL,
    [ScheduleTime]             DATETIME2 (6) NULL,
    [BusState]                 VARCHAR (30)  NULL,
    [TimeToNextStationSeconds] INT           NULL,
    [DelayMinutes]             INT           NULL,
    [EventCount]               INT           NOT NULL
);


GO