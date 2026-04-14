package xbolt.api.web;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import net.sf.json.JSONArray;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@RestController //Controller 라는 것을 명시 @Controller + @RequestBody 
@RequestMapping("/olmapi")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class OlmApiActionController extends XboltController{
	
	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
	
	String tokenKey = "ceb1473d.53a95db76acc419ab6f3976f099287fb";
	
	@RequestMapping(value = "/olmItemSearchAPI", method = RequestMethod.GET)
	//@RequestMapping(method = RequestMethod.GET)
	@ResponseBody //  @ResponseBody 를 쓸때는 view를 찾지 요청들어오는 페이지의 body 에 붓는 형태
    public void olmItemSearchAPI(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		Map setData = new HashMap();
		String  resultJson = "";
		Map itemMap = new HashMap();
		Map fileMap = new HashMap();
		List totalList = new ArrayList();
		try {
			String query = StringUtil.checkNull(request.getParameter("query"));
			String mode = StringUtil.checkNull(request.getParameter("mode"));
			String sort = StringUtil.checkNull(request.getParameter("sort"),"ITEM_TYPE_CD, ITEM_CD");
			String listCount = StringUtil.checkNull(request.getParameter("listCount"),"100");
			String searchField = StringUtil.checkNull(request.getParameter("searchField"));
			String itemCD = StringUtil.checkNull(request.getParameter("itemCD"));
			String itemNM = StringUtil.checkNull(request.getParameter("itemNm"));
			String itemTypeNM = StringUtil.checkNull(request.getParameter("itemTypeNM"));
			String authorNM = StringUtil.checkNull(request.getParameter("authorNm"));
			String authorEmpNo = StringUtil.checkNull(request.getParameter("authorEmpNo"));
			String itemStatusNM = StringUtil.checkNull(request.getParameter("itemStatusNm"));
			String teamNM = StringUtil.checkNull(request.getParameter("teamNm"));
			String itemContent = StringUtil.checkNull(request.getParameter("itemContents"));
			String languageID = StringUtil.checkNull(request.getParameter("LANGUAGE_ID"),"1042");
			String itemTypeCD = StringUtil.checkNull(request.getParameter("itemTypeCd"));
			
			setData.put("searchValue",query);
			setData.put("LANGUAGE_ID",languageID);
			
			if("basic".equals(mode)) {
				setData.put("searchField",searchField);
			}
			else {

				setData.put("DETAILE",mode);
				setData.put("ITEM_CD",itemCD);
				setData.put("ITEM_NM",itemNM);
				setData.put("ITEM_TYPE_NM",itemTypeNM);
				setData.put("AUTHOR_NM",authorNM);
				setData.put("AUTHOR_EMP_NO",authorEmpNo);
				setData.put("ITEM_STATUS_NM",itemStatusNM);
				setData.put("TEAM_NM",teamNM);
				setData.put("ITEM_CONTENT",itemContent);
				
				setData.put("itemTypeCD",itemTypeCD);
			}
			setData.put("sort", sort);
			setData.put("listCount", listCount);
			
			List itemList = commonService.selectList("search_SQL.getSearchForItemView", setData);
			List itemList2 = new ArrayList();
			String itemIDs = "";
			if(itemList != null && !itemList.isEmpty()) {
				
				for(int i=0; i < itemList.size(); i++) {
					Map temp = (Map)itemList.get(i);
					
					String itemContents = removeAllTag(StringUtil.checkNull(temp.get("ITEM_CONTENTS")));
					int queryIndex = itemContents.indexOf(query);
					int lastIndex = itemContents.length() > 300 ? 100 : itemContents.length() - queryIndex;
					int startIndex = queryIndex > 20 ? queryIndex - 20 : 0;
					itemContents = itemContents.substring(startIndex,(itemContents.length() < queryIndex+lastIndex ? itemContents.length() : queryIndex+lastIndex));
					temp.remove("ITEM_CONTENTS");
					temp.put("ITEM_CONTENTS",itemContents);
					itemList2.add(temp);
					
					String itemID = StringUtil.checkNull(temp.get("ITEM_ID"));
					if(i == 0) {
						itemIDs = itemID;
					}else { itemIDs += ","+ itemID; }
				}
				itemMap.put("CollListCount",itemList.size());
				fileMap.put("CollTotCount",itemList.size());
				itemMap.put("Document",itemList2);
				itemMap.put("CollectionName","OLM_ITEM");
			}
			else {
				itemMap.put("CollListCount","0");
				fileMap.put("CollTotCount","0");
				itemMap.put("Document","");
				itemMap.put("CollectionName","OLM_ITEM");				
			}
			
			totalList.add(itemMap);
			
			setData.put("itemIDs", itemIDs);
			//System.out.println("itemIDs :"+itemIDs);
			List fileList = commonService.selectList("search_SQL.getSearchForFileView", setData);

			if(fileList != null && !fileList.isEmpty()) {
				fileMap.put("CollListCount",fileList.size());
				fileMap.put("CollTotCount",fileList.size());
				fileMap.put("Document",fileList);
				fileMap.put("CollectionName","OLM_FILE");
			}
			else {
				fileMap.put("CollListCount","0");
				fileMap.put("CollTotCount","0");
				fileMap.put("Document","");
				fileMap.put("CollectionName","OLM_FILE");				
			}
			
			totalList.add(fileMap);
			
			
			JSONArray jObj = JSONArray.fromObject(totalList);

			//response.setCharacterEncoding("UTF-8");
			response.setContentType("application/json; charset=UTF-8");
			response.getWriter().print(jObj);
	   } catch(Exception e) {
       	throw new ExceptionUtil(e.toString());
       }

    }	
	
	private String removeAllTag(String str) {

		str = str.replaceAll("&lt;", "<");//201610 new line :: Excel To DB 
		str = str.replaceAll("&gt;", ">");//201610 new line :: Excel To DB 
		str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
	}
	private String removeAllTag(String str,String type) { 
		if(type.equals("DbToEx")){//201610 new line :: DB To Excel
			str = str.replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-");//20161024 bshyun Test
		}else{
			str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		}
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		if(type.equals("DbToEx")){
			str = str.replaceAll("&&rn", "\n");
		}
		return StringEscapeUtils.unescapeHtml4(str);
	}	
	
	
}