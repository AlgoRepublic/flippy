<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Upload File</title>
</head>
<body>
	<h1>Upload File</h1>
	<form method="post" action="upload.htm" enctype="multipart/form-data">
		<input name="sessionId" type="hidden" value="10"/>
		<input name="imageFile" type="file"/>
		<input type="submit"/>
	</form>
</body>
</html>