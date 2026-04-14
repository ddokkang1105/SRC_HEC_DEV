package xbolt.app.olmv4.web;

import com.org.json.JSONException;
import com.org.json.JSONObject;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.concurrent.CompletableFuture;

@Controller
@SuppressWarnings("unchecked")
public class olmV4ActionControllerV4 extends XboltController{
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/roleMindMapV4.do")
	public String roleMindMapV4(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "app/olmv4/roleMindMapV4";
		try {
			model.put("menu", getLabel(request, commonService));
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			model.put("s_itemID", s_itemID);

		} catch (Exception e) {
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	/**
	 * roleMindMapV4 - roleMindMap 조회
	 */
	@RequestMapping(value = "/getRoleMindMapDataV4.do", method = RequestMethod.GET)
	public void getRoleMindMapDataV4(HttpServletRequest request, HttpServletResponse response) throws Exception {

		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");

		JSONObject resultMap = new JSONObject();
		Map<String, Object> dataMap = new HashMap<>();

		boolean success = false;

		try {
			final String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			final String languageID = StringUtil.checkNull(request.getParameter("languageID"));

			if (s_itemID.isEmpty()) throw new IllegalArgumentException("s_itemID is required.");
			if (languageID.isEmpty()) throw new IllegalArgumentException("languageID is required.");

			List<Map<String, Object>> diagramList = Collections.synchronizedList(new ArrayList<>());
			List<String> rightItems = Collections.synchronizedList(new ArrayList<>());
			List<String> leftItems  = Collections.synchronizedList(new ArrayList<>());

			// -----------------------------------------------------------------------
			// Root 정보 조회
			// -----------------------------------------------------------------------
			CompletableFuture<Void> rootTask = CompletableFuture.runAsync(() -> {
				try {
					Map<String, Object> param = new HashMap<>();
					param.put("s_itemID", s_itemID);
					param.put("languageID", languageID);

					Map itemInfo = commonService.select("attr_SQL.getItemNameInfo", param);
					if (itemInfo != null) {
						String rootText = StringUtil.checkNull(itemInfo.get("Identifier")) + " " + StringUtil.checkNull(itemInfo.get("PlainText"));
						diagramList.add(createNode(s_itemID, rootText, null, "#0288D1", "#0288D1", "#FFFFFF"));
					}
				} catch (Exception e) { e.printStackTrace(); }
			});

			// -----------------------------------------------------------------------
			// Process + CXN (RIGHT)
			// -----------------------------------------------------------------------
			CompletableFuture<Void> rightTask = CompletableFuture.runAsync(() -> {
				try {
					Map<String, Object> param = new HashMap<>();
					param.put("s_itemID", s_itemID);
					param.put("languageID", languageID);
					param.put("showElement", "Y");
					param.put("mdlIF", "Y");
					param.put("ClassCode", "CL01005");

					List processList = commonService.selectList("item_SQL.getCxnItemList_gridList", param);

					if (processList != null) {

						processList.parallelStream().forEach(obj -> {
							Map process = (Map) obj;
							String processID = StringUtil.checkNull(process.get("s_itemID"));
							String processText = StringUtil.checkNull(process.get("Identifier")) + " " + StringUtil.checkNull(process.get("ItemName"));

							List<Map<String, Object>> localNodes = new ArrayList<>();
							List<String> localRight = new ArrayList<>();

							localNodes.add(createNode(processID, processText, s_itemID, "#11B3A5", "#11B3A5", "#FFFFFF"));
							localRight.add(processID);

							try {
								Map<String, Object> subParam = new HashMap<>();
								subParam.put("s_itemID", processID);
								subParam.put("languageID", languageID);

								List cxnItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", subParam);

								if (cxnItemList != null) {
									Set<String> classSet = new HashSet<>();
									for (Object cxnObj : cxnItemList) {
										Map cxnMap = (Map) cxnObj;
										if ("OJ00002".equals(cxnMap.get("ItemTypeCode"))) continue;

										String classCode = StringUtil.checkNull(cxnMap.get("ClassCode"));
										String className = StringUtil.checkNull(cxnMap.get("ClassName"));
										String cxnID = StringUtil.checkNull(cxnMap.get("s_itemID"));
										String cxnText = StringUtil.checkNull(cxnMap.get("Identifier")) + " " + StringUtil.checkNull(cxnMap.get("ItemName"));

										String classNodeId = "CLS_" + processID + "_" + classCode;

										if (classSet.add(classCode)) {
											localNodes.add(createNode(classNodeId, className, processID, "#a5a5a5", "#a5a5a5", "#FFFFFF"));
										}
										localNodes.add(createNode("4d_" + processID + "_" + cxnID, cxnText, classNodeId, "#ffffff", "#5569b1", "#000000"));
									}
								}

								diagramList.addAll(localNodes);
								rightItems.addAll(localRight);

							} catch (Exception e) { e.printStackTrace(); }
						});
					}
				} catch (Exception e) { e.printStackTrace(); }
			});

			// -----------------------------------------------------------------------
			// Role (LEFT)
			// -----------------------------------------------------------------------
			CompletableFuture<Void> leftTask = CompletableFuture.runAsync(() -> {
				try {
					Map<String, Object> param = new HashMap<>();
					param.put("itemID", s_itemID);
					param.put("assigned", "1");
					param.put("teamRoleCat", "CNGROLETEP");
					param.put("roleType", "EXE");

					List roleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", param);

					if (roleList != null) {
						for (Object obj : roleList) {
							Map role = (Map) obj;
							String teamID = StringUtil.checkNull(role.get("TeamID"));
							String teamName = StringUtil.checkNull(role.get("TeamNM"));

							diagramList.add(createNode("tr_" + teamID, teamName, s_itemID, "#ff9800", "#ff9800", "#FFFFFF"));
							leftItems.add("tr_" + teamID);
						}
					}
				} catch (Exception e) { e.printStackTrace(); }
			});

			CompletableFuture.allOf(rootTask, leftTask, rightTask).join();

			dataMap.put("diagramListData", diagramList);
			dataMap.put("leftItems", leftItems);
			dataMap.put("rightItems", rightItems);

			resultMap.put("data", dataMap);
			success = true;

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
				response.getWriter().print(resultMap);
			} catch (Exception e) {
				System.err.println(e.getMessage());
			}
		}
	}

	private Map<String, Object> createNode(String id, String text, String parent, String fill, String stroke, String fontColor) {
		Map<String, Object> node = new HashMap<>();
		node.put("id", id);
		node.put("text", text);
		if (parent != null) node.put("parent", parent);
		node.put("fill", fill);
		node.put("stroke", stroke);
		node.put("fontColor", fontColor);
		return node;
	}
}
