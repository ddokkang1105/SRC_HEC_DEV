<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<style>
	.column--color-gray, .column--color-gray > .dhx_grid-cell {
		background: #f7f7f7;
	}
	.total {
	    font-weight: bold !important;
	    color: rgb(13, 101, 183);
	    text-decoration: underline;
    }
    .bold {
  	    font-weight: bold;
    }
</style>
<script>
	var p_gridArea;				//그리드 전역변수
	var grid_skin = "dhx_brd";
	var isMainMenu = "${isMainMenu}";
	
	$(document).ready(function(){
		// SKON CSRF 보안 조치
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				}
		})		
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 110)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 110)+"px;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		
		// 검색 버튼 클릭
		$('.searchList').click(function(){
			var url = "admin/newItemStatistics.do";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			
			/* [Dimension] 조건 선택값 */
			if ($("#dimTypeId").val() != "") {
				data = data + "&DimTypeID=" + $("#dimTypeId").val();
				if ($("#dimValueId").val() != "") {
					data = data + "&DimValueID=" + $("#dimValueId").val();
				}
			}
			
			var target = "help_content";
			alert(data);
			ajaxPage(url, data, target);
		});
		
		// DimensionTypeList change event
		$('#dimTypeId').change(function(){changeDimValue($(this).val());});
		if ("${DimTypeID}" != "") {
			changeDimValue("${DimTypeID}");
		}
		
// 		doSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
// 	function setGridData(){
// 		var result = new Object();
// 		var widths = "";
// 		var sorting = "";
// 		var aligns = "";
// 		var aCnt = "${cnt}";
// 		var colWidth = (document.body.clientWidth - 225 - 41) / aCnt;
		
// 		for (var i = 0; i < aCnt; i++) {
// 			widths = widths + "," + colWidth;
// 			sorting = sorting + ",str";
// 			aligns = aligns + ",center";
// 		}
		
// 		result.title = "";
// 		result.key = "";
// 		result.header = ",#cspan,#cspan,#cspan" + "${level1Name}";
		
// 		if(isMainMenu != "Y") {
// 			result.widths = "41" + widths;
// 		}
		
// 		result.sorting = "str" + sorting;
// 		result.aligns = "center" + aligns;
// 		result.data = "";
// 		return result;
// 	}
	
	// [Process Update] Click
	function processUpdate() {
		var url = "admin/newItemStatistics.do";
		var data = "eventMode=prcUpdate&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var target = "help_content";
		
		ajaxPage(url, data, target);
	}
	
	// [dimValue option] 설정
	function changeDimValue(avg){
		var url    = "getDimValueSelectOption.do"; // 요청이 날라가는 주소
		var data   = "dimTypeId="+avg; //파라미터들
		var target = "dimValueId";            // selectBox id
		var defaultValue = "${DimValueID}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendOption, 1000);
	}
	
	function appendOption(){
		$("#dimValueId").val("${DimValueID}").attr("selected", "selected");
	}
	
	function changeChart(){
		var url = "newItemStatisticsChart.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
		/* [Dimension] 조건 선택값 */
		if ($("#dimTypeId").val() != "") {
			data = data + "&DimTypeID=" + $("#dimTypeId").val();
			if ($("#dimValueId").val() != "") {
				data = data + "&DimValueID=" + $("#dimValueId").val();
			}
		}
		
		var target = "help_content";
		ajaxPage(url, data, target);
	}
</script>

