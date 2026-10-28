CREATE VIEW dbo.vw_FleetDailyKPI
AS
SELECT
    d.CalendarDate,
    b.BusLineCode,
    b.BusLineName,
    COUNT_BIG(*) AS TelemetryEvents,
    COUNT(DISTINCT f.TripId) AS DistinctTrips,
    SUM(CAST(f.DelayMinutes AS BIGINT)) AS TotalDelayMinutes,
    CAST(
        AVG(CAST(f.DelayMinutes AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS AverageDelayMinutes,
    SUM(
        CASE WHEN f.BusState = 'Arrived'
             THEN 1 ELSE 0 END
    ) AS ArrivedEvents,
    SUM(
        CASE WHEN f.BusState = 'InMotion'
             THEN 1 ELSE 0 END
    ) AS InMotionEvents
FROM dbo.FactFleetTelemetry AS f
INNER JOIN dbo.DimDate AS d
    ON f.DateKey = d.DateKey
INNER JOIN dbo.DimBusLine AS b
    ON f.BusLineKey = b.BusLineKey
GROUP BY
    d.CalendarDate,
    b.BusLineCode,
    b.BusLineName;

GO