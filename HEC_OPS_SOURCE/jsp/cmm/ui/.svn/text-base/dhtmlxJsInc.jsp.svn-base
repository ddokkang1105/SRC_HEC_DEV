<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!-- dhtmlx calendar-->
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcalendar.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxCalendar/codebase/skins/dhtmlxcalendar_dhx_skyblue.css">
<script  src="${root}cmm/js/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcalendar.js"></script>
<!-- dhtmlx colorPicker-->
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxColorPicker/codebase/dhtmlxcolorpicker.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxColorPicker/codebase/skins/web/dhtmlxcolorpicker.css">
<script  src="${root}cmm/js/dhtmlx/dhtmlxColorPicker/codebase/dhtmlxcolorpicker.js"></script>
<!-- dhtmlx grid -->
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/dhtmlxgrid.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/dhtmlx/dhtmlxgrid_base.css">
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/dhtmlxcommon.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/dhtmlxgrid.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/dhtmlxgridcell.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_post.js" type="text/javascript" charset="utf-8"></script> 
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_srnd.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_math.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_filter.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_validation.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_export.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_group.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_rowspan.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_link.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_cntr.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_dhxcalendar.js"></script> <!-- calendar -->
<!-- dhtmlx  layout -->
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxLayout/codebase/skins/dhtmlxlayout_dhx_skyblue.css" media="screen" title="no title"/> 
<script src="${root}cmm/js/dhtmlx/dhtmlxLayout/codebase/dhtmlxcommon.js" type="text/javascript" charset="utf-8"></script> 
<script src="${root}cmm/js/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.js" type="text/javascript" charset="utf-8"></script> 
<script src="${root}cmm/js/dhtmlx/dhtmlxLayout/codebase/dhtmlxcontainer.js"></script> 
<!-- dhtmlx  tree -->
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/dhtmlxcommon.js" type="text/javascript" charset="utf-8"></script> 
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/dhtmlxtree.js" type="text/javascript" charset="utf-8"></script> 
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_json.js"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_attrs.js" type="text/javascript" charset="utf-8"></script> 
<script src="${root}cmm/js/dhtmlx/dhtmlxTree/codebase/ext/dhtmlxtree_xw.js" type="text/javascript" charset="utf-8"></script> 
<!-- dhtmlx chart -->
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxChart/codebase/dhtmlxchart.css">
<script src="${root}cmm/js/dhtmlx/dhtmlxChart/codebase/dhtmlxchart.js" type="text/javascript"></script>

<!-- dhtmlx  dataProcessor -->
<script src="${root}cmm/js/dhtmlx/dhtmlxDataProcessor/codebase/dhtmlxdataprocessor.js" type="text/javascript"></script>


<!-- dhtmlx vault -->
<!-- 
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxVault/codebase/dhtmlxvault.css">
<script src="${root}cmm/js/dhtmlx/dhtmlxVault/codebase/dhtmlxvault.js" type="text/javascript"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxVault/codebase/swfobject.js" type="text/javascript"></script>
 -->
 <!-- dhtmlx message-->
<link rel="stylesheet" type="text/css" href="${root}cmm/js/dhtmlx/dhtmlxMessage/codebase/skins/dhtmlxmessage_dhx_web.css">
<script src="${root}cmm/js/dhtmlx/dhtmlxMessage/codebase/dhtmlxmessage.js"></script>
<!-- TREE LAYOUT STYLE -->
<style>
table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar{height:43px;}
/* table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar div.dhtmlxInfoBarLabel{top:10px;} */
/* table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar div.dhtmlxInfoButtonShowHide_hor{top:10px;} */
table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBar div.dhtmlxInfoButtonShowHide_ver{top:10px;}
table.dhtmlxLayoutPolyContainer_dhx_skyblue div.dhtmlxPolyInfoBar div.dhtmlxLineL{border-left-width:0px;}
table.dhtmlxLayoutPolyContainer_dhx_skyblue div.dhtmlxPolyInfoBar div.dhtmlxLineR{border-right-width:0px;}
</style>