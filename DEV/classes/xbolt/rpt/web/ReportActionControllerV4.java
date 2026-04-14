package xbolt.rpt.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.nimbusds.jose.shaded.json.JSONObject;
import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

/**
 * 분석/통계
 * @Class Name : ReportActionController.java
 * @Description : 분석/통계관련 Biz.
 * @Modification Information
 * @수정일			수정자		수정내용
 * @--------- 		---------	-------------------------------
 * @2013. 01. 22.	bshy		최초생성
 *
 * @since 2013. 01. 22
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class ReportActionControllerV4 extends XboltController{

	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value="/reportListV4.do")
	public String reportListV4(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		
		String url = "itm/sub/reportListV4";
		
		try{
			List getList = new ArrayList();
			Map getMap = new HashMap();
			
			String kbn = StringUtil.checkNull(request.getParameter("kbn"));
			
			getMap.put("s_itemID", request.getParameter("s_itemID"));
			getMap.put("languageID", commandMap.get("sessionCurrLangType"));
			getMap.put("AuthLev", commandMap.get("sessionAuthLev"));
			getMap.put("defLanguageID", commandMap.get("sessionDefLanguageId"));
					
			getList = commonService.selectList("report_SQL.getReportList",getMap);
			
			// IsPublic = 0 인 reportList들은 선택된 Item의 AuthorID와 로그인 유저 ID를 비교해서 
			// 같을 경우 만 reportList에 남겨두고, 다를 경우는 reportList에서 제외 한다
			String loginUser = String.valueOf(commandMap.get("sessionUserId"));
			if (!"1".equals(String.valueOf(commandMap.get("sessionAuthLev")))) {
				for (int i = 0; getList.size() > i; i++) {
					Map map = (Map) getList.get(i);
					String IsPublic = StringUtil.checkNull(map.get("IsPublic"));
					String SeqLevel = StringUtil.checkNull(map.get("SeqLevel"));
					if ("0".equals(IsPublic) || "1".equals(SeqLevel)) {
						String itemAuthorID = StringUtil.checkNull(map.get("AuthorID"));
						if (!itemAuthorID.equals(loginUser)) {
							getList.remove(i);
							i = i - 1;
						}
					}
				}
			}
			
			model.put("getList", getList);
			model.put("menu", getLabel(request, commonService));
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("option", request.getParameter("option"));
			model.put("kbn", kbn);
			model.put("backBtnYN", request.getParameter("backBtnYN"));
			model.put("accMode", request.getParameter("accMode"));
			model.put("scrnType", request.getParameter("scrnType"));
			model.put("defDimValueID", StringUtil.checkNull(commandMap.get("defDimValueID")));
			model.put("mstItemID", StringUtil.checkNull(commandMap.get("mstItemID")));
			model.put("strItemID", StringUtil.checkNull(commandMap.get("strItemID")));
			model.put("structureID", StringUtil.checkNull(commandMap.get("structureID")));
			model.put("udfSTR", StringUtil.checkNull(commandMap.get("udfSTR")));
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);
	}
	
	 // [페이지 호출] Dimension에 할당된 아이템 목록 호출
	 @RequestMapping(value="/itemTypeDimValueListRPT.do")
	 public String itemTypeDimValueListRPT(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		 String url = "/report/itemTypeDimValueList";
		 try {
			 String itemID = StringUtil.checkNull(commandMap.get("itemID"));

			 model.put("dimTypeID", itemID);
			 model.put("menu", getLabel(request, commonService));

		 } catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		 }
		 return nextUrl(url);
	}	
	
}
