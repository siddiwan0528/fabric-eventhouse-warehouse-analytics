# Validation results

This document records the results returned during the project build. Counts refer to the validated Warehouse staging snapshot and its corresponding Silver/Gold outputs, not to a continuously changing Eventhouse count.

## 1. Layer reconciliation

| Check | Expected / observed result | Status |
|---|---:|---|
| Bronze staging rows | 5,996,018 | Passed |
| Silver distinct complete payload groups | 1,799,554 | Passed |
| Silver source copies summed | 5,996,018 | Passed |
| Silver exact-payload excess rows summed | 4,196,464 | Passed |
| Maximum copies in a complete-payload group | 4 | Passed |
| Gold fact rows | 1,799,554 | Passed |
| Gold event-count field summed | 1,799,554 | Passed |
| Gold source copies summed | 5,996,018 | Passed |
| Gold excess rows summed | 4,196,464 | Passed |

Core reconciliation:

`Bronze rows = Silver payload groups + exact-payload excess rows`

`5,996,018 = 1,799,554 + 4,196,464`

The Gold fact table preserved the same copy and excess-row lineage.

## 2. Dimension coverage

The project populated the date, bus-line and station dimensions for the observed source values. The coverage validation returned zero missing dimension matches for the tested Silver rows.

The dimension coverage check is a referential-coverage check for the validated snapshot; it is not a guarantee that future source values will be covered automatically. New bus lines, stations and dates require dimension maintenance.

## 3. Silver data-quality validation

The Silver validation returned:

| Validation | Result |
|---|---:|
| Silver rows | 1,799,554 |
| Missing timestamp | 0 |
| Missing trip ID | 0 |
| Missing date dimension match | 0 |
| Missing bus-line dimension match | 0 |
| Missing station dimension match | 0 |
| Invalid duration values (as tested) | 0 |

These checks describe the tested transformation output and the validation rules used at the time.

## 4. KPI view reconciliation

View: `dbo.vw_FleetDailyKPI_Gold`

| Metric | Result |
|---|---:|
| KPI rows | 164 |
| Distinct dates | 4 |
| Distinct bus lines | 41 |
| Sum of unique payload rows | 1,799,554 |
| Sum of source rows received | 5,996,018 |
| Sum of exact-payload excess rows | 4,196,464 |

The KPI row count is consistent with the observed grain: four dates × 41 bus lines = 164 date/bus-line combinations.

## 5. Example KPI row

One returned row for 2026-10-31 and bus line code 1:

| Metric | Value |
|---|---:|
| Unique payload rows | 2,263 |
| Distinct trip IDs | 9 |
| Arrived payload rows | 62 |
| In-motion payload rows | 2,184 |
| Not-in-station payload rows | 17 |
| Average ETA seconds | 203.83 |

The three state counts sum to 2,263 for this example row. State counts are payload-row counts, not bus counts or time percentages.

## 6. Recommended final checks before extending the model

### ETA completeness

Run against the Gold fact table:

```sql
SELECT
    COUNT_BIG(*) AS TotalPayloadRows,
    COUNT_BIG(TimeToNextStationSeconds) AS RowsWithETA,
    COUNT_BIG(*) - COUNT_BIG(TimeToNextStationSeconds) AS RowsWithoutETA
FROM dbo.FactFleetTelemetryGold;
```

If `RowsWithoutETA` is greater than zero, add a valid ETA observation count to the KPI view and use that count to weight average ETA values in DAX.

### Future refreshes

The counts above are a recorded snapshot. If the Eventstream and pipeline continue ingesting data, rerun the reconciliation queries at a consistent cutoff/snapshot point before comparing Eventhouse, Bronze, Silver, Gold and Power BI totals.

## 7. Validation boundary

The checks demonstrate internal count reconciliation and dimension coverage for the tested snapshot. They do not independently prove:
- That identical payloads are duplicate real-world events
- That every source event was delivered exactly once
- That the four-day sample represents long-term fleet operations
- That physical storage or compute costs were reduced by the row-count ratio