<div class="pdL10 pdR10">
	<div class="cop_hdtitle" style="width:100%;">
		<li class="floatR pdR15">
			<div class="icon_color_btn2 searchList mgR5"  style="cursor:pointer; display:inline-block; background-color:#E3F0FE;" >
				<i class="mdi mdi-table" style="color:#0f80e2;"></i>
			</div>
			<div class="icon_color_btn" onclick="changeChart()" style="cursor:pointer; display:inline-block;">
		 		<i class="mdi mdi-chart-pie" style="color:#494848;"></i>
			</div>
		</li>
		<h3 style="padding: 6px 0; border-bottom: 1px solid #ccc;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Process Statistics</h3>
	</div>
	<div class="child_search01">
		<li class="pdL20">
			<select id="dimTypeId" style="width:120px">
	    		<option value=''>Select</option>
        	   	<c:forEach var="i" items="${dimTypeList}">
                	<option value="${i.DimTypeID}" <c:if test="${DimTypeID == i.DimTypeID}">selected="selected"</c:if>>${i.DimTypeName}</option>
        	    </c:forEach>
			</select>
			<select id="dimValueId" <c:if test="${isMainMenu eq 'Y' }"> style="width:120px;" </c:if> >
				<option value="">Select</option>
			</select>	
		</li>
		<li>
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" />
		</li>
		<li class="floatR">
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="processUpdate();">
				<span class="mdi mdi-pencil mgR5 mgL_5" style="color:#494848;"></span>Update
			</button>
			<button class="cmm-btn mgR5" style="height:30px;" id="excel">
				<span class="mdi mdi-file-excel mgR5 mgL_5" style="color:#009345;"></span>Down
			</button>
		</li>
	</div>
	
	<form name="itemStatisticsForm" id="itemStatisticsForm" action="" method="post" >	
		<div id="gridDiv" class="mgB10 mgT5">
			<div id="layout" style="width:100%"></div>
		</div>	
	</form>
