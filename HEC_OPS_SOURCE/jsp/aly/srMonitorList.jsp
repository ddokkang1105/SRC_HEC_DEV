
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script>
   var p_gridArea;   
   var screenType = "${screenType}";
   var srMode = "${srMode}";
   var srType = "${srType}";
   var itemID = "${itemID}";

   $(document).ready(function(){   
      // 초기 표시 화면 크기 조정 
      $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
      // 화면 크기 조정
      window.onresize = function() {
         $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
      };
      
     $("#excel").click(function(){
			doExcel();
			return false;
		});
      
      var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
      fnSelect('srArea1', data, 'getSrArea1', '${srArea1}', 'Select');
      if('${srArea1}' !='' ) fnGetSRArea2('${srArea1}');
      if('${category}' !='')fnGetSubCategory('${category}');
      fnSelect('category', data +"&level=1", 'getESMSRCategory', '${category}', 'Select','esm_SQL');
      fnSelect('srStatus', data +"&itemClassCode=CL03004", 'getSRStatusList', '${srStatus}', 'Select','esm_SQL');
      fnSelect('requestTeam', data, 'getESMSRReqTeamID', '${requestTeam}', 'Select','esm_SQL');
      fnSelect('srReceiptTeam', data, 'getESMSRReceiptTeamID', '${srReceiptTeam}', 'Select','esm_SQL'); 
      
      $("input.datePicker").each(generateDatePicker);
      
      $('.searchList').click(function(){
           var url = "srMonitoring.do";
               var data = "";
               var target = "mainLayer";
               
               // 검색 조건 설정
               if($("#REG_STR_DT").val() != '' && $("#REG_STR_DT").val() != null){
             	  if($("#REG_END_DT").val() != '' && $("#REG_END_DT").val() != null){
	                 data = data +"&regStartDate="+ $("#REG_STR_DT").val() +"&regEndDate="+ $("#REG_END_DT").val();
            	   }
               }
               if($("#stSRDueDate").val() != '' && $("#stSRDueDate").val() != null){
                  data = data +"&stSRDueDate="+ $("#stSRDueDate").val();
               }
               if($("#endSRDueDate").val() != '' && $("#endSRDueDate").val() != null){
                   data = data +"&endSRDueDate="+ $("#endSRDueDate").val();
                }
               if($("#completionDT").val() != '' && $("#completionDT").val() != null){
                  data = data +"&completionDT="+ $("#completionDT").val();
               }
               if($("#srArea1").val() != '' && $("#srArea1").val() != null){
                  data = data +"&srArea1="+ $("#srArea1").val();
               }
               if($("#srArea2").val() != '' && $("#srArea2").val() != null){
                  data = data + "&srArea2=" + $("#srArea2").val();
               }
               if($("#category").val() != '' && $("#category").val() != null){
                  data = data + "&category=" + $("#category").val();
               }   
               if($("#subCategory").val() != '' && $("#subCategory").val() != null){
                  data = data + "&subCategory=" + $("#subCategory").val();
               }   
               if($("#requestTeam").val() != '' && $("#requestTeam").val() != null){
                  data = data + "&requestTeam=" + $("#requestTeam").val();
               }      
               if($("#srReceiptTeam").val() != '' && $("#srReceiptTeam").val() != null){
                  data = data + "&srReceiptTeam=" + $("#srReceiptTeam").val();
               }   
               if($("#receiptDelay").val() != '' && $("#receiptDelay").val() != null){
                  data = data + "&receiptDelay=" + $("#receiptDelay").val();
               }   
               if($("#completionDelay").val() != '' && $("#completionDelay").val() != null){
                  data = data + "&completionDelay=" + $("#completionDelay").val();
               }   
              if($("#srStatus").val() != '' && $("#srStatus").val() != null){
                  data = data + "&srStatus=" + $("#srStatus").val();
               }              
                if($("#requestUser").val() != '' && $("#requestUser").val() != null){
                  data = data + "&requestUserName=" + $("#requestUser").val();
               }
               if($("#regUser").val() != '' && $("#regUser").val() != null){
                  data = data + "&regUserName=" + $("#regUser").val();
               }
               if($("#receiptUser").val() != '' && $("#receiptUser").val() != null){
                  data = data + "&receiptUserName=" + $("#receiptUser").val();
               }
            
               ajaxPage(url, data, target);
      });
      $('#searchValue').keypress(function(onkey){
         if(onkey.keyCode == 13){
            doSearchList();
            return false;
         }
      });      
      
      $('#new').click(function(){ 
         fnRegistSR();
         return false;
      });   
      
//       $('#createSRCR').click(function(){ 
//          fnRegistSRCR();
//          return false;
//       });   

      if(srMode == "REG"){
         fnRegistSR();
      }else{
         gridInit();   
         doSearchList();
      }
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
   
   //===============================================================================
   // BEGIN ::: GRID
   function gridInit(){      
      var d = setGridData();
      p_gridArea = fnNewInitGrid("grdGridArea", d);
      p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
      p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");   
      p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});      
      p_gridArea.enablePaging(true,20,null,"pagingArea",true,"recInfoArea");
      p_gridArea.setPagingSkin("bricks");
      p_gridArea.setColumnHidden(0, true);      
      p_gridArea.setColumnHidden(12, true);
      p_gridArea.setColumnHidden(13, true);
      p_gridArea.setColumnHidden(14, true);
      p_gridArea.setColumnHidden(15, true);
      p_gridArea.setColumnHidden(16, true);
      p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
   }
   function setGridData(){
      var result = new Object();
      result.title = "${title}";
      result.key = "";
      result.header = "${menu.LN00024},SR No.,${menu.LN00002},${menu.LN00027},${menu.LN00026},${menu.LN00274},${menu.LN00185},SR${menu.LN00221},CR${menu.LN00221},SR${menu.LN00064},CR${menu.LN00064},${menu.LN00004},srID,ReceiptUserID,Status,ReceiptDelay,CompletionDelay";
      result.cols = "RNUM|SRCode|Subject|StatusName|SRArea1Name|SRArea2Name|ReqTeamNM|SRDueDate|CRDueDate|SRCompletionDT|CRCompletionDT|ReceiptName|SRID|ReceiptUserID|Status|ReceiptDelay|CompletionDelay";
      result.widths = "50,90,*,90,100,90,90,90,90,90,90,150,0";
      result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str";
      result.aligns = "left,left,left,center,center,center,center,center,center,center,center,center,center,center";
               
      return result;
   }
   
   function gridOnRowSelect(id, ind){
      var screenType = "${screenType}";
      var srCode = p_gridArea.cells(id, 1).getValue();
      var srID = p_gridArea.cells(id, 12).getValue();
      var receiptUserID = p_gridArea.cells(id, 13).getValue();
      var status = p_gridArea.cells(id, 14).getValue();
      var url = "processItsp.do?";
      var data = "srCode="+srCode+"&pageNum="+$("#currPage").val()
				+"&srMode=${srMode}&srType=${srType}&scrnType=${screenType}&srID="+srID
				+"&receiptUserID="+receiptUserID+"&status="+status+"&projectID=${projectID}&itemID="+itemID
				+"&isPopup=Y";
		var w = 1280;
		var h = 710;
		var spec = "width="+w+", height="+h+",top=100,left=100,toolbar=no,location=no,status=yes,resizable=yes,scrollbars=yes";
		var popup = window.open(url+data, '_blank', spec);
   }
   
   function doSearchList(){
      p_gridArea.enableRowspan();
      p_gridArea.enableColSpan(true);
      p_gridArea.loadXML("${root}" + "${xmlFilName}");
   }
   
   function fnRegistSR(){
      var url = "registSR.do";
      var target = "srListDiv";
      if(srMode == "REG"){srMode = "";}
      var data = "srType=ITSP&srMode="+srMode+"&screenType=${screenType}";
      ajaxPage(url, data, target);
   }
   
   function fnRegistSRCR(){
      var url = "registSRCR.do";
      var target = "srListDiv";
      var data = "srType=ITSP&srMode=${srMode}&screenType=${screenType}";
      ajaxPage(url, data, target);
   }
   
   function fnGetSRArea2(SRArea1ID){
      var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+SRArea1ID;
      fnSelect('srArea2', data, 'getSrArea2', '${srArea2}', 'Select');
   }
   
   function fnGetSubCategory(parentID){
      var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+parentID;
      fnSelect('subCategory', data, 'getESMSRCategory', '${subCategory}', 'Select','esm_SQL');
   }
   
   // 검색 조건 초기화 
   function fnClearSearchSR(){
      $("#srArea1").val("");
      $("#srArea2").val("");
      $("#category").val("");
      $("#subCategory").val("");
      $("#srStatus").val("");
      $("#REG_STR_DT").val("");
      $("#REG_END_DT").val("");
      $("#stSRDueDate").val("");
      $("#completionDT").val("");
      $("#requestTeam").val("");
      $("#srReceiptTeam").val("");
      $("#receiptDelay").val("");
      $("#completionDelay").val("");
      $("#requestUser").val("");
      $("#regUser").val("");
      $("#receiptUser").val("");

   }
   	
	//===============================================================================
	// BEGIN ::: EXCEL
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	// END ::: EXCEL
	//===============================================================================
   
