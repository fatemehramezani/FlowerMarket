ALTER PROCEDURE [File].[FileTableDelete] (@streamId uniqueidentifier)
   AS
 BEGIN
      SET NOCOUNT ON;
      DELETE from [SystemObject].[File] where FileId = @streamId;    
	  DELETE from [File].[FileTable] where stream_id = @streamId;    
 END