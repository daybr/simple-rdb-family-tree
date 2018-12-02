<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="com.simple.rdb.family_tree.insertion.HumanByNameSelecter"%>
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
<!-- <link rel="stylesheet" type="text/css" media="screen"
	href="${pageContext.request.contextPath}/css/main.css" /> -->
<!-- jQuery library -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>
<body>
	<%
		String query = request.getParameter("q");
		if (query == null) {
			query = "";
		}
	%>
	<div class="container">
		<h3>Find your parent!</h3>
		<form action="" onsubmit="onSubmitQuery(this)">
			<div class="input-group">
				<label for="query-input" class="form-control col-2">Name</label>
				<input type="text" class="form-control col-8" id="query-input" name="q">
				<button type="submit" class="btn btn-primary form-control col-2">Search</button>
			</div>
		</form>
		<pre><%=new HumanByNameSelecter().queryAsJson(true, query)%></pre>
	</div>
</body>
<script>
	$(document).ready(function () {
		$('#query-input').val('<%= query %>')
	})

	function onSubmitQuery() {
		window.location.replace('?&q=' + encodeURI($('#query-input').val()))
	}
</script>
</html>
