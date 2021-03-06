--EXEC	 [SystemObject].[SystemObjectFileDelete] '250,1'
ALTER PROCEDURE [SystemObject].[SystemObjectFileDelete](@Ids nvarchar(MAX))
   AS
 BEGIN
    SET NOCOUNT ON;		
	if(@Ids Is NULL)
		Return
	Declare @IdList TABLE(Id NVARCHAR(MAX))	
	Insert Into @IdList select splitData from [Utility].[Split](@Ids,',')
	Declare @streamId as UniqueIdentifier						 	
	Declare @Row as NVARCHAR(MAX)
	Begin Tran DeleteTran	
		DECLARE Id_cursor CURSOR FOR 	
	        Select Id from @IdList
			OPEN Id_cursor	FETCH NEXT FROM Id_cursor INTO @Row
				WHILE @@FETCH_STATUS = 0
					BEGIN		
						Set @streamId = NULL

						Select @streamId = FileId from [SystemObject].[File] Where Id = Cast(@Row As Int)						
						Exec [File].[FileTableDelete] @streamId						
						FETCH NEXT FROM Id_cursor INTO @Row
					END 	
			CLOSE Id_cursor;
		DEALLOCATE Id_cursor;
	Commit Tran DeleteTran
 END