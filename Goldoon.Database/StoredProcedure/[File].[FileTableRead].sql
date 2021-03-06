ALTER PROCEDURE [File].[FileTableRead] @streamId uniqueidentifier
AS
 BEGIN
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	  SET NOCOUNT ON;
	  Declare @fileStream as Varbinary(MAX)
      select @fileStream = file_stream  from [File].[FileTable] where stream_id = @streamId;
	  select @fileStream
 END