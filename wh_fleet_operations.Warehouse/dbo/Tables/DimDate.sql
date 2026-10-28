CREATE TABLE [dbo].[DimDate] (
    [DateKey]       INT          NOT NULL,
    [CalendarDate]  DATE         NOT NULL,
    [CalendarYear]  SMALLINT     NOT NULL,
    [CalendarMonth] SMALLINT     NOT NULL,
    [MonthName]     VARCHAR (20) NOT NULL,
    [DayOfWeekName] VARCHAR (20) NOT NULL,
    [IsWeekend]     BIT          NOT NULL
);


GO