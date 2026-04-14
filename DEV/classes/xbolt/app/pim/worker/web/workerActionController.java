package xbolt.app.pim.worker.web;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
/**
 * 공통 서블릿 처리
 * @Class Name : InstnceActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2018. 06. 07. Smartfactory / sykang		최초생성
 *
 * @since 2018. 06. 07
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class workerActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value = "/pim_ProcWorkerList.do")
	public String pim_ProcWorkerList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/pim/worker/pim_ProcWorkerList";
		Map getMap = new HashMap();
		try {
			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"));
			String processID = StringUtil.checkNull(request.getParameter("processID"));
			String stepID = StringUtil.checkNull(request.getParameter("stepID"));
			String gubun;
			
			List workerRelTeamList = new ArrayList();
			// get 조직
			commandMap.put("ProcInstNo", instanceNo);
			
			if(stepID != null && stepID != ""){
				gubun = "S";
				workerRelTeamList = commonService.selectList("worker_SQL.getStepRelTeam", commandMap);
			} else{
				gubun = "P";
				workerRelTeamList = commonService.selectList("worker_SQL.getProcRelTeam", commandMap);
			}
			
			model.put("gubun", gubun);
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("workerRelTeamList", workerRelTeamList);
			model.put("instanceNo",instanceNo);	
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/		
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	/*@RequestMapping(value = "/pim_SelectMemberPop.do")
	public String pim_SelectMemberPop(HttpServletRequest request, HashMap cmmMap, ModelMap model)throws Exception {
		
		String url = "/app/pim/worker/pim_SelectMemberPop";
		try {
	
				model.put("ProcInstNo", StringUtil.checkNull(request.getParameter("ProcInstNo")));
				model.put("menuStyle", "csh_organization");
				model.put("memArr", StringUtil.checkNull(request.getParameter("memArr")));
				model.put("isProject", StringUtil.checkNull(request.getParameter("isProject")));
				model.put("arcCode", "AR000002");
				model.put("menu", getLabel(request, commonService));  Label Setting 

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/pim_AssignMembers.do")
	public String pim_AssignMembers(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		try {
				String memberIds = StringUtil.checkNull(commandMap.get("memberIds"));
				String teamID = StringUtil.checkNull(commandMap.get("teamID"));
				String ProcInstNo = StringUtil.checkNull(commandMap.get("ProcInstNo"));
						
				String[] arrayMember = memberIds.split(",");
				setMap.put("teamID", teamID);	
				setMap.put("ProcInstNo", ProcInstNo);
				setMap.put("Creator", commandMap.get("sessionUserId"));
				
				String WorkerCode = commonService.selectString("worker_SQL.getMaxWorkerCode",setMap);
				setMap.put("WorkerCode", WorkerCode);
				commonService.delete("worker_SQL.delWorkerMemberRel", setMap);	// projectID,teamID 일치하는것 모두 삭제 
				if(!memberIds.equals("")){
					for(int i = 0 ; i < arrayMember.length; i++){
						String memberId = arrayMember[i];
						setMap.put("MemberID", memberId);
						commonService.delete("worker_SQL.createWorkerMemberRel", setMap);				
					}
				}
			
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 성공															
				target.put(AJAX_SCRIPT, "this.fnCallBack();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}*/
	
}
