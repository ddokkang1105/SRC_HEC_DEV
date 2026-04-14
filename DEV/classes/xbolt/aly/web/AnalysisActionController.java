package xbolt.aly.web;

import java.io.*;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.org.json.JSONArray;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.JsonUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xwpf.usermodel.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.util.SystemOutLogger;
import org.apache.poi.hslf.util.SystemTimeUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;

/**
 * 분석/통계
 * 
 * @Class Name : AnalysisActionController.java
 * @Description : 분석/통계관련 Biz.
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- ------------------------------- @2013. 01.
 *      22. bshy 최초생성
 *
 * @since 2013. 01. 22
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class AnalysisActionController extends XboltController {
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;

	//////////////////////////////////////////////////////////////////////////
	@RequestMapping(value = "/analysisMgt.do")
	public String analysisMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {

		try {
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"), "NULL");
			if (projectID.equals("NULL") || projectID.equals("")) {
				Map projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", commandMap);
				model.put("projectID", projectInfoMap.get("ProjectID"));
				model.put("projectName", projectInfoMap.get("Name"));
			} else {
				model.put("projectID", StringUtil.checkNull(request.getParameter("ProjectID"), "NULL"));
				model.put("projectName", StringUtil.checkNull(request.getParameter("ProjectName"), "NULL"));
			}

			String screenMode = StringUtil.checkNull(commandMap.get("screenMode"));
			List reportList = commonService.selectList("report_SQL.getReportListOfPjt", commandMap);

			List reportNameList = commonService.selectList("report_SQL.getReportNameList", commandMap);
			HashMap reportNameMap = new HashMap();
			for (int i = 0; i < reportNameList.size(); i++) {
				Map getReportNameMap = (Map) reportNameList.get(i);
				reportNameMap.put(getReportNameMap.get("ReportCode"), getReportNameMap.get("ReportName"));
			}

			model.addAttribute(HTML_HEADER, "HOME");
			model.put("screenMode", screenMode); // 관리자용 통계/일반 유저용 통계 구분
			model.put("menu", getLabel(request, commonService));
			model.put("reportList", reportList);
			model.put("reportNameMap", reportNameMap);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		// return nextUrl("/aly/analysisMgt");
		return nextUrl("/aly/statisticsMainMenu");
	}
	
	/**
	 * Process 통계 (2014/11/20) TW_PROCESS 테이블의 데이터 이용
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/newItemStatisticsChart.do")
	public String newItemStatisticsChart(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {

		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(request.getParameter("languageID"),
					String.valueOf(commandMap.get("sessionCurrLangType")));


			/* update 버튼 클릭으로 본 엑션을 호출한 경우 Process Insert procedure를 기동한다 */
			if (!StringUtil.checkNull(request.getParameter("eventMode")).isEmpty()) {
				commonService.insert("analysis_SQL.insertTwProcess", setMap);
			}

			setMap.put("LanguageID", languageID);

			// Dimension 검색 정보 설정
			if (!StringUtil.checkNull(request.getParameter("DimTypeID")).isEmpty()) {
				setMap.put("DimTypeID", request.getParameter("DimTypeID"));
				model.put("DimTypeID", request.getParameter("DimTypeID"));
				if (!StringUtil.checkNull(request.getParameter("DimValueID")).isEmpty()) {
					setMap.put("DimValueID", request.getParameter("DimValueID"));
					model.put("DimValueID", request.getParameter("DimValueID"));
				}
			}
			

			List level1NameList = commonService.selectList("analysis_SQL.getLevel1Name", setMap);
			model.put("level1NameList", level1NameList);
			
			int rowTotal = 0;
			String classCode = "CL01002";
			

			Map<String, Integer> level4TotalMap = new HashMap<String, Integer>();
			Map<String, Integer> level5TotalMap = new HashMap<String, Integer>();
			
			int levell4TtlCnt = 0;
			int activityTtlCnt = 0;
			

			Map conditionMap = new HashMap();
			List newPrcCntList = new ArrayList();
			Map newPrcCntMap = new HashMap();

			for (int i = 0; i < level1NameList.size(); i++) {
				Map map = (Map) level1NameList.get(i);
				conditionMap.put(String.valueOf(map.get("ItemID")), String.valueOf(map.get("label")));
			}
			setMap.put("ItemTypeCode", "OJ00001");
			List itemClassCodeList = commonService.selectList("analysis_SQL.getItemClassCodeList", setMap);

			int MaxLevel = Integer.parseInt(commonService.selectString("analysis_SQL.getItemClassMaxLevel", setMap));

			Map prcCountMap = new HashMap();
			List prcCountList = new ArrayList();
			String PieDataSet_CL01005 = "";
			for (int icidx = 0; icidx < itemClassCodeList.size(); icidx++) {
				prcCountMap = new HashMap();
				Map tempMap = (Map) itemClassCodeList.get(icidx);
				String itemClassCode = tempMap.get("ItemClassCode").toString();
				int Level = Integer.parseInt(tempMap.get("Level").toString());
				
				tempMap.put("category", "CLS");
				tempMap.put("typeCode", itemClassCode);
				tempMap.put("languageID", languageID);
				String className = commonService.selectString("task_SQL.getDicName", tempMap);
				tempMap.put("className", className);
				
				itemClassCodeList.set(icidx, tempMap);
				
				if(itemClassCode.equals("CL01005") || itemClassCode.equals("CL01006")) {
					setMap.put("ItemClassCode", itemClassCode);

					if ("CL01005".equals(itemClassCode))
						setMap.put("isDim", "Y");
					else if (!"CL01006".equals(itemClassCode))
						setMap.put("isDim", "N");

					if (!itemClassCode.equals("CL01006")) {
						prcCountList = commonService.selectList("analysis_SQL.getPrcCountList", setMap);
					} else {
						if (setMap.containsKey("DimTypeID")) {
							String parentItemIDs = getItemDimListOfParent(setMap);
							setMap.put("ParentItemIDs", parentItemIDs);
							if (parentItemIDs.isEmpty()) {
								setMap.put("isNothingParent", "Y");
							}
						}
						prcCountList = commonService.selectList("analysis_SQL.getPrcCountListL5", setMap);
					}

					for (int i = 0; i < prcCountList.size(); i++) {
						Map map = (Map) prcCountList.get(i);
						prcCountMap.put(String.valueOf(map.get("L1ItemID")), String.valueOf(map.get("CNT")));
					}
					for (int i = 0; i < level1NameList.size(); i++) {
						newPrcCntMap = new HashMap();
						Map map1 = (Map) level1NameList.get(i);
						newPrcCntMap.put("L1ItemID", String.valueOf(map1.get("ItemID")));
						newPrcCntMap.put("ItemClassCode", itemClassCode);
						newPrcCntMap.put("ItemClassLevel", Level);
						newPrcCntMap.put("Identifier", String.valueOf(map1.get("Identifier")));
						newPrcCntMap.put("NAME", String.valueOf(map1.get("NAME")));
						if (prcCountMap.containsKey(String.valueOf(map1.get("ItemID")))) {
							newPrcCntMap.put("CNT", prcCountMap.get(String.valueOf(map1.get("ItemID"))));
						} else {
							newPrcCntMap.put("CNT", "0");
						}
						newPrcCntList.add(newPrcCntMap);
					}
				}
			}

			//Map pieDataSetMap = new HashMap();
			List<String> pieDataList = new ArrayList();
			/* Activity 이외의 item count row 생성 */
			for (int i = 0; i < newPrcCntList.size(); i++) {
				prcCountMap = (Map) newPrcCntList.get(i);
				String level1ItemId = StringUtil.checkNull(prcCountMap.get("L1ItemID"));
				if (conditionMap.containsKey(level1ItemId)) {

					int level = Integer.parseInt(prcCountMap.get("ItemClassLevel").toString());
					String itemClassCode = prcCountMap.get("ItemClassCode").toString();
					if (!classCode.equals(prcCountMap.get("ItemClassCode"))) {
						classCode = String.valueOf(prcCountMap.get("ItemClassCode"));
						// if (!classCode.equals("CL01006")) { //TODO:L4의 Total만표시 할때의 조건
						if (level < MaxLevel - 1) {
							rowTotal = 0; // Total 값 초기화
						}
					}

					if (itemClassCode.equals("CL01006")) {
						level5TotalMap.put(prcCountMap.get("L1ItemID").toString(),
								Integer.parseInt(prcCountMap.get("CNT").toString()));
						activityTtlCnt = activityTtlCnt + Integer.parseInt(prcCountMap.get("CNT").toString());
					} else if (itemClassCode.equals("CL01005")) { // TODO:L4의 Total만표시 할때 : 이 if문의 comment out
						//pieDataList.add("{ id: \""+prcCountMap.get("Identifier")+" "+prcCountMap.get("NAME")+"\", value: "+Integer.parseInt(prcCountMap.get("CNT").toString())+", color: getRandomColor(), month: \""+prcCountMap.get("Identifier")+" "+prcCountMap.get("NAME")+"\" }");
						pieDataList.add("{ id: \""+prcCountMap.get("Identifier")+" "+prcCountMap.get("NAME")+"\", value: "+Integer.parseInt(prcCountMap.get("CNT").toString())+", color: l1Color["+i+"], month: \""+prcCountMap.get("Identifier")+" "+prcCountMap.get("NAME")+"\" }");

						level4TotalMap.put(prcCountMap.get("L1ItemID").toString(), Integer.parseInt(prcCountMap.get("CNT").toString()));
						levell4TtlCnt = levell4TtlCnt + Integer.parseInt(prcCountMap.get("CNT").toString());
					} else {
						//cell.appendChild(doc.createTextNode(String.valueOf(prcCountMap.get("CNT"))));
						rowTotal = rowTotal + Integer.parseInt(String.valueOf(prcCountMap.get("CNT")));
					}
				}
			}
			/*
			Iterator<String> keys = pieDataSetMap.keySet().iterator();
			while( keys.hasNext() ){
				String strKey = keys.next();
				String strValue = StringUtil.checkNull(pieDataSetMap.get(strKey));
				
				pieDataSet += strValue +(keys.hasNext() ? "," : "");
			}
			*/
			for (int p=0; p<pieDataList.size(); p++) {
				PieDataSet_CL01005 += pieDataList.get(p) +(p != pieDataList.size()-1 ? "," : "");
	        }
			model.put("PieDataSet_CL01005", PieDataSet_CL01005);

			level4TotalMap.put("TTL", levell4TtlCnt);
			level5TotalMap.put("TTL", activityTtlCnt);


			rowTotal = 0; // Total 값 초기화


			Map getMap = new HashMap();
			System.out.println(itemClassCodeList.size());
			String PieDataSet_CL01006 = "";
			for (int i = 0; i < itemClassCodeList.size(); i++) {
				
				Map barStackedDataSetMap= new HashMap();
				Map activityColTtlMap = new HashMap();
				String barStackedDataSet = "";
				
				Map tempMap = (Map) itemClassCodeList.get(i);
				int Level = Integer.parseInt(tempMap.get("Level").toString());
				String itemClassCode = tempMap.get("ItemClassCode").toString();
				
				if(itemClassCode.equals("CL01005") || itemClassCode.equals("CL01006")) {
					getMap.put("ItemClassCode", itemClassCode);
					getMap.put("ItemClassLevel", Level);
					getMap.put("AttrTypeCode", (itemClassCode.equals("CL01005") ? "AT00026" : "AT00037"));
					
					if(itemClassCode.equals("CL01005")) {
						activityColTtlMap = level4TotalMap;
					}else if(itemClassCode.equals("CL01006")) {
						activityColTtlMap = level5TotalMap;
					}
						
					Map<String, Integer> activityTotalMap = new HashMap<String, Integer>();

					setMap.put("AttrTypeCode", getMap.get("AttrTypeCode"));
					List activityLovCodeList = null;
					try {
						activityLovCodeList = commonService.selectList("analysis_SQL.getLovCodeList", setMap);
					} catch (Exception e) {
						throw new ExceptionUtil(e.toString());
					}
					
					BigDecimal Ttl = new BigDecimal(StringUtil.checkNull(activityColTtlMap.get("TTL")));

					if (activityLovCodeList != null) {

						for (int index = 0; index < activityLovCodeList.size(); index++) {
							Map map = (Map) activityLovCodeList.get(index);

							String lovValue = (String) map.get("Value");
							String lovCode = (String) map.get("LovCode");
							itemClassCode = getMap.get("ItemClassCode").toString();

							// 해당 activity 건수 취득
							setMap.put("LovCode", lovCode);
							setMap.put("AttrTypeCode", getMap.get("AttrTypeCode"));
							setMap.put("ItemClassCode", getMap.get("ItemClassCode"));
							List activityCntList = null;
							try {
								if (!itemClassCode.equals("CL01006"))
									activityCntList = commonService.selectList("analysis_SQL.getLovCountList", setMap);
								else
									activityCntList = commonService.selectList("analysis_SQL.getLovCountListL5", setMap);

							} catch (Exception e) {
								throw new ExceptionUtil(e.toString());
							}
							
							if (activityCntList.size() == 0) {
								for (int p = 0; p < level1NameList.size(); p++) {
									//cell.appendChild(doc.createTextNode("0%"));
									Map level1NameMap = (Map) level1NameList.get(p);

									barStackedDataSetMap.put(level1NameMap.get("Identifier"), StringUtil.checkNull(barStackedDataSetMap.get(level1NameMap.get("Identifier")), "{ month:\""+level1NameMap.get("NAME")+"\",") + "\""+lovValue+"\":0 ,");
								}
							} else {
								Map activityCntMap = new HashMap();
								//activityTotalMap = new HashMap();
								for (int p = 0; p < activityCntList.size(); p++) {
									Map cntMap = (Map) activityCntList.get(p);
									activityCntMap.put(String.valueOf(cntMap.get("L1ItemID")), String.valueOf(cntMap.get("CNT")));
								}
								
								for (int p = 0; p < level1NameList.size(); p++) {
									Map level1NameMap = (Map) level1NameList.get(p);
									String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));

									BigDecimal nowCnt = new BigDecimal(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0"));

									
									//cell.appendChild(doc.createTextNode(getRatio(colTotal, nowCnt))); // 비율 계산
									
									rowTotal = rowTotal + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0"));

									if (activityTotalMap.containsKey(l1ItemID)) {
										int total = activityTotalMap.get(l1ItemID);
										activityTotalMap.remove(l1ItemID);
										activityTotalMap.put(l1ItemID,
												total + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
									} else {
										activityTotalMap.put(l1ItemID,
												Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
									}
									barStackedDataSetMap.put(level1NameMap.get("Identifier"), StringUtil.checkNull(barStackedDataSetMap.get(level1NameMap.get("Identifier")), "{ month:\""+level1NameMap.get("NAME")+"\",") + "\""+lovValue+"\":"+nowCnt+",");
								}
								
							}
							
							// Total값 설정
							//cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));

							BigDecimal nowCnt = new BigDecimal(String.valueOf(rowTotal));
							if(itemClassCode.equals("CL01006")) {
								PieDataSet_CL01006 += "{ id: \""+lovValue+"\", value: "+Integer.parseInt(getRatio(Ttl, nowCnt).replace("%", ""))+", color: l6Color["+index+"], month: \""+lovValue+"\" },";
							}
							rowTotal = 0; // Total 값 초기화
							
							model.put("activityLovCodeList_"+itemClassCode, activityLovCodeList);
						}
					}
					rowTotal = 0;
					/* N/A */
					
					//appendChild(doc.createTextNode("N/A"));
					

					for (int p = 0; p < level1NameList.size(); p++) {
						Map map = (Map) level1NameList.get(p);
						String l1ItemId = String.valueOf(map.get("ItemID"));

						int manualCnt = 0; // ERP, Legacy 이외 + 미설정된 아이템
						String activityCnt = StringUtil.checkNull(activityTotalMap.get(l1ItemId), "0");
						
						if ("0".equals(StringUtil.checkNull(activityColTtlMap.get(l1ItemId), "0"))) {
							manualCnt = 0;
						} else {
							manualCnt = Integer.parseInt(StringUtil.checkNull(activityColTtlMap.get(l1ItemId),"0")) - (Integer.parseInt(activityCnt));
						}
						
						BigDecimal nowCnt = new BigDecimal(String.valueOf(manualCnt));
						rowTotal = rowTotal + Integer.parseInt(String.valueOf(manualCnt));
						  
						barStackedDataSetMap.put(map.get("Identifier"), StringUtil.checkNull(barStackedDataSetMap.get(map.get("Identifier"))) + "\"N/A\":"+nowCnt+" }");
					}
					// Total값 설정
					//cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
					
					BigDecimal naCnt = new BigDecimal(String.valueOf(rowTotal));
					
					//cell.appendChild(doc.createTextNode(getRatio(Ttl, naCnt)));
					if(itemClassCode.equals("CL01006")) {
						PieDataSet_CL01006 += "{ id: \"N/A\", value: "+Integer.parseInt(getRatio(Ttl, naCnt).replace("%", ""))+", color: l6Color["+activityLovCodeList.size()+"], month: \"N/A\" }";
					}
					rowTotal = 0;

					for (int p = 0; p < level1NameList.size(); p++) {
						Map map = (Map) level1NameList.get(p);
						String l1ItemId = String.valueOf(map.get("ItemID"));
						int totalCnt = Integer.parseInt(StringUtil.checkNull(activityColTtlMap.get(l1ItemId), "0"));
						rowTotal = rowTotal + Integer.parseInt(String.valueOf(totalCnt));
					}

					rowTotal = 0; // Total 값 초기화
					
					Iterator<String> keys = barStackedDataSetMap.keySet().iterator();
					while( keys.hasNext() ){
						String strKey = keys.next();
						String strValue = StringUtil.checkNull(barStackedDataSetMap.get(strKey));
						
						barStackedDataSet += strValue +(keys.hasNext() ? "," : "");
					}
					model.put("barStackedDataSet_"+itemClassCode, barStackedDataSet);
				}
			}

			model.put("PieDataSet_CL01006", PieDataSet_CL01006);
			
			// imension 검색조건:DimtypeList
			List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);
			model.put("dimTypeList", dimTypeList);
			
			
			model.put("itemClassCodeList", itemClassCodeList);
			model.put("newPrcCntList", newPrcCntList);
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/newItemStatisticsChart");
	}
	
	/**
	 * Process 통계 (2014/11/20) TW_PROCESS 테이블의 데이터 이용
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/admin/newItemStatistics.do")
	public String newItemStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		List data = new ArrayList();
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType")));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			/* xml 파일명 설정 */
			String xmlFilName = "upload/processStatistics.xml";
			JSONArray header = new JSONArray();
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));

			/* update 버튼 클릭으로 본 엑션을 호출한 경우 Process Insert procedure를 기동한다 */
			if (!StringUtil.checkNull(request.getParameter("eventMode")).isEmpty()) {
				commonService.insert("analysis_SQL.insertTwProcess", setMap);
			}

			setMap.put("LanguageID", languageID);

			// Dimension 검색 정보 설정
			if (!StringUtil.checkNull(request.getParameter("DimTypeID")).isEmpty()) {
				setMap.put("DimTypeID", request.getParameter("DimTypeID"));
				model.put("DimTypeID", request.getParameter("DimTypeID"));
				if (!StringUtil.checkNull(request.getParameter("DimValueID")).isEmpty()) {
					setMap.put("DimValueID", request.getParameter("DimValueID"));
					model.put("DimValueID", request.getParameter("DimValueID"));
				}
			}

			// get Level1 NameList (grid header표시용)
			List level1NameList = commonService.selectList("analysis_SQL.getLevel1Name", setMap);
//			setNewItemStatisticsData(filepath, level1NameList, xmlFilName, setMap, request);
			data.addAll(getDataByClass(level1NameList));

			Map map = new HashMap<>();
			for (int j = 0; j < level1NameList.size(); j++) {
				Map level1NameMap = (Map) level1NameList.get(j);
				map.put("id", level1NameMap.get("ItemID"));
				map.put("text", level1NameMap.get("label"));
				 header.put(map);
			}

			// Dimension 검색조건:DimtypeList
			List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);
			model.put("dimTypeList", dimTypeList);
			
			/* role row 생성 */
			Map roleCntMap = getCNList(level1NameList, setMap,"CN00201", "toItemID");
			data.add(roleCntMap);
			
			/* System row 생성 */
			Map controlCntMap = getCNList(level1NameList, setMap, "CN00104", "toItemID");
//			rowId = controlCntMap.get("rowId");
			data.add(controlCntMap);

			/* Rule set row 생성 */
			Map ruleSetCntMap = getCNList( level1NameList, setMap, "CN00107", "toItemID");
//			rowId = ruleSetCntMap.get("rowId");
			data.add(ruleSetCntMap);

			/* SOP row 생성 */
			Map kpiCntMap = getCNList(level1NameList, setMap, "CN00105", "toItemID");
