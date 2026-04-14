<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
    <%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
    <script src="${root}cmm/js/tinymce_v7/tinymce.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        var chkReadOnly = true;
    </script>
    <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

    <!-- 화면 표시 메세지 취득  -->
    <spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

    <script type="text/javascript">
        // 	let defaultLang = "";
        let text = "${text}"
        let plainText = "${plainText}"

        // TB_LANGUAGE.Active = 0 인 언어 리스트
        const activeLangList = ${activeLangList};

        // TB_LANGUAGE.ExtCode 에 type 세팅
        const langList = [ {
            "name" : "한국어", "type" : "ko"
        },{
            "name" : "영어", "type" : "en"
        }, {
            "name" : "일본어", "type" : "ja"
        }, {
            "name" : "중국어(간체)", "type" : "zh-CN"
        }, {
            "name" : "중국어(번체)", "type" : "zh-TW"
        }, {
            "name" : "스페인어", "type" : "es"
        }, {
            "name" : "프랑스어", "type" : "fr"
        }, {
            "name" : "독일어", "type" : "de"
        }, {
            "name" : "러시아어", "type" : "ru"
        }, {
            "name" : "이탈리아어", "type" : "it"
        }, {
            "name" : "베트남어", "type" : "vi"
        }, {
            "name" : "태국어", "type" : "th"
        }, {
            "name" : "인도네시아어", "type" : "id"
        } ];

        window.onload = function() {
            // 언어 감지 api
            text = text || plainText;

            if (text) detectLang();

            setLangList("srcLangType");
            setLangList("tarLangType");
        }



        function setLangList(node) {
            const langType = document.getElementById(node);
            const ul = langType.querySelector("ul");
            const summary = langType.querySelector('summary');

            langList.forEach(lang => {
                const li = document.createElement('li');
                li.textContent = lang.name;
                li.setAttribute('data-type', lang.type);
                ul.appendChild(li);
            });

            if(node == "tarLangType") {
                document.querySelector('#'+node+' li[data-type="en"]').classList.add("selected");
                summary.textContent = document.querySelector('#'+node+' li[data-type="en"]').textContent;

            } else {
                document.querySelector('#'+node+' li[data-type="ko"]').classList.add("selected");
                summary.textContent = document.querySelector('#'+node+' li[data-type="ko"]').textContent;
            }

            const langs = langType.querySelectorAll('li');
            langs.forEach(item => {
                item.addEventListener("click", function() {
                    summary.textContent = this.textContent;
                    langs.forEach(li => li.classList.remove('selected'));
                    this.classList.add('selected');
                    langType.removeAttribute('open');
                });
            });
        }

        function detectLang() {
            fetch("/olmapi/langData/gptAI", {
                //
                method : "POST",
                body : JSON.stringify({ text : text }),
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
            })
                .then(res => res.text())
                .then(res => {
                    console.log("res: ", res);
                    document.querySelectorAll('#srcLangType li').forEach(e => e.classList.remove("selected"));
                    document.querySelectorAll('#tarLangType li').forEach(e => e.classList.remove("selected"));
                    document.querySelector('#srcLangType li[data-type="'+res+'"]').classList.add("selected");
                    document.querySelector("#srcLangType summary").textContent = document.querySelector('#srcLangType li[data-type="'+res+'"]').textContent;
                    if(res == "ko") {
                        document.querySelector('#tarLangType li[data-type="en"]').classList.add("selected");
                        document.querySelector("#tarLangType summary").textContent = document.querySelector('#tarLangType li[data-type="en"]').textContent;
                    } else {
                        document.querySelector('#tarLangType li[data-type="ko"]').classList.add("selected");
                        document.querySelector("#tarLangType summary").textContent = document.querySelector('#tarLangType li[data-type="ko"]').textContent;
                    }

                    transData();
                })
        }

        function transData() {
            const sourceLang = document.querySelector('#srcLangType li.selected').dataset.type;
            const targetLang = document.querySelector('#tarLangType li.selected').dataset.type;

            if(sourceLang == targetLang) {
                alert("번역하려는 언어가 동일합니다.")
            } else {
                $("#loading").fadeIn(150);
                text = document.getElementById("transtext").value;
                fetch("/olmapi/transData/gptAI/?memberID=${sessionScope.loginInfo.sessionUserId}&text="+text+"&itemID=${itemID}&languageID=${languageID}&attrTypeCode=${attrTypeCode}&sourceLang="+sourceLang+"&targetLang="+targetLang)
                    .then((response) => response.text())
                    .then((data) => document.getElementById("translatedText").innerHTML = data)
                    .catch((error) => console.log("error:", error));

                $("#loading").fadeOut(150);
            }
        }

        function getTranlangcode(callback) {
            const targetLang = document.querySelector('#tarLangType li.selected').dataset.type;

            $.ajax({
                url: "/olmapi/getLanguageID/",
                type: "GET",
                data: {
                    ExtCode: targetLang
                },
                dataType: "json",
                success: function (response) {
                    document.getElementById("tarLangCode").value = response.tarLangCode;

                    if (typeof callback === 'function') {
                        callback();
                    }
                },
            });
        }

        function saveGPTAITrans() {
            if (confirm("${CM00001}")) {
                getTranlangcode(function() {
                    ajaxSubmit(document.transForm, "savePapagoTrans.do", "saveFrame");
                });
            }
        }

        function selfClose() {
            window.close();
        }

    </script>
    <style>
        .transarea-container {
            padding: 20px;
        }

        .transarea-wrapper {
            display: flex;
            gap: 20px;
        }

        .transarea {
            flex: 1 0;
            border: 1px solid #ddd;
            border-radius: 12px;
            display: flex;
            flex-direction: column;
        }

        .translang {
            width: fit-content;
            font-size: 14px;
            border: none;
            margin: 10px 20px;
            height: 30px;
            line-height: 30px;
            padding-left: 0;
        }

        .transtext {
            padding: 20px;
            border-top: 1px solid #ddd;
            min-height: 196px;
            font-size: 15px;
            white-space: pre-line;
            border-radius: 0 0 12px 12px;
            resize: none;
        }

        .language-selector {
            display: inline-block;
            position: relative;
        }

        .language-selector summary {
            cursor: pointer;
            font-size: 14px;
            border: none;
            margin: 10px 20px;
            height: 30px;
            line-height: 30px;
            width: fit-content;
            font-weight: 500;
            list-style-type: none;
            position: relative;
            padding-right: 20px;
        }

        .language-selector summary::-webkit-details-marker {
            display: none;
        }

        .language-selector summary::after {
            content: "";
            position: absolute;
            width: 7px;
            height: 7px;
            border: 1.5px solid #666;
            border-left: none;
            border-top: none;
            transform: rotate(45deg);
            top: 9px;
            right: 0px;
            transition: .25s transform;
        }

        details[open] summary:after {
            transform: translateY(4px) rotate(225deg);
        }

        .language-list {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            margin: 0;
            padding: 0;
            list-style: none;
            top: calc(100% + 1px);
            position: absolute;
            width: 100%;
            background: #fff;
            border-radius: 0 0 12px 12px;
            height: 236px;
        }

        .language-list li {
            padding: 10px 0;
            padding-left: 22px;
            cursor: pointer;
            font-size: 14px;
        }

        .language-list li:hover {
            color: #2945b3;
            font-weight: bold;
        }

        .language-list li.selected {
            color: #2945b3;
            font-weight: bold;
            position: relative;
        }

        .language-list li.selected::after {
            content: "";
            color: #2945b3;
            position: absolute;
            background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' height='20px' viewBox='0 -960 960 960' width='20px' fill='%232945b3'><path d='M389-267 195-460l51-52 143 143 325-324 51 51-376 375Z'/></svg>");
            background-size: contain;
            background-repeat: no-repeat;
            display: inline-block;
            width: 20px;
            height: 20px;
            top: 10px;
            margin-left: 5px;
        }
    </style>
