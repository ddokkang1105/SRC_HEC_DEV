package xbolt.custom.hyundai.hec.web;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;




import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.custom.hanwha.val.HanwhaGlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;


/**
 * 怨듯넻 �꽌釉붾┸ 泥섎━
 * @Class Name : MainHecActionController.java
 * @Description : 怨듯넻�솕硫댁쓣 �젣怨듯븳�떎.
 * @Modification Information
 * @�닔�젙�씪		�닔�젙�옄		 �닔�젙�궡�슜
 * @---------	---------	-------------------------------
 * @2019. 09.09. smartfactory		理쒖큹�깮�꽦
 *
 * @since 2019. 09. 09.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class MainHecActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	
	@RequestMapping(value="/mainHomeHec.do")
	public String mainHomeHWC(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		Map target = new HashMap();
		try{
			Map setMap = new HashMap();
			setMap.put("teamID", cmmMap.get("sessionTeamId"));
			String teamCnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			setMap.remove("teamID");
			setMap.put("authorID", cmmMap.get("sessionUserId"));
			String authorCnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			setMap.remove("authorID");
			
			setMap.put("itemTypeCode", "OJ00001");
			setMap.put("itemClassCode", "CL01005");
			setMap.put("l1ItemID", "101057");
			String p1Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			setMap.put("itemTypeCode", "OJ00001");
			setMap.put("itemClassCode", "CL01005");
			setMap.put("l1ItemID", "101059");
			String p2Cnt = StringUtil.checkNull(commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap),"0");

			setMap.put("itemTypeCode", "OJ00001");
			setMap.put("itemClassCode", "CL01005");
			setMap.put("l1ItemID", "101061");
			String p3Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);
			
			setMap.put("itemTypeCode", "OJ00001");
			setMap.put("itemClassCode", "CL01005");
			setMap.put("l1ItemID", "145913");
			String p4Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			setMap.put("itemTypeCode", "OJ00001");
			setMap.put("itemClassCode", "CL01005");
			setMap.put("l1ItemID", "101063");
			String p5Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			setMap.remove("l1ItemID");
			
			setMap.remove("l2ItemID");
			setMap.put("itemTypeCode", "OJ00005");
			setMap.put("itemClassCode", "CL05003");
			setMap.put("l0ItemID", "123850");
			String sop1Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);
			
			setMap.put("itemTypeCode", "''");
			setMap.put("itemClassCode", "CL05003");
			setMap.put("l0ItemID", "125704");
			String sop2Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			setMap.put("itemTypeCode", "OJ00005");
			setMap.put("itemClassCode", "CL05003");
			setMap.put("l0ItemID", "125706");
			String sop3Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			setMap.put("itemTypeCode", "OJ00005");
			setMap.put("itemClassCode", "CL05003");
			setMap.put("l0ItemID", "125708");
			String sop4Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			setMap.remove("l0ItemID");
			setMap.put("itemTypeCode", "OJ00005");
			setMap.put("itemClassCode", "CL05003");
			setMap.put("l1ItemID", "125106");
			String sop5Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);			

			setMap.remove("l1ItemID");
			setMap.put("itemTypeCode", "OJ00016");
			setMap.put("itemClassCode", "CL16004");
			setMap.put("l0ItemID", "133167");
			String stp1Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);
			
			setMap.put("itemTypeCode", "OJ00016");
			setMap.put("itemClassCode", "CL16004");
			setMap.put("l0ItemID", "125839");
			String stp2Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			setMap.put("itemTypeCode", "OJ00016");
			setMap.put("itemClassCode", "CL16004");
			setMap.put("l0ItemID", "158323");
			String stp3Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			setMap.put("itemTypeCode", "OJ00016");
			setMap.put("itemClassCode", "CL16004");
			setMap.put("l0ItemID", "158325");
			String stp4Cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);
			
			// ADD GEC 
			setMap.put("itemTypeCode", "OJ00005");
			setMap.put("itemClassCode", "CL05003");
			setMap.put("l0ItemID", "225568");
			String sopGecCnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);
			
			setMap.put("itemTypeCode", "OJ00016");
			setMap.put("itemClassCode", "CL16004");
			setMap.put("l0ItemID", "225570");
			String stpGecCnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);

			model.put("p1Cnt", p1Cnt);
			model.put("p2Cnt", p2Cnt);
			model.put("p3Cnt", p3Cnt);
			model.put("p4Cnt", p4Cnt);
			model.put("p5Cnt", p5Cnt);
			model.put("sop1Cnt", sop1Cnt);
			model.put("sop2Cnt", sop2Cnt);
			model.put("sop3Cnt", sop3Cnt);
			model.put("sop4Cnt", sop4Cnt);
			model.put("sop5Cnt", sop5Cnt);
			model.put("stp1Cnt", stp1Cnt);
			model.put("stp2Cnt", stp2Cnt);
			model.put("stp3Cnt", stp3Cnt);
			model.put("stp4Cnt", stp4Cnt);
			model.put("teamCnt", teamCnt);
			model.put("authorCnt", authorCnt);
			model.put("sopGecCnt", sopGecCnt);
			model.put("stpGecCnt", stpGecCnt);
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
		}
		
		model.put("menu", getLabel(request, commonService));
		return nextUrl("/custom/hyundai/hec/mainHomeHec");
	}
	

	@RequestMapping(value="/zHecGetSubItemList.do")
	public String zHecGetSubItemList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url = "";
		try{
			Map setMap = new HashMap();
			String itemList = "";
	    	String s_itemID = StringUtil.checkNull(cmmMap.get("selectItemID"));
	    	String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
	    	setMap.put("s_itemID", s_itemID);	    	
	    	setMap.put("languageID", languageID);
	    	
	    	List subList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
			
			if(subList != null && !subList.isEmpty()) {
				for(int i=0; i< subList.size(); i++) {
					Map temp = (Map) subList.get(i);
					
					if(i == 0) {
						itemList = temp.get("ItemID") + "_" + temp.get("ItemName");
					}
					else {
						itemList += "@" + temp.get("ItemID") + "_" + temp.get("ItemName");
					}
					
					
					String cnt = commonService.selectString("zHEC_SQL.zhec_GetItemCnt", setMap);
			    	setMap.put("l1ItemID", s_itemID);	    	
			    	setMap.put("itemTypeCode", temp.get("ItemTypeCode"));
					itemList += "_" + cnt;
				}
			}
			target.put(AJAX_SCRIPT, "setSubItemListDiv('"+itemList+"');$('#isSubmit').remove();");	
		
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	

	
}