//			rowId = kpiCntMap.get("rowId");
			data.add(kpiCntMap);
			
			JSONArray gridData = new JSONArray(data);
			model.put("gridData", gridData);
			model.put("level1Name", header);
			model.put("cnt", (level1NameList.size() + 4) * 2);
			model.put("xmlFilName", xmlFilName);
			model.put("isMainMenu", isMainMenu);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/newItemStatistics");
	}
	
	private List getDataByClass(List level1NameList) throws ExceptionUtil {
		List list = new ArrayList();
		Map data = new HashMap();
		Map setMap = new HashMap();
		try {
			String classCode = "CL01002";
			Map conditionMap = new HashMap();

			List newPrcCntList = new ArrayList();
			Map newPrcCntMap = new HashMap();
			int totalCNT = 0;

			for (int i = 0; i < level1NameList.size(); i++) {
				Map map = (Map) level1NameList.get(i);
				conditionMap.put(String.valueOf(map.get("ItemID")), String.valueOf(map.get("label")));
			}
			
			setMap.put("ItemTypeCode", "OJ00001");
			List itemClassCodeList = commonService.selectList("analysis_SQL.getItemClassCodeList", setMap);

			int MaxLevel = Integer.parseInt(commonService.selectString("analysis_SQL.getItemClassMaxLevel", setMap));
			
			List prcCountList = new ArrayList();
			for (int icidx = 0; icidx < itemClassCodeList.size(); icidx++) {
				data = new HashMap();
				totalCNT = 0;
				
				Map tempMap = (Map) itemClassCodeList.get(icidx);
				String itemClassCode = tempMap.get("ItemClassCode").toString();
				int Level = Integer.parseInt(tempMap.get("Level").toString());

				setMap.put("ItemClassCode", itemClassCode);

				if ("CL01005".equals(itemClassCode))
					setMap.put("isDim", "Y");
				else if (!"CL01006".equals(itemClassCode))
					setMap.put("isDim", "N");

				if (icidx != itemClassCodeList.size() - 1) {
					prcCountList = commonService.selectList("analysis_SQL.getPrcCountList", setMap);
				} else {
					if (setMap.containsKey("DimTypeID")) {
						String parentItemIDs = getItemDimListOfParent(setMap);
						setMap.put("ParentItemIDs", parentItemIDs);
						if (parentItemIDs.isEmpty()) {
							setMap.put("isNothingParent", "Y");
						}
					}
					prcCountList = commonService.selectList("analysis_SQL.getPrcCountListL5", setMap);
				}
								
				if(icidx < itemClassCodeList.size() - 2) {
					data.put("id", tempMap.get("ItemClassCode"));
					data.put("class", setTitleCell(tempMap.get("Level").toString()));
					data.put("class-colspan", "2");

					for (int i = 0; i < prcCountList.size(); i++) {
						Map map = (Map) prcCountList.get(i);
						data.put(map.get("L1ItemID").toString(),Integer.parseInt(map.get("CNT").toString()));
						totalCNT = totalCNT + Integer.parseInt(map.get("CNT").toString());
					}
					data.put("total", totalCNT);
					list.add(data);
				} else {
					Map getMap = new HashMap();
					getMap.put("ItemClassCode", tempMap.get("ItemClassCode"));
					getMap.put("ItemClassLevel", tempMap.get("Level"));
					getMap.put("AttrTypeCode", (icidx == itemClassCodeList.size() - 2 ? "AT00026" : "AT00037"));
					
					List activityLovCodeList = commonService.selectList("analysis_SQL.getLovCodeList", getMap);
					
					if (activityLovCodeList.size() > 0) {
						for (int index = 0; index < activityLovCodeList.size(); index++) {
							data = new HashMap();
							Map map = (Map) activityLovCodeList.get(index);
							data.put("id", tempMap.get("ItemClassCode") + "-" + map.get("LovCode"));
							data.put("class", setTitleCell(tempMap.get("Level").toString()));
							data.put("class-sub", map.get("Value"));
							
							List <Map<String, Object>> activityCntList = null;
							getMap.put("LovCode", map.get("LovCode"));
							if (Integer.parseInt(String.valueOf(tempMap.get("Level"))) == MaxLevel - 1)
								activityCntList = commonService.selectList("analysis_SQL.getLovCountList", getMap);
							else
								activityCntList = commonService.selectList("analysis_SQL.getLovCountListL5", getMap);
							
							Optional<BigDecimal> colTotalCountOptional = Optional.ofNullable(activityCntList.stream()
								    .map(item -> (Integer) item.get("CNT")) 
								    .map(BigDecimal::valueOf)
								    .reduce(BigDecimal.ZERO, BigDecimal::add));
							
							BigDecimal colTotal = colTotalCountOptional.orElse(BigDecimal.ZERO);
							
							for (int i = 0; i < activityCntList.size(); i++) {
								Map cntMap = (Map) activityCntList.get(i);
								data.put(cntMap.get("L1ItemID"), String.valueOf(cntMap.get("CNT")));
							}
							
							list.add(data);
						}
						
						data = new HashMap();
						data.put("id", tempMap.get("ItemClassCode") + "-na");
						data.put("class", setTitleCell(tempMap.get("Level").toString()));
						data.put("class-sub", "N/A");
						list.add(data);
					}
					
					data = new HashMap();
					data.put("id", tempMap.get("ItemClassCode"));
					data.put("class", setTitleCell(tempMap.get("Level").toString()));
					data.put("class-sub", "Total");
					
					for (int i = 0; i < prcCountList.size(); i++) {
						Map map = (Map) prcCountList.get(i);
						data.put(map.get("L1ItemID").toString(),Integer.parseInt(map.get("CNT").toString()));
						totalCNT = totalCNT + Integer.parseInt(map.get("CNT").toString());
					}
					data.put("total", totalCNT);
					list.add(data);
				}
			}
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return list;
	}

	private Map getCNList(List level1NameList, Map setMap, String itemTypeCode, String itemFromTo) throws ExceptionUtil {
		Map map = new HashMap();
		try {
			map.put("id", itemTypeCode);
			if ("CN00107".equals(itemTypeCode)) { // Rule set
				map.put("class", "Process/Rule");
			} else if ("CN01301".equals(itemTypeCode)) { // PI
				map.put("class", "PI");
			}else if ("CN00201".equals(itemTypeCode)) { // Process/Role
				map.put("class", "Process/Role");
			} else if ("CN00104".equals(itemTypeCode)) { // System
				map.put("class", "Process/System");
			} else { // SOP
				map.put("class", "Process/SOP");
			}
			
			for (int i = 0; i < level1NameList.size(); i++) {
				Map level1NameMap = (Map) level1NameList.get(i);
				String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));

				// Mapping된 L4
				setMap.put("ItemTypeCode", itemTypeCode);
				setMap.put("L1ItemID", l1ItemID);
				List cnItemList = commonService.selectList("analysis_SQL.getCnItemList", setMap);
				String cnItemCnt = String.valueOf(cnItemList.size());

				// Mapping된 Total L4
				List toItemList = new ArrayList();
				try {
					if (itemFromTo.equals("fromItemID")) {
						toItemList = commonService.selectList("analysis_SQL.getFromItemList", setMap);
					} else { // toItemID
						toItemList = commonService.selectList("analysis_SQL.getToItemList", setMap);
					}
				} catch (Exception e) {
					throw new ExceptionUtil(e.toString());
				}
				String toItemCnt = String.valueOf(toItemList.size());

				// Mapping된 L5
				setMap.put("ItemTypeCode", itemTypeCode);
				setMap.put("L1ItemID", l1ItemID);
				List cnItemListL5 = commonService.selectList("analysis_SQL.getCnL5ItemList", setMap);
				String cnItemCntL5 = String.valueOf(cnItemListL5.size());

				// Mapping된 Total L5
				List toItemListL5 = new ArrayList();
				try {
					if (itemFromTo.equals("fromItemID")) {
						toItemListL5 = commonService.selectList("analysis_SQL.getFromL5ItemList", setMap);
					} else { // toItemID
						toItemListL5 = commonService.selectList("analysis_SQL.getToL5ItemList", setMap);
					}
				} catch (Exception e) {
					throw new ExceptionUtil(e.toString());
				}
				String toItemCntL5 = String.valueOf(toItemListL5.size());
				
				map.put(l1ItemID, cnItemCnt + "/" + toItemCnt);
				map.put(l1ItemID+"-sub", cnItemCntL5 + "/" + toItemCntL5);
			}
			
			// Total값 설정
			// Mapping된 L4
			setMap.put("ItemTypeCode", itemTypeCode);
			setMap.remove("L1ItemID");
			List cnItemList = commonService.selectList("analysis_SQL.getCnItemList", setMap);

			String cnItemCnt = String.valueOf(cnItemList.size());

			// Mapping된 Total L4
			List toItemList = new ArrayList();
			if (itemFromTo.equals("fromItemID")) {
				toItemList = commonService.selectList("analysis_SQL.getFromItemList", setMap);
			} else {
				toItemList = commonService.selectList("analysis_SQL.getToItemList", setMap);
			}

			String toItemCnt = String.valueOf(toItemList.size());

			// Total값 설정
			// Mapping된 L5
			setMap.put("ItemTypeCode", itemTypeCode);
			setMap.remove("L1ItemID");
			List cnItemListL5 = commonService.selectList("analysis_SQL.getCnL5ItemList", setMap);

			String cnItemCntL5 = String.valueOf(cnItemListL5.size());

			// Mapping된 Total L5
			List toItemListL5 = new ArrayList();
			if (itemFromTo.equals("fromItemID")) {
				toItemListL5 = commonService.selectList("analysis_SQL.getFromL5ItemList", setMap);
			} else {
				toItemListL5 = commonService.selectList("analysis_SQL.getToL5ItemList", setMap);
			}

			String toItemCntL5 = String.valueOf(toItemListL5.size());
			
			map.put("total", cnItemCnt + "/" + toItemCnt);
			map.put("total-sub", cnItemCntL5 + "/" + toItemCntL5);
			map.put("class-colspan", "2");
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return map;
	}
			

	/**
	 * Process 통계에 표시할 내용을 xml 파일로 생성
	 * 
	 * @param filepath
	 * @param prcCountList
	 * @param level1NameList
	 * @param xmlFilName
	 * @param setMap
	 * @throws ExceptionUtil
	 */
	private void setNewItemStatisticsData(String filepath, List level1NameList, String xmlFilName, Map setMap,
			HttpServletRequest request) throws ExceptionUtil {

		// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
		// 통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);

			int rowId = 1;
			int rowTotal = 0;
			String classCode = "CL01002";
			String classLevel = "2";

			Map<String, Integer> level4TotalMap = new HashMap<String, Integer>();
			Map<String, Integer> activityTotalMap = new HashMap<String, Integer>();
			int levell4TtlCnt = 0;
			int activityTtlCnt = 0;
			
			// row 엘리먼트
			Element row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));
			rowId++;

			Element cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(setTitleCell(classLevel)));
			cell.setAttribute("colspan", "4"); // title
			cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			Map conditionMap = new HashMap();

			List newPrcCntList = new ArrayList();
			Map newPrcCntMap = new HashMap();

			for (int i = 0; i < level1NameList.size(); i++) {
				Map map = (Map) level1NameList.get(i);
				conditionMap.put(String.valueOf(map.get("ItemID")), String.valueOf(map.get("label")));
			}
			setMap.put("ItemTypeCode", "OJ00001");
			List itemClassCodeList = commonService.selectList("analysis_SQL.getItemClassCodeList", setMap);

			int MaxLevel = Integer.parseInt(commonService.selectString("analysis_SQL.getItemClassMaxLevel", setMap));

			Map prcCountMap = new HashMap();
			List prcCountList = new ArrayList();
			for (int icidx = 0; icidx < itemClassCodeList.size(); icidx++) {
				prcCountMap = new HashMap();
				Map tempMap = (Map) itemClassCodeList.get(icidx);
				String itemClassCode = tempMap.get("ItemClassCode").toString();
				int Level = Integer.parseInt(tempMap.get("Level").toString());
				// get L2 List

				setMap.put("ItemClassCode", itemClassCode);

				if ("CL01005".equals(itemClassCode))
					setMap.put("isDim", "Y");
				else if (!"CL01006".equals(itemClassCode))
					setMap.put("isDim", "N");

				if (icidx != itemClassCodeList.size() - 1) {
					prcCountList = commonService.selectList("analysis_SQL.getPrcCountList", setMap);
				} else {
					if (setMap.containsKey("DimTypeID")) {
						String parentItemIDs = getItemDimListOfParent(setMap);
						setMap.put("ParentItemIDs", parentItemIDs);
						if (parentItemIDs.isEmpty()) {
							setMap.put("isNothingParent", "Y");
						}
					}
					prcCountList = commonService.selectList("analysis_SQL.getPrcCountListL5", setMap);
				}

				for (int i = 0; i < prcCountList.size(); i++) {
					Map map = (Map) prcCountList.get(i);
					prcCountMap.put(String.valueOf(map.get("L1ItemID")), String.valueOf(map.get("CNT")));
				}
				for (int i = 0; i < level1NameList.size(); i++) {
					newPrcCntMap = new HashMap();
					Map map1 = (Map) level1NameList.get(i);
					newPrcCntMap.put("L1ItemID", String.valueOf(map1.get("ItemID")));
					newPrcCntMap.put("ItemClassCode", itemClassCode);
					newPrcCntMap.put("ItemClassLevel", Level);
					if (prcCountMap.containsKey(String.valueOf(map1.get("ItemID")))) {
						newPrcCntMap.put("CNT", prcCountMap.get(String.valueOf(map1.get("ItemID"))));
					} else {
						newPrcCntMap.put("CNT", "0");
					}
					newPrcCntList.add(newPrcCntMap);
				}

			}

			/* Activity 이외의 item count row 생성 */
			for (int i = 0; i < newPrcCntList.size(); i++) {
				prcCountMap = (Map) newPrcCntList.get(i);
				String level1ItemId = StringUtil.checkNull(prcCountMap.get("L1ItemID"));
				if (conditionMap.containsKey(level1ItemId)) {

					int level = Integer.parseInt(prcCountMap.get("ItemClassLevel").toString());
					if (!classCode.equals(prcCountMap.get("ItemClassCode"))) {
						classCode = String.valueOf(prcCountMap.get("ItemClassCode"));
						// if (!classCode.equals("CL01006")) { //TODO:L4의 Total만표시 할때의 조건
						if (level < MaxLevel - 1) {
							// Total cell 값 설정 후, 새로운 row 추가
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
							cell.setAttribute("style", "font-weight:bold;");
							cell.setAttribute("colspan", "2"); // cnt1
							row.appendChild(cell);
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(""));
							row.appendChild(cell);
							rowTotal = 0; // Total 값 초기화

							row = doc.createElement("row");
							rootElement.appendChild(row);
							row.setAttribute("id", String.valueOf(rowId));
							rowId++;

							cell = doc.createElement("cell");
							cell.appendChild(
							doc.createTextNode(setTitleCell(prcCountMap.get("ItemClassLevel").toString())));
							cell.setAttribute("colspan", "4"); // title
							cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
							row.appendChild(cell);
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(""));
							row.appendChild(cell);
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(""));
							row.appendChild(cell);
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(""));
							row.appendChild(cell);
						}
					}

					if (level == MaxLevel) {
						activityTotalMap.put(prcCountMap.get("L1ItemID").toString(),
								Integer.parseInt(prcCountMap.get("CNT").toString()));
						activityTtlCnt = activityTtlCnt + Integer.parseInt(prcCountMap.get("CNT").toString());
					} else if (level == MaxLevel - 1) { // TODO:L4의 Total만표시 할때 : 이 if문의 comment out
						level4TotalMap.put(prcCountMap.get("L1ItemID").toString(),
								Integer.parseInt(prcCountMap.get("CNT").toString()));
						levell4TtlCnt = levell4TtlCnt + Integer.parseInt(prcCountMap.get("CNT").toString());
					} else {
						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(String.valueOf(prcCountMap.get("CNT"))));
						cell.setAttribute("colspan", "2"); // cnt1
						row.appendChild(cell);
						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(""));
						row.appendChild(cell);
						rowTotal = rowTotal + Integer.parseInt(String.valueOf(prcCountMap.get("CNT")));
					}
				}
			}

			activityTotalMap.put("TTL", activityTtlCnt);
			level4TotalMap.put("TTL", levell4TtlCnt);

			// Activity 이외의 item 마지막 row의 Total cell 값 설정
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
			cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
			cell.setAttribute("colspan", "2"); // cnt1
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			rowTotal = 0; // Total 값 초기화

			/* L4 count row 생성 */ // TODO:L4의 Total만표시 할때 : comment out
			// Map<String, Integer> level4CntMap = setLevel4Rows(doc, rootElement, row,
			// cell, rowId, level1NameList, setMap, level4TotalMap);
			// rowId = level4CntMap.get("rowId");

			/* Activity count row 생성 */
			// Map<String, Integer> activityCntMap = setActivityRows(doc, rootElement, row,
			// cell, rowId, level1NameList, setMap, activityTotalMap);
			// rowId = activityCntMap.get("rowId");
			Map getMap = new HashMap();
			System.out.println(itemClassCodeList.size());//4
			for (int i = itemClassCodeList.size() - 2; i < itemClassCodeList.size(); i++) {
				Map tempMap = (Map) itemClassCodeList.get(i);
				getMap.put("ItemClassCode", tempMap.get("ItemClassCode"));
				getMap.put("ItemClassLevel", tempMap.get("Level"));
				getMap.put("AttrTypeCode", (i == itemClassCodeList.size() - 2 ? "AT00026" : "AT00037"));
				System.out.println((i == itemClassCodeList.size() - 2 ? "level4TotalMap" : "activityTotalMap"));
				System.out.println(activityTotalMap.toString());
				Map<String, Integer> CntMap = setLevelActivityRows(doc, rootElement, row, cell, rowId, level1NameList,
						getMap, setMap, (i == itemClassCodeList.size() - 2 ? level4TotalMap : activityTotalMap),
						MaxLevel);
				rowId = CntMap.get("rowId");
			}

			/*
			 * PI row 생성 Map<String, Integer> piCntMap = setCnItemsRow(doc, rootElement,
			 * row, cell, rowId, level1NameList, setMap, "CN01301", "fromItemID"); rowId =
			 * piCntMap.get("rowId");
			 */

			/*
			 * To Check row 생성 Map<String, Integer> toCheckCntMap = setCnItemsRow(doc,
			 * rootElement, row, cell, rowId, level1NameList, setMap, "CN00109",
			 * "toItemID"); rowId = toCheckCntMap.get("rowId");
			 */
			
			/* role row 생성 */
			Map<String, Integer> roleCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap,
					"CN00201", "toItemID");
			rowId = roleCntMap.get("rowId");
			
			/* System row 생성 */
			Map<String, Integer> controlCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList,
					setMap, "CN00104", "toItemID");
			rowId = controlCntMap.get("rowId");

			/* Rule set row 생성 */
			Map<String, Integer> ruleSetCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList,
					setMap, "CN00107", "toItemID");
			rowId = ruleSetCntMap.get("rowId");

			/*
			 * To Check row 생성 Map<String, Integer> toCheckCntMap = setCnItemsRow(doc,
			 * rootElement, row, cell, rowId, level1NameList, setMap, "CN00109",
			 * "toItemID"); rowId = toCheckCntMap.get("rowId");
			 */
			/* SOP row 생성 */
			Map<String, Integer> kpiCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap,
					"CN00105", "toItemID");
			rowId = kpiCntMap.get("rowId");
			

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}

	/**
	 * 부모 레벨의 Item Dim 리스트 취득
	 * 
	 * @param classCode
	 * @param DimTypeId
	 * @param DimValueId
	 * @return
	 * @throws ExceptionUtil
	 */
	private String getItemDimListOfParent(Map setMap) throws ExceptionUtil {
		String result = "";
		try {
			List list = commonService.selectList("analysis_SQL.getItemDimListOfParent", setMap);

			for (int i = 0; i < list.size(); i++) {
				Map map = (Map) list.get(i);
				if (result.isEmpty()) {
					result = String.valueOf(map.get("ItemID"));
				} else {
					result = result + "," + String.valueOf(map.get("ItemID"));
				}
			}
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return result;
	}

	/**
	 * Process map(L4)의 각 row별 count 값을 셋팅한다.
	 * 
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @return
	 * @throws ExceptionUtil
	 */
	private Map<String, Integer> setLevel4Rows(Document doc, Element rootElement, Element row, Element cell, int rowId,
			List level1NameList, Map setMap, Map<String, Integer> level4ColTtlMap) throws ExceptionUtil {
		Map<String, Integer> level4TotalMap = new HashMap<String, Integer>();
		int rowTotal = 0;
		setMap.put("AttrTypeCode", "AT00026");
		List level4LovCodeList = null;
		try {
			level4LovCodeList = commonService.selectList("analysis_SQL.getLovCodeList", setMap);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		BigDecimal l4Ttl = new BigDecimal(StringUtil.checkNull(level4ColTtlMap.get("TTL")));

		if (level4LovCodeList != null) {
			for (int index = 0; index < level4LovCodeList.size(); index++) {
				Map map = (Map) level4LovCodeList.get(index);

				String lovValue = (String) map.get("Value");
				String lovCode = (String) map.get("LovCode");

				if (index == 0) {
					// 첫번째 L4
					row = doc.createElement("row");
					rootElement.appendChild(row);
					row.setAttribute("id", String.valueOf(rowId));
					rowId++;
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(setTitleCell("CL01005")));
					cell.setAttribute("rowspan", String.valueOf(level4LovCodeList.size() + 2)); // col merge
					cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
					cell.setAttribute("colspan", "2"); // cnt1
					row.appendChild(cell);
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(""));
					row.appendChild(cell);
				} else {
					row = doc.createElement("row");
					rootElement.appendChild(row);
					row.setAttribute("id", String.valueOf(rowId));
					rowId++;
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(""));
					row.appendChild(cell);
				}

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(lovValue)); // title 명
				String backColor = l4RowbackColor(index);
				cell.setAttribute("style", "font-weight:bold;" + backColor);
				cell.setAttribute("colspan", "2"); // cnt1
				row.appendChild(cell);
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(""));
				row.appendChild(cell);

				// 해당 activity 건수 취득
				setMap.put("LovCode", lovCode);
				setMap.put("AttrTypeCode", "AT00026");
				// setMap.put("ItemClassCode", "CL01005");
				List level4CntList;
				try {
					level4CntList = commonService.selectList("analysis_SQL.getLovCountList", setMap);
				} catch (Exception e) {
					throw new ExceptionUtil(e.toString());
				}
				if (level4CntList.size() == 0) {
					for (int i = 0; i < level1NameList.size(); i++) {
						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode("0"));
						row.appendChild(cell);
						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode("0%"));
						row.appendChild(cell);
					}
				} else {
					Map level4CntMap = new HashMap();
					for (int i = 0; i < level4CntList.size(); i++) {
						Map cntMap = (Map) level4CntList.get(i);
						level4CntMap.put(String.valueOf(cntMap.get("L1ItemID")), String.valueOf(cntMap.get("CNT")));
					}

					for (int i = 0; i < level1NameList.size(); i++) {
						Map level1NameMap = (Map) level1NameList.get(i);
						String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));

						BigDecimal colTotal = new BigDecimal(StringUtil.checkNull(level4ColTtlMap.get(l1ItemID), "0")); // 해당
																														// 행,Level,Lov의
																														// Total
						BigDecimal nowCnt = new BigDecimal(StringUtil.checkNull(level4CntMap.get(l1ItemID), "0"));

						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode(StringUtil.checkNull(level4CntMap.get(l1ItemID), "0")));
						row.appendChild(cell);
						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode(getRatio(colTotal, nowCnt))); // 비율 계산
						row.appendChild(cell);
						rowTotal = rowTotal + Integer.parseInt(StringUtil.checkNull(level4CntMap.get(l1ItemID), "0"));

						if (level4TotalMap.containsKey(l1ItemID)) {
							int total = level4TotalMap.get(l1ItemID);
							level4TotalMap.remove(l1ItemID);
							level4TotalMap.put(l1ItemID,
									total + Integer.parseInt(StringUtil.checkNull(level4CntMap.get(l1ItemID), "0")));
						} else {
							level4TotalMap.put(l1ItemID,
									Integer.parseInt(StringUtil.checkNull(level4CntMap.get(l1ItemID), "0")));
						}
					}
				}

				// Total값 설정
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
				cell.setAttribute("style", "font-weight:bold;" + backColor);
				row.appendChild(cell);

				BigDecimal nowCnt = new BigDecimal(String.valueOf(rowTotal));
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(getRatio(l4Ttl, nowCnt)));
				cell.setAttribute("style", "font-weight:bold;" + backColor);
				row.appendChild(cell);
				rowTotal = 0; // Total 값 초기화

			}
		}

		/* N/A */
		row = doc.createElement("row");
		rootElement.appendChild(row);
		row.setAttribute("id", String.valueOf(rowId));
		rowId++;
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode("N/A"));
		cell.setAttribute("colspan", "2"); // cnt1
		cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);

		for (int i = 0; i < level1NameList.size(); i++) {
			Map map = (Map) level1NameList.get(i);
			String l1ItemId = String.valueOf(map.get("ItemID"));

			int manualCnt = 0; // ERP, Legacy 이외 + 미설정된 아이템
			String activityCnt = StringUtil.checkNull(level4TotalMap.get(l1ItemId), "0");
			if ("0".equals(StringUtil.checkNull(level4ColTtlMap.get(l1ItemId), "0"))) {
				manualCnt = 0;
			} else {
				manualCnt = level4ColTtlMap.get(l1ItemId) - (Integer.parseInt(activityCnt));
			}

			BigDecimal colTotal = new BigDecimal(StringUtil.checkNull(level4ColTtlMap.get(l1ItemId), "0")); // 해당
																											// 행,Level,Lov의
																											// Total
			BigDecimal nowCnt = new BigDecimal(String.valueOf(manualCnt));

			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(String.valueOf(manualCnt)));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(getRatio(colTotal, nowCnt)));
			row.appendChild(cell);
			rowTotal = rowTotal + Integer.parseInt(String.valueOf(manualCnt));
		}
		// Total값 설정
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
		cell.setAttribute("style", "font-weight:bold;");
		row.appendChild(cell);
		BigDecimal naCnt = new BigDecimal(String.valueOf(rowTotal));
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(getRatio(l4Ttl, naCnt)));
		cell.setAttribute("style", "font-weight:bold;");
		row.appendChild(cell);
		rowTotal = 0; // Total 값 초기화

		// Level4 Total
		row = doc.createElement("row");
		rootElement.appendChild(row);
		row.setAttribute("id", String.valueOf(rowId));
		rowId++;
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode("Total"));
		cell.setAttribute("colspan", "2"); // cnt1
		cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);

		for (int i = 0; i < level1NameList.size(); i++) {
			Map map = (Map) level1NameList.get(i);
			String l1ItemId = String.valueOf(map.get("ItemID"));
			int totalCnt = Integer.parseInt(StringUtil.checkNull(level4ColTtlMap.get(l1ItemId), "0"));
			cell = doc.createElement("cell");
			cell.setAttribute("style", "background-color:#f2f2f2;");
			cell.appendChild(doc.createTextNode(String.valueOf(totalCnt)));
			cell.setAttribute("colspan", "2"); // cnt1
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			rowTotal = rowTotal + Integer.parseInt(String.valueOf(totalCnt));
		}

		// Total값 설정
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
		cell.setAttribute("colspan", "2"); // cnt1
		cell.setAttribute("style",
				"font-weight:bold;color:#0D65B7;text-decoration:underline;background-color:#f2f2f2;");
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);
		rowTotal = 0; // Total 값 초기화

		level4TotalMap.put("rowId", rowId);
		return level4TotalMap;
	}

	/**
	 * Activity(L5)의 각 row별 count 값을 셋팅한다.
	 * 
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @return
	 * @throws ExceptionUtil
	 */
	private Map<String, Integer> setActivityRows(Document doc, Element rootElement, Element row, Element cell,
			int rowId, List level1NameList, Map setMap, Map<String, Integer> activityColTtlMap) throws ExceptionUtil {
		Map<String, Integer> activityTotalMap = new HashMap<String, Integer>();
		int rowTotal = 0;

		setMap.put("AttrTypeCode", "AT00037");
		List activityLovCodeList = null;
		try {
			activityLovCodeList = commonService.selectList("analysis_SQL.getLovCodeList", setMap);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		BigDecimal l5Ttl = new BigDecimal(StringUtil.checkNull(activityColTtlMap.get("TTL")));

		if (activityLovCodeList != null) {
			for (int index = 0; index < activityLovCodeList.size(); index++) {
				Map map = (Map) activityLovCodeList.get(index);

				String lovValue = (String) map.get("Value");
				String lovCode = (String) map.get("LovCode");

				if (index == 0) {
					// 첫번째 activity
					row = doc.createElement("row");
					rootElement.appendChild(row);
					row.setAttribute("id", String.valueOf(rowId));
					rowId++;
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(setTitleCell("CL01006")));
					cell.setAttribute("rowspan", String.valueOf(activityLovCodeList.size() + 2)); // col merge
					cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
					cell.setAttribute("colspan", "2"); // cnt1
					row.appendChild(cell);
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(""));
					row.appendChild(cell);
				} else {
					row = doc.createElement("row");
					rootElement.appendChild(row);
					row.setAttribute("id", String.valueOf(rowId));
					rowId++;
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(""));
					row.appendChild(cell);
				}

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(lovValue)); // title 명
				String backColor = l5RowbackColor(index);
				cell.setAttribute("style", "font-weight:bold;" + backColor);
				cell.setAttribute("colspan", "2"); // cnt1
				row.appendChild(cell);
				
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(""));
				row.appendChild(cell);

				// 해당 activity 건수 취득
				setMap.put("LovCode", lovCode);
				setMap.put("AttrTypeCode", "AT00037");
				setMap.put("ItemClassCode", "CL01006");
				List activityCntList = null;
				try {
					activityCntList = commonService.selectList("analysis_SQL.getLovCountListL5", setMap);
				} catch (Exception e) {
					throw new ExceptionUtil(e.toString());
				}
				if (activityCntList.size() == 0) {
					for (int i = 0; i < level1NameList.size(); i++) {
						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode("0"));
						row.appendChild(cell);
						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode("0%"));
						row.appendChild(cell);
					}
				} else {
					Map activityCntMap = new HashMap();
					for (int i = 0; i < activityCntList.size(); i++) {
						Map cntMap = (Map) activityCntList.get(i);
						activityCntMap.put(String.valueOf(cntMap.get("L1ItemID")), String.valueOf(cntMap.get("CNT")));
					}

					for (int i = 0; i < level1NameList.size(); i++) {
						Map level1NameMap = (Map) level1NameList.get(i);
						String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));

						BigDecimal colTotal = new BigDecimal(
								StringUtil.checkNull(activityColTtlMap.get(l1ItemID), "0")); // 해당 행,Level,Lov의 Total
						BigDecimal nowCnt = new BigDecimal(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0"));

						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
						row.appendChild(cell);
						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode(getRatio(colTotal, nowCnt))); // 비율 계산
						row.appendChild(cell);
						rowTotal = rowTotal + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0"));

						if (activityTotalMap.containsKey(l1ItemID)) {
							int total = activityTotalMap.get(l1ItemID);
							activityTotalMap.remove(l1ItemID);
							activityTotalMap.put(l1ItemID,
									total + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
						} else {
							activityTotalMap.put(l1ItemID,
									Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
						}
					}
				}

				// Total값 설정
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
				cell.setAttribute("style", "font-weight:bold;" + backColor);
				row.appendChild(cell);

				BigDecimal nowCnt = new BigDecimal(String.valueOf(rowTotal));
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(getRatio(l5Ttl, nowCnt)));
				cell.setAttribute("style", "font-weight:bold;" + backColor);
				row.appendChild(cell);
				rowTotal = 0; // Total 값 초기화
			}
		}

		/* N/A */
		row = doc.createElement("row");
		rootElement.appendChild(row);
		row.setAttribute("id", String.valueOf(rowId));
		rowId++;
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode("N/A"));
		cell.setAttribute("colspan", "2"); // cnt1
		cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);

		for (int i = 0; i < level1NameList.size(); i++) {
			Map map = (Map) level1NameList.get(i);
			String l1ItemId = String.valueOf(map.get("ItemID"));

			int manualCnt = 0; // ERP, Legacy 이외 + 미설정된 아이템
			String activityCnt = StringUtil.checkNull(activityTotalMap.get(l1ItemId), "0");
			if ("0".equals(StringUtil.checkNull(activityColTtlMap.get(l1ItemId), "0"))) {
				manualCnt = 0;
			} else {
				manualCnt = activityColTtlMap.get(l1ItemId) - (Integer.parseInt(activityCnt));
			}

			BigDecimal colTotal = new BigDecimal(StringUtil.checkNull(activityColTtlMap.get(l1ItemId), "0")); // 해당
																												// 행,Level,Lov의
																												// Total
			BigDecimal nowCnt = new BigDecimal(String.valueOf(manualCnt));

			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(String.valueOf(manualCnt)));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(getRatio(colTotal, nowCnt)));
			row.appendChild(cell);
			rowTotal = rowTotal + Integer.parseInt(String.valueOf(manualCnt));
		}
		// Total값 설정
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
		cell.setAttribute("style", "font-weight:bold;");
		row.appendChild(cell);

		BigDecimal naCnt = new BigDecimal(String.valueOf(rowTotal));
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(getRatio(l5Ttl, naCnt)));
		cell.setAttribute("style", "font-weight:bold;");
		row.appendChild(cell);
		rowTotal = 0; // Total 값 초기화

		// Activity Total
		row = doc.createElement("row");
		rootElement.appendChild(row);
		row.setAttribute("id", String.valueOf(rowId));
		rowId++;
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode("Total"));
		cell.setAttribute("colspan", "2"); // cnt1
		cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);

		for (int i = 0; i < level1NameList.size(); i++) {
			Map map = (Map) level1NameList.get(i);
			String l1ItemId = String.valueOf(map.get("ItemID"));
			// int totalCnt = activityTotalMap.get(l1ItemId);
			int totalCnt = Integer.parseInt(StringUtil.checkNull(activityColTtlMap.get(l1ItemId), "0"));
			cell = doc.createElement("cell");
			cell.setAttribute("style", "background-color:#f2f2f2;");
			cell.appendChild(doc.createTextNode(String.valueOf(totalCnt)));
			cell.setAttribute("colspan", "2"); // cnt1
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			rowTotal = rowTotal + Integer.parseInt(String.valueOf(totalCnt));
		}

		// Total값 설정
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
		cell.setAttribute("colspan", "2"); // cnt1
		cell.setAttribute("style",
				"font-weight:bold;color:#0D65B7;text-decoration:underline;background-color:#f2f2f2;");
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);
		rowTotal = 0; // Total 값 초기화

		activityTotalMap.put("rowId", rowId);
		return activityTotalMap;
	}

	/**
	 * Activity(L5)의 각 row별 count 값을 셋팅한다.
	 * 
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @return
	 * @throws ExceptionUtil
	 */
	private Map<String, Integer> setLevelActivityRows(Document doc, Element rootElement, Element row, Element cell,
			int rowId, List level1NameList, Map getMap, Map setMap, Map<String, Integer> activityColTtlMap,
			int MaxLevel) throws ExceptionUtil {
		Map<String, Integer> activityTotalMap = new HashMap<String, Integer>();
		int rowTotal = 0;

		setMap.put("AttrTypeCode", getMap.get("AttrTypeCode"));
		List activityLovCodeList = null;
		try {
			activityLovCodeList = commonService.selectList("analysis_SQL.getLovCodeList", setMap);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		BigDecimal Ttl = new BigDecimal(StringUtil.checkNull(activityColTtlMap.get("TTL")));
		String itemClassLevel = "";
		if (activityLovCodeList != null) {
			for (int index = 0; index < activityLovCodeList.size(); index++) {
				Map map = (Map) activityLovCodeList.get(index);

				String lovValue = (String) map.get("Value");
				String lovCode = (String) map.get("LovCode");
				 itemClassLevel = getMap.get("ItemClassLevel").toString();
				
					  
					    if (index == 0) {
					        // 첫번째 activity
					        row = doc.createElement("row");
					        rootElement.appendChild(row);
					        row.setAttribute("id", String.valueOf(rowId));
					        rowId++;
					        cell = doc.createElement("cell");
					        cell.appendChild(doc.createTextNode(setTitleCell(itemClassLevel)));
					        cell.setAttribute("rowspan", String.valueOf(activityLovCodeList.size() + 2)); // col merge
					        cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
					        cell.setAttribute("colspan", "2"); // cnt1
					        row.appendChild(cell);

					        cell = doc.createElement("cell");
					        cell.appendChild(doc.createTextNode(""));
					        row.appendChild(cell);
					    } else {
					        row = doc.createElement("row");
					        rootElement.appendChild(row);
					        row.setAttribute("id", String.valueOf(rowId));
					        rowId++;

					        cell = doc.createElement("cell");
					        cell.appendChild(doc.createTextNode(""));
					        row.appendChild(cell);
					    }
		
			
				String backColor = "";


				if(lovCode.equals("LV26001")||lovCode.equals("LV37001")) {
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(lovValue)); // title 명
					cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
					cell.setAttribute("colspan", "2"); // cnt1
					row.appendChild(cell);
					
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(""));
					row.appendChild(cell);
				}else {
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(setTitleCell(itemClassLevel)));
					cell.setAttribute("style", "display:none;");
					row.appendChild(cell);
					
			
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(lovValue)); // title 명
					cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
					cell.setAttribute("colspan", "2"); // cnt1
					row.appendChild(cell);
					
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(""));
					row.appendChild(cell);
					
				}
			
			
				
				
				
				// 해당 activity 건수 취득
				setMap.put("LovCode", lovCode);
				setMap.put("AttrTypeCode", getMap.get("AttrTypeCode"));
				setMap.put("ItemClassCode", getMap.get("ItemClassCode"));
				List activityCntList = null;
				try {
					if (Integer.parseInt(itemClassLevel) == MaxLevel - 1)
						activityCntList = commonService.selectList("analysis_SQL.getLovCountList", setMap);
					else
						activityCntList = commonService.selectList("analysis_SQL.getLovCountListL5", setMap);

				} catch (Exception e) {
					throw new ExceptionUtil(e.toString());
				}
				if (activityCntList.size() == 0) {
					for (int i = 0; i < level1NameList.size(); i++) {
						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode("0"));
						row.appendChild(cell);
						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode("0%"));
						row.appendChild(cell);
					}
				} else {
					Map activityCntMap = new HashMap();
					for (int i = 0; i < activityCntList.size(); i++) {
						Map cntMap = (Map) activityCntList.get(i);
						activityCntMap.put(String.valueOf(cntMap.get("L1ItemID")), String.valueOf(cntMap.get("CNT")));
					}

					for (int i = 0; i < level1NameList.size(); i++) {
						Map level1NameMap = (Map) level1NameList.get(i);
						String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));

						BigDecimal colTotal = new BigDecimal(
								StringUtil.checkNull(activityColTtlMap.get(l1ItemID), "0")); // 해당 행,Level,Lov의 Total
						BigDecimal nowCnt = new BigDecimal(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0"));

				
						
						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
						row.appendChild(cell);
					
						cell = doc.createElement("cell");
						cell.setAttribute("style", backColor);
						cell.appendChild(doc.createTextNode(getRatio(colTotal, nowCnt))); // 비율 계산
						row.appendChild(cell);
						rowTotal = rowTotal + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0"));

						if (activityTotalMap.containsKey(l1ItemID)) {
							int total = activityTotalMap.get(l1ItemID);
							activityTotalMap.remove(l1ItemID);
							activityTotalMap.put(l1ItemID,
									total + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
						} else {
							activityTotalMap.put(l1ItemID,
									Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
						}
					}
				}

				// Total값 설정
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
				cell.setAttribute("style", "font-weight:bold;" + backColor);
				row.appendChild(cell);

				BigDecimal nowCnt = new BigDecimal(String.valueOf(rowTotal));
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(getRatio(Ttl, nowCnt)));
				cell.setAttribute("style", "font-weight:bold;" + backColor);
				row.appendChild(cell);
				rowTotal = 0; // Total 값 초기화
			}
		}

	

	    


		    /* N/A */
		    row = doc.createElement("row");
		    rootElement.appendChild(row);
		    row.setAttribute("id", String.valueOf(rowId));
		    rowId++;
		    cell = doc.createElement("cell");
		    cell.appendChild(doc.createTextNode(setTitleCell(itemClassLevel)));
		    cell.setAttribute("style", "display:none;");
			row.appendChild(cell);
		        
		    cell = doc.createElement("cell");
		    cell.appendChild(doc.createTextNode(setTitleCell(itemClassLevel)));
		    cell.setAttribute("style", "display:none;");
			row.appendChild(cell);
			
		    cell = doc.createElement("cell");
		    cell.appendChild(doc.createTextNode("N/A"));
		    cell.setAttribute("colspan", "2"); // cnt1
		    cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
		    row.appendChild(cell);
		    cell = doc.createElement("cell");
		    cell.appendChild(doc.createTextNode(""));
		    row.appendChild(cell);
	

		for (int i = 0; i < level1NameList.size(); i++) {
			Map map = (Map) level1NameList.get(i);
			String l1ItemId = String.valueOf(map.get("ItemID"));

			int manualCnt = 0; // ERP, Legacy 이외 + 미설정된 아이템
			String activityCnt = StringUtil.checkNull(activityTotalMap.get(l1ItemId), "0");
			if ("0".equals(StringUtil.checkNull(activityColTtlMap.get(l1ItemId), "0"))) {
				manualCnt = 0;
			} else {
				manualCnt = activityColTtlMap.get(l1ItemId) - (Integer.parseInt(activityCnt));
			}

			BigDecimal colTotal = new BigDecimal(StringUtil.checkNull(activityColTtlMap.get(l1ItemId), "0")); // 해당
																												// 행,Level,Lov의
																												// Total
			BigDecimal nowCnt = new BigDecimal(String.valueOf(manualCnt));

			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(String.valueOf(manualCnt)));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(getRatio(colTotal, nowCnt)));
			row.appendChild(cell);
			rowTotal = rowTotal + Integer.parseInt(String.valueOf(manualCnt));
		}
		// Total값 설정
		
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
		cell.setAttribute("style", "font-weight:bold;");
		row.appendChild(cell);


		BigDecimal naCnt = new BigDecimal(String.valueOf(rowTotal));
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(getRatio(Ttl, naCnt)));
		cell.setAttribute("style", "font-weight:bold;");
		row.appendChild(cell);
		rowTotal = 0; // Total 값 초기화

		// Activity Total
		row = doc.createElement("row");
		rootElement.appendChild(row);
		row.setAttribute("id", String.valueOf(rowId));
		rowId++;
	
		
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(setTitleCell(itemClassLevel)));
		cell.setAttribute("style", "display:none;");
		row.appendChild(cell);
		
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(setTitleCell(itemClassLevel)));
		cell.setAttribute("style", "display:none;");
		row.appendChild(cell);
		
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode("Total"));
		cell.setAttribute("colspan", "2"); // cnt1
		cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
		row.appendChild(cell);
		


		cell = doc.createElement("cell");
		cell.setAttribute("style", "display:none;");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);


		for (int i = 0; i < level1NameList.size(); i++) {
			Map map = (Map) level1NameList.get(i);
			String l1ItemId = String.valueOf(map.get("ItemID"));
			// int totalCnt = activityTotalMap.get(l1ItemId);
			int totalCnt = Integer.parseInt(StringUtil.checkNull(activityColTtlMap.get(l1ItemId), "0"));
			cell = doc.createElement("cell");
			cell.setAttribute("style", "background-color:#f2f2f2;");
			cell.appendChild(doc.createTextNode(String.valueOf(totalCnt)));
			cell.setAttribute("colspan", "2"); // cnt1
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			rowTotal = rowTotal + Integer.parseInt(String.valueOf(totalCnt));
		}

		// Total값 설정
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
		cell.setAttribute("colspan", "2"); // cnt1
		cell.setAttribute("style",
				"font-weight:bold;color:#0D65B7;text-decoration:underline;background-color:#f2f2f2;");
		row.appendChild(cell);
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(""));
		row.appendChild(cell);
		rowTotal = 0; // Total 값 초기화

		activityTotalMap.put("rowId", rowId);
		return activityTotalMap;
	}

	/**
	 * Rule Set (연관항목:CN00107) Count를 설정 한다
	 * 
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @param setMap
	 * @return
	 * @throws ExceptionUtil
	 */
	private Map<String, Integer> setCnItemsRow(Document doc, Element rootElement, Element row, Element cell, int rowId,
			List level1NameList, Map setMap, String itemTypeCode, String itemFromTo) throws ExceptionUtil {

		Map<String, Integer> cnItemsMap = new HashMap<String, Integer>();

		try {
			// Title
			row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));
			rowId++;
			cell = doc.createElement("cell");
			if ("CN00107".equals(itemTypeCode)) { // Rule set
				cell.appendChild(doc.createTextNode("Process/Rule"));
			} else if ("CN01301".equals(itemTypeCode)) { // PI
				cell.appendChild(doc.createTextNode("PI"));
			}else if ("CN00201".equals(itemTypeCode)) { // Process/Role
				cell.appendChild(doc.createTextNode("Process/Role"));
			} /*
				 * else if("CN00109".equals(itemTypeCode)){ // To Check
				 * cell.appendChild(doc.createTextNode("To Check")); }
				 */else if ("CN00104".equals(itemTypeCode)) { // System
				cell.appendChild(doc.createTextNode("Process/System"));
			} else { // SOP
				cell.appendChild(doc.createTextNode("Process/SOP"));
			}
			cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
			cell.setAttribute("colspan", "4");
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			for (int i = 0; i < level1NameList.size(); i++) {
				Map level1NameMap = (Map) level1NameList.get(i);
				String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));

				// Mapping된 L4
				setMap.put("ItemTypeCode", itemTypeCode);
				setMap.put("L1ItemID", l1ItemID);
				List cnItemList = commonService.selectList("analysis_SQL.getCnItemList", setMap);
				String cnItemCnt = String.valueOf(cnItemList.size());

				// Mapping된 Total L4
				List toItemList = new ArrayList();
				try {
					if (itemFromTo.equals("fromItemID")) {
						toItemList = commonService.selectList("analysis_SQL.getFromItemList", setMap);
					} else { // toItemID
						toItemList = commonService.selectList("analysis_SQL.getToItemList", setMap);
					}
				} catch (Exception e) {
					throw new ExceptionUtil(e.toString());
				}
				String toItemCnt = String.valueOf(toItemList.size());

				// Mapping된 L5
				setMap.put("ItemTypeCode", itemTypeCode);
				setMap.put("L1ItemID", l1ItemID);
				List cnItemListL5 = commonService.selectList("analysis_SQL.getCnL5ItemList", setMap);
				String cnItemCntL5 = String.valueOf(cnItemListL5.size());

				// Mapping된 Total L5
				List toItemListL5 = new ArrayList();
				try {
					if (itemFromTo.equals("fromItemID")) {
						toItemListL5 = commonService.selectList("analysis_SQL.getFromL5ItemList", setMap);
					} else { // toItemID
						toItemListL5 = commonService.selectList("analysis_SQL.getToL5ItemList", setMap);
					}
				} catch (Exception e) {
					throw new ExceptionUtil(e.toString());
				}
				String toItemCntL5 = String.valueOf(toItemListL5.size());

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(cnItemCnt + "/" + toItemCnt));
				row.appendChild(cell);
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(cnItemCntL5 + "/" + toItemCntL5));
				row.appendChild(cell);

			}

			// Total값 설정
			// Mapping된 L4
			setMap.put("ItemTypeCode", itemTypeCode);
			setMap.remove("L1ItemID");
			List cnItemList = commonService.selectList("analysis_SQL.getCnItemList", setMap);

			String cnItemCnt = String.valueOf(cnItemList.size());

			// Mapping된 Total L4
			List toItemList = new ArrayList();
			if (itemFromTo.equals("fromItemID")) {
				toItemList = commonService.selectList("analysis_SQL.getFromItemList", setMap);
			} else {
				toItemList = commonService.selectList("analysis_SQL.getToItemList", setMap);
			}

			String toItemCnt = String.valueOf(toItemList.size());

			// Total값 설정
			// Mapping된 L5
			setMap.put("ItemTypeCode", itemTypeCode);
			setMap.remove("L1ItemID");
			List cnItemListL5 = commonService.selectList("analysis_SQL.getCnL5ItemList", setMap);

			String cnItemCntL5 = String.valueOf(cnItemListL5.size());

			// Mapping된 Total L5
			List toItemListL5 = new ArrayList();
			if (itemFromTo.equals("fromItemID")) {
				toItemListL5 = commonService.selectList("analysis_SQL.getFromL5ItemList", setMap);
			} else {
				toItemListL5 = commonService.selectList("analysis_SQL.getToL5ItemList", setMap);
			}

			String toItemCntL5 = String.valueOf(toItemListL5.size());

			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(cnItemCnt + "/" + toItemCnt));
			cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
			cell.appendChild(doc.createTextNode(cnItemCntL5 + "/" + toItemCntL5));
			row.appendChild(cell);

			cnItemsMap.put("rowId", rowId);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return cnItemsMap;
	}

	/**
	 * 아이템 파일 Count를 설정 한다
	 * 
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @param setMap
	 * @return
	 * @throws ExceptionUtil
	 */
	private Map<String, Integer> setItemFileRow(Document doc, Element rootElement, Element row, Element cell, int rowId,
			List level1NameList, Map setMap, HttpServletRequest request) throws ExceptionUtil {

		Map<String, Integer> cnItemsMap = new HashMap<String, Integer>();
		try {
			// Title
			row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));
			rowId++;
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(StringUtil.checkNull(getLabel(request, commonService).get("LN00111"))));
			cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
			cell.setAttribute("colspan", "4");
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			for (int i = 0; i < level1NameList.size(); i++) {
				Map level1NameMap = (Map) level1NameList.get(i);
				String l1ItemID = String.valueOf(level1NameMap.get("ItemID"));

				// 첨부 파일이 하나 이상인 L4개수
				setMap.put("L1ItemID", l1ItemID);
				List l4FileList = commonService.selectList("analysis_SQL.getL4FileList", setMap);
				String l4FileCnt = String.valueOf(l4FileList.size());

				// 첨부파일 건수 Total
				List ttlL4FileList = commonService.selectList("analysis_SQL.getTtlL4FileList", setMap);
				String ttlL4FileCnt = String.valueOf(ttlL4FileList.size());

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(ttlL4FileCnt + "(" + l4FileCnt + ")"));
				cell.setAttribute("colspan", "2");
				row.appendChild(cell);
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(""));
				row.appendChild(cell);

			}

			// Total값 설정
			// 첨부 파일이 하나 이상인 L4개수
			setMap.remove("L1ItemID");
			List l4FileList = commonService.selectList("analysis_SQL.getL4FileList", setMap);
			String l4FileCnt = String.valueOf(l4FileList.size());

			// 첨부파일 건수 Total
			List ttlL4FileList = commonService.selectList("analysis_SQL.getTtlL4FileList", setMap);
			String ttlL4FileCnt = String.valueOf(ttlL4FileList.size());

			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(ttlL4FileCnt + "(" + l4FileCnt + ")"));
			cell.setAttribute("colspan", "2"); // cnt1
			cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			cnItemsMap.put("rowId", rowId);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return cnItemsMap;
	}

	/**
	 * classCode 별 row title 설정
	 * 
	 * @param classCode
	 * @return
	 */
	private String setTitleCell(String classLevel) {
		String result = "";

		if (classLevel.equals("2")) {
			result = "L2";
		} else if (classLevel.equals("3")) {
			result = "L3";
		} else if (classLevel.equals("4")) {
			result = "L4";
		} else if (classLevel.equals("5")) {
			result = "L5";
		} else {
			result = "L6";
		}

		return result;
	}

	/**
	 * L4 background-color return
	 * 
	 * @param classCode
	 * @return
	 */
	private String l4RowbackColor(int index) {
		String result = "";
		if (index == 0) {
			result = "background-color:#E0FFFF;";
		} else if (index == 1) {
			result = "background-color:#FFE1FF;";
		} else if (index == 2) {
			result = "background-color:#EEDD82;";
		} else {
			result = "background-color:#8FBC8F;";
		}

		return result;
	}

	/**
	 * L5 background-color return
	 * 
	 * @param classCode
	 * @return
	 */
	private String l5RowbackColor(int index) {
		String result = "";
		if (index == 0) {
			result = "background-color:#8DB6CD;";
		} else if (index == 1) {
			result = "background-color:#8FBC8F;";
		} else if (index == 2) {
			result = "background-color:#FFDAB9;";
		} else {
			result = "background-color:#EEDD82;";
		}

		return result;
	}

	@RequestMapping(value = "/itemStatistics.do")
	public String itemStatistics(HttpServletRequest request, ModelMap model) throws ExceptionUtil {
		String reportType = StringUtil.checkNull(request.getParameter("reportType"), "1");
		String languageID = StringUtil.checkNull(request.getParameter("languageID"), "1042");
		String nextFromId = StringUtil.checkNull(request.getParameter("NextFromId"), "0");
		String levelName = StringUtil.checkNull(request.getParameter("LevelName"), "");
		String filepath = request.getSession().getServletContext().getRealPath("/");
		Map diplayListMap = new HashMap();

		try {

			diplayListMap = setItemStatisticsData(filepath, nextFromId, levelName, languageID);

			model.put("reportType", reportType);
			model.put("menu", getLabel(request, commonService));

			model.put("selectedValue", nextFromId);
			model.put("L1NameList", diplayListMap.get("L1NameList"));
			model.put("ChartList", diplayListMap.get("ChartList"));
			model.put("displayChartList", diplayListMap.get("displayChartList"));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/itemStatistics");
	}

	@RequestMapping(value = "/statisticsChart.do")
	public void statisticsChart(HashMap commandMap, HttpServletResponse response) throws ExceptionUtil {
		String data = commandMap.get("chartValue").toString().replace("<ampersand>", "&");
		JsonUtil.sendToJson(data, response);
	}

	@RequestMapping(value = "/dimensionStatistics.do")
	public String dimensionStatistics(HttpServletRequest request, ModelMap model) throws ExceptionUtil {
		String reportType = StringUtil.checkNull(request.getParameter("reportType"), "1");
		String languageID = request.getParameter("languageID");
		String filepath = request.getSession().getServletContext().getRealPath("/");
		HashMap commandMap = new HashMap();
		Map diplayListMap = new HashMap();

		try {

			// 프로세스 명 취득
			List itemNameList = new ArrayList();
			commandMap.put("FromItemID", "1");
			commandMap.put("LanguageID", languageID);
			commandMap.put("AttrTypeCode", "AT00001");
			itemNameList = (List) commonService.selectList("analysis_SQL.getLevelNames", commandMap);

			// Dimension Type/Name/Id 취득(grid header표시용)
			List dimTypeList = new ArrayList();
			commandMap.put("LanguageID", languageID);
			dimTypeList = (List) commonService.selectList("analysis_SQL.getDimensionListHeader", commandMap);

			diplayListMap = setDimensionStatisticsData(filepath, itemNameList, dimTypeList);

			model.put("dimTypeList", dimTypeList);
			// model.put("L1NameList", diplayListMap.get("L1NameList"));
			model.put("ChartList", diplayListMap.get("ChartList"));
			model.put("displayChartList", diplayListMap.get("displayChartList"));

			model.put("reportType", reportType);
			model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/dimensionStatistics");
	}

	/**
	 * [관리자-->통계-->Change-->Change Set]
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/changeSetStatistics.do")
	public String changeSetStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		Map setMap = new HashMap();
		List projectList = new ArrayList();
		try {

			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));

			/* 등록일 설정 FromDate:시스템 날짜에서 최근 일년, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.MONTH, -12);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			String scStartDt = StringUtil.checkNull(request.getParameter("SC_STR_DT"), beforeYmd);
			String scEndDt = StringUtil.checkNull(request.getParameter("SC_END_DT"), thisYmd);

			// get CSR List (첫번째 열 표시)
			commandMap.put("filter", "CSR");
			commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			commandMap.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("OwnerTeamID")));
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List csrList = commonService.selectList("analysis_SQL.getCsrList", commandMap);
			
			String cngTypeHeaderConfig = "";
			String cngStatusHeaderConfig = "";	
			String cngHeaderConfig = "";
			
			// get ChangeType List (grid header표시용)
			Map menuMap = getLabel(request, commonService);
			commandMap.put("Category", "CNGT1");
			Map changeTypeMap = new HashMap();
			List changeTypeList = commonService.selectList("analysis_SQL.getCngCodeList", commandMap);
			for (int i = 0; i < changeTypeList.size(); i++) {
				Map cngtMap = (Map) changeTypeList.get(i);
				changeTypeMap.put(cngtMap.get("TypeCode"), cngtMap.get("Name"));
				String changeType = StringUtil.checkNull(cngtMap.get("TypeCode"));
				if(i == 0) {
					cngTypeHeaderConfig += ",{ width: 100, id: 'cngt_cnt_"+changeType+"', header: [{ text: '"+menuMap.get("LN00022")+"', align:'center', colspan:"+changeTypeList.size()*2+"}, { text: '"+cngtMap.get("Name")+"', align:'center', colspan:2} ], align:'center'}";
					cngTypeHeaderConfig += ",{ width: 100, id: 'cngt_per_"+changeType+"', header: ['', { text: '', align:'center'}], align:'center'}";
				}else {
					cngTypeHeaderConfig += ",{ width: 100, id: 'cngt_cnt_"+changeType+"', header: ['', { text: '"+cngtMap.get("Name")+"', align:'center', colspan:2}], align:'center'}";
					cngTypeHeaderConfig += ",{ width: 100, id: 'cngt_per_"+changeType+"', header: ['', { text: '', align:'center'}], align:'center'}";
				}
			}

			commandMap.put("Category", "CNGSTS");
			Map cngStsMap = new HashMap();
			List cngStsList = commonService.selectList("analysis_SQL.getCngCodeList", commandMap);
			for (int i = 0; i < cngStsList.size(); i++) {
				Map cngMap = (Map) cngStsList.get(i);
				String changeStatus = StringUtil.checkNull(cngMap.get("TypeCode"));	
				if (changeStatus.equals("MOD") || changeStatus.equals("CMP") || changeStatus.equals("CLS")) {
					cngStsMap.put(cngMap.get("TypeCode"), cngMap.get("Name"));
					
					if(cngStatusHeaderConfig.equals("")) {
						cngStatusHeaderConfig += ",{ width: 100, id: 'cngSts_cnt_"+changeStatus+"', header: [{ text: '"+menuMap.get("LN00065")+"', align:'center', colspan:"+cngStsList.size()*2+"}, { text: '"+cngMap.get("Name")+"', align:'center', colspan:2} ], align:'center'}";
						cngStatusHeaderConfig += ",{ width: 100, id: 'cngSts_per_"+changeStatus+"', header: ['', { text: '', align:'center'}], align:'center'}";
					}else {
						cngStatusHeaderConfig += ",{ width: 100, id: 'cngSts_cnt_"+changeStatus+"', header: ['', { text: '"+cngMap.get("Name")+"', align:'center', colspan:2}], align:'center'}";
						cngStatusHeaderConfig += ",{ width: 100, id: 'cngSts_per_"+changeStatus+"', header: ['', { text: '', align:'center'}], align:'center'}";
					}
				}
			}
			cngHeaderConfig = cngTypeHeaderConfig + cngStatusHeaderConfig;
			model.put("cngHeaderConfig", cngHeaderConfig);

			List cngStatisticsList = new ArrayList();
			if (isMainMenu.isEmpty()) {
				cngStatisticsList = setChangeSetStatisticsData(csrList, changeTypeList, cngStsList, request,scStartDt, scEndDt);
			}
			JSONArray cngStatisticsListData = new JSONArray(cngStatisticsList);
			model.put("cngStatisticsListData", cngStatisticsListData);
			model.put("totalCnt", cngStatisticsList.size());

			/* 검색 조건 */
			// 프로젝트 리스트
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			if ("1".equals(sessionAuthLev)) {
				// Project List 전체
				setMap.put("ProjectType", "PJT");
				projectList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			} else {
				setMap.put("loginUserId", commandMap.get("sessionUserId"));
				projectList = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
			}

			// 계층
			setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
			List classCodeList = commonService.selectList("cs_SQL.getClassCodeList", setMap);

			model.put("cngtMap", changeTypeMap);
			model.put("cngStsMap", cngStsMap);
			model.put("beforeYmd", scStartDt);
			model.put("thisYmd", scEndDt);
			model.put("projectList", projectList);
			model.put("classCodeList", classCodeList);
			model.put("menu", getLabel(request, commonService));

			model.put("isMainMenu", isMainMenu);
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("OwnerTeamID")));
			model.put("ItemClassCode", StringUtil.checkNull(request.getParameter("ItemClassCode")));
			model.put("period", StringUtil.checkNull(request.getParameter("period")));
			model.put("SC_STR_DT", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
			model.put("SC_END_DT", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/changeSetStatistics");
	}

	private List setChangeSetStatisticsData(List csrList, List changeTypeList, List cngStsList, HttpServletRequest request, String scStartDt, String scEndDt) throws ExceptionUtil {

		HashMap commandMap = new HashMap();
		List countList = new ArrayList();
		
		List cngStatisticsList = new ArrayList();
		try {
			/* 화면에서 선택된 검색 조건을 설정 */
			commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			commandMap.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("OwnerTeamID")));
			commandMap.put("ItemClassCode", StringUtil.checkNull(request.getParameter("ItemClassCode")));
			commandMap.put("period", StringUtil.checkNull(request.getParameter("period")));
			commandMap.put("SC_STR_DT", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
			commandMap.put("SC_END_DT", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));

			// [기간기준] 선택에 따라 검색 조건이 달라짐
			// commandMap.put("scStartDt", scStartDt);
			// commandMap.put("scEndDt", scEndDt);

			/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
			List<Map<String, String>> countResultList = new ArrayList<Map<String, String>>();
			Map<String, Integer> countMap = new HashMap<String, Integer>();
			String cngtCntTtl = "";
			String cngtCnt = "";
			String cngStsCnt = "";
			
			Map cngStatisticsMap = new HashMap();
			// 변경오더 리스트 기준
			for (int i = 0; i < csrList.size(); i++) {
				Map<String, String> rowMap = new HashMap<String, String>();

				Map csrMap = (Map) csrList.get(i);
				String csrId = String.valueOf(csrMap.get("ProjectID"));
				String csrName = String.valueOf(csrMap.get("ProjectName"));

				commandMap.remove("ChangeType");
				commandMap.remove("Status");

				commandMap.put("projectID", csrId);
				
				cngStatisticsMap.put("csrId", csrId);
				cngStatisticsMap.put("csrName", csrName);// col1:변경오더 명
				cngtCntTtl = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
				cngStatisticsMap.put("cngtCount", cngtCntTtl); // col2:변경항목 Total Count

				// 변경구분 : NEW, MOD, DEL
				for (int j = 0; j < changeTypeList.size(); j++) {
					Map cngTMap = (Map) changeTypeList.get(j);
					String changeType = String.valueOf(cngTMap.get("TypeCode"));

					commandMap.put("ChangeType", changeType);
					cngtCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);

					cngStatisticsMap.put("cngt_cnt_"+changeType, cngtCnt); // col3, col5, col,7
					cngStatisticsMap.put("cngt_per_"+changeType, getRatio(new BigDecimal(cngtCntTtl), new BigDecimal(cngtCnt))); // col4, col6, col,8
				}
				commandMap.remove("ChangeType");

				// 진행상태
				for (int j = 0; j < cngStsList.size(); j++) {
					Map cngStsMap = (Map) cngStsList.get(j);
					String status = String.valueOf(cngStsMap.get("TypeCode"));
					if (status.equals("MOD") || status.equals("CMP") || status.equals("CLS")) {

						commandMap.put("Status", status);
						cngStsCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);

						cngStatisticsMap.put("cngSts_cnt_" + status, cngStsCnt); // col9, col11
						cngStatisticsMap.put("cngSts_per_" + status, getRatio(new BigDecimal(cngtCntTtl), new BigDecimal(cngStsCnt))); // col10, col12
					}
				}

				cngStatisticsList.add(cngStatisticsMap);
				cngStatisticsMap = new HashMap();
			}
		
			// TOTAL 행에 표시될 값 설절
			Map setMap = new HashMap();
			String ttl = "";
			String cngtTtl = "";
			String cngStsTtl = "";

			/* 화면에서 선택된 검색 조건을 설정 */
			setMap.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			setMap.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("OwnerTeamID")));
			setMap.put("ItemClassCode", StringUtil.checkNull(request.getParameter("ItemClassCode")));
			setMap.put("period", StringUtil.checkNull(request.getParameter("period")));
			setMap.put("SC_STR_DT", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
			setMap.put("SC_END_DT", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));
			
			cngStatisticsMap.put("csrName", "Total");
			ttl = commonService.selectString("analysis_SQL.getProjectItemCount", setMap);
			cngStatisticsMap.put("cngtCount", ttl);

			for (int j = 0; j < changeTypeList.size(); j++) {
				Map cngTMap = (Map) changeTypeList.get(j);
				String changeType = String.valueOf(cngTMap.get("TypeCode"));

				setMap.put("ChangeType", changeType);
				cngtTtl = commonService.selectString("analysis_SQL.getProjectItemCount", setMap);
								
				cngStatisticsMap.put("cngt_cnt_"+changeType, cngtTtl); 
				cngStatisticsMap.put("cngt_per_"+changeType, getRatio(new BigDecimal(ttl), new BigDecimal(cngtTtl))); 
			}
			setMap.remove("ChangeType");
			for (int j = 0; j < cngStsList.size(); j++) {
				Map cngStsMap = (Map) cngStsList.get(j);
				String status = String.valueOf(cngStsMap.get("TypeCode"));
				if (status.equals("MOD") || status.equals("CMP") || status.equals("CLS")) {
					setMap.put("Status", status);
					cngStsTtl = commonService.selectString("analysis_SQL.getProjectItemCount", setMap);
					
					cngStatisticsMap.put("cngSts_cnt_" + status, cngStsTtl); // col9, col11
					cngStatisticsMap.put("cngSts_per_" + status, getRatio(new BigDecimal(ttl), new BigDecimal(cngStsTtl))); // col10, col12
				}
			}
			cngStatisticsList.add(cngStatisticsMap);
			
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		//System.out.println("cngStatisticsList =>"+cngStatisticsList);
		return cngStatisticsList;
	}

	/**
	 * 선택된 [프로젝트]의 Change set의 해당 담당조직 List를 취득
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/getAuthorTeamListOption.do")
	public String getAuthorTeamListOption(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		try {
			commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("parentPjtID")));

			model.put(AJAX_RESULTMAP, commonService.selectList("analysis_SQL.getOwnerTeamList", commandMap));
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(AJAXPAGE_SELECTOPTION);
	}

	/**
	 * 선택된 [프로젝트]의 Project task classcode 취득
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/getClassCodeOfTaskOption.do")
	public String getClassCodeOfTaskOption(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		try {
			commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("parentPjtID")));

			model.put(AJAX_RESULTMAP, commonService.selectList("analysis_SQL.getClassCodeOfTask", commandMap));
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE_SELECTOPTION);
	}

	/**
	 * 선택된 [프로젝트]의 Project task ItemTypeCode 취득
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/getItemTypeCodeOfTaskOption.do")
	public String getItemTypeCodeOfTaskOption(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		try {
			commandMap.put("ProjectGr", StringUtil.checkNull(request.getParameter("ProjectGr")));
			commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("parentPjtID")));

			model.put(AJAX_RESULTMAP, commonService.selectList("analysis_SQL.getItemTypeCodeOfTask", commandMap));
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE_SELECTOPTION);
	}

	/**
	 * 선택된 [프로젝트]의 Project List 취득
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/getProjectOption.do")
	public String getProjectOption(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		try {
			commandMap.put("ProjectType", "PJT");
			// commandMap.put("ParentID",
			// StringUtil.checkNull(request.getParameter("parentPjtID")));
			commandMap.put("RefPGID", StringUtil.checkNull(request.getParameter("parentPjtID")));

			model.put(AJAX_RESULTMAP, commonService.selectList("project_SQL.getParentPjtList", commandMap));
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE_SELECTOPTION);
	}

	/**
	 * [관리자-->통계-->Change-->Task]
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/taskStatistics_NEW.do")
	public String taskStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		Map setMap = new HashMap();
		List projectList = new ArrayList();
		try {

			String filepath = request.getSession().getServletContext().getRealPath("/");
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));

			/* xml 파일명 설정 */
			String xmlFilName = "upload/task.xml";
			/* xml 파일 존재 할 경우 삭제 */
			File oldFile = new File(filepath + xmlFilName);
			if (oldFile.exists()) {
				oldFile.delete();
			}

			/* 등록일 설정 FromDate:시스템 날짜에서 최근 일년, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.MONTH, -12);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			String scStartDt = StringUtil.checkNull(request.getParameter("SC_STR_DT"), beforeYmd);
			String scEndDt = StringUtil.checkNull(request.getParameter("SC_END_DT"), thisYmd);

			// get csr List (첫번째 열 표시)
			commandMap.put("filter", "CSR");
			commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.remove("OwnerTeamID");
			List csrList = commonService.selectList("analysis_SQL.getCsrList", commandMap);

			// get 고정 Task List (두번째 행 표시 : 고정(RDY, PLAN1, PLAN2, CLS))
			commandMap.put("Category", "TSKTP");
			Map taskPlanMap = new HashMap();
			List taskPlanList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
			for (int i = 0; i < taskPlanList.size(); i++) {
				Map map = (Map) taskPlanList.get(i);
				taskPlanMap.put(map.get("CODE"), map.get("NAME"));
			}

			// get 변동 Task List (두번째 행 표시 : 변동)
			commandMap.put("ItemClassCode", StringUtil.checkNull(request.getParameter("ItemClassCode")));
			// Map taskAcMap = new HashMap();
			String taskActualHeader = "";
			List taskAcList = commonService.selectList("analysis_SQL.getPjtTaskTpList", commandMap);
			/*
			{ width: 180, id: 'rdy',  header: [{ text: "PLAN", colspan: 3 , align : 'center'},{ text: '준비', align:'center'}] },
	        { width: 180, id: 'rdy2', header: ['', { text: '계획수립', align:'center'} ], align:'center'},
	        { width: 180, id: 'rdy3', header: ['', { text: '계획확정', align:'center'} ], align:'center'},
	        
	        { width: 180, id: 'act1', align : 'center', header: [{ text: "ACTUAL", colspan: 5, align : 'center'},{ text: '기능설계', align:'center'}] },
	        { width: 180, id: 'act2', header: ['', { text: '기술설계', align:'center'} ], align:'center'},
	        { width: 180, id: 'act3', header: ['', { text: '코딩', align:'center'} ], align:'center'},
	        { width: 180, id: 'act4', header: ['', { text: '테스트', align:'center'} ], align:'center'},
	        { width: 180, id: 'act5', header: ['', { text: '완료', align:'center'} ], align:'center'},
	        */
	        
			for (int i = 0; i < taskAcList.size(); i++) {
				Map map = (Map) taskAcList.get(i);
				String name = StringUtil.checkNull(map.get("NAME"));
				String cspan = ",#cspan";
				if (taskActualHeader.isEmpty()) {
					taskActualHeader = name + cspan;
				} else {
					taskActualHeader = taskActualHeader + "," + name + cspan;
				}
			}

			// grid에 표시 할 xml file 생성
			if (isMainMenu.isEmpty()) {
				setTaskStatisticsData(filepath, csrList, taskPlanList, taskAcList, xmlFilName, request, scStartDt,
						scEndDt, String.valueOf(commandMap.get("sessionCurrLangType")));
			}

			/* 검색 조건 */
			// 프로젝트 리스트
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			if ("1".equals(sessionAuthLev)) {
				// Project List 전체
				setMap.put("ProjectType", "PJT");
				projectList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			} else {
				setMap.put("loginUserId", commandMap.get("sessionUserId"));
				projectList = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
			}

			model.put("xmlFilName", xmlFilName);
			model.put("taskPlanMap", taskPlanMap);
			model.put("taskActualHeader", taskActualHeader);
			model.put("aCnt", (taskAcList.size() * 2) + 9);
			model.put("taskActSize", taskAcList.size() * 2);

			model.put("beforeYmd", scStartDt);
			model.put("thisYmd", scEndDt);
			model.put("projectList", projectList);
			model.put("menu", getLabel(request, commonService));

			model.put("isMainMenu", isMainMenu);
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("OwnerTeamID")));
			model.put("ItemClassCode", StringUtil.checkNull(request.getParameter("ItemClassCode")));
			model.put("SC_STR_DT", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
			model.put("SC_END_DT", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/taskStatistics");
	}
	
	private void setTaskStatisticsData_NEW(String filepath, List csrList, List taskPlanList, List taskAcList,
			String xmlFilName, HttpServletRequest request, String scStartDt, String scEndDt, String languageID)
			throws ExceptionUtil {

		HashMap commandMap = new HashMap();

		/* 화면에서 선택된 검색 조건을 설정 */
		commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
		commandMap.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("OwnerTeamID")));
		commandMap.put("ItemClassCode", StringUtil.checkNull(request.getParameter("ItemClassCode")));
		commandMap.put("period", "1"); // 등록일
		commandMap.put("SC_STR_DT", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
		commandMap.put("SC_END_DT", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));

		/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
		String tskCnt = "";
		String tskCntRowTtl = "";
		String tskClsCnt = "";
		String tskClsPer = "";

		// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
		// 통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);
			int rowId = 1;

			Element row = doc.createElement("row");
			Element cell = doc.createElement("cell");

			commandMap.put("sessionCurrLangType", languageID);

			// 변경오더 리스트 기준
			for (int i = 0; i < csrList.size(); i++) {
				commandMap.remove("CurTask");

				Map csrMap = (Map) csrList.get(i);
				String csrId = String.valueOf(csrMap.get("ProjectID"));
				String csrName = String.valueOf(csrMap.get("ProjectName"));
				commandMap.put("projectID", csrId);

				row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(csrName)); // col1
				cell.setAttribute("style", "text-align:left;");
				row.appendChild(cell);

				cell = doc.createElement("cell"); // col2
				tskCntRowTtl = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
				cell.appendChild(doc.createTextNode(tskCntRowTtl));
				row.appendChild(cell);

				// Task Type(PLAN)
				for (int j = 0; j < taskPlanList.size(); j++) {
					Map taskPlanMap = (Map) taskPlanList.get(j);
					String type = String.valueOf(taskPlanMap.get("CODE"));
					String typeName = String.valueOf(taskPlanMap.get("NAME"));

					// RDY
					if ("RDY".equals(type)) {
						commandMap.put("CurTask", type);
						tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
						cell = doc.createElement("cell"); // col3
						cell.appendChild(doc.createTextNode(tskCnt));
						row.appendChild(cell);
						cell = doc.createElement("cell"); // col4
						cell.appendChild(
								doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
						row.appendChild(cell);
					}
					// PLAN1
					if ("PLAN1".equals(type)) {
						commandMap.put("CurTask", type);
						tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
						cell = doc.createElement("cell"); // col5
						cell.appendChild(doc.createTextNode(tskCnt));
						row.appendChild(cell);
						cell = doc.createElement("cell"); // col6
						cell.appendChild(
								doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
						row.appendChild(cell);
					}
					// PLAN2
					if ("PLAN2".equals(type)) {
						commandMap.put("CurTask", type);
						tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
						cell = doc.createElement("cell"); // col7
						cell.appendChild(doc.createTextNode(tskCnt));
						row.appendChild(cell);
						cell = doc.createElement("cell"); // col8
						cell.appendChild(
								doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
						row.appendChild(cell);
					}
					// CLS
					if ("CLS".equals(type)) {
						commandMap.put("CurTask", type);
						tskClsCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
						tskClsPer = getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskClsCnt));
					}

				}

				// Task Type(Actual)
				for (int j = 0; j < taskAcList.size(); j++) {
					Map taskAcMap = (Map) taskAcList.get(j);
					String type = String.valueOf(taskAcMap.get("CODE"));
					String typeName = String.valueOf(taskAcMap.get("NAME"));

					commandMap.put("CurTask", type);
					tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(tskCnt));
					row.appendChild(cell);
					cell = doc.createElement("cell");
					cell.appendChild(
							doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
					row.appendChild(cell);
				}

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(tskClsCnt));
				row.appendChild(cell);
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(tskClsPer));
				row.appendChild(cell);
			}

			// TOTAL 행에 표시될 값
			commandMap.remove("projectID");
			commandMap.remove("CurTask");

			row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));
			rowId++;
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("Total")); // col1
			cell.setAttribute("style", "text-align:left;font-weight:bold;");
			row.appendChild(cell);

			cell = doc.createElement("cell"); // col2
			cell.setAttribute("style", "background-color:#f2f2f2;");
			tskCntRowTtl = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
			cell.appendChild(doc.createTextNode(tskCntRowTtl));
			row.appendChild(cell);

			// Task Type(PLAN)
			for (int j = 0; j < taskPlanList.size(); j++) {
				Map taskPlanMap = (Map) taskPlanList.get(j);
				String type = String.valueOf(taskPlanMap.get("CODE"));
				String typeName = String.valueOf(taskPlanMap.get("NAME"));

				// RDY
				if ("RDY".equals(type)) {
					commandMap.put("CurTask", type);
					tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					cell = doc.createElement("cell"); // col3
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(doc.createTextNode(tskCnt));
					row.appendChild(cell);
					cell = doc.createElement("cell"); // col4
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(
							doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
					row.appendChild(cell);
				}
				// PLAN1
				if ("PLAN1".equals(type)) {
					commandMap.put("CurTask", type);
					tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					cell = doc.createElement("cell"); // col5
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(doc.createTextNode(tskCnt));
					row.appendChild(cell);
					cell = doc.createElement("cell"); // col6
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(
							doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
					row.appendChild(cell);
				}
				// PLAN2
				if ("PLAN2".equals(type)) {
					commandMap.put("CurTask", type);
					tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					cell = doc.createElement("cell"); // col7
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(doc.createTextNode(tskCnt));
					row.appendChild(cell);
					cell = doc.createElement("cell"); // col8
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(
							doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
					row.appendChild(cell);
				}
				// CLS
				if ("CLS".equals(type)) {
					commandMap.put("CurTask", type);
					tskClsCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					tskClsPer = getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskClsCnt));
				}

			}

			// Task Type(Actual)
			for (int j = 0; j < taskAcList.size(); j++) {
				Map taskAcMap = (Map) taskAcList.get(j);
				String type = String.valueOf(taskAcMap.get("CODE"));
				String typeName = String.valueOf(taskAcMap.get("NAME"));

				commandMap.put("CurTask", type);
				tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
				cell = doc.createElement("cell");
				cell.setAttribute("style", "background-color:#f2f2f2;");
				cell.appendChild(doc.createTextNode(tskCnt));
				row.appendChild(cell);
				cell = doc.createElement("cell");
				cell.setAttribute("style", "background-color:#f2f2f2;");
				cell.appendChild(doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
				row.appendChild(cell);
			}

			cell = doc.createElement("cell");
			cell.setAttribute("style", "background-color:#f2f2f2;");
			cell.appendChild(doc.createTextNode(tskClsCnt));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.setAttribute("style", "background-color:#f2f2f2;");
			cell.appendChild(doc.createTextNode(tskClsPer));
			row.appendChild(cell);

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);

			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

	}
	
	@RequestMapping(value = "/taskStatistics.do")
	public String taskStatistics_ORG(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		Map setMap = new HashMap();
		List projectList = new ArrayList();
		try {

			String filepath = request.getSession().getServletContext().getRealPath("/");
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));

			/* xml 파일명 설정 */
			String xmlFilName = "upload/task.xml";
			/* xml 파일 존재 할 경우 삭제 */
			File oldFile = new File(filepath + xmlFilName);
			if (oldFile.exists()) {
				oldFile.delete();
			}

			/* 등록일 설정 FromDate:시스템 날짜에서 최근 일년, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.MONTH, -12);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			String scStartDt = StringUtil.checkNull(request.getParameter("SC_STR_DT"), beforeYmd);
			String scEndDt = StringUtil.checkNull(request.getParameter("SC_END_DT"), thisYmd);

			// get csr List (첫번째 열 표시)
			commandMap.put("filter", "CSR");
			commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.remove("OwnerTeamID");
			List csrList = commonService.selectList("analysis_SQL.getCsrList", commandMap);

			// get 고정 Task List (두번째 행 표시 : 고정(RDY, PLAN1, PLAN2, CLS))
			commandMap.put("Category", "TSKTP");
			Map taskPlanMap = new HashMap();
			List taskPlanList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
			for (int i = 0; i < taskPlanList.size(); i++) {
				Map map = (Map) taskPlanList.get(i);
				taskPlanMap.put(map.get("CODE"), map.get("NAME"));
			}

			// get 변동 Task List (두번째 행 표시 : 변동)
			commandMap.put("ItemClassCode", StringUtil.checkNull(request.getParameter("ItemClassCode")));
			// Map taskAcMap = new HashMap();
			String taskActualHeader = "";
			List taskAcList = commonService.selectList("analysis_SQL.getPjtTaskTpList", commandMap);
			for (int i = 0; i < taskAcList.size(); i++) {
				Map map = (Map) taskAcList.get(i);
				String name = StringUtil.checkNull(map.get("NAME"));
				String cspan = ",#cspan";
				if (taskActualHeader.isEmpty()) {
					taskActualHeader = name + cspan;
				} else {
					taskActualHeader = taskActualHeader + "," + name + cspan;
				}
			}

			// grid에 표시 할 xml file 생성
			if (isMainMenu.isEmpty()) {
				setTaskStatisticsData(filepath, csrList, taskPlanList, taskAcList, xmlFilName, request, scStartDt,
						scEndDt, String.valueOf(commandMap.get("sessionCurrLangType")));
			}

			/* 검색 조건 */
			// 프로젝트 리스트
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			if ("1".equals(sessionAuthLev)) {
				// Project List 전체
				setMap.put("ProjectType", "PJT");
				projectList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			} else {
				setMap.put("loginUserId", commandMap.get("sessionUserId"));
				projectList = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
			}

			model.put("xmlFilName", xmlFilName);
			model.put("taskPlanMap", taskPlanMap);
			model.put("taskActualHeader", taskActualHeader);
			model.put("aCnt", (taskAcList.size() * 2) + 9);
			model.put("taskActSize", taskAcList.size() * 2);

			model.put("beforeYmd", scStartDt);
			model.put("thisYmd", scEndDt);
			model.put("projectList", projectList);
			model.put("menu", getLabel(request, commonService));

			model.put("isMainMenu", isMainMenu);
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("OwnerTeamID")));
			model.put("ItemClassCode", StringUtil.checkNull(request.getParameter("ItemClassCode")));
			model.put("SC_STR_DT", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
			model.put("SC_END_DT", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/taskStatistics");
	}

	private void setTaskStatisticsData(String filepath, List csrList, List taskPlanList, List taskAcList,
			String xmlFilName, HttpServletRequest request, String scStartDt, String scEndDt, String languageID)
			throws ExceptionUtil {

		HashMap commandMap = new HashMap();

		/* 화면에서 선택된 검색 조건을 설정 */
		commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
		commandMap.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("OwnerTeamID")));
		commandMap.put("ItemClassCode", StringUtil.checkNull(request.getParameter("ItemClassCode")));
		commandMap.put("period", "1"); // 등록일
		commandMap.put("SC_STR_DT", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
		commandMap.put("SC_END_DT", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));

		/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
		String tskCnt = "";
		String tskCntRowTtl = "";
		String tskClsCnt = "";
		String tskClsPer = "";

		// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
		// 통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);
			int rowId = 1;

			Element row = doc.createElement("row");
			Element cell = doc.createElement("cell");

			commandMap.put("sessionCurrLangType", languageID);

			// 변경오더 리스트 기준
			for (int i = 0; i < csrList.size(); i++) {
				commandMap.remove("CurTask");

				Map csrMap = (Map) csrList.get(i);
				String csrId = String.valueOf(csrMap.get("ProjectID"));
				String csrName = String.valueOf(csrMap.get("ProjectName"));
				commandMap.put("projectID", csrId);

				row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(csrName)); // col1
				cell.setAttribute("style", "text-align:left;");
				row.appendChild(cell);

				cell = doc.createElement("cell"); // col2
				tskCntRowTtl = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
				cell.appendChild(doc.createTextNode(tskCntRowTtl));
				row.appendChild(cell);

				// Task Type(PLAN)
				for (int j = 0; j < taskPlanList.size(); j++) {
					Map taskPlanMap = (Map) taskPlanList.get(j);
					String type = String.valueOf(taskPlanMap.get("CODE"));
					String typeName = String.valueOf(taskPlanMap.get("NAME"));

					// RDY
					if ("RDY".equals(type)) {
						commandMap.put("CurTask", type);
						tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
						cell = doc.createElement("cell"); // col3
						cell.appendChild(doc.createTextNode(tskCnt));
						row.appendChild(cell);
						cell = doc.createElement("cell"); // col4
						cell.appendChild(
								doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
						row.appendChild(cell);
					}
					// PLAN1
					if ("PLAN1".equals(type)) {
						commandMap.put("CurTask", type);
						tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
						cell = doc.createElement("cell"); // col5
						cell.appendChild(doc.createTextNode(tskCnt));
						row.appendChild(cell);
						cell = doc.createElement("cell"); // col6
						cell.appendChild(
								doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
						row.appendChild(cell);
					}
					// PLAN2
					if ("PLAN2".equals(type)) {
						commandMap.put("CurTask", type);
						tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
						cell = doc.createElement("cell"); // col7
						cell.appendChild(doc.createTextNode(tskCnt));
						row.appendChild(cell);
						cell = doc.createElement("cell"); // col8
						cell.appendChild(
								doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
						row.appendChild(cell);
					}
					// CLS
					if ("CLS".equals(type)) {
						commandMap.put("CurTask", type);
						tskClsCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
						tskClsPer = getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskClsCnt));
					}

				}

				// Task Type(Actual)
				for (int j = 0; j < taskAcList.size(); j++) {
					Map taskAcMap = (Map) taskAcList.get(j);
					String type = String.valueOf(taskAcMap.get("CODE"));
					String typeName = String.valueOf(taskAcMap.get("NAME"));

					commandMap.put("CurTask", type);
					tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(tskCnt));
					row.appendChild(cell);
					cell = doc.createElement("cell");
					cell.appendChild(
							doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
					row.appendChild(cell);
				}

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(tskClsCnt));
				row.appendChild(cell);
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(tskClsPer));
				row.appendChild(cell);
			}

			// TOTAL 행에 표시될 값
			commandMap.remove("projectID");
			commandMap.remove("CurTask");

			row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));
			rowId++;
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("Total")); // col1
			cell.setAttribute("style", "text-align:left;font-weight:bold;");
			row.appendChild(cell);

			cell = doc.createElement("cell"); // col2
			cell.setAttribute("style", "background-color:#f2f2f2;");
			tskCntRowTtl = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
			cell.appendChild(doc.createTextNode(tskCntRowTtl));
			row.appendChild(cell);

			// Task Type(PLAN)
			for (int j = 0; j < taskPlanList.size(); j++) {
				Map taskPlanMap = (Map) taskPlanList.get(j);
				String type = String.valueOf(taskPlanMap.get("CODE"));
				String typeName = String.valueOf(taskPlanMap.get("NAME"));

				// RDY
				if ("RDY".equals(type)) {
					commandMap.put("CurTask", type);
					tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					cell = doc.createElement("cell"); // col3
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(doc.createTextNode(tskCnt));
					row.appendChild(cell);
					cell = doc.createElement("cell"); // col4
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(
							doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
					row.appendChild(cell);
				}
				// PLAN1
				if ("PLAN1".equals(type)) {
					commandMap.put("CurTask", type);
					tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					cell = doc.createElement("cell"); // col5
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(doc.createTextNode(tskCnt));
					row.appendChild(cell);
					cell = doc.createElement("cell"); // col6
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(
							doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
					row.appendChild(cell);
				}
				// PLAN2
				if ("PLAN2".equals(type)) {
					commandMap.put("CurTask", type);
					tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					cell = doc.createElement("cell"); // col7
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(doc.createTextNode(tskCnt));
					row.appendChild(cell);
					cell = doc.createElement("cell"); // col8
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(
							doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
					row.appendChild(cell);
				}
				// CLS
				if ("CLS".equals(type)) {
					commandMap.put("CurTask", type);
					tskClsCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					tskClsPer = getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskClsCnt));
				}

			}

			// Task Type(Actual)
			for (int j = 0; j < taskAcList.size(); j++) {
				Map taskAcMap = (Map) taskAcList.get(j);
				String type = String.valueOf(taskAcMap.get("CODE"));
				String typeName = String.valueOf(taskAcMap.get("NAME"));

				commandMap.put("CurTask", type);
				tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
				cell = doc.createElement("cell");
				cell.setAttribute("style", "background-color:#f2f2f2;");
				cell.appendChild(doc.createTextNode(tskCnt));
				row.appendChild(cell);
				cell = doc.createElement("cell");
				cell.setAttribute("style", "background-color:#f2f2f2;");
				cell.appendChild(doc.createTextNode(getRatio(new BigDecimal(tskCntRowTtl), new BigDecimal(tskCnt))));
				row.appendChild(cell);
			}

			cell = doc.createElement("cell");
			cell.setAttribute("style", "background-color:#f2f2f2;");
			cell.appendChild(doc.createTextNode(tskClsCnt));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.setAttribute("style", "background-color:#f2f2f2;");
			cell.appendChild(doc.createTextNode(tskClsPer));
			row.appendChild(cell);

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);

			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

	}

	@RequestMapping(value = "/taskPAresult.do")
	public String taskPAresult(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {

		try {
			Map setMap = new HashMap();
			List projectList = new ArrayList();
			List pjtGrList = new ArrayList();

			String filepath = request.getSession().getServletContext().getRealPath("/");
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));
			Map menuMap = getLabel(request, commonService);

			/* 등록일 설정 FromDate:시스템 날짜에서 최근 일년, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			String scStartDt = StringUtil.checkNull(request.getParameter("scStartDt"), thisYmd);

			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
			Date selectedDate = transFormat.parse(scStartDt);
			cal.setTime(selectedDate);
			cal.add(Calendar.DAY_OF_WEEK, -7);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			// get Task List
			commandMap.put("Category", "TSKTP");
			List taskPlanList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);

			// 첫번째 행 표시 : 구분 및 [프로젝트, 항목 유형]별 task 단계 표시
			// 두번째 행 표시 : 해당 주 표시
			// 세번째 행 표시 : 계획 및 실적 표시
			commandMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			commandMap.put("Mandatory", "1");
			List taskAcList = commonService.selectList("analysis_SQL.getPjtTaskTpList", commandMap);
			String planAtual = menuMap.get("LN00255") + "," + menuMap.get("LN00254"); // 누적 계획,누적실적
			String headerConfig = "";
			for (int i = 0; i < taskAcList.size(); i++) {
				Map taskInfoMap = (Map) taskAcList.get(i);
				String taskName = StringUtil.checkNull(taskInfoMap.get("NAME"));
				String taskTypeCode = StringUtil.checkNull(taskInfoMap.get("CODE"));
				
				// [개발] 인 경우 : 개발중 열 추가
				if ("TS003".equals(taskTypeCode)) {
					headerConfig = headerConfig + ",{ width: 65, id: '"+taskTypeCode+"_LP', align:'center', header: [{text: '" + taskName
							+ "', align: 'center', colspan: 8}"
							+ ",{ text: '"+menuMap.get("LN00251")+"' ,align:'center', colspan: 2} ,{ text: '"+menuMap.get("LN00255")+"' ,align:'center'}]}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_LA', header: ['','', { text: '"+menuMap.get("LN00254")+"', align:'center'} ], align:'center'}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_TP', header: ['', { text: '"+menuMap.get("LN00263")+"', align:'center', colspan: 2}"
							+ ",{ text: '"+menuMap.get("LN00255")+"',align:'center'} ], align:'center'}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_TA', header: ['','', { text: '"+menuMap.get("LN00254")+"', align:'center'} ], align:'center'}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_T2P', header: ['', { text: '"+menuMap.get("LN00252")+"', align:'center', colspan: 4}, { text: '"+menuMap.get("LN00255")+"', align:'center'} ], align:'center'}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_T2A', header: ['','', { text: '"+menuMap.get("LN00254")+"', align:'center'} ], align:'center'}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_T2DEV', header: ['','', { text: '"+menuMap.get("LN00257")+"', align:'center'} ], align:'center'}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_T2PER', header: ['','', { text: '"+menuMap.get("LN00256")+"', align:'center'} ], align:'center'}";
				} else {
					headerConfig = headerConfig + ",{ width: 65, id: '"+taskTypeCode+"_LP', align:'center', header: [{text: '" + taskName
							+ "', align: 'center', colspan: 7}"
							+ ",{ text: '"+menuMap.get("LN00251")+"' ,align:'center', colspan: 2} ,{ text: '"+menuMap.get("LN00255")+"' ,align:'center'}]}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_LA', header: ['','', { text: '"+menuMap.get("LN00254")+"', align:'center'} ], align:'center'}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_TP', header: ['', { text: '"+menuMap.get("LN00263")+"', align:'center', colspan: 2}"
							+ ",{ text: '"+menuMap.get("LN00255")+"',align:'center'} ], align:'center'}"
							
							+ ",{ width: 65, id: '"+taskTypeCode+"_TA', header: ['','', { text: '"+menuMap.get("LN00254")+"', align:'center'} ], align:'center'}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_T2P', header: ['', { text: '"+menuMap.get("LN00252")+"', align:'center', colspan: 3}, { text: '"+menuMap.get("LN00255")+"', align:'center'} ], align:'center'}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_T2A', header: ['','', { text: '"+menuMap.get("LN00254")+"', align:'center'} ], align:'center'}"
							+ ",{ width: 65, id: '"+taskTypeCode+"_T2PER', header: ['','', { text: '"+menuMap.get("LN00256")+"', align:'center'} ], align:'center'}";
				}
			}
			
		    model.put("headerConfig", headerConfig);
			Map taskPAResultMap = new HashMap();
			if (isMainMenu.isEmpty()) {
				taskPAResultMap = setTaskPAStatisticsData(filepath, taskPlanList, taskAcList, request, scStartDt, beforeYmd,String.valueOf(commandMap.get("sessionCurrLangType")), menuMap);
			}
			
			List taskPAResultList = (List)taskPAResultMap.get("taskPAResultList");
			List spanList = (List)taskPAResultMap.get("spanList");
			
			JSONArray taskPAResultListData = new JSONArray(taskPAResultList);
			model.put("taskPAResultListData", taskPAResultListData);
			model.put("totalCnt", taskPAResultList.size());
		
			JSONArray spanData = new JSONArray(spanList);
			model.put("spanData", spanData);

			/* 검색 조건 */
			// 프로젝트 그룹 리스트
			setMap.put("ProjectType", "PG");
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			pjtGrList = commonService.selectList("project_SQL.getParentPjtList", setMap);

			Map pjtGrMap = new HashMap();
			for (int i = 0; i < pjtGrList.size(); i++) {
				Map map = (Map) pjtGrList.get(i);
				pjtGrMap.put(String.valueOf(map.get("CODE")), String.valueOf(map.get("NAME")));
			}
			String key = StringUtil.checkNull(request.getParameter("ProjectGr"), "1");
			model.put("pjtGrHeader", pjtGrMap.get(key)); // 화면에서 선택된 [프로젝트 그룹명]을 셋팅

			setMap.put("ProjectType", "PJT");
			projectList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			

			model.put("taskActSize", taskAcList.size() * 2);
			model.put("thisYmd", scStartDt);
			model.put("pjtGrList", pjtGrList);
			model.put("projectList", projectList);
			model.put("menu", menuMap);
			model.put("isMainMenu", isMainMenu);
			model.put("ProjectGr", StringUtil.checkNull(request.getParameter("ProjectGr")));
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("OwnerTeamID")));
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			model.put("scStartDt", StringUtil.checkNull(request.getParameter("scStartDt"), scStartDt));


		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/taskPAresult");
	}

	private Map setTaskPAStatisticsData(String filepath, List taskPlanList, List taskAcList, HttpServletRequest request, String scStartDt, String beforeYmd, String languageID, Map menuMap)
			throws ExceptionUtil {

		HashMap commandMap = new HashMap();

		/* 화면에서 선택된 검색 조건을 설정 */
		commandMap.put("ProjectGr", StringUtil.checkNull(request.getParameter("ProjectGr"), "1"));
		commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
		commandMap.put("AuthorTeamID", StringUtil.checkNull(request.getParameter("OwnerTeamID")));
		commandMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"), "OJ00004"));
		commandMap.put("scStartDt", StringUtil.checkNull(request.getParameter("scStartDt"), scStartDt));
		commandMap.put("beforeYmd", beforeYmd);
		commandMap.put("sessionCurrLangType", languageID);
		commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
		commandMap.put("NotDel", "NotDel");

		/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
		String tskCnt = "0";
		String tskBPCnt = "0"; // 전주 P
		String tskBACnt = "0"; // 전주 A
		String tskTPCnt = "0"; // 금주P
		String tskTACnt = "0"; // 금주A
		String lineTtlCnt = "0";
		String lastTskACnt = "0"; // Count of Last task type Actual
		String lastTskPCnt = "0"; // Count of Last task type Plan
		String csrIds = "";

		try {
			// 화면에서 선택된 항목 유형에 해당하는 TB_PJT_TASK_TP의 프로젝트를 취득
			commandMap.remove("TaskTypeCode"); // TaskTypeCode 초기화
			commandMap.remove("ParentID"); // ParentID 초기화
			commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			List pjtList = commonService.selectList("analysis_SQL.getProjectOfTask", commandMap);
			String projectIDList = "";
			
			List taskPAResultList = new ArrayList();
			Map taskPAResultMap = new HashMap();
			int id = 1;
			List spanList = new ArrayList(); 
			for (int i = 0; i < pjtList.size(); i++) {
				Map projectInfoMap = (Map) pjtList.get(i);
				String projectID = StringUtil.checkNull(projectInfoMap.get("ProjectID"));
				String projectName = StringUtil.checkNull(projectInfoMap.get("ProjectName"));


				commandMap.put("filter", "CSR");
				commandMap.put("ParentID", projectID);
				List csrList = commonService.selectList("analysis_SQL.getCsrList", commandMap);
				csrIds = "";
				
				//{ row: "5", column: "ProjectNM", rowspan: 3 } , 
				
				Map spanMap = new HashMap(); 
				spanMap.put("row", id);
				spanMap.put("column", "ProjectNM"); 
				spanMap.put("rowspan", csrList.size()+1); 
				spanList.add(spanMap);
				
				for (int j = 0; j < csrList.size(); j++) {
					Map csrMap = (Map) csrList.get(j);
					taskPAResultMap = new HashMap();
					String csrCode = String.valueOf(csrMap.get("ProjectID"));
					String csrName = String.valueOf(csrMap.get("ProjectName"));
					
					taskPAResultMap.put("ProjectNM", projectName);
					taskPAResultMap.put("Csr", csrName);
					
					if (j == 0) {
						csrIds = csrCode;
					} else {
						csrIds = csrIds + "," + csrCode;
					}
					
					commandMap.put("ProjectID", csrCode); // ProjectID
					for (int g = 0; g < taskAcList.size(); g++) {
						Map taskAcMap = (Map) taskAcList.get(g);
						String type = String.valueOf(taskAcMap.get("CODE"));
						String typeName = String.valueOf(taskAcMap.get("NAME"));

						commandMap.put("isDev5", "N"); // 개발중X
						commandMap.put("TaskTypeCode", type); // TaskTypeCode
						
						/* 전주 */
						// P
						commandMap.put("period", "before"); // period
						commandMap.put("Category", "P"); // Category
						tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
						tskBPCnt = tskCnt;						
						taskPAResultMap.put(type+"_LP", tskCnt);
						
						// A
						commandMap.put("Category", "A"); // Category
						tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
						tskBACnt = tskCnt;
						taskPAResultMap.put(type+"_LA", tskCnt);
						
						/* 금주 계산 */
						// P
						commandMap.put("period", "this"); // period
						commandMap.put("Category", "P"); // Category
						tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
						tskTPCnt = tskCnt;
						// A
						commandMap.put("Category", "A"); // Category
						tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
						tskTACnt = tskCnt;

						/* 금주실적 */
						// P
						taskPAResultMap.put(type+"_TP", getMinusResult(tskTPCnt, tskBPCnt));						
						// A
						taskPAResultMap.put(type+"_TA", getMinusResult(tskTACnt, tskBACnt));
						

						/* 금주 누계*/
						// P
						taskPAResultMap.put(type+"_T2P", tskTPCnt);						
						// A
						taskPAResultMap.put(type+"_T2A", tskTACnt);
						
						if (g == taskAcList.size() - 1) { // 마지막 task Actual Count 값 설정
							lastTskACnt = tskTACnt;
						}

						if (g == taskAcList.size() - 1) { // 마지막 task Plan Count 값 설정
							lastTskPCnt = tskTPCnt;
						}
						
						if ("TS003".equals(type)) {
							// 개발중
							commandMap.put("Category", "A"); // Category
							commandMap.put("isDev5", "Y"); // 개발중
							tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
							taskPAResultMap.put(type+"_T2DEV", tskCnt);	
						
							commandMap.put("isDev5", "N"); // 개발중X
						}

						// 금주 실적율
						taskPAResultMap.put(type+"_T2PER", getRatio(new BigDecimal(tskTPCnt), new BigDecimal(tskTACnt)));
					}
					
					commandMap.put("projectID", csrCode); // 개발중
					tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
					
					taskPAResultMap.put("total", tskCnt);
					lineTtlCnt = tskCnt;
					
					// 완료율(Plan)
					taskPAResultMap.put("totalP", getRatio(new BigDecimal(lineTtlCnt), new BigDecimal(lastTskPCnt)));
					
					// 완료율(Actual)
					taskPAResultMap.put("totalA", getRatio(new BigDecimal(lineTtlCnt), new BigDecimal(lastTskACnt)));
					
					taskPAResultMap.put("id", id); id++;
					taskPAResultList.add(taskPAResultMap);

				}
				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////// 소계 /////////////////////////////////////////////////////////////////////////////////////////////////////
			
				taskPAResultMap = new HashMap();	
				commandMap.put("ProjectID", csrIds); // ProjectID
				taskPAResultMap.put("ProjectNM", projectName);
				taskPAResultMap.put("Csr", "소계");
				
				if(!csrIds.equals("")) {
				for (int g = 0; g < taskAcList.size(); g++) {
					Map taskAcMap = (Map) taskAcList.get(g);
					String type = String.valueOf(taskAcMap.get("CODE"));
					String typeName = String.valueOf(taskAcMap.get("NAME"));

					commandMap.put("isDev5", "N"); // 개발중X
					commandMap.put("TaskTypeCode", type); // TaskTypeCode
					
					// 전주 
					// P
					commandMap.put("period", "before"); // period
					commandMap.put("Category", "P"); // Category
					tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
					tskBPCnt = tskCnt;						
					taskPAResultMap.put(type+"_LP", tskCnt);
					
					// A
					commandMap.put("Category", "A"); // Category
					tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
					tskBACnt = tskCnt;
					taskPAResultMap.put(type+"_LA", tskCnt);
					
					// 금주 계산 
					// P
					commandMap.put("period", "this"); // period
					commandMap.put("Category", "P"); // Category
					tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
					tskTPCnt = tskCnt;
					// A
					commandMap.put("Category", "A"); // Category
					tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
					tskTACnt = tskCnt;

					// 금주실적 
					// P
					taskPAResultMap.put(type+"_TP", getMinusResult(tskTPCnt, tskBPCnt));						
					// A
					taskPAResultMap.put(type+"_TA", getMinusResult(tskTACnt, tskBACnt));
					

					// 금주누계
					// P
					taskPAResultMap.put(type+"_T2P", tskTPCnt);						
					// A
					taskPAResultMap.put(type+"_T2A", tskTACnt);
					
					if (g == taskAcList.size() - 1) { // 마지막 task Actual Count 값 설정
						lastTskACnt = tskTACnt;
					}

					if (g == taskAcList.size() - 1) { // 마지막 task Plan Count 값 설정
						lastTskPCnt = tskTPCnt;
					}
					
					if ("TS003".equals(type)) {
						// 개발중
						commandMap.put("Category", "A"); // Category
						commandMap.put("isDev5", "Y"); // 개발중
						tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
						taskPAResultMap.put(type+"_T2DEV", tskCnt);	
					
						commandMap.put("isDev5", "N"); // 개발중X
					}

					// 금주 실적율
					taskPAResultMap.put(type+"_T2PER", getRatio(new BigDecimal(tskTPCnt), new BigDecimal(tskTACnt)));
				}
				
				/* 개발 요약 */
				commandMap.put("projectID", csrIds); // 개발중
				tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
				
				taskPAResultMap.put("total", tskCnt);
				lineTtlCnt = tskCnt;
				// 완료율(계획)
				taskPAResultMap.put("totalP", getRatio(new BigDecimal(lineTtlCnt), new BigDecimal(lastTskPCnt)));
				// 완료율(실적)
				taskPAResultMap.put("totalA", getRatio(new BigDecimal(lineTtlCnt), new BigDecimal(lastTskACnt)));
				
				taskPAResultMap.put("id", id); id++;
				taskPAResultList.add(taskPAResultMap);
				}
				//System.out.println("taskPAResultList :"+taskPAResultList);
			}
			
			/** 총합계 : 화면에서 선택된 프로젝트 그룹의 모든 변경오더의 change set Counting을 한다 */
			commandMap.remove("ProjectID");
			commandMap.remove("projectID");
			commandMap.remove("ParentID");
			commandMap.remove("TaskTypeCode");
			commandMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"), "OJ00004"));

			String strCsrList = getCsrListOfTask(StringUtil.checkNull(request.getParameter("ParentID")),StringUtil.checkNull(request.getParameter("ProjectGr"), "1"));

			commandMap.put("ProjectID", strCsrList);
			commandMap.put("projectID", strCsrList);
			
			taskPAResultMap = new HashMap();	
			commandMap.put("ProjectID", csrIds); // ProjectID
			taskPAResultMap.put("ProjectNM", String.valueOf(menuMap.get("LN00260")));
			taskPAResultMap.put("Csr", "");

			for (int g = 0; g < taskAcList.size(); g++) {
				Map taskAcMap = (Map) taskAcList.get(g);
				String type = String.valueOf(taskAcMap.get("CODE"));
				String typeName = String.valueOf(taskAcMap.get("NAME"));

				commandMap.put("isDev5", "N"); // 개발중X
				commandMap.put("TaskTypeCode", type); // TaskTypeCode

				/* 전주 */
				// P
				commandMap.put("period", "before"); // period
				commandMap.put("Category", "P"); // Category
				tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
				tskBPCnt = tskCnt;
				taskPAResultMap.put(type+"_LP", tskCnt);
				
				// A
				commandMap.put("Category", "A"); // Category
				tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
				tskBACnt = tskCnt;
				taskPAResultMap.put(type+"_LA", tskCnt);

				/* 금주실적 */
				// P
				taskPAResultMap.put(type+"_TP", getMinusResult(tskTPCnt, tskBPCnt));						
				// A
				taskPAResultMap.put(type+"_TA", getMinusResult(tskTACnt, tskBACnt));
				
				// 금주누계
				// P
				taskPAResultMap.put(type+"_T2P", tskTPCnt);						
				// A
				taskPAResultMap.put(type+"_T2A", tskTACnt);
				
				if (g == taskAcList.size() - 1) { // 마지막 task Actual Count 값 설정
					lastTskACnt = tskTACnt;
				}

				if (g == taskAcList.size() - 1) { // 마지막 task Plan Count 값 설정
					lastTskPCnt = tskTPCnt;
				}
				
				if ("TS003".equals(type)) {
					// 개발중
					commandMap.put("Category", "A"); // Category
					commandMap.put("isDev5", "Y"); // 개발중
					tskCnt = commonService.selectString("analysis_SQL.getCountOfTask", commandMap);
					taskPAResultMap.put(type+"_T2DEV", tskCnt);	
				
					commandMap.put("isDev5", "N"); // 개발중X
				}

				// 금주 실적율
				taskPAResultMap.put(type+"_T2PER", getRatio(new BigDecimal(tskTPCnt), new BigDecimal(tskTACnt)));
			}
			
			/* Total 개발 요약 */
			tskCnt = commonService.selectString("analysis_SQL.getProjectItemCount", commandMap);
			taskPAResultMap.put("total", tskCnt);
			lineTtlCnt = tskCnt;
			
			// 완료율(Plan)
			BigDecimal BD1 = null;
			BigDecimal BD2 = null;

			if (lineTtlCnt != null && lineTtlCnt != "" && Integer.parseInt(lineTtlCnt) > 0)
				BD1 = new BigDecimal(lineTtlCnt);
			else
				BD1 = new BigDecimal(0);

			if (lastTskPCnt != null && lastTskPCnt != "" && Integer.parseInt(lastTskPCnt) > 0)
				BD2 = new BigDecimal(lastTskPCnt);
			else
				BD2 = new BigDecimal(0);
			
			taskPAResultMap.put("totalP", getRatio(BD1, BD2));

			if (lastTskACnt != null && lastTskACnt != "" && Integer.parseInt(lastTskACnt) > 0)
				BD2 = new BigDecimal(lastTskACnt);
			else
				BD2 = new BigDecimal(0);
			
			taskPAResultMap.put("totalA", getRatio(BD1, BD2));
			
			///////////////////////////////////////////////////////////////////////////////////////////////////
			
			taskPAResultMap.put("id", id); id++;
			taskPAResultList.add(taskPAResultMap);
			
			
			Map resultMap = new HashMap();
			resultMap.put("taskPAResultList", taskPAResultList);
			resultMap.put("spanList", spanList);
			
			return resultMap;
			
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

	}

	private String getCsrListOfTask(String parentId, String pjtGrId) throws ExceptionUtil {
		String strCsrList = "";
		Map setMap = new HashMap();
		try {
			setMap.put("ParentID", parentId);
			setMap.put("pjtGroupID", pjtGrId);
			List csrList = commonService.selectList("analysis_SQL.getCsrListOfTask", setMap);

			for (int h = 0; h < csrList.size(); h++) {
				Map map = (Map) csrList.get(h);
				String csrId = String.valueOf(map.get("ProjectID"));
				if (strCsrList.isEmpty()) {
					strCsrList = csrId;
				} else {
					strCsrList = strCsrList + "," + csrId;
				}
			}
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return strCsrList;
	}

	/**
	 * [관리자-->통계-->Change-->Issue]
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/issueStatistics.do")
	public String issueStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		Map setMap = new HashMap();
		List projectList = new ArrayList();
		try {

			String filepath = request.getSession().getServletContext().getRealPath("/");
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));

			/* xml 파일명 설정 */
			String xmlFilName = "upload/issue.xml";
			/* xml 파일 존재 할 경우 삭제 */
			File oldFile = new File(filepath + xmlFilName);
			if (oldFile.exists()) {
				oldFile.delete();
			}

			/* 등록일 설정 FromDate:시스템 날짜에서 최근 일년, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.MONTH, -12);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			String scStartDt = StringUtil.checkNull(request.getParameter("SC_STR_DT"), beforeYmd);
			String scEndDt = StringUtil.checkNull(request.getParameter("SC_END_DT"), thisYmd);

			// get CSR List (첫번째 열 표시)
			commandMap.put("filter", "CSR");
			commandMap.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List csrList = commonService.selectList("analysis_SQL.getCsrList", commandMap);

			// get Issue status
			commandMap.put("Category", "ISSTS");
			Map isStsMap = new HashMap();
			List isStsList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
			for (int i = 0; i < isStsList.size(); i++) {
				Map map = (Map) isStsList.get(i);
				isStsMap.put("IS" + map.get("CODE"), map.get("NAME"));
			}

			// grid에 표시 할 xml file 생성
			if (isMainMenu.isEmpty()) {
				setIssueStatisticsData(filepath, csrList, isStsList, xmlFilName, request, scStartDt, scEndDt,
						String.valueOf(commandMap.get("sessionCurrLangType")));
			}

			/* 검색 조건 */
			// 프로젝트 리스트
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			if ("1".equals(sessionAuthLev)) {
				// Project List 전체
				setMap.put("ProjectType", "PJT");
				projectList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			} else {
				setMap.put("loginUserId", commandMap.get("sessionUserId"));
				projectList = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
			}

			// 이슈 유형
			List issueTypeList = commonService.selectList("analysis_SQL.getIsseuItemType", commandMap);
			// 요청 조직
			List issueReqTeamList = commonService.selectList("analysis_SQL.getIssueReqTeamList", commandMap);

			model.put("xmlFilName", xmlFilName);
			model.put("isStsMap", isStsMap);
			model.put("beforeYmd", scStartDt);
			model.put("thisYmd", scEndDt);
			model.put("projectList", projectList);
			model.put("issueTypeList", issueTypeList);
			model.put("issueReqTeamList", issueReqTeamList);
			model.put("menu", getLabel(request, commonService));

			model.put("isMainMenu", isMainMenu);
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("ReqTeamID", StringUtil.checkNull(request.getParameter("ReqTeamID")));
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			model.put("period", StringUtil.checkNull(request.getParameter("period")));
			model.put("SC_STR_DT", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
			model.put("SC_END_DT", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/issueStatistics");
	}

	private void setIssueStatisticsData(String filepath, List csrList, List isStsList, String xmlFilName,
			HttpServletRequest request, String scStartDt, String scEndDt, String languageID) throws ExceptionUtil {

		HashMap commandMap = new HashMap();

		/* 화면에서 선택된 검색 조건을 설정 */
		// [기간기준] 선택에 따라 검색 조건이 달라짐
		commandMap.put("ProjectID", StringUtil.checkNull(request.getParameter("ParentID")));
		commandMap.put("ReqTeamID", StringUtil.checkNull(request.getParameter("ReqTeamID")));
		commandMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
		commandMap.put("period", StringUtil.checkNull(request.getParameter("period")));
		commandMap.put("SC_STR_DT", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
		commandMap.put("SC_END_DT", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));

		/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
		String isCnt = "";
		String isCntRowTtl = "";

		// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
		// 통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);
			int rowId = 1;

			Element row = doc.createElement("row");
			Element cell = doc.createElement("cell");
			commandMap.put("sessionCurrLangType", languageID);
			// 변경오더 리스트 기준
			for (int i = 0; i < csrList.size(); i++) {
				Map csrMap = (Map) csrList.get(i);
				String csrId = String.valueOf(csrMap.get("ProjectID"));
				String csrName = String.valueOf(csrMap.get("ProjectName"));

				commandMap.put("CSRID", csrId);
				commandMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
				List issueTypeList = commonService.selectList("analysis_SQL.getIsseuItemType", commandMap);

				commandMap.remove("ItemTypeCode");
				commandMap.remove("Status");

				// 변경오더 별 [유형]
				for (int j = 0; j < issueTypeList.size(); j++) {
					row = doc.createElement("row");
					rootElement.appendChild(row);
					row.setAttribute("id", String.valueOf(rowId));
					rowId++;
					if (j == 0) {
						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(csrName));
						cell.setAttribute("rowspan", String.valueOf(issueTypeList.size() + 1)); // 변경오더명
						cell.setAttribute("style", "text-align:left;");
						row.appendChild(cell);
					} else {
						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(""));
						row.appendChild(cell);
					}

					Map isTypeMap = (Map) issueTypeList.get(j);
					String issueType = String.valueOf(isTypeMap.get("CODE"));
					String typeName = String.valueOf(isTypeMap.get("NAME"));

					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(typeName)); // col2:유형 명
					row.appendChild(cell);

					commandMap.put("ItemTypeCode", issueType);
					isCntRowTtl = commonService.selectString("issue_SQL.getIssueCount", commandMap);

					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(isCntRowTtl)); // col2:유형 명
					row.appendChild(cell);

					for (int k = 0; k < isStsList.size(); k++) {
						Map isStsMap = (Map) isStsList.get(k);
						String issueSts = String.valueOf(isStsMap.get("CODE"));
						commandMap.put("Status", issueSts);
						isCnt = commonService.selectString("issue_SQL.getIssueCount", commandMap);

						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(isCnt)); // col2:유형 명
						row.appendChild(cell);
						cell = doc.createElement("cell");
						cell.appendChild(
								doc.createTextNode(getRatio(new BigDecimal(isCntRowTtl), new BigDecimal(isCnt)))); // col2:유형
																													// 명
						row.appendChild(cell);

					}

				}

				commandMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
				commandMap.remove("Status");

				if (issueTypeList.size() == 0) {
					row = doc.createElement("row");
					rootElement.appendChild(row);
					row.setAttribute("id", String.valueOf(rowId));
					rowId++;
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(csrName));
					cell.setAttribute("style", "text-align:left;");
					row.appendChild(cell);
				} else {
					row = doc.createElement("row");
					rootElement.appendChild(row);
					row.setAttribute("id", String.valueOf(rowId));
					rowId++;
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(""));
					cell.setAttribute("style", "text-align:left;");
					row.appendChild(cell);
				}

				cell = doc.createElement("cell");
				cell.setAttribute("style", "background-color:#f2f2f2;");
				cell.appendChild(doc.createTextNode("Total"));
				row.appendChild(cell);
				cell = doc.createElement("cell");
				cell.setAttribute("style", "background-color:#f2f2f2;");
				isCntRowTtl = commonService.selectString("issue_SQL.getIssueCount", commandMap);
				cell.appendChild(doc.createTextNode(isCntRowTtl));
				row.appendChild(cell);

				for (int k = 0; k < isStsList.size(); k++) {
					Map isStsMap = (Map) isStsList.get(k);
					String issueSts = String.valueOf(isStsMap.get("CODE"));
					commandMap.put("Status", issueSts);
					isCnt = commonService.selectString("issue_SQL.getIssueCount", commandMap);

					cell = doc.createElement("cell");
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(doc.createTextNode(isCnt));
					row.appendChild(cell);
					cell = doc.createElement("cell");
					cell.setAttribute("style", "background-color:#f2f2f2;");
					cell.appendChild(doc.createTextNode(getRatio(new BigDecimal(isCntRowTtl), new BigDecimal(isCnt))));
					row.appendChild(cell);
				}

			}

			// TOTAL 행에 표시될 값
			commandMap.remove("CSRID");
			commandMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			commandMap.remove("Status");
			row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));
			rowId++;
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("Total"));
			cell.setAttribute("style", "text-align:left;font-weight:bold;");
			row.appendChild(cell);

			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			isCntRowTtl = commonService.selectString("issue_SQL.getIssueCount", commandMap);
			cell.appendChild(doc.createTextNode(isCntRowTtl));
			row.appendChild(cell);

			for (int k = 0; k < isStsList.size(); k++) {
				Map isStsMap = (Map) isStsList.get(k);
				String issueSts = String.valueOf(isStsMap.get("CODE"));
				commandMap.put("Status", issueSts);
				isCnt = commonService.selectString("issue_SQL.getIssueCount", commandMap);

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(isCnt));
				row.appendChild(cell);
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(getRatio(new BigDecimal(isCntRowTtl), new BigDecimal(isCnt))));
				row.appendChild(cell);
			}

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);

			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

	}

	@RequestMapping(value = "/visitLogStatistics.do")
		public String visitLogStatistics(HttpServletRequest request, ModelMap model) throws ExceptionUtil {

			String startDate = "";
			String endDate = "";
			try {
				String filepath = request.getSession().getServletContext().getRealPath("/");
				Map<String, Object> setMap = new HashMap<String, Object>();

				List itemNameList = commonService.selectList("analysis_SQL.getProcessMasterName", setMap);
				// List programNameList =
				// commonService.selectList("analysis_SQL.getProgramMasterName", setMap);

				Map rowMap = new HashMap();

				List allCountList = new ArrayList();

				// system date 부터 한달의 visit log 취득
				for (int i = 0; 30 > i; i++) {

					rowMap = new HashMap();

					// Date
					SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
					long date = System.currentTimeMillis() - ((long) 1000 * 60 * 60 * 24 * i);
					rowMap.put("Date", formatter.format(date));

					setMap.put("Date", formatter.format(date));
					if (i == 29) {
						startDate = formatter.format(date);
					} else if (i == 0) {
						endDate = formatter.format(date);
					}
					List processVisitCntList = commonService.selectList("analysis_SQL.getProcessVisitCount", setMap);
					Map processVisitCntMap = getCountMap(processVisitCntList);
					// List programVisitCntList =
					// commonService.selectList("analysis_SQL.getProgramVisitCount", setMap);
					// Map programVisitCntMap = getCountMap(programVisitCntList);

					List getMemberList = commonService.selectList("analysis_SQL.getMemberCount", setMap);

					rowMap.put("totalMember", getMemberList.size());

					for (int j = 0; itemNameList.size() > j; j++) {
						Map itemNameMap = (Map) itemNameList.get(j);
						String itemName = (String) itemNameMap.get("Identifier");

						if (processVisitCntMap.containsKey(itemName)) {
							rowMap.put(itemName, processVisitCntMap.get(itemName));
						} else {
							rowMap.put(itemName, "0");
						}
					}

					/*
					 * for (int j = 0; programNameList.size() > j ; j++) { Map programNameMap =
					 * (Map) programNameList.get(j); String programName = (String)
					 * programNameMap.get("Identifier");
					 * 
					 * if (programVisitCntMap.containsKey(programName)) { rowMap.put("P_" +
					 * programName, programVisitCntMap.get(programName)); } else { rowMap.put("P_" +
					 * programName, "0"); } }
					 */
					allCountList.add(rowMap);
				}

				// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
				// TODO:통계 리스트 표시 할 xml 파일 생성
				DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
				DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

				// 루트 엘리먼트
				Document doc = docBuilder.newDocument();
				Element rootElement = doc.createElement("rows");
				doc.appendChild(rootElement);

				int rowId = 1;

				for (int i = 0; i < allCountList.size(); i++) {
					// row 엘리먼트
					Element row = doc.createElement("row");
					rootElement.appendChild(row);
					row.setAttribute("id", String.valueOf(rowId));
					rowId++;

					Map countRowMap = (Map) allCountList.get(i);

					Element cell = doc.createElement("cell");
					// Date
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("Date"))));
					row.appendChild(cell);

					// Total 접속자수
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("totalMember"))));
					row.appendChild(cell);

					for (int j = 0; itemNameList.size() > j; j++) {
						Map itemNameMap = (Map) itemNameList.get(j);
						String itemName = (String) itemNameMap.get("Identifier");
						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get(itemName))));
						row.appendChild(cell);
					}

					/*
					 * for (int j = 0; programNameList.size() > j ; j++) { Map programNameMap =
					 * (Map) programNameList.get(j); String programName = (String)
					 * programNameMap.get("Identifier"); cell = doc.createElement("cell");
					 * cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("P_" +
					 * programName)))); row.appendChild(cell); }
					 */
				}

				setMap = new HashMap<String, Object>();
				setMap.put("startDate", startDate);
				setMap.put("endDate", endDate);
				List processVisitCntList = commonService.selectList("analysis_SQL.getProcessVisitCount", setMap);
				Map processVisitCntMap = getCountMap(processVisitCntList);
				// List programVisitCntList =
				// commonService.selectList("analysis_SQL.getProgramVisitCount", setMap);
				// Map programVisitCntMap = getCountMap(programVisitCntList);

				// TOTAL 행에 표시될 값 설절
				Element row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));

				Element cell = doc.createElement("cell");
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode("Total"));
				row.appendChild(cell);

				cell = doc.createElement("cell");
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(""));
				row.appendChild(cell);

				for (int j = 0; itemNameList.size() > j; j++) {
					Map itemNameMap = (Map) itemNameList.get(j);
					String itemName = (String) itemNameMap.get("Identifier");
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(StringUtil.checkNull(processVisitCntMap.get(itemName), "0")));
					row.appendChild(cell);
				}

				/*
				 * for (int j = 0; programNameList.size() > j ; j++) { Map programNameMap =
				 * (Map) programNameList.get(j); String programName = (String)
				 * programNameMap.get("Identifier"); cell = doc.createElement("cell");
				 * cell.appendChild(doc.createTextNode(StringUtil.checkNull(programVisitCntMap.
				 * get(programName), "0"))); row.appendChild(cell); }
				 */
				// XML 파일로 쓰기
				TransformerFactory transformerFactory = TransformerFactory.newInstance();
				Transformer transformer = transformerFactory.newTransformer();

				transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				transformer.setOutputProperty(OutputKeys.INDENT, "yes");
				DOMSource source = new DOMSource(doc);

				// XML 데이터를 StringWriter에 기록
				StringWriter writer = new StringWriter();
				transformer.transform(new DOMSource(doc), new StreamResult(writer));
				String xmlDataString = writer.toString();
				
				StreamResult result = new StreamResult(
						new FileOutputStream(new File(filepath + "upload/visitLogStatisticsGrid.xml")));
				transformer.transform(source, result);
				
				
				//headerListJson
				JSONArray headerListJson = new JSONArray();
				for (int i = 0; i < itemNameList.size(); i++) {
				    Map l1Map = (Map) itemNameList.get(i);
				    Map<String, Object> hearderNames = new HashMap<String, Object>();	
				    hearderNames.put("code", l1Map.get("L1ItemID"));
				    hearderNames.put("name", l1Map.get("Identifier"));
				    headerListJson.put(hearderNames);
				}
				
				model.put("headerListJson", headerListJson); 
				model.put("xmlData", xmlDataString); // XML data
				
				// model.put("programRows", makeGridHeader(programNameList, ","));
				// model.put("programCols", makeGridHeader(programNameList, "|"));
				model.put("processRows", makeGridHeader(itemNameList, ","));
				model.put("processCols", makeGridHeader(itemNameList, "|"));
				model.put("processCnt", itemNameList.size());
				// model.put("programCnt", programNameList.size());
				model.put("menu", getLabel(request, commonService));

			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}

			return nextUrl("/aly/visitLogStatistics");
		}

	@RequestMapping(value = "/mainChangeSetStatistics.do")
	public String mainChangeSetStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		String url = "/hom/main/mainSttProgram";

		try {

			String languageID = request.getParameter("languageID");
			String filepath = request.getSession().getServletContext().getRealPath("/");
			String isMain = StringUtil.checkNull(request.getParameter("isMain"));

			/* xml 파일명 설정 */
			String xmlFilName = "upload/mainChangeSet.xml";
			if (isMain.equals("N")) {
				/* xml 파일명 설정 */
				xmlFilName = "upload/mainChangeSet_admin.xml";
			}

			/* xml 파일 존재 할 경우 삭제 */
			File oldFile = new File(filepath + xmlFilName);
			if (oldFile.exists()) {
				oldFile.delete();
			}

			/* 등록일 설정 FromDate:시스템 날짜에서 최근 한달, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.MONTH, -1);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			String scStartDt = StringUtil.checkNull(request.getParameter("scStartDt"), beforeYmd);
			String scEndDt = StringUtil.checkNull(request.getParameter("scEndDt"), thisYmd);
			String parentProjectId = StringUtil.checkNull(request.getParameter("parentId"));

			commandMap.put("LanguageID", commandMap.get("sessionCurrLangType"));

			// get ChangeType List (grid header표시용)
			List changeTypeList = (List) commonService.selectList("analysis_SQL.getChangeTypeList", commandMap);
			// get Level1 NameList (grid header표시용)
			List level1NameList = commonService.selectList("main_SQL.getLevel1Name", commandMap);
			// get getParentIdList (조건 표시용)
			List getParentIdList = commonService.selectList("analysis_SQL.getParentIdList", commandMap);

			// grid에 표시 할 xml file 생성
			setMainChangeSetStatisticsData(filepath, changeTypeList, level1NameList, scStartDt, scEndDt,
					parentProjectId, xmlFilName);

			String header = "";

			for (int j = 0; j < level1NameList.size(); j++) {
				Map level1NameMap = (Map) level1NameList.get(j);
				String level1Name = String.valueOf(level1NameMap.get("label"));

				header = header + "," + level1Name;
			}

			model.put("level1Name", header);
			model.put("cnt", level1NameList.size());
			model.put("xmlFilName", xmlFilName);
			model.put("beforeYmd", scStartDt);
			model.put("thisYmd", scEndDt);
			model.put("isMain", isMain);
			model.put("getParentIdList", getParentIdList);
			model.put("parentId", parentProjectId);
			model.put("subMenuName", StringUtil.checkNull(request.getParameter("subMenuName")));
			model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(url);
	}

	private void setMainChangeSetStatisticsData(String filepath, List changeTypeList, List level1NameList,
			String scStartDt, String scEndDt, String parentProjectId, String xmlFilName) throws ExceptionUtil {

		HashMap commandMap = new HashMap();
		List countList = new ArrayList();
		try {
			commandMap.put("scStartDt", scStartDt);
			commandMap.put("scEndDt", scEndDt);
			commandMap.put("parentId", parentProjectId);

			/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
			List<Map<String, String>> countResultList = new ArrayList<Map<String, String>>();
			Map<String, Integer> countMap = new HashMap<String, Integer>();

			// 변경구분 리스트 기준
			for (int i = 0; i < changeTypeList.size(); i++) {
				Map<String, String> rowMap = new HashMap<String, String>();

				Map changeTypeMap = (Map) changeTypeList.get(i);
				String changeType = String.valueOf(changeTypeMap.get("TypeCode"));
				String changeTypeName = String.valueOf(changeTypeMap.get("Name"));

				rowMap.put("changeTypeName", changeTypeName);
				rowMap.put("changeType", changeType);

				for (int j = 0; j < level1NameList.size(); j++) {
					Map level1NameMap = (Map) level1NameList.get(j);
					String parentId = String.valueOf(level1NameMap.get("ItemID"));

					commandMap.put("ChangeType", changeType);
					commandMap.put("L1ItemID", parentId);

					String count = commonService.selectString("main_SQL.getCountMainChangeSetData", commandMap);
					String putKey = parentId + "_" + changeType;
					String putTtlKey = parentId;
					rowMap.put(putKey, count);

					countMap.put(putKey, Integer.parseInt(count));

					// Total count를 Map에 저장
					if (i == 0) {
						countMap.put(putTtlKey, Integer.parseInt(count));
					} else {
						int nowTotal = countMap.get(putTtlKey);
						countMap.remove(putTtlKey);
						countMap.put(putTtlKey, nowTotal + Integer.parseInt(count));
					}
				}

				countResultList.add(rowMap);
			}

			// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
			// TODO:통계 리스트 표시 할 xml 파일 생성
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);

			int rowId = 1;

			for (int i = 0; i < countResultList.size(); i++) {
				// row 엘리먼트
				Element row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;

				Map<String, String> countRowMap = countResultList.get(i);

				Element cell = doc.createElement("cell");
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(countRowMap.get("changeTypeName")));
				row.appendChild(cell);

				for (int j = 0; level1NameList.size() > j; j++) {
					Map level1NameMap = (Map) level1NameList.get(j);
					String parentId = String.valueOf(level1NameMap.get("ItemID"));
					String putKey = parentId + "_" + countRowMap.get("changeType");

					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(countRowMap.get(putKey)));
					row.appendChild(cell);
				}
			}

			// TOTAL 행에 표시될 값 설절
			Element row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));

			Element cell = doc.createElement("cell");
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("Total"));
			row.appendChild(cell);

			for (int j = 0; level1NameList.size() > j; j++) {
				Map level1NameMap = (Map) level1NameList.get(j);
				String parentId = String.valueOf(level1NameMap.get("ItemID"));

				String putTtlKey = parentId;

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(countMap.get(putTtlKey))));
				row.appendChild(cell);
			}

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);

			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

	}

	@RequestMapping(value = "/newChangeSetStatistics.do")
	public String newChangeSetStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {

		String languageID = request.getParameter("languageID");
		String screenName = StringUtil.checkNull(request.getParameter("kbn"));
		String itemTypeCode = request.getParameter("ItemTypeCode"); // 프로세스 or 프로그램
		String filepath = request.getSession().getServletContext().getRealPath("/");
		String url = "/aly/newChangeSetStatistics";

		try {

			/* xml 파일명 설정 */
			String xmlFilName = "upload/changeSet_" + itemTypeCode + ".xml";

			/* 화면 표시 구분 */
			if (!screenName.isEmpty()) {
				url = "/hom/main/mainSttProgram";
			}

			/* xml 파일 존재 할 경우 삭제 */
			File oldFile = new File(filepath + xmlFilName);
			if (oldFile.exists()) {
				oldFile.delete();
			}

			/* 등록일 설정 FromDate:시스템 날짜에서 최근 1주, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.WEEK_OF_MONTH, -1);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			String scStartDt = StringUtil.checkNull(request.getParameter("scStartDt"), beforeYmd);
			String scEndDt = StringUtil.checkNull(request.getParameter("scEndDt"), thisYmd);

			commandMap.put("LanguageID", commandMap.get("sessionCurrLangType"));

			// get ChangeType List (grid header표시용)
			List changeTypeList = (List) commonService.selectList("analysis_SQL.getChangeTypeList", commandMap);
			// get WorkFlow List (grid header표시용)
			List wfList = commonService.selectList("analysis_SQL.getWFList", commandMap);
			// get Project List (grid header표시용)
			List pjtList = commonService.selectList("analysis_SQL.getPjtList", commandMap);

			// grid에 표시 할 xml file 생성
			setNewChangeSetStatisticsData(filepath, changeTypeList, wfList, pjtList, itemTypeCode, scStartDt, scEndDt,
					xmlFilName);

			String WfNames = makeGridHeader(wfList, "Name", ",");
			String header1 = "";
			String header2 = "";
			String rspan = ",#cspan";
			int cnt = 0;

			for (int j = 0; j < pjtList.size(); j++) {
				header2 = header2 + WfNames;

				Map pjtMap = (Map) pjtList.get(j);
				String pjtName = String.valueOf(pjtMap.get("Name"));

				for (int k = 0; k < wfList.size(); k++) {
					if (k == 0) {
						header1 = header1 + "," + pjtName;
					} else {
						header1 = header1 + rspan;
					}

					cnt++;
				}
			}

			model.put("header1", header1);
			model.put("header2", header2);
			model.put("cnt", cnt);
			model.put("xmlFilName", xmlFilName);
			model.put("itemTypeCode", itemTypeCode);

			model.put("beforeYmd", scStartDt);
			model.put("thisYmd", scEndDt);
			model.put("menu", getLabel(request, commonService));
			model.put("subMenuName", request.getParameter("subMenuName"));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(url);
	}

	@RequestMapping(value = "/itemDeletedList.do")
	public String searchList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		String url = "/aly/itemDeletedList";
		try {
			model.put("menu", getLabel(request, commonService));

			HashMap setMap = new HashMap();

			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("status", StringUtil.checkNull(request.getParameter("status"), ""));
			setMap.put("itemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode"), ""));
			setMap.put("classCode", StringUtil.checkNull(request.getParameter("classCode"), ""));
			
			List getItemDeletedList = commonService.selectList("analysis_SQL.getItemDeletedList_gridList", setMap);
			
			JSONArray gridData = new JSONArray(getItemDeletedList);
			model.put("gridData", gridData);			
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}

	@RequestMapping(value = "/connectionList.do")
	public String connectionList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		String url = "/itm/connection/connectionList";
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String deletedYN = StringUtil.checkNull(commandMap.get("DeletedYN"));
			String reportYN = StringUtil.checkNull(commandMap.get("reportYN"));
			String connectionType = StringUtil.checkNull(commandMap.get("connectionType"));
			String title = "";
			if (deletedYN.equals("Y")) {
				title = "Deleted Connection list";
			} else {
				title = "Connection list";
			}
			
			commandMap.put("languageID", languageID);
			commandMap.put("connectionType", connectionType);
		    commandMap.put("deletedYN", deletedYN);
	        List deletedConnectionList = commonService.selectList("analysis_SQL.getConnectionList_gridList", commandMap);
	        JSONArray gridData = new JSONArray(deletedConnectionList);
	        model.put("gridData",gridData);	     

			model.put("title", title);
			model.put("DeletedYN", deletedYN);
			model.put("reportYN", reportYN);
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
			commandMap.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID")));
			String itemTypeCode = StringUtil
					.checkNull(commonService.selectString("config_SQL.getItemTypeCodeItemID", commandMap));

			model.put("itemTypeCode", itemTypeCode);
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}

	/**
	 * Item Deleted Recover(set Deleted = 0)
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/admin/deletedItemRecover.do")
	public String deletedItemRecover(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		HashMap target = new HashMap();

		try {

			String s_itemIDs = StringUtil.checkNull(request.getParameter("items"));
			String[] arrayStr = s_itemIDs.split(",");
			String itemID = "";
			if (!s_itemIDs.isEmpty()) {
				// Update TB_ITEM Status
				HashMap updateCommandMap = new HashMap();

				updateCommandMap.put("Deleted", "0");
				updateCommandMap.put("Status", "REL");
				updateCommandMap.put("s_itemIDs", s_itemIDs);
				updateCommandMap.put("ItemIDs", s_itemIDs);
				updateCommandMap.put("LastUser", request.getParameter("userId"));
				updateCommandMap.put("recover", "Y");
				Map setData = new HashMap();
				for (int i = 0; arrayStr.length > i; i++) {
					// setData.put("itemID", arrayStr[i]);
				}

				// connection Item update
				commonService.update("item_SQL.updateCNItemDelRecover", updateCommandMap);
				// Item update
				commonService.update("project_SQL.updateItemStatus", updateCommandMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																													// 성공
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 저장
																													// 오류
																													// 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	/**
	 * 선택된 아이템과 하위항목을 모두 삭제
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/admin/delItemMaster.do")
	public String delItemMaster(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		HashMap target = new HashMap();

		try {
			// 선택된 아이템 아이디
			String s_itemIDs = StringUtil.checkNull(request.getParameter("items"));
			String[] arrayStr = s_itemIDs.split(",");

			for (int i = 0; arrayStr.length > i; i++) {
				String itemId = arrayStr[i];
				GetItemAttrList.delItem(commonService, itemId);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제
																													// 성공
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 오류
																													// 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);

	}

	@RequestMapping(value = "/admin/deleteCNItems.do")
	public String deleteCNItems(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		HashMap target = new HashMap();
		try {
			Map setMap = new HashMap();
			String CNItems = StringUtil.checkNull(request.getParameter("items"), "");
			setMap.put("ItemIDs", CNItems);
			commonService.delete("item_SQL.deleteRefAttrData", setMap);
			commonService.delete("item_SQL.deleteRefItem", setMap);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제
																													// 성공
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " 삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제
																													// 오류
																													// 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/modelObjectSearch.do")
	public String modelObjectSearch(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		String url = "/aly/modelObjectSearch";
		try {
			Map setMap = new HashMap();

			setMap.put("languageID", commandMap.get("sessionCurrLangType"));

			/** 법인 List */
			setMap.put("TeamType", "2");
			List companyOptionList = commonService.selectList("organization_SQL.getTeamList", setMap);
			model.put("companyOption", companyOptionList);

			/** Symbol List */
			List symbolCodeList = commonService.selectList("search_SQL.getSymbolCodeList", setMap);
			model.put("symbolCodeList", symbolCodeList);

			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);

			model.put("defaultLang", defaultLang);
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}

	/**
	 * 해당 카테고리 의 [itemTypeCodeList]를 취득
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/getItemTypeSelectOption.do")
	public String getSymbolSelectOption(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		try {
			commandMap.put("category", request.getParameter("category"));
			List getList = commonService.selectList("analysis_SQL.getItemTypeCodeWithCategory", commandMap);

			model.put(AJAX_RESULTMAP, getList);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(AJAXPAGE_SELECTOPTION);
	}

	private String makeGridHeader(List list, String keyName, String conStr) {
		String strHeader = "";
		for (int i = 0; list.size() > i; i++) {
			Map map = (Map) list.get(i);
			String name = (String) map.get(keyName);

			strHeader = strHeader + conStr + name;
		}
		return strHeader;
	}

	private void setNewChangeSetStatisticsData(String filepath, List changeTypeList, List wfList, List pjtList,
			String itemTypeCode, String scStartDt, String scEndDt, String xmlFilName) throws ExceptionUtil {

		HashMap commandMap = new HashMap();
		List countList = new ArrayList();
		try {
			commandMap.put("scStartDt", scStartDt);
			commandMap.put("scEndDt", scEndDt);
			commandMap.put("ItemTypeCode", itemTypeCode);

			/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
			List<Map<String, String>> countResultList = new ArrayList<Map<String, String>>();
			Map<String, Integer> countMap = new HashMap<String, Integer>();

			// 변경구분 리스트 기준
			for (int i = 0; i < changeTypeList.size(); i++) {
				Map<String, String> rowMap = new HashMap<String, String>();

				Map changeTypeMap = (Map) changeTypeList.get(i);
				String changeType = String.valueOf(changeTypeMap.get("TypeCode"));
				String changeTypeName = String.valueOf(changeTypeMap.get("Name"));

				rowMap.put("changeTypeName", changeTypeName);

				for (int j = 0; j < pjtList.size(); j++) {
					Map pjtMap = (Map) pjtList.get(j);
					String parentId = String.valueOf(pjtMap.get("ProjectID"));

					for (int k = 0; k < wfList.size(); k++) {
						Map wfMap = (Map) wfList.get(k);
						String wfId = String.valueOf(wfMap.get("WFID"));

						commandMap.put("ChangeType", changeType);
						commandMap.put("ParentID", parentId);
						commandMap.put("WFID", wfId);

						String count = commonService.selectString("analysis_SQL.getCountChangeSetData", commandMap);
						String putKey = parentId + "_" + wfId;
						rowMap.put(putKey, count);

						// 각 ModuleName별 Total count를 Map에 저장
						if (i == 0) {
							countMap.put(putKey, Integer.parseInt(count));
						} else {
							int nowTotal = countMap.get(putKey);
							countMap.remove(putKey);
							countMap.put(putKey, nowTotal + Integer.parseInt(count));
						}
					}
				}

				countResultList.add(rowMap);
			}

			// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
			// TODO:통계 리스트 표시 할 xml 파일 생성
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);

			int rowId = 1;

			for (int i = 0; i < countResultList.size(); i++) {
				// row 엘리먼트
				Element row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;

				Map<String, String> countRowMap = countResultList.get(i);

				Element cell = doc.createElement("cell");
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(countRowMap.get("changeTypeName")));
				row.appendChild(cell);

				for (int j = 0; pjtList.size() > j; j++) {
					Map pjtMap = (Map) pjtList.get(j);
					String parentId = String.valueOf(pjtMap.get("ProjectID"));

					for (int k = 0; k < wfList.size(); k++) {
						Map wfMap = (Map) wfList.get(k);
						String wfId = String.valueOf(wfMap.get("WFID"));
						String putKey = parentId + "_" + wfId;

						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(countRowMap.get(putKey)));
						row.appendChild(cell);

					}
				}
			}

			// TOTAL 행에 표시될 값 설절
			Element row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));

			Element cell = doc.createElement("cell");
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("Total"));
			row.appendChild(cell);

			for (int j = 0; pjtList.size() > j; j++) {
				Map pjtMap = (Map) pjtList.get(j);
				String parentId = String.valueOf(pjtMap.get("ProjectID"));

				for (int k = 0; k < wfList.size(); k++) {
					Map wfMap = (Map) wfList.get(k);
					String wfId = String.valueOf(wfMap.get("WFID"));
					String putKey = parentId + "_" + wfId;

					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(String.valueOf(countMap.get(putKey))));
					row.appendChild(cell);

				}
			}

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);

			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

	}

	@RequestMapping(value = "/visitLogStatisticsByDay.do")
	public String visitLogStatisticsByDay(HttpServletRequest request, ModelMap model, HashMap cmmMap)
			throws ExceptionUtil {

		try {
			String haederL1 = StringUtil.checkNull(request.getParameter("haederL1"), "");

			List getL1List = new ArrayList();
			List allCountList = new ArrayList();
			Map rowMap = new HashMap();
			long startDate = 0, endDate = 0;

			List headerList = new ArrayList();
			List masterL1List = new ArrayList();
			List itemTypeCodeList = new ArrayList();
			List tempList = new ArrayList();

			String filepath = request.getSession().getServletContext().getRealPath("/");
			Map<String, Object> setMap = new HashMap<String, Object>();
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));

			setMap.put("haederL1", haederL1);
			setMap.put("category", "OJ");
			masterL1List = commonService.selectList("analysis_SQL.getMasterL1List", setMap);
			String headerL1Code, headerL1Name = "";
			for (int i = 0; i < masterL1List.size(); i++) {
				rowMap = new HashMap();
				tempList = new ArrayList();
				Map headerL1Map = (Map) masterL1List.get(i);
				headerL1Code = String.valueOf(headerL1Map.get("CODE"));
				tempList.add(headerL1Code);

				headerL1Name = String.valueOf(headerL1Map.get("NAME"));
				setMap.put("itemTypeCodeList", tempList);
				getL1List = commonService.selectList("analysis_SQL.getL1List", setMap);
				rowMap.put("headerL1code", headerL1Code);
				rowMap.put("cnt", getL1List.size());
				rowMap.put("headerL1name", headerL1Name);
				headerList.add(rowMap);
				itemTypeCodeList.add(headerL1Code);
			}

			// setMap.put("itemTypeCode",haederL1);
			setMap.put("itemTypeCodeList", itemTypeCodeList);
			getL1List = commonService.selectList("analysis_SQL.getL1List", setMap);
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");

			// system date 부터 한달의 visit log 취득
			for (int i = 1; 31 > i; i++) {
				rowMap = new HashMap();

				long date = System.currentTimeMillis() - ((long) 1000 * 60 * 60 * 24 * i);

				if (i == 1) {
					endDate = date;
				}
				if (i == 30) {
					startDate = date;
				}

				rowMap.put("Date", formatter.format(date));
				setMap.put("dayType", StringUtil.checkNull(cmmMap.get("dayType"), "DAY"));

				setMap.put("Date", formatter.format(date));
				List visitCountByConLogList = commonService.selectList("analysis_SQL.getVisitCountByConLog", setMap);
				Map visitCountByConLogMap = getCountMap(visitCountByConLogList, "L1ItemID", "CNT");
				rowMap.put("totalMember", NumberUtil.getIntValue(visitCountByConLogMap.get("MemberCount")));

				for (int j = 0; getL1List.size() > j; j++) {
					Map l1Map = (Map) getL1List.get(j);
					String l1Code = String.valueOf(l1Map.get("CODE"));

					if (visitCountByConLogMap.containsKey(l1Code)) {
						rowMap.put(l1Code, visitCountByConLogMap.get(l1Code));
					} else {
						rowMap.put(l1Code, "0");
					}
				}
				allCountList.add(rowMap);
			}

			// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
			// TODO:통계 리스트 표시 할 xml 파일 생성
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);

			int rowId = 1;

			for (int i = 0; i < allCountList.size(); i++) {
				// row 엘리먼트
				Element row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;

				Map countRowMap = (Map) allCountList.get(i);

				Element cell = doc.createElement("cell");
				// Date
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("Date"))));
				row.appendChild(cell);

				// Total 접속자수
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("totalMember"))));
				row.appendChild(cell);

				for (int j = 0; getL1List.size() > j; j++) {
					Map l1Map = (Map) getL1List.get(j);
					String l1Code = String.valueOf(l1Map.get("CODE"));
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get(l1Code))));
					row.appendChild(cell);
				}
			}

			setMap = new HashMap<String, Object>();
			setMap.put("startDate", formatter.format(startDate));
			setMap.put("endDate", formatter.format(endDate));
			setMap.put("dayType", StringUtil.checkNull(cmmMap.get("dayType"), "DAY"));
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("itemTypeCodeList", itemTypeCodeList);
			setMap.put("category", "OJ");
			List visitCountByConLogList = commonService.selectList("analysis_SQL.getVisitCountByConLog", setMap);
			Map visitCountByConLogMap = getCountMap(visitCountByConLogList, "L1ItemID", "CNT");

			// TOTAL 행에 표시될 값 설절
			Element row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));

			Element cell = doc.createElement("cell");
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("Total"));
			row.appendChild(cell);

			cell = doc.createElement("cell");
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(StringUtil.checkNull(visitCountByConLogMap.get("MemberCount"), "0")));
			row.appendChild(cell);

			for (int j = 0; getL1List.size() > j; j++) {
				Map L1Map = (Map) getL1List.get(j);
				String l1Code = String.valueOf(L1Map.get("CODE"));
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(StringUtil.checkNull(visitCountByConLogMap.get(l1Code), "0")));
				row.appendChild(cell);
			}

			model.put("headerRows", makeGridHeader(getL1List, "NAME", ","));
			model.put("headerCols", makeGridHeader(getL1List, "|"));

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);
			
			// XML 데이터를 StringWriter에 기록
			StringWriter writer = new StringWriter();
			transformer.transform(new DOMSource(doc), new StreamResult(writer));
			String xmlDataString = writer.toString();

			StreamResult result = new StreamResult(
					new FileOutputStream(new File(filepath + "upload/visitLogStatisticsByDayGrid.xml")));
			transformer.transform(source, result);

			//headerListJson
			JSONArray headerListJson = new JSONArray();
			for (int i = 0; i < getL1List.size(); i++) {
			    Map l1Map = (Map) getL1List.get(i);
			    Map<String, Object> hearderNames = new HashMap<String, Object>();	
			    hearderNames.put("code", l1Map.get("CODE"));
			    hearderNames.put("name", l1Map.get("NAME"));
			    headerListJson.put(hearderNames);
			}

			model.put("headerListJson", headerListJson); 
 			model.put("xmlData", xmlDataString); // XML data
			model.put("haederL1", haederL1);
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/aly/visitLogStatisticsByDay");
	}

	private Map getCountMap(List conutList) {
		Map contMap = new HashMap();
		Map mapValue = new HashMap();
		for (int i = 0; i < conutList.size(); i++) {
			mapValue = (HashMap) conutList.get(i);
			contMap.put(mapValue.get("Identifier"), mapValue.get("CNT"));
		}

		return contMap;
	}

	private Map getCountMap(List conutList, String pKey, String pValue) {
		Map contMap = new HashMap();
		Map mapValue = new HashMap();
		for (int i = 0; i < conutList.size(); i++) {
			mapValue = (HashMap) conutList.get(i);
			contMap.put(mapValue.get(pKey), mapValue.get(pValue));
		}

		return contMap;
	}

	private String makeGridHeader(List list, String conStr) {
		String strHeader = "";
		for (int i = 0; list.size() > i; i++) {
			Map map = (Map) list.get(i);
			String name = (String) map.get("Identifier");

			strHeader = strHeader + conStr + name;
		}
		return strHeader;
	}

	private Map setItemStatisticsData(String filepath, String nextFromId, String levelName, String languageID)
			throws ExceptionUtil {

		HashMap returnMap = new HashMap();
		List returnChartList = new ArrayList();
		List displayChartList = new ArrayList();

		// TODO:통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);

			List returnData = new ArrayList();
			HashMap commandMap = new HashMap();
			int rowId = 1;
			commandMap.put("FromItemID", "1");
			commandMap.put("LanguageID", languageID);
			commandMap.put("AttrTypeCode", "AT00001");
			returnData = (List) commonService.selectList("analysis_SQL.getLevelNames", commandMap);
			returnMap.put("L1NameList", returnData);

			if (nextFromId.equals("0")) {
				optionSelectedAll(doc, rootElement, returnData, returnChartList, displayChartList, returnMap,
						languageID);
			} else {
				optionSelectedItemName(doc, rootElement, returnChartList, displayChartList, nextFromId, levelName,
						returnMap, languageID);
			}

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(
					new FileOutputStream(new File(filepath + "upload/statisticsGrid.xml")));

			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return returnMap;

	}

	private Map setDimensionStatisticsData(String filepath, List itemNameList, List dimTypeList) throws ExceptionUtil {

		HashMap returnMap = new HashMap();
		List returnChartList = new ArrayList();
		List displayChartList = new ArrayList();

		// TODO:통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);

			HashMap commandMap = new HashMap();

			List allCountList = new ArrayList();
			List dimTypeNameList = new ArrayList();
			String dimTypeName = "";
			/* gridArea에 표시할 Count, Ratio 값을 취득하여 각 행의 List에 저장 */
			for (int i = 0; i < dimTypeList.size(); i++) {
				Map dimTypeMap = new HashMap();
				dimTypeMap = (Map) dimTypeList.get(i);
				String dimValueID = dimTypeMap.get("DimValueID").toString();
				String dimValueName = dimTypeMap.get("DimValueName").toString();
				String dimTypeID = dimTypeMap.get("DimTypeID").toString();

				commandMap.put("DimValueID", dimValueID);
				commandMap.put("DimTypeID", dimTypeID);
				List itemList = (List) commonService.selectList("analysis_SQL.getDimensionItemId", commandMap);
				List countList = new ArrayList();
				Map countMap = new HashMap(); // key:[1 개발],[2 마케팅],[3 영업],[4 구매],[5 제조],[6 설비],[7 물류],[8 경영]...

				for (int j = 0; j < itemList.size(); j++) {
					Map itemIdMap = new HashMap();
					itemIdMap = (Map) itemList.get(j);
					String itemId = itemIdMap.get("ItemID").toString();

					findProcessAndCounting(itemId, itemNameList, countMap);
				}

				countMap.put("TotalCount", itemList.size());
				countMap.put("dimTypeName", dimTypeMap.get("DimTypeName").toString()); // ex)Company, Business area...
				countMap.put("dimValueName", dimValueName + "(" + dimValueID + ")"); // ex)전사공통(70), 한국본사(71)...
				if (!dimTypeName.equals(dimTypeMap.get("DimTypeName").toString())) {
					dimTypeName = dimTypeMap.get("DimTypeName").toString();
					dimTypeNameList.add(dimTypeName);
				}
				countList.add(countMap);
				allCountList.add(countList);
			}

			int rowId = 1;
			List<BigDecimal> totalCountList = new ArrayList<BigDecimal>();

			/* gridArea에 표시할 xml 파일 생성 */
			for (int i = 0; i < itemNameList.size(); i++) {
				Map itemNameMap = new HashMap();
				itemNameMap = (Map) itemNameList.get(i);
				String levelName = itemNameMap.get("LevelName").toString();

				// row 엘리먼트
				Element row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;

				Element cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(levelName));
				row.appendChild(cell);

				BigDecimal totalCount = BigDecimal.ZERO;

				// grid표시용 xml 데이터 설정
				for (int j = 0; j < allCountList.size(); j++) {
					List countList = (List) allCountList.get(j);
					Map countMap = (Map) countList.get(0);
					BigDecimal count = BigDecimal.ZERO;

					if (countMap.containsKey(levelName)) {
						count = new BigDecimal((countMap.get(levelName).toString()));
					}

					totalCount = new BigDecimal((countMap.get("TotalCount").toString()));

					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(String.valueOf(count)));
					row.appendChild(cell);

					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(getRatio(totalCount, count)));
					row.appendChild(cell);

					if (i == 0) {
						totalCountList.add(totalCount);
					}
				}

			}

			Map jsonMap = new HashMap();
			Map displayChartMap = new HashMap();
			Map chartJson = new HashMap();

			String dimValueName = "";
			String col = "";

			// chart표시용 데이터 설정
			for (int j = 0; j < dimTypeNameList.size(); j++) {
				List jsonList = new ArrayList();
				dimTypeName = dimTypeNameList.get(j).toString();

				for (int t = 0; t < itemNameList.size(); t++) {
					Map itemNameMap = new HashMap();
					itemNameMap = (Map) itemNameList.get(t);
					String levelName = itemNameMap.get("LevelName").toString();
					jsonMap = new HashMap();
					jsonMap.put("label", levelName);
					col = "label";
					int valueCnt = 0;
					dimValueName = "";
					for (int i = 0; i < allCountList.size(); i++) {
						List countList = (List) allCountList.get(i);
						Map countMap = (Map) countList.get(0);

						if (dimTypeName.equals(countMap.get("dimTypeName").toString())) {
							BigDecimal count = BigDecimal.ZERO;
							if (countMap.containsKey(levelName)) {
								count = new BigDecimal((countMap.get(levelName).toString()));
							}
							BigDecimal totalCount = new BigDecimal((countMap.get("TotalCount").toString()));

							jsonMap.put("value" + valueCnt, getRatio(totalCount, count).replace("%", ""));
							col = col + ",value" + valueCnt;
							valueCnt++;
							if (dimValueName.isEmpty()) {
								dimValueName = countMap.get("dimValueName").toString();
							} else {
								dimValueName = dimValueName + "," + countMap.get("dimValueName").toString();
							}

						}
					}

					jsonList.add(jsonMap);
					chartJson = new HashMap();
					String[] cols = col.split(",");
					chartJson.put("jsonData",
							JsonUtil.parseJson(jsonList, cols, "/dev_xbolt").replace("&", "<ampersand>"));
				}

				displayChartMap = new HashMap();
				displayChartMap.put("dimTypeName", dimTypeName);
				displayChartMap.put("dimValueName", dimValueName);

				returnChartList.add(chartJson);
				displayChartList.add(displayChartMap);

			}

			// row 엘리먼트
			Element row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));

			Element cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("Total"));
			row.appendChild(cell);

			for (BigDecimal totalCount : totalCountList) {
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(totalCount)));
				row.appendChild(cell);

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(""));
				row.appendChild(cell);
			}

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(
					new FileOutputStream(new File(filepath + "upload/dimensionStatisticsGrid.xml")));

			transformer.transform(source, result);

			returnMap.put("ChartList", returnChartList);
			returnMap.put("displayChartList", displayChartList);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return returnMap;

	}

	private Map setChangeSetStatisticsData(String filepath, List itemTypeCodeList, List teamIdList, String languageID,
			String scStartDt, String scEndDt) throws ExceptionUtil {

		HashMap returnMap = new HashMap();
		List returnChartList = new ArrayList();

		// TODO:통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);

			HashMap commandMap = new HashMap();

			commandMap.put("LanguageID", languageID);
			commandMap.put("scStartDt", scStartDt);
			commandMap.put("scEndDt", scEndDt);
			List changeSetDataList = (List) commonService.selectList("analysis_SQL.getChangeSetData", commandMap);
			List countList = new ArrayList();

			/* gridArea에 표시할 Count, Ratio 값을 취득하여 각 행의 List에 저장 */
			String TeamID = "";
			String ItemTypeCode = "";
			Map countMap = new HashMap();
			Map totalCountMap = new HashMap();
			List<Map> totalCountList = new ArrayList<Map>();
			for (int i = 0; i < changeSetDataList.size(); i++) {
				Map changeSetDataMap = new HashMap();
				changeSetDataMap = (Map) changeSetDataList.get(i);
				if (i == 0) {
					TeamID = changeSetDataMap.get("TeamID").toString();
					ItemTypeCode = changeSetDataMap.get("ItemTypeCode").toString();
					countMap = new HashMap();
					countMap.put("TeamID", TeamID);
					countMap.put("ItemTypeCode", ItemTypeCode);
					countMap.put("Count", 1);

					totalCountMap = new HashMap();
					totalCountMap.put("Total", 1);

				} else {

					if (ItemTypeCode.equals(changeSetDataMap.get("ItemTypeCode").toString())) {
						int totalCnt = Integer.parseInt(totalCountMap.get("Total").toString());
						totalCountMap.remove("Total");
						totalCountMap.put("Total", totalCnt + 1);
					} else {
						totalCountList.add(totalCountMap);
						totalCountMap = new HashMap();
						totalCountMap.put("Total", 1);
					}

					if (TeamID.equals(changeSetDataMap.get("TeamID").toString())
							&& ItemTypeCode.equals(changeSetDataMap.get("ItemTypeCode").toString())) {
						int cnt = Integer.parseInt(countMap.get("Count").toString());
						countMap.remove("Count");
						countMap.put("Count", cnt + 1);
					} else {
						countList.add(countMap);
						TeamID = changeSetDataMap.get("TeamID").toString();
						ItemTypeCode = changeSetDataMap.get("ItemTypeCode").toString();
						countMap = new HashMap();
						countMap.put("TeamID", TeamID);
						countMap.put("ItemTypeCode", ItemTypeCode);
						countMap.put("Count", 1);
					}
				}
			}

			// 마지막 데이터 리스트에 추가
			countList.add(countMap);
			totalCountList.add(totalCountMap);

			int rowId = 1;

			Map jsonMap = new HashMap();
			List jsonList = new ArrayList();

			/* gridArea에 표시할 xml 파일 생성 */
			for (int i = 0; i < teamIdList.size(); i++) {
				Map teamIdMap = new HashMap();
				teamIdMap = (Map) teamIdList.get(i);
				TeamID = teamIdMap.get("TeamID").toString();
				String TeamName = teamIdMap.get("TeamName").toString();

				// row 엘리먼트
				Element row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;

				Element cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(TeamName));
				row.appendChild(cell);

				BigDecimal totalCount = BigDecimal.ZERO;

				// grid표시용 xml 데이터 설정
				for (int j = 0; j < itemTypeCodeList.size(); j++) {
					Map itemTypeCodeMap = new HashMap();
					itemTypeCodeMap = (Map) itemTypeCodeList.get(j);
					ItemTypeCode = itemTypeCodeMap.get("ItemTypeCode").toString();
					BigDecimal count = BigDecimal.ZERO;

					totalCountMap = (Map) totalCountList.get(j);

					for (int t = 0; t < countList.size(); t++) {
						countMap = (Map) countList.get(t);

						if (TeamID.equals(countMap.get("TeamID"))
								&& ItemTypeCode.equals(countMap.get("ItemTypeCode"))) {
							count = new BigDecimal((countMap.get("Count").toString()));
							break;
						}

					}

					totalCount = new BigDecimal((totalCountMap.get("Total").toString()));

					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(String.valueOf(count)));
					row.appendChild(cell);

					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(getRatio(totalCount, count)));
					row.appendChild(cell);

					jsonMap = new HashMap();
					jsonMap.put("label", itemTypeCodeMap.get("ItemTypeName").toString());
					jsonMap.put("value", getRatio(totalCount, count).replace("%", ""));
					jsonList.add(jsonMap);

				}

				String[] cols = { "label", "value" };
				jsonMap = new HashMap();
				jsonMap.put("jsonData", JsonUtil.parseJson(jsonList, cols, "/dev_xbolt"));
				jsonList = new ArrayList();
				returnChartList.add(jsonMap);
			}

			// row 엘리먼트
			Element row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));

			Element cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("Total"));
			row.appendChild(cell);

			for (Map map : totalCountList) {
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(map.get("Total"))));
				row.appendChild(cell);

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(""));
				row.appendChild(cell);
			}

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);

			StreamResult result = new StreamResult(
					new FileOutputStream(new File(filepath + "upload/changeSetStatisticsGrid.xml")));
			transformer.transform(source, result);

			returnMap.put("ChartList", returnChartList);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return returnMap;

	}

	private void findProcessAndCounting(String itemId, List itemNameList, Map countMap) throws ExceptionUtil {
		HashMap commandMap = new HashMap();
		commandMap.put("ItemID", itemId);
		try {
			List fromItemIdList = (List) commonService.selectList("analysis_SQL.getFromItemID", commandMap);
			if (fromItemIdList.size() != 0) {
				Map fromItemIdMap = (Map) fromItemIdList.get(0);
				String fromItemId = fromItemIdMap.get("FromItemID").toString();
				int level = Integer.parseInt(fromItemIdMap.get("Level").toString());
				int checkCnt = level;

				for (int t = 0; t < checkCnt; t++) {
					if (level == 1) {
						for (int g = 0; g < itemNameList.size(); g++) {
							Map itemNameMap = new HashMap();
							itemNameMap = (Map) itemNameList.get(g);
							String levelName = itemNameMap.get("LevelName").toString();
							String nextFromId = itemNameMap.get("NextFromId").toString();
							if (fromItemId.equals(nextFromId)) {
								if (countMap.containsKey(levelName)) {
									int oldCount = Integer.parseInt(countMap.get(levelName).toString());
									countMap.remove(levelName);
									countMap.put(levelName, oldCount + 1);
								} else {
									countMap.put(levelName, 1);
								}
								break;
							}
						}

					} else {
						commandMap.put("ItemID", fromItemId);
						fromItemIdList = (List) commonService.selectList("analysis_SQL.getFromItemID", commandMap);
						fromItemIdMap = (Map) fromItemIdList.get(0);
						fromItemId = fromItemIdMap.get("FromItemID").toString();
						level = Integer.parseInt(fromItemIdMap.get("Level").toString());
					}

				}
			}
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

	}

	private HashMap setRowItemValue(Document doc, Element rootElement, String nextFromId, String levelName,
			String languageID, int rowId) throws ExceptionUtil {

		HashMap subTotalValueMap = new HashMap();
		HashMap commandMap = new HashMap();

		int L2SubTotal = 0;
		int L3SubTotal = 0;
		int L4SubTotal = 0;
		int C4TotalSubTotal = 0;
		int C4ERPSubTotal = 0;
		int C4LegacySubTotal = 0;
		int C4ManSubTotal = 0;
		int V4TotalSubTotal = 0;
		int V4ERPSubTotal = 0;
		int V4LegacySubTotal = 0;
		int V4ManSubTotal = 0;
		int L5TotalSubTotal = 0;
		int L5ERPSubTotal = 0;
		int L5LegacySubTotal = 0;
		int L5ManSubTotal = 0;

		commandMap = new HashMap();
		commandMap.put("FromItemID", nextFromId);
		commandMap.put("LanguageID", languageID);
		commandMap.put("AttrTypeCode", "AT00001");
		try {
			List level2NameList = (List) commonService.selectList("analysis_SQL.getLevelNames", commandMap);

			for (int j = 0; j < level2NameList.size(); j++) {
				Map level2NameMap = new HashMap();
				level2NameMap = (Map) level2NameList.get(j);
				String level2Name = level2NameMap.get("LevelName").toString();
				nextFromId = level2NameMap.get("NextFromId").toString();

				// row 엘리먼트
				Element row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;

				// cell: L1 Name 엘리먼트
				Element cell1 = doc.createElement("cell");
				if (j == 0) {
					cell1.appendChild(doc.createTextNode(levelName));
					cell1.setAttribute("rowspan", String.valueOf(level2NameList.size() + 2));
				} else {
					cell1.appendChild(doc.createTextNode(""));
				}
				row.appendChild(cell1);

				// cell: L2 Name 엘리먼트
				Element cell2 = doc.createElement("cell");
				cell2.appendChild(doc.createTextNode(level2Name));
				row.appendChild(cell2);

				// cell: L2 엘리먼트
				int l2Cnt = 1;
				Element cell3 = doc.createElement("cell");
				cell3.appendChild(doc.createTextNode(String.valueOf(l2Cnt))); //
				row.appendChild(cell3);
				L2SubTotal = L2SubTotal + l2Cnt;

				// cell: L3 엘리먼트
				Element cell4 = doc.createElement("cell");
				commandMap = new HashMap();
				commandMap.put("FromItemID", nextFromId);
				commandMap.put("LanguageID", languageID);
				commandMap.put("AttrTypeCode", "AT00001");
				List level3NameList = (List) commonService.selectList("analysis_SQL.getLevelNames", commandMap);
				int l3Cnt = 0;
				l3Cnt = level3NameList.size();
				cell4.appendChild(doc.createTextNode(String.valueOf(level3NameList.size())));
				row.appendChild(cell4);
				L3SubTotal = L3SubTotal + l3Cnt;

				// cell: L4 엘리먼트
				Element cell5 = doc.createElement("cell");
				int l4Cnt = 0;
				String nextFromIds = setIdList(level3NameList, "NextFromId");
				String l5StartFromIds = "";

				if (!nextFromIds.isEmpty()) {
					commandMap.put("FromItemID", nextFromIds);
					commandMap.put("LanguageID", languageID);
					commandMap.put("AttrTypeCode", "AT00001");
					List level4NameList = (List) commonService.selectList("analysis_SQL.getLevelNames", commandMap);
					l4Cnt = level4NameList.size();

					nextFromIds = setIdList(level4NameList, "NextFromId");
					l5StartFromIds = nextFromIds;
				}

				cell5.appendChild(doc.createTextNode(String.valueOf(l4Cnt)));
				row.appendChild(cell5);
				L4SubTotal = L4SubTotal + l4Cnt;

				// cell: C4 Total 엘리먼트
				String c4ItemId = "";
				int c4TtlCnt = 0;

				if (!nextFromIds.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("FromItemID", nextFromIds);
					commandMap.put("LanguageID", languageID);
					commandMap.put("AttrTypeCode", "AT00005");
					commandMap.put("Level", "C4");
					List c4TotalList = (List) commonService.selectList("analysis_SQL.getLevel56Names", commandMap);
					c4TtlCnt = c4TotalList.size();

					c4ItemId = setIdList(c4TotalList, "ItemID");
				}

				Element cell6 = doc.createElement("cell");
				cell6.appendChild(doc.createTextNode(String.valueOf(c4TtlCnt)));
				row.appendChild(cell6);
				C4TotalSubTotal = C4TotalSubTotal + c4TtlCnt;

				// cell: C4 ERP 엘리먼트
				int c4Erp = 0;
				if (!c4ItemId.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("ItemID", c4ItemId);
					commandMap.put("LanguageID", languageID);
					commandMap.put("AttrTypeCode", "AT00037");
					commandMap.put("LovCodeValue", "LV37002");
					List c4ErpList = (List) commonService.selectList("analysis_SQL.getLevel56Names", commandMap);
					c4Erp = c4ErpList.size();
				}
				Element cell7 = doc.createElement("cell");
				cell7.appendChild(doc.createTextNode(String.valueOf(c4Erp)));
				row.appendChild(cell7);
				C4ERPSubTotal = C4ERPSubTotal + c4Erp;

				// cell: C4 Legacy 엘리먼트
				int c4Legacy = 0;
				if (!c4ItemId.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("ItemID", c4ItemId);
					commandMap.put("LanguageID", languageID);
					commandMap.put("AttrTypeCode", "AT00037");
					commandMap.put("LovCodeValue", "LV37005");
					List c4LegacyList = (List) commonService.selectList("analysis_SQL.getLevel56Names", commandMap);
					c4Legacy = c4LegacyList.size();
				}
				Element cell8 = doc.createElement("cell");
				cell8.appendChild(doc.createTextNode(String.valueOf(c4Legacy)));
				row.appendChild(cell8);
				C4LegacySubTotal = C4LegacySubTotal + c4Legacy;

				// cell: C4 Man 엘리먼트
				int c4Man = 0;
				if (!c4ItemId.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("ItemID", c4ItemId);
					commandMap.put("LanguageID", languageID);
					List c4ManList = (List) commonService.selectList("analysis_SQL.getLevel5Man", commandMap);
					c4Man = c4ManList.size();
				}
				Element cell9 = doc.createElement("cell");
				cell9.appendChild(doc.createTextNode(String.valueOf(c4Man)));
				row.appendChild(cell9);
				C4ManSubTotal = C4ManSubTotal + c4Man;

				// cell: V4 Total 엘리먼트
				String v4ItemId = "";
				int v4TtlCnt = 0;

				if (!nextFromIds.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("FromItemID", nextFromIds);
					commandMap.put("LanguageID", languageID);
					commandMap.put("AttrTypeCode", "AT00005");
					commandMap.put("Level", "V4");
					List v4TotalList = (List) commonService.selectList("analysis_SQL.getLevel56Names", commandMap);
					v4TtlCnt = v4TotalList.size();

					v4ItemId = setIdList(v4TotalList, "ItemID");
				}

				Element cell10 = doc.createElement("cell");
				cell10.appendChild(doc.createTextNode(String.valueOf(v4TtlCnt)));
				row.appendChild(cell10);
				V4TotalSubTotal = V4TotalSubTotal + v4TtlCnt;

				// cell: V4 ERP 엘리먼트
				int v4Erp = 0;
				if (!v4ItemId.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("ItemID", v4ItemId);
					commandMap.put("LanguageID", languageID);
					commandMap.put("AttrTypeCode", "AT00037");
					commandMap.put("LovCodeValue", "LV37002");
					List v4ErpList = (List) commonService.selectList("analysis_SQL.getLevel56Names", commandMap);
					v4Erp = v4ErpList.size();
				}
				Element cell11 = doc.createElement("cell");
				cell11.appendChild(doc.createTextNode(String.valueOf(v4Erp)));
				row.appendChild(cell11);
				V4ERPSubTotal = V4ERPSubTotal + v4Erp;

				// cell: V4 Legacy 엘리먼트
				int v4Legacy = 0;
				if (!v4ItemId.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("ItemID", v4ItemId);
					commandMap.put("LanguageID", languageID);
					commandMap.put("AttrTypeCode", "AT00037");
					commandMap.put("LovCodeValue", "LV37005");
					List v4LegacyList = (List) commonService.selectList("analysis_SQL.getLevel56Names", commandMap);
					v4Legacy = v4LegacyList.size();
				}
				Element cell12 = doc.createElement("cell");
				cell12.appendChild(doc.createTextNode(String.valueOf(v4Legacy)));
				row.appendChild(cell12);
				V4LegacySubTotal = V4LegacySubTotal + v4Legacy;

				// cell: V4 Man 엘리먼트
				int v4Man = 0;
				if (!v4ItemId.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("ItemID", v4ItemId);
					commandMap.put("LanguageID", languageID);
					List v4ManList = (List) commonService.selectList("analysis_SQL.getLevel5Man", commandMap);
					v4Man = v4ManList.size();
				}
				Element cell13 = doc.createElement("cell");
				cell13.appendChild(doc.createTextNode(String.valueOf(v4Man)));
				row.appendChild(cell13);
				V4ManSubTotal = V4ManSubTotal + v4Man;

				// cell: Total(L5) 엘리먼트
				int l5Ttl = 0;
				nextFromIds = l5StartFromIds;
				if (!nextFromIds.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("FromItemID", nextFromIds);
					commandMap.put("LanguageID", languageID);
					commandMap.put("ObjLevel", "6");
					commandMap.put("AttrTypeCode", "AT00001");

					List l5TtlList = commonService.selectList("analysis_SQL.getLevel56Names", commandMap);
					l5Ttl = l5TtlList.size();
				}

				Element cell14 = doc.createElement("cell");
				cell14.appendChild(doc.createTextNode(String.valueOf(l5Ttl)));
				row.appendChild(cell14);
				L5TotalSubTotal = L5TotalSubTotal + l5Ttl;

				// cell: ERP(L5) 엘리먼트
				int l5Erp = 0;
				if (!nextFromIds.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("FromItemID", nextFromIds);
					commandMap.put("LanguageID", languageID);
					commandMap.put("ObjLevel", "6");
					commandMap.put("AttrTypeCode", "AT00037");
					commandMap.put("LovCodeValue", "LV37002");

					List l5ErpList = commonService.selectList("analysis_SQL.getLevel56Names", commandMap);
					l5Erp = l5ErpList.size();
				}
				Element cell15 = doc.createElement("cell");
				cell15.appendChild(doc.createTextNode(String.valueOf(l5Erp)));
				row.appendChild(cell15);
				L5ERPSubTotal = L5ERPSubTotal + l5Erp;

				// cell: Legacy(L5) 엘리먼트
				int l5Legacy = 0;
				if (!nextFromIds.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("FromItemID", nextFromIds);
					commandMap.put("LanguageID", languageID);
					commandMap.put("ObjLevel", "6");
					commandMap.put("AttrTypeCode", "AT00037");
					commandMap.put("LovCodeValue", "LV37005");

					List l5LegacyList = commonService.selectList("analysis_SQL.getLevel56Names", commandMap);
					l5Legacy = l5LegacyList.size();

				}
				Element cell16 = doc.createElement("cell");
				cell16.appendChild(doc.createTextNode(String.valueOf(l5Legacy)));
				row.appendChild(cell16);
				L5LegacySubTotal = L5LegacySubTotal + l5Legacy;

				// cell: Man(L5) 엘리먼트
				int l5Man = 0;
				if (!nextFromIds.isEmpty()) {
					commandMap = new HashMap();
					commandMap.put("FromItemID", nextFromIds);
					commandMap.put("LanguageID", languageID);
					List l5ManList = commonService.selectList("analysis_SQL.getLevel6Man", commandMap);
					l5Man = l5ManList.size();
				}
				Element cell17 = doc.createElement("cell");
				cell17.appendChild(doc.createTextNode(String.valueOf(l5Man)));
				row.appendChild(cell17);
				L5ManSubTotal = L5ManSubTotal + l5Man;

			}

			subTotalValueMap.put("L2Total", L2SubTotal);
			subTotalValueMap.put("L3Total", L3SubTotal);
			subTotalValueMap.put("L4Total", L4SubTotal);
			subTotalValueMap.put("C4TotalTotal", C4TotalSubTotal);
			subTotalValueMap.put("C4ERPTotal", C4ERPSubTotal);
			subTotalValueMap.put("C4LegacyTotal", C4LegacySubTotal);
			subTotalValueMap.put("C4ManTotal", C4ManSubTotal);
			subTotalValueMap.put("V4TotalTotal", V4TotalSubTotal);
			subTotalValueMap.put("V4ERPTotal", V4ERPSubTotal);
			subTotalValueMap.put("V4LegacyTotal", V4LegacySubTotal);
			subTotalValueMap.put("V4ManTotal", V4ManSubTotal);
			subTotalValueMap.put("L5TotalTotal", L5TotalSubTotal);
			subTotalValueMap.put("L5ERPTotal", L5ERPSubTotal);
			subTotalValueMap.put("L5LegacyTotal", L5LegacySubTotal);
			subTotalValueMap.put("L5ManTotal", L5ManSubTotal);
			subTotalValueMap.put("rowId", rowId);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return subTotalValueMap;

	}

	private void optionSelectedItemName(Document doc, Element rootElement, List returnChartList, List displayChartList,
			String nextFromId, String levelName, HashMap returnMap, String languageID) throws ExceptionUtil {
		HashMap commandMap = new HashMap();
		HashMap displayChartMap = new HashMap();
		int rowId = 1;
		try {
			HashMap subTotalValueMap = setRowItemValue(doc, rootElement, nextFromId, levelName, languageID, rowId);
			rowId = Integer.parseInt(subTotalValueMap.get("rowId").toString());
			setRowTotal(subTotalValueMap, doc, rootElement, rowId, "");
			rowId++;
			Map chartJson = setRowRatio(subTotalValueMap, doc, rootElement, rowId, "");
			// TODO
			returnChartList.add(chartJson);
			rowId++;

			displayChartMap.put("LevelName", levelName);
			displayChartList.add(displayChartMap);

			returnMap.put("ChartList", returnChartList);
			returnMap.put("displayChartList", displayChartList);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

	}

	private void optionSelectedAll(Document doc, Element rootElement, List returnData, List returnChartList,
			List displayChartList, HashMap returnMap, String languageID) throws ExceptionUtil {
		HashMap commandMap = new HashMap();
		HashMap totalValueMap = new HashMap();
		int rowId = 1;
		int L2Total = 0;
		int L3Total = 0;
		int L4Total = 0;
		int C4TotalTotal = 0;
		int C4ERPTotal = 0;
		int C4LegacyTotal = 0;
		int C4ManTotal = 0;
		int V4TotalTotal = 0;
		int V4ERPTotal = 0;
		int V4LegacyTotal = 0;
		int V4ManTotal = 0;
		int L5TotalTotal = 0;
		int L5ERPTotal = 0;
		int L5LegacyTotal = 0;
		int L5ManTotal = 0;

		try {
			for (int i = 0; i < returnData.size(); i++) {
				Map level1NameMap = new HashMap();
				level1NameMap = (Map) returnData.get(i);
				String nextFromId = level1NameMap.get("NextFromId").toString();
				String level1Name = level1NameMap.get("LevelName").toString();

				HashMap subTotalValueMap = setRowItemValue(doc, rootElement, nextFromId, level1Name, languageID, rowId);
				rowId = Integer.parseInt(subTotalValueMap.get("rowId").toString());
				setRowTotal(subTotalValueMap, doc, rootElement, rowId, "");
				rowId++;
				Map chartJson = setRowRatio(subTotalValueMap, doc, rootElement, rowId, "");
				// TODO
				returnChartList.add(chartJson);
				rowId++;

				L2Total = L2Total + Integer.parseInt(subTotalValueMap.get("L2Total").toString());
				L3Total = L3Total + Integer.parseInt(subTotalValueMap.get("L3Total").toString());
				L4Total = L4Total + Integer.parseInt(subTotalValueMap.get("L4Total").toString());

				C4TotalTotal = C4TotalTotal + Integer.parseInt(subTotalValueMap.get("C4TotalTotal").toString());
				C4ERPTotal = C4ERPTotal + Integer.parseInt(subTotalValueMap.get("C4ERPTotal").toString());
				C4LegacyTotal = C4LegacyTotal + Integer.parseInt(subTotalValueMap.get("C4LegacyTotal").toString());
				C4ManTotal = C4ManTotal + Integer.parseInt(subTotalValueMap.get("C4ManTotal").toString());

				V4TotalTotal = V4TotalTotal + Integer.parseInt(subTotalValueMap.get("V4TotalTotal").toString());
				V4ERPTotal = V4ERPTotal + Integer.parseInt(subTotalValueMap.get("V4ERPTotal").toString());
				V4LegacyTotal = V4LegacyTotal + Integer.parseInt(subTotalValueMap.get("V4LegacyTotal").toString());
				V4ManTotal = V4ManTotal + Integer.parseInt(subTotalValueMap.get("V4ManTotal").toString());

				L5TotalTotal = L5TotalTotal + Integer.parseInt(subTotalValueMap.get("L5TotalTotal").toString());
				L5ERPTotal = L5ERPTotal + Integer.parseInt(subTotalValueMap.get("L5ERPTotal").toString());
				L5LegacyTotal = L5LegacyTotal + Integer.parseInt(subTotalValueMap.get("L5LegacyTotal").toString());
				L5ManTotal = L5ManTotal + Integer.parseInt(subTotalValueMap.get("L5ManTotal").toString());

			}
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		// TOTAL ROW 값설정, TOTAL Ratio ROW 값설정
		totalValueMap.put("L2Total", L2Total);
		totalValueMap.put("L3Total", L3Total);
		totalValueMap.put("L4Total", L4Total);

		totalValueMap.put("C4TotalTotal", C4TotalTotal);
		totalValueMap.put("C4ERPTotal", C4ERPTotal);
		totalValueMap.put("C4LegacyTotal", C4LegacyTotal);
		totalValueMap.put("C4ManTotal", C4ManTotal);

		totalValueMap.put("V4TotalTotal", V4TotalTotal);
		totalValueMap.put("V4ERPTotal", V4ERPTotal);
		totalValueMap.put("V4LegacyTotal", V4LegacyTotal);
		totalValueMap.put("V4ManTotal", V4ManTotal);

		totalValueMap.put("L5TotalTotal", L5TotalTotal);
		totalValueMap.put("L5ERPTotal", L5ERPTotal);
		totalValueMap.put("L5LegacyTotal", L5LegacyTotal);
		totalValueMap.put("L5ManTotal", L5ManTotal);
		setRowTotal(totalValueMap, doc, rootElement, rowId, "1");
		rowId++;
		setRowRatio(totalValueMap, doc, rootElement, rowId, "1");
		rowId++;

		returnMap.put("ChartList", returnChartList);
		returnMap.put("displayChartList", returnData);

	}

	private String setNextFromIdList(List levelNameList) {
		String nextFromIds = "";
		for (int i = 0; i < levelNameList.size(); i++) {
			Map level3NameMap = new HashMap();
			level3NameMap = (Map) levelNameList.get(i);
			String nextFromId = level3NameMap.get("NextFromId").toString();
			if (i == 0) {
				nextFromIds = nextFromId;
			} else {
				nextFromIds = nextFromIds + "," + nextFromId;
			}
		}

		return nextFromIds;
	}

	private String setIdList(List levelNameList, String keyName) {
		String Ids = "";
		for (int i = 0; i < levelNameList.size(); i++) {
			Map levelMap = new HashMap();
			levelMap = (Map) levelNameList.get(i);
			String Id = levelMap.get(keyName).toString();
			if (i == 0) {
				Ids = Id;
			} else {
				Ids = Ids + "," + Id;
			}
		}

		return Ids;
	}

	private void setRowTotal(Map map, Document doc, Element rootElement, int rowId, String kbn) {
		// row 엘리먼트
		Element row = doc.createElement("row");
		rootElement.appendChild(row);
		row.setAttribute("id", String.valueOf(rowId));

		if (kbn.isEmpty()) {
			// cell: L1 Name 엘리먼트
			Element cell1 = doc.createElement("cell");
			cell1.appendChild(doc.createTextNode(""));
			row.appendChild(cell1);

			// cell: L2 Name 엘리먼트
			Element cell2 = doc.createElement("cell");
			cell2.appendChild(doc.createTextNode("Sub Total"));
			row.appendChild(cell2);
		} else {
			// cell: L1 Name 엘리먼트
			Element cell1 = doc.createElement("cell");
			cell1.appendChild(doc.createTextNode("Total"));
			cell1.setAttribute("colspan", "2");
			row.appendChild(cell1);

			// cell: L2 Name 엘리먼트
			Element cell2 = doc.createElement("cell");
			cell2.appendChild(doc.createTextNode(""));
			row.appendChild(cell2);
		}

		// cell: L2 엘리먼트
		Element cell3 = doc.createElement("cell");
		cell3.appendChild(doc.createTextNode(String.valueOf(map.get("L2Total"))));
		row.appendChild(cell3);

		// cell: L3 엘리먼트
		Element cell4 = doc.createElement("cell");
		cell4.appendChild(doc.createTextNode(String.valueOf(map.get("L3Total"))));
		row.appendChild(cell4);

		// cell: L4 엘리먼트
		Element cell5 = doc.createElement("cell");
		cell5.appendChild(doc.createTextNode(String.valueOf(map.get("L4Total"))));
		row.appendChild(cell5);

		// cell: C4 Total 엘리먼트
		Element cell6 = doc.createElement("cell");
		cell6.appendChild(doc.createTextNode(String.valueOf(map.get("C4TotalTotal"))));
		row.appendChild(cell6);

		// cell: C4 Erp 엘리먼트
		Element cell7 = doc.createElement("cell");
		cell7.appendChild(doc.createTextNode(String.valueOf(map.get("C4ERPTotal"))));
		row.appendChild(cell7);

		// cell: C4 Legacy 엘리먼트
		Element cell8 = doc.createElement("cell");
		cell8.appendChild(doc.createTextNode(String.valueOf(map.get("C4LegacyTotal"))));
		row.appendChild(cell8);

		// cell: C4 Man 엘리먼트
		Element cell9 = doc.createElement("cell");
		cell9.appendChild(doc.createTextNode(String.valueOf(map.get("C4ManTotal"))));
		row.appendChild(cell9);

		// cell: V4 Total 엘리먼트
		Element cell10 = doc.createElement("cell");
		cell10.appendChild(doc.createTextNode(String.valueOf(map.get("V4TotalTotal"))));
		row.appendChild(cell10);

		// cell: V4 Erp 엘리먼트
		Element cell11 = doc.createElement("cell");
		cell11.appendChild(doc.createTextNode(String.valueOf(map.get("V4ERPTotal"))));
		row.appendChild(cell11);

		// cell: V4 Legacy 엘리먼트
		Element cell12 = doc.createElement("cell");
		cell12.appendChild(doc.createTextNode(String.valueOf(map.get("V4LegacyTotal"))));
		row.appendChild(cell12);

		// cell: V4 Man 엘리먼트
		Element cell13 = doc.createElement("cell");
		cell13.appendChild(doc.createTextNode(String.valueOf(map.get("V4ManTotal"))));
		row.appendChild(cell13);

		// cell: Total(L5) 엘리먼트
		Element cell14 = doc.createElement("cell");
		cell14.appendChild(doc.createTextNode(String.valueOf(map.get("L5TotalTotal"))));
		row.appendChild(cell14);

		// cell: ERP(L5) 엘리먼트
		Element cell15 = doc.createElement("cell");
		cell15.appendChild(doc.createTextNode(String.valueOf(map.get("L5ERPTotal"))));
		row.appendChild(cell15);

		// cell: Legacy(L5) 엘리먼트
		Element cell16 = doc.createElement("cell");
		cell16.appendChild(doc.createTextNode(String.valueOf(map.get("L5LegacyTotal"))));
		row.appendChild(cell16);

		// cell: Man(L5) 엘리먼트
		Element cell17 = doc.createElement("cell");
		cell17.appendChild(doc.createTextNode(String.valueOf(map.get("L5ManTotal"))));
		row.appendChild(cell17);
	}

	private Map setRowRatio(Map map, Document doc, Element rootElement, int rowId, String kbn) {

		Map returnMap = new HashMap();
		Map jsonMap = new HashMap();
		List jsonList = new ArrayList();

		// row 엘리먼트
		Element row = doc.createElement("row");
		rootElement.appendChild(row);
		row.setAttribute("id", String.valueOf(rowId));

		if (kbn.isEmpty()) {
			// cell: L1 Name 엘리먼트
			Element cell1 = doc.createElement("cell");
			cell1.appendChild(doc.createTextNode(""));
			row.appendChild(cell1);

			// cell: L2 Name 엘리먼트
			Element cell2 = doc.createElement("cell");
			cell2.appendChild(doc.createTextNode("Ratio"));
			row.appendChild(cell2);
		} else {
			// cell: L1 Name 엘리먼트
			Element cell1 = doc.createElement("cell");
			cell1.appendChild(doc.createTextNode("Total Ratio"));
			cell1.setAttribute("colspan", "2");
			row.appendChild(cell1);

			// cell: L2 Name 엘리먼트
			Element cell2 = doc.createElement("cell");
			cell2.appendChild(doc.createTextNode(""));
			row.appendChild(cell2);
		}

		// cell: L2 엘리먼트
		Element cell3 = doc.createElement("cell");
		cell3.appendChild(doc.createTextNode(""));
		row.appendChild(cell3);

		// cell: L3 엘리먼트
		Element cell4 = doc.createElement("cell");
		cell4.appendChild(doc.createTextNode(""));
		row.appendChild(cell4);

		// cell: L4 엘리먼트
		Element cell5 = doc.createElement("cell");
		cell5.appendChild(doc.createTextNode(""));
		row.appendChild(cell5);

		// cell: C4 Total 엘리먼트
		String c4Ttl = getRatio(new BigDecimal(map.get("C4TotalTotal").toString()),
				new BigDecimal(map.get("C4TotalTotal").toString()));
		Element cell6 = doc.createElement("cell");
		cell6.appendChild(doc.createTextNode(c4Ttl));
		row.appendChild(cell6);

		// cell: C4 ERP 엘리먼트
		String c4Erp = getRatio(new BigDecimal(map.get("C4TotalTotal").toString()),
				new BigDecimal(map.get("C4ERPTotal").toString()));
		Element cell7 = doc.createElement("cell");
		cell7.appendChild(doc.createTextNode(c4Erp));
		row.appendChild(cell7);

		jsonMap = new HashMap();
		jsonMap.put("label", "C4 ERP");
		jsonMap.put("value", c4Erp.replace("%", ""));
		jsonList.add(jsonMap);

		// cell: C4 Legacy 엘리먼트
		String c4Legacy = getRatio(new BigDecimal(map.get("C4TotalTotal").toString()),
				new BigDecimal(map.get("C4LegacyTotal").toString()));
		Element cell8 = doc.createElement("cell");
		cell8.appendChild(doc.createTextNode(c4Legacy));
		row.appendChild(cell8);

		jsonMap = new HashMap();
		jsonMap.put("label", "C4 Legacy");
		jsonMap.put("value", c4Legacy.replace("%", ""));
		jsonList.add(jsonMap);

		// cell: C4 Man 엘리먼트
		String c4Man = getRatio(new BigDecimal(map.get("C4TotalTotal").toString()),
				new BigDecimal(map.get("C4ManTotal").toString()));
		Element cell9 = doc.createElement("cell");
		cell9.appendChild(doc.createTextNode(c4Man));
		row.appendChild(cell9);

		jsonMap = new HashMap();
		jsonMap.put("label", "C4 Man");
		jsonMap.put("value", c4Man.replace("%", ""));
		jsonList.add(jsonMap);

		// cell: V4 Total 엘리먼트
		String v4Ttl = getRatio(new BigDecimal(map.get("V4TotalTotal").toString()),
				new BigDecimal(map.get("V4TotalTotal").toString()));
		Element cell10 = doc.createElement("cell");
		cell10.appendChild(doc.createTextNode(v4Ttl));
		row.appendChild(cell10);

		// cell: V4 ERP 엘리먼트
		String v4Erp = getRatio(new BigDecimal(map.get("V4TotalTotal").toString()),
				new BigDecimal(map.get("V4ERPTotal").toString()));
		Element cell11 = doc.createElement("cell");
		cell11.appendChild(doc.createTextNode(v4Erp));
		row.appendChild(cell11);

		jsonMap = new HashMap();
		jsonMap.put("label", "V4 ERP");
		jsonMap.put("value", v4Erp.replace("%", ""));
		jsonList.add(jsonMap);

		// cell: V4 Legacy 엘리먼트
		String v4Legacy = getRatio(new BigDecimal(map.get("V4TotalTotal").toString()),
				new BigDecimal(map.get("V4LegacyTotal").toString()));
		Element cell12 = doc.createElement("cell");
		cell12.appendChild(doc.createTextNode(v4Legacy));
		row.appendChild(cell12);

		jsonMap = new HashMap();
		jsonMap.put("label", "V4 Legacy");
		jsonMap.put("value", v4Legacy.replace("%", ""));
		jsonList.add(jsonMap);

		// cell: V4 Man 엘리먼트
		String v4Man = getRatio(new BigDecimal(map.get("V4TotalTotal").toString()),
				new BigDecimal(map.get("V4ManTotal").toString()));
		Element cell13 = doc.createElement("cell");
		cell13.appendChild(doc.createTextNode(v4Man));
		row.appendChild(cell13);

		jsonMap = new HashMap();
		jsonMap.put("label", "V4 Man");
		jsonMap.put("value", v4Man.replace("%", ""));
		jsonList.add(jsonMap);

		// cell: Total(L5) 엘리먼트
		String l5Ttl = getRatio(new BigDecimal(map.get("L5TotalTotal").toString()),
				new BigDecimal(map.get("L5TotalTotal").toString()));
		Element cell14 = doc.createElement("cell");
		cell14.appendChild(doc.createTextNode(l5Ttl));
		row.appendChild(cell14);

		// cell: ERP(L5) 엘리먼트
		String l5Erp = getRatio(new BigDecimal(map.get("L5TotalTotal").toString()),
				new BigDecimal(map.get("L5ERPTotal").toString()));
		Element cell15 = doc.createElement("cell");
		cell15.appendChild(doc.createTextNode(l5Erp));
		row.appendChild(cell15);

		jsonMap = new HashMap();
		jsonMap.put("label", "L5 ERP");
		jsonMap.put("value", l5Erp.replace("%", ""));
		jsonList.add(jsonMap);

		// cell: Legacy(L5) 엘리먼트
		String l5Legacy = getRatio(new BigDecimal(map.get("L5TotalTotal").toString()),
				new BigDecimal(map.get("L5LegacyTotal").toString()));
		Element cell16 = doc.createElement("cell");
		cell16.appendChild(doc.createTextNode(l5Legacy));
		row.appendChild(cell16);

		jsonMap = new HashMap();
		jsonMap.put("label", "L5 Legacy");
		jsonMap.put("value", l5Legacy.replace("%", ""));
		jsonList.add(jsonMap);

		// cell: Man(L5) 엘리먼트
		String l5Man = getRatio(new BigDecimal(map.get("L5TotalTotal").toString()),
				new BigDecimal(map.get("L5ManTotal").toString()));
		Element cell17 = doc.createElement("cell");
		cell17.appendChild(doc.createTextNode(l5Man));
		row.appendChild(cell17);

		jsonMap = new HashMap();
		jsonMap.put("label", "L5 Man");
		jsonMap.put("value", l5Man.replace("%", ""));
		jsonList.add(jsonMap);

		String[] cols = { "label", "value" };
		returnMap.put("jsonData", JsonUtil.parseJson(jsonList, cols, "/dev_xbolt"));
		return returnMap;

	}

	private String getRatio(BigDecimal levelTotalNum, BigDecimal subTotalNum) {
		if (levelTotalNum.compareTo(BigDecimal.ZERO) == 0 || subTotalNum.compareTo(BigDecimal.ZERO) == 0) {
			return "0%";
		}
		BigDecimal resultRatio = (subTotalNum.divide(levelTotalNum, MathContext.DECIMAL32))
				.multiply(new BigDecimal(100)).setScale(0, RoundingMode.HALF_UP);
		return resultRatio.toString() + "%";
	}

	private String getMinusResult(String x, String y) {
		int result = 0;
		result = Integer.parseInt(x) - Integer.parseInt(y);

		return String.valueOf(result);
	}

	/**
	 * [PI운영-->Report-->SR 처리현황 통계]
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/srStatistics.do")
	public String srStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		Map setMap = new HashMap();
		List projectList = new ArrayList();
		try {
			String filepath = request.getSession().getServletContext().getRealPath("/");
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

			Map menuMap = getLabel(request, commonService);
			String header1 = "";
			String header2 = "";
			String cspan = ",#cspan";
			String comma = ",";
			int colCnt = 0;

			/* xml 파일명 설정 */
			String xmlFilName = "upload/srStatistics.xml";
			/* xml 파일 존재 할 경우 삭제 */
			// File oldFile = new File(filepath + xmlFilName);
			// if (oldFile.exists()) {
			// oldFile.delete();
			// }

			/* 등록일 설정 FromDate:시스템 날짜에서 최근 일년, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.MONTH, -6);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			String scStartDt = StringUtil.checkNull(request.getParameter("SC_STR_DT"), beforeYmd);
			String scEndDt = StringUtil.checkNull(request.getParameter("SC_END_DT"), thisYmd);

//	        System.out.println("##### scStartDt : "+scStartDt);
//	        System.out.println("##### scEndDt : "+scEndDt);

			// 첫번째 Header : Status
			commandMap.put("languageID", languageID);
			commandMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ITSP"));
			commandMap.put("itemClassCode", "CL03004");
			List srStatList = commonService.selectList("esm_SQL.getSRStatusList", commandMap);
			for (int i = 0; i < srStatList.size(); i++) {
				Map map = (Map) srStatList.get(i);
				if (i == 0) {
					header1 = (String) map.get("NAME");
				} else {
					header1 = header1 + comma + map.get("NAME");
				}
				colCnt++;
			}

			// 첫번째 열 : 상위 SR 카테고리
			// 두번째 열 : 하위 SR 카테고리
			setMap.put("level", "1");
			setMap.put("languageID", languageID);
			setMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ITSP"));

			List srCatListLv1 = commonService.selectList("esm_SQL.getESMSRCategory", setMap);

			// grid에 표시 할 xml file 생성
//			if (isMainMenu.isEmpty()) {
//				setSrStatisticsData(filepath, srStatList, srCatListLv1, xmlFilName, request, languageID, scStartDt,
//						scEndDt);
//			}

			// 계층
			setMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ITSP"));
			setMap.put("userID", commandMap.get("sessionUserID"));

			System.out.println("###### reqTeamList Set ");
			List reqTeamList = commonService.selectList("esm_SQL.getESMSRReqTeamID", setMap);
			List receiptTeamList = commonService.selectList("esm_SQL.getESMSRReceiptTeamID", setMap);
			List srArea1List = commonService.selectList("common_SQL.getSrArea1_commonSelect", setMap);
			
			// setSrStatisticsData 호출하여 XML 데이터 문자열 받기
	        String xmlDataString = setSrStatisticsData(filepath, srStatList, srCatListLv1, xmlFilName, request, languageID, scStartDt, scEndDt);

			JSONArray headerListJson = new JSONArray();
			for (int i = 0; i < srStatList.size(); i++) {
			    Map srStatMap = (Map) srStatList.get(i);
			    Map<String, Object> hearderNames = new HashMap<String, Object>();	
			    hearderNames.put("code", srStatMap.get("CODE"));
			    hearderNames.put("name", srStatMap.get("NAME"));
			    headerListJson.put(hearderNames);
			}

			System.out.println("###### Model put ");
			model.put("headerListJson", headerListJson); 
 			model.put("xmlData", xmlDataString); // XML data
			model.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ITSP"));
			model.put("xmlFilName", xmlFilName);
			model.put("header1", header1);
//	        model.put("header2", header2);
			model.put("beforeYmd", scStartDt);
			model.put("thisYmd", scEndDt);
			model.put("srArea1List", srArea1List);
			model.put("reqTeamList", reqTeamList);
			model.put("receiptTeamList", receiptTeamList);
			model.put("menu", getLabel(request, commonService));
			model.put("colCnt", colCnt + 3); // Status + total+ Category1,2
			model.put("isMainMenu", isMainMenu);
			model.put("srArea1Code", StringUtil.checkNull(request.getParameter("srArea1")));
			model.put("srArea2Code", StringUtil.checkNull(request.getParameter("srArea2")));
			model.put("reqTeamCode", StringUtil.checkNull(request.getParameter("reqTeam")));
			model.put("receiptTeamCode", StringUtil.checkNull(request.getParameter("receiptTeam")));
			model.put("SC_STR_DT", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
			model.put("SC_END_DT", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));
			model.put("refPGID", StringUtil.checkNull(request.getParameter("refPGID")));
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/aly/srStatistics");
	}

	private String setSrStatisticsData(String filepath, List srStatList, List srCatListLv1, String xmlFilName,
			HttpServletRequest request, String languageID, String scStartDt, String scEndDt) throws ExceptionUtil {
		HashMap commandMap = new HashMap();
		List countList = new ArrayList();
		/* 화면에서 선택된 검색 조건을 설정 */
		commandMap.put("languageID", languageID);
		commandMap.put("scStartDt", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
		commandMap.put("scEndDt", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));
		commandMap.put("srArea1", StringUtil.checkNull(request.getParameter("srArea1")));
		commandMap.put("srArea2", StringUtil.checkNull(request.getParameter("srArea2")));
		commandMap.put("reqTeam", StringUtil.checkNull(request.getParameter("reqTeam")));
		commandMap.put("receiptTeam", StringUtil.checkNull(request.getParameter("receiptTeam")));
		commandMap.put("refPGID", StringUtil.checkNull(request.getParameter("refPGID")));

//        // [기간기준] 선택에 따라 검색 조건이 달라짐 
//        commandMap.put("scStartDt", scStartDt);
//        commandMap.put("scEndDt", scEndDt);
		try {
			/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
			List<Map<String, String>> countResultList = new ArrayList<Map<String, String>>();
			Map<String, Integer> countMap = new HashMap<String, Integer>();
			String srCntTtl = "";
			String srCnt = "";
			String cngStsCnt = "";
			// SR Category > Staus
			// SR Category lv1 Row
			for (int i = 0; i < srCatListLv1.size(); i++) {
				HashMap setMap = new HashMap();
				Map maplv1 = (Map) srCatListLv1.get(i);
				String srCatLv1_CD = String.valueOf(maplv1.get("CODE"));
				String srCatLv1_NM = String.valueOf(maplv1.get("NAME"));
				commandMap.remove("parentID");
				commandMap.put("parentID", maplv1.get("CODE"));
				commandMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ITSP"));

				// SR Category lv2 Row
				List srCatListLv2 = commonService.selectList("esm_SQL.getESMSRCategory", commandMap);
				for (int j = 0; j < srCatListLv2.size(); j++) {
					Map<String, String> rowMap = new HashMap<String, String>();
					Map maplv2 = (Map) srCatListLv2.get(j);
					String srCatLv2_CD = String.valueOf(maplv2.get("CODE"));
					String srCatLv2_NM = String.valueOf(maplv2.get("NAME"));

					commandMap.remove("status");
					commandMap.remove("srCatID");
					commandMap.put("srCatID", srCatLv2_CD);
					// System.out.println("###### 1. SR Status Total ");
					srCntTtl = commonService.selectString("analysis_SQL.getCountOfSR", commandMap); // [Sub
																									// Category/Status]
																									// total
					// row add
					// System.out.println("###### 1. SR Status Total lv2 num :
					// "+Integer.toString(j));
					// System.out.println("###### 1. SR Status Total lv2 srCatLv1_NM :
					// "+srCatLv1_NM);
					// System.out.println("###### 1. SR Status Total lv2 srCatLv2_NM :
					// "+srCatLv2_NM);
					rowMap.put("num", Integer.toString(j));
					rowMap.put("rspan", Integer.toString(srCatListLv2.size() + 2));
					rowMap.put("srCatLv1_NM", srCatLv1_NM); // col1 : SR Category Name
					rowMap.put("srCatLv2_NM", srCatLv2_NM); // col2 : SR Sub Category Name
					rowMap.put("statusCnt", srCntTtl); // col9 : Total by Sub Category

					// SR Status Column add
					for (int k = 0; k < srStatList.size(); k++) {
						Map satusMap = (Map) srStatList.get(k);
						String statusId = String.valueOf(satusMap.get("CODE"));

						commandMap.remove("status");
						commandMap.put("status", statusId);
						// System.out.println("###### 2. SR Status Column add ");
						srCnt = commonService.selectString("analysis_SQL.getCountOfSR", commandMap);
						rowMap.put(statusId, srCnt); // col3 ~ col8 : value by Status
					}
					countResultList.add(rowMap);
				}

				// SubCategory Not Allocation row add start
				Map<String, String> rowMap = new HashMap<String, String>();
				commandMap.remove("status");
				commandMap.remove("srCatID");
				commandMap.remove("parentID");
				commandMap.put("parentID", srCatLv1_CD);
				commandMap.put("subCatNA", "NA");
				// System.out.println("###### 3. SR Status SubTotal ");
				srCntTtl = commonService.selectString("analysis_SQL.getCountOfSR", commandMap); // [Category/Status]
																								// total

				// Column add
				rowMap.put("srCatLv1_NM", srCatLv1_NM); // col1 : SR Category Name
				rowMap.put("srCatLv2_NM", "N/A"); // col1 : SR Sub Category Name
				rowMap.put("statusCnt", srCntTtl); // col9 : Total by Sub Category

				// SR Status Column add
				for (int k = 0; k < srStatList.size(); k++) {
					Map satusMap = (Map) srStatList.get(k);
					String statusId = String.valueOf(satusMap.get("CODE"));

					commandMap.remove("status");
					commandMap.put("status", statusId);
					// System.out.println("###### 4. SR Status SubTotal Total ");
					srCnt = commonService.selectString("analysis_SQL.getCountOfSR", commandMap);
					rowMap.put(statusId, srCnt); // col3 ~ col8 : value by Status
				}
				countResultList.add(rowMap);

				// SubTotal row add start
				rowMap = new HashMap<String, String>();
				commandMap.remove("status");
				commandMap.remove("srCatID");
				commandMap.remove("parentID");
				commandMap.remove("subCatNA");
				commandMap.put("parentID", srCatLv1_CD);
				// System.out.println("###### 3. SR Status SubTotal ");
				srCntTtl = commonService.selectString("analysis_SQL.getCountOfSR", commandMap); // [Category/Status]
																								// total
				// Column add
				rowMap.put("srCatLv1_NM", srCatLv1_NM); // col1 : SR Category Name
				rowMap.put("srCatLv2_NM", "Sub Total"); // col1 : SR Sub Category Name
				rowMap.put("statusCnt", srCntTtl); // col9 : Total by Sub Category

				// SR Status Column add
				for (int k = 0; k < srStatList.size(); k++) {
					Map satusMap = (Map) srStatList.get(k);
					String statusId = String.valueOf(satusMap.get("CODE"));

					commandMap.remove("status");
					commandMap.put("status", statusId);
					// System.out.println("###### 4. SR Status SubTotal Total ");
					srCnt = commonService.selectString("analysis_SQL.getCountOfSR", commandMap);
					rowMap.put(statusId, srCnt); // col3 ~ col8 : value by Status
				}
				countResultList.add(rowMap);
			}

			// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
			// 통계 리스트 표시 할 xml 파일 생성
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);

			int rowId = 1;
			for (int i = 0; i < countResultList.size(); i++) {
				// System.out.println("###### 5. countResultList : "+ i);
				// row 엘리먼트
				Element row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;

				Map<String, String> countRowMap = countResultList.get(i);
				// col 1
				Element cell = doc.createElement("cell");

				if (countRowMap.get("num") != null && countRowMap.get("num").equals("0")) {
					cell.appendChild(doc.createTextNode(countRowMap.get("srCatLv1_NM")));
					cell.setAttribute("rowspan", countRowMap.get("rspan"));
				} else {
					cell.appendChild(doc.createTextNode(""));
				}
//				cell.setAttribute("style", "background-color:#f2f2f2; text-align:left;font-weight:bold;");
				row.appendChild(cell);

				// col 2
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(countRowMap.get("srCatLv2_NM")));
//				cell.setAttribute("style", "background-color:#f2f2f2; text-align:left;font-weight:bold;");
				row.appendChild(cell);

				// col 3 ~ 8 (status)
				for (int j = 0; j < srStatList.size(); j++) {
					Map cngTMap = (Map) srStatList.get(j);
					String status = String.valueOf(cngTMap.get("CODE"));

					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(countRowMap.get(status)));
//					if (countRowMap.get("srCatLv2_NM").equals("Sub Total")) {
//						cell.setAttribute("style", "background-color:#f2f2f2;text-align:right;font-weight:bold;");
//					} else {
//						cell.setAttribute("style", "text-align:right;");
//					}
					row.appendChild(cell);
				}

				// Total by Sub Category
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(countRowMap.get("statusCnt")));
				// if(countRowMap.get("srCatLv2_NM").equals("Sub Toal")){
//				cell.setAttribute("style", "background-color:#f2f2f2;text-align:right;font-weight:bold;");
				// }else{
				// cell.setAttribute("style",
				// "background-color:#f2f2f2;text-align:center;font-weight:bold;");
				// }
				row.appendChild(cell);
			}

			// TOTAL 행에 표시될 값 설정
			Map setMap = new HashMap();
			String ttl = "";
			String cngtTtl = "";
			String cngStsTtl = "";

			/* 화면에서 선택된 검색 조건을 설정 */
			setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), languageID));
			setMap.put("scStartDt", StringUtil.checkNull(request.getParameter("SC_STR_DT"), scStartDt));
			setMap.put("scEndDt", StringUtil.checkNull(request.getParameter("SC_END_DT"), scEndDt));
			setMap.put("srArea1", StringUtil.checkNull(request.getParameter("srArea1")));
			setMap.put("srArea2", StringUtil.checkNull(request.getParameter("srArea2")));
			setMap.put("reqTeam", StringUtil.checkNull(request.getParameter("reqTeam")));
			setMap.put("receiptTeam", StringUtil.checkNull(request.getParameter("receiptTeam")));
			setMap.put("refPGID", StringUtil.checkNull(request.getParameter("refPGID")));

			// Total row
			Element row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));

			Element cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("Total"));
			cell.setAttribute("colspan", "2");
