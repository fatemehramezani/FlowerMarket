ALTER PROCEDURE [File].[FileTableInsert](@systemObjectId int,@fileName nvarchar(255),@fileTypeId tinyint = NULL ,@filePath nvarchar(1024) = NULL,@fileStream varbinary(max) = NULL)
AS
DECLARE @streamId uniqueidentifier;
	BEGIN
		Begin Tran InsertTran
			DECLARE @ParentId hierarchyid = GETPATHLOCATOR(FILETABLEROOTPATH('[File].[FileTable]') + @filePath)
			IF @ParentId IS NULL
				Begin
					Exec  [File].[FileTableInsertFolder] @filePath
					Set @ParentId = GETPATHLOCATOR(FILETABLEROOTPATH('[File].[FileTable]') + @filePath)
				End

			SET @streamId = NEWID();

			DECLARE @RandomId binary(16) = CONVERT(binary(16), NEWID())
			DECLARE @NewId hierarchyid = CONVERT(hierarchyid, CONCAT(@ParentId.ToString(),CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(@RandomId, 1, 6))), '.',CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(@RandomId, 7, 6))), '.',CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(@RandomId, 13, 4))), '/'))
			if(@fileStream Is Not NULL)
				Set @fileName = CONCAT('_' , Cast(DATEPART(MILLISECOND,GETDATE()) + DATEPART(MICROSECOND,GETDATE()) as nvarchar),'_',@fileName)
			INSERT INTO [File].[FileTable](stream_id, file_stream, name,path_locator,is_directory) VALUES (@streamId ,@fileStream,@fileName,@NewId,IIF(@fileStream IS NULL, 1, 0));
			if(@systemObjectId IS NOT NULL)
				Insert Into [SystemObject].[File](FileId,SystemObjectId,FileTypeId) Values(@streamId,@systemObjectId,@fileTypeId)
		Commit  Tran InsertTran
	END