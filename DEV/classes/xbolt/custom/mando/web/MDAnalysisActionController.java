package xbolt.custom.mando.web;

import java.io.*;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;


import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.MakeWordReport;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
/**
 * 분석/통계
 * @Class Name : MDAnalysisActionController.java
 * @Description : 분석/통계관련 Biz.
 * @Modification Information
 * @수정일			수정자		수정내용
 * @--------- 		---------	-------------------------------
 * @2017. 06. 07.	wjcho		만도용 최초생성
 *
 * @since 2017. 06. 07
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class MDAnalysisActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;
	
	/**
	 * 만도 전용 ItemStatis함수 (2017/06/07 조우진)
	 * TW_PROCESS 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value="/mdItemStatistics.do")
	public String mdItemStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(String.valueOf(commandMap.get("sessionCurrLangType")),request.getParameter("languageID"));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			/* xml 파일명 설정 */
	        String xmlFilName = "upload/processStatistics.xml";
	        String header = "";
	        
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
	        setNewItemStatisticsData(filepath, level1NameList, xmlFilName, setMap, request);
	     	
	        for (int j = 0; j < level1NameList.size(); j++) {
	        	Map level1NameMap = (Map) level1NameList.get(j);
        		String level1Name =String.valueOf(level1NameMap.get("label"))+ ",#cspan";
        		header = header + "," + level1Name;
	        }
	        
	        // Dimension 검색조건:DimtypeList
	        List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
			model.put("dimTypeList", dimTypeList);
	        
	        model.put("level1Name", header + ",Total,#cspan");
	        model.put("cnt", (level1NameList.size() + 4) * 2);
	        model.put("xmlFilName", xmlFilName);
			model.put("menu", getLabel(request, commonService));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/custom/mando/newMDItemStatistics");
	}
	
	/**
	 * Process 통계 (2014/11/20)
	 * TW_PROCESS 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/newMDItemStatistics.do")
	public String newMDItemStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(String.valueOf(commandMap.get("sessionCurrLangType")),request.getParameter("languageID"));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			/* xml 파일명 설정 */
	        String xmlFilName = "upload/processStatistics.xml";
	        String header = "";
	        
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
	        setNewItemStatisticsData(filepath, level1NameList, xmlFilName, setMap, request);
	     	
	        for (int j = 0; j < level1NameList.size(); j++) {
	        	Map level1NameMap = (Map) level1NameList.get(j);
        		String level1Name =String.valueOf(level1NameMap.get("label"))+ ",#cspan";
        		header = header + "," + level1Name;
	        }
	        
	        // Dimension 검색조건:DimtypeList
	        List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
			model.put("dimTypeList", dimTypeList);
	        
	        model.put("level1Name", header + ",Total,#cspan");
	        model.put("cnt", (level1NameList.size() + 4) * 2);
	        model.put("xmlFilName", xmlFilName);
			model.put("menu", getLabel(request, commonService));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/custom/mando/newMDItemStatistics");
	}
	
	private String getRatio(BigDecimal levelTotalNum, BigDecimal subTotalNum) {
		if (levelTotalNum.compareTo(BigDecimal.ZERO) == 0 || subTotalNum.compareTo(BigDecimal.ZERO) == 0) {
			return "0%";
		}
		BigDecimal resultRatio = (subTotalNum.divide(levelTotalNum, MathContext.DECIMAL32)).multiply(new BigDecimal(100)).setScale(0, RoundingMode.HALF_UP);
		return resultRatio.toString() + "%";
	}
	
	private String getMinusResult(String x, String y) {
		int result = 0;
		result = Integer.parseInt(x) - Integer.parseInt(y);
		
		return String.valueOf(result);
	}
	
	/**
	 * Process 통계에 표시할 내용을 xml 파일로 생성
	 * @param filepath
	 * @param prcCountList
	 * @param level1NameList
	 * @param xmlFilName
	 * @param setMap
	 * @throws Exception
	 */
	private void setNewItemStatisticsData(String filepath, List level1NameList, String xmlFilName, Map setMap, HttpServletRequest request) throws ExceptionUtil {
		
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
	        cell.appendChild(doc.createTextNode(setTitleCell(classCode)));
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
	        
	        // get L2 List
	        setMap.put("ItemClassCode", "CL01002");
	        setMap.put("isDim", "N");
	        List prcCountList = commonService.selectList("analysis_SQL.getPrcCountList", setMap);
	        Map prcCountMap = new HashMap();
	        for (int i = 0; i < prcCountList.size(); i++) {
	        	Map map = (Map) prcCountList.get(i);
	        	prcCountMap.put(String.valueOf(map.get("L1ItemID")), String.valueOf(map.get("CNT")));
	        }
	        for (int i = 0; i < level1NameList.size(); i++) {
	        	newPrcCntMap = new HashMap();
	        	Map map1 = (Map) level1NameList.get(i);
	        	newPrcCntMap.put("L1ItemID", String.valueOf(map1.get("ItemID")));
	        	newPrcCntMap.put("ItemClassCode", "CL01002");
	        	if (prcCountMap.containsKey(String.valueOf(map1.get("ItemID")))) {
	        		newPrcCntMap.put("CNT", prcCountMap.get(String.valueOf(map1.get("ItemID"))));
	        	} else {
	        		newPrcCntMap.put("CNT", "0");
	        	}
	        	newPrcCntList.add(newPrcCntMap);
	        }
	        
	        // get L3 List
	        setMap.put("ItemClassCode", "CL01004");
	        setMap.put("isDim", "N");
	        prcCountList = commonService.selectList("analysis_SQL.getPrcCountList", setMap);
	        prcCountMap = new HashMap();
	        for (int i = 0; i < prcCountList.size(); i++) {
	        	Map map = (Map) prcCountList.get(i);
	        	prcCountMap.put(String.valueOf(map.get("L1ItemID")), String.valueOf(map.get("CNT")));
	        }
	        for (int i = 0; i < level1NameList.size(); i++) {
	        	newPrcCntMap = new HashMap();
	        	Map map1 = (Map) level1NameList.get(i);
	        	newPrcCntMap.put("L1ItemID", String.valueOf(map1.get("ItemID")));
	        	newPrcCntMap.put("ItemClassCode", "CL01004");
	        	if (prcCountMap.containsKey(String.valueOf(map1.get("ItemID")))) {
	        		newPrcCntMap.put("CNT", prcCountMap.get(String.valueOf(map1.get("ItemID"))));
	        	} else {
	        		newPrcCntMap.put("CNT", "0");
	        	}
	        	newPrcCntList.add(newPrcCntMap);
	        }
	        
	        // get L4 List
	        setMap.put("ItemClassCode", "CL01005");
	        setMap.put("isDim", "Y");
	        prcCountList = commonService.selectList("analysis_SQL.getPrcCountList", setMap);
	        prcCountMap = new HashMap();
	        for (int i = 0; i < prcCountList.size(); i++) {
	        	Map map = (Map) prcCountList.get(i);
	        	prcCountMap.put(String.valueOf(map.get("L1ItemID")), String.valueOf(map.get("CNT")));
	        }
	        for (int i = 0; i < level1NameList.size(); i++) {
	        	newPrcCntMap = new HashMap();
	        	Map map1 = (Map) level1NameList.get(i);
	        	newPrcCntMap.put("L1ItemID", String.valueOf(map1.get("ItemID")));
	        	newPrcCntMap.put("ItemClassCode", "CL01005");
	        	if (prcCountMap.containsKey(String.valueOf(map1.get("ItemID")))) {
	        		newPrcCntMap.put("CNT", prcCountMap.get(String.valueOf(map1.get("ItemID"))));
	        	} else {
	        		newPrcCntMap.put("CNT", "0");
	        	}
	        	newPrcCntList.add(newPrcCntMap);
	        }
	        
	        // get L5 List       
	        setMap.put("ItemClassCode", "CL01006");
	        if (setMap.containsKey("DimTypeID")) {
	        	String parentItemIDs = getItemDimListOfParent(setMap);
	        	setMap.put("ParentItemIDs", parentItemIDs);
	        	if (parentItemIDs.isEmpty()) {
	        		setMap.put("isNothingParent", "Y");
	        	}
	        }
	        prcCountList = commonService.selectList("analysis_SQL.getPrcCountListL5", setMap);
	        prcCountMap = new HashMap();
	        for (int i = 0; i < prcCountList.size(); i++) {
	        	Map map = (Map) prcCountList.get(i);
	        	prcCountMap.put(String.valueOf(map.get("L1ItemID")), String.valueOf(map.get("CNT")));
	        }
	        for (int i = 0; i < level1NameList.size(); i++) {
	        	newPrcCntMap = new HashMap();
	        	Map map1 = (Map) level1NameList.get(i);
	        	newPrcCntMap.put("L1ItemID", String.valueOf(map1.get("ItemID")));
	        	newPrcCntMap.put("ItemClassCode", "CL01006");
	        	if (prcCountMap.containsKey(String.valueOf(map1.get("ItemID")))) {
	        		newPrcCntMap.put("CNT", prcCountMap.get(String.valueOf(map1.get("ItemID"))));
	        	} else {
	        		newPrcCntMap.put("CNT", "0");
	        	}
	        	newPrcCntList.add(newPrcCntMap);
	        }
	        
	        /* Activity 이외의 item count row 생성 */
		    for (int i = 0; i < newPrcCntList.size(); i++) {
		    	prcCountMap = (Map) newPrcCntList.get(i);
		    	String level1ItemId = StringUtil.checkNull(prcCountMap.get("L1ItemID"));
		    	if (conditionMap.containsKey(level1ItemId)) {
		    		if (!classCode.equals(prcCountMap.get("ItemClassCode"))) {
			    		classCode = String.valueOf(prcCountMap.get("ItemClassCode"));
			    		if (!classCode.equals("CL01006")) { //TODO:L4의 Total만표시 할때의 조건
			    		//if (!(classCode.equals("CL01006") || classCode.equals("CL01005"))) {
			    			// Total cell 값 설정 후, 새로운 row 추가
			    			cell = doc.createElement("cell");
					        cell.appendChild(doc.createTextNode(String.valueOf(rowTotal)));
					        cell.setAttribute("style", "font-weight:bold;");
					        cell.setAttribute("colspan", "2"); // cnt1
					        row.appendChild(cell);
					        cell = doc.createElement("cell");
					        cell.appendChild(doc.createTextNode(""));
					        row.appendChild(cell);
					        rowTotal = 0;  // Total 값 초기화
					        
			    			row = doc.createElement("row"); 
				            rootElement.appendChild(row); 
				            row.setAttribute("id", String.valueOf(rowId));
				            rowId++;
				            
				            cell = doc.createElement("cell");
					        cell.appendChild(doc.createTextNode(setTitleCell(classCode)));
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
			    	
			    	if (classCode.equals("CL01006")) { 
			    		activityTotalMap.put(prcCountMap.get("L1ItemID").toString(), Integer.parseInt(prcCountMap.get("CNT").toString()));
			    		activityTtlCnt = activityTtlCnt + Integer.parseInt(prcCountMap.get("CNT").toString());
			    	} /*else if (classCode.equals("CL01005")){ //TODO:L4의 Total만표시 할때 : 이 if문의 comment out
			    		level4TotalMap.put(prcCountMap.get("L1ItemID").toString(), Integer.parseInt(prcCountMap.get("CNT").toString()));
			    		levell4TtlCnt = levell4TtlCnt + Integer.parseInt(prcCountMap.get("CNT").toString());
			    	} */else {
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
	        rowTotal = 0; 
		    // Total 값 초기화
	        
	        /* L4 count row 생성 */ // TODO:L4의 Total만표시 할때 : comment out
	     //   Map<String, Integer> level4CntMap = setLevel4Rows(doc, rootElement, row, cell, rowId, level1NameList, setMap, level4TotalMap);
	     //   rowId = level4CntMap.get("rowId");
	        
		    /* Activity count row 생성 */
	        Map<String, Integer> activityCntMap = setActivityRows(doc, rootElement, row, cell, rowId, level1NameList, setMap, activityTotalMap);
	        rowId = activityCntMap.get("rowId");
	     
	        /* PI row 생성 */
	       // Map<String, Integer> piCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN01301", "fromItemID");
	       // rowId = piCntMap.get("rowId");
	        
	        /* Rule set row 생성 */
	       // Map<String, Integer> ruleSetCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00107", "toItemID");
	       // rowId = ruleSetCntMap.get("rowId");
	        
	        /* To Check row 생성 */
	        //Map<String, Integer> toCheckCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00109", "toItemID");
	       // rowId = toCheckCntMap.get("rowId");
	        
	        /* KPI row 생성 */
	      //  Map<String, Integer> kpiCntMap = setCnItemsRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, "CN00108", "toItemID");
	      //  rowId = kpiCntMap.get("rowId");
	        
	        /* 첨부파일 row 생성 */
	       // Map<String, Integer> fileCntMap = setItemFileRow(doc, rootElement, row, cell, rowId, level1NameList, setMap, request);
	       // rowId = fileCntMap.get("rowId");
	        
		    // XML 파일로 쓰기 
	        TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
	        Transformer transformer = transformerFactory.newTransformer(); 
	        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
		    transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
		    DOMSource source = new DOMSource(doc); 	    
		    StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
		    transformer.transform(source, result); 
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}
	
	/**
	 * 부모 레벨의 Item Dim 리스트 취득
	 * @param classCode
	 * @param DimTypeId
	 * @param DimValueId
	 * @return
	 * @throws Exception
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
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
			
		return result;
	}
	
	/**
	 * Process map(L4)의 각 row별 count 값을 셋팅한다.
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @return
	 * @throws Exception
	 */
	private Map<String, Integer> setLevel4Rows(Document doc, Element rootElement
								, Element row, Element cell, int rowId
								, List level1NameList, Map setMap, Map<String, Integer> level4ColTtlMap) throws ExceptionUtil {
		Map<String, Integer> level4TotalMap = new HashMap<String, Integer>();
		int rowTotal = 0;
			try {
			setMap.put("AttrTypeCode", "AT00026");
			List level4LovCodeList = commonService.selectList("analysis_SQL.getLovCodeList", setMap);
			BigDecimal l4Ttl = new BigDecimal(StringUtil.checkNull(level4ColTtlMap.get("TTL")));
			
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
		        cell.setAttribute("style", "font-weight:bold;"+backColor);
		        cell.setAttribute("colspan", "2"); // cnt1
		        row.appendChild(cell);
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(""));
		        row.appendChild(cell);
		        
		        // 해당 activity 건수 취득
		        setMap.put("LovCode", lovCode);
		        setMap.put("AttrTypeCode", "AT00026");
		        setMap.put("ItemClassCode", "CL01005");
		        List level4CntList = commonService.selectList("analysis_SQL.getLovCountList", setMap);
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
		            	
		            	BigDecimal colTotal = new BigDecimal(StringUtil.checkNull(level4ColTtlMap.get(l1ItemID),"0")); // 해당 행,Level,Lov의 Total
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
		    	        	level4TotalMap.put(l1ItemID, total + Integer.parseInt(StringUtil.checkNull(level4CntMap.get(l1ItemID), "0")));
		    	        } else {
		    	        	level4TotalMap.put(l1ItemID, Integer.parseInt(StringUtil.checkNull(level4CntMap.get(l1ItemID), "0")));
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
		        rowTotal = 0;  // Total 값 초기화
				
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
	        	if ("0".equals(StringUtil.checkNull(level4ColTtlMap.get(l1ItemId),"0"))) {
	        		manualCnt = 0;
	        	} else {
	        		manualCnt = level4ColTtlMap.get(l1ItemId) - (Integer.parseInt(activityCnt));
	        	}
	        	
	        	BigDecimal colTotal = new BigDecimal(StringUtil.checkNull(level4ColTtlMap.get(l1ItemId),"0")); // 해당 행,Level,Lov의 Total
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
	        rowTotal = 0;  // Total 값 초기화
	        
	        // Level4 Total
	        row = doc.createElement("row"); 
	        rootElement.appendChild(row); 
	        row.setAttribute("id", String.valueOf(rowId));
	        rowId++;
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(""));
	        row.appendChild(cell);
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode("L3"));
	        cell.setAttribute("colspan", "2"); // cnt1
	        cell.setAttribute("style", "font-weight:bold;background-color:#f2f2f2;");
	        row.appendChild(cell);
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(""));
	        row.appendChild(cell);
	        
	        for (int i = 0; i < level1NameList.size(); i++) {
	        	Map map = (Map) level1NameList.get(i);
	        	String l1ItemId = String.valueOf(map.get("ItemID"));
	        	int totalCnt = Integer.parseInt(StringUtil.checkNull(level4ColTtlMap.get(l1ItemId),"0"));
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
	        cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;background-color:#f2f2f2;");
	        row.appendChild(cell);
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(""));
	        row.appendChild(cell);
	        rowTotal = 0;  // Total 값 초기화
			
	        level4TotalMap.put("rowId", rowId);
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return level4TotalMap;
	}
	
	/**
	 * Activity(L5)의 각 row별 count 값을 셋팅한다.
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @return
	 * @throws Exception
	 */
	private Map<String, Integer> setActivityRows(Document doc, Element rootElement
								, Element row, Element cell, int rowId
								, List level1NameList, Map setMap, Map<String, Integer> activityColTtlMap) throws ExceptionUtil {
		Map<String, Integer> activityTotalMap = new HashMap<String, Integer>();
		int rowTotal = 0;
			try {
			setMap.put("AttrTypeCode", "AT00004");
			List activityLovCodeList = commonService.selectList("analysis_SQL.getLovCodeList", setMap);
			BigDecimal l5Ttl = new BigDecimal(StringUtil.checkNull(activityColTtlMap.get("TTL")));
			
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
		        cell.setAttribute("style", "font-weight:bold;"+backColor);
		        cell.setAttribute("colspan", "2"); // cnt1
		        row.appendChild(cell);
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(""));
		        row.appendChild(cell);
		        
		        // 해당 activity 건수 취득
		        setMap.put("LovCode", lovCode);
		        setMap.put("AttrTypeCode", "AT00004");
		        setMap.put("ItemClassCode", "CL01006");
		        List activityCntList = commonService.selectList("analysis_SQL.getLovCountListL5", setMap);
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
		            	
		            	BigDecimal colTotal = new BigDecimal(StringUtil.checkNull(activityColTtlMap.get(l1ItemID),"0")); // 해당 행,Level,Lov의 Total
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
		    	        	activityTotalMap.put(l1ItemID, total + Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
		    	        } else {
		    	        	activityTotalMap.put(l1ItemID, Integer.parseInt(StringUtil.checkNull(activityCntMap.get(l1ItemID), "0")));
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
		        rowTotal = 0;  // Total 값 초기화
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
	        	if ("0".equals(StringUtil.checkNull(activityColTtlMap.get(l1ItemId),"0"))) {
	        		manualCnt = 0;
	        	} else {
	        		manualCnt = activityColTtlMap.get(l1ItemId) - (Integer.parseInt(activityCnt));
	        	}
	        	
	        	BigDecimal colTotal = new BigDecimal(StringUtil.checkNull(activityColTtlMap.get(l1ItemId),"0")); // 해당 행,Level,Lov의 Total
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
	        rowTotal = 0;  // Total 값 초기화
	        
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
	        	//int totalCnt = activityTotalMap.get(l1ItemId);
	        	int totalCnt = Integer.parseInt(StringUtil.checkNull(activityColTtlMap.get(l1ItemId),"0"));
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
	        cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;background-color:#f2f2f2;");
	        row.appendChild(cell);
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(""));
	        row.appendChild(cell);
	        rowTotal = 0;  // Total 값 초기화
			
			activityTotalMap.put("rowId", rowId);
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return activityTotalMap;
	}
	
	
	/**
	 * Rule Set (연관항목:CN00107) Count를 설정 한다
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @param setMap
	 * @return
	 * @throws Exception
	 */
	private Map<String, Integer> setCnItemsRow(Document doc, Element rootElement, Element row, Element cell, int rowId, List level1NameList, Map setMap, String itemTypeCode, String itemFromTo) throws ExceptionUtil {
		
		Map<String, Integer> cnItemsMap = new HashMap<String, Integer>();
			try {
			// Title
			row = doc.createElement("row"); 
	        rootElement.appendChild(row); 
	        row.setAttribute("id", String.valueOf(rowId));
	        rowId++;
	        cell = doc.createElement("cell");
	        if ("CN00107".equals(itemTypeCode)) { // Rule set
	        	cell.appendChild(doc.createTextNode("Rule set"));
	        } else if("CN01301".equals(itemTypeCode)){ // PI
	        	cell.appendChild(doc.createTextNode("PI"));
	        } else if("CN00109".equals(itemTypeCode)){ // To Check
	        	cell.appendChild(doc.createTextNode("To Check"));
	        } else { // KPI
	        	cell.appendChild(doc.createTextNode("KPI"));
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
	        	if(itemFromTo.equals("fromItemID")){
	        		toItemList = commonService.selectList("analysis_SQL.getFromItemList", setMap);
	        	}else{ // toItemID
	        		toItemList = commonService.selectList("analysis_SQL.getToItemList", setMap);
	        	}
	        	String toItemCnt = String.valueOf(toItemList.size());
	        	
	        	cell = doc.createElement("cell"); 
		        cell.appendChild(doc.createTextNode(toItemCnt + "(" + cnItemCnt + ")"));
		        cell.setAttribute("colspan", "2");
		        row.appendChild(cell);
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(""));
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
	    	if(itemFromTo.equals("fromItemID")){
	    		toItemList = commonService.selectList("analysis_SQL.getFromItemList", setMap);
	    	}else{
	    		toItemList = commonService.selectList("analysis_SQL.getToItemList", setMap);
	    	}
	    	String toItemCnt = String.valueOf(toItemList.size());
	    	
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(toItemCnt + "(" + cnItemCnt + ")"));
	        cell.setAttribute("colspan", "2"); // cnt1
	        cell.setAttribute("style", "font-weight:bold;color:#0D65B7;text-decoration:underline;");
	        row.appendChild(cell);
	        cell = doc.createElement("cell");
	        cell.appendChild(doc.createTextNode(""));
	        row.appendChild(cell);
	        
	        cnItemsMap.put("rowId", rowId);
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return cnItemsMap;
	}
	
	/**
	 * 아이템 파일  Count를 설정 한다
	 * @param doc
	 * @param rootElement
	 * @param row
	 * @param cell
	 * @param rowId
	 * @param level1NameList
	 * @param setMap
	 * @return
	 * @throws Exception
	 */
	private Map<String, Integer> setItemFileRow(Document doc, Element rootElement
								, Element row, Element cell, int rowId, List level1NameList
								, Map setMap, HttpServletRequest request) throws ExceptionUtil {
		
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
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return cnItemsMap;
	}
	
	/**
	 * classCode 별 row title 설정
	 * @param classCode
	 * @return
	 */
	private String setTitleCell(String classCode) {
		String result = "";
		
		if (classCode.equals("CL01002")) {
			result = "L2";
		} else if (classCode.equals("CL01004")) {
			result = "L3";
		} else if (classCode.equals("CL01005")) {
			result = "L4";
		} else {
			result = "L5";
		}
		
		return result;
	}
	
	/**
	 * L4 background-color return
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
	

	@RequestMapping(value="/mdVisitLogRep.do")
	public String mdVisitLogRep(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		try {
			
			String filepath = request.getSession().getServletContext().getRealPath("/");
			Map<String, Object> setMap = new HashMap<String, Object>();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),request.getParameter("languageID"));
		
			String startDT = StringUtil.checkNull(request.getParameter("startDT"));
			String endDT = StringUtil.checkNull(request.getParameter("endDT"));
			setMap.put("languageID", languageID);
			List itemNameList = commonService.selectList("custom_SQL.getMDVisitLogName", setMap);
			List processOtherNameList = commonService.selectList("custom_SQL.getMDVisitLogNameOther", setMap);
			
			Map topList = new HashMap();
			setMap.put("dimTypeID", "100001");
			List regionList = commonService.selectList("dim_SQL.getDimValueNameList", setMap);
			int regSize = regionList.size();
			List allCountList = new ArrayList();
			Map rowMap = new HashMap();
			Map regMap = new HashMap();
			if(startDT != null && startDT != "" && endDT != null && endDT != "") {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
				Date st = formatter.parse(startDT.replaceAll("-", ""));
				Date ed = formatter.parse(endDT.replaceAll("-", ""));
				
				long diffDate = ed.getTime() - st.getTime();
				diffDate = diffDate / (24*60*60*1000);
				for (int i = 0; i < diffDate+1 ; i++) {
					String setDate = formatter.format(ed.getTime() - ((long) 1000 * 60 * 60 * 24 * (i)));					
					for(int j=0; j<regionList.size(); j++) {
	
						rowMap = new HashMap();
						regMap = (HashMap) regionList.get(j);
						
						setMap.put("dayId", setDate);
						setMap.put("region", regMap.get("DimValueID"));
						rowMap.put("Date", setDate);
						rowMap.put("Region", regMap.get("DimValueID"));
						
						Map tempMap = commonService.select("custom_SQL.getMDVisitLogMemberValue", setMap);
						  
						if(tempMap == null || tempMap.isEmpty()) {
							rowMap.put("MEMBER", "0");
						}
						else {
							rowMap.put("MEMBER", tempMap.get("CON_COUNT"));
						}
						
						for(int k=0; k < itemNameList.size(); k++) {

			            	Map itemNameMap = (Map) itemNameList.get(k);
			            	String itemName = (String) itemNameMap.get("Identifier");
			            	setMap.put("itemCode",itemName);
			            	
							tempMap = commonService.select("custom_SQL.getMDVisitLogProcValue", setMap);
							  
							if(tempMap == null || tempMap.isEmpty()) {
								rowMap.put(itemName, "0");
							}
							else {
								rowMap.put(itemName, tempMap.get("CON_COUNT"));
							}
						}
						setMap.remove("itemCode");
						
						tempMap = commonService.select("custom_SQL.getMDVisitLogOtherValue", setMap);
						  
						if(tempMap == null || tempMap.isEmpty()) {
							rowMap.put("OT1", "0");
							rowMap.put("OT2", "0");
							rowMap.put("OT3", "0");
							rowMap.put("OT4", "0");
							rowMap.put("OT5", "0");
							rowMap.put("OT6", "0");
							rowMap.put("OT7", "0");
						}
						else {
							rowMap.putAll(tempMap);
						}
						
						allCountList.add(rowMap);				
					}
	
					rowMap = new HashMap();
					rowMap.put("Date", setDate);
					setMap.put("dayId", setDate);
					setMap.put("region", "total");
					rowMap.put("Region", "Total");

					Map tempMap = commonService.select("custom_SQL.getMDVisitLogMemberValue", setMap);
					  
					if(tempMap == null || tempMap.isEmpty()) {
						rowMap.put("MEMBER", "0");
					}
					else {
						rowMap.put("MEMBER", tempMap.get("CON_COUNT"));
					}
					
					for(int k=0; k < itemNameList.size(); k++) {

		            	Map itemNameMap = (Map) itemNameList.get(k);
		            	String itemName = (String) itemNameMap.get("Identifier");
		            	setMap.put("itemCode",itemName);
		            	
						tempMap = commonService.select("custom_SQL.getMDVisitLogProcValue", setMap);
						  
						if(tempMap == null || tempMap.isEmpty()) {
							rowMap.put(itemName, "0");
						}
						else {
							rowMap.put(itemName, tempMap.get("CON_COUNT"));
						}
					}
					setMap.remove("itemCode");
					
					tempMap = commonService.select("custom_SQL.getMDVisitLogOtherValue", setMap);
					  
					if(tempMap == null || tempMap.isEmpty()) {
						rowMap.put("OT1", "0");
						rowMap.put("OT2", "0");
						rowMap.put("OT3", "0");
						rowMap.put("OT4", "0");
						rowMap.put("OT5", "0");
						rowMap.put("OT6", "0");
						rowMap.put("OT7", "0");
					}
					else {
						rowMap.putAll(tempMap);
					}
					
					allCountList.add(rowMap);
					
				}
			}
			else {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
				SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
				for (int i = 0; 7 > i ; i++) {
					
					// system date 부터  일주일의 visit log 취득
					// Date
					long date = System.currentTimeMillis() - ((long) 1000 * 60 * 60 * 24 * (i+1));
					if(i == 6)
						startDT = String.valueOf(formatter2.format(date));
					else if(i == 0)
						endDT = String.valueOf(formatter2.format(date));
					
					for(int j=0; j<regionList.size()  ; j++) {
	
						rowMap = new HashMap();
						regMap = (HashMap) regionList.get(j);
						setMap.put("dayId", formatter.format(date));
						setMap.put("region", regMap.get("DimValueID"));
						rowMap.put("Date", formatter.format(date));
						rowMap.put("Region", regMap.get("DimValueID"));

						Map tempMap = commonService.select("custom_SQL.getMDVisitLogMemberValue", setMap);
						  
						if(tempMap == null || tempMap.isEmpty()) {
							rowMap.put("MEMBER", "0");
						}
						else {
							rowMap.put("MEMBER", tempMap.get("CON_COUNT"));
						}
						
						for(int k=0; k < itemNameList.size(); k++) {

			            	Map itemNameMap = (Map) itemNameList.get(k);
			            	String itemName = (String) itemNameMap.get("Identifier");
			            	setMap.put("itemCode",itemName);
			            	
							tempMap = commonService.select("custom_SQL.getMDVisitLogProcValue", setMap);
							  
							if(tempMap == null || tempMap.isEmpty()) {
								rowMap.put(itemName, "0");
							}
							else {
								rowMap.put(itemName, tempMap.get("CON_COUNT"));
							}
						}
						setMap.remove("itemCode");
						
						tempMap = commonService.select("custom_SQL.getMDVisitLogOtherValue", setMap);
						  
						if(tempMap == null || tempMap.isEmpty()) {
							rowMap.put("OT1", "0");
							rowMap.put("OT2", "0");
							rowMap.put("OT3", "0");
							rowMap.put("OT4", "0");
							rowMap.put("OT5", "0");
							rowMap.put("OT6", "0");
							rowMap.put("OT7", "0");
						}
						else {
							rowMap.putAll(tempMap);
						}
						
						allCountList.add(rowMap);				
					}
	
					rowMap = new HashMap();
					rowMap.put("Date", formatter.format(date));
					setMap.put("dayId", formatter.format(date));
					setMap.put("region", "total");
					rowMap.put("Region", "Total");

					Map tempMap = commonService.select("custom_SQL.getMDVisitLogMemberValue", setMap);
					  
					if(tempMap == null || tempMap.isEmpty()) {
						rowMap.put("MEMBER", "0");
					}
					else {
						rowMap.put("MEMBER", tempMap.get("CON_COUNT"));
					}
					
					for(int k=0; k < itemNameList.size(); k++) {

		            	Map itemNameMap = (Map) itemNameList.get(k);
		            	String itemName = (String) itemNameMap.get("Identifier");
		            	setMap.put("itemCode",itemName);
		            	
						tempMap = commonService.select("custom_SQL.getMDVisitLogProcValue", setMap);
						  
						if(tempMap == null || tempMap.isEmpty()) {
							rowMap.put(itemName, "0");
						}
						else {
							rowMap.put(itemName, tempMap.get("CON_COUNT"));
						}
					}
					setMap.remove("itemCode");
					
					tempMap = commonService.select("custom_SQL.getMDVisitLogOtherValue", setMap);
					  
					if(tempMap == null || tempMap.isEmpty()) {
						rowMap.put("OT1", "0");
						rowMap.put("OT2", "0");
						rowMap.put("OT3", "0");
						rowMap.put("OT4", "0");
						rowMap.put("OT5", "0");
						rowMap.put("OT6", "0");
						rowMap.put("OT7", "0");
					}
					else {
						rowMap.putAll(tempMap);
					}
					
					allCountList.add(rowMap);
					
				}
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
	            if(i == 0 || i%(regSize+1)==0) {
		            cell = doc.createElement("cell"); 
		            cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("Date"))));
		            cell.setAttribute("rowspan", String.valueOf(regSize+1));
	                row.appendChild(cell);
	            }
	            else {
		            cell = doc.createElement("cell"); 
		            cell.appendChild(doc.createTextNode(String.valueOf("")));
	                row.appendChild(cell);
	            }
                
                // Region
                cell = doc.createElement("cell"); 
	            cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("Region"))));
                row.appendChild(cell);
                
                // Total 접속자수
                cell = doc.createElement("cell"); 
	            cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("MEMBER"))));
                row.appendChild(cell);
	            
	            for (int j = 0; itemNameList.size() > j ; j++) {
	            	Map itemNameMap = (Map) itemNameList.get(j);
	            	String itemName = (String) itemNameMap.get("Identifier");
	            	cell = doc.createElement("cell"); 
	            	cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get(itemName))));
	                row.appendChild(cell); 
	            }
	            for (int j = 0; processOtherNameList.size() > j ; j++) {
	            	Map itemNameMap = (Map) processOtherNameList.get(j);
	            	String itemName = itemNameMap.get("sort").toString();
	            	cell = doc.createElement("cell"); 
	            	cell.appendChild(doc.createTextNode(String.valueOf(countRowMap.get("OT"+itemName))));
	                row.appendChild(cell); 
	            }
	            
	        }

	        // XML 파일로 쓰기 
	        TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
	        Transformer transformer = transformerFactory.newTransformer(); 
	 
	        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
	        transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
	        DOMSource source = new DOMSource(doc); 
	        
	        Calendar cal = Calendar.getInstance();
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
			java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
			String sdate = sdf.format(cal.getTime());
			String stime = sdf2.format(cal.getTime());
			String mkFileNm = sdate+stime;
			String xmlFilName = "visitLogStatisticsGrid";
			
			xmlFilName = xmlFilName + mkFileNm;
			
	        StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + "upload/"+xmlFilName+".xml"))); 

	        transformer.transform(source, result); 
	        
			model.put("processRows", makeGridHeader(itemNameList, ","));
			model.put("processCols", makeGridHeader(itemNameList, "|"));
			model.put("processCnt", itemNameList.size());
			model.put("startDT", startDT);
			model.put("endDT", endDT);

			model.put("menu", getLabel(request, commonService));
	        model.put("xmlFilName", xmlFilName);
			
		}
		catch (Exception e) {
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/custom/mando/mdVisitLogRep");
	}

	private String makeGridHeader(List list, String conStr) {
		String strHeader = "";
		for (int i = 0; list.size() > i ; i++) {
			Map map = (Map) list.get(i);
        	String name = (String) map.get("Identifier");
        	
			strHeader = strHeader + conStr + name;
		}		
		return strHeader;
	}

	private String makeGridHeader(List list, String keyName ,String conStr) {
		String strHeader = "";
		for (int i = 0; list.size() > i ; i++) {
			Map map = (Map) list.get(i);
        	String name = (String) map.get(keyName);
        	
			strHeader = strHeader + conStr + name;
		}		
		return strHeader;
	}
	private Map getCountMap(List conutList) {
		Map contMap = new HashMap();
		Map mapValue = new HashMap();
		for(int i = 0; i < conutList.size(); i++){
			mapValue = (HashMap)conutList.get(i);
			contMap.put(mapValue.get("Identifier"), mapValue.get("CNT"));
		}
		
		return contMap;
	}
	
}
