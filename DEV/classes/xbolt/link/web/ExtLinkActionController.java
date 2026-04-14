package xbolt.link.web;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
public class ExtLinkActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	
	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
	
	@Resource(name = "commonOraService")
	private CommonService commonOraService;
	
	@RequestMapping(value="/runSAPTransaction.do")
	public String runSAPTransaction(Map cmmMap,ModelMap model, HttpServletRequest request) throws Exception {
		Map setMap = new HashMap();
		String url = "/custom/sap/runSAPTransaction";
		String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
		String attrTypeCode = "AT00039";
		
		
		String t_code = "";
		String languageID = GlobalVal.DEFAULT_LANGUAGE;
		
	
		setMap.put("attrTypeCode", attrTypeCode);
		setMap.put("itemID", itemID);
		setMap.put("languageID", languageID);
		t_code = commonService.selectString("link_SQL.getAttrValue", setMap);
		
		setMap.put("s_itemID", itemID);
		Map tempMap = commonService.select("link_SQL.getAttrVarfilter", setMap);
		String SAPshortCutPath = StringUtil.checkNull(tempMap.get("VarFilter"));
		if(t_code == null || t_code.equals("")) {
			setMap.put("ITEM_ID", itemID);
			Map itemInfo = commonService.select("item_SQL.selectItemInfo", setMap);
			t_code = StringUtil.checkNull(itemInfo.get("Identifier"));
		}
		String sapUrl = SAPshortCutPath + t_code;
		
		model.put("sapUrl",sapUrl);
		return nextUrl(url);
	
	}	
	
	@RequestMapping (value="/getAttrLinkList.do")
	public String getAttrLinkList(Map cmmMap,ModelMap model, HttpServletResponse response) throws Exception {
		Map setMap = new HashMap();
		try{
			String itemID = StringUtil.checkNull(cmmMap.get("itemID"),"");
			setMap.put("itemID", StringUtil.checkNull(cmmMap.get("itemID"),""));
			setMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),""));
			setMap.put("itemClassCode", StringUtil.checkNull(cmmMap.get("itemClassCode"),""));
			List resultData = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap);
			
			Map linkMap = new HashMap();
			String url = "";
			String link = "";
			String lovCode = "";
			String attrTypeCode = "";
			for(int i=0; i < resultData.size(); i++){
				linkMap = (HashMap)resultData.get(i);
				if(i == 0){
					url = StringUtil.checkNull(linkMap.get("URL"),"");
					link = StringUtil.checkNull(linkMap.get("LinkName"),"");
					lovCode = StringUtil.checkNull(linkMap.get("LovCode"),"");
					attrTypeCode = StringUtil.checkNull(linkMap.get("AttrTypeCode"),"");
				}else{
					url += ","+StringUtil.checkNull(linkMap.get("URL"),"");
					link += ","+StringUtil.checkNull(linkMap.get("LinkName"),"");
					lovCode = ","+StringUtil.checkNull(linkMap.get("LovCode"),"");
					attrTypeCode = ","+StringUtil.checkNull(linkMap.get("AttrTypeCode"),"");
				}
			}						
		
			response.setCharacterEncoding("UTF-8"); // 한글깨짐현상 방지
			PrintWriter out = response.getWriter();
		    out.append(link);
		    out.append("/");
		    out.append(url);
		    out.append("/");
		    out.append(lovCode);
		    out.append("/");
		    out.append(attrTypeCode);
		    out.append("/");
		    out.append(StringUtil.checkNull(resultData.size()));
		    out.flush();
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/runSysLink.do")
	public String runSysLink(Map commandMap,ModelMap model, HttpServletRequest request) throws Exception {
		Map setMap = new HashMap();
		String itemID = StringUtil.checkNull(commandMap.get("itemID"));
		// String attrTypeCode = "AT00014";
		String attrTypeCode = StringUtil.checkNull(commandMap.get("attrTypeCode"),"AT00014");
		
		setMap.put("attrTypeCode", attrTypeCode);
		setMap.put("itemID", itemID);
		setMap.put("languageID", commandMap.get("sessionDefLanguageId"));			
		String LinkParameter = commonService.selectString("link_SQL.getAttrValue", setMap);
		String url = commonService.selectString("link_SQL.getAttrUrl", setMap);
		
		if(attrTypeCode.equals("AT00014") || attrTypeCode.equals("AT00039")) {
			url = StringUtil.checkNull(url) + StringUtil.checkNull(LinkParameter);
		} else{
			url = StringUtil.checkNull(url);
		}
		return redirect(url);	
	}
	
	@RequestMapping(value="/runSysOptionList.do")
	public String runSysOptionList(Map commandMap,ModelMap model, HttpServletRequest request) throws Exception {
		String url = "/popup/selectSysPop";
		
		model.put("menu", getLabel(request, commonService));
		
		Map target = new HashMap();
		Map setMap = new HashMap();
		String itemID = StringUtil.checkNull(commandMap.get("itemID"));
		String attrTypeCode = StringUtil.checkNull(commandMap.get("attrTypeCode"),"AT00014");
		String classCode = StringUtil.checkNull(commandMap.get("classCode"),"CL04005");
		
		setMap.put("attrTypeCode", attrTypeCode);
		// setMap.put("itemID", itemID);
		setMap.put("s_itemID", itemID);
		setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
		setMap.put("ClassCode", classCode);
		
		List cxnItemList = (List) commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
		
		model.put("attrTypeCode", attrTypeCode);
		model.put("s_itemID", itemID);
		model.put("languageID", commandMap.get("sessionDefLanguageId"));	
		
		if (cxnItemList.size() == 0) {
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(url);
		} else {
			JSONArray gridData = new JSONArray(cxnItemList);
			model.put("gridData", gridData);
			return nextUrl(url);	
		}
		
		
//		String LinkParameter = commonService.selectString("link_SQL.getAttrValue", setMap);
//		String[] split_arr = LinkParameter.split(",");
//		System.out.println("====================================");
//		System.out.println("배열의 크기: " + split_arr.length);
//		System.out.println(LinkParameter);
//		System.out.println(url);
//		System.out.println("====================================");
//		
//		String url = commonService.selectString("link_SQL.getAttrUrl", setMap);
//		if(attrTypeCode.equals("AT00014") || attrTypeCode.equals("AT00039")) {
//			url = StringUtil.checkNull(url) + StringUtil.checkNull(LinkParameter);
//		} else{
//			url = StringUtil.checkNull(url);
//		}
//		return nextUrl(url);	
	}	
	
	@RequestMapping(value="/extWebServiceMgt.do")
	public String extWebServiceMgt(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		String url = "/itm/sub/extWebServiceMgt";
		String languageID = StringUtil.checkNull(cmmMap.get("languageID"));
		String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
		String extUrl =  StringUtil.checkNull(cmmMap.get("extUrl"));
		String isPopup =  StringUtil.checkNull(cmmMap.get("isPopup"));
		String getUserInfo =  StringUtil.checkNull(cmmMap.get("getUserInfo"));
				
		cmmMap.put("arcCode", "AR000000");
		cmmMap.put("menuID", "MN015");
		cmmMap.put("languageID", languageID);
		
		Map ewInfo = commonService.select("link_SQL.getExtWebServiceInfo", cmmMap);
		cmmMap.put("attrTypeCode", "AT00014");
		cmmMap.put("s_itemID", s_itemID);

		Map tempMap = commonService.select("link_SQL.getAttrVarfilter", cmmMap);
		
		if(tempMap != null && !tempMap.isEmpty()) {
			extUrl = "?" + StringUtil.checkNull(tempMap.get("VarFilter")) + "=" + StringUtil.checkNull(tempMap.get("PlainText"));
		}
		model.put("menu", getLabel(request, commonService)); /* Label Setting */
		model.put("ewInfo",ewInfo);
		model.put("extUrl",extUrl);
		model.put("isPopup",isPopup);
		model.put("getUserInfo",getUserInfo);

		return nextUrl(url);
	}
	
	private String getMLovVlaue(String languageID, String itemID, String attrTypeCode) throws ExceptionUtil {
		List mLovList = new ArrayList();
		Map setMap = new HashMap();
		String plainText = "";
		try {
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("languageID", languageID);
			setMap.put("defaultLang", defaultLang);			
			setMap.put("itemID", itemID);
			setMap.put("attrTypeCode", attrTypeCode);
			mLovList = commonService.selectList("attr_SQL.getMLovList",setMap);
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
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return plainText;
	}
	
    //중복제거 메소드, key는 제거할 맵 대상
    public static List<HashMap<Object, Object>> distinctArray(List<HashMap<Object, Object>> target, Object key){ 
        if(target != null){
            target = target.stream().filter(distinctByKey(o-> o.get(key))).collect(Collectors.toList());
        }
        return target;
    }

    //중복 제거를 위한 함수
    public static <T> Predicate<T> distinctByKey(Function<? super T,Object> keyExtractor) {
        Map<Object,Boolean> seen = new ConcurrentHashMap<>();
        return t -> seen.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
	    
	}
	
}