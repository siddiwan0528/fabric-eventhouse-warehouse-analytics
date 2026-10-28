CREATE VIEW dbo.vw_MaintenanceKPI
AS
SELECT
    d.CalendarDate,
    b.BusLineCode,
    b.BusLineName,
    f.MaintenanceType,
    f.MaintenanceStatus,
    COUNT_BIG(*) AS MaintenanceRecords,
    SUM(CAST(f.DowntimeMinutes AS BIGINT))
        AS TotalDowntimeMinutes,
    CAST(SUM(f.MaintenanceCost) AS DECIMAL(14,2))
        AS TotalMaintenanceCost
FROM dbo.FactMaintenance AS f
INNER JOIN dbo.DimDate AS d
    ON f.DateKey = d.DateKey
INNER JOIN dbo.DimBusLine AS b
    ON f.BusLineKey = b.BusLineKey
GROUP BY
    d.CalendarDate,
    b.BusLineCode,
    b.BusLineName,
    f.MaintenanceType,
    f.MaintenanceStatus;

GO