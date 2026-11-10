CREATE VIEW dbo.vw_FleetDailyKPI_Gold
AS
SELECT
    d.CalendarDate,
    b.BusLineCode,
    b.BusLineName,

    COUNT_BIG(*) AS UniquePayloadRows,

    SUM(CAST(g.SourceCopies AS BIGINT))
        AS SourceRowsReceived,

    SUM(CAST(g.DuplicateExcessRows AS BIGINT))
        AS DuplicateExcessRows,

    COUNT(DISTINCT g.TripId)
        AS DistinctTripIds,

    SUM(CASE
        WHEN g.BusState = 'Arrived' THEN 1
        ELSE 0
    END) AS ArrivedPayloadRows,

    SUM(CASE
        WHEN g.BusState = 'InMotion' THEN 1
        ELSE 0
    END) AS InMotionPayloadRows,

    SUM(CASE
        WHEN g.BusState = 'NotInStation' THEN 1
        ELSE 0
    END) AS NotInStationPayloadRows,

    CAST(
        AVG(CAST(g.TimeToNextStationSeconds AS DECIMAL(18,2)))
        AS DECIMAL(18,2)
    ) AS AverageETASeconds

FROM dbo.FactFleetTelemetryGold AS g

INNER JOIN dbo.DimDate AS d
    ON g.DateKey = d.DateKey

INNER JOIN dbo.DimBusLine AS b
    ON g.BusLineKey = b.BusLineKey

GROUP BY
    d.CalendarDate,
    b.BusLineCode,
    b.BusLineName;

GO