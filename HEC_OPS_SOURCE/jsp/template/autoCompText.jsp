<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<%--------------------------------------------------------------------------------
                              IMPORT / INCLUDE JAVASCRIPT, CSS
---------------------------------------------------------------------------------%>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="${root}cmm/js/jquery/ui/jquery-ui-1.10.3.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery-ui-1.10.3.css"/> 

<script>
	function autoComplete(id, attrTypeCode, itemTypeCode, itemClassCode, sessionCurrLangUse, searchListCnt, position){
		//if(attrTypeCode == ''){ attrTypeCode = "AT00001" } 
		if(sessionCurrLangUse == ''){ sessionCurrLangUse = "F" } 
		if(searchListCnt == ''){ searchListCnt = 5 } 
		if(position == ''){ position = "bottom";}
		
		$("#"+id).autocomplete({
	        source : function( request, response ) {
	             $.ajax({
	                    type: 'get',
	                    url: "/getAutoCompText.do",
	                    dataType: "json",
	                    data: {
	                    	"searchValue" : request.term,
	                    	"attrTypeCode" : attrTypeCode,
	                    	"itemTypeCode" : itemTypeCode,
	                    	"itemClassCode" : itemClassCode,
	                    	"sessionCurrLangUse" : sessionCurrLangUse,
	                    	"searchListCnt" : searchListCnt
	                    },
	                    success: function(data) {
	                    	
	                        //서버에서 json 데이터 response 후 목록에 추가
	                        response(
	                            $.map(data, function(item) {    //json[i] 번째 에 있는게 item 임.
	                                return {
	                                	label: item.label.toLowerCase().replace(request.term.toLowerCase(),"<span style='font-weight:bold;color:Blue;'>" + request.term.toLowerCase() + "</span>"),
	                                    value: unescape(item.value),
	                                }
	                            })
	                        );
	                    }
	               });
	            },    // source 는 자동 완성 대상
	        select : function(event, ui) {    //아이템 선택시
	            ui.item.value = unescape(ui.item.value);
	        },
	        focus : function(event, ui) {    //포커스 가면
	            return false;//한글 에러 잡기용도로 사용됨
	        },
	        minLength: 2,// 최소 글자수
	        autoFocus: true, //첫번째 항목 자동 포커스 기본값 false
	        classes: {    //잘 모르겠음
	            "ui-autocomplete": "highlight"
	        },
	        delay: 100,    //검색창에 글자 써지고 나서 autocomplete 창 뜰 때 까지 딜레이 시간(ms)
	        position: { my : "left " + position, at: "left bottom" },
	        close : function(event){    //자동완성창 닫아질때 호출
	        }
	        
	    }).data('uiAutocomplete')._renderItem = function( ul, item ) {
	        return $( "<li style='cursor:hand; cursor:pointer;'></li>" )
	        .data( "item.autocomplete", item )
	        .append("<a>"+ unescape(item.label) + "</a>")
	    .appendTo( ul );
		};
	}
</script>