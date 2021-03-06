
ALTER PROCEDURE [File].[FileTableInsertFolder](@filePath nvarchar(MAX))
--Exec [File].[FileTableInsertFolder] '\1\22\333\4444\55555'
AS
BEGIN
	SET NOCOUNT ON;		
	Begin Tran InsertTran
		Declare @SubFolders TABLE(Id  int,FolderName NVARCHAR(MAX),StartIndex int)	
		Insert Into @SubFolders select ROW_NUMBER() Over(Order by splitindex) as Id,* from [Utility].[Split](@filePath,'\')
		Declare @count int
		Declare @current int
		Declare @subFolder nvarchar(Max)
		Declare @parentFolder nvarchar(Max)
		Set @current = 1
		Select @count = Count(Id) from @SubFolders
		Set @parentFolder = ''
		While(@current < @count)
			BEGIN
				Select @subFolder = FolderName From @SubFolders Where Id = @current + 1
				Select @parentFolder = @parentFolder + FolderName From @SubFolders Where Id = @current
				DECLARE  @ParentFolderId  hierarchyid = GETPATHLOCATOR(FILETABLEROOTPATH('[File].[FileTable]') + @parentFolder +'\'+ @subFolder )
				If(@ParentFolderId Is NULL)
					Exec [File].[FileTableInsert] NULL,@subFolder, NULL , @parentFolder, NULL
				Set @current = @current + 1
				Set @parentFolder = @parentFolder + '\' 
			END
	Commit  Tran InsertTran
END