</div>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});

	let spansData = [];
	let gridData = ${gridData};
	let level1Name = ${level1Name};
	
	var aCnt = "${cnt}";
	var colWidth = (window.innerWidth - 225 - 41) / aCnt;
	
	let columns = [
        { width: colWidth * 2, id: "class", header: [{ text: "", colspan: 2, align:"center"}], align:"center", mark: () => ("column--color-gray"),},
        { width: colWidth * 2, id: "class-sub", header: [{ text: "", align:"center"}], align:"center", mark: () => ("column--color-gray"),},
    ];
	
	if(level1Name) {
		level1Name.forEach(e => {
			columns.push({ width: colWidth, id: String(e.id), header: [{ text: e.text, colspan: 2, align:"center"}], align:"center",
				template: function (text, row, col) {
        			return text ? text : 0;
            	}
			});
			columns.push({ width: colWidth, id: e.id+"-sub", header: [{ text: ""}], align:"center"});
		})
		columns.push({ width: colWidth, id: "total", header: [{ text: "Total", colspan: 2, align:"center"}], align:"center",
			template: function (text, row, col) {
    			return text ? text : 0;
        	}
		});
		columns.push({ width: colWidth, id: "total-sub", header: [{ text: ""}], align:"center" });
	}
	
	if(gridData) {
		gridData.forEach((e,i) => {
		    if(e["class-colspan"]) {
		    	// 클래스코드명 colspan
		    	spansData.push({row : e.id, column : "class", colspan : e["class-colspan"]})
		    	
		    	columns.forEach((column,i) => {
		    		// item별 % 표시 안하는 셀 colspan
				    if(1 < i && !String(column.id).includes("sub") && !e[column.id + "-sub"])  {
				    	spansData.push({row : e.id, column : String(column.id), colspan : 2})
				    }
				})
		    }
		})
		
		// Level 별 Total row colspan
		gridData.filter(e => e["class-sub"] == "Total").forEach(e => {
	    	columns.forEach((column,i) => {
			    if(1 < i && !String(column.id).includes("sub") && !e[column.id + "-sub"])  {
			    	spansData.push({row : e.id, column : String(column.id), colspan : 2, css : "column--color-gray"})
			    }
			})
		})
		
		// N/A 값을 구해야하는 classCode
		const classCodeList = gridData.filter(e => e["class-sub"] && !e.id.includes("-")).map(e => e.id);
		// 계산해야하는 item
		const items = columns.filter(e => isFinite(e.id)).map(e => e.id);
		
		classCodeList.forEach(classCode => {
			items.forEach(item => {
				let total = Number(gridData.filter(e => e.id === classCode).map(e => e[item]).join(""));
				let rowTotal = gridData.filter(e => e.id.includes(classCode+"-LV")).map(e => e[item]).reduce((a, c) => {
				    if (c !== undefined) return a + Number(c);
				    return a;
				}, 0);
				
				// N/A 값 구하기
				gridData.forEach(e => {
					if(e.id == classCode + "-na") {
						e[item] = total - rowTotal;
						e[item+"-sub"] = getRatio(total, total - rowTotal);
						e["total"] = getRowTotal(e);
						e["total-sub"] = getRatio(gridData.filter(e => e.id == classCode).map(e => e.total).join(""), e.total);
					}
				})
				
				// item sub 칼럼 퍼센트 구하기
				gridData.filter(e => e.id.includes(classCode+"-LV")).forEach(e => {
				    e[item+"-sub"] = getRatio(total, e[item]);
				    e["total"] = getRowTotal(e);
				    e["total-sub"] = getRatio(gridData.filter(e => e.id == classCode).map(e => e.total).join(""), e.total);
				})
			})
			
			let rowSpanSize = gridData.filter(e => e.id.includes(classCode)).length;
			let firstRow = gridData.filter(e => e.id.includes(classCode))[0].id;
			spansData.push({row : firstRow, column : "class", rowspan : rowSpanSize})
		})
	}
	
	var grid = new dhx.Grid("grdGridArea",  {
		columns: columns,
	    resizable: true,
	    tooltip: false,
	    data: gridData,
	    spans: spansData
	});
	
	 layout.getCell("a").attach(grid);
	
	grid.data.getInitialData().filter(e => !e.id.includes("-")).forEach(e => {
		grid.addCellCss(e.id, "total", "total");
		grid.addCellCss(e.id, "total-sub", "total");
	})
	
	grid.data.getInitialData().filter(e => e.id.includes("-")).forEach(e => {
		grid.addCellCss(e.id, "total", "bold");
		grid.addCellCss(e.id, "total-sub", "bold");
	})
	
	// 각 row별 Total 값 구하기
	function getRowTotal(e) {
	    const entries = Object.entries(e);
	    const total = entries.reduce((sum, [key, value]) => {
	        const isNumericKey = !isNaN(Number(key)) && key !== "$height";
	        if (isNumericKey) {
	            return sum + Number(value);
	        }
	        return sum;
	        
	    }, 0);
	    
	    return total;
	}
	
	function getRatio(levelTotalNum, subTotalNum) {
	    // 입력된 값이 문자열일 경우 숫자로 변환합니다. (선택 사항)
	    const level = Number(levelTotalNum);
	    const sub = Number(subTotalNum);

	    // 1. 0으로 나누는 경우 또는 부분 값이 0인 경우 "0%"를 반환합니다.
	    // (Java의 levelTotalNum.compareTo(BigDecimal.ZERO) == 0 || subTotalNum.compareTo(BigDecimal.ZERO) == 0 와 동일)
	    if (level === 0 || sub === 0 || isNaN(level) || isNaN(sub)) {
	        return "0%";
	    }

	    // 2. 비율 계산: (sub / level) * 100
	    // Java의 (subTotalNum.divide(levelTotalNum, MathContext.DECIMAL32)).multiply(new BigDecimal(100)) 와 유사
	    const ratio = (sub / level) * 100;

	    // 3. 소수점 0자리에서 반올림하고 문자열로 변환합니다.
	    // Math.round()는 RoundingMode.HALF_UP과 가장 유사하게 동작합니다.
	    const resultRatio = Math.round(ratio);
	    
	    // 4. "%" 기호를 붙여 최종 문자열을 반환합니다.
	    // (Java의 resultRatio.toString() + "%" 와 동일)
	    return resultRatio.toString() + "%";
	}
</script>