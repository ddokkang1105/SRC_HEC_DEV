<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<%--------------------------------------------------------------------------------
                              IMPORT / INCLUDE JAVASCRIPT, CSS
---------------------------------------------------------------------------------%>
<!-- XBOLT js -->
<script src="${root}cmm/js/xbolt/common.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/popupHelper.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/ajaxHelper.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/pagingHelper.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/dhtmlxCalendarHelper.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/dhtmlxGridHelper.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/dhtmlxTreeHelper.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/dhtmlxChartHelper.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/selectBox.js" type="text/javascript"></script>
<!-- TinyMce : Editor
<script src="${root}cmm/js/tinymce_v3/tiny_mce_src.js" type="text/javascript"></script>-->
<!-- TinyMce v4-->
<script src="${root}cmm/js/tinymce_v4.3/tinymce.min.js" type="text/javascript"></script>
