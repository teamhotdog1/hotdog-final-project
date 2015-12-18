<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">

	$(document).ready(function() {
		var file0 = document.querySelector('#file0');
    	var file1 = document.querySelector('#file1');
    	var file2 = document.querySelector('#file2');
    	$("#boardContent").keyup(function(){
    		if(!($("#img0").length > 0)){
    			$("#file0").val("");
	    		$("#fileInfo0").html("");
    		}
    		if(!($("#img1").length > 0)){
    			$("#file1").val("");
	    		$("#fileInfo1").html("");
    		}
    		if(!($("#img2").length > 0)){
    			$("#file2").val("");
	    		$("#fileInfo2").html("");
    		}
    	});
    	$("#boardContent").keydown(function(e){
    		if (e.keyCode === 13) {
   		      document.execCommand('insertHTML', false, "<br><br>");
   		      return false;
   		    }
    	});
    	file0.onchange = function () { 
    	    var fileList = file0.files;
    	    var reader = new FileReader();
    	    if(fileList[0] instanceof Blob){
	    	    reader.readAsDataURL(fileList[0]);
	    	    reader.onload = function  () {
	    	    	$("#img0").remove();
	    	    	$("#boardContent").html($("#boardContent").html()+"<img class='hotdogimg' id='img0' width='300' src='"+reader.result+"'></img>");
	    	    }; 
    	    }else{
    	    	$("#img0").remove();
    	    }
    	};
    	file1.onchange = function () { 
    	    var fileList = file1.files;
    	    var reader = new FileReader();
    	    if(fileList[0] instanceof Blob){
	    	    reader.readAsDataURL(fileList[0]);
	    	    reader.onload = function  () {
	    	    	$("#img1").remove();
	    	    	$("#boardContent").html($("#boardContent").html()+"<img class='hotdogimg' id='img1' width='300' src='"+reader.result+"'></img>");
	    	    }; 
    	    }else{
    	    	$("#img1").remove();
    	    }
    	};
    	file2.onchange = function () { 
    	    var fileList = file2.files;
    	    var reader = new FileReader();
    	    if(fileList[0] instanceof Blob){
	    	    reader.readAsDataURL(fileList[0]);
	    	    reader.onload = function  () {
	    	    	$("#img2").remove();
	    	    	$("#boardContent").html($("#boardContent").html()+"<img class='hotdogimg' id='img2' width='300' src='"+reader.result+"'></img>");
	    	    }; 
    	    }else{
    	    	$("#img2").remove();
    	    }
    	};
		$("#writeBtn").click(	function() {
			if ($("#boardTitle").val() == "") {
				alert("글 제목을 입력하세요!");
				$("#boardTitle").focus();
				return;
			}
			if ($("#petGender").val() == "") {
				alert("성별을 선택해주세요!");
				return;
			}
			if ($("#petNeutralInfo").val() == "") {
				alert("중성화여부를 선택해주세요!");
				return;
			}
			if ($("#petSize").val() == "") {
				alert("애견크기를 선택해주세요!");
				return;
			}
			if ($("#boardContent").text() == "") {
				alert("글 내용을 입력하세요!");
				$("#boardContent").focus();
				return;
			}
			if($("#boardTitle").val().length > 30){
    			alert("글 제목이 너무 깁니다.\n30자 이내로 입력해주시기 바랍니다!");
    			$("#boardTitle").focus();
    			return;
    		}
			var fileExist = "";
			for (var i = 0; i < 3; i++) {
				fileExist += $("#file" + i).val();
				if ($("#file" + i).val() != "") {
					var fileExt = $("#file" + i).val().substring($("#file"	+ i)	.val().lastIndexOf('.') + 1).toUpperCase();
					if (fileExt != "JPG" && fileExt != "GIF" && fileExt != "JPEG" && fileExt != "PNG") {
						alert("첨부파일은 jpg, gif, jpeg, png로 된 이미지만 가능합니다.");
						return;
					}
				}
			}
			if (fileExist == "") {
				alert("이미지 파일을 첨부하셔야 글을 등록하실 수 있습니다.");
				return;
			}
			for (var i = 0; i < 3; i++) {
				if ($("#fileInfo" + i).text().search("용량") != -1) {
					alert("첨부파일의 용량이 초과되었습니다.");
					return;
				}
			}
			$("#boardContentHidden").val($("#boardContent").html());
    		$("#write_form").submit();
		});
		$("#file0").change(function() {
			checkFileSize(0);
		});
		$("#file1").change(function() {
			checkFileSize(1);
		});
		$("#file2").change(function() {
			checkFileSize(2);
		});
		function checkFileSize(index) {
			if ($("#file" + index).val() == "") {
				$("#fileInfo" + index).html("");
			} else {
				var iSize = 0;
				if ($.browser.msie) {
					var objFSO = new ActiveXObject("Scripting.FileSystemObject");
					var sPath = $("#file" + index)[0].value;
					var objFile = objFSO.getFile(sPath);
					var iSize = objFile.size;
					iSize = iSize / 1024;
				} else {
					iSize = ($("#file" + index)[0].files[0].size / 1024);
				}
				if (iSize / 1024 > 1) {
					iSize = (Math.round((iSize / 1024) * 100) / 100)
					if (iSize >= 5) {
						$("#fileInfo" + index).html("<font color='red'>"	+ iSize	 + "Mb 용량이 초과되었습니다.</font>");
					} else {
						$("#fileInfo" + index).html("<font color='blue'>" + iSize + "Mb</font>");
					}
				} else {
					iSize = (Math.round(iSize * 100) / 100)
					$("#fileInfo" + index).html("<font color='blue'>" + iSize + "kb</font>");
				}
			}
		}
		$("#resetBtn").click(function() {
			if (confirm("글 작성을 취소하시겠습니까?")) {
				location.href = "getPostingList.do?type=board_adoption";
			}
		});
	});
	
	

