<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007" arguments="ID" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00081" var="WM00081" />

<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	
	<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
	<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
	<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
	<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
	
	<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
	<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
	<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>
	
	<script>
		
		// 공통 사용
		var languageID = `${languageID}`;
		var s_itemID = `${s_itemID}`;
		var changeSetID = `${changeSetID}`;
		var papagoTrans = `${papagoTrans}`;
		var gptAITrans = `${gptAITrans}`;
		var autoID = `${autoID}`;
		
		// 현재 날짜
		let today = new Date();
		today = today.getFullYear() +
		'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
		'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) );
		
		
		// html 렌더링
		renderProcessInfo();
		renderItemAttrList();
		
		
		/**
	   	* @function renderProcessInfo
	   	* @description 아이템 기본 정보를 api를 통해 가져온 후 html 렌더링 합니다.
	  	*/
		async function renderProcessInfo() {
			
			try {
		        // 1. 아이템 기본정보 불러오기
		        const processInfo = await getProcessInfo();
		        if (!processInfo || processInfo.length === 0) {
		            return;
		        }
		        
		        const info = processInfo[0];
		        
		    	// 저장에 필요한 요소에 processInfo의 데이터를 할당
		        const csrID = document.getElementById("csrID");
		        const authorID = document.getElementById("AuthorID");
		        const ownerTeamCode = document.getElementById("ownerTeamCode");
				
		        if (info) {
		            if (csrID) csrID.value = info.ProjectID || '';
		            if (authorID) authorID.value = info.AuthorID || '';
		            if (ownerTeamCode) ownerTeamCode.value = info.OwnerTeamID || '';
		        }
		        
		        
		        // html 렌더링 요소 준비
		        const table = document.getElementById("processInfo");
		        
		        // option
		        const isAutoID = autoID === "Y" ? "disabled" : "";
		        
		        // class option 제작
		        const classOptions = await getClassOptions(info.ItemTypeCode);
		        let optionsHtml = '';
		        if (Array.isArray(classOptions) && classOptions.length > 0) {
		            optionsHtml = classOptions.map(i => {
		                const isSelected = (info && info.ClassCode === i.ItemClassCode) ? 'selected="selected"' : '';
		                return `<option value="\${i.ItemClassCode}" \${isSelected}>\${i.Name}</option>`;
		            }).join('');
		        }
		        
		        // html 셋팅
		        let html = `
		            <colgroup>
		                <col width="12%">
		                <col width="16%">
		                <col width="12%">
		                <col width="32%">
		                <col width="12%">
		                <col width="16%">                
		            </colgroup>
		            <tbody>
		                <tr>
		                    <th class="viewtop">${menu.LN00106}</th>
		                    <td class="viewtop pdL5 pdR5">
		                        <input type="text" class="text" id="Identifier" name="Identifier" value="\${info.Identifier || ''}" ${isAutoID} />
		                    </td>
		                    
		                    <th class="viewtop">${menu.LN00028}</th>
		                    <td class="viewtop pdL5 pdR5">
		                        <input type="text" class="text" id="AT00001" name="AT00001" value="\${info.ItemName || ''}" />
		                    </td>
		                    
		                    <th class="viewtop">${menu.LN00016}</th>
		                    <td class="viewtop">
		                        <select id="ClassCode" name="ClassCode" class="sel">
		                            \${optionsHtml}
		                        </select>
		                    </td>
		                </tr>
		            </tbody>
		        `;
				
				if (table) {
					table.innerHTML = html;
				}

		    } catch (error) {
		        console.error("ProcessInfo 가공 중 오류 발생:", error);
		        return;
		    }
			
		}
		
		/**
	   	* @function renderItemAttrList
	   	* @description 아이템 attr 정보를 api를 통해 가져온 후 html 렌더링 합니다.
	  	*/
		async function renderItemAttrList() {
			
			try {
		        // 1. 아이템 기본정보 불러오기
		        const attrList = await getItemAttrList();
		        if (!attrList || attrList.length === 0) {
		            return;
		        }
		        
		        // html 셋팅
		        const table = document.getElementById("attr");
		       	const tbody = document.createElement("tbody");
				
				// 1. attrList 가공 
				// 1-1. invisible 비활성화
				const filteredList = attrList.filter(item => String(item.invisible) !== "1");
		        
				// 1-2. 중복된 attr 항목의 값 , 로 구분
				const reduceAttrList = filteredList
					.reduce((acc, current) => {
			        // 동일한 attr 항목 ,로 구분
			        const existingItem = acc.find(item => item.Name === current.Name);
			        
			        if (existingItem) {
			            if (current.PlainText) {
			                existingItem.PlainText += ", " + current.PlainText;
			            }
			        } else {
			            acc.push({ ...current });
			        }
			        return acc;
			    }, []);
				
				// 2. RowNum 기준으로 데이터 정렬 및 그룹화
				const rowsMap = reduceAttrList.reduce((acc, item) => {
				    const rowNum = item.RowNum || 0; // RowNum이 없으면 0으로 처리
				    if (!acc[rowNum]) {
				        acc[rowNum] = [];
				    }
				    acc[rowNum].push(item);
				    return acc;
				}, {});

				// 3. RowNum 숫자 순서대로 정렬된 키 배열 생성
				const sortedRowKeys = Object.keys(rowsMap).sort((a, b) => Number(a) - Number(b));
				
				// 4. 테이블 생성 로직
				for (const rowKey of sortedRowKeys) {
				    const rowItems = rowsMap[rowKey]; // 같은 RowNum을 가진 아이템 리스트
				    const currentRow = document.createElement('tr');
				    
				    // 해당 행의 높이는 포함된 아이템 중 가장 큰 AreaHeight를 사용하거나 첫 번째 아이템 기준
				    const maxHeight = Math.max(...rowItems.map(i => i.AreaHeight || 20));
				    currentRow.style.height = maxHeight + "px";
				    tbody.appendChild(currentRow);
				    
				    for (const item of rowItems) {
				    	
				    	// item option
				    	const dataType = item.DataType;
				    	const isHtml = String(item.HTML).trim() == "1";
				    	
				    	// edit option
				    	const editable = item.Editable;
				        const readOnlyAttr = (editable === '0') ? ' readonly="readonly" ' : '';
				    	
				    	let content = item.PlainText == "" || item.PlainText === undefined ? item.DefaultValue ? item.DefValue : "" : item.PlainText;
				    	let dateValue = item.PlainText == "" || item.PlainText === undefined ? "" : item.PlainText;
				    	
				        // th (속성명)
				        const th = document.createElement('th');
				        th.style.width = "12%";
				        
				     	// Mandatory 처리
				        if(item.Mandatory == '1') th.innerHTML = '<p style="display:inline;color:#FF0000;">*</p>' + item.Name;
				        else th.innerText = item.Name;
				     	
				     	// trans 번역 버튼
				     	if(dataType === 'Text' && papagoTrans === 'Y' && isHtml !== '1'){
				     		const papagoBtn = document.createElement('button');
				     		papagoBtn.innerText = 'Translate';
				     	    papagoBtn.onclick = function() {
				     	        fnOpenPapagoTrans(item.AttrTypeCode, item.HTML);
				     	    };
				     	    th.appendChild(papagoBtn);
				     	}
						if(dataType === 'Text' && gptAITrans === 'Y' && isHtml !== '1'){
							const gptBtn = document.createElement('button');
						    gptBtn.innerText = 'Translate';
						    gptBtn.onclick = function() {
						        fnOpenGPTAITrans(item.AttrTypeCode, item.HTML);
						    };
						    th.appendChild(gptBtn);
				     	}
				     	
				        currentRow.appendChild(th);

				        // td (값)
				        const td = document.createElement('td');
				        td.classList.add('alignL', 'pdL10');
				        let tdContent = '';
				        
				        // dataType : Text
				        if(dataType === 'Text'){
				        	// HTML 처리
					        if (isHtml) {
					        	tdContent += '<div style="width:100%; height:'+item.AreaHeight+'px;" class="pd0">';
					        	tdContent += '<textarea class="tinymceText" name="'+item.AttrTypeCode+'" id="'+item.AttrTypeCode+'" ' +readOnlyAttr+ '>'+content+'</textarea>';
					        	tdContent += '</div>';
					        	tdContent = decodeHtml(tdContent);
					        } else {
				        		tdContent = '<textarea class="edit" name="'+item.AttrTypeCode+'" id="'+item.AttrTypeCode+'" style="height:'+item.AreaHeight+'px;" ' +readOnlyAttr+ '>'+content+'</textarea>';
					            td.style.whiteSpace = "pre-wrap";
				        	}
				        }
						// dataType : ''
						if(dataType === ''){
							// HTML 처리
					        if (isHtml) {
					        	tdContent += '<div style="width:100%; height:'+item.AreaHeight+'px;" class="pd0">';
					        	tdContent += '<textarea class="tinymceText" name="'+item.AttrTypeCode+'" id="'+item.AttrTypeCode+'" ' +readOnlyAttr+ '>'+content+'</textarea>';
					        	tdContent += '</div>';
					        	tdContent = decodeHtml(tdContent);
					        } else {
					        	tdContent = '<input type="text" id="'+item.AttrTypeCode+'" name="'+item.AttrTypeCode+'" value="'+content+'" class="text" ' +readOnlyAttr+ ' />';
					            td.style.whiteSpace = "pre-wrap";
				        	}
				        }
						// dataType : 'Number'
						if(dataType === 'Number'){
							
							let numContent = (content !== null && content !== '') ? Number(content) : '';
							if (isNaN(numContent)) {
								numContent = ''; 
						    }
							
							tdContent = '<input type="number" id="'+item.AttrTypeCode+'" name="'+item.AttrTypeCode+'" value="'+numContent+'" class="text" ' +readOnlyAttr+ ' />';
				            td.style.whiteSpace = "pre-wrap";
				        }
						// dataType : 'LOV'
						if(dataType === 'LOV'){
							tdContent = await getAttrLovList(item.AttrTypeCode,item.LovCode,item.Mandatory, item.DefValue,item.Style,item.VarFilter, editable);
				        }
						// dataType : 'MLOV'
						if(dataType === 'MLOV'){
							tdContent = await getAttrMlovList(item.AttrTypeCode,item.Mandatory, item.DefValue, editable);
				        }
						// dataType : 'Date'
						if(dataType === 'Date'){
							// Date 의 기본값이 today일 경우 오늘날짜 입력
							if((dateValue === "" || dateValue === null || dateValue === undefined ) && item.DefValue == "today"){
								dateValue = today;
							} else {
								if(content) content = content.substring(0, 10);
								dateValue = content;
							}
							
							tdContent += '<input type="text" id="'+item.AttrTypeCode+'" name="'+item.AttrTypeCode+'" value="'+dateValue+'" class="input_off datePicker text" size="8" style="width: 120px;" onchange="checkPositiveValueDate(this,  '+(item.CtrlType || "''")+', \''+item.Name+'\')" maxlength="10" ' +readOnlyAttr+ ' >';
				        }
						// dataType : 'Time'
						if(dataType === 'Time'){
							// Date 의 기본값이 today일 경우 오늘날짜 입력
							if((dateValue === "" || dateValue === null || dateValue === undefined ) && item.DefValue == "today"){
								dateValue = today + ' ' + getCurrentTime();
							} else dateValue = content;
							
							// date + time 통합
							tdContent += '<input type="text" style="width:180px!important;" id="'+item.AttrTypeCode+'" name="'+item.AttrTypeCode+'" class="mgL5 timePicker input_off text ui-timepicker-input" size="20" maxlength="20" value="' + dateValue + '" autocomplete="off" ' +readOnlyAttr+ ' >';
				        }
				        
				        // dataType별 셋팅 값 넣어주기
						td.innerHTML = tdContent;

				        // ColumnNum에 따른 colspan 처리
				        // rowItems 개수가 1개뿐이거나 ColumnNum이 0이면 colspan 적용
				        if (item.ColumnNum === 0 || rowItems.length === 1) {
				            td.colSpan = 3; 
				        } else {
				            td.style.width = "38%";
				        }
				        
				        currentRow.appendChild(td);
				    };
				};
				
				
				if (table) {
				    table.appendChild(tbody);
				    
				    // datePicker 초기화
				    initDynamicCalendar(tbody);
				    // timePicker 초기화
				    initDynamicDateTimePicker(tbody);
				    
				    //subAttr 초기화
				    attrList.forEach(item => {
				        if (item.VarFilter) {
				            const currentValue = item.LovCode || item.DefValue || "";
				            fnGetSubAttrTypeCode(item.VarFilter, currentValue, item.AttrTypeCode);
				        }
				    });
				}
				
				// 새 스크립트 요소 생성
			    
				const script = document.createElement('script');
			    script.type = 'text/javascript';
			    script.src = '<c:url value="/cmm/js/xbolt/tinyEditorHelper.js"/>';
			    
			    document.body.appendChild(script);
			    

		    } catch (error) {
		        console.error("itemAttrList 가공 중 오류 발생:", error);
		        return;
		    }
			
		}
		
		/**
	   	* @function getCurrentTime
	   	* @description 현재 시간을 return 합니다.
	   	* @returns {String} 현재 시간
	  	*/
		function getCurrentTime() {
		    const now = new Date();
		    const hours = String(now.getHours()).padStart(2, '0');
		    const minutes = String(now.getMinutes()).padStart(2, '0');
		    return hours + ':' + minutes;
		}
		
		/**
	   	* @function decodeHtml
	   	* @param {String} html
	   	* @description HTML 엔티티(&lt; 등)를 실제 태그(< 등)로 변환합니다.
	   	* @returns {String} 변환된 html
	  	*/
		function decodeHtml(html) {
		    const txt = document.createElement("textarea");
		    txt.innerHTML = html;
		    return txt.value;
		}
	   	
	   	/**
	   	* @function checkPositiveValueDate
	   	* @param {inputElement} inputElement 체크할 element
	   	* @param {String} ctrlType 1인 경우 현재 기준으로 미래 날짜만 가능
	   	* @param {String} name attr 명
	   	* @description date type의 input값의 데이터 정합성을 체크합니다.
	  	*/
	   	function checkPositiveValueDate(inputElement, ctrlType, name){
	   		inputElement.value = makeDateType(inputElement.value);
			if(ctrlType == "1"){
				// 현재 기준으로 미래 날짜만 가능
				if(inputElement.value < today) {
					getDicData("ERRTP", "LN0005").then(data => alert(name + data.LABEL_NM));
					inputElement.value = '';
				};
			}
		}
	   	
	   	/**
	   	* @function getProcessInfo
	   	* @description 아이템 기본 정보를 api를 통해 return 합니다.
	   	* @returns {Array} 아이템 기본 정보
	  	*/
		async function getProcessInfo() {

	   		const sqlID = 'report_SQL.getItemInfo'; 
	   		const sqlGridList = 'N';
	   	    const requestData = { languageID, s_itemID, sqlID, sqlGridList };
	   	    const params = new URLSearchParams(requestData).toString();
	   	    const url = "getData.do?" + params;
	   	    
			try {
				const response = await fetch(url, { method: 'GET' });
				
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(result.message, result.status);
				}

				const result = await response.json();
				// success 필드 체크
				if (!result.success) {
					throw throwServerError(result.message, result.status);
				}

				if (result && result.data) {
					return result.data;
				} else {
					return [];
				}

			} catch (error) {
				handleAjaxError(error);
			}
		}
	   	/**
	   	* @function getItemAttrList
	   	* @description 아이템 attr 정보를 api를 통해 return 합니다.
	   	* @returns {Array} 아이템 attrList
	  	*/
		async function getItemAttrList() {

			const requestData = { languageID, s_itemID, accMode, changeSetID, showInvisible };
			const params = new URLSearchParams(requestData).toString();
			const url = "getItemAttrList.do?" + params;
			try {
				const response = await fetch(url, { method: 'GET' });
				
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(result.message, result.status);
				}

				const result = await response.json();
				// success 필드 체크
				if (!result.success) {
					throw throwServerError(result.message, result.status);
				}

				if (result && result.data) {
					return result.data;
				} else {
					return [];
				}

			} catch (error) {
				handleAjaxError(error);
			}
		}
	   	
		/**
	   	* @function getAttrMLovList
	   	* @param {String} attrTypeCode
	   	* @param {Number} Mandatory 필수 여부 ( 1 : 필수 )
	   	* @param {String} defaultValue 디폴트값
	   	* @description api를 통해 해당 attrTypeCode의 MLOV List를 가져오고 html 렌더링 합니다. 
	   	* @return {String} 렌더링한 html 태그
	  	*/
	   	async function getAttrMlovList(attrTypeCode, mandatory, defaultValue, editable){
			
			const sqlID = 'attr_SQL.getMLovListWidthItemAttr';
			const sqlGridList = 'N';
			const requestData = { attrTypeCode, itemID : s_itemID, languageID, defaultLang : languageID, sqlID, sqlGridList };
			
			const params = new URLSearchParams(requestData).toString();
			const url = "getData.do?" + params;
			try {
				const response = await fetch(url, { method: 'GET' });
				
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(result.message, result.status);
				}

				const result = await response.json();
				// success 필드 체크
				if (!result.success) {
					throw throwServerError(result.message, result.status);
				}

				if (result && result.data) {
					
					return lovCheckbox(result.data, attrTypeCode, defaultValue, editable);
					
				} else {
					return '';
				}

			} catch (error) {
				handleAjaxError(error);
			}
		}
	   	
	   	/**
	   	* @function getAttrLovList
	   	* @param {String} attrTypeCode
	   	* @param {String} val 초기에 셋팅되고자 하는 값
	   	* @param {Number} mandatory 필수 여부
	   	* @param {String} defaultValue 디폴트값
	   	* @param {String} style 스타일 ( radio / 그 외엔 select )
	   	* @param {String} varFilter
	   	* @description api를 통해 해당 attrTypeCode의 LOV List를 가져오고 html 렌더링 합니다. 
	   	* @return {String} 렌더링한 html 태그
	  	*/
	   	async function getAttrLovList(attrTypeCode, val, mandatory, defaultValue, style, varFilter, editable){
			
	   		let value = val;              
	   	 	// 기본 선택값이 없으면 디폴트값 설정
			if(value == "") value = defaultValue;
			// "select" 일 경우 선택, "true" 일 경우 전체로 표시
			const isAll  = mandatory == "" || attrTypeCode == "NULL" ? "true" : "false"; 
			
			const sqlID = 'attr_SQL.selectAttrLovOption';
			const sqlGridList = 'N';
			const requestData = { s_itemID : attrTypeCode, languageID, sqlID, sqlGridList };
			
			const params = new URLSearchParams(requestData).toString();
			const url = "getData.do?" + params;
			try {
				const response = await fetch(url, { method: 'GET' });
				
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(result.message, result.status);
				}

				const result = await response.json();
				// success 필드 체크
				if (!result.success) {
					throw throwServerError(result.message, result.status);
				}

				if (result && result.data) {
					
					const html = (style === "radio") 
				    ? lovRadio(result.data, attrTypeCode, value, varFilter, editable) 
				    : lovSelect(result.data, attrTypeCode, value, isAll, varFilter, editable);
					
					return html;
					
				} else {
					return '';
				}

			} catch (error) {
				handleAjaxError(error);
			}
		}
	   	
	   	/**
	   	* @function lovRadio
	   	* @param {Array} data 선택 가능한 값 리스트
	   	* @param {String} attrTypeCode
	   	* @param {String} value 초기에 셋팅되고자 하는 값
	   	* @param {String} varFilter
	   	* @description data를 통해 html radio 태그로 렌더링 합니다.
	  	*/
		function lovRadio(data, attrTypeCode, value, varFilter, editable) {
			let lovHtml = "";
			const disabledAttr = (editable === '0') ? ' disabled="disabled" ' : '';
			
			// targetAttrType 스타일 초기화
			let obj = {};
			if(varFilter) varFilter.split("&").filter(e => e).forEach(e => obj[e.split("=")[0]] = e.split("=")[1]);
			
			for(var i=0; i < data.length; i++) {
				lovHtml += '<input type="radio" id="'+data[i].AttrTypeCode+data[i].CODE+'" name="'+data[i].AttrTypeCode+'" value="'+data[i].CODE+'" onChange="fnGetSubAttrTypeCode(\''+(varFilter || '' )+'\',this.value,\'\',\''+attrTypeCode+'\')"' + disabledAttr;
				
				// value 가 있을 경우,
				if(value && data[i].CODE === value) lovHtml += ' checked />';
				// value와 defaultValue 모두 없을 경우
				else if(!value && i == 0) lovHtml += ' checked />';
				else lovHtml += ' />';
				lovHtml += '<label for="'+data[i].AttrTypeCode+data[i].CODE+'">'+data[i].NAME+'</label>';
				
				// targetAttrType 스타일 초기화
				let actionValue = '';
				if(obj.actionValue){
					actionValue = obj.actionValue.split('?');
				}
				
				// targetAttrType 존재할 경우 subAttr 호출
				if(actionValue.includes(data[i].CODE)){
					fnGetSubAttrTypeCode(varFilter, value, attrTypeCode);
				}
				
			}
			
			// targetAttrType 스타일 초기화
			//fnGetSubAttrTypeCode(varFilter, value, attrTypeCode);
			
			return lovHtml;
		}
	   	
	   	/**
	   	* @function lovSelect
	   	* @param {Array} data 선택 가능한 값 리스트
	   	* @param {String} attrTypeCode
	   	* @param {String} value 초기에 셋팅되고자 하는 값
	   	* @param {String} varFilter
	   	* @description data를 통해 html select 태그로 렌더링 합니다.
	  	*/
		function lovSelect(data, attrTypeCode, value, isAll, varFilter, editable) {
			
	   		const disabledAttr = (editable === '0') ? ' disabled="disabled" ' : '';
	   		let lovHtml = '<select id="'+attrTypeCode+'" name="'+attrTypeCode+'"  class="sel" OnChange="fnGetSubAttrTypeCode(\''+(varFilter || '')+'\',this.value,\''+attrTypeCode+'\')"'+disabledAttr+'>';
			
			if(isAll) lovHtml += '<option value="">Select</option>';

			// targetAttrType 스타일 초기화
			let obj = {};
			if(varFilter) varFilter.split("&").filter(e => e).forEach(e => obj[e.split("=")[0]] = e.split("=")[1]);
			
			for(var i=0; i < data.length; i++) {
				lovHtml += '<option value="'+data[i].CODE+'"';
				
				// value 가 있을 경우,
				if(value && data[i].CODE === value) lovHtml += ' selected';
				lovHtml += '>'+data[i].NAME+'</option>';
				
				// targetAttrType 스타일 초기화
				let actionValue = '';
				if(obj.actionValue){
					actionValue = obj.actionValue.split('?');
				}
				
				// targetAttrType 존재할 경우 subAttr 호출
				if(actionValue.includes(data[i].CODE)){
					fnGetSubAttrTypeCode(varFilter, value, attrTypeCode);
				}
			}
			lovHtml += '</select>';
			
			return lovHtml;
		}
	   	
	   	/**
	   	* @function lovCheckbox
	   	* @param {Array} data 선택 가능한 값 리스트
	   	* @param {String} attrTypeCode
	   	* @param {String} defaultValue 선택 값 없을 시 default값 
	   	* @description data를 통해 html radio 태그로 렌더링 합니다.
	  	*/
		function lovCheckbox(data, attrTypeCode, defaultValue, editable) {
	   		
	   		const defValue = defaultValue ? String(defaultValue).split(',') : [];
	   		
	   		let lovHtml = "";
			const disabledAttr = (editable === '0') ? ' disabled="disabled" ' : '';
			
			// 기존 값 있는지 체크
			const matchedLovCodes = data
	        .filter(item => item.LovCode && item.LovCode === item.CODE)
	        .map(item => item.CODE);
			
			// 기존 값 있으면 해당 값 체크, 없으면 defaultValue 선택
			const selectedValues = (matchedLovCodes.length > 0) ? matchedLovCodes : defValue;
			
			for(var i=0; i < data.length; i++) {
				
				const item = data[i];
		        const fullID = item.AttrTypeCode + item.CODE;
		        
		        const isChecked = selectedValues.includes(item.CODE) ? ' checked="checked"' : '';
		        
		        lovHtml += `
		            <input type="checkbox" 
		                   class="mlov-item" 
		                   data-attr-code="\${item.AttrTypeCode}" 
		                   id="\${fullID}" 
		                   name="\${fullID}" 
		                   value="\${item.CODE}" 
		                   \${disabledAttr} \${isChecked} />
		            <label for="\${fullID}" class="mgR10">\${item.NAME}</label>
		        `;
		        
			}
			
			return lovHtml;
		}
	   	
	   	/**
	   	* @function fnGetSubAttrTypeCode
	   	* @param {String} varFilter [ ex : &actionValue=02&targetAttrType=SRAT0076 / actionValue 는 해당 attrTypeCode 에서 subAttr 을 호출할 값 , targetAttrType 는 subAttrTypeCode ]
	   	* @param {String} value
	   	* @param {String} attrTypeCode
	   	* @description subAttrType input을 활성화/비활성화 합니다.
	  	*/
	  	let extraManList = [];
	  	let defObjValue = [];
		function fnGetSubAttrTypeCode(varFilter, value, attrTypeCode){
			
			if (!varFilter) return;
			
			// 1. 설정값 파싱
			const obj = {};
		    varFilter.split("&").filter(Boolean).forEach(e => {
		        const [k, v] = e.split("=");
		        obj[k] = v;
		    });
			// obj 예시 : { targetAttrType: "SRAT0076", actionValue: "02" }
		    
			// 2. 타겟 attrType 확인 및 요소 찾기 ( id 없으면 name 으로 )
			const targetType = obj.targetAttrType;
    		if (!targetType) return;
    		
    		let el = document.getElementById(targetType) || document.querySelector(`[name="\${targetType}"]`);
    	    if (!el) return;
    	    
    	 	// 3. 그룹 요소 선택자 생성 (에러 방지용)
    	    const targetName = el.getAttribute("name") || targetType;
    	    const selector = [
    	        `input[name="\${targetName}"]`,
    	        `select[name="\${targetName}"]`,
    	        `textarea[name="\${targetName}"]`,
    	        `#\${targetType}`
    	    ].join(", ");
    	    const allInGroup = document.querySelectorAll(selector);
			
    	 	// 4. 현재 값 추출
    	    const getCurrentValue = (target) => {
    	    	console.log(target);
    	        const tag = target.tagName.toUpperCase();
    	        const type = (target.type || "").toLowerCase();
				
    	        if(tag === 'SELECT') {
    	        	return target.value;
    	        } else if (type === "radio" || type === "checkbox") {
    	            const checked = document.querySelectorAll(`input[name="\${targetName}"]:checked`);
    	            return Array.from(checked).map(i => i.value).join(",");
    	        } else {
    	        	return target.value || target.textContent || "";
    	        }
    	    };
    	    
    	    let elValue = getCurrentValue(el);
    	    
    	 	// 5. 기본값 백업 (중복 방지)
    	    if (elValue && !defObjValue.some(d => d.attrTypeCode === attrTypeCode)) {
    	        defObjValue.push({ attrTypeCode, defaultValue: elValue });
    	    }
    	 	
    	 	// 6. 상태 제어 (actionValue 확인)
    	    const actionValues = obj.actionValue ? obj.actionValue.split('?') : [];
    	    const isActive = actionValues.includes(value);
    	    const parentLabel = el.parentNode?.previousElementSibling;
    	 	
    	    allInGroup.forEach(target => {
    	        if (isActive) {
    	            // 활성화 상태
    	            target.readOnly = false;
    	            target.disabled = false;
    	            target.classList.add("edit");
    	            target.style.pointerEvents = "auto";
    	            target.style.backgroundColor = "";
    	        } else {
    	            // 비활성화 상태
    	            target.readOnly = true;
    	            target.disabled = true;
    	            target.classList.remove("edit");
    	            target.style.pointerEvents = "none";
    	            target.style.backgroundColor = "#f5f5f5";
    	            
    	            if (target.type === "radio" || target.type === "checkbox") target.checked = false;
    	            else target.value = "";
    	        }
    	    });
    	    
    	 	// 7. 후속 처리 (활성화 시 값 복원 및 필수 표시)
    	    if (isActive) {
    	        // 값 복원 로직
    	        let finalValue = elValue || defObjValue.find(d => d.attrTypeCode === attrTypeCode)?.defaultValue;
    	        console.log("finalValue : " + finalValue);
    	        if (finalValue) {
    	            const valArray = finalValue.split(",");
    	            allInGroup.forEach(target => {
    	                if (target.type === "radio" || target.type === "checkbox") {
    	                    target.checked = valArray.includes(target.value);
    	                } else {
    	                    target.value = finalValue;
    	                }
    	            });
    	        }

    	        // 필수 표시(*) 추가
    	        if (parentLabel && !parentLabel.querySelector(".req-star")) {
    	            parentLabel.insertAdjacentHTML("afterbegin", "<p class='req-star' style='display:inline;color:#FF0000;'>*</p>");
    	        }

    	        if (!extraManList.includes(targetType)) extraManList.push(targetType);

    	    } else {
    	        // 필수 표시(*) 제거
    	        if (parentLabel) {
    	            parentLabel.querySelectorAll(".req-star").forEach(p => p.remove());
    	        }
    	        const idx = extraManList.indexOf(targetType);
    	        if (idx > -1) extraManList.splice(idx, 1);
    	    }
		}
		
	   	
		/**
	   	* @function getClassOptions
	   	* @description class Option 을 api로 조회 후 리턴 합니다.
	   	* @return {Array} classOption List
	  	*/
		async function getClassOptions(ItemTypeCode) {
			const sqlID = 'item_SQL.getClassOption'; 
			const sqlGridList = 'N';
		    const requestData = { ItemTypeCode, languageID, sqlID, sqlGridList };
		    const params = new URLSearchParams(requestData).toString();
		    const url = "getData.do?" + params;
			
		    try {
				const response = await fetch(url, { method: 'GET' });
				
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(result.message);
				}

				const result = await response.json();
				// success 필드 체크
				if (!result.success) {
					throw throwServerError(result.message);
				}

				if (result && result.data) {
					
					return result.data;
			        
				} else {
					return [];
				}

			} catch (error) {
				handleAjaxError(error);
			}
		}
	   	
	   	/**
	   	 * @function initDynamicCalendar
	   	 * @param {HTMLElement} container - 캘린더를 찾을 부모 요소
	   	 * @description 컨테이너 내의 .datePicker 클래스를 가진 요소들에 dhx.Calendar를 바인딩합니다.
	   	 */
	   	function initDynamicCalendar(container) {
	   	    if (!container) return;

	   	    const dateInputs = container.querySelectorAll('.datePicker');
	   	    
		   	if (dateInputs.length === 0)  return;
	   	    
	   	    dateInputs.forEach(input => {
	   	        const calendar = new dhx.Calendar(null, {
	   	            dateFormat: "%Y-%m-%d",
	   	            css: "dhx_widget--bordered"
	   	        });

	   	        const popup = new dhx.Popup();
	   	        popup.attach(calendar);

	   	        input.addEventListener("click", () => {
	   	            if (input.value) {
	   	                calendar.setValue(input.value);
	   	            }
	   	            popup.show(input);
	   	        });

	   	        calendar.events.on("change", () => {
	   	            input.value = calendar.getValue(); 
	   	            popup.hide();
	   	            input.dispatchEvent(new Event('change'));
	   	        });
	   	    });
	   	}
	   	 
	   	/**
	   	 * @function initDynamicDateTimePicker
	   	 * @param {HTMLElement} container - 타임피커를 찾을 부모 요소
	   	 * @description 컨테이너 내의 .timePicker 클래스를 가진 요소들에 dhx.Calendar ( + time )를 바인딩합니다.
	   	 */
	   	function initDynamicDateTimePicker(container) {
	   	    if (!container) return;

	   	    const dtInputs = container.querySelectorAll('.timePicker');
	   	    if (dtInputs.length === 0) return;

	   	    dtInputs.forEach(input => {
	   	        if (input.dataset.dtInit === "true") return;
	   	        input.dataset.dtInit = "true";

	   	        // 1. 날짜 + 시간 통합 설정
	   	        const dtPicker = new dhx.Calendar(null, {
	   	            timePicker: true,       // 시간 선택 활성화
	   	            dateFormat: "%Y-%m-%d %H:%i", // 2024-12-20 12:00 형식
	   	            timeFormat: 24,         // 24시간제
	   	            css: "dhx_widget--bordered"
	   	        });

	   	        const popup = new dhx.Popup();
	   	        popup.attach(dtPicker);

	   	        input.addEventListener("click", () => {
	   	            // 기존 값이 있다면 캘린더에 세팅
	   	            if (input.value) {
	   	                try {
	   	                    dtPicker.setValue(input.value);
	   	                } catch (e) {
	   	                    // 형식 불 일치일 경우 기본값 셋팅
	   	                    dtPicker.setValue(new Date());
	   	                }
	   	            }
	   	            popup.show(input);
	   	        });

	   	        dtPicker.events.on("change", () => {
	   	            input.value = dtPicker.getValue(); 
	   	            popup.hide(); 
	   	            input.dispatchEvent(new Event('change'));
	   	        });
	   	    });
	   	}
	   	 
	   	/**
	   	* @function saveObjInfoMain
	   	* @description 수정한 item attr을 저장합니다.
	  	*/
		async function saveObjInfoMain(){
			if(confirm("${CM00001}")){	
				
				$('#loading').fadeIn(150);
				
				// identifier 체크
				const identifier = document.getElementById("Identifier").value;
				if (!identifier) {
					
					// err msg
					Promise.all([getDicData("BTN", "LN0034")])
					.then(([btnDic]) => showDhxAlert('${WM00007}', btnDic.LABEL_NM));
					
					$('#loading').fadeOut(150);
					return;
				}
				
					
				// identifier 중복 체크
				const identifierEqualCount = await getIdentifierEqualCount(identifier);
				if (identifierEqualCount > 0) {
					
					// err msg
					const equalIdentifierInfo = await getEqualIdentifierInfo(identifier); // 중복 info 가져오기
					const formattedMsg = '${WM00081}'.replace("{0}", equalIdentifierInfo || "");
					
					Promise.all([getDicData("BTN", "LN0034")])
					.then(([btnDic]) => showDhxAlert(formattedMsg, btnDic.LABEL_NM));
					
					$('#loading').fadeOut(150);
					return;
					
				} else {
					
					// form 가져오기
					const form = document.objectInfoFrm;
					if (!form) return;
					
					// mlov 값 가공 start
					const checkedItems = document.querySelectorAll(".mlov-item:checked");
					const mlovGroups = {};

					checkedItems.forEach(item => {
					    const attrCode = item.dataset.attrCode; 
					    
					    if (attrCode) {
					        if (!mlovGroups[attrCode]) {
					            mlovGroups[attrCode] = [];
					        }
					        mlovGroups[attrCode].push(item.value);
					    }
					});
				    
					Object.keys(mlovGroups).forEach(code => {
						
						let hiddenInput = form.querySelector(`input[name="${code}"]`);
						if (!hiddenInput) {
					        hiddenInput = document.createElement("input");
					        hiddenInput.type = "hidden";
					        hiddenInput.name = code;
					        form.appendChild(hiddenInput);
					    }
					    hiddenInput.value = mlovGroups[code].join(",");
					});
					// mlov 값 가공 end
					
					
					const formData = new FormData(form);
					
				    // tinyEditor 값 셋팅
				    const tinyElements = document.querySelectorAll('textarea.tinymceText');
				    tinyElements.forEach(el => {
				        const editor = tinyMCE.get(el.id);
				        if (editor) {
				            formData.set(el.name, editor.getContent());
				        }
				    });
				    
				    // reuestData 준비
				    const requestData = Object.fromEntries(formData.entries());
				    
				    // 단계별 저장 진행
				    let success = false;
				    // 1.기본정보 저장
					success = await updateItemAPI(requestData,'info');
					// 2. attr 저장
				    success = await updateItemAPI(requestData,'attr');
					// 3. ZAT4015_ID 있을 경우 별도의 update 함수 실행
					const ZAT4015 = document.getElementById("ZAT4015_ID");
					if(ZAT4015) success = await updateItemAPI(requestData,'ZAT4015');
				
					// 성공 시 loading 종료
					if(success){
						$('#loading').fadeOut(150);
						Promise.all([
							getDicData("ERRTP", "LN0043"), // 저장이 완료되었습니다.
							getDicData("BTN", "LN0034"), // 닫기
						]).then(results => {
							showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
							renderItemNameAndPath(s_itemID, changeSetID);
						});
						
						
					} else {
						$('#loading').fadeOut(150);
					}
					
					
				}
			}
		}
		/**
	   	* @function updateItem
	   	* @param {Object} 저장할 정보 requestData
	   	* @param {String} 타입 ( info / attr )
	   	* @description item의 기본 정보 혹은 attr정보를 update 합니다.
	  	*/
		async function updateItemAPI(requestData, type) {
			    
			let url = 'updateItemInfo.do';
			if(type === 'attr') url = 'updateItemAttr.do';
			else if(type === 'ZAT4015') url = 'processInitialAuthAssignment.do';
				
		    try {
		    	const response = await fetch(url, {
		            method: 'POST',
		            headers: {
		                'Content-Type': 'application/json'
		            },
		            body: JSON.stringify(requestData) 
		        });
		        
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(response.statusText, response.status);
				}

		        const result = await response.json();
		        
				if (!result.success) {
					throw throwServerError(result.message, result.status);
				}
		        
				return result.success;
		        
		    } catch (error) {
		    	
		    	handleAjaxError(error, "LN0014");
		    	return false;
		    	
		    }
		    
		}
		/**
	   	* @function getIdentifierEqualCount
	   	* @description 중복 identifier의 count를 api로 조회 후 리턴 합니다.
	   	* @return {Number} Identifier Equal Count
	  	*/
		async function getIdentifierEqualCount(identifier) {
			const sqlID = 'attr_SQL.identifierEqualCount'; 
			const sqlGridList = 'N';
		    const requestData = { ItemID : s_itemID, Identifier : identifier , languageID, sqlID, sqlGridList };
		    const params = new URLSearchParams(requestData).toString();
		    const url = "getData.do?" + params;
			
		    try {
				const response = await fetch(url, { method: 'GET' });
				
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(result.message);
				}

				const result = await response.json();
				// success 필드 체크
				if (!result.success) {
					throw throwServerError(result.message);
				}

				if (result && result.data) {
					
					return result.data;
			        
				} else {
					return [];
				}

			} catch (error) {
				handleAjaxError(error);
			}
		}
	   	/**
	   	* @function getEqualIdentifierInfo
	   	* @description 중복 identifier의 정보를 api로 조회 후 리턴 합니다.
	   	* @return {Number} Identifier Equal Count
	  	*/
		async function getEqualIdentifierInfo(identifier) {
			const sqlID = 'attr_SQL.getEqualIdentifierInfo'; 
			const sqlGridList = 'N';
		    const requestData = { ItemID : s_itemID, Identifier : identifier , languageID, sqlID, sqlGridList };
		    const params = new URLSearchParams(requestData).toString();
		    const url = "getData.do?" + params;
			
		    try {
				const response = await fetch(url, { method: 'GET' });
				
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(result.message);
				}

				const result = await response.json();
				// success 필드 체크
				if (!result.success) {
					throw throwServerError(result.message);
				}

				if (result && result.data) {
					
					return result.data;
			        
				} else {
					return [];
				}

			} catch (error) {
				handleAjaxError(error);
			}
		} 
	   	
	   	
	</script>
	</head>
	<body>
		<div class="btn-wrap justify-end pdT10 pdB10">
			<div></div>
			<div class="btns">
				<button onclick="saveObjInfoMain()" class="primary">Save</button>
			</div>
		</div>

		<form name="objectInfoFrm" id="objectInfoFrm" enctype="multipart/form-data" action="saveObjectInfo.do" method="post" onsubmit="return false;">
			
			<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
			
			<input type="hidden" id="option" name="option"  value="${option}" />		
			<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
			<input type="hidden" id="sessionUserId" name="sessionUserId" value="${sessionScope.loginInfo.sessionUserId}" />		
			<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />		
			<input type="hidden" id="AuthorID" name="AuthorID" value="" />
			<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />			
			<input type="hidden" id="sub" name="sub" value="${sub}" />
			<input type="hidden" id="function" name="function" value="saveObjInfoMain">
			<input type="hidden" id="mLovAttrTypeCode" name="mLovAttrTypeCode" value="" />
			<input type="hidden" id="csrID" name="csrID"  value="" /> <!-- projectID -->
			
			<table width="100%" cellpadding="0" cellspacing="0" border="0" class="form-column-8 new-form" id="processInfo"></table>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" class="form-column-8 new-form mgT10 mgB20" id="attr"></table>
			
		</form>
		
		<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
	</body>
</html>