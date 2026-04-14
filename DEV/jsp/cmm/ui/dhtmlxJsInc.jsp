<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<script>
	sessionStorage.setItem("DEF_FONT","${sessionScope.loginInfo.sessionDefFont}");
</script>

<!--//////////////////////////  dhtmlx old ////////////////////////////////////////////////////////////////////// -->

<!-- dhtmlx old common -->
<script src="${root}cmm/js/dhtmlx/codebase/dhtmlx.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxCommon/codebase/connector.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxCommon/codebase/dhtmlxcommon.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxCommon/codebase/dhtmlxcontainer.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxCommon/codebase/dhtmlxcore.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxCommon/codebase/dhtmlxdataprocessor.js"></script> 

<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/codebase/dhtmlx.css"/>

<!-- dhtmlx old grid -->
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/dhtmlxgrid.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_math.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_data.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_drag.js"></script>

<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_export.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_fast.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_filter_ext.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_filter.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_form.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_group.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_hextra.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_hmenu.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_json.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_keymap.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_markers.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_math.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_mcol.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_nxml.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_over.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_pivot.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_post.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_rowspan.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_selection.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_splt.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_srnd.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_ssc.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_start.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_undo.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_validation.js"></script> 

<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/skins/dhtmlxgrid_dhx_skyblue.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/skins/dhtmlxgrid_dhx_terrace.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/skins/dhtmlxgrid_dhx_web.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/skins/dhtmlxgrid_material.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/skins/dhtmlxgrid_board.css" />

<!-- dhtmlx old treeGrid-->
<script src="${root}cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/ext/dhtmlxtreegrid_filter.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/ext/dhtmlxtreegrid_lines.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/ext/dhtmlxtreegrid_property.js"></script>

<!-- dhtmlx5  layout -->
<script src="${root}cmm/js/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.js" type="text/javascript" charset="utf-8"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxLayout/codebase/skins/dhtmlxlayout_dhx_skyblue.css" />

<!-- dhtmlx old tree -->
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/dhtmlxtree.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_attrs.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_dragin.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_ed.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_json.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_kn.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_lf.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_li.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_path.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_rl.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_sb.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_srnd.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_start.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_xw.js"></script>

<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/skins/dhtmlxtree_dhx_skyblue.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/skins/dhtmlxtree_dhx_terrace.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/skins/dhtmlxtree_dhx_web.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/skins/dhtmlxtree_material.css" />

<!-- dhtmlx old calendar -->
<script src="${root}cmm/js/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcalendar.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxCalendar/codebase/ext/dhtmlxcalendar_double.js"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxCalendar/codebase/skins/dhtmlxcalendar_dhx_skyblue.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxCalendar/codebase/skins/dhtmlxcalendar_dhx_terrace.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxCalendar/codebase/skins/dhtmlxcalendar_dhx_web.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxCalendar/codebase/skins/dhtmlxcalendar_material.css" />

<!-- dhtmlx old chart -->
<script src="${root}cmm/js/dhtmlx/dhtmlxChart/codebase/dhtmlxchart.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxChart/codebase/skins/dhtmlxchart_dhx_skyblue.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxChart/codebase/skins/dhtmlxchart_dhx_terrace.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxChart/codebase/skins/dhtmlxchart_dhx_web.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxChart/codebase/skins/dhtmlxchart_material.css">


<!-- TREE LAYOUT STYLE -->
<!-- <style>
table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar{height:43px;}
/* table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar div.dhtmlxInfoBarLabel{top:10px;} */
/* table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar div.dhtmlxInfoButtonShowHide_hor{top:10px;} */
table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar div.dhtmlxInfoButtonShowHide_ver{top:10px;}
table.dhtmlxLayoutPolyContainer_dhx_skyblue div.dhtmlxPolyInfoBar div.dhtmlxLineL{border-left-width:0px;}
table.dhtmlxLayoutPolyContainer_dhx_skyblue div.dhtmlxPolyInfoBar div.dhtmlxLineR{border-right-width:0px;}
</style> -->