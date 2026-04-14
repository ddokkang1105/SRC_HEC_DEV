package xbolt.adm.role.web;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONException;
import com.org.json.JSONObject;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import xbolt.adm.role.dto.RoleDTO;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
public class RoleActionControllerV4 extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value = "/rnrMatrixV4.do")
	public String rnrMatrixV4(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/rnrMatrixV4";
		try {
			
			// role : byRole ( 기존 rnrMatrixByRole ) | team : byTeam ( 기존 rnrMatrix )
			String type = StringUtil.checkNull(request.getParameter("type"));
			model.put("type",type);
			
			String grid = StringUtil.checkNull(request.getParameter("grid"));
			if(grid.equals("Y")) url = "/adm/role/rnrMatrixByRoleGrid";
			model.put("grid", grid);
			
			String activityOnly = StringUtil.checkNull(request.getParameter("activityOnly"));
			String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"));
			model.put("activityOnly", activityOnly);
			model.put("attrTypeCode", attrTypeCode);
			
			model.put("menu", getLabel(request, commonService));
			model.put("s_itemID", cmmMap.get("s_itemID"));
			model.put("elmClassList", cmmMap.get("elmClassList"));
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);
			
			// accMode로 출력할 status 설정
			String accMode = StringUtil.checkNull(request.getParameter("accMode"));
			model.put("accMode", accMode);
			

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/roleAssignmentV4.do")
	public String roleAssignmentV4(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/roleAssignmentV4";
		HashMap setData = new HashMap();
		try {
			
			// 권한 체크
			setData.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			Map itemAuthInfo = commonService.select("item_SQL.getItemAuthority", setData);
			model.put("itemIDAuthorID", StringUtil.checkNull(itemAuthInfo.get("AuthorID")));
			
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("assignmentType", StringUtil.checkNull(request.getParameter("varFilter")));			
			model.put("blankPhotoUrlPath", GlobalVal.HTML_IMG_DIR + "/blank_photo.png");	
			model.put("photoUrlPath", GlobalVal.EMP_PHOTO_URL);	
			model.put("searchOption", StringUtil.checkNull(request.getParameter("searchOption")));
			model.put("menu", getLabel(request, commonService)); // Label Setting			
			
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/itemTeamRoleListV4.do")
	public String itemTeamRoleListV4(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/itemTeamRoleListV4";
		HashMap setData = new HashMap();
		try {
			
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			String isSubItem = StringUtil.checkNull(cmmMap.get("isSubItem"));
			String teamRoleCat = StringUtil.checkNull(request.getParameter("varFilter"));
			String accMode = StringUtil.checkNull(cmmMap.get("accMode"));
			
			// 권한 체크
			setData.put("s_itemID", s_itemID);
			Map itemInfo = commonService.select("project_SQL.getItemInfo", setData);
			model.put("itemIDAuthorID", StringUtil.checkNull(itemInfo.get("AuthorID")));
			model.put("itemBlocked", StringUtil.checkNull(itemInfo.get("Blocked")));
			
			model.put("s_itemID", s_itemID);
			model.put("isSubItem", isSubItem);
			model.put("teamRoleCat", teamRoleCat);
			model.put("accMode", accMode);
			model.put("menu", getLabel(request, commonService)); // Label Setting
			
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/goTeamRoleDetailPop.do")
	public String goTeamRoleDetailPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/role/teamRoleDetailPop";
		HashMap setData = new HashMap();

		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));

			String rowData = request.getParameter("rowData");
			ObjectMapper mapper = new ObjectMapper();
			Map teamRoleInfo = mapper.readValue(rowData, Map.class);

			model.put("teamRoleInfo", teamRoleInfo);
			model.put("s_itemID", s_itemID);
			model.put("menu", getLabel(request, commonService)); // Label Setting

		} catch (Exception e) {
			System.out.println("Detail Pop Error: " + e.toString());
		}

		return nextUrl(url);
	}
	
	// rnr header (Role) 조회
	@RequestMapping(value = "getRnRHeaderByRoleList.do", method = RequestMethod.GET)
	@ResponseBody
	public void getRnRHeaderByRoleList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		List roleNameList = new ArrayList();
		boolean success = false;
		
		try {
	        
			// parameter
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");		
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String elmClassList = StringUtil.checkNull(request.getParameter("elmClassList"), "");
			String activityOnly = StringUtil.checkNull(request.getParameter("activityOnly"), "");
			
			
			// parameter check
			if (s_itemID.isEmpty()) {
	             throw new IllegalArgumentException("s_itemID is required.");
	        }
			
			setMap.put("languageID",languageID);
			setMap.put("s_itemID",s_itemID);
			
			String reqElmClassList[] = elmClassList.split(",");
			if(!"".equals(elmClassList)) {
				for(int i = 0; i<reqElmClassList.length; i++) {
					if(i == 0) {
						elmClassList = "'" + StringUtil.checkNull(reqElmClassList[i])+"'";
					}else {
						elmClassList = elmClassList + ",'" + StringUtil.checkNull(reqElmClassList[i]) + "'";
					}
				}
			}
			
			if(!"".equals(elmClassList)) setMap.put("elmClassList", elmClassList);
			if(activityOnly.equals("Y")) setMap.put("classCode", "CL01006");
			
			roleNameList = commonService.selectList("role_SQL.getRoleNameList", setMap);
			
			success = true;
			resultMap.put("data", roleNameList);
			
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	// rnr sub item list 조회
	@RequestMapping(value = "getRnrMatrixByRoleSubDataList.do", method = RequestMethod.GET)
	@ResponseBody
	public void getRnrMatrixByRoleSubDataList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		List<Map> subItemRoleTreeGList = new ArrayList();
		boolean success = false;
		
		try {
	        
			// parameter
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");		
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String elmClassList = StringUtil.checkNull(request.getParameter("elmClassList"), "");
			String activityOnly = StringUtil.checkNull(request.getParameter("activityOnly"), "");
			String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"),"");
			
			// parameter check
			if (s_itemID.isEmpty()) {
	             throw new IllegalArgumentException("s_itemID is required.");
	        }
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("attrTypeCode", attrTypeCode);
			setMap.put("languageID", languageID);
			
			String reqElmClassList[] = elmClassList.split(",");
			if(!"".equals(elmClassList)) {
				for(int i = 0; i<reqElmClassList.length; i++) {
					if(i == 0) {
						elmClassList = "'" + StringUtil.checkNull(reqElmClassList[i])+"'";
					}else {
						elmClassList = elmClassList + ",'" + StringUtil.checkNull(reqElmClassList[i]) + "'";
					}
				}
			}
			if(!elmClassList.equals("")) setMap.put("elmClassList", elmClassList);
			if(activityOnly.equals("Y")) setMap.put("classCode", "CL01006");
				
			subItemRoleTreeGList = commonService.selectList("role_SQL.getSubItemRoleList",setMap);

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
			
			success = true;
			resultMap.put("data", subItemRoleTreeGList);
			
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	// rnr header (Team) 조회
	@RequestMapping(value = "getRnRHeaderByTeamList.do", method = RequestMethod.GET)
	@ResponseBody
	public void getRnRHeaderByTeamList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		List teamNameList = new ArrayList();
		boolean success = false;
		
		try {
	        
			// parameter
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");		
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String elmClassList = StringUtil.checkNull(request.getParameter("elmClassList"), "");
			String accMode = StringUtil.checkNull(request.getParameter("accMode"));
			
			// parameter check
			if (s_itemID.isEmpty()) {
	             throw new IllegalArgumentException("s_itemID is required.");
	        }
			
			if("DEV".equals(accMode) || "".equals(accMode)){
				setMap.put("asgnOption", "1,2"); //해제,해제중 미출력 & 신규, 릴리즈 출력
			}else {
				setMap.put("asgnOption", "2,3"); //해제,신규 미출력 & 릴리즈, 해제중 출력
			}
			
			setMap.put("languageID",languageID);
			setMap.put("s_itemID",s_itemID);
			
			String reqElmClassList[] = elmClassList.split(",");
			if(!"".equals(elmClassList)) {
				for(int i = 0; i<reqElmClassList.length; i++) {
					if(i == 0) {
						elmClassList = "'" + StringUtil.checkNull(reqElmClassList[i])+"'";
					}else {
						elmClassList = elmClassList + ",'" + StringUtil.checkNull(reqElmClassList[i]) + "'";
					}
				}
			}
			
			if(!"".equals(elmClassList)) setMap.put("elmClassList", elmClassList);
			
			teamNameList = commonService.selectList("role_SQL.getTeamRoleTeamNameList", setMap);
			
			success = true;
			resultMap.put("data", teamNameList);
			
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	// rnr sub item list 조회
	@RequestMapping(value = "getRnrMatrixByTeamSubDataList.do", method = RequestMethod.GET)
	@ResponseBody
	public void getRnrMatrixByTeamSubDataList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		List<Map> subItemTeamRoleTreeList = new ArrayList();
		List<Map> subItemTeamRoleInfoList = new ArrayList();
		Map subItemMap = new HashMap();
		
		boolean success = false;
		
		try {
	        
			// parameter
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");		
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String elmClassList = StringUtil.checkNull(request.getParameter("elmClassList"), "");
			String accMode = StringUtil.checkNull(request.getParameter("accMode"), "");
			
			// parameter check
			if (s_itemID.isEmpty()) {
	             throw new IllegalArgumentException("s_itemID is required.");
	        }
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", languageID);
			
			String reqElmClassList[] = elmClassList.split(",");
			if(!"".equals(elmClassList)) {
				for(int i = 0; i<reqElmClassList.length; i++) {
					if(i == 0) {
						elmClassList = "'" + StringUtil.checkNull(reqElmClassList[i])+"'";
					}else {
						elmClassList = elmClassList + ",'" + StringUtil.checkNull(reqElmClassList[i]) + "'";
					}
				}
			}
			if(!elmClassList.equals("")) setMap.put("elmClassList", elmClassList);
			
			// accMode로 출력할 status 설정
			setMap.put("accMode", accMode);
			if("DEV".equals(accMode) || "".equals(accMode)){
				setMap.put("asgnOption", "1,2"); //해제,해제중 미출력 & 신규, 릴리즈 출력
			}else {
				setMap.put("asgnOption", "2,3"); //해제,신규 미출력 & 릴리즈, 해제중 출력 
			}
				
			subItemTeamRoleTreeList = commonService.selectList("role_SQL.getNewSubItemTeamRoleTreeList",setMap);
			subItemTeamRoleInfoList = commonService.selectList("role_SQL.getSubItemTeamRoleInfoList",setMap);
			
			subItemMap.put("tree", subItemTeamRoleTreeList);
			subItemMap.put("info", subItemTeamRoleInfoList);
			
			/*
			String roleTypeNm = StringUtil.checkNull(commonService.selectString("role_SQL.getTeamRoleName", setMap));
			roleMap.put("T"+teamIDs[j], roleTypeNm);
			String roleTypeDesc = StringUtil.checkNull(commonService.selectString("role_SQL.getTeamRoleDesc", setMap));
			roleMap.put("D"+teamIDs[j], roleTypeDesc);
			*/
			
			success = true;
			resultMap.put("data", subItemMap);
			
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	// teamRole 조회
	@RequestMapping(value = "getTeamRoleMgtList.do", method = RequestMethod.GET)
	@ResponseBody
	public void getTeamRoleMgtList(RoleDTO roleDTO, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		List teamRoleMgtList = new ArrayList();
		boolean success = false;
		
		try {
	        
			// parameter check
			if (roleDTO.getTeamID().isEmpty()) {
	             throw new IllegalArgumentException("teamID is required.");
	        }
			
			ObjectMapper objectMapper = new ObjectMapper();
	        objectMapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.NONE);
	        objectMapper.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
	        setMap = objectMapper.convertValue(roleDTO, Map.class); // role 관련 dto
			
			teamRoleMgtList = commonService.selectList("role_SQL.getTeamRoleItemList_gridList", setMap);
			
			success = true;
			resultMap.put("data", teamRoleMgtList);
			
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	
}
