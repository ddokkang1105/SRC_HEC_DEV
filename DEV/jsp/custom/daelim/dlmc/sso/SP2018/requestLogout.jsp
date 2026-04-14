<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rathontech2018.sso.sp.agent.web.WebAgent"%>
WebAgent.requestLogout: <%= new WebAgent().requestLogout(request, null) %>