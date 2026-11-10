# Data quality and analytical limitations

## 1. Context

The sample telemetry source does not expose a verified unique event identifier in the payload schema. The available fields are timestamp, trip ID, bus line, station number, schedule time and a JSON properties field.

As a result, the project cannot reliably distinguish:
- A repeated delivery of the same source record
- Two legitimate events that happen to have identical values in every available field

The Silver transformation therefore uses a clearly stated exact-payload grouping policy.

## 2. Exact full-payload grouping

The grouping key contains all eight projected payload attributes:

1. `EventTimestamp`
2. `TripId`
3. `BusLine`
4. `StationNumber`
5. `ScheduleTime`
6. `BusState`
7. `TimeToNextStation`
8. `PropertiesJson`

For each distinct complete payload, Silver retains:
- `SourceCopies`: number of staging rows in the group
- `DuplicateExcessRows`: copies minus one

This is exact row/payload grouping. It is **not hash-based deduplication** and it is not proof of unique real-world events.

## 3. Observed staging snapshot

| Measure | Rows |
|---|---:|
| Bronze staging rows | 5,996,018 |
| Distinct complete payload groups | 1,799,554 |
| Excess rows within exact-payload groups | 4,196,464 |
| Maximum copies observed in a group | 4 |

Reconciliation:

`5,996,018 = 1,799,554 + 4,196,464`

The excess-row ratio is:

`4,196,464 / 5,996,018 = approximately 69.99%`

This percentage describes the share of rows removed from the Silver row set by the grouping rule for this snapshot. It must not be described as a 69.99% storage-cost saving: physical storage, compression, retention and capacity consumption were not measured.

## 4. Why Bronze is retained

Bronze remains the audit/reprocessing layer. The project does not delete or overwrite the original staging records as part of the Silver grouping policy.

Keeping the original staging snapshot supports:
- Re-running transformations with a revised business rule
- Investigating repeated payloads
- Comparing source and curated row counts
- Preserving traceability through `SourceCopies` and `DuplicateExcessRows`

## 5. Event identity improvement

For a production design, request a source-generated immutable event ID (or a reliable event sequence/partition-offset identity) from the producer. Then define deduplication using that identifier and an explicit replay/late-arrival policy.

A composite business key can be considered only after the business confirms that its fields uniquely identify an event. Timestamp + trip + bus line + station alone should not be assumed unique without that validation.

## 6. ETA averaging caveat

The SQL KPI view calculates `AverageETASeconds` using SQL `AVG`, which ignores NULL ETA values.

The semantic model currently contains a weighted ETA measure that multiplies each date/bus-line average by `UniquePayloadRows`. This is statistically correct only if every payload row in each group has a non-NULL ETA.

If some ETA values are NULL, the correct weighted calculation requires the number of valid ETA observations per date/bus-line group:

`Weighted ETA = SUM(Average ETA × Valid ETA observations) / SUM(Valid ETA observations)`

Recommended follow-up:
1. Count total Gold fact rows.
2. Count non-NULL `TimeToNextStationSeconds` rows.
3. If the counts differ, add `ETAObservationCount` to the KPI view.
4. Weight each group average by `ETAObservationCount`, not by all unique payload rows.

Do not publish the weighted ETA as fully validated until this check passes.

## 7. KPI interpretation

- **Unique payload rows:** count of distinct complete payload groups in the Silver/Gold model; not a proven count of unique physical events.
- **Source rows received:** sum of source-copy counts represented by the curated payload groups.
- **Exact-payload excess rows:** additional staging copies beyond one retained row per complete payload group.
- **Bus lines covered:** distinct bus-line codes present in the selected data; not a count of currently active buses or lines.
- **Bus-state distribution:** distribution of recorded payload rows by state; not time spent in each state.
- **Distinct trip IDs:** distinct trip identifiers in the KPI grouping context; not necessarily concurrent active trips.
- **Average ETA:** average of recorded ETA observations, subject to the NULL-weighting caveat above.

## 8. Scope limitations

The validated snapshot covers four dates and 41 bus lines. It is suitable for demonstrating Fabric ingestion, warehousing, transformation and reporting patterns, but it is too short to support seasonal or long-term operational conclusions.
