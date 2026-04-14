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
<script src="${root}cmm/js/hangul.js" type="text/javascript"></script>
<style>
	.ui-autocomplete {
	    max-height: 110px;
	    overflow-y: auto;
        border-radius: 0;
    	border-color: #ccc;
	}
</style>
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
// 	        focus : function(event, ui) {    //포커스 가면
// 	            return false;//한글 에러 잡기용도로 사용됨
// 	        },
	        minLength: 2,// 최소 글자수
// 	        autoFocus: true, //첫번째 항목 자동 포커스 기본값 false
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
	
	function autoCompMbrNM(id, callBackFunc){
		$.ajax({
			type : 'get',
			url : "/getAutoMbrNMLIst.do",
			dataType : "json",
			success : function(data) {
				let source = $.map(data, function(item) {
					chosung = "";
					Hangul.d(item.Name, true).forEach(function(strItem, index) {
						if(strItem[0] != " "){
							chosung += strItem[0];
						}
					});
					return {
						label : chosung + "|" +item.Name,
						value : item.Name,
						chosung : chosung,
						memberID : item.MemberID,
						teamName : item.TeamName,
						position : item.Position,
						companyName : item.CompanyName,
						email : item.Email
					}
				});

				let firstIndex;
				let lastIndex;
				$("#"+id).autocomplete({
					source : function(request, response) {
				        var results = $.ui.autocomplete.filter(source, request.term);        
				        response(results.slice(0, 100)); // slice 두번째 파라미터가 limit 값
				    },
					focus : function(event, ui) {
						return false;
					},
					select: function( event, ui ) {						
						callBackFunc(ui.item.memberID, ui.item.value);
						$(this).blur();
					}
				})
				.on('focus',function(){$(this).autocomplete("search", $(this).val());})
				.data( "ui-autocomplete" )._renderItem = function( ul, item) {
					if(44032 <= this.term.toLowerCase().charCodeAt() && this.term.toLowerCase().charCodeAt() <= 55203) {
						firstIndex = item.value.indexOf(this.term);
						lastIndex = item.value.lastIndexOf(this.term);
					} else {
						firstIndex = item.chosung.toLowerCase().indexOf(this.term);
						lastIndex = item.chosung.toLowerCase().lastIndexOf(this.term);
					}
					
					if(firstIndex === lastIndex) {
						lastIndex = firstIndex + this.term.length-1;
					}
					
					let result = [...item.value].map((e,i) => {
						if(firstIndex <= i && i <= lastIndex) {
			                return "<span style='font-weight:bold;color:#157efb;'>"+e+"</span>"
			            } else {
			                return e
			            }
			        }).join("");
					
					let returnElement = '<a class="box">'
						+ '<span class="thumb">'
					   	+ '	<span lang="ko" class="initial_profile" style="background-color: rgb(134, 164, 212);">'
					    + '		<em>'+item.value.substring(0,1)+'</em>'
					    + '	</span>'
					    + '</span>'
					    + '<span class="address_item_info">'
					    + '	<span class="name_info">'
					    + '		<span class="name_txt">'
					    + '			<span class="name">'+result+'</span>'
					    + '		</span>'
					    + '	</span>'
					    + '	<p class="company_info">'
					    + '		<span>'
					    + '			<strong>'+item.position+'</strong>'
					    + '			<span>'+item.teamName+'</span>'
					    + '			<span>'+item.companyName+'</span>'
					    + '			<span>'+item.email+'</span>'
					    + '		</span>'
					    + '	</p>'
					    + '</span>'
						+'</a></li>';
					
			        
			      return $( "<li class='mem_list' style='cursor:pointer;'>" )
			        .append(returnElement)
// .append("<a>"+ result + " | " + item.teamName + "</a></li>")
			    	.appendTo( ul );
			    };
			}
		});
	}
</script>