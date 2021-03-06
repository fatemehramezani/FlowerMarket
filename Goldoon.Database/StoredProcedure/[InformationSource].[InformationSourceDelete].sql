
Create PROCEDURE [InformationSource].[InformationSourceDelete](@Ids nvarchar(MAX))
   AS
 BEGIN
    SET NOCOUNT ON;		
	if(@Ids Is NULL)
		Return
	Declare @IdList TABLE(Id NVARCHAR(MAX))	
	Declare @streamId as UniqueIdentifier						 	
	Declare @InformationSourceId as NVARCHAR(MAX)
	Declare @SystemObjectId as int

	Insert Into @IdList select splitData from [Utility].[Split](@Ids,',')

	Begin Tran DeleteTran	
		DECLARE Id_cursor CURSOR FOR 	
	        Select Id from @IdList
			OPEN Id_cursor	FETCH NEXT FROM Id_cursor INTO @InformationSourceId
				WHILE @@FETCH_STATUS = 0
					BEGIN		
						Set @SystemObjectId = NULL
						select @SystemObjectId = [SystemObjectId] FROM [Basic].[InformationSource] Where Id = @InformationSourceId
						DELETE FROM [Basic].[InformationSource] Where Id = @InformationSourceId
						
						Set @streamId = NULL
						Select @streamId = FileId from [SystemObject].[File] Where SystemObjectId = @SystemObjectId
						Exec [File].[FileTableDelete] @streamId	
											
						FETCH NEXT FROM Id_cursor INTO @InformationSourceId
					END 	
			CLOSE Id_cursor;
		DEALLOCATE Id_cursor;
	Commit Tran DeleteTran
 END