//			cell.setAttribute("style", "background-color:#f2f2f2;text-align:center;font-weight:bold;");
			row.appendChild(cell);

			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			// Total by Status
			// System.out.println("###### 6. Total by Category");
			for (int i = 0; i < srStatList.size(); i++) {
				Map statusMap = (Map) srStatList.get(i);
				String statusCode = String.valueOf(statusMap.get("CODE"));

				setMap.put("status", statusCode);
				// System.out.println("###### 6. Total by Category "+i +" : "+ statusCode);
				cngtTtl = commonService.selectString("analysis_SQL.getCountOfSR", setMap);
				cell = doc.createElement("cell");
//				cell.setAttribute("style", "background-color:#f2f2f2;text-align:right;font-weight:bold;");
				cell.appendChild(doc.createTextNode(cngtTtl));
				row.appendChild(cell);
			}

			// Grand Total(Cell)
			// System.out.println("###### 7. Total by Category Grand Total ");
			setMap.remove("status");
			setMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ITSP"));
			ttl = commonService.selectString("analysis_SQL.getCountOfSR", setMap);

			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(ttl));
//			cell.setAttribute("style", "background-color:#f2f2f2;text-align:right;font-weight:bold;");
			row.appendChild(cell);

			// System.out.println("###### 8.XML ");
			//  XML 데이터를 StringWriter에 기록
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);

	        StringWriter writer = new StringWriter();
	        transformer.transform(source, new StreamResult(writer));
	        String xmlDataString = writer.toString();
	        
	        return xmlDataString;

		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		// System.out.println("###### 8.XML 3 result : "+source+"\n result: "+result);
	}

	@RequestMapping(value = "/srMonitoring.do")
	public String srList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws ExceptionUtil {
		String url = "/aly/srMonitorList";
		try {
//				Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),
					request.getParameter("languageID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"), "ITSP");
			String srMode = StringUtil.checkNull(request.getParameter("srMode"));

			String filepath = request.getSession().getServletContext().getRealPath("/");
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));
//				Map menuMap = getLabel(request, commonService);
			String cspan = ",#cspan";
			String comma = ",";
			int colCnt = 0;

			/* xml 파일명 설정 */