</script>
<br>

          <h1>유기견분양</h1>
<div class="section">
	<div class="container">
		<form class="form-horizontal" role="form" action="${initParam.root}auth_posting.do?type=board_adoption"
			id="write_form" method="post" enctype="multipart/form-data">
			<div class="form-group">
				<div class="col-sm-2">
					<label for="inputEmail3" class="control-label">제목</label>
				</div>
				<div class="col-sm-4">
					<input type="text" class="form-control" id="boardTitle"
						placeholder="글 제목을 입력하세요" name="boardTitle" onfocus="this.select()"
						required="">
				</div>
			</div>
						<div class="form-group">
				<div class="col-sm-2">
					<label for="inputEmail3" class="control-label">닉네임</label>
				</div>
				<div class="col-sm-4">
					<label for="inputEmail3" class="control-label">${sessionScope.loginVo.memberNickName}</label>

				</div>
			</div>
			<div class="form-group">
				<div class="col-sm-2">
					<label for="inputEmail3" class="control-label">전화번호</label>
				</div>
				<div class="col-sm-4">
					<label for="inputEmail3" class="control-label">${sessionScope.loginVo.memberTel}</label>
				</div>
			</div>
			<div class="form-group">
				<div class="col-sm-2">
					<label for="inputEmail3" class="control-label">거주지역</label>
				</div>
				<div class="col-sm-4">
				<select class="selectpicker" data-style="btn-info" name="residence">
				<option value="서울">서울</option>
				<option value="경기도">경기도</option>
				<option value="강원도">강원도</option>
				<option value="충청도">충청도</option>
				<option value="전라도">전라도</option>
				<option value="경상도">경상도</option>
			</select>
