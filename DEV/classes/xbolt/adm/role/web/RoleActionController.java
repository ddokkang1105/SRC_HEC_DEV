package xbolt.adm.role.web;

import java.awt.Color;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

/**
 * 업무 처리
 * 
 * @Class Name : RoleActionController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- ------------------------------- @2018.
 *      03.23 . Smartfactory 최초생성
 * 
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class RoleActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/roleAssignment.do")
	public String roleAssignment(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/roleAssignment";
		HashMap setData = new HashMap();
		try {
			model.put("menu", getLabel(request, commonService)); // Label Setting			
			setData.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			Map itemAuthInfo = commonService.select("item_SQL.getItemAuthority", setData);
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("itemIDAuthorID", StringUtil.checkNull(itemAuthInfo.get("AuthorID")));
			model.put("assignmentType", StringUtil.checkNull(request.getParameter("varFilter")));			
			model.put("blankPhotoUrlPath", GlobalVal.HTML_IMG_DIR + "/blank_photo.png");	
			model.put("photoUrlPath", GlobalVal.EMP_PHOTO_URL);	
			
			setData.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			setData.put("isAll", "N");
			setData.put("assignmentType", StringUtil.checkNull(request.getParameter("varFilter")));			
			setData.put("blankPhotoUrlPath", GlobalVal.HTML_IMG_DIR + "/blank_photo.png");	
			setData.put("photoUrlPath", GlobalVal.EMP_PHOTO_URL);	
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			List assignedRoleList = commonService.selectList("role_SQL.getAssignedRoleList_gridList",setData);
			JSONArray gridData = new JSONArray(assignedRoleList);
			model.put("gridData", gridData);
			model.put("searchOption", StringUtil.checkNull(request.getParameter("searchOption")));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/saveRoleAssignment.do")
	public String saveRoleAssignment(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		String alertType =  StringUtil.checkNull(request.getParameter("alertType"), "");
		try {
			HashMap setData = new HashMap();
			HashMap insertData = new HashMap();
			HashMap updateData = new HashMap();

			String seq = StringUtil.checkNull(request.getParameter("seq"));
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String roleType = StringUtil.checkNull(request.getParameter("roleType"));
			String assigned = StringUtil.checkNull(request.getParameter("assigned"));
			String assignmentType = StringUtil.checkNull(request.getParameter("assignmentType"));
			String orderNum = StringUtil.checkNull(request.getParameter("orderNum"));
			String accessRight = StringUtil.checkNull(request.getParameter("accessRight"));
			String memberID = StringUtil.checkNull(request.getParameter("memberID"));
			String memo = StringUtil.checkNull(request.getParameter("memo"));
			String mbrTeamID = StringUtil.checkNull(request.getParameter("mbrTeamID"));
			String clientID = StringUtil.checkNull(request.getParameter("clientID"));
			String[] arrayItems = itemID.split(",");
			
			String mode = StringUtil.checkNull(request.getParameter("mode"));
			String[] arrRoleTypes = roleType.split(","); // 일괄 추가 시 
			String[] memberIDs = memberID.split(",");
			String[] mbrTeamIDs = mbrTeamID.split(",");
			
			String searchUserID = StringUtil.checkNull(request.getParameter("searchUserID"));
			
			for (int i = 0; i < arrayItems.length; i++) {				
				
				// 일괄추가
				if("ALL".equals(mode)){
						
						insertData.put("itemID", arrayItems[i]);
						insertData.put("assigned", assigned);
						insertData.put("assignmentType", assignmentType);
						insertData.put("orderNum", orderNum);
						insertData.put("accessRight", accessRight);
						insertData.put("creator", cmmMap.get("sessionUserId"));
						insertData.put("memo", memo);
							
						for (int k = 0; k < memberIDs.length; k++) {
							memberID = memberIDs[k];
							mbrTeamID = mbrTeamIDs[k];
							
							setData.put("memberID", memberID);
							setData.put("itemID", arrayItems[i]);
							setData.put("assignmentType", assignmentType);
							setData.put("roleType", arrRoleTypes[i]);
							
							
							if(!"".equals(searchUserID) && "".equals(clientID)) {
								// 사용자 검색 시 특정 clientID 미선택인 경우, 사용자의 clientID 전부 할당
								insertData.put("searchUserID", searchUserID);
								insertData.put("memberID", memberID);
								insertData.put("mbrTeamID", mbrTeamID);
								insertData.put("roleType", arrRoleTypes[i]);
								String successCount = commonService.selectString("role_SQL.insertRoleCopyUser", insertData);
							} else {
								setData.put("clientID", clientID);
								String myItemCNT = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCNT", setData));
								seq = "";
								if(Integer.parseInt(myItemCNT)>0) {
									seq = commonService.selectString("item_SQL.getMyItemSeq", setData);
								}
								
								if ("".equals(seq)) {
									insertData.put("clientID", clientID);
									insertData.put("memberID", memberID);
									insertData.put("mbrTeamID", mbrTeamID);
									insertData.put("roleType", arrRoleTypes[i]);
									commonService.insert("role_SQL.insertRoleAssignment", insertData);
								}
							}
							
						}
				} else {
					
					setData.put("memberID", memberID);
					setData.put("itemID", arrayItems[i]);
					setData.put("assignmentType", assignmentType);
					setData.put("roleType", roleType);
					setData.put("clientID", clientID);
					String myItemCNT = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCNT", setData));
					if(Integer.parseInt(myItemCNT)>0) {
						seq = commonService.selectString("item_SQL.getMyItemSeq", setData);
					}
					
					if (seq.equals("")) {
						insertData.put("memberID", memberID);
						insertData.put("mbrTeamID", mbrTeamID);
						insertData.put("itemID", arrayItems[i]);
						insertData.put("roleType", roleType);
						insertData.put("assigned", assigned);
						insertData.put("assignmentType", assignmentType);
						insertData.put("orderNum", orderNum);
						insertData.put("accessRight", accessRight);
						insertData.put("creator", cmmMap.get("sessionUserId"));
						insertData.put("memo", memo);
						insertData.put("clientID", clientID);
						commonService.insert("role_SQL.insertRoleAssignment", insertData);
					} else {
						updateData.put("seq", seq);
						updateData.put("itemID", arrayItems[i]);
						updateData.put("roleType", roleType);
						updateData.put("assigned", assigned);
						updateData.put("assignmentType", assignmentType);
						updateData.put("orderNum", orderNum);
						updateData.put("accessRight", accessRight);
						updateData.put("lastUser", cmmMap.get("sessionUserId"));
						updateData.put("memo", memo);
						updateData.put("clientID", clientID);
						commonService.update("role_SQL.updateRoleAssignment", updateData);
					}
				}
			}
			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			}
	
			target.put(AJAX_SCRIPT, "fnRoleCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			
			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			}	
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/deleteRoleAssignment.do")
	public String deleteRoleAssignment(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap updateData = new HashMap();
			String mode = StringUtil.checkNull(request.getParameter("mode"));
			
			if("ALL".equals(mode)){
				String itemID = StringUtil.checkNull(request.getParameter("itemID"));
				String[] arrayItems = itemID.split(",");
				
				String assignmentType = StringUtil.checkNull(request.getParameter("assignmentType"));
				updateData.put("assignmentType", assignmentType);
				
				String clientID = StringUtil.checkNull(request.getParameter("clientID"));
				updateData.put("clientID", clientID);
				
				String roleType = "";
				String roleTypes = StringUtil.checkNull(request.getParameter("roleTypes"));
				String roleSpl[] = roleTypes.split(",");
				
				String memberID = "";
				String memberIDs = StringUtil.checkNull(request.getParameter("memberIDs"));
				String memSpl[] = memberIDs.split(",");
				
				for (int i = 0; i < roleSpl.length; i++) {
					roleType = roleSpl[i];
					updateData.put("roleType", roleType);
					updateData.put("itemID", arrayItems[i]);
					for (int j = 0; j < memSpl.length; j++) {
						memberID = memSpl[j];
						updateData.put("memberID", memberID);
						commonService.update("role_SQL.deleteRoleAssignment", updateData);
					}
				}
			} else {
				String seq = "";
				String seqArr = StringUtil.checkNull(request.getParameter("seqArr"));
	
				String seqSpl[] = seqArr.split(",");
				for (int i = 0; i < seqSpl.length; i++) {
					seq = seqSpl[i];
					updateData.put("seq", seq);
					commonService.update("role_SQL.deleteRoleAssignment", updateData);
				}
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnRoleCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/itemTeamRoleList.do")
	public String itemTeamRoleList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/itemTeamRoleList";
		HashMap setData = new HashMap();
		try {
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			String showRemoved = StringUtil.checkNull(request.getParameter("showRemoved"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String isSubItem = StringUtil.checkNull(cmmMap.get("isSubItem"));
			model.put("menu", getLabel(request, commonService)); // Label Setting
			setData.put("s_itemID", s_itemID);
			Map itemInfo = commonService.select("project_SQL.getItemInfo", setData);
			
			model.put("s_itemID", s_itemID);
			model.put("itemIDAuthorID", StringUtil.checkNull(itemInfo.get("AuthorID")));
			model.put("teamRoleCat", StringUtil.checkNull(request.getParameter("varFilter")));
			model.put("showRemoved", StringUtil.checkNull(request.getParameter("showRemoved")));
			model.put("itemBlocked", StringUtil.checkNull(itemInfo.get("Blocked")));
			model.put("isSubItem", isSubItem);
			
			setData.put("itemID", s_itemID);
			setData.put("showRemoved", showRemoved);
			setData.put("languageID", languageID);
			
			// accMode로 출력할 status 설정
			String accMode = StringUtil.checkNull(cmmMap.get("accMode"));
			model.put("accMode", accMode);
			//accMode가 DEV or 기본 이며 showRemoved 일 때 해제,해제중 모두 출력
		
			if("DEV".equals(accMode) || "".equals(accMode)){
				if(!"Y".equals(showRemoved)){
					setData.put("asgnOption", "1,2");  //해제,해제중 미출력 & 릴리즈,신규 출력
				}
			}else {
				setData.put("asgnOption", "2,3"); //해제,신규 미출력 & 릴리즈, 해제중 출력
			} 
			List teamRoleList;
			if("Y".equals(isSubItem)) {
			 teamRoleList = commonService.selectList("role_SQL.getSubItemRoleList_gridList", setData);
			}else {
				
				teamRoleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setData);
			}
	
			
			JSONArray gridData = new JSONArray(teamRoleList);
			model.put("gridData", gridData);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/saveTeamRole.do")
	public String saveTeamRole(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap insertData = new HashMap();
			HashMap setData = new HashMap();
			HashMap updateData = new HashMap();

			String teamIDs[] = StringUtil.checkNull(request.getParameter("teamIDs")).split(",");
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String roleType = StringUtil.checkNull(request.getParameter("roleTypeCode"));
			//String assigned = StringUtil.checkNull(request.getParameter("assigned"));
			String teamRoleCat = StringUtil.checkNull(request.getParameter("teamRoleCat"),"TEAMROLETP");
			if(teamRoleCat.equals("")) teamRoleCat = "TEAMROLETP";
			
			insertData.put("itemID", itemID);
			String curChangeSet = commonService.selectString("item_SQL.getCurChangeSet", insertData);
			
			//insertData.put("assigned", assigned);			
			insertData.put("teamRoleType", roleType);			
			insertData.put("creator", cmmMap.get("sessionUserId"));
			insertData.put("teamRoleCat", teamRoleCat);
			insertData.put("changeSetID", curChangeSet);
			
			for (int i = 0; i < teamIDs.length; i++) {
				insertData.put("teamID", teamIDs[i]);
				
				setData.put("itemID", itemID);	
				setData.put("teamID", teamIDs[i]);	
				setData.put("teamRoleType", roleType);
				setData.put("teamRoleCat", teamRoleCat);	
				
				Map teamRoleInfo = commonService.select("role_SQL.getTeamRoleAssigned", setData);
				if(!teamRoleInfo.isEmpty()) {
					String assigned = StringUtil.checkNull(teamRoleInfo.get("Assigned"));
					String teamRoleID = StringUtil.checkNull(teamRoleInfo.get("TeamRoleID"));
				
					if(assigned.equals("0")) { // 0 :해제 Insert New record, Assigned = 1
						insertData.put("assigned", "1");
						commonService.insert("role_SQL.insertTeamRole", insertData);
					}else if(assigned.equals("3")) { // 3 : 해제중 -> Update Assignd = 2, LastUpdated = getDate( )
						updateData = new HashMap();
						updateData.put("assigned", "2");
						updateData.put("teamRoleID", teamRoleID);
						commonService.update("role_SQL.updateTeamRole", updateData);
					}
					// assigned : 1,2 No processing
				}else {
					insertData.put("assigned", "1");
					commonService.insert("role_SQL.insertTeamRole", insertData);
				}
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnTeamRoleCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/updateTeamRoleInfo.do")
	public String updateTeamRoleInfo(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap updateData = new HashMap();

			String teamRoleID = StringUtil.checkNull(request.getParameter("teamRoleID"));
			String teamRoleType = StringUtil.checkNull(request.getParameter("teamRoleType"));
			String roleManagerID = StringUtil.checkNull(request.getParameter("roleManagerID"));
			String teamRoleIDs = StringUtil.checkNull(request.getParameter("teamRoleIDs"));
			String assigned = StringUtil.checkNull(request.getParameter("assigned"));
			String roleDescription = StringUtil.checkNull(cmmMap.get("roleDescription"));

			updateData.put("teamRoleID", teamRoleID);
			updateData.put("teamRoleType", teamRoleType);
			updateData.put("roleManagerID", roleManagerID);
			updateData.put("teamRoleIDs", teamRoleIDs);
			updateData.put("assigned", assigned);
			updateData.put("roleDescription", roleDescription);

			commonService.update("role_SQL.updateTeamRole", updateData);

			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnTeamRoleCallBack('" + teamRoleID + "');");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/goTeamRoleTypePop.do")
	public String goTeamRoleTypePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/teamRoleTypePop";
		HashMap setData = new HashMap();
		try {
			setData.put("itemID", request.getParameter("s_itemID"));
			List teamRoleList = commonService.selectList("role_SQL.getTeamRoleIDList", setData);
			String teamIDs = "";
			if (teamRoleList.size() > 0) {
				for (int i = 0; i < teamRoleList.size(); i++) {
					Map teamRoleMap = (Map) teamRoleList.get(i);
					if (i == 0) {
						teamIDs = StringUtil.checkNull(teamRoleMap.get("TeamID"));
					} else {
						teamIDs = teamIDs + StringUtil.checkNull(teamRoleMap.get("TeamID"));
					}
				}
			}
			model.put("teamIDs", teamIDs);
			model.put("menu", getLabel(request, commonService)); // Label Setting

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/deleteTeamRole.do")
	public String deleteTeamRole(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();
			String teamRoleIDs[] = StringUtil.checkNull(request.getParameter("teamRoleIDs")).split(",");
			String assigneds[] = StringUtil.checkNull(request.getParameter("assigneds")).split(",");
			
			// Assigned = 1 일 경우 Recode 삭제... Assigned = 2 일 경우 Assigned = 3
			if(!StringUtil.checkNull(request.getParameter("teamRoleIDs")).equals("")) {
				for(int i=0; i<teamRoleIDs.length; i++) {
					String teamRoleID = StringUtil.checkNull(teamRoleIDs[i]);
					String assigned = StringUtil.checkNull(assigneds[i]);
					
					if(assigned.equals("1")){ // 삭제 
						setData.put("teamRoleIDs", teamRoleID);
						commonService.delete("role_SQL.deleteTeamRole", setData);
					}else if(assigned.equals("2")){ // Assigned = 3
						
						setData.put("teamRoleID", teamRoleID);
						setData.put("assigned", "3");
						commonService.update("role_SQL.updateTeamRole", setData);
					}
					
					setData = new HashMap();
				}
			}


			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnTeamRoleCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/teamRoleMgt.do")
	public String teamRoleMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/teamRoleMgt";
		try {
			model.put("teamManagerID", request.getParameter("teamManagerID"));
			model.put("teamID", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("teamID"))));
			model.put("menu", getLabel(request, commonService)); // Label Setting
			model.put("teamRoleType", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("teamRoleType"))));
			model.put("hideTitle", StringUtil.checkNull(request.getParameter("hideTitle")));
			model.put("pageNum", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("pageNum"))));
			model.put("itemTypeCode", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("itemTypeCode"))));
			model.put("classCode", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("classCode"))));
		
					
			model.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));		
			cmmMap.put("searchKey", request.getParameter("searchKey"));				
			cmmMap.put("searchValue", request.getParameter("searchValue"));
			List<String> tmrList = commonService.selectList("role_SQL.getTeamRoleItemList_gridList",cmmMap);
			JSONArray gridData = new JSONArray(tmrList);
			model.put("gridData", gridData);
		
			
			
			
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/teamItemMappingList.do")
	public String teamItemMappingList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/teamItemMappingList";
		HashMap setData = new HashMap();
		try {
			model.put("menu", getLabel(request, commonService)); // Label Setting
			setData.put("reportCode", request.getParameter("reportCode"));
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			String reportName = StringUtil.checkNull(commonService.selectString("report_SQL.getReportName", setData));
			if (reportName.equals("") || reportName == null) {
				reportName = "Team Item Mapping List";
			}
			model.put("reportName", reportName);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/myRoleList.do")
	public String myRoleList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/user/sub/myRoleList";
		try {
			// setData.put("itemID", request.getParameter("s_itemID"));
			model.put("memberID", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("memberID"))));
			model.put("scrnType", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("scrnType"))));
			// Map itemAuthInfo = commonService.select("item_SQL.getItemAuthority",
			// setData);

			// model.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")) );
			// model.put("itemIDAuthorID",
			// StringUtil.checkNull(itemAuthInfo.get("AuthorID")) );
			// model.put("assignmentType",
			// StringUtil.checkNull(request.getParameter("varFilter")) );
			cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			cmmMap.put("memberId",request.getParameter("memberID"));
			cmmMap.put("assigned", 1);
			List mrList = commonService.selectList("role_SQL.getMyAssignedRoleList_gridList",cmmMap);

			JSONArray gridData = new JSONArray(mrList);
			model.put("gridData",gridData);
			
			
			model.put("menu", getLabel(request, commonService)); // Label Setting

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/teamRoleDetail.do")
	public String teamRoleDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/teamRoleDetail";
		HashMap setData = new HashMap();
		try {
			model.put("teamRoleID", request.getParameter("teamRoleID"));
			model.put("editYN", request.getParameter("editYN"));
			model.put("menu", getLabel(request, commonService)); // Label Setting

			setData.put("teamRoleID", request.getParameter("teamRoleID"));
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			Map teamRoleInfo = commonService.select("role_SQL.getTeamRoleItemMappingList_gridList", setData);
			model.put("teamRoleInfo", teamRoleInfo);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/rnrMatrix.do")
	public String rnrMatrix(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/rnrMatrix";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", cmmMap.get("s_itemID"));
			model.put("elmClassList", cmmMap.get("elmClassList"));
			
			String reqElmClassList[] = StringUtil.checkNull(cmmMap.get("elmClassList")).split(",");
			String elmClassList = "";
			if(!StringUtil.checkNull(cmmMap.get("elmClassList")).equals("")) {
				for(int i = 0; i<reqElmClassList.length; i++) {
					if(i == 0) {
						elmClassList = "'" + StringUtil.checkNull(reqElmClassList[i])+"'";
					}else {
						elmClassList = elmClassList + ",'" + StringUtil.checkNull(reqElmClassList[i]) + "'";
					}
				}
			}
			if(!elmClassList.equals("")) {
				cmmMap.put("elmClassList", elmClassList);
			}
			
			// accMode로 출력할 status 설정
			String accMode = StringUtil.checkNull(cmmMap.get("accMode"));
			model.put("accMode", accMode);
			if("DEV".equals(accMode) || "".equals(accMode)){
				cmmMap.put("asgnOption", "1,2"); //해제,해제중 미출력 & 신규, 릴리즈 출력
			}else {
				cmmMap.put("asgnOption", "2,3"); //해제,신규 미출력 & 릴리즈, 해제중 출력
			}
			List teamNameList = commonService.selectList("role_SQL.getTeamRoleTeamNameList", cmmMap);
			String treegridHeader = "";
			String treegridHeaderEx = "";
			String cols = "";
			for (int i = 0; i < teamNameList.size(); i++) {
				Map teamName = (Map) teamNameList.get(i);
				if (i > 0) {
					treegridHeader += ",{width:120, id:\"" +"T"+ StringUtil.checkNull(teamName.get("TeamID"))
							+ "\", type:\"string\", header:[{text:\"<span onClick='fnOpenTeamPop("+StringUtil.checkNull(teamName.get("TeamID"))+")'> " + StringUtil.checkNull(teamName.get("TeamNM"))
							+ "<img class='mgL3 mgR10' src='/cmm/common/images/detail.png' id='popup' style='width:12px; cursor:pointer;' alt='새창열기'></span>\", align: \"center\"}, { content: \"selectFilter\"}], align: \"center\", tooltipTemplate: rowDataTemplate"
							+ "}";
					
					treegridHeader += ",{hidden:true, width:100, id:\"" +"D"+ StringUtil.checkNull(teamName.get("TeamID"))
					+ "\", type:\"string\", header:[{text:\"" + StringUtil.checkNull(teamName.get("RoleDesc"))
					+ "\", align: \"center\"}], align: \"center\", htmlEnable: true"
					+ "}";
					
					treegridHeaderEx += ",{width:120, id:\"" +"T"+ StringUtil.checkNull(teamName.get("TeamID"))
					+ "\", type:\"string\", header:[{text:\""+ StringUtil.checkNull(teamName.get("TeamNM"))
					+ "\", align: \"center\"}, { content: \"selectFilter\"}], align: \"center\", tooltipTemplate: rowDataTemplate"
					+ "}";
			
					treegridHeaderEx += ",{hidden:true, width:100, id:\"" +"D"+ StringUtil.checkNull(teamName.get("TeamID"))
					+ "\", type:\"string\", header:[{text:\"" + StringUtil.checkNull(teamName.get("RoleDesc"))
					+ "\", align: \"center\"}], align: \"center\", htmlEnable: true"
					+ "}";
					
					cols += "|" + "T" + StringUtil.checkNull(teamName.get("TeamID")) + "|" + "D" + StringUtil.checkNull(teamName.get("TeamID"));
				} else {
					treegridHeader = "{width:120, id:\"" + "T" +StringUtil.checkNull(teamName.get("TeamID"))
							+ "\", type:\"string\", header:[{text:\"<span onClick='fnOpenTeamPop("+StringUtil.checkNull(teamName.get("TeamID"))+")'>" + StringUtil.checkNull(teamName.get("TeamNM"))
							+ "<img class='mgL3 mgR10' src='/cmm/common/images/detail.png' id='popup' style='width:12px; cursor:pointer;' alt='새창열기'></span>\", align: \"center\"}, { content: \"selectFilter\"}], align: \"center\" , tooltipTemplate: rowDataTemplate"
							+ "}";
					treegridHeader += ",{hidden:true, width:100, id:\"" + "D" +StringUtil.checkNull(teamName.get("TeamID"))
					+ "\", type:\"string\", header:[{text:\"" + StringUtil.checkNull(teamName.get("RoleDesc"))
					+ "\", align: \"center\"}], align: \"center\" , htmlEnable: true"
					+ "}";
					
					treegridHeaderEx = "{width:120, id:\"" + "T" +StringUtil.checkNull(teamName.get("TeamID"))
					+ "\", type:\"string\", header:[{text:\""+ StringUtil.checkNull(teamName.get("TeamNM"))
					+ "\", align: \"center\"}, { content: \"selectFilter\"}], align: \"center\" , tooltipTemplate: rowDataTemplate"
					+ "}";
					treegridHeaderEx += ",{hidden:true, width:100, id:\"" + "D" +StringUtil.checkNull(teamName.get("TeamID"))
					+ "\", type:\"string\", header:[{text:\"" + StringUtil.checkNull(teamName.get("RoleDesc"))
					+ "\", align: \"center\"}], align: \"center\" , htmlEnable: true"
					+ "}";
					
					cols = "|" + "T" +StringUtil.checkNull(teamName.get("TeamID"))+ "|" + "D" + StringUtil.checkNull(teamName.get("TeamID"));
				}
			}
			
			model.put("treegridHeader", treegridHeader);
			model.put("treegridHeaderEx", treegridHeaderEx);
			model.put("cols", cols);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	public static void returnTreeGridJsonV7(List list, final String[] cols, HttpServletResponse res,
			final String contextPath, String s_itemID) {
		sendToJsonV7(parseTreeGridJsonV7(list, cols, contextPath, s_itemID), res);
	}

	public static void sendToJsonV7(String jObj, HttpServletResponse res) {
		try {
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if (!jObj.equals("{rows: [ ]}")) {
				res.getWriter().print(jObj);
			} else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}

			System.out.println("json Object :" + jObj);

		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}

	public static String parseTreeGridJsonV7(List list, final String[] cols, final String contextPath,
			String s_itemID) {
		final String OPEN = "[";
		final String COT = "\"";
		final String COMMA = ",";
		final String CLOSE = "]";
		final String BOPEN = "{";
		final String BClOSE = "}";
		final String COL = ":";

		StringBuffer result = new StringBuffer();

		if (list != null && list.size() > 0 && cols != null && cols.length > 0) {
			result.append(OPEN);
			for (int i = 0; i < list.size(); i++) {
				if (i != 0) {
					result.append(COMMA);
				}
				Map map = (Map) list.get(i);
				result.append(BOPEN);
				int j = 0;
				for (String string : cols) {
					if (j > 0 && !StringUtil.checkNull(map.get(string)).equals("")) {
						result.append(COMMA);
					}

					if (!StringUtil.checkNull(map.get(string)).equals("")) {
						result.append(COT).append(string).append(COT).append(COL);
						if (string.equals("TREE_NM")) {
							if (StringUtil.checkNull(map.get("ItemID")).equals(s_itemID)) {
								result.append(COT).append("<img src=/cmm/common/images/item/img_process.png>"
										+"<span onclick=fnOpenItemPop('"+StringUtil.checkNull(map.get("ItemID"))+"')><span class='identifier'>"+ get(map.get("Identifier"), contextPath) +"</span> "+ get(map.get(string), contextPath)+"</span>")
										.append(COT);
							} else {
								result.append(COT).append("<span onclick=fnOpenItemPop('"+StringUtil.checkNull(map.get("ItemID"))+"')><span class='identifier'>"
										+ get(map.get("Identifier"), contextPath) + "</span> "
										+ get(map.get(string), contextPath)+"</span>").append(COT);
							}
						} else {
							result.append(COT).append(get(map.get(string), contextPath)).append(COT);
						}
						j++;
					}
				}
				result.append(BClOSE);
			}
			result.append(CLOSE);
		}

		// System.out.println("result ::: >"+result);

		String resultData = result.toString().replaceAll("PRE_TREE_ID", "parent").replaceAll("TREE_ID", "id")
				.replaceAll("TREE_NM", "value").replaceAll("PRE_id", "parent").replaceAll(",,", ",");
		return resultData;
	}

	@RequestMapping(value = "/getDhtmlV7SubItemTeamRoleTreeGridList.do")
	public void getDhtmlV7SubItemTeamRoleTreeGridList(Map cmmMap, HttpServletResponse response) throws Exception {
		Map setMap = new HashMap();
		try {
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			
			String reqElmClassList[] = StringUtil.checkNull(cmmMap.get("elmClassList")).split(",");
			String elmClassList = "";
			if(!StringUtil.checkNull(cmmMap.get("elmClassList")).equals("")) {
				for(int i = 0; i<reqElmClassList.length; i++) {
					if(i == 0) {
						elmClassList = "'" + StringUtil.checkNull(reqElmClassList[i])+"'";
					}else {
						elmClassList = elmClassList + ",'" + StringUtil.checkNull(reqElmClassList[i]) + "'";
					}
				}
			}
			if(!elmClassList.equals("")) {
				setMap.put("elmClassList", elmClassList);
			}
			// accMode로 출력할 status 설정
			String accMode = StringUtil.checkNull(cmmMap.get("accMode"));
			setMap.put("accMode", accMode);
			if("DEV".equals(accMode) || "".equals(accMode)){
				setMap.put("asgnOption", "1,2"); //해제,해제중 미출력 & 신규, 릴리즈 출력
			}else {
				setMap.put("asgnOption", "2,3"); //해제,신규 미출력 & 릴리즈, 해제중 출력 
			}
				
			List<Map> subItemTeamRoleTreeGList = commonService.selectList("role_SQL.getSubItemTeamRoleTreeGList",setMap);

			if (subItemTeamRoleTreeGList.size() > 0) {

				for (int i = 0; i < subItemTeamRoleTreeGList.size(); i++) {
					Map roleMap = subItemTeamRoleTreeGList.get(i);
					String itemID = StringUtil.checkNull(roleMap.get("ItemID"));
					String teamIDs[] = StringUtil.checkNull(roleMap.get("TeamIDList")).split("/");

					setMap.put("itemID", itemID);
					for (int j = 0; j < teamIDs.length; j++) {
						setMap.put("teamID", teamIDs[j]);

						String roleTypeNm = StringUtil.checkNull(commonService.selectString("role_SQL.getTeamRoleName", setMap));
						roleMap.put("T"+teamIDs[j], roleTypeNm);
					}
					
					for (int j = 0; j < teamIDs.length; j++) {
						setMap.put("teamID", teamIDs[j]);

						String roleTypeDesc = StringUtil.checkNull(commonService.selectString("role_SQL.getTeamRoleDesc", setMap));
						roleMap.put("D"+teamIDs[j], roleTypeDesc);
					}
				}
			}

			String[] cols = ((String) cmmMap.get("cols")).split("[|]");

			returnTreeGridJsonV7(subItemTeamRoleTreeGList, cols, response, (String) cmmMap.get("contextPath"), s_itemID);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}

	private final static String IMG_NEW_SRC = "@{new}";
	private final static String IMG_NEW_TARGET_OPEN = "<img src='";
	private final static String IMG_NEW_TARGET_CLOSE = "/images/btn_star.gif' width='13' height='13' />";

	/**
	 * 엔터를 <br/>
	 * 로 변환한다.
	 * 
	 * @param object
	 * @return
	 */
	private static Object get(Object object, final String contextPath) {
		if (object == null) {
			return "";
		}
		if (object instanceof java.lang.String) {
			String result = StringUtil.replace((String) object, "\n", "<br/>");
			result = StringUtil.replace(result, IMG_NEW_SRC, IMG_NEW_TARGET_OPEN + contextPath + IMG_NEW_TARGET_CLOSE);
			result = StringUtil.replace(result, "\r", "<br/>");
			if (result.indexOf('"') != -1) {
				result = StringUtil.replace(result, "\"", "＂");
			}
			if (result.indexOf('\\') != -1) {
				result = StringUtil.replace(result, "\\", "/");
			}
			return result;
		}
		return object;
	}
	
	@RequestMapping(value = "/getTeamItemMappingList.do")
	public void getTeamItemMappingList(Map cmmMap, HttpServletResponse response) throws Exception {
		
		Map setMap = new HashMap();
		try {
			String companyID = StringUtil.checkNull(cmmMap.get("companyID"));
			String assigned = StringUtil.checkNull(cmmMap.get("assigned"));
			String teamRoleType = StringUtil.checkNull(cmmMap.get("teamRoleType"));
			
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("companyID",companyID);
			setMap.put("assigned",assigned);
			setMap.put("teamRoleType",teamRoleType);
			List<Map> teamList = commonService.selectList("role_SQL.getTeamListTeamRole", setMap);
			List<Map> teamRoleList = commonService.selectList("role_SQL.getTeamRoleItemMappingReportList", setMap);
					
			for (int i = 0; i < teamList.size(); i++) {
				Map teamMap = teamList.get(i);
				teamRoleList.add(teamMap);
			}
			
			String[] cols = ((String) cmmMap.get("cols")).split("[|]");

			returnReportTreeGridJsonV7(teamRoleList, cols, response, (String) cmmMap.get("contextPath"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	public static void returnReportTreeGridJsonV7(List list, final String[] cols, HttpServletResponse res, final String contextPath) {
		sendToJsonV7(parseReportTreeGridJsonV7(list, cols, contextPath), res);
	}
	
	public static String parseReportTreeGridJsonV7(List list, final String[] cols, final String contextPath) {
		final String OPEN = "[";
		final String COT = "\"";
		final String COMMA = ",";
		final String CLOSE = "]";
		final String BOPEN = "{";
		final String BClOSE = "}";
		final String COL = ":";

		StringBuffer result = new StringBuffer();

		if (list != null && list.size() > 0 && cols != null && cols.length > 0) {
			result.append(OPEN);
			for (int i = 0; i < list.size(); i++) {
				if (i != 0) {
					result.append(COMMA);
				}
				Map map = (Map) list.get(i);
				result.append(BOPEN);
				int j = 0;
				for (String string : cols) {
					if (j > 0 && !StringUtil.checkNull(map.get(string)).equals("")) {
						result.append(COMMA);
					}

					if (!StringUtil.checkNull(map.get(string)).equals("")) {
						result.append(COT).append(string).append(COT).append(COL);
						result.append(COT).append(get(map.get(string), contextPath)).append(COT);
						j++;
					}
				}
				result.append(BClOSE);
			}
			result.append(CLOSE);
		}

		String resultData = StringUtil.checkNull(result);
		//String resultData = result.toString().replaceAll("PRE_TREE_ID", "parent").replaceAll("TREE_ID", "id").replaceAll("TREE_NM", "value").replaceAll("PRE_id", "parent").replaceAll(",,", ",");
		return resultData;
	}
	
	@RequestMapping(value = "/rnrMatrixByRole.do")
	public String rnrMatrixByRole(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/rnrMatrixByRole";
		try {
			String grid = StringUtil.checkNull(request.getParameter("grid"));
			String activityOnly = StringUtil.checkNull(request.getParameter("activityOnly"));
			String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"));
			if(grid.equals("Y")) url = "/adm/role/rnrMatrixByRoleGrid";
			if(activityOnly.equals("Y")) cmmMap.put("classCode", "CL01006");
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", cmmMap.get("s_itemID"));
			model.put("elmClassList", cmmMap.get("elmClassList"));
			
			String reqElmClassList[] = StringUtil.checkNull(cmmMap.get("elmClassList")).split(",");
			String elmClassList = "";
			if(!StringUtil.checkNull(cmmMap.get("elmClassList")).equals("")) {
				for(int i = 0; i<reqElmClassList.length; i++) {
					if(i == 0) {
						elmClassList = "'" + StringUtil.checkNull(reqElmClassList[i])+"'";
					}else {
						elmClassList = elmClassList + ",'" + StringUtil.checkNull(reqElmClassList[i]) + "'";
					}
				}
			}
			if(!elmClassList.equals("")) {
				cmmMap.put("elmClassList", elmClassList);
			}
			
			List roleNameList = commonService.selectList("role_SQL.getRoleNameList", cmmMap);
			String treegridHeader = "";
			String treegridHeaderEx = "";
			String cols = "";
			String cxnCols = "";
			String attrCols = "";
			for (int i = 0; i < roleNameList.size(); i++) {
				Map roleItemInfo = (Map) roleNameList.get(i);
				if (i > 0) {
					treegridHeader += ",{width:120, id:\"" + StringUtil.checkNull(roleItemInfo.get("RoleItemID"))
							+ "\", type:\"string\", header:[{text:\"<span onClick='fnOpenItemPop("+StringUtil.checkNull(roleItemInfo.get("RoleItemID"))+")'>" + StringUtil.checkNull(roleItemInfo.get("RoleItemNM"))
							+ "<img class='mgL3 mgR10' src='/cmm/common/images/detail.png' id='popup' style='width:12px; cursor:pointer;' alt='새창열기'></span>\", align: \"center\"}], align: \"center\", tooltipTemplate: rowDataTemplate, "
							+ "htmlEnable : true, template : function (text, row, col) {"
							+ "if(text) {"
							+ "	let result = \"<span onclick='editPopup(\"+row[col.id+\"_CxnItemID\"]+\",\\\"\"+row[col.id]+\"\\\")' style='cursor:pointer;'>\"+text;"
							+	"	if(row[col.id+\"_Attr\"]) result += \"(\"+row[col.id+\"_Attr\"]+\")\";"
							+	"	result += \"</span>\" + \"<img class='mgL8 none' name='del-btn' src='/cmm/common/images/btn_file_del.png' style='width:12px; cursor:pointer;' onclick='delConnection(\"+col.id+\",\"+row.ItemID+\")'>\";"
							+ "	return result;"
							+ "}"
							+ "}"
							+ "}";
					treegridHeaderEx += ",{width:120, id:\"" + StringUtil.checkNull(roleItemInfo.get("RoleItemID"))
					+ "\", type:\"string\", header:[{text:\"" + StringUtil.checkNull(roleItemInfo.get("RoleItemNM"))
					+ "\", align: \"center\"}, { content: \"selectFilter\"}], align: \"center\", tooltipTemplate: rowDataTemplate"
					+ "}";
					
					cols += "|" + StringUtil.checkNull(roleItemInfo.get("RoleItemID"));
					cxnCols += "|" + StringUtil.checkNull(roleItemInfo.get("RoleItemID"))+"_CxnItemID";
					attrCols += "|" + StringUtil.checkNull(roleItemInfo.get("RoleItemID"))+"_Attr";
				} else {
					treegridHeader = "{width:120, id:\"" + StringUtil.checkNull(roleItemInfo.get("RoleItemID"))
							+ "\", type:\"string\", header:[{text:\"<span onClick='fnOpenItemPop("+StringUtil.checkNull(roleItemInfo.get("RoleItemID"))+")'>" + StringUtil.checkNull(roleItemInfo.get("RoleItemNM"))
							+ "<img class='mgL3 mgR10' src='/cmm/common/images/detail.png' id='popup' style='width:12px; cursor:pointer;' alt='새창열기'></span>\", align: \"center\"}], align: \"center\" , tooltipTemplate: rowDataTemplate, "
							+ "htmlEnable : true, template : function (text, row, col) {"
							+ "if(text) {"
							+ "	let result = \"<span onclick='editPopup(\"+row[col.id+\"_CxnItemID\"]+\",\\\"\"+row[col.id]+\"\\\")' style='cursor:pointer;'>\"+text;"
							+	"	if(row[col.id+\"_Attr\"]) result += \"(\"+row[col.id+\"_Attr\"]+\")\";"
							+	"	result += \"</span>\" + \"<img class='mgL8 none' name='del-btn' src='/cmm/common/images/btn_file_del.png' style='width:12px; cursor:pointer;' onclick='delConnection(\"+col.id+\",\"+row.ItemID+\")'>\";"
							+ "	return result;"
							+ "}"
							+ "}"
							+ "}";
					treegridHeaderEx = "{width:120, id:\"" + StringUtil.checkNull(roleItemInfo.get("RoleItemID"))
					+ "\", type:\"string\", header:[{text:\"" + StringUtil.checkNull(roleItemInfo.get("RoleItemNM"))
					+ "\", align: \"center\"}, { content: \"selectFilter\"}], align: \"center\" , tooltipTemplate: rowDataTemplate"
					+ "}";
					
					cols = "|" + StringUtil.checkNull(roleItemInfo.get("RoleItemID"));
					cxnCols += "|" + StringUtil.checkNull(roleItemInfo.get("RoleItemID"))+"_CxnItemID";
					attrCols += "|" + StringUtil.checkNull(roleItemInfo.get("RoleItemID"))+"_Attr";
				}
			}
			
			model.put("treegridHeader", treegridHeader);
			model.put("treegridHeaderEx", treegridHeaderEx);
			//System.out.println("treegridHeader :"+treegridHeader);
			model.put("cols", cols);
			model.put("cxnCols", cxnCols);
			model.put("attrCols", attrCols);
			model.put("cxnTypeList", StringUtil.checkNull(request.getParameter("cxnTypeList"), ""));
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);
			model.put("grid", grid);
			model.put("activityOnly", activityOnly);
			model.put("attrTypeCode", attrTypeCode);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/getRnrMatrixByRoleDataList.do")
	public void getRnrMatrixByRoleDataList(Map cmmMap, HttpServletResponse response) throws Exception {
		Map setMap = new HashMap();
		try {
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			String attrTypeCode = StringUtil.checkNull(cmmMap.get("attrTypeCode"),"");
			setMap.put("s_itemID", s_itemID);
			setMap.put("attrTypeCode", attrTypeCode);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			
			String reqElmClassList[] = StringUtil.checkNull(cmmMap.get("elmClassList")).split(",");
			String elmClassList = "";
			if(!StringUtil.checkNull(cmmMap.get("elmClassList")).equals("")) {
				for(int i = 0; i<reqElmClassList.length; i++) {
					if(i == 0) {
						elmClassList = "'" + StringUtil.checkNull(reqElmClassList[i])+"'";
					}else {
						elmClassList = elmClassList + ",'" + StringUtil.checkNull(reqElmClassList[i]) + "'";
					}
				}
			}
			if(!elmClassList.equals("")) {
				setMap.put("elmClassList", elmClassList);
			}
				
			List<Map> subItemRoleTreeGList = commonService.selectList("role_SQL.getSubItemRoleList",setMap);

			if (subItemRoleTreeGList.size() > 0) {

				for (int i = 0; i < subItemRoleTreeGList.size(); i++) {
					Map roleMap = subItemRoleTreeGList.get(i);
					String roleItemIDList[] = StringUtil.checkNull(roleMap.get("RoleItemIDList")).split("/");
					String RoleCxnClassList[] = StringUtil.checkNull(roleMap.get("RoleCxnClass")).split("#");
					String CxnItemIDList[] = StringUtil.checkNull(roleMap.get("CxnItemIDList")).split("/");
					String plainTextList[] = StringUtil.checkNull(roleMap.get("plainTextList")).split("/", -1);
					
					for (int j = 0; j < RoleCxnClassList.length; j++) {
						roleMap.put(roleItemIDList[j],RoleCxnClassList[j]);
						roleMap.put(roleItemIDList[j]+"_CxnItemID", CxnItemIDList[j]);
						if(plainTextList.length > 0 && !attrTypeCode.equals("")) {
							if(!plainTextList[j].equals("")) roleMap.put(roleItemIDList[j]+"_Attr", plainTextList[j]);
						}
					}
				}
			}

			String[] cols = ((String) cmmMap.get("cols")).split("[|]");

			returnTreeGridJsonV7(subItemRoleTreeGList, cols, response, (String) cmmMap.get("contextPath"), s_itemID);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	@RequestMapping(value = "/teamTaskInfoMgt.do")
	public String teamTaskInfoMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/teamTaskInfoMgt";
		HashMap setData = new HashMap();
		try {
			// teamID 변수 우선, sessionTeamID 차선
			String teamID = StringUtil.checkNull(request.getParameter("teamID"), StringUtil.checkNull(cmmMap.get("sessionTeamId")));
			String csrID = StringUtil.checkNull(request.getParameter("csrID"), StringUtil.checkNull(request.getParameter("curCsrID")));
			setData.put("projectID", csrID);
			setData.put("teamID", teamID);
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			setData.put("assignmentType", "JOBALLOCTP");
			
			Map teamTaskInfo = commonService.select("role_SQL.getTeamTaskInfo", setData);
			model.put("teamTaskInfo", teamTaskInfo);
						
			List teamTask = commonService.selectList("role_SQL.getMyAssignedRoleList_gridList",setData);
			JSONArray gridData = new JSONArray(teamTask);
			model.put("gridData",gridData);
			
			setData.put("pjtTeamID", StringUtil.checkNull(teamTaskInfo.get("PjtTeamID")));
			List teamJob = commonService.selectList("role_SQL.getTeamJobLog",setData);
			Map temp = new HashMap();
			temp.put("RNUM", "");
			temp.put("Activity", "");
			temp.put("Before", "");
			temp.put("After", "");
			temp.put("Type", "");
			temp.put("RelTeamNM", "");
			temp.put("Reason", "");
			teamJob.add(temp);
			JSONArray teamData = new JSONArray(teamJob);
			model.put("teamData",teamData);
			
			model.put("projectID", csrID);
			model.put("teamID", teamID);
			model.put("pjtTeamID", StringUtil.checkNull(teamTaskInfo.get("PjtTeamID")));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/editTeamTask.do", produces = "application/text; charset=utf-8")
	public void editTeamTask(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		JSONArray result = new JSONArray();
		Map setData = new HashMap();
		try {
			String teamMemo = StringUtil.checkNull(request.getParameter("teamMemo"));
			String changeLog = StringUtil.checkNull(request.getParameter("changeLog"));
			
			if(teamMemo != null) {
				setData.put("memo", teamMemo);
				setData.put("changeLog", changeLog);
				setData.put("status","WIP");
				setData.put("projectID", StringUtil.checkNull(request.getParameter("projectID")));
				setData.put("teamID", StringUtil.checkNull(request.getParameter("teamID")));
				
				commonService.update("project_SQL.updatePjtTeamRel", setData);
			}	
		} catch (Exception e) {
			System.out.println(e);
		}
	}
	
	@RequestMapping(value = "/editMbrTask.do", produces = "application/text; charset=utf-8")
	public void editMbrTask(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		JSONArray result = new JSONArray();
		Map setData = new HashMap();
		try {
			setData.put("projectID", StringUtil.checkNull(request.getParameter("projectID")));
			setData.put("teamID", StringUtil.checkNull(request.getParameter("teamID")));
			setData.put("status", "WIP");
			
			String assignedValue = StringUtil.checkNull(request.getParameter("assignedValue"));
			if(assignedValue != "") {
				setData.put("assigned", assignedValue);
				setData.put("status", "CMP");
			}
			commonService.update("project_SQL.updatePjtTeamRel", setData);			
			
			JSONArray jsonArray  = new JSONArray(request.getParameter("editedRow"));			
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jo = (JSONObject)jsonArray.get(i);
				setData.put("seq",StringUtil.checkNull(jo.get("Seq")));
				setData.put("memo",StringUtil.checkNull(jo.get("Memo")));
				commonService.update("role_SQL.updateRoleAssignment", setData);
			}
			response.setCharacterEncoding("UTF-8");
			
			setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			setData.put("assignmentType", "JOBALLOCTP");
			
			List gridData = commonService.selectList("role_SQL.getMyAssignedRoleList_gridList",setData);
			result = new JSONArray(gridData);
			
		} catch (Exception e) {
			System.out.println(e);
		}
		response.getWriter().print(result);
	}
	
	@RequestMapping(value = "/getTmMbrTaskList.do", produces = "application/text; charset=utf-8")
	public void getTmMbrTaskList(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		JSONArray result = new JSONArray();
		Map setData = new HashMap();
		try {
			setData.put("teamID", StringUtil.checkNull(request.getParameter("teamID")));
			setData.put("projectID", StringUtil.checkNull(request.getParameter("projectID")));
			setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			setData.put("assignmentType", "JOBALLOCTP");
			
			response.setCharacterEncoding("UTF-8");			
			List reportData = commonService.selectList("role_SQL.tmMbrTaskList",setData);
			result = new JSONArray(reportData);
			
		} catch (Exception e) {
			System.out.println(e);
		}
		response.getWriter().print(result);
	}
	
	@RequestMapping(value = "/editTeamJobLog.do", produces = "application/text; charset=utf-8")
	public void editTeamJobLog(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		JSONArray result = new JSONArray();
		Map setData = new HashMap();
		try {
			setData.put("pjtTeamID",StringUtil.checkNull(request.getParameter("pjtTeamID")));
			JSONArray jsonArray  = new JSONArray(request.getParameter("editedRow"));			
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jo = (JSONObject)jsonArray.get(i);
				setData.put("activity",StringUtil.checkNull(jo.get("Activity")));
				setData.put("before",StringUtil.checkNull(jo.get("Before")));
				setData.put("after",StringUtil.checkNull(jo.get("After")));
				setData.put("type",StringUtil.checkNull(jo.get("Type")));
				setData.put("relTeamNM",StringUtil.checkNull(jo.get("RelTeamNM")));
				setData.put("reason",StringUtil.checkNull(jo.get("Reason")));
				setData.put("userID",StringUtil.checkNull(commandMap.get("sessionUserId")));
				
				String RNUM = StringUtil.checkNull(jo.get("RNUM"));
				if(RNUM.isEmpty()) {
					commonService.insert("role_SQL.insertTeamJobLog", setData);
				} else {
					setData.put("seq", StringUtil.checkNull(jo.get("SEQ")));
					commonService.update("role_SQL.updateTeamJobLog", setData);
				}
			}
			response.setCharacterEncoding("UTF-8");
			
			List teamJob = commonService.selectList("role_SQL.getTeamJobLog",setData);
			Map temp = new HashMap();
			temp.put("RNUM", "");
			temp.put("Activity", "");
			temp.put("Before", "");
			temp.put("After", "");
			temp.put("Type", "");
			temp.put("RelTeamNM", "");
			temp.put("Reason", "");
			teamJob.add(temp);
			result = new JSONArray(teamJob);
			
		} catch (Exception e) {
			System.out.println(e);
		}
		response.getWriter().print(result);
	}
	
	@RequestMapping(value = "/deleteTeamJobLog.do")
	public String deleteTeamJobLog(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String seq = StringUtil.checkNull(request.getParameter("seq"));		
				setMap.put("seq", seq);
				commonService.delete("role_SQL.deleteTeamJobLog", setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/downTeamTaskInfo.do")
	public String downTeamTaskInfo(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		HashMap target = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		try{
			Map setMap = new HashMap();
			String sheetTmpName = "";
			
			// teamID 변수 우선, sessionTeamID 차선
			String teamID = StringUtil.checkNull(request.getParameter("teamID"));
			String csrID = StringUtil.checkNull(request.getParameter("projectID"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
			setMap.put("projectID", csrID);
			setMap.put("teamID", teamID);
			setMap.put("languageID", languageID);
			setMap.put("assignmentType", "JOBALLOCTP");
			
			Map selectedTeamTaskInfo = commonService.select("role_SQL.getTeamTaskInfo", setMap);
			// 선택한 부서와 하위 부서 리스트
			List resultSub = commonService.selectList("role_SQL.getPjtSubTeamList", setMap);
			
			for(int i=0; i<resultSub.size(); i++){
				Map resultSubMap = (Map) resultSub.get(i);
				setMap.put("teamID", StringUtil.checkNull(resultSubMap.get("TeamID")));
				Map teamTaskInfo = commonService.select("role_SQL.getTeamTaskInfo", setMap);
				
				XSSFSheet sheet = wb.createSheet(StringUtil.checkNull(teamTaskInfo.get("teamName")));
				XSSFCellStyle titleStyle = setCellTitleSyle(wb);
				XSSFCellStyle headerStyle2 = setCellHeaderStyle2(wb);
				XSSFCellStyle contentsLeftStyle = setCellContentsStyleLeft(wb);
				XSSFCellStyle contentsCenterStyle = setCellContentsStyleCenter(wb);
				XSSFCellStyle underLine = setCellUnderline(wb);					

				//눈금선 없애기
				sheet.setDisplayGridlines(false);
				
				int cellIndex = 1;
				int rowIndex = 1;
				XSSFRow row = sheet.createRow(rowIndex);
				XSSFCell cell = null;
				
				//sheet.setDefaultColumnWidth(3500);
				sheet.setColumnWidth((short)0,(short)300);
				sheet.setColumnWidth((short)13,(short)3500);
				
				row = sheet.createRow(0);
				
				row = sheet.createRow(rowIndex++);
				cell = row.createCell(cellIndex);
				cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle2); cell.setCellValue("부서 직무");
				sheet.addMergedRegion(new CellRangeAddress(rowIndex-1,rowIndex-1,2,12));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(teamTaskInfo.get("itemNames")));
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				
				cellIndex = 1;
				row = sheet.createRow(rowIndex++);
				row.setHeight((short) 2000);
				cell = row.createCell(cellIndex);
				cell = row.createCell(cellIndex++); cell.setCellStyle(headerStyle2); cell.setCellValue("부서과업");
				sheet.addMergedRegion(new CellRangeAddress(rowIndex-1,rowIndex-1,2,12));
				cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(teamTaskInfo.get("Memo")));
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				rowIndex++;
				
				cellIndex = 1;
				row = sheet.createRow(rowIndex++);
				cell = row.createCell(cellIndex++);
				
				XSSFFont font= wb.createFont();
				font.setUnderline(XSSFFont.U_SINGLE);
				cell.setCellValue("변경 내역");
				//
				cellIndex = 1;
				row = sheet.createRow(rowIndex++);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("No");
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("업무");
				sheet.addMergedRegion(new CellRangeAddress(rowIndex-1,rowIndex-1,3,6));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("변경 전");
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				sheet.addMergedRegion(new CellRangeAddress(rowIndex-1,rowIndex-1,7,10));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("변경 후");
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("구분");				
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("이관부서");
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("사유");
				
				setMap.put("pjtTeamID", StringUtil.checkNull(resultSubMap.get("PjtTeamID")));
				List teamJobLog = commonService.selectList("role_SQL.getTeamJobLog", setMap);
				for(int j=0; j<teamJobLog.size(); j++) {
					Map logMap = (Map) teamJobLog.get(j);
					cellIndex = 1;
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(logMap.get("RNUM")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(logMap.get("Activity")));
					sheet.addMergedRegion(new CellRangeAddress(rowIndex-1,rowIndex-1,3,6));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(logMap.get("Before")));
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					sheet.addMergedRegion(new CellRangeAddress(rowIndex-1,rowIndex-1,7,10));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(logMap.get("After")));
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(logMap.get("Type")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(logMap.get("RelTeamNM")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(logMap.get("Reason")));
				}
				rowIndex++;
				
				cellIndex = 1;
				row = sheet.createRow(rowIndex++);
				cell = row.createCell(cellIndex++);
				
				font.setUnderline(XSSFFont.U_SINGLE);
				cell.setCellValue("부서원 Task");
				//
				cellIndex = 1;
				row = sheet.createRow(rowIndex++);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("No");
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("Name");
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("직위");
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("사번");
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("입사일자");
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("직무");
				sheet.addMergedRegion(new CellRangeAddress(rowIndex-1,rowIndex-1,7,13));
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);		cell.setCellValue("과업");
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				cell = row.createCell(cellIndex++);		cell.setCellStyle(headerStyle2);
				
				List teamTask = commonService.selectList("role_SQL.getMyAssignedRoleList_gridList", setMap);
				for(int j=0; j<teamTask.size(); j++) {
					Map taskMap = (Map) teamTask.get(j);
					cellIndex = 1;
					row = sheet.createRow(rowIndex++);
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(taskMap.get("RNUM")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(taskMap.get("Name")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(taskMap.get("Position")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(taskMap.get("EmployeeNum")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsCenterStyle); cell.setCellValue(StringUtil.checkNull(taskMap.get("joinDate")));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(taskMap.get("ItemName")));
					sheet.addMergedRegion(new CellRangeAddress(rowIndex-1,rowIndex-1,7,13));
					cell = row.createCell(cellIndex++); cell.setCellStyle(contentsLeftStyle); cell.setCellValue(StringUtil.checkNull(taskMap.get("Memo")));
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
					cell = row.createCell(cellIndex++);	cell.setCellStyle(contentsLeftStyle);
				}
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			String itemName = "직능조직도_"+StringUtil.checkNull(selectedTeamTaskInfo.get("teamName"));
			String selectedItemName1 = new String(itemName.getBytes("UTF-8"), "ISO-8859-1");
			String selectedItemName2 = new String(selectedItemName1.getBytes("8859_1"), "UTF-8");
			
			String orgFileName1 = selectedItemName1 + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = selectedItemName2 + "_" + formatter.format(date) + ".xlsx";
			String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
			String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
			
			File file = new File(downFile2);			
			fileOutput =  new FileOutputStream(file);
			wb.write(fileOutput);
			
			HashMap drmInfoMap = new HashMap();
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			drmInfoMap.put("orgFileName", orgFileName2);
			drmInfoMap.put("downFile", downFile2);
			
			// file DRM 적용
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
			if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
				drmInfoMap.put("funcType", "report");
				DRMUtil.drmMgt(drmInfoMap);
			}
			
			target.put(AJAX_SCRIPT, "doFileDown('"+orgFileName1+"', 'excel');$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		} finally {
			if(fileOutput != null) fileOutput.close();
			wb = null;
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);	
	}
	
	private XSSFCellStyle setCellTitleSyle(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		
		style.setFillForegroundColor(new XSSFColor(new Color(22, 54, 92)));
		style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 11);
		font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("맑은 고딕");
		font.setColor(HSSFColor.WHITE.index);
		style.setFont(font);
		
		return style;
	}
	
	private XSSFCellStyle setCellHeaderStyle2(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		
		style.setFillForegroundColor(new XSSFColor(new Color(220, 230, 241)));
		style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
				
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 11);
		font.setFontName("맑은 고딕");
		style.setFont(font);
		
		return style;
	}
	
	private XSSFCellStyle setCellContentsStyleLeft(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		 
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setWrapText(true);
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 10);
		font.setFontName("맑은 고딕");
		style.setFont(font);
		 
		return style;
	}
	
	private XSSFCellStyle setCellContentsStyleCenter(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		 
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setAlignment(XSSFCellStyle.ALIGN_CENTER);
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 10);
		font.setFontName("맑은 고딕");
		style.setFont(font);
		 
		return style;
	}
	
	private XSSFCellStyle setCellUnderline(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		
		XSSFFont font= wb.createFont();
		font.setUnderline(XSSFFont.U_SINGLE);
		style.setFont(font);
		
		return style;
	}
	
	@RequestMapping(value = "olmRoleMbrList.do")
	public String olmRoleMbrList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/olmRoleMbrList";
		HashMap setData = new HashMap();
		String varFilter = "";
		try {
			model.put("menu", getLabel(request, commonService)); // Label Setting			
			setData.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			Map itemAuthInfo = commonService.select("item_SQL.getItemAuthority", setData);
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("itemIDAuthorID", StringUtil.checkNull(itemAuthInfo.get("AuthorID")));
			model.put("assignmentType", StringUtil.checkNull(request.getParameter("varFilter")));			
			model.put("blankPhotoUrlPath", GlobalVal.HTML_IMG_DIR + "/blank_photo.png");	
			model.put("photoUrlPath", GlobalVal.EMP_PHOTO_URL);	
			
			setData.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			setData.put("isAll", "N");
			setData.put("assignmentType", StringUtil.checkNull(request.getParameter("varFilter")));	
			setData.put("blankPhotoUrlPath", GlobalVal.HTML_IMG_DIR + "/blank_photo.png");	
			setData.put("photoUrlPath", GlobalVal.EMP_PHOTO_URL);	
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			List assignedRoleList = commonService.selectList("role_SQL.getOlmRoleMbrList_gridList",setData);
			JSONArray gridData = new JSONArray(assignedRoleList);
			model.put("gridData", gridData);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/espRoleMbrList.do")
	public String srRoleAssignment(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/espRoleMbrList";
		HashMap setData = new HashMap();
		String varFilter = "";
		try {
			model.put("menu", getLabel(request, commonService)); // Label Setting			
			
			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			setData.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			
			model.put("blankPhotoUrlPath", GlobalVal.HTML_IMG_DIR + "/blank_photo.png");	
			model.put("photoUrlPath", GlobalVal.EMP_PHOTO_URL);	
			
			// role 권한 체크
			setData.put("isAll", "N");
			setData.put("assignmentType", "CNGROLETP");
			setData.put("assigned", "1");
			
			String editYN = "N";
			List roleList = commonService.selectList("role_SQL.getAssignedRoleList_gridList", setData);
			if(roleList != null) {
				for(int i=0; i < roleList.size(); i++) {
					Map temp = (Map)roleList.get(i);
					String memberID = StringUtil.checkNull(temp.get("MemberID"));
					if(memberID.equals(sessionUserId)){
						editYN = "Y";
						break;
					}
				}
			}
			model.put("editYN",editYN);
			
			// itemID 를 통해서 clientID 가져오기
			String chkClientID = StringUtil.checkNull(request.getParameter("chkClientID"));
			if("Y".equals(chkClientID)){
				String clientID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemClientID", setData));
				model.put("clientID", clientID);
			}
	        
	        model.put("assignmentType", StringUtil.checkNull(request.getParameter("varFilter")));
	        model.put("myClient", StringUtil.checkNull(request.getParameter("myClient")));
	        model.put("notCompanyIDs", StringUtil.checkNull(request.getParameter("notCompanyIDs")));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/editESPGroupALL.do")
	public String editESPGroupALL(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/editESPGroupALLPop";
		HashMap setData = new HashMap();
		String varFilter = "";
		try {
			model.put("menu", getLabel(request, commonService)); // Label Setting			
			
			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			model.put("clientID", StringUtil.checkNull(request.getParameter("clientID")));
			setData.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			
			// role 권한 체크
			setData.put("isAll", "N");
			setData.put("assignmentType", "CNGROLETP");
			setData.put("assigned", "1");
			
			String editYN = "N";
			List roleList = commonService.selectList("role_SQL.getAssignedRoleList_gridList", setData);
			if(roleList != null) {
				for(int i=0; i < roleList.size(); i++) {
					Map temp = (Map)roleList.get(i);
					String memberID = StringUtil.checkNull(temp.get("MemberID"));
					if(memberID.equals(sessionUserId)){
						editYN = "Y";
						break;
					}
				}
			}
			model.put("editYN",editYN);
			model.put("assignmentType", StringUtil.checkNull(cmmMap.get("assignmentType")));
			model.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			model.put("clientID", StringUtil.checkNull(request.getParameter("clientID")));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
}