//			String xmlFilName = "upload/srMonitoring.xml";
			/* xml 파일 존재 할 경우 삭제 */
			// File oldFile = new File(filepath + xmlFilName);
			// if (oldFile.exists()) {
			// oldFile.delete();
			// }

			/* 등록일 설정 FromDate:시스템 날짜에서 최근 일년, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.MONTH, -1);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			String scStartDt = StringUtil.checkNull(request.getParameter("regStartDate"), beforeYmd);
			String scEndDt = StringUtil.checkNull(request.getParameter("regEndDate"), thisYmd);

			// grid에 표시 할 xml file 생성
			if (isMainMenu.isEmpty()) {
				/* 화면에서 선택된 검색 조건을 설정 */
//				cmmMap.put("languageID", languageID);
//				cmmMap.put("srType", StringUtil.checkNull(cmmMap.get("srType"), "ITSP"));
//				cmmMap.put("regStartDate", scStartDt);
//				cmmMap.put("regEndDate", scEndDt);
//				List srList = commonService.selectList("esm_SQL.getEsrMSTList_gridList", cmmMap);

//				model.put("srCnt", srList.size());
//				setSrMonitoringData(filepath, xmlFilName, srList);
			}

			if (srMode.equals("mySr")) {
				model.put("requstUser", cmmMap.get("sessionUserNm"));
			}
			model.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));

			model.put("beforeYmd", scStartDt);
			model.put("thisYmd", scEndDt);

			model.put("regStartDate", StringUtil.checkNull(request.getParameter("regStartDate"), scStartDt));
			model.put("regEndDate", StringUtil.checkNull(request.getParameter("regEndDate"), scEndDt));
			model.put("stSRDueDate", StringUtil.checkNull(request.getParameter("stSRDueDate")));
			model.put("endSRDueDate", StringUtil.checkNull(request.getParameter("endSRDueDate")));
			model.put("completionDT", StringUtil.checkNull(request.getParameter("completionDT")));
			model.put("srArea1", StringUtil.checkNull(request.getParameter("srArea1")));
			model.put("srArea2", StringUtil.checkNull(request.getParameter("srArea2")));
			model.put("category", StringUtil.checkNull(request.getParameter("category")));
			model.put("subCategory", StringUtil.checkNull(request.getParameter("subCategory")));
			model.put("requestTeam", StringUtil.checkNull(request.getParameter("requestTeam")));
			model.put("srReceiptTeam", StringUtil.checkNull(request.getParameter("srReceiptTeam")));
			model.put("receiptDelay", StringUtil.checkNull(request.getParameter("receiptDelay")));
			model.put("completionDelay", StringUtil.checkNull(request.getParameter("completionDelay")));
			model.put("srStatus", StringUtil.checkNull(request.getParameter("srStatus")));
			model.put("regUserName", StringUtil.checkNull(request.getParameter("regUserName")));
			model.put("receiptName", StringUtil.checkNull(request.getParameter("receiptName")));
			model.put("requestUserName", StringUtil.checkNull(request.getParameter("requestUserName")));

