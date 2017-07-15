<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<title>众筹系统</title>
<link rel="stylesheet" href="static/bootstrap/bootstrap.min.css">
<script type="text/javascript" src="static/jquery/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="static/bootstrap/bootstrap.min.js"></script>
</head>

<style>
body {
	text-align: center;
}

.table th, .table td {
	text-align: center;
	vertical-align: middle;
}
</style>

<script>
	function select(owner) {
		$('#owner').val(owner);
	}

	// 模态框1
	function confirm() {
		var owner = $.trim($('#owner').val());
		var coin = $.trim($('#coin').val());
		var password = $.trim($('#password').val());
		var file = $.trim($('#file').val());
		if (!owner || !coin || !password || !file) {
			alert('信息不完善！');
			return false;
		}

		// 读取文件
		var reader = new FileReader();
		reader.readAsText(document.getElementById("file").files[0], "UTF-8");
		reader.onload = function(e) {
			var content = e.target.result;

			// 异步提交
			$.ajax({
				url : "sendCoin",
				type : "POST",
				data : {
					"owner" : owner,
					"coin" : coin,
					"password" : password,
					"content" : content
				},
				beforeSend : function() {
					$("#tip").html('<span style="color:blue">正在处理...</span>');
					return true;
				},
				success : function(res) {
					if (res) {
						alert('操作成功');
					} else {
						alert('操作失败');
					}
					setTimeout(function() {
						$("#myModal").modal('hide')
					}, 1000);
				}
			});
		};
		return false;
	}

	//模态框2
	function confirm2() {
		var password = $.trim($('#password2').val());
		var file = $.trim($('#file2').val());
		if (!password || !file) {
			alert('信息不完善！');
			return false;
		}

		// 读取文件
		var reader = new FileReader();
		reader.readAsText(document.getElementById("file2").files[0], "UTF-8");
		reader.onload = function(e) {
			var content = e.target.result;

			// 异步提交
			$.ajax({
				url : "raiseFund",
				type : "POST",
				data : {
					"password" : password,
					"content" : content
				},
				beforeSend : function() {
					$("#tip2").html('<span style="color:blue">正在处理...</span>');
					return true;
				},
				success : function(res) {
					if (res) {
						alert('操作成功');
					} else {
						alert('操作失败');
					}
					setTimeout(function() {
						$("#myModal2").modal('hide')
					}, 1000);
				}
			});
		};
		return false;
	}

	// 模态框1
	$(function() {
		$('#myModal').on('hide.bs.modal', function() {
			$("#owner").val('');
			$("#coin").val('');
			$("#password").val('');
			$("#file").val('');
			$("#tip").html('<span id="tip"> </span>');
		})
	});

	//模态框2
	$(function() {
		$('#myModal2').on('hide.bs.modal', function() {
			$("#password2").val('');
			$("#file2").val('');
			$("#tip2").html('<span id="tip2"> </span>');
		})
	});
</script>

<body>
	<div class="container">
		<div class="jumbotron">

			<h2 class="text-muted">众筹列表</h2>

			<!-- 后台返回结果为空 -->
			<c:if test="${ fn:length(fList) eq 0 }">
				<p class="text-danger">暂无众筹</p>
			</c:if>

			<!-- 后台返回结果不为空 -->
			<c:if test="${ fn:length(fList) gt 0 }">
				<table class="table">
					<thead>
						<tr>
							<th>众筹地址</th>
							<th>已筹人数</th>
							<th>已筹金币</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${ fList }" var="fund">
							<tr>
								<td><c:out value="${ fund.owner }"></c:out></td>
								<td><c:out value="${ fund.number }"></c:out></td>
								<td><c:out value="${ fund.coin }"></c:out></td>
								<td><button type="button" class="btn btn-primary btn-sm"
										data-toggle="modal" data-target="#myModal"
										onclick="select('${ fund.owner }')">我要捐赠</button></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>

			<button type="button" class="btn btn-success btn-lg"
				data-toggle="modal" data-target="#myModal2">我要众筹</button>
		</div>
	</div>

	<!-- 模态框1（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">发送金币</h4>
				</div>

				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label class="col-sm-2 control-label">地址</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="owner" name="owner"
									placeholder="0x..." readOnly />
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-2 control-label">金币</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="coin" name="coin" />
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-2 control-label">密码</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="password"
									name="password" />
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-2 control-label">密钥</label>
							<div class="col-sm-8">
								<input type="file" id="file" name="file" />
							</div>
						</div>
					</form>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="confirm()">确认</button>
					<span id="tip"> </span>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

	<!-- 模态框2（Modal） -->
	<div class="modal fade" id="myModal2" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel2" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel2">发起众筹</h4>
				</div>

				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label class="col-sm-2 control-label">密码</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="password2"
									name="password2" />
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-2 control-label">密钥</label>
							<div class="col-sm-8">
								<input type="file" id="file2" name="file2" />
							</div>
						</div>
					</form>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="confirm2()">确认</button>
					<span id="tip2"> </span>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
</body>
</html>