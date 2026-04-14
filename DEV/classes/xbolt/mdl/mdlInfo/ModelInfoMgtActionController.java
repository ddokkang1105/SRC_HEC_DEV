package xbolt.mdl.mdlInfo;



import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;



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
public class ModelInfoMgtActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "mdItemService")
	private CommonService mdItemService;
	
	@RequestMapping(value="/modelInfoMgt.do")
	public String modelInfoMgt(HttpServletRequest request,  HashMap commandMap, ModelMap model) throws Exception{
		String url = "/mdl/modelItem/itemModelList";
		try{
			
			Map getMap = new HashMap();
	
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			
			String listFilterType = StringUtil.checkNull(request.getParameter("listFilterType"), "");
			if(!StringUtil.checkNull(request.getParameter("url")).equals("")) {
				url = StringUtil.checkNull(request.getParameter("url"),"");
			}
			if(!listFilterType.equals("")) {
				url = "/mdl/modelItem/" + listFilterType;
			}
			model.put("itemID",StringUtil.checkNull(request.getParameter("itemID"),""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("pop", request.getParameter("pop"));
			model.put("modelID", StringUtil.checkNull( request.getParameter("modelID"),""));
			model.put("ModelID", StringUtil.checkNull( request.getParameter("modelID"),""));
			model.put("getWidth", StringUtil.checkNull( request.getParameter("getWidth"),"1024"));
			model.put("option", StringUtil.checkNull(commandMap.get("option")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			
			Map authMap = new HashMap();
			String itemAthId = "";
			String blocked = "";
			String ItemTypeCode ="";
			
			authMap.put("itemId", StringUtil.checkNull(request.getParameter("s_itemID"),"")); 
			Map result  = mdItemService.select("fileMgt_SQL.selectItemAuthorID",authMap);
		
			model.put("selectedItemAuthorID", StringUtil.checkNull(result.get("AuthorID")));
			model.put("selectedItemBlocked", StringUtil.checkNull(result.get("Blocked")));
			model.put("selectedItemLockOwner", StringUtil.checkNull(result.get("LockOwner")));
			model.put("itemClassCode", StringUtil.checkNull(result.get("ClassCode")));
			model.put("selectedItemStatus", StringUtil.checkNull(result.get("Status")));
			model.put("ItemTypeCode", StringUtil.checkNull(result.get("ItemTypeCode")));
			model.put("itemInfo", result);
			model.put("s_itemID", s_itemID);
			model.put("ReportCode", StringUtil.checkNull(request.getParameter("ReportCode"),""));			
			model.put("gridChk", StringUtil.checkNull(request.getParameter("gridChk"),"element"));
			model.put("classCode", StringUtil.checkNull(request.getParameter("classCode"), ""));
			/*
			 * model.put("searchKey",
			 * StringUtil.checkNull(request.getParameter("searchKey"), ""));
			 * model.put("searchValue",
			 * StringUtil.checkNull(request.getParameter("searchValue"), ""));
			 * model.put("groupClassCode",
			 * StringUtil.checkNull(request.getParameter("groupClassCode"), ""));
			 * model.put("groupElementCode",
			 * StringUtil.checkNull(request.getParameter("groupElementCode"), ""));
			 * model.put("showChild",
			 * StringUtil.checkNull(request.getParameter("showChild")));
			 */
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
			
			// pop up 창에서 편집 버튼 제어 용
			model.put("pop", StringUtil.checkNull(request.getParameter("pop"),""));
			// 개요 화면에서 본 이벤트를 호출했을때 구분을 위한 파라메터
			model.put("isFromMain", StringUtil.checkNull(request.getParameter("isFromMain"),""));
			
			authMap.put("s_itemID",s_itemID);
			String itemBlocked = commonService.selectString("project_SQL.getItemBlocked", authMap);
			model.put("itemBlocked", itemBlocked);

			String viewYN = "";
			String myItemYN = StringUtil.checkNull(model.get("myItem"),"");
			viewYN = myItemYN.equals("Y") ? "N" : "Y"; 
			model.put("viewYN", viewYN);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
}

