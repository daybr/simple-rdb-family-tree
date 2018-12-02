<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
</head>
<body>
	<div class="container">
		<div>부모 정보</div>
		<button type="button" class="btn btn-primary" onClick="onSearchParentPopup()">Find your parent...</button>
	</div>
</body>
<script>
	function onSearchParentPopup() {
		var win = window.open(null, '_blank',
				"top=10, left=10, width=600, height=500");
		win.document
				.write('<iframe width="100%", height="100%" src="search-parent.jsp?" '
						+ 'frameborder="0" allowfullscreen></iframe>')
	}
</script>
</html>