//			model.put("xmlFilName", xmlFilName);
			model.put("srMode", srMode);
			model.put("srType", srType);
			model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	private void setSrMonitoringData(String filepath, String xmlFilName, List srList) throws ExceptionUtil {
		// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
		// 통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);
			// SR List
			List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();

			for (int i = 0; i < srList.size(); i++) {
				Map map = (Map) srList.get(i);
				String receiptDelay = (String) map.get("ReceiptDelay");
				String completionDelay = (String) map.get("CompletionDelay");
				String strCol = "RNUM:SRCode:Subject:StatusName:ReqTeamNM:SRArea1Name:SRArea2Name:SRDueDate:CRDueDate:SRCompletionDT:CRCompletionDT:ReceiptInfo:SRID:ReceiptUserID:Status:ReceiptDelay:CompletionDelay:SRType";
				String colList[] = strCol.split(":");

				Element row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(i + 1));

				// col
				Element cell;
				// System.out.println("###### 2. colList size : "+colList.length);
				for (int j = 0; j < colList.length; j++) {
					String colName = colList[j];
					cell = doc.createElement("cell");
					// System.out.println("###### 3. col map : "+colName+" = "+map.get(colName));
					cell.appendChild(doc.createTextNode(map.get(colName).toString()));
					if (receiptDelay.equals("Y")) {
						cell.setAttribute("style", "font-weight:bold;background-color:#FCDCDC; ");

					} else if (completionDelay.equals("Y")) {
						cell.setAttribute("style", "font-weight:bold;background-color:#CFE4FC; ");

					} else {
//		        		cell.setAttribute("style","text-align:left;");

					}
					row.appendChild(cell);
				}

			}
			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);

			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

	}

	@RequestMapping(value = "/mainSRStatistics.do")
	public String mainSRStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {

		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(String.valueOf(commandMap.get("sessionCurrLangType")));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			String srType = StringUtil.checkNull(String.valueOf(commandMap.get("srType"))); 
//			String srType = "ITSP"; // test용
			/* xml 파일명 설정 */
			String xmlFilName = "upload/mainSRStatistics.xml";
			String header = "상태/영역";

			setMap.put("languageID", languageID);
			setMap.put("srType", srType);
			setMap.put("category", "SRSTS");

			// get SR Status NameList (grid header표시용)
			List getSRStatList = commonService.selectList("analysis_SQL.getSRStatList", setMap);
			// get SR SRArea1 Name List
			List getSRArea1List = commonService.selectList("analysis_SQL.getSRArea1List", setMap);
			setMainSRStatisticsData(filepath, getSRStatList, getSRArea1List, xmlFilName, setMap);

			for (int i = 0; i < getSRStatList.size(); i++) { 
				Map srStatNameMap = (Map) getSRStatList.get(i);
				String srStatName = StringUtil.checkNull(srStatNameMap.get("SRStatusName"));
				header = header + "," + srStatName;
			}

			// setSrStatisticsData 호출하여 XML 데이터 문자열 받기
	        String xmlDataString = setMainSRStatisticsData(filepath, getSRStatList, getSRArea1List, xmlFilName, setMap);
						
			model.put("xmlData", xmlDataString); // XML data
			model.put("srStsCnt", getSRStatList.size()); // SR 상태 Count
			model.put("header", header + ",Total"); 
			model.put("xmlFilName", xmlFilName);
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/hom/main/sr/mainSRStatistics");
	}

	private String setMainSRStatisticsData(String filepath, List getSRStatList, List getSRArea1List, String xmlFilName,
			Map setMap) throws ExceptionUtil {
		Map srCntMap = new HashMap();
		List<Map<String, String>> srArea1CNTResultList = new ArrayList<Map<String, String>>();
		try {
			for (int i = 0; i < getSRArea1List.size(); i++) {
				Map<String, String> rowMap = new HashMap<String, String>();
				Map srArea1Map = (Map) getSRArea1List.get(i);

				String rNum = String.valueOf(srArea1Map.get("RNUM"));
				String SRArea1Code = String.valueOf(srArea1Map.get("SRArea1Code"));
				String SRArea1Name = String.valueOf(srArea1Map.get("SRArea1Name"));

				rowMap.put("rNum", rNum);
				rowMap.put("SRArea1Name", SRArea1Name);

				setMap.put("srArea1Code", SRArea1Code);
				srCntMap = commonService.select("analysis_SQL.getSRCNTList", setMap);

				rowMap.put("RCVCNT", String.valueOf(srCntMap.get("RCVCNT")));
				rowMap.put("CSRCNT", String.valueOf(srCntMap.get("CSRCNT")));
				rowMap.put("CNGCNT", String.valueOf(srCntMap.get("CNGCNT")));
				rowMap.put("CMPCNT", String.valueOf(srCntMap.get("CMPCNT")));
				rowMap.put("CLSCNT", String.valueOf(srCntMap.get("CLSCNT")));
				rowMap.put("REQCNT", String.valueOf(srCntMap.get("REQCNT")));
				rowMap.put("TotalCNT", String.valueOf(srCntMap.get("TotalCNT")));
				srArea1CNTResultList.add(rowMap);
			}

			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);
			int rowId = 1;
			for (int i = 0; i < srArea1CNTResultList.size(); i++) {
				Map<String, String> srRowMap = srArea1CNTResultList.get(i);

				// row 엘리먼트
				Element row = doc.createElement("row");
				rootElement.appendChild(row);
				row.setAttribute("id", String.valueOf(rowId));
				rowId++;

				Element cell = doc.createElement("cell");
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(StringUtil.checkNull(srRowMap.get("SRArea1Name"))));
				cell.setAttribute("style", "text-align:center;");
				row.appendChild(cell);

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(srRowMap.get("REQCNT")));
				cell.setAttribute("style", "text-align:right;");
				row.appendChild(cell);

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(srRowMap.get("RCVCNT")));
				cell.setAttribute("style", "text-align:right;");
				row.appendChild(cell);

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(srRowMap.get("CSRCNT")));
				cell.setAttribute("style", "text-align:right;");
				row.appendChild(cell);

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(srRowMap.get("CNGCNT")));
				cell.setAttribute("style", "text-align:right;");
				row.appendChild(cell);

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(srRowMap.get("CMPCNT")));
				cell.setAttribute("style", "text-align:right;");
				row.appendChild(cell);

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(srRowMap.get("CLSCNT")));
				cell.setAttribute("style", "text-align:right;");
				row.appendChild(cell);

				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(srRowMap.get("TotalCNT")));
				cell.setAttribute("style", "text-align:right;");
				row.appendChild(cell);

			}

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);

			StringWriter writer = new StringWriter();
	        transformer.transform(source, new StreamResult(writer));
	        String xmlDataString = writer.toString();
	        
	        return xmlDataString;
	        
