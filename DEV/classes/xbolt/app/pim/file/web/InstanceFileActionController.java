package xbolt.app.pim.file.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

/**
 * 공통 서블릿 처리
 * @Class Name : InstnceFileActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class InstanceFileActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	

	@RequestMapping(value="/pim_instanceFileList.do")
	public String pim_instanceFileList(HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "/app/pim/file/pim_instanceFileList";
		String processID = StringUtil.checkNull(request.getParameter("processID"), "");		
		String fileOption = StringUtil.checkNull(request.getParameter("fileOption"),"OLM");	
		String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
		String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"),"");
		String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");	
		String stepID = StringUtil.checkNull(request.getParameter("stepID"), "");	
		
		try {
		
			if(!"".equals(varFilter)){
				model.put("fileOption", varFilter);
			}else {
				model.put("fileOption", fileOption);
			}
			
			model.put("pageScale", GlobalVal.LIST_PAGE_SCALE);
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("frmType", request.getParameter("frmType"));
			model.put("backBtnYN", request.getParameter("backBtnYN"));
			
			model.put("processID", processID);
			model.put("stepID", stepID);
			model.put("instanceNo", instanceNo);
			model.put("instanceClass", instanceClass);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveInstanceFile.do")
	public String saveInstanceFile(HttpServletRequest request,HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		String processID 	= StringUtil.checkNull(cmmMap.get("id"), "");
		String instanceNo 	= StringUtil.checkNull(cmmMap.get("instanceNo"), "");
		String FltpCode = StringUtil.checkNull(cmmMap.get("fltpCode"), "");
		String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"), "");
		String fileMgt 	= StringUtil.checkNull(cmmMap.get("fileMgt"), "PIM");
		String userId 	= StringUtil.checkNull(cmmMap.get("usrId"), "");
		String linkType = StringUtil.checkNull(cmmMap.get("linkType"), "1");
		
		try{
			List fileList = new ArrayList();
			Map fileMap = new HashMap();
			Map setData = new HashMap();
			
			setData.put("FltpCode", FltpCode);		
			String filePath = StringUtil.checkNull(fileMgtService.selectString("fileMgt_SQL.getDocFilePath",setData),GlobalVal.FILE_UPLOAD_ITEM_DIR);
			
			cmmMap.put("itemId", processID);
			cmmMap.put("KBN", "insert");
			
			int seq = Integer.parseInt(commonService.selectString("instanceFile_SQL.getInstancFileID", cmmMap));
			//Read Server File
			String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//";
			String targetPath = filePath;
			List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
			
			// DRM 복호와 정보 
			
			HashMap drmInfoMap = new HashMap();			
			String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(cmmMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(cmmMap.get("sessionTeamName"));			
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			
			if(tmpFileList != null){					
				for(int i=0; i<tmpFileList.size();i++){
					fileMap=new HashMap(); 
					HashMap resultMap=(HashMap)tmpFileList.get(i);
					fileMap.put("fileID", seq);
					fileMap.put("FltpCode", FltpCode);
					fileMap.put("instanceClass", instanceClass);
					fileMap.put("instanceNo", instanceNo);
					fileMap.put("itemID", processID);
					fileMap.put("linkType", linkType);
					fileMap.put("fileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
					fileMap.put("fileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
					fileMap.put("fileSize", resultMap.get(FileUtil.FILE_SIZE));
					fileMap.put("fileMgt", fileMgt);
					fileMap.put("filePath", filePath);
					fileMap.put("userID", userId);
					fileMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					fileMap.put("SQLNAME", "instanceFile_SQL.insertInstanceFile");	
					
					// File DRM 복호화 					
					String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
					String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
					if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
						//DRMUtil.setDRM(drmInfoMap);
						drmInfoMap.put("ORGFileDir", targetPath);
						drmInfoMap.put("DRMFileDir", targetPath);
						drmInfoMap.put("Filename", resultMap.get(FileUtil.UPLOAD_FILE_NM));
						drmInfoMap.put("funcType", "upload");
						String returnValue = DRMUtil.drmMgt(drmInfoMap); // 암호화 
					}
					
					fileList.add(fileMap);
					seq++;
				}
			}
			fileMgtService.save(fileList, cmmMap);
			
			//target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,  "parent.viewMessage();parent.$('#isSubmit').remove();");	
		}catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.dhtmlx.alert('" + MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068") + "');parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
}
