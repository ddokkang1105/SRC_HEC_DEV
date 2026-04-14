package xbolt.mypage.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;
/**
 * @Class Name : MyFavoriteActionController.java
 * @Description : 즐겨찾기 컨트롤 
 * @Modification Information
 * @수정일			수정자		수정내용
 * @--------- 		---------	-------------------------------
 * @2013. 11. 26.	jhAhn		최초생성
 *
 * @since 2013. 11. 26.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class MyFavoriteActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "mypageService")
	private CommonService mypageService;
	
	@RequestMapping(value="/MyFavorite.do")
	public String MyFavorite(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{
			
			Map setMap = new HashMap();
			
			setMap.put("MemberID", request.getParameter("UserID"));
			//setMap.put("ArcCode", request.getParameter("option"));
			setMap.put("AssignmentType", "2");
			
			String message = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067");
			
			if(StringUtil.checkNull(request.getParameter("favoriteType"),"add").equals("add")){
				setMap.put("ItemID", request.getParameter("s_itemID"));
				setMap.put("GUBUN", "insert");
				mypageService.save(setMap);
			}else{
//				if(StringUtil.checkNull(request.getParameter("favoriteType"),"add").equals("del")){
				setMap.put("ItemID", request.getParameter("s_itemID"));
				setMap.put("GUBUN", "delete");
				mypageService.save(setMap);
				message = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069");
			}
			
			target.put(AJAX_ALERT, message);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
		}
		catch (Exception e) {
			System.out.println(e);
			//target.put(AJAX_ALERT, "즐겨찾기 관련 처리줄 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		return nextUrl(AJAXPAGE);
	}
	


}