//			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
//			transformer.transform(source, result);
	        
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

	}

	/**
	 * Process 통계 (2016/08/20) TB_SR_MST 테이블의 데이터 이용
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/srDashboard.do")
	public String srDashboard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws ExceptionUtil {
		String url = "/aly/srDashboard";
		try {
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),
					request.getParameter("languageID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"), "ITSP");
			model.put("srType", srType);
			model.put("menu", getLabel(request, commonService)); // Label Setting

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	/**
	 * Process 통계 (2016/08/20) TB_SR_MST 테이블의 데이터 이용
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/srDashboardList.do")
	public String srDashboardList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws ExceptionUtil {
		String url = "/aly/srDashboardList";
		try {
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),
					request.getParameter("languageID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"), "ITSP");
			String srMode = StringUtil.checkNull(request.getParameter("srMode"));

			String filepath = request.getSession().getServletContext().getRealPath("/");
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));
//			Map menuMap = getLabel(request, commonService);
			String cspan = ",#cspan";
			String comma = ",";
			int colCnt = 0;

			// xml 파일명 설정
			String xmlFilName = "upload/srMonitoring.xml";

			// 등록일 설정 FromDate:시스템 날짜에서 최근 일년, ToDate:시스템 날짜
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.MONTH, -1);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			String scStartDt = StringUtil.checkNull(cmmMap.get("regStartDate"), "");
			String scEndDt = StringUtil.checkNull(cmmMap.get("regEndDate"), "");
			String srDueStartDt = StringUtil.checkNull(cmmMap.get("srDueStartDate"), "");
			String srDueEndDt = StringUtil.checkNull(cmmMap.get("srDueEndDate"), "");
			String crDueStartDt = StringUtil.checkNull(cmmMap.get("crDueStartDate"), "");
			String crDueEndDt = StringUtil.checkNull(cmmMap.get("crDueEndDate"), "");

			// grid에 표시 할 xml file 생성
			if (isMainMenu.isEmpty()) {
				// setSrMonitoringData(filepath, xmlFilName, request, languageID, scStartDt,
				// scEndDt);
				cmmMap.put("languageID", languageID);
				cmmMap.put("srType", StringUtil.checkNull(cmmMap.get("srType"), "ITSP"));
				cmmMap.put("regStartDate", scStartDt);
				cmmMap.put("regEndDate", scEndDt);
				cmmMap.put("stSRDueDate", srDueStartDt);
				cmmMap.put("endSRDueDate", srDueEndDt);
				cmmMap.put("stCRDueDate", crDueStartDt);
				cmmMap.put("endCRDueDate", crDueEndDt);
				List srList = commonService.selectList("esm_SQL.getEsrMSTList_gridList", cmmMap);
				model.put("srCnt", srList.size());
				setSrMonitoringData(filepath, xmlFilName, srList);
			}

			model.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
			model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
			model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
			model.put("xmlFilName", xmlFilName);
			model.put("srMode", srMode);
			model.put("srType", srType);
			model.put("regStartDate", scStartDt);
			model.put("regEndDate", scEndDt);
			model.put("stSRDueDate", srDueStartDt);
			model.put("endSRDueDate", srDueEndDt);
			model.put("stCRDueDate", crDueStartDt);
			model.put("endCRDueDate", crDueEndDt);

			model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum")));
			model.put("menu", getLabel(request, commonService)); // Label Setting

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/mainSttProcess.do")
	public String mainSttChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			List classList = (List) commonService.selectList("main_SQL.processStt_sum", cmmMap);
			String classCL4 = "0";
			String classCL5 = "0";
			String classCL6 = "0";
			if (classList.size() > 0) {
				for (int i = 0; i < classList.size(); i++) {
					HashMap classCnt = (HashMap) classList.get(i);
					if ("CL01004".equals(StringUtil.checkNull(classCnt.get("ItemClassCode")))) {
						classCL4 = StringUtil.getFormat(StringUtil.checkNull(classCnt.get("value"), "0"), "");
					}
					if ("CL01005".equals(StringUtil.checkNull(classCnt.get("ItemClassCode")))) {
						classCL5 = StringUtil.getFormat(StringUtil.checkNull(classCnt.get("value"), "0"), "");
					}
					if ("CL01006".equals(StringUtil.checkNull(classCnt.get("ItemClassCode")))) {
						classCL6 = StringUtil.getFormat(StringUtil.checkNull(classCnt.get("value"), "0"), "");
					}
				}
			}
			model.put("classCL4", classCL4);
			model.put("classCL5", classCL5);
			model.put("classCL6", classCL6);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/hom/main/stts/mainSttProcess");
	}

	@RequestMapping(value = "/itemRevisionStatisticsByYear.do")
	public String itemRevisionStatisticsByYear(HttpServletRequest request, ModelMap model, HashMap cmmMap) throws ExceptionUtil {
		try {
			model.put("menu", getLabel(request, commonService));
			Map<String, Object> setMap = new HashMap<String, Object>();

			Map rowMap = new HashMap();
			List allCountList = new ArrayList();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy");
			long curTime = System.currentTimeMillis();

			int curYear = Integer.parseInt(formatter.format(curTime));
			int minYear = Integer.parseInt(commonService.selectString("report_SQL.getMinYearByCHANGESET", setMap));

			int fromYear = Integer.parseInt(StringUtil.checkNull(request.getParameter("fromYear"), "0"));
			int toYear = Integer.parseInt(StringUtil.checkNull(request.getParameter("toYear"), "0"));

			if (fromYear == 0 && toYear == 0) {
				toYear = curYear;
				fromYear = toYear - 9;
			} else if (fromYear == 0 && toYear != 0) {
				fromYear = minYear;
			}

			List quarterList = new ArrayList();
			for (int i = 1; i < 5; i++) {
				rowMap = new HashMap();
				rowMap.put("quarter", "Q" + i);
				quarterList.add(rowMap);
			}

			List dateList = new ArrayList();
			for (int i = toYear; fromYear <= i; i--) {
				dateList.add(i);
			}

			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCodeList"), "");
			String[] itemTypeCodeList = itemTypeCode.split(",");
			setMap.put("itemTypeCodeList", itemTypeCodeList);
			for (int i = 0; i < dateList.size(); i++) {
				rowMap = new HashMap();
				setMap.put("Date", dateList.get(i));
				List companyStandardRevisionCntList = commonService.selectList("report_SQL.getItemRevisionStatisticsByYearCount", setMap);
				Map companyStandardRevisionCntMap = getCountMap(companyStandardRevisionCntList);

				rowMap.put("Date", dateList.get(i));
				rowMap.put("CNT", NumberUtil.getIntValue(companyStandardRevisionCntMap.get("CNT")));

				for (int j = 0; quarterList.size() > j; j++) {
					Map quarterMap = (Map) quarterList.get(j);
					String compareName = (String) quarterMap.get("quarter");

					if (companyStandardRevisionCntMap.containsKey(compareName)) {
						rowMap.put(compareName, companyStandardRevisionCntMap.get(compareName));
					} else {
						rowMap.put(compareName, "0");
					}
				}
				allCountList.add(rowMap);
			}
			
			JSONArray gridData = new JSONArray(allCountList);
			model.put("itemRevisionByYearList", gridData);
			
			model.put("fromYear", fromYear);
			model.put("toYear", toYear);
			model.put("minYear", minYear);
			model.put("curYear", curYear);
			model.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
			
			setMap.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			model.put("itemTypeCodeList", itemTypeCode);
			model.put("title", commonService.selectString("report_SQL.getReportName", setMap));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/report/itemRevisionStatisticsByYear");
	}

	@RequestMapping(value = "/mainSttProcessBarChart.do")
	public String mainSttProcessBarChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			cmmMap.put("ClassCode", "CL01005");
			List processList = commonService.selectList("main_SQL.processStt_chart", cmmMap);
			
			JSONArray processListJson = new JSONArray(processList);
			model.put("processData", processListJson);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/hom/main/stts/mainSttProcessBarChart");
	}
	
	

	
	@RequestMapping(value = "/mainSttProcessByTeamBarChart.do")
	public String mainSttProcessByTeamBarChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			cmmMap.put("classCode", "CL01005");
			List processList = commonService.selectList("custom_SQL.getL4CDimCountByOwnerTeam", cmmMap);
			
			JSONArray processListJson = new JSONArray(processList);
			
			model.put("processTeamData", processListJson);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/hom/main/stts/mainSttProcessByTeamBarChart");
	}
	
	@RequestMapping(value = "/mainSttProcessByTeamList.do")
	public String mainSttProcessByTeamList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			cmmMap.put("classCode", "CL01005");
			String teamColumnName = commonService.selectString("custom_SQL.getTeamColumnName", cmmMap);
			List teamHeaderNameList = commonService.selectList("custom_SQL.getTeamHeaderName", cmmMap);
			System.out.println("teamHeaderNameList :"+teamHeaderNameList);
			
			
			String pivotColumnName = "";
			String teamColumnSumName = "";
			String columns = " { width: 40, id: 'Type1', header: [{ text: '구분',  align:'center', colspan: 2}], align:'center'},{ width: 40, id: 'Type2', header: [{ text: '구분',  align:'center'}], align:'center'}";
			if(teamHeaderNameList.size()>0) {
				for(int i=0; teamHeaderNameList.size()>i; i++) {
					Map teamHeaderNameInfo = (Map)teamHeaderNameList.get(i);
					String teamName = StringUtil.checkNull(teamHeaderNameInfo.get("TeamName"));
					String teamCode = StringUtil.checkNull(teamHeaderNameInfo.get("TeamCode"));
					String teamNameForGrid = StringUtil.checkNull(teamHeaderNameInfo.get("TeamNameForGrid")); 
					
					columns += ",{ width: 60, id: '"+teamName+"', header: [{ text: '<span onClick=fnClickTeamName(\""+teamCode+"\")>"+teamNameForGrid+"</span>', align:'center'}], align:'center'}";		
					
					if(i==0) {
						pivotColumnName = teamName;
						teamColumnSumName = "MAX("+teamName+")";
					}else { pivotColumnName += ","+teamName; teamColumnSumName += " + MAX("+teamName+")";}
				}
			}
			columns += ",{ width: 60, id: 'Total', header: [{ text: 'Total', align:'center'}], align:'center'}";
			
			cmmMap.put("pivotColumnName", pivotColumnName);
			cmmMap.put("teamColumnSumName", teamColumnSumName);
			cmmMap.put("teamColumnName", teamColumnName);
			
			model.put("columns", columns);
			//model.put("spans", spans);
			
			List processList = commonService.selectList("custom_SQL.getL4CDimCountByOwnerTeamDetail", cmmMap);
			JSONArray processListJson = new JSONArray(processList);
			model.put("processTeamData", processListJson);


		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/hom/main/stts/mainSttProcessByTeamList");
	}
	
	@RequestMapping(value = "/mainSttProcessChart.do")
	public String mainSttProcessChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			List classList = (List) commonService.selectList("main_SQL.processStt_sum", cmmMap);
			String classCL4 = "0";
			String classCL5 = "0";
			String classCL6 = "0";
			if (classList.size() > 0) {
				for (int i = 0; i < classList.size(); i++) {
					HashMap classCnt = (HashMap) classList.get(i);
					if ("CL01004".equals(StringUtil.checkNull(classCnt.get("ItemClassCode")))) {
						classCL4 = StringUtil.getFormat(StringUtil.checkNull(classCnt.get("value"), "0"), "");
					}
					if ("CL01005".equals(StringUtil.checkNull(classCnt.get("ItemClassCode")))) {
						classCL5 = StringUtil.getFormat(StringUtil.checkNull(classCnt.get("value"), "0"), "");
					}
					if ("CL01006".equals(StringUtil.checkNull(classCnt.get("ItemClassCode")))) {
						classCL6 = StringUtil.getFormat(StringUtil.checkNull(classCnt.get("value"), "0"), "");
					}
				}
			}
			model.put("classCL4", classCL4);
			model.put("classCL5", classCL5);
			model.put("classCL6", classCL6);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/hom/main/stts/mainSttProcessChart");
	}

	@RequestMapping(value = "/visitLogStatisticsUser.do")
	public String visitLogStatisticsUser(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date(System.currentTimeMillis()));
		String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

		model.put("thisYmd", thisYmd);
		model.put("menu", getLabel(request, commonService)); /* Label Setting */
		return nextUrl("/aly/visitLogStatisticsUser");
	}

	//////////////////////////////////////////////////////////////////////////
	@RequestMapping(value = "/webixSidebarTest.do")
	public String webixSidebarTest(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {

		try {
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"), "NULL");
			if (projectID.equals("NULL") || projectID.equals("")) {
				Map projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", commandMap);
				model.put("projectID", projectInfoMap.get("ProjectID"));
				model.put("projectName", projectInfoMap.get("Name"));
			} else {
				model.put("projectID", StringUtil.checkNull(request.getParameter("ProjectID"), "NULL"));
				model.put("projectName", StringUtil.checkNull(request.getParameter("ProjectName"), "NULL"));
			}

			String screenMode = StringUtil.checkNull(commandMap.get("screenMode"));
			List reportList = commonService.selectList("report_SQL.getReportListOfPjt", commandMap);

			List reportNameList = commonService.selectList("report_SQL.getReportNameList", commandMap);
			HashMap reportNameMap = new HashMap();
			for (int i = 0; i < reportNameList.size(); i++) {
				Map getReportNameMap = (Map) reportNameList.get(i);
				reportNameMap.put(getReportNameMap.get("ReportCode"), getReportNameMap.get("ReportName"));
			}

			model.addAttribute(HTML_HEADER, "HOME");
			model.put("screenMode", screenMode); // 관리자용 통계/일반 유저용 통계 구분
			model.put("menu", getLabel(request, commonService));
			model.put("reportList", reportList);
			model.put("reportNameMap", reportNameMap);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		// return nextUrl("/aly/analysisMgt");
		return nextUrl("/aly/webixSidebarTest");
	}
	
	@RequestMapping(value="/visitLogReportByComp.do")
	public String visitLogReportByComp(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		Map setMap = new HashMap();
		Map VisitLogTotalMap = new HashMap();
		Map itemTypeCodeaMap = new HashMap();
		Map VisitLogTempMap = new HashMap();
	
	
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
	
	    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	
		String selStartDate = StringUtil.checkNull(commandMap.get("startDate"), "");
		String selEndDate = StringUtil.checkNull(commandMap.get("endDate"), "");
		
		String endDate = df.format(calendar.getTime());
	    calendar.add(Calendar.DATE, -7);
		String StartDate = df.format(calendar.getTime());
	
		if(selStartDate.equals("") && selEndDate.equals("")) {
			selStartDate = StartDate;
			selEndDate = endDate;		
		}
	
	    setMap.put("startDate",selStartDate);
	    setMap.put("endDate",selEndDate);
	    List VisitLogReportByCompList = new ArrayList();
		List UserLogList = commonService.selectList("user_SQL.getUserLogList", setMap);
	    List VisitLogReportByComp = commonService.selectList("analysis_SQL.getVisitLogReportByComp", setMap);
	    setMap.put("languageID", commandMap.get("languageID"));
	    setMap.put("Deactivated", 0);
	    List itemTypeList = commonService.selectList("item_SQL.getSearchItemTypeCode", setMap);
	    List templist = new ArrayList();
	    
	    String COMP_CD ="";
	    for(int i=0; i<VisitLogReportByComp.size(); i++) {
	    	VisitLogTotalMap = (HashMap) (VisitLogReportByComp.get(i));
	    	COMP_CD = StringUtil.checkNull(VisitLogTotalMap.get("COMP_CD"));
	    	for(int j=0; j<itemTypeList.size(); j++) {
	    		itemTypeCodeaMap = (HashMap) (itemTypeList.get(j));
	    		setMap = new HashMap();
	    		setMap.put("startDate",selStartDate);
	    	    setMap.put("endDate",selEndDate);
	    	    setMap.put("COMP_CD",COMP_CD);
	    	    setMap.put("itemTypeCode",itemTypeCodeaMap.get("ItemTypeCode"));
	    		templist = commonService.selectList("analysis_SQL.getVisitLogReportByComp", setMap);
	    		if(templist.size()>0) {
	    			for(int k=0; k<templist.size(); k++) {
	        			VisitLogTempMap = (HashMap) (templist.get(k));
	        			VisitLogTotalMap.put(itemTypeCodeaMap.get("ItemTypeCode"), StringUtil.checkNull(VisitLogTempMap.get("empCNT")));
	        		}
	    		}else {
	    			VisitLogTotalMap.put(itemTypeCodeaMap.get("ItemTypeCode"), 0);
	    		}
	    		
	    	}
	    	VisitLogReportByCompList.add(VisitLogTotalMap);
	    }
		
		JSONArray VisitLogReportByCompListData = new JSONArray(VisitLogReportByCompList);
		JSONArray UserLogListData = new JSONArray(UserLogList);
		model.put("VisitLogReportByCompListData", VisitLogReportByCompListData);
		model.put("UserLogListData", UserLogListData);
	
		model.put("itemTypeList", itemTypeList);
		model.put("startDate", selStartDate);
		model.put("endDate", selEndDate);
		
		String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
		setMap.put("reportCode",reportCode);
		setMap.put("languageID",languageID);
		String reportName = StringUtil.checkNull(commonService.selectString("report_SQL.getReportName", setMap));
		model.put("title", reportName);
	
		return nextUrl("/aly/visitLogReportByComp");
	}
	

	
	/**
	 * Process 통계 (2014/11/20) TW_PROCESS 테이블의 데이터 이용
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil 
	 */
	@RequestMapping(value = "/procSysCxnCnt.do")
	public String procSysCxnCnt(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {

		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(request.getParameter("languageID"),
					String.valueOf(commandMap.get("sessionCurrLangType")));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			/* xml 파일명 설정 */
			String xmlFilName = "upload/procSysCxnCnt.xml";
			String header = "";
			//String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));

			/* update 버튼 클릭으로 본 엑션을 호출한 경우 Process Insert procedure를 기동한다 / CALL XBOLTADM.TW_INSERT_ITEM_CXN */
			if (!StringUtil.checkNull(request.getParameter("eventMode")).isEmpty()) {
				commonService.insert("analysis_SQL.insertTwCXN", setMap);
			}

			setMap.put("LanguageID", languageID);

			// Dimension 검색 정보 설정
			if (!StringUtil.checkNull(request.getParameter("DimTypeID")).isEmpty()) {
				setMap.put("DimTypeID", request.getParameter("DimTypeID"));
				model.put("DimTypeID", request.getParameter("DimTypeID"));
				if (!StringUtil.checkNull(request.getParameter("DimValueID")).isEmpty()) {
					setMap.put("DimValueID", request.getParameter("DimValueID"));
					model.put("DimValueID", request.getParameter("DimValueID"));
				}
			}

			// get Level1 NameList (grid header표시용)
			Map setDomainMap = new HashMap();
			setDomainMap.put("domain", "fromDomain");
			setDomainMap.put("cxnItemTypeCode", "CN00104");
			List fromDoMainList = commonService.selectList("analysis_SQL.getProcSysCxnDomain", setDomainMap);
			
			setDomainMap.put("domain", "toDomain");
			setDomainMap.put("cxnItemTypeCode", "CN00104");
			List toDoMainList = commonService.selectList("analysis_SQL.getProcSysCxnDomain", setDomainMap);
			
			String parentItemIDs = "";
			if (setMap.containsKey("DimTypeID")) {
				parentItemIDs = getItemDimListOfParent(setMap);
				setDomainMap.put("ParentItemIDs", parentItemIDs);
				if (parentItemIDs.isEmpty()) {
					setDomainMap.put("isNothingParent", "Y");
				}
			}
			setDomainMap.put("ItemClassCode", "CL01006");
			List prcCountList = commonService.selectList("analysis_SQL.getPrcCountListL5", setDomainMap);

			Map prcCountMap = new HashMap();
			Map map = new HashMap();
			for (int i = 0; i < prcCountList.size(); i++) {
				map = (Map) prcCountList.get(i);
				prcCountMap.put(String.valueOf(map.get("L1ItemID")), String.valueOf(map.get("CNT")));
			}
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			Element row = doc.createElement("row");
			Element cell = doc.createElement("cell");
			doc.appendChild(rootElement);

			int rowId = 1;
			int rowTotal = 0;
			List getProcSysCxnList = new ArrayList();
			Map fromDomainMap = new HashMap();
			Map toDomainMap = new HashMap();

			for(int i=0; i<toDoMainList.size(); i++) {
				rowTotal = 0;
				toDomainMap = (HashMap)(toDoMainList.get(i));
				
				row = doc.createElement("row"); 
	            rootElement.appendChild(row); 
	            row.setAttribute("id", String.valueOf(rowId));
				rowId++;
				
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(toDomainMap.get("label"))));
				cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
				row.appendChild(cell);
				for(int j=0; j<fromDoMainList.size(); j++) {
					setDomainMap = new HashMap();
					fromDomainMap = (HashMap)(fromDoMainList.get(j));
					setDomainMap.put("cxnItemTypeCode", "CN00104");
					setDomainMap.put("toDomain", toDomainMap.get("ToDomain"));
					setDomainMap.put("fromDomain", fromDomainMap.get("FromDomain"));
					setDomainMap.put("ParentItemIDs", parentItemIDs);
					getProcSysCxnList = commonService.selectList("analysis_SQL.getProcSysCxnList", setDomainMap);
					
					cell = doc.createElement("cell");
					cell.appendChild(doc.createTextNode(Integer.toString(getProcSysCxnList.size())));
					row.appendChild(cell);
					rowTotal += getProcSysCxnList.size();
				}
				
				cell = doc.createElement("cell");
				cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
				cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
				row.appendChild(cell);
				
			}
			//Last line Total
			row = doc.createElement("row"); 
            rootElement.appendChild(row); 
            row.setAttribute("id", String.valueOf(rowId));
			rowId++;
			
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("Total"));
			cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
			row.appendChild(cell);
			int l5cnt = 0;
			int l5Totalcnt = 0;
			for(int j=0; j<fromDoMainList.size(); j++) {
				setDomainMap = new HashMap();
				fromDomainMap = (HashMap)(fromDoMainList.get(j));
				setDomainMap.put("cxnItemTypeCode", "CN00104");
				setDomainMap.put("fromDomain", fromDomainMap.get("FromDomain"));
				setDomainMap.put("ParentItemIDs", parentItemIDs);
				getProcSysCxnList = commonService.selectList("analysis_SQL.getProcSysCxnList", setDomainMap);
				
				cell = doc.createElement("cell");
				String FromDomain = String.valueOf(fromDomainMap.get("FromDomain"));
				l5cnt = Integer.parseInt(String.valueOf(prcCountMap.get(FromDomain)));
				cell.appendChild(doc.createTextNode(Integer.toString(getProcSysCxnList.size())+ "/" + Integer.toString(l5cnt)));
				row.appendChild(cell);
				rowTotal += getProcSysCxnList.size();
				l5Totalcnt += l5cnt;
			}
			
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(String.valueOf(rowTotal) + "/" + Integer.toString(l5Totalcnt)));
			cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
			row.appendChild(cell);
			
			
			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);
			
			// XML 데이터를 StringWriter에 기록
			StringWriter writer = new StringWriter();
			transformer.transform(new DOMSource(doc), new StreamResult(writer));
			String xmlDataString = writer.toString();
			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
			transformer.transform(source, result);

			//기존 header