<body>
<form name="transForm" id="transForm" action="" method="post" onsubmit="return false;">
    <input type="hidden" id=itemID name="itemID" value="${itemID}" />
    <input type="hidden" id="attrTypeCode" name="attrTypeCode" value="${attrTypeCode}" />
    <input type="hidden" id="tarLangCode" name="tarLangCode" value="" />
    <div class="transarea-container">

        <div class="transarea-wrapper">
            <div class="transarea">
                <details class="language-selector" id="srcLangType"> <summary></summary>
                    <ul class="language-list"></ul>
                </details>
                <textarea class="transtext" id="transtext">${plainText}</textarea>
            </div>
            <div class="transarea">
                <details class="language-selector" id="tarLangType"> <summary></summary>
                    <ul class="language-list"></ul>
                </details>
                <textarea id="translatedText" name="translatedText" class="transtext" readonly>
                    ${transData.translatedText}
                </textarea>
                <!-- 					</div> -->
            </div>
        </div>
        <button onclick="saveGPTAITrans()" class="cmm-btn2 floatR last mgT10">Save</button>
        <button onclick="transData()" class="cmm-btn2 floatR last mgT10" style="margin-right: 10px;">Translate</button>
    </div>
</form>
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none" frameborder="0"></iframe>
</body>
</head>
</html>