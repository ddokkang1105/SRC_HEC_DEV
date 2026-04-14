<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script type="text/javascript">
	var forumData = ${forumData};
	
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center" },
	        { width: 50, id: "AttechImg", header: [{ text: "파일" }], htmlEnable: true, align: "center", template: function (text, row, col) {
                return "<img src=${root}${HTML_IMG_DIR}"+text+">";
            }},
	        { width: 150, id: "Category", header: [{ text: "${menu.LN00021}" }] },
	        { id: "itemName", header: [{ text: "${menu.LN00028}" }] },
	        { id: "Subject", header: [{ text: "${menu.LN00002}" }], gravity:1 },
	        { width: 100, id: "WriteUserNM", header: [{ text: "${menu.LN00060}" }] },
	        { width: 100, id: "ModDT", header: [{ text: "${menu.LN00070}" }] },
	        { width: 100, id: "BrdCategory", header: [{ text: "${menu.LN00033}" }] },
	        { width: 100, id: "ItemMgtUserID", header: [{ text: "${menu.LN00004}" }] },
	        { width: 50, id: "ReadCNT", header: [{ text: "Count" }] },
	        { width: 50, id: "CommentCNT", header: [{ text: "Reply" }] },
	        { width: 50, id: "IsNew", header: [{ text: "${menu.LN00068}" }], htmlEnable: true, align: "center", template: function (text, row, col) {
                return "<img src=${root}${HTML_IMG_DIR}"+text+">";
            } },
	        { width: 50, id: "Content", header: [{ text: "Content" }], hidden: true },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    css: "boardStyle",
	    data: forumData
	});
	
// datapicker dhtmlxJsInc.jsp line9,11 주석처리해야 사용가능
var filterFormConfig = {
        padding: "8px 12px 0",
        cols: [
            {
                type: "combo", // Input controls have initial width while Combo controls don't have
                width: 270,
                name: "Category",
                label: "Category",
                padding: "8px",
                itemHeight: 50,
                placeholder: "Select something",
            },
            {
                type: "combo",
                width: 270,
                name: "Subject",
                label: "Combo",
                padding: "8px",
                multiselection:!0,
                placeholder:"All",
            },
            {
                type: "datepicker",
                name: "ModDT",
                label: "${menu.LN00070}",
                dateFormat: "%Y-%m-%d",
                padding: "8px",
                placeholder: "Select date",
                editable: true
            },
            {
                type: "input", 
                name: "Content",
                label: "내용",
                padding: "8px",
                placeholder: "Type something",
            },
            {
                padding: "32px 8px 0",
                cols: [
                    {
                        name: "search-button",
                        type: "button",
                        icon: "mdi mdi-magnify",
                        text: "Search",
                        circle: true
                    },
                    {
                        name: "clear",
                        type: "button",
                        text: "clear",
                        view: "link",
                        padding: "0 16px",
                        circle: true
                    }
                ]
            },
        ]
    };

// Layout initialization
var layout2 = new dhx.Layout("layout2", {
    rows: [
        {
            id: "filter",
            height: "content",
            css: "dhx_demo-filter"
        },
        {
            rows: [
                { id: "grid" }
            ]
        },
        {
        	id:"pagination",
        	height: "content"
        }
    ]
});

// initializing Form for data filtering
var filterForm = new dhx.Form(null, filterFormConfig);
filterForm.getItem("search-button").events.on("click", function () {
    var filterData = filterForm.getValue();
    grid.data.filter(function (item) {
        var check = true;
			for (var key in filterData) {
            if (filterData[key] !== "" && !RegExp(item[key], "i").exec(filterData[key])) {
                check = false;
            }
        }
        return check;
    });
});
filterForm.getItem("clear").events.on("click", function () {
    filterForm.clear();
    grid.data.filter();
});

function fnLoadByData (data){
    var Category = [...new Set(data.map(function (item) {
        if (item.Category) {
            return item.Category;
        }
    }))];
    filterForm.getItem("Category").getWidget().data.add(Category.map(function (item) {
        return { id: item, value: item };
    }));
}

function fnLoadSubjectByData (data){
    var subject = [...new Set(data.map(function (item) {
        if (item.Subject) {
            return item.Subject;
        }
    }))];
    filterForm.getItem("Subject").getWidget().data.add(subject.map(function (item) {
        return { id: item, value: item };
    }));
}

fnLoadByData(grid.data)
fnLoadSubjectByData(grid.data)

	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 20,
	});

layout2.getCell("filter").attach(filterForm);
layout2.getCell("grid").attach(grid);
layout2.getCell("pagination").attach(pagination);


</script>
<div id="help_content" class="mgL10 mgR10" style="height:100%;">
<%-- 	<div class="title-section">${boardMgtInfo.boardMgtName}</div> --%>
<!-- 	<div style="width: 100%" id="grid"></div> -->
<!-- 	<div id="pagination"></div> -->

	<div id="layout2" style="height: 100%;"></div>
	
</div>