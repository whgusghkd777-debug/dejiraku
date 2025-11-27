<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
	  	<meta charset="UTF-8">
	  	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
	</head>
	<body style="padding:12px;">
		  <c:if test="${not empty ok}">
		    <div class="alert alert-success">${ok}</div>
		  </c:if>
		  <c:if test="${not empty error}">
		    <div class="alert alert-danger">${error}</div>
		  </c:if>
	</body>
</html>