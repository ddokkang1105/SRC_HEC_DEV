package xbolt.itm.dim.web;

import com.nimbusds.jose.shaded.json.JSONObject;
import com.org.json.JSONArray;
import com.org.json.JSONException;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@SuppressWarnings("unchecked")
public class DimensionActionControllerV4 extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;

	 
	 /**
	  * 개요 화면에서 [Dimension] 아이콘 클릭 이벤트
	  * @param request
	  * @param model
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/itemDimValueListMgt.do")
	 public String itemDimValueListMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		 String url = "/itm/dimension/itemDimValueListInfo";
		 try {
			 String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));

			 // 권한 체크
			 HashMap<String, String> map = new HashMap<>();
			 map.put("s_itemID", s_itemID);
			 String myItem = commonService.selectString("item_SQL.checkMyItem", map);

			 model.put("menu", getLabel(request, commonService));
			 model.put("s_itemID", s_itemID);
			 model.put("myItem", myItem);

		 } catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		 return nextUrl(url);
	}

	@RequestMapping(value = "/getItemDimValueListInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getItemDimValueListInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {

		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();

		List dimList = new ArrayList();
		boolean success = false;

		try {
			// parameter
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");

			// parameter check
			if (s_itemID.isEmpty()) throw new IllegalArgumentException("s_itemID is required.");
			if (languageID.isEmpty()) throw new IllegalArgumentException("languageID is required.");

			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", languageID);
			dimList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);

			success = true;
			resultMap.put("data", dimList);

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
	
	// ADMIN 화면에서 Dimension >> Dimension value 탭 클릭
	@RequestMapping(value="/dimValueListMgt.do")
	public String dimValueListMgt(HttpServletRequest request,HashMap commandMap,  ModelMap model) throws Exception{
		String url = "itm/dimension/dimValueList";		
		try{		
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			
			Map<String, Object> setMap = new HashMap<>();
			setMap.put("s_itemID",s_itemID);
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			
			List<?> prcList = commonService.selectList("report_SQL.getItemInfo", setMap);

			model.put("prcList", prcList);	
			model.put("s_itemID", s_itemID);			
			model.put("menu", getLabel(request, commonService));	
	
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/getDimValueListMgt.do", method = RequestMethod.GET)
	@ResponseBody
	public void getDimValueListMgt(HttpServletRequest request, HttpServletResponse response) throws Exception {

		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();

		List dimValueList = new ArrayList();
		boolean success = false;
		
		try {
			// parameter
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");

			// parameter check
			if (s_itemID.isEmpty()) throw new IllegalArgumentException("s_itemID is required.");
			if (languageID.isEmpty()) throw new IllegalArgumentException("languageID is required.");

			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", languageID);
			dimValueList = commonService.selectList("dim_SQL.selectDimList_gridList", setMap);

			success = true;
			resultMap.put("data", dimValueList);

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
	
	@RequestMapping(value="/admin/NewDimensionV4.do", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public String NewDimensionV4(HttpServletRequest request, HashMap commandMap) throws Exception {		
	    boolean success = false;
	    
	    String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
	    String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
	    
	    try {
	        Map<Object, Object> setMap = new HashMap<>();			
	        
	        
	        setMap.put("DimTypeID", s_itemID);
	        setMap.put("DimValueID", request.getParameter("dimValueID"));
	        setMap.put("Name", request.getParameter("dimValueName"));			
	        setMap.put("Level", "1");
	        setMap.put("ParentID", commonService.selectString("dim_SQL.getParentDimID", setMap));
	        
	        String dimDeleted = StringUtil.checkNull(request.getParameter("dimDeleted"), "false");
	        setMap.put("Deleted", dimDeleted.equals("true") ? "1" : "0");

	        String saveType = StringUtil.checkNull(request.getParameter("saveType"), "");
	        
	        if("Edit".equals(saveType)){
	            setMap.put("BeforeDimValueID", request.getParameter("BeforeDimValueID"));								
	            commonService.update("dim_SQL.editItemDim", setMap);
	            
	            setMap.put("LanguageID", languageID);
	            commonService.update("dim_SQL.updateDimTxt", setMap);
	        } else {
	            commonService.insert("dim_SQL.insertDimValue", setMap);
	            
	            List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);
	            for(int i = 0; i < getLanguageList.size(); i++){
	                Map getMap = (HashMap)getLanguageList.get(i);
	                setMap.put("LanguageID", getMap.get("CODE"));				
	                commonService.insert("dim_SQL.insertDimTxt", setMap);
	            }
	        }			

	        // 성공 결과 응답
	        String successMsg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"); // "저장 성공"
	        String encodedMsg = URLEncoder.encode(successMsg, "UTF-8");
	        return "{\"success\": true, \"message\": \"" + encodedMsg + "\"}";      
	    } catch (Exception e) {
	    	success = false;
			System.err.println(e);	   
			String errorMsg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"); // "오류 발생"
			String encodedMsg = URLEncoder.encode(errorMsg, "UTF-8");
	        return "{\"success\": false, \"message\": \"" + encodedMsg + "\"}";			
		}
	}	
	
	@RequestMapping(value="/admin/DelDimensionV4.do", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public String DelDimensionV4(HttpServletRequest request, HashMap commandMap) throws Exception {		
	    try {
	        Map<String, Object> setMap = new HashMap<>();
	        setMap.put("DimTypeID", request.getParameter("DimTypeID"));
	        setMap.put("DimValueID", request.getParameter("DimValueID"));
	        
	        // DB 삭제(업데이트) 실행
	        commonService.update("dim_SQL.delDimValue", setMap);
	        
	        // 마지막 데이터 처리 시 성공 메시지 반환
	        if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
	            String successMsg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069");
	            String encodedMsg = URLEncoder.encode(successMsg, "UTF-8").replaceAll("\\+", "%20");
	            return "{\"success\": true, \"message\": \"" + encodedMsg + "\"}";
	        }
	        
	        return "{\"success\": true}";
	    } catch (Exception e) {
	        System.out.println(e);
	        String errorMsg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070");
	        String encodedMsg = URLEncoder.encode(errorMsg, "UTF-8").replaceAll("\\+", "%20");
	        return "{\"success\": false, \"message\": \"" + encodedMsg + "\"}";
	    }
	}	
	
	@RequestMapping(value="/admin/deleteDimensionV4.do", produces = "application/json; charset=utf8")
	@ResponseBody
	public String deleteDimensionV4(HttpServletRequest request, HashMap commandMap) throws Exception {		
	    try {
	        Map<String, Object> setData = new HashMap<>();
	        String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
	        // 콤마로 구분된 ID들을 배열로 분리
	        String dimValueIDs[] = StringUtil.checkNull(request.getParameter("dimValueIDs")).split(",");
	        
	        for(int i=0; i < dimValueIDs.length; i++) {
	            String dimValueID = StringUtil.checkNull(dimValueIDs[i]);
	            setData.put("DimTypeID", dimTypeID);
	            setData.put("DimValueID", dimValueID);
	            
	            // 실제 삭제 쿼리들 실행
	            commonService.update("dim_SQL.delSubDimValue", setData);
	            commonService.update("dim_SQL.deleteDimValue", setData);
	            commonService.update("dim_SQL.deleteDimTxt", setData);	
	        }
	        
	        // 성공 메시지 인코딩
	        String successMsg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069");
	        String encodedMsg = URLEncoder.encode(successMsg, "UTF-8").replaceAll("\\+", "%20");
	        
	        return "{\"success\": true, \"message\": \"" + encodedMsg + "\"}";
	    }
	    catch (Exception e) {
	        e.printStackTrace();
	        // 실패 메시지 인코딩
	        String errorMsg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070");
	        String encodedMsg = URLEncoder.encode(errorMsg, "UTF-8").replaceAll("\\+", "%20");
	        
	        return "{\"success\": false, \"message\": \"" + encodedMsg + "\"}";
	    }
	}
	
	@RequestMapping(value="/admin/DelSubDimensionV4.do", produces = "application/json; charset=utf8")
	@ResponseBody
	public String DelSubDimensionV4(HttpServletRequest request, HashMap commandMap) throws Exception {		
	    try {
	        Map<String, Object> setData = new HashMap<>();
	        String dimTypeId = StringUtil.checkNull(request.getParameter("dimTypeId"));
	        String dimValueId = StringUtil.checkNull(request.getParameter("dimValueId"));
	        String items[] = StringUtil.checkNull(request.getParameter("items")).split(",");
	        
	        for(int i=0; i < items.length; i++) {
	            setData.put("DimTypeID", dimTypeId);
	            setData.put("DimValueID", dimValueId);
	            setData.put("s_itemID", items[i]); // 선택된 각 Item 삭제
	            
	            // 실제 삭제 서비스 호출 (기존 mapper ID에 맞춰 수정 필요할 수 있음)
	            commonService.update("dim_SQL.delSubDimValue", setData);
	        }
	        
	        String successMsg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"); // 삭제 성공
	        String encodedMsg = URLEncoder.encode(successMsg, "UTF-8").replaceAll("\\+", "%20");
	        
	        return "{\"success\": true, \"message\": \"" + encodedMsg + "\"}";
	    } catch (Exception e) {
	        e.printStackTrace();
	        String errorMsg = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070"); // 삭제 오류
	        String encodedMsg = URLEncoder.encode(errorMsg, "UTF-8").replaceAll("\\+", "%20");
	        return "{\"success\": false, \"message\": \"" + encodedMsg + "\"}";
	    }
	}
	
	
}
