CREATE TABLE [dbo].[DimBusLine] (
    [BusLineKey]  INT          NOT NULL,
    [BusLineCode] INT          NOT NULL,
    [BusLineName] VARCHAR (50) NOT NULL,
    [DepotName]   VARCHAR (50) NOT NULL,
    [IsActive]    BIT          NOT NULL
);


GO