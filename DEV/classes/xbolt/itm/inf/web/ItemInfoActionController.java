package xbolt.itm.inf.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.file.web.FileMgtActionController;
import xbolt.itm.str.web.StructureActionController;



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
public class ItemInfoActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "itemInfoService")
	private CommonService itemInfoService;
	@Resource(name = "CSService")
	private CommonService CSService;
	@Resource(name = "fileMgtActionController")
	private FileMgtActionController fileMgtActionController;
	@Resource(name = "structureActionController")
	private StructureActionController strActionController;
	
	/*
	 * 2012 - 11 -28
	 * */
	@RequestMapping(value="/checkObjName.do")
	public String checkObjName(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();		
		try{
			
			Map setMap = new HashMap();
			setMap.put("ItemID", request.getParameter("s_itemID"));
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("ClassCode", request.getParameter("classCode"));
			setMap.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			setMap.put("AttrTypeCode", "AT00001");
			setMap.put("PlainText", request.getParameter("AT00001"));				

			String getCount = commonService.selectString("attr_SQL.attrNameEqualCount", setMap);
			
			if(getCount.equals("0")){
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();parent."+request.getParameter("function")+"();");
			}else{
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");				
				//target.put(AJAX_ALERT, "동일한 명칭값이 존재합니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00080"));
			}
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, "체크중 오류가 발생하였습니다.\n\n[msg]"+e.getMessage());
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00089"));
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		//System.out.println("target = "+target);
		
		return nextUrl(AJAXPAGE);
	}
	
	
	@RequestMapping(value="/ObjectInfoMain.do")
	public String ObjectInfoMain(HttpServletRequest request, ModelMap model) throws Exception {		
		String url = "/itm/itemInfo/ObjectInfoMain";		
		try {
			List returnData = new ArrayList();
			HashMap OccAttrInfo = new HashMap();
			HashMap getList  = new HashMap();
			
			String s_itemID = "";
			String setID = "";			
			if( !StringUtil.checkNull(request.getParameter("subID"),"").equals("")){
				s_itemID = StringUtil.checkNull(request.getParameter("subID"),"");
				setID = StringUtil.checkNull(request.getParameter("subID"),"");
			}else{
				s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
				setID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			}
					
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			
			OccAttrInfo = new HashMap();
			OccAttrInfo.put("ModelID", s_itemID);
			OccAttrInfo.put("languageID", request.getParameter("languageID"));
			returnData = (List)commonService.selectList("attr_SQL.getItemAttrText", OccAttrInfo);
			for(int i = 0 ; i < returnData.size(); i++){
				getList = (HashMap)returnData.get(i);
				OccAttrInfo.put(getList.get("AttrTypeCode"), getList.get("PlainText"));
			}
			model.put("AttrInfo", OccAttrInfo);
			
			model.put("s_itemID", setID);
			model.put("option", request.getParameter("option"));
			
			returnData = (List)commonService.selectList("attr_SQL.getItemAttrType", OccAttrInfo);			
			model.put("AttrColumn", returnData);
			
			OccAttrInfo.put("s_itemID",s_itemID);
			OccAttrInfo.put("option",request.getParameter("option"));
			getList = (HashMap)commonService.select("item_SQL.getObjectInfo", OccAttrInfo);
			model.put("getList", getList);
			
			//권한에 따른 url변경
			if(request.getParameter("getAuth").toString().equals("editor")){				
				OccAttrInfo.put("TeamType", "2");
				returnData = commonService.selectList("organization_SQL.getTeamList", OccAttrInfo);
				model.put("companyOption", returnData);

				OccAttrInfo.put("TeamType", "4");
				returnData = commonService.selectList("organization_SQL.getTeamList", OccAttrInfo);
				model.put("ownerTeamOption", returnData);

				OccAttrInfo.put("option",  request.getParameter("option"));
				returnData = commonService.selectList("item_SQL.getClassOption", OccAttrInfo);
				model.put("classOption", returnData);

				url = "/itm/itemInfo/ObjectInfoMainAdmin";				
			}
			
			if(StringUtil.checkNull(request.getParameter("sub"),"").equals("sub")){
				if(StringUtil.checkNull(request.getParameter("getAuth")).equals("editor")){url = "/itm/sub/ObjectInfoSubMainAdmin";
				}else{url = "/itm/sub/ObjectInfoSubMain";}
			}			
			//ItemFile 목록
			OccAttrInfo.put("ItemID", setID);
			OccAttrInfo.put("FilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
			model.put("itemFiles", (List)commonService.selectList("item_SQL.itemFileList_select", OccAttrInfo));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/ObjectInfoChild.do")
	public String ObjectInfoChild(HttpServletRequest request, ModelMap model) throws Exception {		
		String url = "/itm/sub/ObjectInfoChild";		
		try {
			List returnData = new ArrayList();
			HashMap OccAttrInfo = new HashMap();
			HashMap getList  = new HashMap();
			
			OccAttrInfo.put("languageID", request.getParameter("languageID"));			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			if(StringUtil.checkNull(request.getParameter("getAuth"),"").equals("editor")){url = "/itm/sub/ObjectInfoChildAdmin";}
			
			String s_itemID="";
			String setID="";			
			if( !StringUtil.checkNull(request.getParameter("subID"),"").equals("")){
				s_itemID = StringUtil.checkNull(request.getParameter("subID"),"");
				setID = StringUtil.checkNull(request.getParameter("subID"),"");
			}else{
				s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
				setID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			}			
			OccAttrInfo.put("ModelID", s_itemID);
			OccAttrInfo.put("languageID", (String)request.getParameter("languageID"));			
			returnData = (List)commonService.selectList("attr_SQL.getItemAttrText", OccAttrInfo);
			
			OccAttrInfo = new HashMap();			
			for(int i = 0 ; i < returnData.size(); i++){
				getList = (HashMap)returnData.get(i);
				OccAttrInfo.put(getList.get("AttrTypeCode"), getList.get("PlainText"));
			}
			
			model.put("s_itemID", s_itemID);
			model.put("option", request.getParameter("option"));			
			model.put("AttrInfo", OccAttrInfo);
			
			OccAttrInfo.put("ModelID", s_itemID);
			OccAttrInfo.put("languageID", (String)request.getParameter("languageID"));
			returnData = (List)commonService.selectList("attr_SQL.getItemAttrType", OccAttrInfo);
			
			model.put("AttrColumn", returnData);
/*
			//ItemFile 목록
			OccAttrInfo.put("ItemID", (String)request.getParameter("s_itemID"));
			OccAttrInfo.put("FilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
			model.put("itemFiles", (List)commonService.selectList("item_SQL.itemFileList_select", OccAttrInfo));
 * */
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/ObjectAttrInfo.do")
	public String ObjectAttrInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		
		String url = "/itm/sub/ObjectAttrInfoMain";
		try {
			List returnData = new ArrayList();
			HashMap setMap = new HashMap();	
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String attrRevYN = StringUtil.checkNull(request.getParameter("attrRevYN"),"");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"),"");
			String modelID = StringUtil.checkNull(request.getParameter("ModelID"),"");
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("defaultLang", defaultLang);
			setMap.put("option", request.getParameter("option"));
						
			setMap.put("s_itemID", s_itemID);
			setMap.put("attrRevYN", attrRevYN);
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			String itemStatus = StringUtil.checkNull(itemInfo.get("Status"));
			String identifier = StringUtil.checkNull(itemInfo.get("Identifier"));
			/* edit 가능 한 Item 인지 Item Status를 취득해서  판단 */
			String itemBlocked = commonService.selectString("project_SQL.getItemBlocked", setMap);	
			
			setMap.put("modelID", modelID);
			setMap.put("link", s_itemID);
			String elementReleaseNo = "";
			if(modelID != null && !modelID.equals("null") && !modelID.equals("")) {
				elementReleaseNo = commonService.selectString("model_SQL.getElementReleaseNo", setMap);	
			}
			
			setMap.put("releaseNo", elementReleaseNo);
			if(attrRevYN.equals("Y")){				
				setMap.put("changeSetID", changeSetID);
				returnData = (List)commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
				returnData = GetItemAttrList.getItemAttrRevList(commonService, returnData, setMap, StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				
			}else{
				returnData = (List)commonService.selectList("attr_SQL.getItemAttr", setMap);
				returnData = GetItemAttrList.getItemAttrList(commonService, returnData, setMap, request.getParameter("languageID"));	
			}
			
			String dataType = "";
			Map setData = new HashMap();
			List mLovList = new ArrayList();
			String plainText = "";		
			for(int i=0; i<returnData.size(); i++){
				Map attrTypeMap = (HashMap)returnData.get(i);
				dataType = StringUtil.checkNull(attrTypeMap.get("DataType"));
				if(dataType.equals("MLOV")){
					setData.put("defaultLang", defaultLang);
					setData.put("languageID", request.getParameter("languageID"));
					setData.put("itemID", commandMap.get("s_itemID"));
					setData.put("attrTypeCode", attrTypeMap.get("AttrTypeCode"));
					mLovList = commonService.selectList("attr_SQL.getMLovList",setData);
					plainText = "";
					if(mLovList.size() > 0){
						for(int j=0; j<mLovList.size(); j++){
							Map mLovListMap = (HashMap)mLovList.get(j);
							if(j==0){
								plainText = StringUtil.checkNull(mLovListMap.get("Value"));
							}else {
								plainText = plainText + " / " + mLovListMap.get("Value") ;
							}
						}
					}
					attrTypeMap.put("PlainText", plainText);
				}
			}
			
			model.put("itemStatus", itemStatus); // 아이템 Status
			
			if(modelID.equals("null")){modelID = "";}
			setData.put("modelID", modelID);
			String modelBlocked = "";
			if(!modelID.equals("")){
				modelBlocked = StringUtil.checkNull(commonService.selectString("model_SQL.getModelBlocked", setData));
			}
			
			if (!"0".equals(itemBlocked) || !"0".equals(modelBlocked)) {
				model.put("isPossibleEdit", "N");
			} else {
				model.put("isPossibleEdit", "Y");
			}
			
			// Login user editor 권한 추가
//			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(request.getParameter("userID")) 
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(request.getParameter("userID"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}		
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
			
			commandMap.put("itemID", s_itemID);
			String accRight = getItemAccRight(commandMap);
			
			List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
			List dimResultList = new ArrayList();
			Map dimResultMap = new HashMap();
			
			String dimTypeName = "";
			String dimValueNames = "";
			for(int i = 0; i < dimInfoList.size(); i++){
				Map map = (HashMap)dimInfoList.get(i);
				
				if (i > 0) {
					if(dimTypeName.equals(map.get("DimTypeName").toString())) {
						dimValueNames += " / "+map.get("DimValuePath").toString();
					} else {
						dimResultMap.put("dimValueNames", dimValueNames);
						dimResultList.add(dimResultMap);
						dimResultMap = new HashMap(); // 초기화
						dimTypeName = map.get("DimTypeName").toString();
						dimResultMap.put("dimTypeName", dimTypeName);
						dimValueNames = map.get("DimValuePath").toString();
					}
				}else{
					dimTypeName = map.get("DimTypeName").toString();
					dimResultMap.put("dimTypeName", dimTypeName);
					dimValueNames = map.get("DimValuePath").toString();
				}
			}
			if (dimInfoList.size() > 0) {
				dimResultMap.put("dimValueNames", dimValueNames);
				dimResultList.add(dimResultMap);
			}
			
			setMap.put("itemID",s_itemID);
			setMap.put("assignmentType", "CNGROLETP");	
			setMap.put("languageID", request.getParameter("languageID"));
			List roleAssignMemberList = roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);	
			model.put("roleAssignMemberList", roleAssignMemberList);
			
			model.put("dimResultList", dimResultList);
			
			setMap.put("changeSetID", changeSetID);
			Map csInfo = commonService.select("cs_SQL.getChangeSetInfo", setMap);
			String csValidDate = "";
			if(!csInfo.isEmpty()) {
				csValidDate = StringUtil.checkNull(csInfo.get("ValidFrom"));
			}
			model.put("csValidDate", csValidDate);
			model.put("screenType",  StringUtil.checkNull(request.getParameter("screenType")));
			model.put("s_itemID", s_itemID);
			model.put("identifier", identifier);
			model.put("getList", returnData);
			model.put("attrRevYN", attrRevYN);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			model.put("itemInfo", itemInfo); 
			model.put("accRight", accRight);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/ConnectionAttrInfo.do")
	public String ConnectionAttrInfo(HttpServletRequest request, ModelMap model) throws Exception {
		
		String url = "/itm/sub/ObjectAttrInfoMain";
		try {
			List returnData = new ArrayList();
			HashMap setMap = new HashMap();
			
			String s_itemID = "";
			
			if( !StringUtil.checkNull(request.getParameter("subID"),"").equals("")){
				s_itemID = StringUtil.checkNull(request.getParameter("subID"),"");
			}else{
				s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			}
			
			setMap.put("parentID", StringUtil.checkNull(request.getParameter("parentID"),"") );
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("option", request.getParameter("option"));
			returnData = (List)commonService.selectList("attr_SQL.getConItemDetailInfo", setMap);
			
			model.put("getList", returnData);
			
			setMap.put("fromID", StringUtil.checkNull(request.getParameter("parentID"),"") );
			model.put("s_itemID", commonService.selectString("item_SQL.getStID", setMap));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveObjInfo.do")
	public String saveObjInfo(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();	
		XSSRequestWrapper xss = new XSSRequestWrapper(request);	
		try{
			for (Iterator i = commandMap.entrySet().iterator(); i.hasNext();) {
			    Entry e = (Entry) i.next(); // not allowed
			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
			    	commandMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
			    }
			}			
			
			Map setValue = new HashMap();
			setValue.put("ItemID", xss.getParameter("s_itemID"));
			setValue.put("languageID", xss.getParameter("languageID"));
			setValue.put("ClassCode", xss.getParameter("classCode"));
			setValue.put("ItemTypeCode", xss.getParameter("ItemTypeCode"));
			
			// 명칭
			setValue.put("AttrTypeCode", "AT00001");
			setValue.put("PlainText", request.getParameter("AT00001"));	
			String setInfo = GetItemAttrList.attrUpdate(commonService, setValue);		
			
			setValue.put("Identifier", xss.getParameter("Identifier"));
			setValue.put("ClassCode", xss.getParameter("classCode"));
			setValue.put("CompanyID", xss.getParameter("companyCode"));
			setValue.put("OwnerTeamID", xss.getParameter("ownerTeamCode"));
			setValue.put("Version", xss.getParameter("Version"));
			setValue.put("AuthorID", xss.getParameter("AuthorID"));
			setValue.put("LastUser", xss.getParameter("AuthorID"));
			
			commonService.update("item_SQL.updateItemObjectInfo",setValue);
				

			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.top.frames['main'].fnSearchTreeId('"+xss.getParameter("s_itemID")+"');parent.returnSaveObj();this.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, "저장중 오류가 발생하였습니다.\n\n[msg]"+e.getMessage());
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		//return nextUrl("/itm/sub/ObjectInfoSubMainAdmin");
		return nextUrl(AJAXPAGE);
	}	

	@RequestMapping(value="/saveObjInfoChild.do")
	public String saveObjInfoChild(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		
		Map target = new HashMap();
		try{
			
			Map setValue = new HashMap();
			setValue.put("ItemID", request.getParameter("s_itemID"));
			setValue.put("languageID", request.getParameter("languageID"));
			setValue.put("ClassCode", "");
			setValue.put("ItemTypeCode", "");
			setValue.put("AttrTypeCode", "AT00003");
			setValue.put("PlainText", request.getParameter("AT00003"));
			
			String setInfo = GetItemAttrList.attrUpdate(commonService, setValue);
			
			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, "저장중 오류가 발생하였습니다.\n\n[msg]"+e.getMessage());
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		//return nextUrl("/itm/sub/ObjectInfoSubMainAdmin");
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/saveObjInfoMain.do")
	public String saveObjInfoMain(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();		
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try{
			
			for (Iterator i = commandMap.entrySet().iterator(); i.hasNext();) {
			    Entry e = (Entry) i.next(); // not allowed
			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
			    	commandMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
			    }
			}
			
			String setAttrID[] = {"01"};
			String[] dmsFileItems = StringUtil.checkNull(xss.getParameter("dms_items"), "").split("\\|", 0);
			
			Map setValue = new HashMap();
			setValue.put("ItemID", xss.getParameter("s_itemID"));
			setValue.put("languageID", xss.getParameter("languageID"));
			setValue.put("ClassCode", xss.getParameter("classCode"));
			setValue.put("ItemTypeCode", xss.getParameter("ItemTypeCode"));
			
			for(int i = 0; i < setAttrID.length ; i++){
				setValue.put("AttrTypeCode", "AT000"+setAttrID[i]);
				setValue.put("PlainText", xss.getParameter("AT000"+setAttrID[i]));				
				String setInfo = GetItemAttrList.attrUpdate(commonService, setValue);
			}
			
			setValue.put("Identifier", xss.getParameter("Identifier"));
			setValue.put("ClassCode", xss.getParameter("classCode"));
			setValue.put("CompanyID", xss.getParameter("companyCode"));
			setValue.put("OwnerTeamID", StringUtil.checkNull(xss.getParameter("subOwnerTeamCode"),xss.getParameter("ownerTeamCode")));
			setValue.put("Version", xss.getParameter("Version"));
			setValue.put("AuthorID", StringUtil.checkNull(xss.getParameter("subAuthorID"),xss.getParameter("AuthorID")));
			setValue.put("LastUser", xss.getParameter("UserID"));
			
			commonService.update("item_SQL.updateItemObjectInfo",setValue);

			Iterator fileNameIter = request.getFileNames();
			String savePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;//"C:/Tomcat 7.0/webapps/ROOT/doc/item/"; // 폴더 바꾸기
			String fileName = "";
			int LinkType = 1;
		    while (fileNameIter.hasNext()) {
			   MultipartFile mFile = request.getFile((String)fileNameIter.next());
			   boolean isWrite = true;
			   if (mFile.getSize() > 0) {
				   LinkType = 1;
				   fileName = mFile.getOriginalFilename();
				   for(int i=0; i<dmsFileItems.length; i++){
					   if(dmsFileItems[i].indexOf(fileName) > 0){
						   LinkType = 2;
						   isWrite = false;
						   break;
					   }
				   }
				   HashMap map = FileUtil.uploadFile(mFile, savePath, isWrite);
				   
				   map.put("DocumentID", xss.getParameter("s_itemID"));
				   map.put("FileNm", map.get(FileUtil.FILE_NAME));
				   map.put("SysFileNm", map.get(FileUtil.UPLOAD_FILE_NM));
				   map.put("LinkType", LinkType);		//1:Xbolt 2:DMS
				   map.put("RegMemberID", "");
				   map.put("DocCategory", "ITM");
				   commonService.insert("item_SQL.itemFile_insert", map);
			   }
			}		

			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.returnSaveObj();parent.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, "저장중 오류가 발생하였습니다.\n\n[msg]"+e.getMessage());
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		//return nextUrl("/itm/sub/ObjectInfoSubMainAdmin");
		return nextUrl(AJAXPAGE);		
	}
	
	// 므로세스 모델 속성 수정 팝업
		@RequestMapping(value = "/editAttrPop.do")
		public String editAttrPop(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception {
			try {
				List returnData = new ArrayList();
				HashMap setMap = new HashMap();
				model.put("menu", getLabel(request, commonService)); /* Label Setting */

				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
				String scrnType = StringUtil.checkNull(request.getParameter("scrnType"), ""); 
				String defaultLang =  StringUtil.checkNull(cmmMap.get("sessionDefLanguageId"));
				
//				String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
//				String userID = String.valueOf(cmmMap.get("sessionUserId"));

				setMap.put("s_itemID", s_itemID);
				setMap.put("itemID", s_itemID);
				setMap.put("languageID", request.getParameter("languageID"));
				setMap.put("defaultLang", defaultLang);
				setMap.put("option", request.getParameter("option"));
				String identifier = "";
				Map itemMap = commonService.select("report_SQL.getItemInfo", setMap);
				if(itemMap != null){
					identifier = StringUtil.checkNull(itemMap.get("Identifier"));
//					if (StringUtil.checkNull(itemMap.get("AuthorID")).equals(userID) || StringUtil.checkNull(itemMap.get("LockOwner")).equals(userID) || "1".equals(sessionAuthLev)) {
//						model.put("myItem", "Y");
//					}
					
					String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
					model.put("myItem", myItem);
					
					itemMap.put("ItemName", StringUtil.checkNull(itemMap.get("ItemName")).replaceAll("\"", "&quot;"));
				}
				model.put("itemMap", itemMap);
				// isComLang = ALL
				setMap.put("Editable", 1);
				returnData = (List) commonService.selectList("attr_SQL.getItemAttr", setMap);
				// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
				returnData = GetItemAttrList.getItemAttrList(commonService, returnData, setMap, request.getParameter("languageID"));
				
				List mLovList = new ArrayList();
				Map setData = new HashMap();
				String dataType = "";
				String mLovAttrTypeCode = "";
				String mLovAttrTypeValue = "";
				int k=0;
				for(int i=0; i<returnData.size(); i++){
					Map listMap = (Map) returnData.get(i);
					dataType = StringUtil.checkNull(listMap.get("DataType"));
					if(dataType.equals("MLOV")){
						setData.put("attrTypeCode",listMap.get("AttrTypeCode"));
						setData.put("itemID",s_itemID);
						setData.put("languageID", cmmMap.get("sessionCurrLangType"));
						setData.put("defaultLang", defaultLang);
						mLovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
						listMap.put("mLovList", mLovList);
						if(k==0){
							mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode"));
							mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME"));
						}else{
							mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode"));
							mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME"));
						}
						model.put("mLovAttrTypeCode",mLovAttrTypeCode);
						model.put("mLovAttrTypeValue",mLovAttrTypeValue);
						k++;
					}
				}
				
				setMap = new HashMap();
				setMap.put("itemID", s_itemID);
				String itemClassCode = StringUtil.checkNull(commonService.selectString("item_SQL.getClassCode",setMap)); 
				
				setMap.put("itemClassCode", itemClassCode);
				Map itemClassInfo = commonService.select("item_SQL.getClassOption", setMap);
				String autoID = StringUtil.checkNull(itemClassInfo.get("AutoID"));
				
				model.put("autoID", autoID);
				
				model.put("s_itemID", s_itemID);
				model.put("getList", returnData);
				model.put("identifier",identifier);
				model.put("scrnType", scrnType); 
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl("/popup/editAttrPop");
		}
	
		// 므로세스 모델 속성 수정 팝업
		@RequestMapping(value = "/editAttrOfItemsPop.do")
		public String editAttrOfItemsPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
			try {
				List returnData = new ArrayList();
				HashMap setMap = new HashMap();
				
				String attrCode = StringUtil.checkNull(request.getParameter("attrCode").replace("&#39", "'").replace(";", ""));
				String items = StringUtil.checkNull(request.getParameter("items"));
				String classCodes = StringUtil.checkNull(request.getParameter("classCodes"));
				//System.out.println(items+", attrCode :"+attrCode);

				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("AttrTypeCodes", attrCode);
				setMap.put("ItemClassCode", classCodes);
				System.out.println("setMap :: "+setMap);
				returnData = (List) commonService.selectList("attr_SQL.getAttrAllocList", setMap);
				
				List mLovList = new ArrayList();
				String dataType = "";
				for(int i=0; i<returnData.size(); i++){
					Map listMap = (Map) returnData.get(i);
					dataType = StringUtil.checkNull(listMap.get("DataType"));
					if(dataType.equals("MLOV")){
						setMap.put("s_itemID",listMap.get("AttrTypeCode"));
						setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
						mLovList = commonService.selectList("attr_SQL.selectAttrLovOption",setMap);
						listMap.put("mLovList",mLovList);					
					}
					
				}
				model.put("itemID", items);
				model.put("attrCode", StringUtil.checkNull(request.getParameter("attrCode")));
				model.put("classCodes", classCodes);
				model.put("getList", returnData);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */

			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl("/popup/editAttrOfItemsPop");
		}

		// 므로세스 모델 속성 수정 팝업
		@RequestMapping(value = "/selectAttributePop.do")
		public String selectAttributePop(HttpServletRequest request,
				HashMap cmmMap, ModelMap model) throws Exception {
			try {
				List returnData = new ArrayList();
				HashMap setMap = new HashMap();
				HashMap classCodeMap = new HashMap();

				String items = StringUtil.checkNull(request.getParameter("items"));
				String classCodes = StringUtil.checkNull(request.getParameter("classCodes"));

				String[] arrayClassCode = classCodes.split(",");
				String attrCodes = "";
				String classCode = "";
				int classNum = 0;
				
				if (!classCodes.equals("")) {
					classCode = arrayClassCode[0];
					classCodes = "";
					classCodeMap = new HashMap();
					for (int i = 0; arrayClassCode.length > i; i++) {
						if (i == 0) {
							classCodes = "'" + arrayClassCode[i] + "'";
							classCodeMap.put(arrayClassCode[i], arrayClassCode[i]);
							classNum++;
						} else {
							if (!classCodeMap.containsKey(arrayClassCode[i])) {
								classCodes = classCodes + ",'" + arrayClassCode[i]
										+ "'";
								classCodeMap.put(arrayClassCode[i],
										arrayClassCode[i]);
								classNum++;
							}
						}
					}
					setMap.put("ClassNum", classNum);
					setMap.put("ItemClassCodes", classCodes);
					List crossAttrCodesList = (List) commonService.selectList("attr_SQL.getCrossAttrCodes", setMap);

					for (int i = 0; i < crossAttrCodesList.size(); i++) {
						Map map = (Map) crossAttrCodesList.get(i);
						if (i == 0) {
							attrCodes = "'"
									+ String.valueOf(map.get("AttrTypeCode")) + "'";
						} else {
							attrCodes = attrCodes + ",'"
									+ String.valueOf(map.get("AttrTypeCode") + "'");
						}
					}

					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					setMap.put("ItemClassCode", classCode);
					setMap.put("AttrTypeCodes", attrCodes);
					returnData = (List) commonService.selectList("attr_SQL.getAttrAllocList", setMap);
					model.put("classCodes", classCode);

				} else {
					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					setMap.put("ItemClassCode", classCodes);
					returnData = (List) commonService.selectList("attr_SQL.getAttrAllocList", setMap);
					model.put("classCodes", classCodes);
				}

				model.put("items", items);
				model.put("getAttrList", returnData);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */

			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl("/popup/selectAttributePop");
		}
	
		@RequestMapping(value = "/editItemInfoPop.do")
		public String editItemInfoPop(HttpServletRequest request, ModelMap model)
				throws Exception {
			String url = "/popup/editItemInfoPop";
			try {
				List returnData = new ArrayList();
				HashMap OccAttrInfo = new HashMap();
				HashMap getList = new HashMap();

				OccAttrInfo.put("languageID", request.getParameter("languageID"));
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/

				String s_itemID = "";
				String setID = "";
				if (!StringUtil.checkNull(request.getParameter("subID"), "").equals("")) {
					s_itemID = StringUtil.checkNull(request.getParameter("subID"), "");
					setID = StringUtil.checkNull(request.getParameter("subID"), "");
				} else {
					s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
					setID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
				}


				OccAttrInfo = new HashMap();
				OccAttrInfo.put("ModelID", s_itemID);
				OccAttrInfo.put("languageID", request.getParameter("languageID"));
				returnData = (List) commonService.selectList("attr_SQL.getItemAttrText", 	OccAttrInfo);
				for (int i = 0; i < returnData.size(); i++) {
					getList = (HashMap) returnData.get(i);
					OccAttrInfo.put(getList.get("AttrTypeCode"),
							getList.get("PlainText"));
				}
				model.put("AttrInfo", OccAttrInfo);

				model.put("s_itemID", setID);
				model.put("option", request.getParameter("option"));

				returnData = (List) commonService.selectList("attr_SQL.getItemAttrType",
						OccAttrInfo);
				model.put("AttrColumn", returnData);

				OccAttrInfo.put("s_itemID", s_itemID);
				OccAttrInfo.put("option", request.getParameter("option"));
				getList = (HashMap) commonService.select("item_SQL.getObjectInfo", OccAttrInfo);
				model.put("getList", getList);
				model.put("OwnerTeamName", getList.get("OwnerTeamName"));
				model.put("ClassName", getList.get("ClassName"));

				OccAttrInfo.put("TeamType", "2");
				returnData = commonService.selectList("organization_SQL.getTeamList",	OccAttrInfo);
				model.put("companyOption", returnData);

				OccAttrInfo.put("TeamType", "4");
				returnData = commonService.selectList("organization_SQL.getTeamList",	OccAttrInfo);
				model.put("ownerTeamOption", returnData);

				OccAttrInfo.put("option", request.getParameter("option"));
				returnData = commonService.selectList("item_SQL.getClassOption", OccAttrInfo);
				model.put("classOption", returnData);

				// 개요
				returnData = new ArrayList();

				OccAttrInfo.put("ModelID", s_itemID);
				OccAttrInfo.put("languageID",
						(String) request.getParameter("languageID"));
				returnData = (List) commonService.selectList("attr_SQL.getItemAttrType",
						OccAttrInfo);

				model.put("AttrColumn", returnData);

				/* 속성 */
				returnData = new ArrayList();
				OccAttrInfo.put("s_itemID", s_itemID);
				OccAttrInfo.put("languageID", request.getParameter("languageID"));
				OccAttrInfo.put("option", request.getParameter("option"));

				// isComLang = ALL
				returnData = (List) commonService.selectList("attr_SQL.getItemAttr", OccAttrInfo);
				// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
				returnData = GetItemAttrList
						.getItemAttrList(commonService, returnData, OccAttrInfo,	request.getParameter("languageID"));

				model.put("getAttrList", returnData);
				model.put("title", request.getParameter("title"));

				// TODO : div pop 표시용
				if (!StringUtil.checkNull(request.getParameter("isDivPop"))
						.isEmpty()) {
					url = "/popup/editItemInfoDivPop";
				}

			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl(url);
		}
	
		@RequestMapping(value = "/editObjectInfoPop.do")
		public String editObjectInfoPop(HttpServletRequest request, ModelMap model)
				throws Exception {
			try {
				List returnData = new ArrayList();
				HashMap OccAttrInfo = new HashMap();
				HashMap getList = new HashMap();
				
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				String s_itemID = "";
				String setID = "";
				if (!StringUtil.checkNull(request.getParameter("subID"), "").equals("")) {
					s_itemID = StringUtil.checkNull(request.getParameter("subID"), "");
					setID = StringUtil.checkNull(request.getParameter("subID"), "");
				} else {
					s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
					setID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
				}

				Map getMap = new HashMap();
				OccAttrInfo = new HashMap();
				OccAttrInfo.put("ModelID", s_itemID);
				OccAttrInfo.put("languageID", request.getParameter("languageID"));
				returnData = (List) commonService.selectList("attr_SQL.getItemAttrText",
						OccAttrInfo);
				for (int i = 0; i < returnData.size(); i++) {
					getList = (HashMap) returnData.get(i);
					OccAttrInfo.put(getList.get("AttrTypeCode"),
							getList.get("PlainText"));
				}
				model.put("AttrInfo", OccAttrInfo);

				model.put("s_itemID", setID);
				model.put("option", request.getParameter("option"));

				returnData = (List) commonService.selectList("attr_SQL.getItemAttrType",
						OccAttrInfo);
				model.put("AttrColumn", returnData);

				OccAttrInfo.put("s_itemID", s_itemID);
				OccAttrInfo.put("option", request.getParameter("option"));
				getList = (HashMap) commonService.select("item_SQL.getObjectInfo", OccAttrInfo);
				model.put("getList", getList);

				OccAttrInfo.put("TeamType", "2");
				returnData = commonService.selectList("organization_SQL.getTeamList", OccAttrInfo);
				model.put("companyOption", returnData);

				OccAttrInfo.put("TeamType", "4");
				returnData = commonService.selectList("organization_SQL.getTeamList", OccAttrInfo);
				model.put("ownerTeamOption", returnData);

				OccAttrInfo.put("option", request.getParameter("option"));
				returnData = commonService.selectList("item_SQL.getClassOption", OccAttrInfo);
				model.put("classOption", returnData);

				// 개요
				returnData = new ArrayList();

				OccAttrInfo.put("ModelID", s_itemID);
				OccAttrInfo.put("languageID",  (String) request.getParameter("languageID"));
				returnData = (List) commonService.selectList("attr_SQL.getItemAttrType",	OccAttrInfo);

				model.put("AttrColumn", returnData);

			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl("/popup/editObjectInfoPop");
		}		
		
		@RequestMapping(value = "/EditAttributePopup.do")
		public String EditAttributePopup(HttpServletRequest request, ModelMap model)
				throws Exception {

			try {

				model.put("menu", getLabel(request, commonService)); /* Label Setting */

				model.put("objAttrTypeCode",	request.getParameter("objAttrTypeCode"));
				model.put("objName", request.getParameter("objName"));
				model.put("DataType", request.getParameter("DataType"));

			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl("/popup/EditAttributePopup");
		}	
		
	/**
	 * csrList를 문자열로 return
	 * 
	 * @param parentInfoMap
	 * @return
	 * @throws Exception
	 */
	private String setCsrIds(List csrList) {
		String csrIds = "-1";
		for (int i = 0; i < csrList.size(); i++) {
			Map map = (Map) csrList.get(i);
			String csrId = StringUtil.checkNull(map.get("CODE"));
			
			if (csrIds.isEmpty()) {
				csrIds = csrId;
			} else {
				csrIds = csrIds + "," + csrId;
			}
		}
		
		return csrIds;
	}
	
	@RequestMapping(value = "/checkItemAccRight.do")
	public String checkItemAccRight(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
				String accRight = getItemAccRight(commandMap);
				target.put(AJAX_SCRIPT, accRight);
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	public String getItemAccRight(HashMap commandMap) throws Exception {
			String accRight = "";
			Map setData = new HashMap();				
			String itemID = StringUtil.checkNull(commandMap.get("itemID"),"");
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			setData.put("itemID", itemID);
			setData.put("userID", userID);
			
			String accCtrl = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAccCtrl", setData));
			if(accCtrl.equals("0")) accRight = "Y";
			else accRight = StringUtil.checkNull(commonService.selectString("user_SQL.getUserItemAccRight", setData));
			
			return accRight;
	}
	
	@RequestMapping(value = "/checkItemArrayAccRight.do")
	public String checkItemArrayAccRight(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
				Map setData = new HashMap();				
				String itemIDs[] = StringUtil.checkNull(request.getParameter("itemIDs"),"").split(",");
				String seqs[] = StringUtil.checkNull(request.getParameter("seq"),"").split(",");
				String itemID = "";
				String seq = "";
				String accRight = "";
				if(itemIDs.length>0) {
					for(int i=0; i<itemIDs.length; i++) {
						itemID = StringUtil.checkNull(itemIDs[i]);
						seq = StringUtil.checkNull(seqs[i]);
						
						commandMap.put("itemID", itemID);
						accRight = getItemAccRight(commandMap);
												
						Map resultData = new HashMap();
						if(!"".equals(seq) && accRight.equals("N")) {
							setData.put("seq", seq);
							String fileName = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFileName", setData)); 
							
							target.put(AJAX_SCRIPT, accRight +","+ fileName);
							model.addAttribute(AJAX_RESULTMAP, target);								
							return nextUrl(AJAXPAGE);
						}
						else if("".equals(seq) && accRight.equals("N")) {
							
							target.put(AJAX_SCRIPT, accRight +",");
							model.addAttribute(AJAX_RESULTMAP, target);								
							return nextUrl(AJAXPAGE);
						}
					}
				}
				
				target.put(AJAX_SCRIPT, accRight);
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/registerItem.do")
	public String registerItem(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "itm/structure/registerItem";
		try {			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			cmmMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			cmmMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			String itemPath = StringUtil.checkNull(commonService.selectString("organization_SQL.getPathOrg", cmmMap));
			String itemTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", cmmMap));
			
			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			String dimTypeList = StringUtil.checkNull(request.getParameter("dimTypeList"));
			
			cmmMap.put("typeCode", classCode);
			cmmMap.put("category", "CLS");
			String className = StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", cmmMap));
							 
			model.put("itemTypeCode", itemTypeCode);
			model.put("itemPath", itemPath);
			model.put("classCode", classCode);
			model.put("fltpCode", fltpCode);
			model.put("dimTypeID", dimTypeList);	
			model.put("className", className);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/registerItemAttrFrame.do")
	public String registerItemAttrFrame(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "itm/structure/registerItemAttrFrame";
		try {			
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			model.put("s_itemID", s_itemID);
			model.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			model.put("pop", StringUtil.checkNull(request.getParameter("pop")));
			
			Map setData = new HashMap();
			
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			setData.put("Editable", "1");
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", cmmMap);
			setData.put("defaultLang", defaultLang);
			setData.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
			setData.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			
			// isComLang = ALL
			List attrAllocList = (List)commonService.selectList("attr_SQL.getAttrTypeAllocList", setData);
			// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
			//attrList = GetItemAttrList.getItemAttrList2(commonService, attrList, setData, request.getParameter("languageID"));
						
			List mLovList = new ArrayList();
			List mLovAttrList = new ArrayList();
			List mLovList2 = new ArrayList();
			setData = new HashMap();
			Map mLovMap = new HashMap();
			String dataType = "";
			String dataType2 = "";
			String mLovAttrTypeCode = "";
			String mLovAttrTypeValue = "";
			
			int k=0; int l=0;
			for(int i=0; i<attrAllocList.size(); i++){
				Map listMap = (Map) attrAllocList.get(i);
				dataType = StringUtil.checkNull(listMap.get("DataType"));
				dataType2 = StringUtil.checkNull(listMap.get("DataType2"));
				if(!dataType.equals("Text")){
					setData.put("attrTypeCode",listMap.get("AttrTypeCode"));
					setData.put("languageID", cmmMap.get("sessionCurrLangType")); 
					setData.put("defaultLang", defaultLang);
					mLovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
					listMap.put("mLovList", mLovList);
										
					if(k==0){
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME"));
					}else{
						mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME"));
					}
					model.put("mLovAttrTypeCode",mLovAttrTypeCode);
					model.put("mLovAttrTypeValue",mLovAttrTypeValue);
					k++;
				}
				
				if(!dataType2.equals("Text")){
					setData.put("attrTypeCode",listMap.get("AttrTypeCode2"));
					setData.put("languageID", cmmMap.get("sessionCurrLangType"));
					setData.put("defaultLang", defaultLang);
					mLovList2 = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
					listMap.put("mLovList2", mLovList2);
										
					if(l==0 && mLovAttrTypeCode.equals("")){
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME2"));
					}else{
						mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME2"));
					}
					model.put("mLovAttrTypeCode2",mLovAttrTypeCode);
					model.put("mLovAttrTypeValue2",mLovAttrTypeValue);
					l++;
				}
			}
		
			model.put("attrAllocList", attrAllocList);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/checkIdentifier.do")
	public String checkIdentifier(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();	
		try{			
			String identifierCNT = commonService.selectString("item_SQL.getIdentifierCount", commandMap);			
			target.put(AJAX_SCRIPT, "fnReturnCheckID("+identifierCNT+");");
			
		} catch(Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/createItemMst.do")
	public String saveObjectInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));		
			String identifier = StringUtil.checkNull(request.getParameter("identifier"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String csrID = StringUtil.checkNull(request.getParameter("csrID"));
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String autoID = StringUtil.checkNull(request.getParameter("autoID"));
			String preFix = StringUtil.checkNull(request.getParameter("preFix"));
			
			Map setMap = new HashMap();			
			String newItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
			
			setMap.put("option", StringUtil.checkNull(request.getParameter("option")));			
			setMap.put("Version", "1");
			setMap.put("Deleted", "0");
			setMap.put("Creator", userID);
			setMap.put("CategoryCode", "OJ");
			setMap.put("ClassCode", classCode);
			setMap.put("OwnerTeamId", teamID);
			setMap.put("Identifier", identifier);
			setMap.put("ItemID", newItemID);			
			setMap.put("s_itemID", s_itemID);	
			if(itemTypeCode.equals("")){
				itemTypeCode = commonService.selectString("item_SQL.selectedItemTypeCode", setMap);
			}
			setMap.put("ItemTypeCode", itemTypeCode);
			
			setMap.put("AuthorID", userID);
			setMap.put("IsPublic", 0);
			setMap.put("ProjectID", csrID);
			setMap.put("Status","NEW1");
			setMap.put("projectID", csrID);
			String itemAccCtrl = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectItemAccCtrl", setMap));
			setMap.put("AccCtrl", itemAccCtrl);
		
			String clientID = "";
			Map<String, Object> parentInfoMap = commonService.select("project_SQL.getParentPjtInfo", setMap);
			if(!parentInfoMap.isEmpty()) {
				clientID = StringUtil.checkNull(parentInfoMap.get("ClientID"));
			}
			setMap.put("clientID", clientID);
			
			Map setValue = new HashMap();
			String idLength = "";
			
			String newItemCode = "";
			if(autoID.equals("Y")){
				newItemCode = StringUtil.checkNull(commonService.selectString("item_SQL.getNewItemCode", setMap));
				if(!newItemCode.equals("") && newItemCode != null) {					
					identifier = newItemCode;				
				}else {
					setValue = new HashMap();
					setValue.put("preFix", preFix);
					identifier = StringUtil.checkNull(commonService.selectString("item_SQL.getMaxPreFixIdentifier", setValue));
					for(int i=0; 5-identifier.length() > i; i++){
						idLength = idLength + "0";
					}
					
					if(identifier.equals("")){
						identifier = preFix + "00001";
					}else{
						identifier = preFix + idLength + identifier;
					}
				}
				
				setMap.put("Identifier", identifier);
			}
			
			commonService.insert("item_SQL.insertItem", setMap);
						
			setMap.put("PlainText", StringUtil.checkNull(request.getParameter("itemName")));
			setMap.put("AttrTypeCode","AT00001");			
			List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);			
			for(int i = 0; i < getLanguageList.size(); i++){
				Map getMap = (HashMap)getLanguageList.get(i);
				setMap.put("languageID", getMap.get("CODE") );				
				commonService.insert("item_SQL.ItemAttr", setMap);
			}	
			
			
			// INSERT ST1 Item 
			setMap.put("CategoryCode", "ST1");
            setMap.put("ClassCode", "NL00000");
			setMap.put("ToItemID", setMap.get("ItemID"));
			setMap.put("FromItemID", s_itemID);
			
			setMap.put("ItemID", commonService.selectString("item_SQL.getItemMaxID", setMap));
			setMap.remove("RefItemID");
			setMap.remove("Identifier");
			setMap.put("ItemTypeCode", commonService.selectString("item_SQL.selectedConItemTypeCode", setMap));
			commonService.insert("item_SQL.insertItem", setMap);
			
			/* 신규 생성된 ITEM의 ITEM_CLASS.ChangeMgt = 1 일 경우, CHANGE_SET 테이블에 레코드 생성  */
			Map insertCngMap = new HashMap();
			Map updateData = new HashMap();
			setMap.put("ItemID", newItemID);
			String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
			if (changeMgt.equals("1")) {
				/* Insert to TB_CHANGE_SET */
				insertCngMap.put("itemID", newItemID);
				insertCngMap.put("userId", userID);
				insertCngMap.put("projectID", csrID);
				insertCngMap.put("classCode", classCode);
				insertCngMap.put("KBN", "insertCNG");
				insertCngMap.put("status", "MOD");
				CSService.save(new ArrayList(), insertCngMap);
			}else if(!changeMgt.equals("1")){ 
				/* ChangeMgt !=1 인 경우 ParentItem의 CurChangeSet Update */
				setMap.put("itemID",s_itemID);
				String sItemIDCurChangeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap));
				if(!sItemIDCurChangeSetID.equals("")){
					updateData.put("CurChangeSet", sItemIDCurChangeSetID);
					updateData.put("s_itemID", newItemID);
					commonService.update("project_SQL.updateItemStatus", updateData);
				}
			}
			
			// Dimension 생성 TB_ITEM_CLASS HasDimension = 1 
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
			String dimTypeValueID = StringUtil.checkNull(request.getParameter("dimTypeValueID"));
			String subDimTypeValueID = StringUtil.checkNull(request.getParameter("subDimTypeValueID"));
			if(!dimTypeID.equals("") && !dimTypeValueID.equals("")){					
				Map setData = new HashMap();
				setData.put("ItemTypeCode", itemTypeCode);
				setData.put("ItemClassCode", classCode);
				setData.put("ItemID",newItemID);
				setData.put("DimTypeID", dimTypeID);
				setData.put("DimValueID", dimTypeValueID);
				commonService.update("dim_SQL.insertItemDim", setData);
				if(!subDimTypeValueID.equals("")) {
					setData.put("DimValueID", subDimTypeValueID);
					commonService.update("dim_SQL.insertItemDim", setData);
				}
			}
			
			List returnData = new ArrayList();
			setMap = new HashMap();
			setMap.put("Editable", "1");
			setMap.put("classCode", classCode);
			setMap.put("languageID", languageID);
			setMap.put("defaultLang", commandMap.get("sessionDefLanguageId"));
			setMap.put("showInvisible", commandMap.get("showInvisible"));
			returnData = (List)commonService.selectList("attr_SQL.getItemAttr", setMap);
			
			String setInfo = "";
			setMap = new HashMap();
			String dataType = "";
			String mLovValue = "";
			String html = "";
			for(int i = 0; i < returnData.size() ; i++){				
				setMap = (HashMap)returnData.get(i);
				dataType = StringUtil.checkNull(setMap.get("DataType"));
				html = StringUtil.checkNull(setMap.get("HTML"));
				if(!dataType.equals("Text")){
					if(dataType.equals("MLOV")){
					String reqMLovValue[] =  StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode"))).split(",");
				
					for(int j=0; j<reqMLovValue.length; j++){
						mLovValue = reqMLovValue[j].toString();							
						setMap.put("PlainText", mLovValue);						
						setMap.put("ItemID", newItemID);
						setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
						setMap.put("ClassCode", classCode);
						setMap.put("ItemTypeCode", itemTypeCode);															
						setMap.put("LovCode", mLovValue );
						setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
					}	
				}else{
						setMap.put("PlainText", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")),"") );					
						setMap.put("ItemID", newItemID);
						setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
						setMap.put("ClassCode", classCode);
						setMap.put("ItemTypeCode", itemTypeCode);															
						setMap.put("LovCode", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")),""));
						setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
					}
				}else{	
					String plainText = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")),"");
					// if(html.equals("1")){plainText =  StringEscapeUtils.escapeHtml4(plainText);}
					setMap.put("PlainText", plainText);
					setMap.put("ItemID", newItemID);
					setMap.put("languageID", languageID);
					setMap.put("ClassCode", classCode);
					setMap.put("ItemTypeCode", itemTypeCode);															
					setMap.put("LovCode", StringUtil.checkNull( commonService.selectString("attr_SQL.selectAttrLovCode", setMap) ,"") );
					setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
				}
			}
			
			// ZAT4015 최초 인증 담당자
			String ZAT4015 = StringUtil.checkNull(request.getParameter("ZAT4015_ID"));
			if(!ZAT4015.equals("") && ZAT4015 != null) {
				setMap = new HashMap();
				setMap.put("sessionUserId", ZAT4015);
				String mbrTeamID = commonService.selectString("user_SQL.userTeamID", setMap);
				
				setMap.put("projectID", csrID);
				setMap.put("itemID", newItemID);
				setMap.put("memberID", ZAT4015);
				setMap.put("mbrTeamID", mbrTeamID);
				setMap.put("assignmentType", "CNGROLETP");
				setMap.put("roleType", "R");
				setMap.put("orderNum", 1);
				setMap.put("assigned", 1);
				setMap.put("accessRight", "U");
				setMap.put("creator", userID);
				
				commonService.insert("role_SQL.insertRoleAssignment", setMap);
			}
			
			//첨부파일 등록 : TB_FILE 
			commandMap.put("projectID", csrID);
			commandMap.put("id", newItemID);
			commandMap.put("usrId", userID);
			commandMap.put("docCategory", "ITM");
			fileMgtActionController.saveMultiFile(request,commandMap,model);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.fnCallBack('"+newItemID+"');parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}	
	
	@RequestMapping(value="/viewItemInfoMgt.do")
	public String viewItemInfoMgt(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		String url = "/itm/itemInfo/viewItemInfoMgt";		
		
		model.put("menu", getLabel(request, commonService));
		String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));		
		if(s_itemID.equals("")) s_itemID = StringUtil.checkNull(cmmMap.get("itemID"));		
		String option = StringUtil.checkNull(cmmMap.get("option"),"");
		String accMode = StringUtil.checkNull(cmmMap.get("accMode"));
		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
		
		String itemViewPage = StringUtil.checkNull(cmmMap.get("itemViewPage"));
		String itemEditPage = StringUtil.checkNull(cmmMap.get("itemEditPage"));
		
		Map setMap = new HashMap();
		setMap.put("languageID", languageID);
		setMap.put("s_itemID", s_itemID);			
		Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
		
		String parentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setMap));
		model.put("parentItemID", parentItemID);
		
//		String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
//		String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
//		if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserId) 
//				|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserId)
//				|| "1".equals(sessionAuthLev)) {
//			model.put("myItem", "Y");
//		}
		
		String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
		model.put("myItem", myItem);
		
		setMap.put("itemID", s_itemID);	
		String classUrl = StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuVarFilterByClass", setMap));	//default url = Menu Varfilter
		classUrl = classUrl.split("=")[classUrl.split("=").length-1];

		if(!classUrl.equals("")) url = classUrl;
		
		List itemPath = new ArrayList();
		itemPath = strActionController.getRootItemPath(s_itemID,languageID,itemPath);
		Collections.reverse(itemPath);
		model.put("itemPath",itemPath);
					
		String changeSetID = "";
		if(accMode.equals("OPS")) {
			changeSetID = StringUtil.checkNull(itemInfo.get("ReleaseNo"));
			setMap.put("changeSetID",changeSetID);
			Map prcList = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
			prcList.put("Blocked",itemInfo.get("Blocked"));
			prcList.put("ChangeMgt",itemInfo.get("ChangeMgt"));
			prcList.put("SubscrOption",itemInfo.get("SubscrOption"));
			prcList.put("CheckInOption",itemInfo.get("CheckInOption"));
			prcList.put("CheckOutOption",itemInfo.get("CheckOutOption"));
			prcList.put("Status",itemInfo.get("Status"));
			prcList.put("ClassVarFilter",itemInfo.get("ClassVarFilter"));
			model.put("itemInfo", prcList);	
		} else {
			model.put("itemInfo", itemInfo);
		}
		
		setMap = new HashMap();
		setMap.put("userId", cmmMap.get("sessionUserId"));
		setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
		setMap.put("s_itemID", s_itemID);
		setMap.put("ProjectType", "CSR");
		setMap.put("isMainItem", "Y");
		setMap.put("status", "CNG");
		List projectNameList = commonService.selectList("project_SQL.getProjectNameList", setMap);
		model.put("projectNameList", projectNameList.size());
		
		// QuickCheckOut 설정
		String quickCheckOut = "N";
		String itemAuthorID = StringUtil.checkNull(itemInfo.get("AuthorID"));
		String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
		
		setMap.put("ItemID", s_itemID);
		String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
		
		if(itemInfo.get("Blocked").equals("2")){
			//attributeBtn = "N";
			setMap = new HashMap();
			setMap.put("itemID", s_itemID);
			setMap.put("accessRight", "U");
			setMap.put("userID", sessionUserID);
			String myItemMember = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemMemberIDTop1", setMap));
			if( (itemInfo.get("Status").equals("REL")) && changeMgt.equals("1") && (itemAuthorID.equals(sessionUserID) || myItemMember.equals(sessionUserID))   ) {
				quickCheckOut = "Y";
			}
		}
		setMap.put("memberID", cmmMap.get("sessionUserId"));
		setMap.put("itemID", s_itemID);
		setMap.put("assignmentType", "SUBSCR");
		setMap.put("accessRight", "R");
		model.put("myItemCNT", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCNT", setMap)));
		model.put("quickCheckOut", quickCheckOut);
		
		model.put("s_itemID", s_itemID);
		model.put("option", option);
		model.put("accMode", accMode);
		
		model.put("itemViewPage", itemViewPage);
		model.put("itemEditPage", itemEditPage);
		model.put("rewBrdMgtID", StringUtil.checkNull(request.getParameter("rewBrdMgtID")));

		return nextUrl(url);
	}
	
	@RequestMapping(value = "/searchItemListPop.do")
	public String searchItemListPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			model.put("itemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode"), ""));
			model.put("classCodes", StringUtil.checkNull(request.getParameter("classCodes"), ""));
			model.put("items", StringUtil.checkNull(request.getParameter("items"), ""));
			model.put("initSearch", StringUtil.checkNull(request.getParameter("initSearch"), ""));
			model.put("callBackData", StringUtil.checkNull(request.getParameter("callBackData"), ""));
			setMap.put("ItemClassCode", StringUtil.checkNull(request.getParameter("classCode"), ""));
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			model.put("attrList", commonService.selectList("attr_SQL.getAttrAllocList", setMap));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/itm/search/searchItemListPop");
	}
	
	@RequestMapping(value = "/getItemAccRight.do")
	public void getItemAccRight(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map map = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("application/json");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	String accRight = "";
	    	String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
	    	String userID = StringUtil.checkNull(request.getParameter("userID"),"");
	    	
	    	map.put("itemID", itemID);
	    	map.put("userID", userID);
	    	String accCtrl = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAccCtrl", map));
			if(accCtrl.equals("0")) accRight = "Y";
			else accRight = StringUtil.checkNull(commonService.selectString("user_SQL.getUserItemAccRight", map));
			
			jsonObject.put("data", accRight);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
}
