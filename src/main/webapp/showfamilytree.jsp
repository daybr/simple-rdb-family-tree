<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="com.simple.rdb.family_tree.OJDBCAdapter"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- Bootstrap 4 CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<!-- Main CSS -->
<link rel="stylesheet" type="text/css" media="screen"
	href="${pageContext.request.contextPath}/css/main.css" />
<!-- jQuery library -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-2.1.1.min.js"></script>
<script src="https://d3js.org/d3.v3.js"></script>

<title>Welcome to Family Tree</title>
</head>
<body>
		<div id="graph"></div>

</body>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/graph.js"></script>
</html>
