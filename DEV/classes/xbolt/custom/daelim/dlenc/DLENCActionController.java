package xbolt.custom.daelim.dlenc;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.JsonUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GetProperty;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.daelim.plant.EnsemblePlus.DLMWebServiceProxy;
import xbolt.custom.daelim.val.DaelimGlobalVal;
import xbolt.mdl.model.web.DiagramEditActionController;

/**
 * @Class Name : DaelimActionController.java
 * @Description : DaelimActionController.java
 * @Modification Information
 * @수정일 수정자 수정내용 @ David Lee @2024. 11.15 15. smartfactory 최초생성
 *
 * @since 2024. 11. 15
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class DLENCActionController extends XboltController {
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;

	@Autowired
	private DiagramEditActionController diagramEditActionController;

	@RequestMapping(value = "/zdlencRoleMindMap.do")
	public String zdlencroleMindMap(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/dlenc/item/zdlencRoleMindMap";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			Map setData = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String month = StringUtil.checkNull(request.getParameter("Month"));
			String filter = StringUtil.checkNull(request.getParameter("filter"));
			model.put("s_itemID", s_itemID);

			setData.put("s_itemID", s_itemID);
			setData.put("my_itemID", s_itemID);
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			setData.put("AType", "ZPAT007"); // Activity Type(MP/DP) attr
			setData.put("PreAttr", "ZPAT011"); // 선행(MP)(플랜트) attr
			setData.put("L1Attr", "ZPAT001"); // L1 구분(플랜트) attr
			setData.put("DoneSts", "ZPAT030"); // Done 진행사항 attr
			setData.put("STDDay", "ZPAT015"); // 기준일 attr
			setData.put("DRBegn", "ZPAT016"); // 착수 attr
			setData.put("month", month);
			setData.put("projectType", filter);// 주,토,플 구분자 (메뉴의 filter 파라미터, A/C/P)

			setData.put("itemID", s_itemID);
			String projectID = commonService.selectString("item_SQL.getProjectIDFromItem", setData); // Std, Site 구분
			setData.put("projectID", projectID);
			Map itemInfo = commonService.select("zDLENC_SQL.getRoleMindMapItemInfo", setData);
			List diagramList = new ArrayList();
			List rightItems = new ArrayList();

			String myProjectID = StringUtil.checkNull(itemInfo.get("ProjectID"));
			setData.put("projectID", myProjectID);// s_itemID의 프로젝트 ID
			List l1AttrList = (List) commonService.selectList("zDLENC_SQL.getPreAttr", setData);

			// 본인 프로세스
			String doneStatus = StringUtil.checkNull(itemInfo.get("DoneStatus"));
			String myL1Value = StringUtil.checkNull(itemInfo.get("MAP_VAXIS"));
			/*
			 * String myDept = StringUtil.checkNull(itemInfo.get("dept")); String mySTDDay =
			 * StringUtil.checkNull(itemInfo.get("STDDay")); String myDRBegn =
			 * StringUtil.checkNull(itemInfo.get("DRBegn"));
			 */

			Map itemMap = new HashMap();
			itemMap.put("id", s_itemID);
			itemMap.put("text", StringUtil.checkNull(itemInfo.get("ItemName")).replaceAll("&amp;", "&") + " (" + myL1Value + ")");

			switch (doneStatus) {
			case "DNP":
				itemMap.put("fill", "#FF0000");
				itemMap.put("stroke", "#FF0000");
				itemMap.put("fontColor", "#FFFFFF");
				break; // 빨간색
			case "DC":
				itemMap.put("fill", "#000000");
				itemMap.put("stroke", "#000000");
				itemMap.put("fontColor", "#FFFFFF");
				break; // 검정
			case "DP":
				itemMap.put("fill", "#00FF00");
				itemMap.put("stroke", "#00FF00");
				itemMap.put("fontColor", "#FFFFFF");
				break; // 초록
			default:
				itemMap.put("fill", "#FFFFFF");
				itemMap.put("stroke", "#5569b1");
				itemMap.put("fontColor", "#000000");
				break; // 기본 파란색
			}

			diagramList.add(itemMap);

			Set SetleftItems = new HashSet();
			Set l1Values = new HashSet();
			Set PreIdes = new HashSet();

			if (l1AttrList.size() > 0) {
				for (int i = 0; i < l1AttrList.size(); i++) {
					Map process = (Map) l1AttrList.get(i);

					// DB에서 색상 맵 조회
					List<HashMap> colorList = commonService.selectList("zDlenc_getMAP_VAXIS_COLOR", setData);
					Map<String, String> colorMap = new HashMap<>();
					for (HashMap map : colorList) {
						String code = StringUtil.checkNull(map.get("CD_MAP_VAXIS"));
						String color = StringUtil.checkNull(map.get("MAP_VAXIS_COLOR"));
						colorMap.put(code, color);
					}

					// 기존 process 리스트 처리
					String l1Value = StringUtil.checkNull(process.get("LovCode"));

					if (l1Value != null && !l1Value.isEmpty() && !l1Values.contains(l1Value)) {
						itemMap = new HashMap<>();
						itemMap.put("id", "PreL1_" + l1Value);
						itemMap.put("text", StringUtil.checkNull(process.get("Value")));
						itemMap.put("parent", s_itemID);

						// DB에서 색상 가져오기, 없으면 기본값
						String fillColor = colorMap.getOrDefault(l1Value, "#a5a5a5");
						String strokeColor = colorMap.getOrDefault(l1Value, "#FFFFFF");
						itemMap.put("fill", fillColor);
						itemMap.put("stroke", strokeColor);

						itemMap.put("fontColor", "#FFFFFF");
						diagramList.add(itemMap);

						l1Values.add(l1Value);
					}

					// 왼쪽 leftItems
					String leftItem = "'" + "PreL1_" + l1Value + "'";// 중복제거용
					if (!SetleftItems.contains(leftItem)) {
						SetleftItems.add(leftItem);
					}

					setData.put("s_itemID", StringUtil.checkNull(process.get("p_itemID")));
					List PreItemList = (List) commonService.selectList("zDLENC_SQL.getPreAttr", setData);

					String PreDSts = StringUtil.checkNull(process.get("DoneStatus"));
					String l1Id = "4p_" + StringUtil.checkNull(process.get("p_itemID"));
					if (!PreIdes.contains(l1Id)) {
						itemMap = new HashMap();
						itemMap.put("id", "4p_" + StringUtil.checkNull(process.get("p_itemID")));
						itemMap.put("text", StringUtil.checkNull(process.get("ItemName")));
						itemMap.put("parent", "PreL1_" + StringUtil.checkNull(process.get("LovCode")));

						switch (PreDSts) {
						case "DNP":
							itemMap.put("fill", "#FF0000");
							itemMap.put("stroke", "#FF0000"); // 빨간색
							itemMap.put("fontColor", "#ffffff");
							break;
						case "DC":
							itemMap.put("fill", "#000000");
							itemMap.put("stroke", "#000000"); // 검정
							itemMap.put("fontColor", "#ffffff");
							break;
						case "DP":
							itemMap.put("fill", "#00FF00");
							itemMap.put("stroke", "#00FF00"); // 초록
							itemMap.put("fontColor", "#ffffff");
							break;
						default:
							itemMap.put("fill", "#ffffff");
							itemMap.put("stroke", "#5569b1"); // 기본 흰색
							itemMap.put("fontColor", "#000000");
							break;
						}

						diagramList.add(itemMap);
						PreIdes.add(l1Id);
					}

					if (PreItemList.size() > 0) {
						for (int j = 0; j < PreItemList.size(); j++) {
							Map cxnMap = (Map) PreItemList.get(j);
							if (!cxnMap.get("ItemTypeCode").equals("OJ00002")) {
								String PrePDSts = StringUtil.checkNull(cxnMap.get("DoneStatus"));
								itemMap = new HashMap();
								itemMap.put("id", "4d_" + StringUtil.checkNull(process.get("p_itemID")) + "_"
										+ StringUtil.checkNull(cxnMap.get("p_itemID")));
								itemMap.put("text", StringUtil.checkNull(cxnMap.get("ItemName")));
								itemMap.put("parent", "4p_" + StringUtil.checkNull(process.get("p_itemID")));

								switch (PrePDSts) {
								case "DNP":
									itemMap.put("fill", "#FF0000");
									itemMap.put("stroke", "#FF0000"); // 빨간색
									itemMap.put("fontColor", "#ffffff");
									break;
								case "DC":
									itemMap.put("fill", "#000000");
									itemMap.put("stroke", "#000000"); // 검정
									itemMap.put("fontColor", "#ffffff");
									break;
								case "DP":
									itemMap.put("fill", "#00FF00");
									itemMap.put("stroke", "#00FF00"); // 초록
									itemMap.put("fontColor", "#ffffff");
									break;
								default:
									itemMap.put("fill", "#ffffff");
									itemMap.put("stroke", "#5569b1"); // 기본 흰색
									itemMap.put("fontColor", "#000000");
									break;
								}

								diagramList.add(itemMap);
							}
						}
					}
				}
			}

			// 후행 Activity
			setData.put("itemID", s_itemID);
			setData.put("prodeuctTypeAttr", "ZPAT005"); // 상품타입 ATTR
			setData.put("PTypeValue", "AMP"); // 상품타입 ATTR 값 암모니아(=AMP) 이제 플랜트도 myProjectID로 찾으니 빼도 되는지 확인하기
			setData.put("DoneSts", "ZPAT030"); // Done 진행사항 attr
			setData.put("month", month);
			setData.put("projectID", myProjectID);// s_itemID의 프로젝트 ID

			List postAttrList = commonService.selectList("zDLENC_SQL.getPostAttr", setData);

			Set Postl1Values = new HashSet();
			Set PostIdes = new HashSet();

			if (postAttrList.size() > 0) {
				for (int i = 0; i < postAttrList.size(); i++) {
					Map postProcess = (Map) postAttrList.get(i);

					// 오른쪽 L1 구분(플랜트)
					// DB에서 색상 맵 조회
					List<HashMap> colorList = commonService.selectList("zDlenc_getMAP_VAXIS_COLOR", setData);
					Map<String, String> colorMap = new HashMap<>();
					for (HashMap map : colorList) {
						String code = StringUtil.checkNull(map.get("CD_MAP_VAXIS"));
						String color = StringUtil.checkNull(map.get("MAP_VAXIS_COLOR"));
						colorMap.put(code, color);
					}

					// 기존 postProcess 리스트 처리
					String postL1Value = StringUtil.checkNull(postProcess.get("LovCode"));

					if (postL1Value != null && !postL1Value.isEmpty() && !Postl1Values.contains(postL1Value)) {
						itemMap = new HashMap<>();
						itemMap.put("id", "PostL1_" + postL1Value);
						itemMap.put("text", StringUtil.checkNull(postProcess.get("Value")));
						itemMap.put("parent", s_itemID);

						// DB에서 색상 가져오기, 없으면 기본값
						String fillColor = colorMap.getOrDefault(postL1Value, "#a5a5a5");
						String strokeColor = colorMap.getOrDefault(postL1Value, "#FFFFFF");
						itemMap.put("fill", fillColor);
						itemMap.put("stroke", strokeColor);

						itemMap.put("fontColor", "#FFFFFF");
						diagramList.add(itemMap);

						Postl1Values.add(postL1Value);

						// 오른쪽 rightItems
						String rightItem = "'" + "PostL1_" + StringUtil.checkNull(postProcess.get("LovCode")) + "'";// 중복제거용
						if (!rightItems.contains(rightItem)) {
							rightItems.add(rightItem);
						}

					}

					setData.put("itemID", StringUtil.checkNull(postProcess.get("p_itemID")));
					List postItemList = (List) commonService.selectList("zDLENC_SQL.getPostAttr", setData);

					String PostDSts = StringUtil.checkNull(postProcess.get("DoneStatus"));
					String Postl1Id = "4p_" + StringUtil.checkNull(postProcess.get("p_itemID"));
					if (!PostIdes.contains(Postl1Id)) {
						itemMap = new HashMap();
						itemMap.put("id", "4p_" + StringUtil.checkNull(postProcess.get("p_itemID")));
						itemMap.put("text", StringUtil.checkNull(postProcess.get("ItemName")));
						itemMap.put("parent", "PostL1_" + StringUtil.checkNull(postProcess.get("LovCode")));

						switch (PostDSts) {
						case "DNP":
							itemMap.put("fill", "#FF0000");
							itemMap.put("stroke", "#FF0000"); // 빨간색
							itemMap.put("fontColor", "#ffffff");
							break;
						case "DC":
							itemMap.put("fill", "#000000");
							itemMap.put("stroke", "#000000"); // 검정
							itemMap.put("fontColor", "#ffffff");
							break;
						case "DP":
							itemMap.put("fill", "#00FF00");
							itemMap.put("stroke", "#00FF00"); // 초록
							itemMap.put("fontColor", "#ffffff");
							break;
						default:
							itemMap.put("fill", "#ffffff");
							itemMap.put("stroke", "#5569b1"); // 기본 흰색
							itemMap.put("fontColor", "#000000");
							break;
						}

						diagramList.add(itemMap);
						PostIdes.add(Postl1Id);
					}

					if (postItemList.size() > 0) {
						for (int j = 0; j < postItemList.size(); j++) {
							Map postMap = (Map) postItemList.get(j);
							if (!postMap.get("ItemTypeCode").equals("OJ00002")) {
								String PostPDSts = StringUtil.checkNull(postMap.get("DoneStatus"));
								itemMap = new HashMap();
								itemMap.put("id", "4d_" + StringUtil.checkNull(postProcess.get("p_itemID")) + "_"
										+ StringUtil.checkNull(postMap.get("p_itemID")));
								itemMap.put("text", StringUtil.checkNull(postMap.get("ItemName")));
								itemMap.put("parent", "4p_" + StringUtil.checkNull(postProcess.get("p_itemID")));

								switch (PostPDSts) {
								case "DNP":
									itemMap.put("fill", "#FF0000");
									itemMap.put("stroke", "#FF0000"); // 빨간색
									itemMap.put("fontColor", "#ffffff");
									break;
								case "DC":
									itemMap.put("fill", "#000000");
									itemMap.put("stroke", "#000000"); // 검정
									itemMap.put("fontColor", "#ffffff");
									break;
								case "DP":
									itemMap.put("fill", "#00FF00");
									itemMap.put("stroke", "#00FF00"); // 초록
									itemMap.put("fontColor", "#ffffff");
									break;
								default:
									itemMap.put("fill", "#ffffff");
									itemMap.put("stroke", "#5569b1"); // 기본 흰색
									itemMap.put("fontColor", "#000000");
									break;
								}
								diagramList.add(itemMap);
							}
						}
					}
				}
			}

			JSONArray diagramListData = new JSONArray(diagramList);
			model.put("diagramListData", diagramListData);
			System.out.println("diagramListData :" + diagramListData);

			List leftItems = new ArrayList(SetleftItems);
			model.put("leftItems", leftItems);
			model.put("rightItems", rightItems);
			System.out.println("leftItems :" + leftItems);
			System.out.println("rightItems :" + rightItems);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/zdlencACRoleMindMap.do")
	public String zdlencACroleMindMap(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/dlenc/item/zdlencRoleMindMap";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			Map setData = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String month = StringUtil.checkNull(request.getParameter("Month"));
			String filter = StringUtil.checkNull(request.getParameter("filter"));
			model.put("s_itemID", s_itemID);

			setData.put("s_itemID", s_itemID);
			setData.put("my_itemID", s_itemID);
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			setData.put("AType", "ZPAT007"); // Activity Type(MP/DP) attr
			setData.put("PreAttr", "ZPAT011"); // 선행(MP)(플랜트) attr
			setData.put("L1Attr", "ZPAT001"); // L1 구분(플랜트) attr
			setData.put("DoneSts", "ZPAT030"); // Done 진행사항 attr
			setData.put("STDDay", "ZPAT015"); // 기준일 attr
			setData.put("DRBegn", "ZPAT016"); // 착수 attr
			setData.put("month", month);
			setData.put("projectType", filter);// 주,토,플 구분자 (메뉴의 filter 파라미터, A/C/P)
			setData.put("dept", "ZAT0003"); // 주관부서(who)

			Map itemInfo = commonService.select("zDLENC_SQL.getRoleMindMapItemInfo", setData);
			List diagramList = new ArrayList();
			List rightItems = new ArrayList();

			String myProjectID = StringUtil.checkNull(itemInfo.get("ProjectID"));
			setData.put("projectID", myProjectID);// s_itemID의 프로젝트 ID
			List l1AttrList = (List) commonService.selectList("zDLENC_SQL.getPreAttr", setData);

			// 본인 프로세스
			String doneStatus = StringUtil.checkNull(itemInfo.get("DoneStatus"));
			String myL1Value = StringUtil.checkNull(itemInfo.get("L1Value"));
			String myDept = StringUtil.checkNull(itemInfo.get("dept"));

			Map itemMap = new HashMap();
			itemMap.put("id", s_itemID);
			itemMap.put("text", StringUtil.checkNull(itemInfo.get("ItemName")) + " (" + myDept + ")");
			itemMap.put("fill", "#0288D1");
			itemMap.put("stroke", "#0288D1");
			itemMap.put("fontColor", "#FFFFFF");

			diagramList.add(itemMap);

			Set SetleftItems = new HashSet();
			Set l1Values = new HashSet();
			Set PreIdes = new HashSet();

			if (l1AttrList.size() > 0) {
				for (int i = 0; i < l1AttrList.size(); i++) {
					Map process = (Map) l1AttrList.get(i);
					// 주토 주관부서 구분
					String preDept = StringUtil.checkNull(process.get("preDept"));

					if (!l1Values.contains(preDept)) {
						itemMap = new HashMap();
						itemMap.put("id", "PreL1_" + StringUtil.checkNull(process.get("preDept")));
						itemMap.put("text", StringUtil.checkNull(process.get("preDept")));
						itemMap.put("parent", s_itemID);
						itemMap.put("fill", "#a5a5a5"); // 기본 회색
						itemMap.put("stroke", "#FFFFFF");
						itemMap.put("fontColor", "#FFFFFF");
						diagramList.add(itemMap);

						l1Values.add(preDept);

						// 왼쪽 leftItems
						String leftDeptItem = "'" + "PreL1_" + preDept + "'"; // 중복제거용
						if (!SetleftItems.contains(leftDeptItem)) {
							SetleftItems.add(leftDeptItem);
						}
					}

					setData.put("s_itemID", StringUtil.checkNull(process.get("p_itemID")));
					List PreItemList = (List) commonService.selectList("zDLENC_SQL.getPreAttr", setData);

					String PreDSts = StringUtil.checkNull(process.get("DoneStatus"));
					String l1Id = "4p_" + StringUtil.checkNull(process.get("p_itemID"));
					if (!PreIdes.contains(l1Id)) {
						itemMap = new HashMap();
						itemMap.put("id", "4p_" + StringUtil.checkNull(process.get("p_itemID")));
						itemMap.put("text", StringUtil.checkNull(process.get("ItemName")));
						itemMap.put("parent", "PreL1_" + StringUtil.checkNull(process.get("preDept")));
						itemMap.put("fill", "#ffffff");
						itemMap.put("stroke", "#5569b1");
						itemMap.put("fontColor", "#000000");

						diagramList.add(itemMap);
						PreIdes.add(l1Id);
					}

					if (PreItemList.size() > 0) {
						for (int j = 0; j < PreItemList.size(); j++) {
							Map cxnMap = (Map) PreItemList.get(j);
							if (!cxnMap.get("ItemTypeCode").equals("OJ00002")) {
								String PrePDSts = StringUtil.checkNull(cxnMap.get("DoneStatus"));
								itemMap = new HashMap();
								itemMap.put("id", "4d_" + StringUtil.checkNull(process.get("p_itemID")) + "_"
										+ StringUtil.checkNull(cxnMap.get("p_itemID")));
								itemMap.put("text", StringUtil.checkNull(cxnMap.get("ItemName")));
								itemMap.put("parent", "4p_" + StringUtil.checkNull(process.get("p_itemID")));
								itemMap.put("fill", "#ffffff");
								itemMap.put("stroke", "#5569b1");
								itemMap.put("fontColor", "#000000");

								diagramList.add(itemMap);
							}
						}
					}
				}
			}

			// 후행 Activity
			setData.put("itemID", s_itemID);
			setData.put("prodeuctTypeAttr", "ZPAT005"); // 상품타입 ATTR
			setData.put("PTypeValue", "AMP"); // 상품타입 ATTR 값 암모니아(=AMP) 이제 플랜트도 myProjectID로 찾으니 빼도 되는지 확인하기
			setData.put("DoneSts", "ZPAT030"); // Done 진행사항 attr
			setData.put("month", month);
			setData.put("projectID", myProjectID);// s_itemID의 프로젝트 ID

			List postAttrList = commonService.selectList("zDLENC_SQL.getPostAttr", setData);

			Set Postl1Values = new HashSet();
			Set PostIdes = new HashSet();

			if (postAttrList.size() > 0) {
				for (int i = 0; i < postAttrList.size(); i++) {
					Map postProcess = (Map) postAttrList.get(i);
					// 주토 주관부서 구분
					String PostDept = StringUtil.checkNull(postProcess.get("postDept"));
					if (!Postl1Values.contains(PostDept)) {
						itemMap = new HashMap();
						itemMap.put("id", "PostL1_" + StringUtil.checkNull(postProcess.get("postDept")));
						itemMap.put("text", StringUtil.checkNull(postProcess.get("postDept")));
						itemMap.put("parent", s_itemID);
						itemMap.put("fill", "#a5a5a5"); // 기본 회색
						itemMap.put("stroke", "#FFFFFF");
						itemMap.put("fontColor", "#FFFFFF");
						diagramList.add(itemMap);

						Postl1Values.add(PostDept);

						// 오른쪽 rightItems
						String rightDeptItem = "'" + "PostL1_" + StringUtil.checkNull(postProcess.get("postDept"))
								+ "'"; // 중복제거용
						if (!rightItems.contains(rightDeptItem)) {
							rightItems.add(rightDeptItem);
						}
					}

					setData.put("itemID", StringUtil.checkNull(postProcess.get("p_itemID")));
					List postItemList = (List) commonService.selectList("zDLENC_SQL.getPostAttr", setData);

					String PostDSts = StringUtil.checkNull(postProcess.get("DoneStatus"));
					String Postl1Id = "4q_" + StringUtil.checkNull(postProcess.get("p_itemID"));
					if (!PostIdes.contains(Postl1Id)) {
						itemMap = new HashMap();
						itemMap.put("id", "4q_" + StringUtil.checkNull(postProcess.get("p_itemID")));
						itemMap.put("text", StringUtil.checkNull(postProcess.get("ItemName")));
						itemMap.put("parent", "PostL1_" + StringUtil.checkNull(postProcess.get("postDept")));
						itemMap.put("fill", "#ffffff");
						itemMap.put("stroke", "#5569b1");
						itemMap.put("fontColor", "#000000");
						diagramList.add(itemMap);
						PostIdes.add(Postl1Id);
					}

					if (postItemList.size() > 0) {
						for (int j = 0; j < postItemList.size(); j++) {
							Map postMap = (Map) postItemList.get(j);
							if (!postMap.get("ItemTypeCode").equals("OJ00002")) {
								String PostPDSts = StringUtil.checkNull(postMap.get("DoneStatus"));
								itemMap = new HashMap();
								itemMap.put("id", "4s_" + StringUtil.checkNull(postProcess.get("p_itemID")) + "_"
										+ StringUtil.checkNull(postMap.get("p_itemID")));
								itemMap.put("text", StringUtil.checkNull(postMap.get("ItemName")));
								itemMap.put("parent", "4q_" + StringUtil.checkNull(postProcess.get("p_itemID")));
								itemMap.put("fill", "#ffffff");
								itemMap.put("stroke", "#5569b1");
								itemMap.put("fontColor", "#000000");
								diagramList.add(itemMap);
							}
						}
					}
				}
			}

			JSONArray diagramListData = new JSONArray(diagramList);
			model.put("diagramListData", diagramListData);
			System.out.println("diagramListData :" + diagramListData);

			List leftItems = new ArrayList(SetleftItems);
			model.put("leftItems", leftItems);
			model.put("rightItems", rightItems);
			System.out.println("leftItems :" + leftItems);
			System.out.println("rightItems :" + rightItems);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/zDlenc_ElmInfoTabMenu.do")
	public String zDlenc_ElmInfoTabMenu(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		String url = "/custom/daelim/dlenc/item/zDlenc_ElmInfoTabMenu";
		HashMap setMap = new HashMap();
		String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
		String modelID = StringUtil.checkNull(request.getParameter("modelID"), "");
		setMap.put("s_itemID", s_itemID);
		String projectCode = commonService.selectString("zDLENC_SQL.getProjectCodeFromItem", setMap);
		model.put("projectCode", projectCode); /* Label Setting */
		model.put("menu", getLabel(request, commonService)); /* Label Setting */
		model.put("s_itemID", s_itemID);
		model.put("modelID", modelID);

		model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));
		model.put("attrRevYN", StringUtil.checkNull(request.getParameter("attrRevYN"), ""));
		model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"), ""));
		model.put("mdlFilter", StringUtil.checkNull(request.getParameter("mdlFilter"), ""));

		model.put("itemTypeFilter", StringUtil.checkNull(request.getParameter("itemTypeFilter")));
		model.put("dimTypeFilter", StringUtil.checkNull(request.getParameter("dimTypeFilter")));
		model.put("symTypeFilter", StringUtil.checkNull(request.getParameter("symTypeFilter")));
		model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
		String userID = StringUtil.checkNull(String.valueOf(commandMap.get("sessionUserId")), "");

		setMap.put("sessionUserId", userID);
		String teamID = commonService.selectString("user_SQL.userTeamID", setMap);
		setMap.put("sessionTeamId", teamID);

		setMap.put("ItemId", s_itemID);
		setMap.put("actionType", StringUtil.checkNull(request.getParameter("actionType"), ""));
		String ip = request.getHeader("X-FORWARDED-FOR");
		if (ip == null)
			ip = request.getRemoteAddr();
		setMap.put("IpAddress", ip);
		setMap.put("ActionType", "MODEL");
		setMap.put("comment", modelID);

		commonService.insert("gloval_SQL.insertVisitLog", setMap);

		setMap.put("ID_IPUT_PRSN", StringUtil.checkNull(commandMap.get("sessionLoginId")));
		setMap.put("s_itemID", s_itemID);
		setMap.put("itemID", s_itemID);

		String NO_ACTY = commonService.selectString("zDLENC_SQL.zDlenc_getSiteNoActy", setMap);
		String parentProjectCode = commonService.selectString("zDLENC_SQL.zDlenc_getParentProjectCode", setMap);

		if (parentProjectCode.equals("FIELDA240001") || parentProjectCode.equals("FIELDC240002")
				|| parentProjectCode.equals("FIELDP240003")) {
			if (NO_ACTY != null && !NO_ACTY.isEmpty()) {
				setMap.put("NO_ACTY", NO_ACTY);
				commonService.insert("zDLENC_SQL.zDlenc_insertActivityLog", setMap);
			}
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/zDlenc_ObjectAttrInfo.do")
	public String zDlenc_ObjectAttrInfo(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {

		String url = "/itm/sub/ObjectAttrInfoMain";
		try {
			List returnData = new ArrayList();
			HashMap setMap = new HashMap();
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String attrRevYN = StringUtil.checkNull(request.getParameter("attrRevYN"), "");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
			String modelID = StringUtil.checkNull(request.getParameter("ModelID"), "");
			String projectCode = StringUtil.checkNull(request.getParameter("projectCode"), "");

			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("defaultLang", defaultLang);
			setMap.put("option", request.getParameter("option"));

			setMap.put("s_itemID", s_itemID);
			setMap.put("attrRevYN", attrRevYN);
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			String itemStatus = StringUtil.checkNull(itemInfo.get("Status"));
			String identifier = StringUtil.checkNull(itemInfo.get("Identifier"));
			/* edit 가능 한 Item 인지 Item Status를 취득해서 판단 */
			String itemBlocked = commonService.selectString("project_SQL.getItemBlocked", setMap);

			/*
			 * String dataType = ""; Map setData = new HashMap(); List mLovList = new
			 * ArrayList(); String plainText = ""; for(int i=0; i<returnData.size(); i++){
			 * Map attrTypeMap = (HashMap)returnData.get(i); dataType =
			 * StringUtil.checkNull(attrTypeMap.get("DataType"));
			 * if(dataType.equals("MLOV")){ setData.put("defaultLang", defaultLang);
			 * setData.put("languageID", request.getParameter("languageID"));
			 * setData.put("itemID", commandMap.get("s_itemID"));
			 * setData.put("attrTypeCode", attrTypeMap.get("AttrTypeCode")); mLovList =
			 * commonService.selectList("attr_SQL.getMLovList",setData); plainText = "";
			 * if(mLovList.size() > 0){ for(int j=0; j<mLovList.size(); j++){ Map
			 * mLovListMap = (HashMap)mLovList.get(j); if(j==0){ plainText =
			 * StringUtil.checkNull(mLovListMap.get("Value")); }else { plainText = plainText
			 * + " / " + mLovListMap.get("Value") ; } } } attrTypeMap.put("PlainText",
			 * plainText); } }
			 * 
			 * model.put("itemStatus", itemStatus); // 아이템 Status
			 */

			// Login user editor 권한 추가
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(request.getParameter("userID"))
					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(request.getParameter("userID"))
					|| "1".equals(sessionAuthLev)) {
				model.put("myItem", "Y");
			}

			setMap.put("modelID", modelID);
			setMap.put("link", s_itemID);
			String elementReleaseNo = "";
			if (modelID != null && !modelID.equals("null") && !modelID.equals("")) {
				elementReleaseNo = commonService.selectString("model_SQL.getElementReleaseNo", setMap);
			}

			setMap.put("releaseNo", elementReleaseNo);
			Map setData = new HashMap();
			setData.put("modelID", modelID);
			String modelBlocked = "";
			if (!modelID.equals("")) {
				modelBlocked = StringUtil.checkNull(commonService.selectString("model_SQL.getModelBlocked", setData));
			}

			if (!"0".equals(itemBlocked) || !"0".equals(modelBlocked)) {
				model.put("isPossibleEdit", "N");
			} else {
				model.put("isPossibleEdit", "Y");
			}

			setMap.put("changeSetID", changeSetID);
			/*
			 * Map csInfo = commonService.select("cs_SQL.getChangeSetInfo", setMap); String
			 * csValidDate = ""; if (!csInfo.isEmpty()) { csValidDate =
			 * StringUtil.checkNull(csInfo.get("ValidFrom")); }
			 */
			setMap.put("itemID", s_itemID);
			String classCode = commonService.selectString("item_SQL.getClassCode", setMap);
			if (classCode.equals("CL33005") | classCode.equals("CL32005") | classCode.equals("CL31005")) {

				setMap.put("assignmentType", "CNGROLETP");
				setMap.put("languageID", request.getParameter("languageID"));
				setMap.put("projectCode", projectCode);
				String PJCategory = commonService.selectString("zDLENC_SQL.getPJCategory", setMap);
				List manual;
				String parentProjectCode = commonService.selectString("zDLENC_SQL.zDlenc_getParentProjectCode", setMap);
				if (parentProjectCode.equals("FIELDP240003")) {
					manual = commonService.selectList("zDLENC_SQL.zDlenc_getSiteItemAttr", setMap);
					url = "/custom/daelim/dlenc/item/zDlenc_PSITEObjectAttrInfoMain";
				} else if (parentProjectCode.equals("FIELDA240001") || parentProjectCode.equals("FIELDC240002")) {
					manual = commonService.selectList("zDLENC_SQL.zDlenc_getSiteItemAttr", setMap);
					url = "/custom/daelim/dlenc/item/zDlenc_ACSITEObjectAttrInfoMain";
				} else if (parentProjectCode.equals("HQP240003")) {
					manual = commonService.selectList("zDLENC_SQL.zDlenc_getStdItemAttr_P", setMap);
					url = "/custom/daelim/dlenc/item/zDlenc_PSTDObjectAttrInfoMain";
				} else if (parentProjectCode.equals("HQA240001") || parentProjectCode.equals("HQC240002")) {
					manual = commonService.selectList("zDLENC_SQL.zDlenc_getStdItemAttr", setMap);
					url = "/custom/daelim/dlenc/item/zDlenc_ACSTDObjectAttrInfoMain";

				} else if (parentProjectCode.equals("HQP240003")) {
					manual = commonService.selectList("zDLENC_SQL.zDlenc_getStdItemAttr", setMap);
					url = "/custom/daelim/dlenc/item/zDlenc_PSTDObjectAttrInfoMain";

				} else {
					url = "/itm/sub/ObjectAttrInfoMain";
					returnData = (List) commonService.selectList("attr_SQL.getItemAttr", setMap);
					manual = GetItemAttrList.getItemAttrList(commonService, returnData, setMap,
							request.getParameter("languageID"));
				}
				model.put("manual", manual);
			}
			// model.put("csValidDate", csValidDate);
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("s_itemID", s_itemID);
			model.put("identifier", identifier);
			model.put("attrRevYN", attrRevYN);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("itemInfo", itemInfo);
			model.put("projectCode", projectCode);
			// model.put("accRight", accRight);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/zDlenc_ObjectOutputInfo.do")
	public String zDlenc_ObjectOutputInfo(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {

		String url = "";
		try {
			List returnData = new ArrayList();
			HashMap setMap = new HashMap();
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String attrRevYN = StringUtil.checkNull(request.getParameter("attrRevYN"), "");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
			String modelID = StringUtil.checkNull(request.getParameter("ModelID"), "");
			String projectCode = StringUtil.checkNull(request.getParameter("projectCode"), "");

			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("defaultLang", defaultLang);
			setMap.put("option", request.getParameter("option"));

			setMap.put("s_itemID", s_itemID);
			setMap.put("attrRevYN", attrRevYN);
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			String itemStatus = StringUtil.checkNull(itemInfo.get("Status"));
			String identifier = StringUtil.checkNull(itemInfo.get("Identifier"));
			/* edit 가능 한 Item 인지 Item Status를 취득해서 판단 */
			String itemBlocked = commonService.selectString("project_SQL.getItemBlocked", setMap);

			// Login user editor 권한 추가
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(request.getParameter("userID"))
					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(request.getParameter("userID"))
					|| "1".equals(sessionAuthLev)) {
				model.put("myItem", "Y");
			}

			setMap.put("modelID", modelID);
			setMap.put("link", s_itemID);
			String elementReleaseNo = "";
			if (modelID != null && !modelID.equals("null") && !modelID.equals("")) {
				elementReleaseNo = commonService.selectString("model_SQL.getElementReleaseNo", setMap);
			}

			setMap.put("releaseNo", elementReleaseNo);
			Map setData = new HashMap();
			setData.put("modelID", modelID);
			String modelBlocked = "";
			if (!modelID.equals("")) {
				modelBlocked = StringUtil.checkNull(commonService.selectString("model_SQL.getModelBlocked", setData));
			}

			if (!"0".equals(itemBlocked) || !"0".equals(modelBlocked)) {
				model.put("isPossibleEdit", "N");
			} else {
				model.put("isPossibleEdit", "Y");
			}

			setMap.put("changeSetID", changeSetID);
			/*
			 * Map csInfo = commonService.select("cs_SQL.getChangeSetInfo", setMap); String
			 * csValidDate = ""; if (!csInfo.isEmpty()) { csValidDate =
			 * StringUtil.checkNull(csInfo.get("ValidFrom")); }
			 */
			setMap.put("itemID", s_itemID);
			setMap.put("assignmentType", "CNGROLETP");
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("projectCode", projectCode);
			String PJCategory = commonService.selectString("zDLENC_SQL.getPJCategory", setMap);
			List manual;
			String parentProjectCode = commonService.selectString("zDLENC_SQL.zDlenc_getParentProjectCode", setMap);
			if (parentProjectCode.equals("FIELDP240003")) {
				manual = commonService.selectList("zDLENC_SQL.zDlenc_getSiteItemAttr", setMap);
				url = "/custom/daelim/dlenc/item/zDlenc_PSITEObjectOutputInfoMain";
			} else if (parentProjectCode.equals("FIELDA240001") || parentProjectCode.equals("FIELDC240002")) {
				manual = commonService.selectList("zDLENC_SQL.zDlenc_getSiteItemAttr", setMap);
				url = "/custom/daelim/dlenc/item/zDlenc_ACSITEObjectOutputInfoMain";
			} else if (parentProjectCode.equals("HQP240003")) {
				manual = commonService.selectList("zDLENC_SQL.zDlenc_getStdItemAttr", setMap);
				url = "/custom/daelim/dlenc/item/zDlenc_PSTDObjectOutputInfoMain";
			} else if (parentProjectCode.equals("HQA240001") || parentProjectCode.equals("HQC240002")) {
				manual = commonService.selectList("zDLENC_SQL.zDlenc_getStdItemAttr", setMap);
				url = "/custom/daelim/dlenc/item/zDlenc_ACSTDObjectOutputInfoMain";
			} else if (parentProjectCode.equals("HQP240003")) {
				manual = commonService.selectList("zDLENC_SQL.zDlenc_getStdItemAttr", setMap);
				url = "/custom/daelim/dlenc/item/zDlenc_PSTDObjectOutputInfoMain";
			} else {
				url = "/itm/sub/ObjectAttrInfoMain";
				returnData = (List) commonService.selectList("attr_SQL.getItemAttr", setMap);
				manual = GetItemAttrList.getItemAttrList(commonService, returnData, setMap,
						request.getParameter("languageID"));
			}
			model.put("manual", manual);
			// model.put("csValidDate", csValidDate);
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("s_itemID", s_itemID);
			model.put("identifier", identifier);
			model.put("attrRevYN", attrRevYN);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("itemInfo", itemInfo);
			model.put("projectCode", projectCode);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/zdlencModelXmlExport.do")
	public String zdlencModelXmlExport(HttpServletRequest request, HashMap commandMap, ModelMap model,
			HttpServletResponse response) throws Exception {
		Map target = new HashMap();
		HashMap setMap = new HashMap();

		String modelID = StringUtil.checkNull(request.getParameter("modelID"), "");
		String modelName = StringUtil.checkNull(request.getParameter("modelName"), "model");
		setMap.put("s_itemID", modelID);
		setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));

		List getModelInfo = commonService.selectList("model_SQL.selectModelInfo", setMap);

		String modelXML = "";

		if (!getModelInfo.isEmpty()) {
			Map<String, Object> modelXmlValue = (Map<String, Object>) getModelInfo.get(0);
			modelXML = (String) modelXmlValue.get("ModelXML");
		}

		Calendar cal = Calendar.getInstance();
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
		java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
		String sdate = sdf.format(cal.getTime());
		String stime = sdf2.format(cal.getTime());
		String mkFileNm = sdate + stime;

		String filePath = GlobalVal.FILE_EXPORT_DIR;
		String fileName = modelName + "_" + mkFileNm + ".xml";
		String xmlFile = filePath + modelID;

		try (BufferedWriter writer = new BufferedWriter(new FileWriter(xmlFile))) {
			writer.write(modelXML);

			System.out.println("XML 파일이 성공적으로 저장되었습니다: " + xmlFile);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.fnGoModelInfo('view');");
		} catch (Exception e) {
			System.err.println("파일 저장 중 오류 발생: " + e.getMessage());
		}
		request.setAttribute("downFile", xmlFile);
		request.setAttribute("orginFile", fileName);

		FileUtil.downFile(request, response);

		// String downFile = xmlFile;

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/zdlencModelXmlImport.do")
	public String zdlencModelXmlImport(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		Map target = new HashMap();

		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Iterator<String> fileNameIter = multipartRequest.getFileNames();
		String savePath = GlobalVal.FILE_EXPORT_DIR.replace("\\", "//");
		String filePath = "";
		String fileName = "";

		if (fileNameIter.hasNext()) {
			// 하나의 파일만 처리
			String fileParamName = fileNameIter.next(); // 파일 파라미터 이름
			MultipartFile mFile = multipartRequest.getFile(fileParamName);
			fileName = mFile.getOriginalFilename();
			if (mFile.getSize() > 0) {
				String ext = FileUtil.getExt(fileName);

				HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
				fileName = (String) resultMap.get("SysFileNm");
				filePath = (String) resultMap.get("FilePath");
			}
		}
		HashMap setMap = new HashMap();

		String modelID = StringUtil.checkNull(request.getParameter("modelID"), "");
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");

		String xmlFile = filePath + fileName;
		File modelXmlFile = new File(xmlFile);
		StringBuilder xmlContent = new StringBuilder();

		try (BufferedReader br = new BufferedReader(new FileReader(modelXmlFile))) {
			String firstLine = br.readLine();
			if (firstLine != null && firstLine.trim().startsWith("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")) {
				// 첫 번째 줄이 XML 선언이라면, 그 줄을 건너뛰고 3줄을 건너뛰고 나머지 줄 읽기
				br.lines().skip(2) // 처음 3줄을 건너뜀 (Draw.io -> ModelXML 불필요한 문구 삭제)
						.forEach(line -> xmlContent.append(line)); // 모든 줄을 하나의 문자열로 합침
			} else {

				xmlContent.append(firstLine); // 첫 번째 줄도 xmlContent에 추가
				br.lines().forEach(line -> xmlContent.append(line)); // 그 뒤의 모든 줄을 합침
			}

		} catch (IOException e) {
			e.printStackTrace();
		}

		// DOM 객체 사이 공백 제거 & 위에서 3줄 건너뛴 DOM 객체 삭제
		String formattedXml = xmlContent.toString().replaceAll(">\\s*", ">").replaceAll("\\s*<", "<")
				.replace("</diagram></mxfile>", "");

		setMap.put("s_itemID", modelID);
		setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));

		List getModelInfo = commonService.selectList("model_SQL.selectModelInfo", setMap);

		String modelName = "";
		String modelDesc = "";
		String itemID = "";
		String modelTypeName = "";
		String modelCat = "";
		String modelTypeCode = "";

		if (!getModelInfo.isEmpty()) {
			Map<String, Object> modelXmlValue = (Map<String, Object>) getModelInfo.get(0);
			modelName = (String) modelXmlValue.get("Name");
			modelDesc = (String) modelXmlValue.get("Description");
			itemID = String.valueOf(modelXmlValue.get("ItemID"));
			modelTypeName = (String) modelXmlValue.get("ModelTypeName");
			modelCat = (String) modelXmlValue.get("MTCategory");
			modelTypeCode = (String) modelXmlValue.get("ModelTypeCode");
		}

//		String newModelID = StringUtil.checkNull(commonService.selectString("model_SQL.getMaxModelIDString", setMap));
//		
//		setMap.put("updateMTCategory", "TOBE");		
//		setMap.put("orgMTCategory", modelCat);		
//		setMap.put("itemID", itemID);		
//		commonService.insert("model_SQL.updateModelCat", setMap);
//
//		
//		setMap.put("ModelID", newModelID); setMap.put("ItemID", itemID);
//		setMap.put("ProjectID", StringUtil.checkNull(commonService.selectString(
//		"item_SQL.getProjectIDFromItem", setMap))); setMap.put("ChangeSetID", "");
//		setMap.put("ModelTypeCode", modelTypeCode); setMap.put("MTCategory",
//		modelCat); setMap.put("GlobalID", ""); setMap.put("Creator",
//		commandMap.get("sessionUserId")); setMap.put("Deleted", "0");
//		setMap.put("Status", "REL"); setMap.put("Blocked", "0");
//		setMap.put("isModel", "1"); commonService.insert("model_SQL.insertModel", setMap);

		setMap.put("Name", modelName);
		setMap.put("ModelID", modelID);
		setMap.put("LanguageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
		setMap.put("Description", modelDesc);
		setMap.put("ModelXML", formattedXml);
		setMap.put("lastUser", commandMap.get("sessionUserId"));
		commonService.update("model_SQL.updateModelXML", setMap);

		target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
		target.put(AJAX_SCRIPT, "parent.fnGoModelInfo('view');");

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	// -----------------------------------------------------------------------------------------------------------

	// 주토-뷰데이터 현장 Tree 받아오는 함수
	@RequestMapping(value = "/DLENCFetchACSITETreeViewData.do")
	public String DLENCFetchACSITETreeViewData(HttpServletRequest request, HashMap cmmMap, ModelMap model)
			throws Exception {
		Map target = new HashMap();
		HashMap setMap = new HashMap();
		try {
			setMap.put("ReportCode","TREE_AC");
			
			setMap.put("Contents","XBOLTADM.DLENC_A_C_CD_SITE_TREE_BATCH");
			commonService.insert("zDLENC_SQL.insertBatchJobLog", setMap);
			String BatchJobNo = commonService.selectString("zDLENC_SQL.getMaxBatchJobNoString", setMap);
			setMap.put("BatchJobNo",BatchJobNo);
			
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			Map getData = new HashMap();
			getData.put("itemID", itemID);
			getData.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			commonService.insert("zDLENC_SQL.getDLENC_FetchViewACSITETreeData", getData);

			setMap.put("Status","02");
			commonService.update("zDLENC_SQL.UpdateBatchJobLog",setMap);
			
			// target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "");

			model.addAttribute(AJAX_RESULTMAP, target);
		} catch (Exception e) {
			setMap.put("Status","03");
			commonService.select("zDLENC_SQL.UpdateBatchJobLog", setMap);
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	/*
	 * // 주토플-뷰데이터 현장 Tree+item 배치 예약 등록 함수
	 * 
	 * @RequestMapping(value = "/DLENCTreeItemInsertViewData.do") public String
	 * DLENCFetchTreeViewData(HttpServletRequest request, HashMap cmmMap, ModelMap
	 * model) throws Exception { Map target = new HashMap(); try { Map<String,
	 * Object> logData = new HashMap<>(); String itemID =
	 * StringUtil.checkNull(request.getParameter("itemID")); String execDate =
	 * LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")); String
	 * UserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
	 * 
	 * // TB_VISIT_LOG insert logData.put("BatName", "FETCH_ACP_LvL_Item");
	 * logData.put("ActionType", "READY"); logData.put("ExecDate", execDate); // 실행
	 * 예정일 logData.put("RegUserID", UserID); logData.put("Time",
	 * LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
	 * logData.put("itemID", itemID);
	 * 
	 * commonService.insert("zDLENC_SQL.insertZDLENCBatchLog", logData);
	 * 
	 * target.put(AJAX_ALERT, "배치 작업이 성공적으로 예약되었습니다."); target.put(AJAX_SCRIPT, "");
	 * model.addAttribute(AJAX_RESULTMAP, target); } catch (Exception e) {
	 * System.out.println(e); throw new ExceptionUtil(e.toString()); } return
	 * nextUrl(AJAXPAGE); }
	 */

	// -----------------------------------------------------------------------------------------------------------

	// 플랜트-뷰데이터 Map Tree 받아오는 함수
	@RequestMapping(value = "/DLENCFetchPlantMapTreeViewData.do")
	public String DLENCFetchPlantMapTreeViewData(HttpServletRequest request, HashMap cmmMap, ModelMap model)
			throws Exception {
		Map target = new HashMap();
		HashMap setMap = new HashMap();
		try {
			
			setMap.put("ReportCode","TREE_P");
			setMap.put("Contents","XBOLTADM.DLENC_PLANT_MAP_TREE_BATCH");
			commonService.insert("zDLENC_SQL.insertBatchJobLog", setMap);
			String BatchJobNo = commonService.selectString("zDLENC_SQL.getMaxBatchJobNoString", setMap);
			setMap.put("BatchJobNo",BatchJobNo);
			
			Map getData = new HashMap();
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			getData.put("itemID", itemID);
			getData.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			commonService.insert("zDLENC_SQL.getDLENC_FetchViewPlantMapTreeData", getData);

			setMap.put("Status","02");
			commonService.update("zDLENC_SQL.UpdateBatchJobLog",setMap);
			// target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "");

			model.addAttribute(AJAX_RESULTMAP, target);
		} catch (Exception e) {
			setMap.put("Status","03");
			commonService.select("zDLENC_SQL.UpdateBatchJobLog", setMap);
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	@ResponseBody
	@RequestMapping(value = "/custom/daelim/dlenc/XMLProcessing.do")
	public ResponseEntity<?> XMLProcessing() throws Exception {

		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();

		HashMap<String, Object> cmmMap = new HashMap<>();
		HashMap<String, Object> getData = new HashMap<>();

		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
		LocalDateTime start = LocalDateTime.now();
		HashMap setMap = new HashMap();
		try {
			  
			  setMap.put("ReportCode","XmlUpdate");
			  setMap.put("Contents","XMLProcessing");
			  commonService.insert("zDLENC_SQL.insertBatchJobLog", setMap);
			  String BatchJobNo = commonService.selectString("zDLENC_SQL.getMaxBatchJobNoString", setMap);
			  setMap.put("BatchJobNo",BatchJobNo);
			  
			System.out.println(">>> XMLProcessing Start ^ - Start Time: " + start.format(formatter));
			
			commonService.update("zDLENC_SQL.UpdateDeletedElement",setMap);
			List<Map<String, Object>> getModelIDList = commonService.selectList("zDLENC_SQL.zDlenc_getIsModel2Model",
					getData);
			System.out.println("START");

			if (getModelIDList == null || getModelIDList.isEmpty()) {
				return ResponseEntity.ok("No related model found.");
			}
			cmmMap.put("sessionCurrLangType", 1042);

			// 4. 모델별 처리
			for (Map<String, Object> ModelIDList : getModelIDList) {
				String modelID = StringUtil.checkNull(ModelIDList.get("ModelID"));
				cmmMap.put("modelID", modelID);

				String isModel = commonService.selectString("model_SQL.getDiagramType", cmmMap);
				if ("2".equals(isModel)) {
					diagramEditActionController.modelXmlSave(request, cmmMap, new ModelMap());
				}
			}
			
			setMap.put("Status","02");
			commonService.update("zDLENC_SQL.UpdateBatchJobLog",setMap);
			LocalDateTime end = LocalDateTime.now();
			Duration duration = Duration.between(start, end);
			System.out.println(">>> XMLProcessing End & | Start Time: " + end.format(formatter) + " | End Time: "
					+ duration.toMillis() + " ms");

		} catch (Exception e) {
			setMap.put("Status","03");
			commonService.update("zDLENC_SQL.UpdateBatchJobLog",setMap);
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("Internal server error occurred." + e.getMessage());
		}

		return ResponseEntity.ok("Processed successfully");
	}

	@RequestMapping(value = "/zdlencSubItemList.do")
	public String zdlencSubItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		try {
			List returnData = new ArrayList();
			HashMap OccAttrInfo = new HashMap();
			String s_itemID = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("s_itemID"), ""));

			model.put("s_itemID", s_itemID);
			model.put("option", request.getParameter("option"));
			OccAttrInfo.put("languageID", commandMap.get("sessionCurrLangType"));
			OccAttrInfo.put("s_itemID", s_itemID);
			OccAttrInfo.put("option", request.getParameter("option"));
			returnData = commonService.selectList("item_SQL.getClassOption", OccAttrInfo);
			model.put("classOption", returnData);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			OccAttrInfo.put("SelectMenuId", request.getParameter("option"));
			String fiterType = StringUtil
					.checkNull(commonService.selectString("menu_SQL.selectArcFilter", OccAttrInfo));
			String treeDataFilterd = StringUtil
					.checkNull(commonService.selectString("menu_SQL.selectArcTreeDataFiltered", OccAttrInfo));
			model.put("filterType", fiterType);
			model.put("TreeDataFiltered", treeDataFilterd);

			// Login user editor 권한 추가
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", OccAttrInfo);
//				if (StringUtil.checkNull(itemAuthorMap.get("AuthorID"))
//						.equals(StringUtil.checkNull(commandMap.get("sessionUserId")))
//						|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(
//								StringUtil.checkNull(commandMap.get("sessionUserId")))
//						|| "1".equals(sessionAuthLev)) {
//					model.put("myItem", "Y");
//				}

			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);

			// [ADD],[Del] 버튼 제어
			String blocked = StringUtil.checkNull(itemAuthorMap.get("Blocked"));
			if (!"0".equals(blocked)) {
				model.put("blocked", "Y");
			}

			/* 선택된 아이템의 해당 CSR 리스트를 취득 */
			OccAttrInfo.put("AuthorID", commandMap.get("sessionUserId"));
			returnData = commonService.selectList("project_SQL.getCsrListWithMember", OccAttrInfo);
			model.put("csrOption", returnData);

			// pop up 창에서 편집 버튼 제어 용
			String pop = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("pop"), ""));
			model.put("pop", pop);
			String showElement = StringUtil.checkNull(commandMap.get("showElement"));
			String showTOJ = StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("showTOJ")));
			OccAttrInfo = new HashMap();
			OccAttrInfo.put("arcCode", request.getParameter("option"));
			model.put("sortOption",
					StringUtil.checkNull(commonService.selectString("menu_SQL.getArcSortOption", OccAttrInfo)));
			OccAttrInfo = new HashMap();
			OccAttrInfo.put("s_itemID", s_itemID);
			model.put("itemTypeCode", commonService.selectString("item_SQL.getItemTypeCode", OccAttrInfo));
			model.put("showTOJ", showTOJ);
			model.put("showElement", showElement);
			model.put("addOption", StringUtil.checkNull(commandMap.get("addOption")));

			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			String dimTypeList = StringUtil.checkNull(request.getParameter("dimTypeList"));

			model.put("classCode", classCode);
			model.put("fltpCode", fltpCode);
			model.put("dimTypeList", dimTypeList);

			OccAttrInfo.put("s_itemID", s_itemID);
			OccAttrInfo.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			OccAttrInfo.put("option", StringUtil.checkNull(request.getParameter("option")));
			OccAttrInfo.put("filterType", fiterType);
			OccAttrInfo.put("TreeDataFiltered", treeDataFilterd);
			OccAttrInfo.put("showTOJ", showTOJ);
			OccAttrInfo.put("showElement", showElement);
			OccAttrInfo.put("sessionParamSubItems", StringUtil.checkNull(commandMap.get("sessionParamSubItems")));

			String accMode = StringUtil.replaceFilterString(StringUtil.checkNull(commandMap.get("accMode")));
			OccAttrInfo.put("accMode", StringUtil.checkNull(commandMap.get("accMode")));
			model.put("accMode", accMode);
			List subItemList = null;
			OccAttrInfo.put("sessionUserId", StringUtil.checkNull(commandMap.get("sessionUserId")));
			// accMode가 OPS 일때 search 기능x
			if ("OPS".equals(accMode)) {
				subItemList = commonService.selectList("item_SQL.getChildItemList_gridList", OccAttrInfo);
			} else {
				subItemList = commonService.selectList("zDLENC_SQL.zDlenc_getSubItemList_gridList", OccAttrInfo);
			}

			JSONArray gridData = new JSONArray(subItemList);
			model.put("gridData", gridData);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/custom/daelim/dlenc/item/zDlenc_subItemList");
	}
	
	@RequestMapping(value="/exeAVLvLTree.do")
	public String exeAVLvLTree(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception {
		Map target = new HashMap();
		Map getData = new HashMap();
		String runningBatch = commonService.selectString("exeAVLvLTreeIsRunning",getData);
		getData.put("ReportCode","Acty");
		String itemID = StringUtil.checkNull(request.getParameter("itemID"));
		getData.put("Contents","XBOLTADM.DLENC_ACP_TREE_BATCH&XBOLTADM.DLENC_ACP_ITEM_BATCH");
		commonService.insert("zDLENC_SQL.insertBatchJobLog", getData);
		String BatchJobNo = commonService.selectString("zDLENC_SQL.getMaxBatchJobNoString", getData);
		getData.put("BatchJobNo",BatchJobNo);
        
				try {
				getData.put("itemID",itemID);
	            commonService.select("zDLENC_SQL.getDLENC_FetchViewTreeData", getData);
	            commonService.select("zDLENC_SQL.getDLENC_FetchViewActyData", getData);				           
	            getData.put("Status","02");
	            if(runningBatch.equals("0")) {
		            commonService.insert("zDLENC_SQL.getDLENC_UpdateViewActyData", getData);
	            }
	            commonService.update("zDLENC_SQL.UpdateBatchJobLog",getData);
				//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "");
				
				model.addAttribute(AJAX_RESULTMAP, target);	
		} catch (Exception e) {
			getData.put("Status","03");
			commonService.select("zDLENC_SQL.UpdateBatchJobLog", getData);
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/zdlencExtWebServiceMgt.do")
	public String zdlencExtWebServiceMgt(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/dlenc/item/zDlenc_ExtWebServiceMgt";
		Map getData = new HashMap();
		String itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
		getData.put("itemID", itemID);
		getData.put("s_itemID", itemID);
		String classCode = commonService.selectString("item_SQL.getClassCode", getData);
		String parentProjectCode = commonService.selectString("zDLENC_SQL.zDlenc_getParentProjectCode", getData);
		List manual;
		if (!"CL33016".equals(classCode)) {
			if(parentProjectCode.equals("HQP240003")) {
				manual = commonService.selectList("zDLENC_SQL.zDlenc_getStdItemAttr_P", getData);
			}else {
				manual = commonService.selectList("zDLENC_SQL.zDlenc_getSiteItemAttr", getData);
			}
			String projectCode = commonService.selectString("zDLENC_SQL.getProjectCodeFromItem", getData);
			model.put("projectCode",projectCode);
			model.put("manual",manual);
		}
		model.put("parentProjectCode",parentProjectCode);
		model.put("classCode",classCode);
		return nextUrl(url);
	}
}