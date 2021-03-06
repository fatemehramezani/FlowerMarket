ALTER FUNCTION [Security].[GetUserProfileFullName]( @UserId int)
RETURNS nvarchar(64)
AS
BEGIN
	DECLARE @FullName nvarchar(64)
	SELECT @FullName = FirstName + ' ' + LastName from [User].[Profile] where UserId = @UserId
	RETURN @FullName
END
