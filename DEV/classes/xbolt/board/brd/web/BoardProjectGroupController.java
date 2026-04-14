package xbolt.board.brd.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

@Controller
public class BoardProjectGroupController extends XboltController{
	
	
	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
	
	@RequestMapping(value="/boardProjectGroupList.do")
	public String boardProjectGroupList(HttpServletRequest request, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		List getProcess = new ArrayList();		
		try {
			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"PJT"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		

		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/board/brd/boardProjectGroupList");
	}
}