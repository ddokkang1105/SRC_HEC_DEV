<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<style>
.dhx_list_template_a__title {
        font-weight: 600;
        white-space: nowrap;
        overflow-x: hidden;
        text-overflow: ellipsis;
    }
    .searchList2, .searchList3 {
    	margin:5px 0;
    }
</style>
<script type="text/javascript">
	var termsData = '${termsData}';
	var regExp;
	
	$(document).ready(function(){
		$("#list").attr("style","height:"+(setWindowHeight() - 280)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#list").attr("style","height:"+(setWindowHeight() - 280)+"px;");
		};
		
		function template(item) {
		    var template = "<div class='list_item'>";
		        template += "<div class='dhx_list_template_a__title'>" + item.Name +"</div>";
		        template += "<div class='item_author'>" + item.Description + "</div>";
		        template += "</div>";
		    return template;
		};

		var list = new dhx.List("list", {
			template: template,
			css: "dhx_widget--bordered",
		});
		
		list.events.on("click", function () {
			var itemID = list.selection.getItem().ItemID
			var url = "viewTermDetail.do?itemID="+itemID+"&csr=${csr}"+"&mgt=${mgt}";
			window.open(url,'_blank','width=1000, height=720, left=200, top=100,scrollbar=yes,resizble=0');
		});

		list.data.parse(termsData);
		
		var pagination = new dhx.Pagination("pagination", {
		    data: list.data,
		    pageSize: 30,
		});
		
		document.querySelector("#selected_item").addEventListener("keyup", function (event) {
			  const key = event.target.value;
			  if (key) {
			    list.data.filter(function(item) {
			      return item.Name.toLowerCase().includes(key.toLowerCase());
			    });
			  } else {
			    list.data.filter();
			  }
			});
		
		/** [A,B,C...버튼 클릭] */
		$('.searchList2').click(function(){
			var alphabet = $(this).attr("alt");
			list.data.filter(function(item) {
		      return item.Name.substr(0,1).includes(alphabet);
		    });
		});
		
		/** [ㄱ,ㄴ,ㄷ...버튼 클릭] */
		$('.searchList3').click(function(){
			setSearchCondition4($(this).attr("alt"));
			list.data.filter(function(item) {
		      return regExp.test(item.Name.substr(0,1));
		    });
		});
	});
		
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	function setSearchCondition4(searchCondition3) {
		switch (searchCondition3) {		
			case "ㄱ" : 
				regExp = /[가-깋]/;
				break;
			case "ㄴ" : 
				regExp = /[나-닣]/;
				break;
			case "ㄷ" : 
				regExp = /[다-딯]/;
				break;
			case "ㄹ" : 
				regExp = /[라-맇]/;
				break;
			case "ㅁ" : 
				regExp = /[마-밓]/;
				break;
			case "ㅂ" : 
				regExp = /[바-빟]/;
				break;
			case "ㅅ" : 
				regExp = /[사-싷]/;
				break;
			case "ㅇ" : 
				regExp = /[아-잏]/;
				break;
			case "ㅈ" : 
				regExp = /[자-짛]/;
				break;
			case "ㅊ" : 
				regExp = /[차-칳]/;
				break;
			case "ㅋ" : 
				regExp = /[카-킿]/;
				break;
			case "ㅌ" : 
				regExp = /[타-팋]/;
				break;
			case "ㅍ" : 
				regExp = /[파-핗]/;
				break;
			case "ㅎ" : 
				regExp = /[하-힣]/;
				break;
		}
	}
</script>
<form name="standardTermsSchFrm" id="standardTermsSchFrm" action="" method="post">
	<div class="title-section bordered-bottom">${menu.LN00300}</div>
	<div class="mgB10 mgT10 pdL10">	
		<section class="dhx_sample-controls">
		    <label for="selected_item" class="dhx_sample-label">명칭</label>
		    <input type="text" id="selected_item" class="dhx_sample-input">
		</section>
		<section class="dhx_sample-controls mgT2 mgB2">
			<label for="selected_item" class="dhx_sample-label">Korean</label>
			<img src="${root}${HTML_IMG_DIR}/dic_korea_01.png" width="16" height="16" alt="ㄱ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_02.png" width="16" height="16" alt="ㄴ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_03.png" width="16" height="16" alt="ㄷ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_04.png" width="16" height="16" alt="ㄹ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_05.png" width="16" height="16" alt="ㅁ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_06.png" width="16" height="16" alt="ㅂ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_07.png" width="16" height="16" alt="ㅅ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_08.png" width="16" height="16" alt="ㅇ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_09.png" width="16" height="16" alt="ㅈ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_10.png" width="16" height="16" alt="ㅊ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_11.png" width="16" height="16" alt="ㅋ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_12.png" width="16" height="16" alt="ㅌ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_13.png" width="16" height="16" alt="ㅍ" class="searchList3">&nbsp;
			<img src="${root}${HTML_IMG_DIR}/dic_korea_14.png" width="16" height="16" alt="ㅎ" class="searchList3">
		</section>
		<section class="dhx_sample-controls mgT2 mgB2">
			<label for="selected_item" class="dhx_sample-label">English</label>
			  	<img src="${root}${HTML_IMG_DIR}/dic_eng_01.png" width="16" height="16" alt="A" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_02.png" width="16" height="16" alt="B" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_03.png" width="16" height="16" alt="C" class="searchList2">&nbsp;	
				<img src="${root}${HTML_IMG_DIR}/dic_eng_04.png" width="16" height="16" alt="D" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_05.png" width="16" height="16" alt="E" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_06.png" width="16" height="16" alt="F" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_07.png" width="16" height="16" alt="G" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_08.png" width="16" height="16" alt="H" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_09.png" width="16" height="16" alt="I" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_10.png" width="16" height="16" alt="J" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_11.png" width="16" height="16" alt="K" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_12.png" width="16" height="16" alt="L" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_13.png" width="16" height="16" alt="M" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_14.png" width="16" height="16" alt="N" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_15.png" width="16" height="16" alt="O" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_16.png" width="16" height="16" alt="P" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_17.png" width="16" height="16" alt="Q" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_18.png" width="16" height="16" alt="R" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_19.png" width="16" height="16" alt="S" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_20.png" width="16" height="16" alt="T" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_21.png" width="16" height="16" alt="U" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_22.png" width="16" height="16" alt="V" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_23.png" width="16" height="16" alt="W" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_24.png" width="16" height="16" alt="X" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_25.png" width="16" height="16" alt="Y" class="searchList2">&nbsp;
				<img src="${root}${HTML_IMG_DIR}/dic_eng_26.png" width="16" height="16" alt="Z" class="searchList2">	 
		</section>
    </div>

	<div id="list" class="mgR20 mgL20"></div>
	<div id="pagination"></div>
</form>	

