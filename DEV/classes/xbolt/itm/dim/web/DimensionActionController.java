package xbolt.itm.dim.web;

import com.org.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.File;
import java.io.FileOutputStream;
import java.util.*;



/**
 * 업무 처리
 * @Class Name : BizController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class DimensionActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value="/dimensionList.do")
	public String objectReportList(HttpServletRequest request, ModelMap model) throws Exception{		
		String url = "itm/dimension/dimensionList";		
		try{			
			String s_itemID = s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			
			model.put("s_itemID", s_itemID);
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);
	}	
	@RequestMapping(value="/ProcessDimensionList.do")
	public String ProcessDimensionList(HttpServletRequest request,HashMap commandMap,  ModelMap model) throws Exception{
		String url = "itm/dimension/dimensionItemList";		
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
			
			commandMap.put("s_itemID", s_itemID);
			commandMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			List<String> dmList = commonService.selectList("dim_SQL.selectDimList_gridList",commandMap);
			JSONArray gridData = new JSONArray(dmList);
			model.put("gridData", gridData);
		
			
			 Map<String, Object> subMap = new HashMap<>();
			 subMap.put("dimTypeID",s_itemID); 
			 subMap.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"),""));
			 subMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"),"")); 
			 subMap.put("v",StringUtil.checkNull(request.getParameter("v"),""));
			 subMap.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue"),"")); List<String>
			 dmSubList =commonService.selectList("dim_SQL.selectDimPertinentDetailList_gridList",subMap); JSONArray gridSubData = new JSONArray(dmSubList);
			 model.put("gridSubData", gridSubData);
			 
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);
	}

	@RequestMapping(value="/userDimension.do")
	public String userDimension(HttpServletRequest request, ModelMap model) throws Exception{
		String url = "adm/user/userProcessDimension";		
		try{		
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
					
			model.put("s_itemID", s_itemID);			
			model.put("menu", getLabel(request, commonService));			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/admin/NewDimension.do")
	public String NewDimension(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			Map setMap = new HashMap();			
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			//TB_DIM_VALUE_TXT
			setMap.put("DimTypeID", s_itemID);
			//setMap.put("DimValueID", commonService.selectString("dim_SQL.getMaxDimValueID", setMap));			
			setMap.put("DimValueID", request.getParameter("dimValueID"));
			setMap.put("Name", request.getParameter("dimValueName"));			
			setMap.put("Level", "1");
			setMap.put("ParentID", commonService.selectString("dim_SQL.getParentDimID", setMap));
			if(StringUtil.checkNull(request.getParameter("dimDeleted"),"false").equals("true")){
				setMap.put("Deleted", "1");
			}else{setMap.put("Deleted", "0");}
			if(StringUtil.checkNull(request.getParameter("saveType"), "").equals("Edit")){
				setMap.put("BeforeDimValueID", request.getParameter("BeforeDimValueID"));								
				commonService.update("dim_SQL.editItemDim", setMap);				
			}else{
				/*
				 * if(StringUtil.checkNull(request.getParameter("dimDeleted"),"false").equals(
				 * "true")){ setMap.put("Deleted", "1"); }else{ setMap.put("Deleted", "0"); }
				 */	
				commonService.insert("dim_SQL.insertDimValue", setMap);
			}	
			
			if(StringUtil.checkNull(request.getParameter("saveType"), "").equals("Edit")){
				setMap.put("BeforeDimValueID", request.getParameter("BeforeDimValueID"));
				setMap.put("LanguageID", request.getParameter("languageID"));
				
				commonService.update("dim_SQL.updateDimTxt", setMap);	
			}else{
				List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);
				for(int i = 0; i < getLanguageList.size(); i++){
					Map getMap = (HashMap)getLanguageList.get(i);
					setMap.put("LanguageID", getMap.get("CODE") );				
					commonService.insert("dim_SQL.insertDimTxt", setMap);
				}				
			}			
			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.fnReload();this.$('#isSubmit').remove();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/admin/DelDimension.do")
	public String DelDimension(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			Map setMap = new HashMap();
			//TB_DIM_VALUE_TXT
			setMap.put("DimTypeID", request.getParameter("DimTypeID"));
			setMap.put("DimValueID", request.getParameter("DimValueID"));				
			commonService.update("dim_SQL.delDimValue", setMap);				
			if(StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")){
				//target.put(AJAX_ALERT, "삭제가 성공하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			}			
			target.put(AJAX_SCRIPT, "this.fnReload();this.$('#isSubmit').remove();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, "삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/admin/deleteDimension.do")
	public String deleteDimension(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			
			Map setData = new HashMap();
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
			String dimValueIDs[] = StringUtil.checkNull(request.getParameter("dimValueIDs")).split(",");
			String dimValueID = "";
			for(int i=0; dimValueIDs.length > i; i++){
				dimValueID = StringUtil.checkNull(dimValueIDs[i]);
				setData.put("DimTypeID", dimTypeID);
				setData.put("DimValueID", dimValueID);
				
				commonService.update("dim_SQL.delSubDimValue", setData);
				commonService.update("dim_SQL.deleteDimValue", setData);
				commonService.update("dim_SQL.deleteDimTxt", setData);	
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			target.put(AJAX_SCRIPT, "this.fnReload();this.$('#isSubmit').remove();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * delete Dimension [admin]
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/admin/DelSubDimension.do")
	public String DelSubDimension(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();  
		try{
			
			Map setMap = new HashMap();
	   
			String items = request.getParameter("items").toString();
			String dimTypeID = request.getParameter("dimTypeId").toString();
			String dimValueID = request.getParameter("dimValueId").toString();
			
			String[] arrayItems = items.split(",");
			
			for (int i = 0; i < arrayItems.length; i++) {
				String itemID = arrayItems[i];
				/* DELETE TB_ITEM_DIM_TREE
				// Connection ItemID 취득, NodeID 설정
				List<String> connectionIdList = new ArrayList<String>();
		   
				// 삭제 대상의 ItemId의 Connection ItemID 중  TB_ITEM_DIM record가 존재하는 data를 취득
				List<String> itemDimIdList  = new ArrayList<String>();
				DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
				DimTreeAdd.getExistItemDimId(commonService, itemDimIdList, connectionIdList, dimTypeID, dimValueID);
			   
				connectionIdList = new ArrayList<String>();
				DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeID, dimValueID, connectionIdList, 0);
				DimTreeAdd.getExistItemDimId(commonService, itemDimIdList, connectionIdList, dimTypeID, dimValueID);
			   
				// 삭제 대상의 ItemId의 Connection ItemID를 TB_ITEM_DIM_TREE 테이블에서 모두 삭제
				connectionIdList = new ArrayList<String>();
				DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
				DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeID, dimValueID, connectionIdList, 1);
			   
				setMap.put("DimTypeID", dimTypeID);
				setMap.put("DimValueID", dimValueID);
				for (String connectionId : connectionIdList) {
					setMap.put("NodeID", connectionId);
					commonService.delete("dim_SQL.delSubDimTree", setMap); 
				}
		
				// 삭제 대상의 ItemId의 Connection ItemID 중  TB_ITEM_DIM record가 존재하는 data의 TB_ITEM_DIM_TREE record를 INSERT
				itemDimIdList.remove(itemID);
				if (itemDimIdList.size() != 0) {
					//Map commandMap = new HashMap();
			    
					for (int j = 0; j < itemDimIdList.size(); j++) {
						String itemDimId = itemDimIdList.get(j);
						// ItemID의 ItemTypeCode, ClassCode 취득 
						commandMap.put("ItemID", itemDimId);  
						List itemInfoList = (List) commonService.selectList("dim_SQL.getItemTypeCodeAndClassCode", commandMap);
						Map itemInfoMap = (Map) itemInfoList.get(0);
						String itemTypeCode = itemInfoMap.get("ItemTypeCode").toString();
			     
						connectionIdList = new ArrayList<String>();
			     
						DimTreeAdd.getOverConnectionId(commonService, itemDimId, dimTypeID, dimValueID, connectionIdList, 0);
						DimTreeAdd.getUnderConnectionId(commonService, itemDimId, connectionIdList);
			     
						// connectionId list분, TB_ITEM_DIM_TREE record 입력
						// 단, 이미 존재하는 record 인 경우, INSERT skip
						commandMap.put("DimTypeID", dimTypeID);
						commandMap.put("DimValueID", dimValueID);
						commandMap.put("ItemTypeCode", itemTypeCode);
						DimTreeAdd.insertToTbItemDimTree(commonService, connectionIdList, commandMap);
					}
			    
				}  */
			   
			   /* DELETE TB_ITEM_DIM */
			   setMap.put("DimTypeID", dimTypeID);
			   setMap.put("DimValueID", dimValueID);    
			   setMap.put("s_itemID", itemID);   
			   commonService.delete("dim_SQL.delSubDimValue", setMap); 
			}
	   
		   target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
		   target.put(AJAX_SCRIPT, "this.doSearchList2('"+ dimValueID +"','"+dimTypeID+"');this.$('#isSubmit').remove();");

	  } catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  //target.put(AJAX_ALERT, "삭제중 오류가 발생하였습니다.");
		  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
	  }
		 model.addAttribute(AJAX_RESULTMAP, target);
		 return nextUrl(AJAXPAGE);
	 }
	 
	 
	 @RequestMapping(value="/admin/NewSubDimension.do") 
	 public String NewSubDimension(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{  
		 HashMap target = new HashMap();  
		 try{
			
			 Map setMap = new HashMap(); 
			 //Map commandMap = new HashMap(); 
	   
			 String itemID = request.getParameter("s_itemID");
			 String dimTypeID = request.getParameter("DimTypeID");
			 String dimValueID = request.getParameter("DimValueID");
	   
			 // ItemID의 ItemTypeCode, ClassCode 취득 
			 commandMap.put("ItemID", itemID);  
			 List itemInfoList = (List) commonService.selectList("dim_SQL.getItemTypeCodeAndClassCode", commandMap);
			 Map itemInfoMap = (Map) itemInfoList.get(0);
			 String itemTypeCode = itemInfoMap.get("ItemTypeCode").toString();
			 String itemClassCode = itemInfoMap.get("ClassCode").toString();
	   
			 // INSERT TB_ITEM_DIM 
			 setMap.put("ItemTypeCode", itemTypeCode);
			 setMap.put("ItemClassCode", itemClassCode);
			 setMap.put("ItemID", itemID);
			 setMap.put("DimTypeID", dimTypeID); 
			 setMap.put("DimValueID", dimValueID);   
			 commonService.insert("dim_SQL.insertItemDim", setMap);
	   
			 /*/ INSERT TB_ITEM_DIM_TREE
	   
			 // Connection ItemID 취득, NodeID 설정
			 List<String> connectionIdList = new ArrayList<String>();
	   
			 DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeID, dimValueID, connectionIdList, 0);
			 DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
	   
			 // connectionId list분, TB_ITEM_DIM_TREE record 입력
			 // 단, 이미 존재하는 record 인 경우, INSERT skip
			 DimTreeAdd.insertToTbItemDimTree(commonService, connectionIdList, setMap);
			 */
	   
			 if(StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")){
				 target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				 target.put(AJAX_SCRIPT, "this.addClose('"+ dimValueID +"');this.$('#isSubmit').remove();");
			 } else {
				 target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();");
			 }
	   
	  }catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  //target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
		  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생

	  }
		 model.addAttribute(AJAX_RESULTMAP, target);
		 return nextUrl(AJAXPAGE);
	 }
	 
	 /**
	  * 개요 화면에서 [Dimension] 아이콘 클릭 이벤트
	  * @param request
	  * @param model
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/dimListForItemInfo.do")
	 public String dimListForItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		 String url = "/itm/dimension/dimListForItemInfo";
		 try {
			 List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
			 String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			 String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));
			 String dimTypeId = StringUtil.checkNull(commandMap.get("dimTypeId"));
			 String dimValueId = StringUtil.checkNull(commandMap.get("dimValueId"));

			 commandMap.put("languageID", languageID);
			 commandMap.put("s_itemID", s_itemID);
		     commandMap.put("dimTypeId", dimTypeId);
		     commandMap.put("dimValueId", dimValueId);
	         List dimListForItemIFList = commonService.selectList("dim_SQL.selectDim_gridList", commandMap);
	         JSONArray gridData = new JSONArray(dimListForItemIFList);
	         model.put("gridData",gridData);	 
	        
			 model.put("menu", getLabel(request, commonService));
			 model.put("s_itemID", request.getParameter("s_itemID"));
			 model.put("myItem", request.getParameter("myItem"));
			 model.put("dimTypeList", dimTypeList);
			 model.put("backBtnYN", request.getParameter("backBtnYN"));
				
		 } catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		 return nextUrl(url);
	}
		
	 @RequestMapping(value = "/viewItemDimDesc.do")
	 public String viewItemDimDesc(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		 String url = "/itm/dimension/viewItemDimDesc";
		Map setMap = new HashMap();
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String dimTypeId = StringUtil.checkNull(request.getParameter("dimTypeId"));
			String dimValueId = StringUtil.checkNull(request.getParameter("dimValueId"));
			setMap.put("s_itemID",s_itemID);
			setMap.put("dimValueId",dimValueId);
			setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			
			Map dimInfo = commonService.select("dim_SQL.selectDim_gridList", setMap);
			String authorID = commonService.selectString("item_SQL.getItemAuthorId", setMap);
			
			model.put("s_itemID",s_itemID);
			model.put("dimTypeId",dimTypeId);
			model.put("dimValueId",dimValueId);
			model.put("dimInfo",dimInfo);
			model.put("authorID",authorID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/saveItemDim.do")
	public String SaveFileType(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeId"));
			String dimValueID = StringUtil.checkNull(request.getParameter("dimValueId"));
			String description = StringUtil.checkNull(request.getParameter("description"));
			setMap.put("itemID", itemID);
			setMap.put("dimTypeID", dimTypeID);
			setMap.put("dimValueID", dimValueID);
			setMap.put("description", description);
			
			commonService.update("dim_SQL.updateItemDim", setMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
			target.put(AJAX_SCRIPT,"parent.fnCallBack();this.$('#isSubmit').remove();"); // 성공

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
	}
		
    /**
	  * Dimension 화면에서 [Assign] 클릭 이벤트
	  * @param request
	  * @param model
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/selectDimensionPop.do")
    public String selectDimensionPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		 String url = "/itm/dimension/selectDimensionPop";
		 try {
			 
			 List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);
			 
			 model.put("menu", getLabel(request, commonService));
			 model.put("s_itemID", request.getParameter("s_itemID"));
			 model.put("dimTypeList", dimTypeList);
				
		 } catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		 }
			return nextUrl(url);
	}

	@RequestMapping(value="/getDimensionSubLevel.do")
    public String getDimensionSubLevel(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		 String url = "/itm/dimension/dimSubLevelList";
		 try {
			 Map setMap = new HashMap();
			 String dimTypeID = StringUtil.checkNull(commandMap.get("dimTypeID"),"");					
			 String dimValueID = StringUtil.checkNull(commandMap.get("dimValueID"),"");			
			 String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			 
			 setMap.put("dimTypeID",dimTypeID);
			 setMap.put("dimValueID",dimValueID);
			 setMap.put("languageID",languageID);
			 
			 String dimValuePath = commonService.selectString("dim_SQL.getDimValuePath", setMap);
			 
			 model.put("menu", getLabel(request, commonService));
			 model.put("dimTypeID", dimTypeID);
			 model.put("dimValueID", dimValueID);
			 model.put("dimValuePath", dimValuePath);
			 
			
//				commandMap.put("dimTypeID", dimTypeID);
//				commandMap.put("DimValueID", StringUtil.checkNull(request.getParameter("dimValueID"),""));
//				commandMap.put("languageID", languageID);
//				commandMap.put("ItemClassCode", StringUtil.checkNull(request.getParameter("newClassCode"),""));
//				commandMap.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue"),""));
//				List<String> dmSubList = commonService.selectList("dim_SQL.selectDimPertinentDetailList_gridList",commandMap);
//				
//				JSONArray subGridData = new JSONArray(dmSubList);
//				
//				System.out.println("GridDataSub : "+subGridData);
//				model.put("subGridData",subGridData );

				
		 } catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		 }
			return nextUrl(url);
	}
	
	
    /**
	 * Dimension Assign Poup 화면에서 [Add] 클릭 이벤트
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="/addDimensionForItem.do")
    public String addDimensionForItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
    	HashMap target = new HashMap();

		try {
			 
			Map setMap = new HashMap(); 
			
			String itemID = request.getParameter("s_itemID");
			String dimValueIds = StringUtil.checkNull(request.getParameter("ids"));

			String[] arrayDimValueIds = dimValueIds.split(",");

			for (int i = 0; i < arrayDimValueIds.length; i++) {
				
				String dimValueID = arrayDimValueIds[i];
				String[] dimInfo = dimValueID.split("/");
		   
				// ItemID의 ItemTypeCode, ClassCode 취득 
				if(dimInfo.length > 1) {
					
					
					commandMap.put("ItemID", itemID);  
					List itemInfoList = (List) commonService.selectList("dim_SQL.getItemTypeCodeAndClassCode", commandMap);
					Map itemInfoMap = (Map) itemInfoList.get(0);
					String itemTypeCode = itemInfoMap.get("ItemTypeCode").toString();
					String itemClassCode = itemInfoMap.get("ClassCode").toString();
					
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					setMap.put("itemID", dimInfo[0]);
					setMap.put("attrTypeCode", "AT00074");

					String maxLevel = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setMap),"1");
					
					setMap.put("dimTypeID", dimInfo[0]); 
					setMap.put("dimValueID", dimInfo[1]);   
					
					String dimLevel = commonService.selectString("dim_SQL.getDimensionLevel", setMap);
					
					if(dimLevel.equals(maxLevel)) {
						
						setMap.put("ItemTypeCode", itemTypeCode);
						setMap.put("ItemClassCode", itemClassCode);
						setMap.put("ItemID", itemID);
						setMap.put("DimTypeID", dimInfo[0]); 
						setMap.put("DimValueID", dimInfo[1]);   
						setMap.put("Creator", commandMap.get("sessionUserId"));
						commonService.insert("dim_SQL.insertItemDim", setMap);
							
						/*/INSERT TB_ITEM_DIM_TREE
				   
						// Connection ItemID 취득, NodeID 설정
						List<String> connectionIdList = new ArrayList<String>();
				   
						DimTreeAdd.getOverConnectionId(commonService, itemID, dimInfo[0], dimInfo[1], connectionIdList, 0);
						DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
				   
						// connectionId list분, TB_ITEM_DIM_TREE record 입력
						// 단, 이미 존재하는 record 인 경우, INSERT skip
						DimTreeAdd.insertToTbItemDimTree(commonService, connectionIdList, setMap);
					
						// INSERT TB_MY_DIM_VALUE
						if(pageFrom.equals("User")){
						commonService.insert("dim_SQL.insertMyDim", setMap);
						}    */
				   
					}
				}
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "this.assignClose();this.$('#isSubmit').remove();");
				
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
    
    /**
	 * Dimension 화면에서 [Del] 클릭 이벤트
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="/delDimensionForItem.do")
	public String delDimensionForItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();
		String alertType = StringUtil.checkNull(request.getParameter("alertType"), "");

		try{
			Map setMap = new HashMap();
			
			String itemID = request.getParameter("s_itemID");
			String dimTypeIds = StringUtil.checkNull(request.getParameter("dimTypeIds"));
			String dimValueIds = StringUtil.checkNull(request.getParameter("dimValueIds"));

			String[] arrayDimTypeIds = dimTypeIds.split(",");
			String[] arrayDimValueIds = dimValueIds.split(",");
			
			for (int i = 0; i < arrayDimTypeIds.length; i++) {
				String dimTypeID = arrayDimTypeIds[i];
				String dimValueID = arrayDimValueIds[i];
				/* TB_ITEM_DIM_TREE Insert, Delete 기능 제거 
				// DELETE TB_ITEM_DIM_TREE 
				// Connection ItemID 취득, NodeID 설정
				List<String> connectionIdList = new ArrayList<String>();
		   
				// 삭제 대상의 ItemId의 Connection ItemID 중  TB_ITEM_DIM record가 존재하는 data를 취득
				List<String> itemDimIdList  = new ArrayList<String>();
				DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
				DimTreeAdd.getExistItemDimId(commonService, itemDimIdList, connectionIdList, dimTypeID, dimValueID);
			   
				connectionIdList = new ArrayList<String>();
				DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeID, dimValueID, connectionIdList, 0);
				DimTreeAdd.getExistItemDimId(commonService, itemDimIdList, connectionIdList, dimTypeID, dimValueID);
			   
				// 삭제 대상의 ItemId의 Connection ItemID를 TB_ITEM_DIM_TREE 테이블에서 모두 삭제
				connectionIdList = new ArrayList<String>();
				DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
				DimTreeAdd.getOverConnectionId(commonService, itemID, dimTypeID, dimValueID, connectionIdList, 1);
			   
				setMap.put("DimTypeID", dimTypeID);
				setMap.put("DimValueID", dimValueID);
				for (String connectionId : connectionIdList) {
					setMap.put("NodeID", connectionId);
					commonService.delete("dim_SQL.delSubDimTree", setMap); 
				}
		
				// 삭제 대상의 ItemId의 Connection ItemID 중  TB_ITEM_DIM record가 존재하는 data의 TB_ITEM_DIM_TREE record를 INSERT
				itemDimIdList.remove(itemID);
				if (itemDimIdList.size() != 0) {
					//Map commandMap = new HashMap();
			    
					for (int j = 0; j < itemDimIdList.size(); j++) {
						String itemDimId = itemDimIdList.get(j);
						// ItemID의 ItemTypeCode, ClassCode 취득 
						commandMap.put("ItemID", itemDimId);  
						List itemInfoList = (List) commonService.selectList("dim_SQL.getItemTypeCodeAndClassCode", commandMap);
						Map itemInfoMap = (Map) itemInfoList.get(0);
						String itemTypeCode = itemInfoMap.get("ItemTypeCode").toString();
			     
						connectionIdList = new ArrayList<String>();
			     
						DimTreeAdd.getOverConnectionId(commonService, itemDimId, dimTypeID, dimValueID, connectionIdList, 0);
						DimTreeAdd.getUnderConnectionId(commonService, itemDimId, connectionIdList);
			     
						// connectionId list분, TB_ITEM_DIM_TREE record 입력
						// 단, 이미 존재하는 record 인 경우, INSERT skip
						commandMap.put("DimTypeID", dimTypeID);
						commandMap.put("DimValueID", dimValueID);
						commandMap.put("ItemTypeCode", itemTypeCode);
						DimTreeAdd.insertToTbItemDimTree(commonService, connectionIdList, commandMap);
					}
			    
				}*/
			   
				 /* DELETE TB_ITEM_DIM */
				   setMap.put("DimTypeID", dimTypeID);
				   setMap.put("DimValueID", dimValueID);    
				   setMap.put("s_itemID", itemID);   
				   commonService.delete("dim_SQL.delSubDimValue", setMap); 
			}

			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			}
			target.put(AJAX_SCRIPT, "this.doSearchList();this.$('#isSubmit').remove();");
			
	  } catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  //target.put(AJAX_ALERT, "삭제중 오류가 발생하였습니다.");
			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
			}
	  }
		model.addAttribute(AJAX_RESULTMAP, target);
        return nextUrl(AJAXPAGE);
    }
	
    
    /**
	  * Dimension Item 검색
	  * @param request
	  * @param model
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/mDimItemSearch.do")
   public String mDimItemSearch(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		 String url = "/itm/dimension/mDimItemSearch";
		 String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
		 List itemTypeCodeList = new ArrayList();
		 try {
			 Map setData = new HashMap();
			 String itemTypeCodes = "";
			 String itemTypeCode = StringUtil.checkNull(commandMap.get("defItemTypeCode"));
			  
			 if(itemTypeCode.equals("")) {
				 itemTypeCodeList = (List) commonService.selectList("dim_SQL.getItemTypeCodeList", setData);
			 }else {
				 itemTypeCodeList = Arrays.asList(itemTypeCode.split(","));
			 }
			 
			 for(int k=0; k<itemTypeCodeList.size(); k++) {
				 if(k==0){
					 itemTypeCodes = "'" + StringUtil.checkNull(((Map)itemTypeCodeList.get(k)).get("CODE")) + "'";
				 }else{
					 itemTypeCodes = itemTypeCodes + ",'" +StringUtil.checkNull(((Map)itemTypeCodeList.get(k)).get("CODE")) + "'";
				 }
			 }
			 String title = "";
			 setData.put("arcCode", commandMap.get("arcCode"));
			 setData.put("languageID", languageID);
			 Map arcInfo = commonService.select("menu_SQL.getArcInfo", setData);
			 title =  StringUtil.checkNull(arcInfo.get("ArcName"));
			 if(title.equals("")) {
				 setData.put("MenuID", commandMap.get("arcCode"));
				 arcInfo = commonService.select("config_SQL.getDefineMenutypeCode_gridList", setData);
				 title = StringUtil.checkNull(arcInfo.get("MenuName"));
			 }
			 
			 model.put("title", title);
			 
			 setData.put("itemTypeCodes",itemTypeCodes);
			 List itemDimNameList = (List) commonService.selectList("dim_SQL.getItemDimNameList", setData);
			 List dimTypeNameList = (List) commonService.selectList("dim_SQL.getDimTypeNameList", setData);
			 model.put("defItemTypeCode", StringUtil.checkNull(((Map)itemTypeCodeList.get(0)).get("CODE")));
			 model.put("itemTypeCode", commandMap.get("itemTypeCode"));
			 model.put("itemDimNameList", itemDimNameList);
			 model.put("dimTypeNameList", dimTypeNameList);
			 model.put("itemTypeCodeList", itemTypeCodeList);
			 
			 model.put("menu", getLabel(request, commonService));
				
		 } catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		 }
			return nextUrl(url);
	}
	
	@RequestMapping(value="/mDimItemSearchXml.do")
	   public String mDimItemSearchXml(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{

		 Map target = new HashMap();
			 try {
				 String dimDataS = StringUtil.checkNull(request.getParameter("dimData"));
				 List<Map<String,Object>> dimData = new ArrayList<Map<String,Object>>();
				  dimData = net.sf.json.JSONArray.fromObject(dimDataS);
				 //dimData = JSONArray.fromObject(dimDataS);
				 //JSONArray.
					String dimTypeID = "", dimValueID ="";
					List dimDataList = new ArrayList();
					 Map temp = new HashMap();
					
					 for(int i=0; i<dimData.size();i++) {
						dimTypeID = StringUtil.checkNull((dimData.get(i)).get("dimTypeID"));
						dimValueID = StringUtil.checkNull((dimData.get(i)).get("dimValueID"));
						temp = new HashMap();
						temp.put("dimTypeID",dimTypeID);
						temp.put("dimValueID",((List)(dimData.get(i)).get("dimValueID")));
						dimDataList.add(temp);
					 }
					 commandMap.put("dimData", dimDataList);
				 String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
				 List dimSearchList = (List) commonService.selectList("dim_SQL.getDimSearchList_gridList", commandMap);
				 String filepath = request.getSession().getServletContext().getRealPath("/");
				 setDimItemSearchXml(dimSearchList, filepath, languageID, "upload/dimSearchListXml.xml");
				 target.put(AJAX_SCRIPT, "this.loadXml("+dimSearchList.size()+");this.$('#isSubmit').remove();");
			 } catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
				throw new ExceptionUtil(e.toString());
			 }
			 model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
		}	
	
	private void setDimItemSearchXml(List dimSearchList, String filepath, String languageID, String xmlFilName ) throws Exception {
		/* xml 파일 존재 할 경우 삭제 */
		File oldFile = new File(filepath + xmlFilName);
		if (oldFile.exists()) {
			oldFile.delete();
		}
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		
		// 루트 엘리먼트 
		Document doc = docBuilder.newDocument(); 
		Element rootElement = doc.createElement("rows"); 
		doc.appendChild(rootElement); 
		
		Map setMap = new HashMap();
		
		
		Element row, cell;
		String RNUM, itemID, itemName, itemPath, dimension, ItemTypeImg;
		String Identifier, itemTypeName, authorName, teamName, statusName, fileIcon, LastUpdated, Status;
		
		Map dimData;
		String descriptionText = "";
		for (int i = 0; i < dimSearchList.size(); i++) {
			dimData = (Map)dimSearchList.get(i);
			descriptionText = "";
			
			row = doc.createElement("row"); 
			rootElement.appendChild(row); 
			/*
			cell = doc.createElement("cell");
			elmInstMap = (Map) dimSearchList.get(i);
			RNUM = StringUtil.checkNull(elmInstMap.get("RNUM"));
			row.setAttribute("id", String.valueOf(RNUM));
			*/
			RNUM = StringUtil.checkNull(dimData.get("RNUM"));
			itemID = StringUtil.checkNull(dimData.get("ItemID"));
			itemName = StringUtil.checkNull(dimData.get("ItemName"));
			itemPath = StringUtil.checkNull(dimData.get("ItemPath"));
			ItemTypeImg = StringUtil.checkNull(dimData.get("ItemTypeImg"));
			Identifier = StringUtil.checkNull(dimData.get("Identifier"));
			itemTypeName = StringUtil.checkNull(dimData.get("itemTypeName"));
			authorName = StringUtil.checkNull(dimData.get("authorName"));
			teamName = StringUtil.checkNull(dimData.get("teamName"));
			statusName = StringUtil.checkNull(dimData.get("statusName"));
			fileIcon = StringUtil.checkNull(dimData.get("fileIcon"));
			LastUpdated = StringUtil.checkNull(dimData.get("LastUpdated"));
			Status = StringUtil.checkNull(dimData.get("Status"));
			
			
			cell = doc.createElement("cell");
			row.setAttribute("id", String.valueOf(RNUM));
			
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(RNUM));
			row.appendChild(cell); 
			
			//itemID
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(itemID));
			row.appendChild(cell);
			
			//ItemTypeImg
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(ItemTypeImg));
			row.appendChild(cell); 
			
			//Identifier
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(Identifier));
			row.appendChild(cell); 
			
			//ItemName
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(itemName));
			row.appendChild(cell); 
			
			//itemTypeName
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(itemTypeName));
			row.appendChild(cell); 
			
			//itemTypeName
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(teamName));
			row.appendChild(cell); 
			
			//authorName
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(authorName));
			row.appendChild(cell); 
			
			//LastUpdated
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(LastUpdated));
			row.appendChild(cell); 
			
			//statusName
			cell = doc.createElement("cell");
			String StatusNameHtml = "";
			if(Status.equals("NEW1")) {
				StatusNameHtml = "<span style=color:blue;font-weight:bold>" + statusName + "</span>";
			}else if(Status.equals("MOD1")) {
				StatusNameHtml = "<span style=color:orange;font-weight:bold>" + statusName + "</span>";
			}else if(Status.equals("MOD2")) {
				StatusNameHtml = "<span style=color:orange;font-weight:bold>" + statusName + "</span>";
			}
			cell.appendChild(doc.createTextNode(StatusNameHtml));
			row.appendChild(cell);
			
			//fileIcon
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(fileIcon));
			row.appendChild(cell); 
		}
		
		TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
		Transformer transformer = transformerFactory.newTransformer(); 
		
		transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
		transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
		DOMSource source = new DOMSource(doc); 
		
		StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
		transformer.transform(source, result); 
	}
	
	@RequestMapping(value="/saveDimSubLevelGridData.do")
	public String saveDimSubLevelGridData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{					
			String ids[] = request.getParameter("ids").split(",");
			Map setData = new HashMap();
			String gridStatus = "";
			String dimTypeID = "";
			String dimValueID = "";
			String orgDimValueID = "";
			String dimValueName = "";
			String parentID = "";
			String isExistDimValue = "";
			for(int i=0; i<ids.length; i++){
				// System.out.println("ids ["+i+"] :::> "+ids[i]+" Row ::::row status:"+request.getParameter(ids[i]+"_!nativeeditor_status") );
				gridStatus = StringUtil.checkNull(request.getParameter(ids[i]+"_!nativeeditor_status"),"");
				dimValueID = StringUtil.checkNull(request.getParameter(ids[i]+"_c2"),"");  // P1101
				dimValueName = StringUtil.checkNull(request.getParameter(ids[i]+"_c3"),""); // 꼬마카레왕
				orgDimValueID = StringUtil.checkNull(request.getParameter(ids[i]+"_c4"),"");
				dimTypeID = StringUtil.checkNull(request.getParameter(ids[i]+"_c5"),"");
				parentID = StringUtil.checkNull(request.getParameter(ids[i]+"_c6"),"");

				/*System.out.println("gridStatus :"+gridStatus+", ProcInstNo :"+ProcInstNo+", startTime: "+startTime+", endTime : "+endTime);
				System.out.println("status  : "+status+", ownerID : "+ownerID+", ownerTeamID :"+ownerTeamID+", chk :"+chk+" , processID :"+processID);*/

				setData.put("DimValueID", dimValueID);
				setData.put("BeforeDimValueID", orgDimValueID);
				setData.put("DimTypeID", dimTypeID);
				setData.put("Name", dimValueName);
				setData.put("Deleted", "0");
				setData.put("LanguageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				setData.put("userID", StringUtil.checkNull(commandMap.get("sessionUserId")));
				
				if(gridStatus.equals("updated")){
					commonService.update("dim_SQL.editItemDim", setData);
					commonService.update("dim_SQL.updateDimTxt", setData);				
				}
				else if(gridStatus.equals("inserted")){
					isExistDimValue = StringUtil.checkNull(commonService.selectString("dim_SQL.isExistDimValue", setData));
					
					if(isExistDimValue.equals("0")) {
						setData.put("ParentID", parentID);
						setData.put("Level", 2);
						commonService.update("dim_SQL.insertDimValue", setData);
						commonService.update("dim_SQL.insertDimTxt", setData);		
					}
				}
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnAfterUpdateSendData();this.$('#isSubmit').remove();");
			// target.put(AJAX_SCRIPT, "parent.fnMyAction();parent.$('#isSubmit').remove();");
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	

	@RequestMapping(value = "/dimAssignTreePop.do")
	public String dimAssignTreePop(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		try {
			
			Map setMap = new HashMap();
			
			String btnName = "Assign";
			String btnStyle = "assign";
			String dimValues = "";
			setMap.put("ItemID", StringUtil.checkNull(commandMap.get("s_itemID")));
			String alertType = StringUtil.checkNull(request.getParameter("alertType"), "");

			List itemDimList = (List) commonService.selectList("dim_SQL.getDimListWithItemId", setMap);
			
			if(itemDimList != null && itemDimList.size() > 0) {
				for(int i=0; i<itemDimList.size(); i++) {
					Map temp = (Map)itemDimList.get(i);
					
					if(i==0) dimValues =    StringUtil.checkNull(temp.get("DimTypeID")) 
							        + "/" + StringUtil.checkNull(temp.get("DimValueID"));
					else dimValues += "," + StringUtil.checkNull(temp.get("DimTypeID")) 
							        + "/" + StringUtil.checkNull(temp.get("DimValueID"));					
				}
			}

			setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID")));
			String itemTypeCode =  commonService.selectString("item_SQL.selectedItemTypeCode", setMap);
			
			model.put("s_itemID",StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("dimValues", dimValues);
			model.put("btnName", btnName);
			model.put("btnStyle", btnStyle);
			model.put("itemTypeCode", itemTypeCode);
			model.put("alertType", alertType);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/dimAssignTreePop");
	}
	
	@RequestMapping(value = "/dimTreePop.do")
	public String dimTreePop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			
			Map setMap = new HashMap();
			
			String btnName = "Assign";
			String btnStyle = "assign";
			String dimValues = "";
			setMap.put("ItemID", StringUtil.checkNull(commandMap.get("s_itemID")));
			String alertType = StringUtil.checkNull(request.getParameter("alertType"), "");

			List itemDimList = (List) commonService.selectList("dim_SQL.getDimListWithItemId", setMap);
			
			if(itemDimList != null && itemDimList.size() > 0) {
				for(int i=0; i<itemDimList.size(); i++) {
					Map temp = (Map)itemDimList.get(i);
					
					if(i==0) dimValues =    StringUtil.checkNull(temp.get("DimTypeID")) 
							        + "/" + StringUtil.checkNull(temp.get("DimValueID"));
					else dimValues += "," + StringUtil.checkNull(temp.get("DimTypeID")) 
							        + "/" + StringUtil.checkNull(temp.get("DimValueID"));					
				}
			}

			setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID")));
			String itemTypeCode =  commonService.selectString("item_SQL.selectedItemTypeCode", setMap);
			
			model.put("s_itemID",StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("dimValues", dimValues);
			model.put("btnName", btnName);
			model.put("btnStyle", btnStyle);
			model.put("itemTypeCode", itemTypeCode);
			model.put("alertType", alertType);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/dimTreePop");
	}
}