<!-- 					<input type="text" class="form-control" id="residence"
						placeholder="사시는 지역을 입력하세요" name="residence"
						onfocus="this.select()" required=""> <span
						id="loginIdCheckView"></span> -->
				</div>
			</div>
			<div class="form-group">
				<div class="col-sm-2">
					<label for="inputEmail3" class="control-label">애견종류</label>
				</div>
				<div class="col-sm-4">
				<select class="selectpicker" data-style="btn-info" name="petType">
				<option value="삽살개">삽살개</option>
				<option value="진돗개">진돗개</option>
				<option value="풍산개">풍산개</option>
				<option value="우리집개">우리집개</option>
			</select>
			
			
			

				</div>
			</div>

			<div class="form-group">
				<div class="col-sm-2">
					<label for="inputEmail3" class="control-label">애견나이</label>
				</div>

				
			<div class="col-sm-4">
			
				<select class="selectpicker" data-style="btn-info" name="petAge">
				<c:forEach var="i" begin="1" end="15">
				<option value="${i}">${i}</option>
			    </c:forEach>
			    </select>
			    
			</div>
	
				
				
<!-- 
				<div class="col-sm-4">

					<input type="text" class="form-control" id="petAge"
						placeholder="애견나이를 입력하세요" name="petAge" onfocus="this.select()"
						required="">
				</div> -->
			</div>



			<div class="form-group">
				<div class="col-sm-2">
					<label for="inputEmail3" class="control-label">성별</label>
				</div>
				<div class="col-sm-4">
					<label class="radio-inline"> <input type="radio"
						name="petGender" id="petGender" value="수컷">수컷
					</label> <label class="radio-inline"> <input type="radio"
						name="petGender" id="petGender" value="암컷">암컷
					</label>
				</div>
			</div>
			
			<div class="form-group">
				<div class="col-sm-2">
					<label for="inputEmail3" class="control-label">중성화여부</label>
				</div>
				<div class="col-sm-4">
					<label class="radio-inline"> <input type="radio"
						name="petNeutralInfo" id="petNeutralInfo" value="예">예&nbsp;&nbsp;
					</label> <label class="radio-inline"> <input type="radio"
						name="petNeutralInfo" id="petNeutralInfo" value="아니오">아니오
					</label>
				</div>
			</div>

			<div class="form-group">
				<div class="col-sm-2">
					<label for="inputEmail3" class="control-label">애견크기</label>
				</div>
				<div class="col-sm-4">
					<label class="radio-inline"> <input type="radio"
						name="petSize" id="petSize" value="소형">소형
					</label> <label class="radio-inline"> <input type="radio"
						name="petSize" id="petSize" value="중형">중형
					</label> <label class="radio-inline"> <input type="radio"
						name="petSize" id="petSize" value="대형">대형
					</label>

				</div>
			</div>
			<div class="form-group">
				<div class="col-sm-2">
					<label for="inputEmail3" class="control-label">내용</label>
				</div>
				<div class="col-sm-4">
					<input type = "hidden" name = "boardContent" id = "boardContentHidden" value = "">
     				<div id="boardContent" contenteditable="true"></div>
				</div>
			</div>
			<div class="form-group">
				<div class="col-sm-12">
					<label for="exampleInputFile">파일 업로드</label>
				    <input type="file" name="file[0]" id="file0" accept="image/*"><div id="fileInfo0"></div><br>
				    <input type="file" name="file[1]" id="file1" accept="image/*"><div id="fileInfo1"></div><br>
				    <input type="file" name="file[2]" id="file2" accept="image/*"><div id="fileInfo2"></div><br>
				    <font color="red">* 이미지 파일만 업로드 가능합니다.<br>
				    * 용량 제한은 5MB입니다.</font> 
					</div>
				</div>


			<div class="modal-footer">
				<ul class="nav navbar-nav navbar-left">
					<li>
					<a id="writeBtn" class="action">글쓰기</a>
					</li>
					<li><a id="resetBtn" class="action">닫기</a></li>
					
					
				</ul>
			</div>
		</form>
	</div>
		
	</div>