</script>
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
<!-- <div id="srListDiv"> -->
	<div class="floatL mgT10 mgB12" style="width:100%">
		<h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;Service Request Monitoring</h3>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
			<col width="10%">
			<col width="23%">
			<col width="10%">
			<col width="23%">
			<col width="10%">
			<col width="24%">
	    </colgroup>
		<tr>
			<!-- 등록일-->
			<th class="alignL viewtop pdL10">${menu.LN00013}</th>
			<td class="alignL viewtop">
				<font><input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${beforeYmd}"   class="input_off datePicker stext" size="8"
			      style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10" >
				</font>
			   ~
			   <font><input type="text" id="REG_END_DT" name="REG_END_DT" value="${thisYmd}"   class="input_off datePicker stext" size="8"
			      style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10">
			   </font>
			 </td>
			   <!-- 완료예정일 -->
			<th class="alignL viewtop pdL10">${menu.LN00221}</th>
			<td class="alignL viewtop">
			    <font><input type="text" id="stSRDueDate" name=stSRDueDate value="${stSRDueDate}"   class="input_off datePicker stext" size="8"
			      style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10" >
			   </font>
			   ~
			<font><input type="text" id="endSRDueDate" name="endSRDueDate" value="${endSRDueDate}"	class="input_off datePicker stext" size="8"
				style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
			</font>
			</td>
			    <!-- 완료일 -->
			<th class="alignL viewtop pdL10">${menu.LN00064}</th>
			<td class="alignL viewtop">
			      <font><input type="text" id="completionDT" name="completionDT" value="${completionDT}" class="input_off datePicker stext" size="8"
			   style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"   maxlength="10" >
			   </font>
			</td>
		</tr>    
		<c:if test="${screenType != 'ITM' }" >
		<tr>
			<!-- 도메인 -->
			<th class="alignL pdL10">${menu.LN00274}</th>
			<td class="alignL">
			   <select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width:90%">
			      <option value=''>Select</option>
			   </select>
			</td>
			<!-- 시스템 -->
			<th class="alignL pdL10">${menu.LN00185}</th>
			<td class="alignL">
			 <select id="srArea2" Name="srArea2" style="width:90%">
			    <option value=''>Select</option>
			</select>
			</td>
			<!-- 요청조직 -->
			<th class="alignL pdL10">${menu.LN00026}</th>
			<td class= "alignL">
			    <select id="requestTeam" Name="requestTeam" style="width:90%">
		            <option value=''>Select</option>
		        </select>
		    </td>
		</tr>
		</c:if>
		<tr>
		    <!-- 카테고리 -->
		   <th class="alignL pdL10">${menu.LN00033}</th>
		   <td>
		      <select id="category" Name="category" OnChange="fnGetSubCategory(this.value);" style="width:90%">
		         <option value=''>Select</option>
		      </select>
		   </td>
		   <!-- 서브 카테고리 -->
		   <th class="alignL pdL10">${menu.LN00273}</th>
		   <td class="alignL">
		      <select id="subCategory" Name="subCategory" style="width:90%">
		          <option value=''>Select</option>
		      </select>
		   </td>
		   <!-- 접수조직 -->
		   <th class="alignL pdL10">${menu.LN00227}</th>
		   <td>
		      <select id="srReceiptTeam" Name="srReceiptTeam" style="width:90%">
		           <option value=''>Select</option>
		       </select>
		   </td>
		</tr>
		<tr>
			<!-- 접수지연 -->
			<th class="alignL pdL10">${menu.LN00278}</th>
			<td>
			<select id="receiptDelay" Name="receiptDelay" style="width:90%">
					<option value='' <c:if test="${'' == receiptDelay}">selected="selected"</c:if>>Select</option>
					<option value='Y' <c:if test="${'Y' == receiptDelay}">selected="selected"</c:if>>Yes</option>
					<option value='N' <c:if test="${'N' == receiptDelay}">selected="selected"</c:if>>No</option>
			    </select>				
			</td>
			<!-- 처리지연-->
			<th class="alignL pdL10">${menu.LN00279}</th>
			<td>
			<select id="completionDelay" Name="completionDelay" style="width:90%">
					<option value='' <c:if test="${'' == completionDelay}">selected="selected"</c:if>>Select</option>
					<option value='Y' <c:if test="${'Y' == completionDelay}">selected="selected"</c:if>>Yes</option>
					<option value='N' <c:if test="${'N' == completionDelay}">selected="selected"</c:if>>No</option>
				</select>
			   
			</td> 
			<!-- 상태 -->
			<th class="alignL pdL10">${menu.LN00027}</th>
			<td>
				<select id="srStatus" Name="srStatus" style="width:90%">
					<option value=''>Select</option>
				</select>
			</td>
		</tr>
    </table>
	<div class="countList pdT5" >
        <li class="count">Total ${srCnt}<span id="TOT_CNT_"></span></li>
        <li class="floatR">
              &nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search"/>
           <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearchSR();" >
		   <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
	</div>
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular">
		<div id="pagingArea" style="display:inline-block;"></div>
	   <div id="recinfoArea" class="floatL pdL10"></div>
	</div>
<!-- </div> -->