//			for (int j = 0; j < fromDoMainList.size(); j++) {
//				Map level1NameMap = (Map) fromDoMainList.get(j);
//				String level1Name = String.valueOf(level1NameMap.get("label"));
//				header = header + "," + level1Name;
//			}
			
			// headerListJson
			JSONArray headerListJson = new JSONArray();
			for (int j = 0; j < fromDoMainList.size(); j++) {
			    Map level1NameMap = (Map) fromDoMainList.get(j);
			    Map headerNames = new HashMap<>();
			    headerNames.put("code", level1NameMap.get("CODE"));
			    headerNames.put("name", level1NameMap.get("NAME"));
			    headerListJson.put(headerNames);
			}
			
			System.out.println("!!!" + xmlDataString);
			model.put("headerListJson", headerListJson);
 			model.put("xmlData", xmlDataString); // XML data

			// Dimension 검색조건:DimtypeList
			List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);
			model.put("dimTypeList", dimTypeList);

//			model.put("level1Name", header + ",Total");
			model.put("cnt", (fromDoMainList.size()));
			model.put("xmlFilName", xmlFilName);
			//model.put("isMainMenu", isMainMenu);
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/procSysCxnCnt");
	}
	
	/**
	 * Process 통계 (2014/11/20) TW_PROCESS 테이블의 데이터 이용
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/itemDimensionStatistics.do")
	public String itemDimensionStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {

		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(request.getParameter("languageID"),
					String.valueOf(commandMap.get("sessionCurrLangType")));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			/* xml 파일명 설정 */
			String xmlFilName = "upload/itemDimensionStatistics.xml";
			String header = "";
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));

			/* update 버튼 클릭으로 본 엑션을 호출한 경우 Process Insert procedure를 기동한다 */
			if (!StringUtil.checkNull(request.getParameter("eventMode")).isEmpty()) {
				commonService.insert("analysis_SQL.insertTwProcess", setMap);
			}

			setMap.put("LanguageID", languageID);

			// Dimension 검색 정보 설정
			if (!StringUtil.checkNull(request.getParameter("DimTypeID")).isEmpty()) {
				setMap.put("DimTypeID", request.getParameter("DimTypeID"));
				model.put("DimTypeID", request.getParameter("DimTypeID"));
				if (!StringUtil.checkNull(request.getParameter("DimValueID")).isEmpty()) {
					setMap.put("DimValueID", request.getParameter("DimValueID"));
					model.put("DimValueID", request.getParameter("DimValueID"));
				}
			}

			// get Level1 NameList (grid header표시용)
			List level1NameList = commonService.selectList("analysis_SQL.getLevel1Name", setMap);
			setTtemDimensionStatisticsData(filepath, level1NameList, xmlFilName, setMap, request);

			for (int j = 0; j < level1NameList.size(); j++) {
				Map level1NameMap = (Map) level1NameList.get(j);
				String level1Name = String.valueOf(level1NameMap.get("label")) + ",#cspan";
				header = header + "," + level1Name;
			}

			// Dimension 검색조건:DimtypeList
			List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);
			model.put("dimTypeList", dimTypeList);

			model.put("level1Name", header + ",Total,#cspan");
			model.put("cnt", (level1NameList.size() + 4) * 2);
			model.put("xmlFilName", xmlFilName);
			model.put("isMainMenu", isMainMenu);
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/aly/itemDimensionStatistics");
	}
	

	/**
	 * Process Dimension 통계에 표시할 내용을 xml 파일로 생성
	 */
	private void setTtemDimensionStatisticsData(String filepath, List level1NameList, String xmlFilName, Map setMap,
			HttpServletRequest request) throws ExceptionUtil {

		// 통계 수치 resultList를 xml에 값 셋팅해서 grid 생성
		// 통계 리스트 표시 할 xml 파일 생성
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("rows");
			doc.appendChild(rootElement);

			int rowId = 1;
			int rowTotal = 0;
			String classCode = "CL01002";
			String classLevel = "2";

			Map<String, Integer> level4TotalMap = new HashMap<String, Integer>();
			Map<String, Integer> activityTotalMap = new HashMap<String, Integer>();
			Map<String, Integer> level6TotalMap = new HashMap<String, Integer>();
			int levell4TtlCnt = 0;
			int activityTtlCnt = 0;
			int levell6TtlCnt = 0;

			// row 엘리먼트
			Element row = doc.createElement("row");
			rootElement.appendChild(row);
			row.setAttribute("id", String.valueOf(rowId));
			rowId++;

			Element cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(setTitleCell(classLevel)));
			cell.setAttribute("colspan", "4"); // title
			cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);

			Map conditionMap = new HashMap();

			List newPrcCntList = new ArrayList();
			Map newPrcCntMap = new HashMap();

			for (int i = 0; i < level1NameList.size(); i++) {
				Map map = (Map) level1NameList.get(i);
				conditionMap.put(String.valueOf(map.get("ItemID")), String.valueOf(map.get("label")));
			}
			setMap.put("ItemTypeCode", "OJ00001");
			List itemClassCodeList = commonService.selectList("analysis_SQL.getItemClassCodeList", setMap);

			int MaxLevel = Integer.parseInt(commonService.selectString("analysis_SQL.getItemClassMaxLevel", setMap));

			Map prcCountMap = new HashMap();
			List prcCountList = new ArrayList();
			for (int icidx = 0; icidx < itemClassCodeList.size(); icidx++) {
				prcCountMap = new HashMap();
				Map tempMap = (Map) itemClassCodeList.get(icidx);
				String itemClassCode = tempMap.get("ItemClassCode").toString();
				int Level = Integer.parseInt(tempMap.get("Level").toString());
				// get L2 List

				setMap.put("ItemClassCode", itemClassCode);

				if ("CL01005".equals(itemClassCode))
					setMap.put("isDim", "Y");
				else if (!"CL01006".equals(itemClassCode))
					setMap.put("isDim", "N");

				if (icidx != itemClassCodeList.size() - 1) {
					prcCountList = commonService.selectList("analysis_SQL.getPrcCountList", setMap);
				} else {
					if (setMap.containsKey("DimTypeID")) {
						String parentItemIDs = getItemDimListOfParent(setMap);
						setMap.put("ParentItemIDs", parentItemIDs);
						if (parentItemIDs.isEmpty()) {
							setMap.put("isNothingParent", "Y");
						}
					}
					prcCountList = commonService.selectList("analysis_SQL.getPrcCountListL5", setMap);
				}

				for (int i = 0; i < prcCountList.size(); i++) {
					Map map = (Map) prcCountList.get(i);
					prcCountMap.put(String.valueOf(map.get("L1ItemID")), String.valueOf(map.get("CNT")));
				}
				for (int i = 0; i < level1NameList.size(); i++) {
					newPrcCntMap = new HashMap();
					Map map1 = (Map) level1NameList.get(i);
					newPrcCntMap.put("L1ItemID", String.valueOf(map1.get("ItemID")));
					newPrcCntMap.put("ItemClassCode", itemClassCode);
					newPrcCntMap.put("ItemClassLevel", Level);
					if (prcCountMap.containsKey(String.valueOf(map1.get("ItemID")))) {
						newPrcCntMap.put("CNT", prcCountMap.get(String.valueOf(map1.get("ItemID"))));
					} else {
						newPrcCntMap.put("CNT", "0");
					}
					newPrcCntList.add(newPrcCntMap);
				}

			}

			/* Activity 이외의 item count row 생성 */
			for (int i = 0; i < newPrcCntList.size(); i++) {
				prcCountMap = (Map) newPrcCntList.get(i);
				String level1ItemId = StringUtil.checkNull(prcCountMap.get("L1ItemID"));
				if (conditionMap.containsKey(level1ItemId)) {

					int level = Integer.parseInt(prcCountMap.get("ItemClassLevel").toString());
					if (!classCode.equals(prcCountMap.get("ItemClassCode"))) {
						classCode = String.valueOf(prcCountMap.get("ItemClassCode"));
						// if (!classCode.equals("CL01006")) { //TODO:L4의 Total만표시 할때의 조건
						if (level < MaxLevel - 1) {
							// Total cell 값 설정 후, 새로운 row 추가
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
							cell.setAttribute("style", "font-weight:bold;");
							cell.setAttribute("colspan", "2"); // cnt1
							row.appendChild(cell);
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(""));
							row.appendChild(cell);
							rowTotal = 0; // Total 값 초기화

							row = doc.createElement("row");
							rootElement.appendChild(row);
							row.setAttribute("id", String.valueOf(rowId));
							rowId++;

							cell = doc.createElement("cell");
							cell.appendChild(
									doc.createTextNode(setTitleCell(prcCountMap.get("ItemClassLevel").toString())));
							cell.setAttribute("colspan", "4"); // title
							cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
							row.appendChild(cell);
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(""));
							row.appendChild(cell);
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(""));
							row.appendChild(cell);
							cell = doc.createElement("cell");
							cell.appendChild(doc.createTextNode(""));
							row.appendChild(cell);
						}
					}

					if (level == MaxLevel) {
						activityTotalMap.put(prcCountMap.get("L1ItemID").toString(),
								Integer.parseInt(prcCountMap.get("CNT").toString()));
						activityTtlCnt = activityTtlCnt + Integer.parseInt(prcCountMap.get("CNT").toString());
					} else if (level == MaxLevel - 1) { // TODO:L4의 Total만표시 할때 : 이 if문의 comment out
						level4TotalMap.put(prcCountMap.get("L1ItemID").toString(),
								Integer.parseInt(prcCountMap.get("CNT").toString()));
						levell4TtlCnt = levell4TtlCnt + Integer.parseInt(prcCountMap.get("CNT").toString());
					} else {
						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(String.valueOf(prcCountMap.get("CNT"))));
						cell.setAttribute("colspan", "2"); // cnt1
						row.appendChild(cell);
						cell = doc.createElement("cell");
						cell.appendChild(doc.createTextNode(""));
						row.appendChild(cell);
						rowTotal = rowTotal + Integer.parseInt(String.valueOf(prcCountMap.get("CNT")));
					}
				}
			}

			activityTotalMap.put("TTL", activityTtlCnt);
			level4TotalMap.put("TTL", levell4TtlCnt);

			// Activity 이외의 item 마지막 row의 Total cell 값 설정
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
			cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
			cell.setAttribute("colspan", "2"); // cnt1
			row.appendChild(cell);
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
			rowTotal = 0; // Total 값 초기화

			/* L4 count row 생성 */ // TODO:L4의 Total만표시 할때 : comment out
			// Map<String, Integer> level4CntMap = setLevel4Rows(doc, rootElement, row,
			// cell, rowId, level1NameList, setMap, level4TotalMap);
			// rowId = level4CntMap.get("rowId");

			/* Activity count row 생성 */
			// Map<String, Integer> activityCntMap = setActivityRows(doc, rootElement, row,
			// cell, rowId, level1NameList, setMap, activityTotalMap);
			// rowId = activityCntMap.get("rowId");
			Map getMap = new HashMap();
			System.out.println(itemClassCodeList.size());
			for (int i = itemClassCodeList.size() - 2; i < itemClassCodeList.size(); i++) {
				Map tempMap = (Map) itemClassCodeList.get(i);
				getMap.put("ItemClassCode", tempMap.get("ItemClassCode"));
				getMap.put("ItemClassLevel", tempMap.get("Level"));
				getMap.put("AttrTypeCode", (i == itemClassCodeList.size() - 2 ? "AT00026" : "AT00037"));
				System.out.println((i == itemClassCodeList.size() - 2 ? "level4TotalMap" : "activityTotalMap"));
				System.out.println(activityTotalMap.toString());
				Map<String, Integer> CntMap = setLevelActivityRows(doc, rootElement, row, cell, rowId, level1NameList,
						getMap, setMap, (i == itemClassCodeList.size() - 2 ? level4TotalMap : activityTotalMap),
						MaxLevel);
				rowId = CntMap.get("rowId");
			}

			/*
			 * PI row 생성 Map<String, Integer> piCntMap = setCnItemsRow(doc, rootElement,
			 * row, cell, rowId, level1NameList, setMap, "CN01301", "fromItemID"); rowId =
			 * piCntMap.get("rowId");
			 */

			/*
			 * To Check row 생성 Map<String, Integer> toCheckCntMap = setCnItemsRow(doc,
			 * rootElement, row, cell, rowId, level1NameList, setMap, "CN00109",
			 * "toItemID"); rowId = toCheckCntMap.get("rowId");
			 */
			
			/* role row 생성 */
			Map<String, Integer> roleCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap,
					"CN00201", "toItemID");
			rowId = roleCntMap.get("rowId");
			
			/* System row 생성 */
			Map<String, Integer> controlCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList,
					setMap, "CN00104", "toItemID");
			rowId = controlCntMap.get("rowId");

			/* Rule set row 생성 */
			Map<String, Integer> ruleSetCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList,
					setMap, "CN00107", "toItemID");
			rowId = ruleSetCntMap.get("rowId");

			/*
			 * To Check row 생성 Map<String, Integer> toCheckCntMap = setCnItemsRow(doc,
			 * rootElement, row, cell, rowId, level1NameList, setMap, "CN00109",
			 * "toItemID"); rowId = toCheckCntMap.get("rowId");
			 */
			/* SOP row 생성 */
			Map<String, Integer> kpiCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap,
					"CN00105", "toItemID");
			rowId = kpiCntMap.get("rowId");
			

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName)));
			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	
	@RequestMapping(value = "/procChangeSttatByLvl.do")
	public String progressByL1(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws ExceptionUtil {
		Map setMap = new HashMap();
		try {
			/* update 버튼 클릭으로 본 엑션을 호출한 경우 Process Insert procedure를 기동한다 */
			if (!StringUtil.checkNull(request.getParameter("eventMode")).isEmpty()) {
				commonService.selectList("analysis_SQL.insertTwProcess", setMap);
			}
			model.put("menu", getLabel(request, commonService));
			commandMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
			// get Level1 NameList (grid header표시용)
			List level1NameList = commonService.selectList("analysis_SQL.getLevel1Name", commandMap); 
			JSONArray level1NameData = new JSONArray(level1NameList);
			model.put("level1NameList", level1NameData);
			commandMap.put("L1list",level1NameList);
			String classCode = StringUtil.checkNull(request.getParameter("ClassCode"));
			String attrTypeCode = StringUtil.checkNull(request.getParameter("AttrTypeCode"));
			model.put("ClassCode",classCode);
			if(classCode.isEmpty()||classCode.equals("CL01005")) {
				commandMap.put("ClassCode","CL01005");
			}else {
				commandMap.put("ClassCode","CL01006");
			}
			commandMap.put("AttrTypeCode","AT00026");
			List LovCodeList = commonService.selectList("analysis_SQL.getLovCodeList", commandMap ); 
			commandMap.put("LovCodeList",LovCodeList);
			List dList = commonService.selectList("analysis_SQL.getProcChangeSttatByLvl_gridlist",commandMap);
			model.put("showClsFilter",StringUtil.checkNull(request.getParameter("showClsFilter")));

			JSONArray gridData = new JSONArray(dList);
			model.put("gridData",gridData);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/hom/main/stts/procChangeSttatByLvl");
	}
	
}
