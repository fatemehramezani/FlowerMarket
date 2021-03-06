USE [ELearning1]
GO
/****** Object:  UserDefinedFunction [Utility].[Split]    Script Date: 19/08/1394 04:31:24 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [Utility].[Split](@string NVARCHAR(MAX), @delimiter CHAR(1)) 
RETURNS @output TABLE(splitdata NVARCHAR(MAX),splitindex int) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 
		BEGIN 
			IF @end = 0  
				SET @end = LEN(@string) + 1
       
			INSERT INTO @output (splitdata,splitindex)  
			VALUES(SUBSTRING(@string, @start, @end - @start),@start) 
			SET @start = @end + 1 
			SET @end = CHARINDEX(@delimiter, @string, @start)
		END 
    RETURN 
END
