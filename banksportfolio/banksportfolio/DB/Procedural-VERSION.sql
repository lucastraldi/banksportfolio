USE master
IF EXISTS(SELECT * FROM sys.databases WHERE name = 'BanksPortfolio')
DROP DATABASE BanksPortfolio

CREATE DATABASE BanksPortfolio
GO
USE BanksPortfolio

CREATE TABLE Trades (
	Id INT PRIMARY KEY IDENTITY (1, 1),
	Value DECIMAL(10,2) NOT NULL,
	ClientSector VARCHAR(100) NOT NULL,
	Risk VARCHAR(100) DEFAULT('')
)
GO

CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY (1, 1),
	Name VARCHAR(100) NOT NULL
)
GO

CREATE TABLE CategoryFilter (
	Id INT PRIMARY KEY IDENTITY (1, 1),
	Field VARCHAR(100) NOT NULL,
	Condition VARCHAR(100) NOT NULL,
	Value VARCHAR(100) NOT NULL,
	CategoryID int,
	CONSTRAINT FK_Category FOREIGN KEY (CategoryID)
    REFERENCES Categories(Id)
)
GO

--------------------

INSERT INTO Trades Values
(400000, 'Public', ''),
(2000000, 'Private', ''),
(500000, 'Public', ''),
(2000000, 'Private', '')

INSERT INTO Categories VALUES ('LOWRISK')
INSERT INTO CategoryFilter VALUES
('Value', '<', '1000000', SCOPE_IDENTITY()),
('ClientSector', 'like', '''Public''', SCOPE_IDENTITY())

INSERT INTO Categories VALUES ('MEDIUMRISK')
INSERT INTO CategoryFilter VALUES
('Value', '>', '1000000', SCOPE_IDENTITY()),
('ClientSector', 'like', '''Public''', SCOPE_IDENTITY())

INSERT INTO Categories VALUES ('HIGHRISK')
INSERT INTO CategoryFilter VALUES
('Value', '>', '1000000', SCOPE_IDENTITY()),
('ClientSector', 'like', '''Private''', SCOPE_IDENTITY())
GO
-----------------

CREATE PROCEDURE spRisk
AS
BEGIN

	DECLARE @risk VARCHAR(100)
	

	DECLARE @TradeId int
	DECLARE TRADE_CURSOR CURSOR 
	  LOCAL STATIC READ_ONLY FORWARD_ONLY
	FOR 
	SELECT DISTINCT Id 
	FROM Trades

	OPEN TRADE_CURSOR
	FETCH NEXT FROM TRADE_CURSOR INTO @TradeId
	WHILE @@FETCH_STATUS = 0
	BEGIN 

		SET @risk =  'It does not match any implemented risk'

		UPDATE Trades
		SET Risk = @risk
		WHERE Id = @TradeId

		DECLARE @value DECIMAL(10,2)
		DECLARE @clientsector VARCHAR(100)

		SELECT @value = Value, @clientsector = ClientSector
		FROM Trades
		WHERE Id = @tradeID

		DECLARE @CategoryId int
		DECLARE CATEGORY_CURSOR CURSOR 
		  LOCAL STATIC READ_ONLY FORWARD_ONLY
		FOR 
		SELECT DISTINCT Id 
		FROM Categories

		OPEN CATEGORY_CURSOR
		FETCH NEXT FROM CATEGORY_CURSOR INTO @CategoryId
		WHILE @@FETCH_STATUS = 0
		BEGIN 

			DECLARE @Query NVARCHAR(MAX)

			SET @Query =
			N'SELECT COUNT(*)
			FROM Trades 
			WHERE Id = ' + CAST(@tradeID AS VARCHAR(10)) + ' '

			DECLARE @FilterId INT
			DECLARE @Index INT = 0

			DECLARE FILTER_CURSOR CURSOR 
			LOCAL STATIC READ_ONLY FORWARD_ONLY
			FOR 
			SELECT DISTINCT Id 
			FROM CategoryFilter
			WHERE CategoryID = @CategoryId

			OPEN FILTER_CURSOR
			FETCH NEXT FROM FILTER_CURSOR INTO @FilterId
			WHILE @@FETCH_STATUS = 0
			BEGIN 
		

				DECLARE @F_Field VARCHAR(100)
				DECLARE @F_Condition VARCHAR(100)
				DECLARE @F_Value VARCHAR(100)

				SELECT @F_Field = Field, @F_Condition = Condition, @F_Value = Value
				FROM CategoryFilter
				WHERE Id = @FilterId

				SET @Query += ' and ' + @F_Field + ' ' + @F_Condition + ' ' + @F_Value

				FETCH NEXT FROM FILTER_CURSOR INTO @FilterId
			END
			CLOSE FILTER_CURSOR
			DEALLOCATE FILTER_CURSOR

			DECLARE @RowCount TABLE (Value int);
			INSERT INTO @RowCount
			EXEC(@Query);

			DECLARE @Count INT
			SELECT @Count = Value FROM @RowCount;

			PRINT @Count

			IF @Count > 0
			BEGIN
				SELECT @risk = Name from Categories WHERE Id = @CategoryId
				BREAK
			END

			

			FETCH NEXT FROM CATEGORY_CURSOR INTO @CategoryId
		END
		CLOSE CATEGORY_CURSOR
		DEALLOCATE CATEGORY_CURSOR

		UPDATE Trades
		SET Risk = @risk
		WHERE Id = @TradeId

	FETCH NEXT FROM TRADE_CURSOR INTO @TradeId
	END
	CLOSE TRADE_CURSOR

END
GO

EXEC spRisk
SELECT * FROM Trades