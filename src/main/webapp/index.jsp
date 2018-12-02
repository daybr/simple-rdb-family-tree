<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="com.simple.rdb.family_tree.OJDBCAdapter"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Open+Sans:300,400">
<!-- Google web font "Open Sans" -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/font-awesome-4.5.0/css/font-awesome.min.css"/ >
<!-- Font Awesome -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/slick/slick.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/slick/slick-theme.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/tooplate-style.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/magnific-popup.css" />
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
	<div class="parallax-window" data-parallax="scroll"
		data-image-src="${pageContext.request.contextPath}/img/bg-img-01.jpg">
		<section class="container tm-page-1-content">
			<div class="row">
				<div class="col-md-6 ml-auto tm-text-white">
					<header>
						<h1>Find your Root</h1>
					</header>
					<p>자신으로 부터 시작되는 가계도 그리기</p>

					<a href="#tm-section-2" class="btn btn-danger">Explore...</a>
				</div>
			</div>

		</section>
	</div>


	<div id="tm-section-2" class="parallax-window" data-parallax="scroll"
		data-image-src="${pageContext.request.contextPath}/img/bg-img-02.jpg">
		<section class="container tm-page-1-content tm-page-2">
			<div class="row">
				<article class="col-md-6 tm-article tm-bg-white-transparent">
					<header>
						<h2>부계로 찾기</h2>
					</header>
					<b>Donec id augue ac risus faucibus . Quisque tincidunt, sapien
						et tincidunt suscipit, diam ipsum iaculis augue, nec semper orci
						ex a arcu. Donec efficitur sem sed ligula mollis.</b> <a
						href="#tm-section-3"
						class="btn btn-danger ml-auto mr-0 tm-btn-block"
						onclick="location.href='showfamilytree.jsp' ">Details...</a>
				</article>

				<article class="col-md-6 tm-article tm-bg-white-transparent">
					<header>
						<h2>모계로 찾기</h2>
					</header>
					<b>Donec id augue ac risus faucibus elementum. Quisque
						tincidunt, sapien et tincidunt suscipit, diam ipsum iaculis augue,
						nec semper orci ex a arcu. Duis commodo orci libero.</b> <a
						href="#tm-section-3"
						class="btn btn-danger ml-auto mr-0 tm-btn-block"
						onclick="location.href='showfamilytree.jsp' ">Details...</a>
				</article>
			</div>
		</section>
	</div>


	<div class="parallax-window tm-position-relative tm-form-section"
		data-parallax="scroll"
		data-image-src="${pageContext.request.contextPath}/img/bg-img-06.jpg">
		<div class="container ">
			<div class="row1 ">

				<div class="col-lg-8 col-md-6 col-xs-12">
					<div class="tm-address-box">
						<p>Integer pretium volutpat tempor. Maecenas condimentum
							tincidunt leo. Paesent scelerisque erat placerat tempus laoreet.
							Vivamus pellentesque tempor congue. Vestibulum ac diam dui.
							Vivamus a fringilla velit.</p>
						<br>
						<address>
							<b>Our Address</b><br> <br> 440-660 Proin mauris enim,<br>
							dignissim sit amet ligula id,<br> finibus tempus erat 10200
						</address>
					</div>
				</div>
			</div>

			<div class="footer">
				<p>
					Copyright © 2018 Your Company . Design: <a
						href="http://www.tooplate.com/view/2096-individual"
						target="_parent">Individual</a>
				</p>
			</div>
		</div>

	</div>


	<!-- load JS files -->
	<script
		src="${pageContext.request.contextPath}/js/jquery-1.11.3.min.js"></script>
	<!-- jQuery (https://jquery.com/download/) -->
	<script src="${pageContext.request.contextPath}/js/parallax.min.js"></script>

	<script type="text/javascript" src="slick/slick.min.js"></script>
	<!-- Slick Carousel -->

	<!-- Magnific Popup core JS file -->
	<script
		src="${pageContext.request.contextPath}/js/jquery.magnific-popup.min.js"></script>

</body>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/graph.js"></script>
</html>
