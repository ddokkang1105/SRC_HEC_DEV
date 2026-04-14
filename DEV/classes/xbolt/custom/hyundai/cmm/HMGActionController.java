package xbolt.custom.hyundai.cmm;


import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.security.cert.X509Certificate;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import javax.xml.transform.dom.DOMSource;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;


import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;










/*
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;
import com.nets.sso.agent.AuthUtil;
import com.nets.sso.agent.authcheck.AuthCheck;
import com.nets.sso.common.AgentExceptionCode;
import com.nets.sso.common.enums.AuthStatus;
*/
import com.org.json.JSONObject;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.custom.hyundai.val.HMGGlobalVal;
import xbolt.custom.hyundai.val.HMGGlobalVal;
import xbolt.custom.hanwha.val.HanwhaGlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;


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
public class HMGActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
		
	@Resource(name = "mdItemService")
	private CommonService mdItemService;
	
	@Resource(name = "CSService")
	private CommonService CSService;

	@Resource(name = "CSActionController")
	private CSActionController CSActionController;
	
	// Approval Request 
	
	@RequestMapping("/zhdc_WFDocMgt.do")
	public String zhec_WFDocMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = HMGGlobalVal.wfDocOpenJspUrl;//"/custom/hyundai/hec/wf/zhec_goWorkflow";
		Map setMap = new HashMap();
		HashMap autoWayMap = new HashMap();
		String wfUrl = "";
		try {
			String isNew = StringUtil.checkNull(request.getParameter("isNew"));
			String wfStep = StringUtil.checkNull(request.getParameter("wfStep"));
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
			String isMulti = StringUtil.checkNull(request.getParameter("isMulti"));
			String wfStepInfo = StringUtil.checkNull(request.getParameter("wfStep"), "WF001"); // TODO
			String wfDocType = StringUtil.checkNull(request.getParameter("wfDocType"),"CS");
			String wfDocumentIDs = StringUtil.checkNull(request.getParameter("wfDocumentIDs"));
			String isPop = StringUtil.checkNull(request.getParameter("isPop"),"N");
			String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"));
			String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID"));
			String preWfInstanceID = StringUtil.checkNull(request.getParameter("preWfInstanceID"));
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"));
			String actionType = StringUtil.checkNull(request.getParameter("actionType"),"create");
			String isView = StringUtil.checkNull(request.getParameter("isView"),"Y");
			String backFunction = "wfInstanceList.do";
			String backMessage = "";
			String callbackData = "&wfMode=AREQ&screenType=MyPg&wfStepID=AREQ";
			String returnedValue = "";
			String comType = GlobalVal.OLM_SERVER_NAME;
			String emailType = "";
			String isProc = StringUtil.checkNull(request.getParameter("isProc"),"Y");

			setMap.put("changeSetID",changeSetID);
			String itemID = StringUtil.checkNull(commonService.selectString("task_SQL.getCsrItemID", setMap));
			
			setMap.put("s_itemID", itemID);
			String itemTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.selectedItemTypeCode", setMap));
			String itemClassCode = StringUtil.checkNull(commonService.selectString("item_SQL.selectedItemClassCode", setMap));

			setMap.put("wfDocType",wfDocType);
			setMap.put("docSubClass",itemClassCode);
			
			String MailVarFilter = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFIDForVarfilter", setMap));	
			Map varMap = new HashMap();
			if(!"".equals(MailVarFilter)) {
				
				String[] tempFilter = MailVarFilter.split("&");
				
				for(int i=0; i<tempFilter.length; i++) {
					String[] temp = tempFilter[i].split("=");
					varMap.put(temp[0],temp[1]);
				}
			
				emailType = StringUtil.checkNull(varMap.get("emailType"));
				//comType = StringUtil.checkNull(varMap.get("comType"));
				
			}
			
			if("Y".equals(isProc) && "H-WAY".equals(comType) ) {
				url = HMGGlobalVal.wfDocViewJspUrl; //"/custom/hyundai/hec/wf/zhec_goProcess";
				
				setMap.put("ChangeSetID", changeSetID);		
				Map getPJTMap = commonService.select("wf_SQL.getChangeSetInfoWF", setMap);

				List itemPath = new ArrayList();
				
				itemPath = getRootItemPath(itemID,StringUtil.checkNull(commandMap.get("languageID")),itemPath);
				Collections.reverse(itemPath);	
				
				String itemPathName = "";	
				if(itemPath != null && !itemPath.isEmpty()) {
					for(int i=0; i< itemPath.size(); i++) {
						Map temp = (Map)itemPath.get(i);
						
						if(i ==0) {
							itemPathName = StringUtil.checkNull(temp.get("PlainText"));
						}
						else {
							itemPathName = itemPathName + " > " + StringUtil.checkNull(temp.get("PlainText"));
							
						}
					}
				}
				model.put("getPJTMap", getPJTMap);
				model.put("itemPathName", itemPathName);
				
				return nextUrl(url);
				
			}
			
			if(!"".equals(wfInstanceID)) {
				setMap.put("wfInstanceID", wfInstanceID);
				returnedValue = StringUtil.checkNull(commonService.selectString("wf_SQL.getWfReturnedValue", setMap));				
			}
			
			if(!"".equals(wfInstanceID) && !"".equals(returnedValue) && "Y".equals(isView)) {
				
		    	autoWayMap.put("dftCompId" ,HMGGlobalVal.dftCompId);
		    	autoWayMap.put("lgyDocId" ,wfInstanceID);
		    	autoWayMap.put("LangType" ,"ko-KR");
		    	autoWayMap.put("lgySystemId" , comType);
		    	autoWayMap.put("dftUserId" , commandMap.get("sessionLoginId"));
		    	autoWayMap.put("dftDeptCode" ,"");
		    	autoWayMap.put("PID" ,returnedValue);
		    	wfUrl = HMGGlobalVal.wfViewAPIUrl;//"https://autowaywf.hyundai.net/HECWebService/ExternalWebService.asmx?wsdl";

	            String wfData = viewWfCreateXML(wfUrl,autoWayMap);
	            System.out.println(wfData);
	            
		        if(!"".equals(wfData)) {
		            JSONObject jo1 = new JSONObject(wfData);
		            
		            String returnUrl = StringUtil.checkNull(jo1.get("returnURL"));
		            String resultCode = StringUtil.checkNull(jo1.get("resultCode"));
		            String errMsg = StringUtil.checkNull(jo1.get("errMsg"));
		            
					model.put("returnUrl", returnUrl);
					model.put("resultCode", resultCode);
					model.put("errMsg", errMsg);
	            }
	            else {

					model.put("returnUrl", "");
					model.put("resultCode", "E");
					model.put("errMsg", "Error");
	            }
			}
			else {

				if("".equals(projectID)) {
					setMap.put("s_itemID", changeSetID);
					projectID = commonService.selectString("cs_SQL.getProjectIDForCSID", setMap);
				}
				
				Map labelMap = getLabel(request, commonService);

				String newWFInstanceID = "";
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
				String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setMap);
				String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
				int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();	
				String initLen = "%0" + (13-OLM_SERVER_NAME_LENGTH) + "d";
				
				int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
				int maxcode = maxWFInstanceID2 + 1;
				newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, maxcode);

				if(!"".equals(preWfInstanceID))
					wfInstanceID = preWfInstanceID;
				
				// �빀�쓽 /�듅�씤 �떒怨� 由ъ뒪�듃 痍⑤뱷				
				setMap.put("LanguageID", commandMap.get("languageID"));
				setMap.put("WFID", wfStepInfo);
				setMap.put("TypeCode", wfStepInfo);
				setMap.put("ProjectID", projectID);
				
				List wfStepList = commonService.selectList("wf_SQL.getWfStepList", setMap);
				
				String wfDescription = commonService.selectString("wf_SQL.getWFDescription", setMap);
				String MandatoryGRID = commonService.selectString("wf_SQL.getMandatoryGRID", setMap);

				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("projectID", projectID);
				String ProjectName = commonService.selectString("project_SQL.getProjectName", setMap);
				
				setMap.put("WFStepIDs", "'AREQ','APRV','AGR'");
				
				List wfStepInstList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
				int wfStepInstListSize = 0;
				if(wfStepInstList != null && !wfStepInstList.isEmpty())
					wfStepInstListSize = wfStepInstList.size();
				
				model.put("wfStepInstListSize", wfStepInstListSize);
				
				String wfStepInstInfo = "";
				String wfStepInstREFInfo = "";
				String wfStepInstAGRInfo = "";
				
				String wfStepMemberIDs = "";
				String wfStepRoleTypes = "";
				
				Map wfStepInstInfoMap = new HashMap();
				Map getPJTMap = new HashMap();
				
				setMap.put("dimTypeID", "100001");
				List regionList = commonService.selectList("dim_SQL.getDimValueNameList", setMap);
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("s_itemID", projectID);
				setMap.put("wfInstanceID", wfInstanceID);
				
				Map getMap = commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
				model.put("getMap", getMap);

				if(getMap != null && !getMap.isEmpty())
					setMap.put("DocCategory", getMap.get("DocCategory"));

				if(isMulti.equals("N")) {
					setMap.remove("s_itemID");
					setMap.put("ProjectID", projectID);
					setMap.put("ChangeSetID", changeSetID);		
					getPJTMap = commonService.select("wf_SQL.getChangeSetInfoWF", setMap);
					backFunction = "itemChangeInfo.do";
					callbackData = "&changeSetID="+request.getParameter("ChangeSetID")+"&screenMode=edit&StatusCode=MOD&isAuthorUser=&LanguageID="+commandMap.get("sessionCurrLangType");
					backMessage = StringUtil.checkNull(labelMap.get("LN00206"));
				}				
				else {
					setMap.put("wfInstanceID", wfInstanceID);
					getPJTMap = commonService.select("wf_SQL.getWFInstTXT", setMap);
					
				}
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("s_itemID", projectID);
				model.put("getPJTMap", getPJTMap);
				
				Map setData = new HashMap();
				if(StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV")){
					setData.put("ProjectID",projectID);
					setData.put("Status","CNG");
					commonService.update("project_SQL.updateProject",setData);
				}else if(StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV2")){
					setData.put("ProjectID",projectID);
					setData.put("Status","QA");
					commonService.update("project_SQL.updateProject",setData);
				}
		    	
				HashMap inserWFInstTxtData = new HashMap();
				HashMap insertWFStepData = new HashMap();
				HashMap insertWFStepRefData = new HashMap();
				HashMap insertWFInstData = new HashMap();
				HashMap updateData = new HashMap();
				HashMap updateCRData = new HashMap();
				
				insertWFInstData.put("WFInstanceID", newWFInstanceID);
				insertWFInstData.put("ProjectID", projectID);
				insertWFInstData.put("DocumentID", changeSetID);
				insertWFInstData.put("DocCategory", wfDocType);
				insertWFInstData.put("WFID", "WF001");
				insertWFInstData.put("Creator", commandMap.get("sessionUserId"));
				insertWFInstData.put("LastUser", commandMap.get("sessionUserId"));
				insertWFInstData.put("Status", "-1"); // �긽�떊
				insertWFInstData.put("aprvOption", "PRE");
				insertWFInstData.put("curSeq", "1");
				insertWFInstData.put("LastSigner", commandMap.get("sessionUserId"));
				
				commonService.insert("wf_SQL.insertToWfInst", insertWFInstData);
				
				String maxId = "";

				int lastSeq = 1;
					
				insertWFStepData.put("Seq", "0");
				String status = null;
				maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);	
				insertWFStepData.put("StepInstID", Integer.parseInt(maxId) + 1);
				insertWFStepData.put("ProjectID", projectID);
				
				status = "0"; 		
				insertWFStepData.put("Status", status);
				insertWFStepData.put("ActorID", commandMap.get("sessionUserId"));
				insertWFStepData.put("WFID", "WF001");
				insertWFStepData.put("WFStepID", "AREQ");				
				
				if(wfInstanceID.isEmpty()){ insertWFStepData.put("WFInstanceID", newWFInstanceID); }
				commonService.insert("wf_SQL.insertWfStepInst", insertWFStepData);
								
				inserWFInstTxtData.put("WFInstanceID",newWFInstanceID);
				inserWFInstTxtData.put("subject",getPJTMap.get("ItemName"));
				inserWFInstTxtData.put("subjectEN","");
				inserWFInstTxtData.put("description",getPJTMap.get("ItemName"));
				inserWFInstTxtData.put("descriptionEN","");
				inserWFInstTxtData.put("comment","");
				inserWFInstTxtData.put("actorID",commandMap.get("sessionUserId"));
				commonService.insert("wf_SQL.insertWfInstTxt", inserWFInstTxtData);	
				
			    updateCRData = new HashMap();	
				HashMap updateSR = new HashMap(); 

				updateCRData.put("Status", "APRV");
				updateCRData.put("lastUser", commandMap.get("sessionUserId"));
				updateCRData.put("userID", commandMap.get("sessionUserId"));

				if(wfDocType.equals("CS")) {
					
					if(isMulti.equals("Y")) {
						String ids[] = wfDocumentIDs.split(",");
						for(int i=0; i<ids.length; i++) {
							updateCRData.put("s_itemID", ids[i]);
							updateCRData.put("wfInstanceID",newWFInstanceID);
							commonService.update("cs_SQL.updateChangeSetForComDT", updateCRData);
						}
					}
					else {
						updateCRData.put("s_itemID", changeSetID);
						updateCRData.put("wfInstanceID",newWFInstanceID);
						commonService.update("cs_SQL.updateChangeSetForComDT", updateCRData);
					}
					
				}
				
	            //   URL 설정하고 접속하기 
				
				setMap.put("languageID", commandMap.get("languageID"));
				setMap.put("wfInstanceID", newWFInstanceID);
				Map menu = getLabel(request, commonService);
				
				Calendar calendar = Calendar.getInstance();
				Date date = calendar.getTime();
						    	
		    	String myResult = "";

				setMap.remove("s_itemID");
				setMap.remove("projectID");
				setMap.remove("ChangeSetID");
				
				List csInstList = commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);	
				String startHTML = "<![CDATA[<!doctype html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html><body>";
						
				setMap.put("assigned","1");
				setMap.put("itemID", itemID);
				List roleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);

								
				setMap.put("emailCode", emailType );
				setMap.put("languageID", commandMap.get("sessionCurrLangType") );
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
				
				String rolePath = "";
				if(roleList != null && !roleList.isEmpty()) {
					for(int i=0; i< roleList.size(); i++) {
						Map temp = (Map)roleList.get(i);
						
						if(i ==0) {
							rolePath = StringUtil.checkNull(temp.get("TeamNM"));
						}
						else {
							rolePath = rolePath + " / " + StringUtil.checkNull(temp.get("TeamNM"));
							
						}
					}
				}
								
				setMap.put("s_itemID", itemID);
				String itemStatus = StringUtil.checkNull(commonService.selectString("project_SQL.getItemStatus", setMap));
				
				setMap.put("ItemID", itemID);
				setMap.put("attrTypeCode", "AT00501");
				Map mainTextMap = commonService.select("attr_SQL.getItemAttrText", setMap);

				List itemPath = new ArrayList();
				
				itemPath = getRootItemPath(itemID,StringUtil.checkNull(commandMap.get("languageID")),itemPath);
				Collections.reverse(itemPath);		
				
				String itemPathName = "";
				if(itemPath != null && !itemPath.isEmpty()) {
					for(int i=0; i< itemPath.size(); i++) {
						Map temp = (Map)itemPath.get(i);
						
						if(i ==0) {
							itemPathName = StringUtil.checkNull(temp.get("PlainText"));
						}
						else {
							itemPathName = itemPathName + " > " + StringUtil.checkNull(temp.get("PlainText"));
							
						}
					}
				}
				getPJTMap.put("itemPathName",itemPathName);
				getPJTMap.put("rolePath",rolePath);
				getPJTMap.put("emailHTMLForm",emailHTMLForm);
				getPJTMap.put("mainText",StringUtil.checkNull(mainTextMap.get("PlainText")).replace("src=\"/upload", "src=\""+GlobalVal.OLM_SERVER_URL+"/upload").replace("&", "&amp;"));
				getPJTMap.put("mainText",StringUtil.checkNull(mainTextMap.get("PlainText")).replace("src=\"upload", "src=\""+GlobalVal.OLM_SERVER_URL+"/upload").replace("&", "&amp;"));
				String mainText2 = GlobalVal.OLM_SERVER_URL+"olmLink.do.do?arCode=AT00004A&olmLoginid=guest&object=itm&linkType=id&keyID="+StringUtil.checkNull(getPJTMap.get("ItemID"))+"&linkID="+StringUtil.checkNull(getPJTMap.get("ChangeSetID"))+"&languageID="+StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				getPJTMap.put("mainText2",mainText2);
				
				String returnHTML = replaceHTMLForm(getPJTMap,languageID,menu,comType);
				
				Map wfTempMap = new HashMap();
				wfTempMap.put("itemTypeCode",getPJTMap.get("itemTypeCode"));
				wfTempMap.put("empCode",commandMap.get("sessionLoginId"));
				wfTempMap.put("itemID",getPJTMap.get("itemID"));
				wfTempMap.put("languageID",languageID);
				
				String wfPath = getWfPathInfo(wfTempMap,roleList, comType);
		    	
		    	autoWayMap.put("sendDate" ,new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
		    	autoWayMap.put("apprPhase" ,"1");
		    	autoWayMap.put("dftCompId" ,HMGGlobalVal.dftCompId);
		    	autoWayMap.put("lgyDocId" ,newWFInstanceID);
		    	autoWayMap.put("htmlType" ,"1");
		    	autoWayMap.put("LangType" ,"ko-KR");
		    	
		    	String docTitle = getWfDocTitle(getPJTMap,comType);
		    	

		    	autoWayMap.put("docTitle" , docTitle);
		    	autoWayMap.put("lgySystemId" ,HMGGlobalVal.lgySystemId); // "H-WAY"
		    	autoWayMap.put("oldPID" ,"");
		    	autoWayMap.put("checklistVisible" ,"");
		    	autoWayMap.put("dftUserId" , commandMap.get("sessionLoginId"));
		    	autoWayMap.put("dftDeptCode" ,"");
		    	autoWayMap.put("samplePath" ,wfPath);
		    	
		    	Map formId = getWfDocformId(itemTypeCode,comType);
		    	
		    	autoWayMap.put("lgyFormId" ,StringUtil.checkNull(formId.get("lgyFormId")));
		    	autoWayMap.put("atyFormId" ,StringUtil.checkNull(formId.get("atyFormId")));
		    	
		    	autoWayMap.put("approvalPathLine" ,"");
		    	autoWayMap.put("mainContpdf" ,"");
		    	autoWayMap.put("lgyRefDocId" ,"");
		    	autoWayMap.put("minSerialCnt" ,"");
				autoWayMap.put("mainContHtml", returnHTML);

		    	wfUrl = GlobalVal.APPROVAL_SYS_URL;
		    	Map fileMap = new HashMap();
		    	fileMap.put("changeSetID", changeSetID);
		    	fileMap.put("DocumentID", itemID);
		    	fileMap.put("languageID",languageID);
		    	fileMap.put("fileListYN","Y");
		    	List fileList = commonService.selectList("fileMgt_SQL.getFile_gridList", fileMap);	
		    	String sendFileList = "";
		    	if(fileList != null && !fileList.isEmpty()) {
		    		for(int i=0; i<fileList.size(); i++) {
		    			Map temp = (Map)fileList.get(i);
		    			temp.put("comType", comType);
				    	String isFlag = zhdc_sendFile(temp,newWFInstanceID);
			            System.out.println(isFlag);
			            
			            if(i == 0) {
			            	sendFileList = StringUtil.checkNull(temp.get("FileRealName")).replace("&", "&amp;");
			            }
			            else {
			            	sendFileList += "|" + StringUtil.checkNull(temp.get("FileRealName")).replace("&", "&amp;");
			            }
		    		}
		    	}
		    	
		    	if(!"".equals(sendFileList)) {
		    		autoWayMap.put("fileList", "/"+comType+"/attach/" + newWFInstanceID + "/" + sendFileList);
		    	}

	            String wfData = createWfXML(wfUrl,autoWayMap);
	            System.out.println(wfData);
	            
		        if(!"".equals(wfData)) {
		            JSONObject jo1 = new JSONObject(wfData);
		            
		            String returnUrl = StringUtil.checkNull(jo1.get("returnUrl"));
		            String resultCode = StringUtil.checkNull(jo1.get("resultCode"));
		            String errMsg = StringUtil.checkNull(jo1.get("errMsg"));
		            
					model.put("returnUrl", returnUrl);
					model.put("resultCode", resultCode);
					model.put("errMsg", errMsg);
	            }
	            else {

					model.put("returnUrl", "");
					model.put("resultCode", "E");
					model.put("errMsg", "Error");
	            }
			}
			
			
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	 public String createWfXML(String url, HashMap autoWayMap) throws Exception {
		 String returnData = "";
		 try {
		        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();        
		        factory.setNamespaceAware(true);             
		        DocumentBuilder parser = factory.newDocumentBuilder();
		 
		        //request SOAP message DOMSource create
		        String sendMessage = 
		        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" 
               +"	<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
               +"     <soap:Body>"
			   +"        <OpenApprovalDraftWindow xmlns=\"http://tempuri.org/\">"			   
			   +"         <dftCompId>"+autoWayMap.get("dftCompId")+"</dftCompId>"
			   +"         <dftUserId>"+autoWayMap.get("dftUserId")+"</dftUserId>"
			   +"         <dftDeptCode></dftDeptCode>"
			   +"         <sendDate>"+autoWayMap.get("sendDate")+"</sendDate>"
			   +"         <docTitle>"+autoWayMap.get("docTitle")+"</docTitle>"
			   +"         <lgySystemId>"+autoWayMap.get("lgySystemId")+"</lgySystemId>" //H-WAY
			   +"         <lgyDocId>"+autoWayMap.get("lgyDocId")+"</lgyDocId>"
			   +"         <lgyRefDocId></lgyRefDocId>"
			   +"         <htmlType>1</htmlType>"
			   +"         <mainContpdf></mainContpdf>"
			   +"         <mainContHtml>"+autoWayMap.get("mainContHtml")+"</mainContHtml>"
			   +"         <approvalPathLine>"+autoWayMap.get("samplePath")+"</approvalPathLine>"
			   +"         <atyFormId>"+autoWayMap.get("atyFormId")+"</atyFormId>"
			   +"         <lgyFormId>"+autoWayMap.get("lgyFormId")+"</lgyFormId>"
			   +"         <fileList>"+autoWayMap.get("fileList")+"</fileList>"
			   +"         <apprPhase>1</apprPhase>"
			   +"         <minSerialCnt></minSerialCnt>"
			   +"         <checklistVisible></checklistVisible>"
			   +"         <oldPID></oldPID>"
			   +"         <LangType>ko-KR</LangType>"
			   +"      </OpenApprovalDraftWindow>"
			   +"   </soap:Body>"		             
			   +"</soap:Envelope>";
			   System.out.println(sendMessage);
		       StringReader reader = new StringReader(sendMessage);
		       InputSource is = new InputSource(reader);
		       Document document = parser.parse(is);
		       DOMSource requestSource = new DOMSource(document);

		       //SOAPMessage create
		       MessageFactory messageFactory = MessageFactory.newInstance();
		       SOAPMessage requestSoapMessage = messageFactory.createMessage(); 
		       SOAPPart requestSoapPart = requestSoapMessage.getSOAPPart(); 
		       requestSoapPart.setContent(requestSource);
		        //SOAPConnection create instance
		       SOAPConnectionFactory scf = SOAPConnectionFactory.newInstance();
		       SOAPConnection connection = scf.createConnection();
	        
		       //SOAP SEND MESSAGE
		       SOAPMessage responseSoapMessage = connection.call(requestSoapMessage, url);
		       ByteArrayOutputStream out = new ByteArrayOutputStream();
		       responseSoapMessage.writeTo(out);
		       String soapResult = new String(out.toByteArray(), "UTF-8");
		       System.out.println(soapResult);
		       SOAPBody soapBody = responseSoapMessage.getSOAPBody();  
		       returnData = soapBody.getTextContent();
		        
			} catch (Exception e) {
			    e.printStackTrace();
			}    
		 return returnData;
	 } 
	 public String viewWfCreateXML(String url, HashMap autoWayMap) throws Exception {
		 String returnData = "";
		 try {
		        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();        
		        factory.setNamespaceAware(true);             
		        DocumentBuilder parser = factory.newDocumentBuilder();

		        //request SOAP message DOMSource create
		        String sendMessage = 
		        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" 
               +"	<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
               +"     <soap:Body>"
			   +"        <CallDoc xmlns=\"http://tempuri.org/\">"			   
			   +"         <dftCompId>"+autoWayMap.get("dftCompId")+"</dftCompId>"
			   +"         <dftUserId>"+autoWayMap.get("dftUserId")+"</dftUserId>"
			   +"         <dftDeptCode></dftDeptCode>"
			   +"         <lgySystemId>"+autoWayMap.get("lgySystemId")+"</lgySystemId>" //H-WAY
			   +"         <lgyDocId>"+autoWayMap.get("lgyDocId")+"</lgyDocId>"
			   +"         <PID>"+autoWayMap.get("PID")+"</PID>"
			   +"         <LangType>ko-KR</LangType>"
			   +"      </CallDoc>"
			   +"   </soap:Body>"		             
			   +"</soap:Envelope>";
			   System.out.println(sendMessage);
		       StringReader reader = new StringReader(sendMessage);
		       InputSource is = new InputSource(reader);
		       Document document = parser.parse(is);
		       DOMSource requestSource = new DOMSource(document);

		       //SOAPMessage create
		       MessageFactory messageFactory = MessageFactory.newInstance();
		       SOAPMessage requestSoapMessage = messageFactory.createMessage(); 
		       SOAPPart requestSoapPart = requestSoapMessage.getSOAPPart(); 
		       requestSoapPart.setContent(requestSource);
		        //SOAPConnection create instance
		       SOAPConnectionFactory scf = SOAPConnectionFactory.newInstance();
		       SOAPConnection connection = scf.createConnection();
	        
		       //SOAP SEND MESSAGE
		       SOAPMessage responseSoapMessage = connection.call(requestSoapMessage, url);
		       ByteArrayOutputStream out = new ByteArrayOutputStream();
		       responseSoapMessage.writeTo(out);
		       String soapResult = new String(out.toByteArray(), "UTF-8");
		       System.out.println(soapResult);
		       SOAPBody soapBody = responseSoapMessage.getSOAPBody();  
		       returnData = soapBody.getTextContent();
		        
			} catch (Exception e) {
			    e.printStackTrace();
			}    
		 return returnData;
	 } 
		
		

	@RequestMapping(value="/custom/hyundai/indexHDC.do")
	public String indexHDC(Map cmmMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try{				
			Map setData = new HashMap();
		    String logonId = "";          // 로그온 된 사용자 아이디
		    Map userInfo = new HashMap();         // 로그온 된 사용자 추가정보
		    Map ssoInfo = new HashMap();         // 로그온 된 사용자 추가정보
		    String scriptMsg = "";        // 에러 메시지
		    String returnUrlTagName = ""; // 리턴 URL 태그 이름
		    String siteTagName = "";      // 사이트 응용프로그램 태그 이름
/*
        	System.out.println("SSO Start");
		    AuthCheck auth = new AuthCheck(request, response);
	        //인증확인
	        AuthStatus status = auth.checkLogon();

        	System.out.println("SSO Start");
	        //일반 설정값들
	        returnUrlTagName = auth.getSsoProvider().getParamName(AuthUtil.ParamInfo.RETURN_URL);
	        siteTagName = auth.getSsoProvider().getParamName(AuthUtil.ParamInfo.SITE_ID);

        	System.out.println("SSO Start");
	        //인증상태별 처리
	        if (status == AuthStatus.SSOFirstAccess) {
	            //최초 접속
	            auth.trySSO();
            	System.out.println("SSO Start 1");
	        } else if (status == AuthStatus.SSOSuccess) {
	            //인증성공
	            //로그인 아이디
	            logonId = auth.getUserID();
	            //인증정보 모두 보기(화면에서 보고 싶을 때 주석을 제거 하세요)
	            if (auth.getUserInfoCollection() != null && auth.getUserInfoCollection().size() > 0) {
	               
	                for (Enumeration<String> e = auth.getUserInfoCollection().keys(); e.hasMoreElements(); ) {
	                	String key = e.nextElement();
	                	ssoInfo.put(key,auth.getUserInfoCollection().get(key));
	                	System.out.println(key);
	                }
	            }


				setData.put("employeeNum", ssoInfo.get("empNO"));
				
				userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);
			
				if(userInfo != null && !userInfo.isEmpty()) {	
					String activeYN = "N";
					HashMap setMap = new HashMap();
					
					setMap.put("LOGIN_ID", StringUtil.checkNull(userInfo.get("LoginId")));
					
					activeYN = commonService.selectString("login_SQL.login_active_select", setMap);
					if(!"Y".equals(activeYN)) {
						return nextUrl("indexHEC");
					}
					
					model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
				}
				
				model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
				model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
				model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"),""));
				model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"),""));
				
	        } else if (status == AuthStatus.SSOFail) {
	            //인증실패
	            if (auth.getErrCode() != AgentExceptionCode.NoException.getValue()) {
	                model.put("errorCode","other");
	                model.put("errorMessage",auth.getErrCode());
                	System.out.println("SSO other");
	            }
	            if (auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue()) {
	                model.put("errorCode","overlap");
	                model.put("errorMessage","");
                	System.out.println("SSO overlap");
	            }
	            //로그오프를 해야하는 상황
	            if (auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue() ||
	                    auth.getErrCode() == AgentExceptionCode.TokenIdleTimeout.getValue() ||
	                    auth.getErrCode() == AgentExceptionCode.TokenExpired.getValue() ||
	                    auth.getErrCode() == AgentExceptionCode.NoExistUserIDSessionValue.getValue()) {
	                scriptMsg += "OnLogoff();";
                	System.out.println("SSO lgoff");
	            } else {
	                scriptMsg += "goLogonPage();";
	            }
	            
	        } else if (status == AuthStatus.SSOUnAvailable) {
	            //SSO장애
	            scriptMsg = "alertError('현재 통합인증 서비스가 불가합니다.', '');";
            	System.out.println("SSO error");
	        } else if (status == AuthStatus.SSOAccessDenied) {
	            //접근거부
	            response.sendRedirect("denied.jsp");
            	System.out.println("SSO no");
	        }*/
				
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HDCActionController::HDC Login ::Error::"+e);}

     	System.out.println(e.getMessage());
			return nextUrl("indexHDC");	
		}		
		
		return nextUrl("indexHDC");
	}
		
		@RequestMapping(value="/hyundai/loginHDCForm.do")
		public String loginHecForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		  HttpSession session = request.getSession(true);
		  
		  Map loginInfo = (Map)session.getAttribute("loginInfo");

		  if(loginInfo != null && !loginInfo.isEmpty()) {
			  	if("guest".equals(loginInfo.get("sessionLoginId"))) {
			  		session.invalidate();
					model.put("ssoYN", "N");
			  	}
			  	else {
					model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 援щ텇
					model.put("ssoYN", "Y");
			  	}
		  }
		  else {
				model.put("ssoYN", "N");
		  }

		  model=setLoginScrnInfo(model,cmmMap);
		  
		  model.put("screenType", cmmMap.get("screenType"));
		  model.put("mainType", cmmMap.get("mainType"));
		  model.put("srID", cmmMap.get("srID"));
		  model.put("sysCode", cmmMap.get("sysCode"));
		  model.put("proposal", cmmMap.get("proposal"));
		  model.put("status", cmmMap.get("status"));
		  return nextUrl("/custom/hyundai/login");
		}
		

		private ModelMap setLoginScrnInfo(ModelMap model,HashMap cmmMap) throws ExceptionUtil {
			  
		  String pass = StringUtil.checkNull(cmmMap.get("pwd"));
		  model.addAttribute("loginid",StringUtil.checkNull(cmmMap.get("loginid"), ""));
		  model.addAttribute("pwd",pass);
		  model.addAttribute("lng",StringUtil.checkNull(cmmMap.get("lng"), ""));
		  try {
			  List langList = commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
			  if( langList!=null &&langList.size() > 0){
				  for(int i=0; i<langList.size();i++){
					  Map langInfo = (HashMap) langList.get(i);
					  if(langInfo.get("IsDefault").equals("1")){
						  model.put("langType", StringUtil.checkNull(langInfo.get("CODE"),""));
						  model.put("langName", StringUtil.checkNull(langInfo.get("NAME"),""));
					  }
				  }
			  }else{model.put("langType", "");model.put("langName", "");}
			  model.put("langList", langList);
			  model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 援щ텇
		  } catch(Exception e) {
			  throw new ExceptionUtil(e.toString());
		  }
		  return model;
	 	}
		

		@RequestMapping(value="/hyundai/loginHDC.do")
		public String loginHDC(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
			try {
					HttpSession session = request.getSession(true);
					Map resultMap = new HashMap();
					String langCode = GlobalVal.DEFAULT_LANG_CODE;	
					String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),StringUtil.checkNull(cmmMap.get("LANGUAGEID")) );
					if("".equals(languageID)){
						languageID = GlobalVal.DEFAULT_LANGUAGE;
					}
					
					cmmMap.put("LANGUAGE", languageID);
					
					String ref = request.getHeader("referer");
					String protocol = request.isSecure() ? "https://" : "http://";
					
					String IS_CHECK = GlobalVal.PWD_CHECK;
					String url_CHECK = "Y";//StringUtil.chkURL(ref, protocol);

					if("".equals(IS_CHECK))
						IS_CHECK = "Y";
					
					
					if("".equals(url_CHECK)) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));	
					}
					else {
						Map idInfo = new HashMap();
						idInfo = commonService.select("login_SQL.login_id_select", cmmMap);
					
						if(idInfo == null || idInfo.size() == 0) {
							resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
							resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));				
						}
						else {				
							Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
							if(loginInfo == null || loginInfo.size() == 0) {
								resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
								//resultMap.put(AJAX_ALERT, "System�뿉 �빐�떦 �궗�슜�옄 �젙蹂닿� �뾾�뒿�땲�떎.�벑濡� �슂泥�諛붾엻�땲�떎.");
								resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00102"));					
							}
							else {
								// [Authority] < 4 �씤 寃쎌슦, �닔�젙媛��뒫�븯寃� 蹂�寃�
								if(loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)	loginInfo.put("loginType", "editor");
								else	loginInfo.put("loginType", "viewer");	
								resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
								//resultMap.put(AJAX_MESSAGE, "Login�꽦怨�");					
								session.setAttribute("loginInfo", loginInfo);
							}
						}
					}
					model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 援щ텇
					model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
				    model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
				    model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
				    model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));

					model.addAttribute(AJAX_RESULTMAP,resultMap);
			}
			catch (Exception e) {
				System.out.println(e.toString());
				if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl(AJAXPAGE);
		}
		
		public String zhdc_sendFile(Map fileMap, String wfInstanceID) throws Exception {
			HashMap target = new HashMap();		
			try{
				/*	String id = StringUtil.checkNull(fileMap.get("id"));//"SFTPHEC@grhq.hmgc.net";
					String pwd = StringUtil.checkNull(fileMap.get("pwd"));//"SftpHec!23";
					String url = StringUtil.checkNull(fileMap.get("url"));//"10.6.180.135";
					Session session = null;
					Channel channel = null;
					ChannelSftp channelSftp = null;

					JSch jsch = new JSch();
				    session = jsch.getSession(id,url,8988);
		            
		            //password 설정
		            session.setPassword(pwd);
		            
		            //세션관련 설정정보 설정
		            java.util.Properties config = new java.util.Properties();
		            
		            //호스트 정보 검사하지 않는다.
		            config.put("StrictHostKeyChecking", "no");
		            session.setConfig(config);
		            
		            //접속
		            session.connect();

		            //sftp 채널 접속
		            channel = session.openChannel("sftp");
		            channel.connect();
		            channelSftp = (ChannelSftp) channel;
		            File file = new File(StringUtil.checkNull(fileMap.get("filePath")) + StringUtil.checkNull(fileMap.get("fileName")));
		            FileInputStream in = null;
		            
		            in = new FileInputStream(file);
		            String ftpPath = "/" + StringUtil.checkNull(fileMap.get("companyPath")) + "/attach/"+wfInstanceID;
		            
		            try {
		            	channelSftp.mkdir(ftpPath);
		            	channelSftp.cd(ftpPath);
		            	
		            }
		            catch(Exception e) {
		            	channelSftp.cd(ftpPath);	            	
		            }
		                 

					channelSftp.put(in,file.getName());
					channelSftp.rename(file.getName(), StringUtil.checkNull(fileMap.get("fileRealName")));
					in.close();				
					channelSftp.quit();
					session.disconnect();*/
			}catch(Exception e){
				return "false";
			}
			return "success";
		}

		@RequestMapping("/custom/hyundai/zhdc_inboundLink.do")
		public String zhdc_inboundLink(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception {
			String url = "/template/olmLinkPopup";
			try {
				String logonId = "";          // 로그온 된 사용자 아이디
			    Map userInfo = new HashMap();         // 로그온 된 사용자 추가정보
			    Map ssoInfo = new HashMap();         // 로그온 된 사용자 추가정보
			    Map setMap = new HashMap();         // 로그온 된 사용자 추가정보
			    String scriptMsg = "";        // 에러 메시지
			    String returnUrlTagName = ""; // 리턴 URL 태그 이름
			    String siteTagName = "";      // 사이트 응용프로그램 태그 이름
			    	/*		
			    AuthCheck auth = new AuthCheck(request, response);
		        //인증확인
		        AuthStatus status = auth.checkLogon();

		        //일반 설정값들
		        returnUrlTagName = auth.getSsoProvider().getParamName(AuthUtil.ParamInfo.RETURN_URL);
		        siteTagName = auth.getSsoProvider().getParamName(AuthUtil.ParamInfo.SITE_ID);
		        
		        //인증상태별 처리
		        if (status == AuthStatus.SSOFirstAccess) {
		            //최초 접속
		            auth.trySSO();
		        } else if (status == AuthStatus.SSOSuccess) {
		            //인증성공
		            //로그인 아이디
		            logonId = auth.getUserID();
		            //인증정보 모두 보기(화면에서 보고 싶을 때 주석을 제거 하세요)
		            if (auth.getUserInfoCollection() != null && auth.getUserInfoCollection().size() > 0) {
		               
		                for (Enumeration<String> e = auth.getUserInfoCollection().keys(); e.hasMoreElements(); ) {
		                	String key = e.nextElement();
		                	ssoInfo.put(key,auth.getUserInfoCollection().get(key));
		                }
		            }


		            setMap.put("employeeNum", ssoInfo.get("empNO"));
					
					userInfo = commonService.select("common_SQL.getLoginIDFromMember", setMap);
				
					if(userInfo != null && !userInfo.isEmpty()) {	
						String activeYN = "N";
						HashMap setInfo = new HashMap();
						
						setInfo.put("LOGIN_ID", StringUtil.checkNull(userInfo.get("LoginId")));
						
						activeYN = commonService.selectString("login_SQL.login_active_select", setInfo);
						if(!"Y".equals(activeYN)) {
							return nextUrl("indexHDC");
						}
						
						model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
						model.put("loginid", StringUtil.checkNull(userInfo.get("LoginId")));
					}
					
					String itemID = StringUtil.checkNull(commandMap.get("keyID"));
					String changeSetID = StringUtil.checkNull(commandMap.get("linkID"));
					String option = StringUtil.checkNull(commandMap.get("option"));
					String languageID = StringUtil.checkNull(commandMap.get("languageID"));
					String arCode = "";
					setMap = new HashMap();
					setMap.put("ChangeSetID", changeSetID);
					Map csMap = commonService.select("cs_SQL.getRootCngtInfo", setMap);
					
					setMap.put("itemID", itemID);
					String maxVersion = commonService.selectString("cs_SQL.getItemReleaseVersion", setMap);
					

					model.put("itemID", itemID);
					model.put("changeSetID", changeSetID);
					model.put("arCode", arCode);
					model.put("option",option);
					model.put("languageID", languageID);
					
					model.put("olmLng", StringUtil.checkNull(commandMap.get("olmLng"),""));
					model.put("screenType", StringUtil.checkNull(commandMap.get("screenType"),""));
					model.put("mainType", StringUtil.checkNull(commandMap.get("mainType"),""));
					model.put("srID", StringUtil.checkNull(commandMap.get("srID"),""));
					model.put("sysCode", StringUtil.checkNull(commandMap.get("sysCode"),""));
					model.put("proposal", StringUtil.checkNull(commandMap.get("proposal"),""));
					
		        } else if (status == AuthStatus.SSOFail) {
		            //인증실패
		            if (auth.getErrCode() != AgentExceptionCode.NoException.getValue()) {
		                model.put("errorCode","other");
		                model.put("errorMessage",auth.getErrCode());
		            }
		            if (auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue()) {
		                model.put("errorCode","overlap");
		                model.put("errorMessage","");
		            }
		            //로그오프를 해야하는 상황
		            if (auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue() ||
		                    auth.getErrCode() == AgentExceptionCode.TokenIdleTimeout.getValue() ||
		                    auth.getErrCode() == AgentExceptionCode.TokenExpired.getValue() ||
		                    auth.getErrCode() == AgentExceptionCode.NoExistUserIDSessionValue.getValue()) {
		                scriptMsg += "OnLogoff();";
		            } else {
		                scriptMsg += "goLogonPage();";
		            }
		            
		        } else if (status == AuthStatus.SSOUnAvailable) {
		            //SSO장애
		            scriptMsg = "alertError('현재 통합인증 서비스가 불가합니다.', '');";
		        } else if (status == AuthStatus.SSOAccessDenied) {
		            //접근거부
		            response.sendRedirect("denied.jsp");
		        }
		        */
				//String olmLoginid = StringUtil.checkNull(commandMap.get("olmLoginid"));
				//String itemID = StringUtil.checkNull(commandMap.get("keyID"));
				//String changeSetID = StringUtil.checkNull(commandMap.get("linkID"));
				//String option = StringUtil.checkNull(commandMap.get("option"));
				//String languageID = StringUtil.checkNull(commandMap.get("languageID"));
				//String arCode = "";
				//setMap = new HashMap();
				//setMap.put("ChangeSetID", changeSetID);
				//Map csMap = commonService.select("cs_SQL.getRootCngtInfo", setMap);
				
				//setMap.put("itemID", itemID);
				//String maxVersion = commonService.selectString("cs_SQL.getItemReleaseVersion", setMap);
				

				//model.put("loginid", olmLoginid);
				//model.put("itemID", itemID);
				//model.put("changeSetID", changeSetID);
				//model.put("arCode", arCode);
				//model.put("option",option);
				//model.put("languageID", languageID);
				
				//model.put("olmLng", StringUtil.checkNull(commandMap.get("olmLng"),""));
				//model.put("screenType", StringUtil.checkNull(commandMap.get("screenType"),""));
				//model.put("mainType", StringUtil.checkNull(commandMap.get("mainType"),""));
				//model.put("srID", StringUtil.checkNull(commandMap.get("srID"),""));
				//model.put("sysCode", StringUtil.checkNull(commandMap.get("sysCode"),""));
				//model.put("proposal", StringUtil.checkNull(commandMap.get("proposal"),""));
				
			}  catch(Exception e) {
				System.out.println(e.toString());
			}		
			
			return nextUrl(url);
		}
		
		public String replaceHTMLForm(Map cmmCnts,String languageID, Map menu, String comType){
			String returnHTML = "";
			if("H-WAY".equals(comType)) {
				returnHTML = returnHTMLForHway(cmmCnts, languageID, menu);
			}
			
			return returnHTML;
		}	
		
		public String returnHTMLForHway(Map cmmCnts,String languageID, Map menu) {
			String itemTypeCode = StringUtil.checkNull(cmmCnts.get("itemTypeCode"));
			String Identifier = StringUtil.checkNull(cmmCnts.get("Identifier"));
			String itemPath = StringUtil.checkNull(cmmCnts.get("itemPath"));
			String ItemName = StringUtil.checkNull(cmmCnts.get("ItemName"));
			String TeamName = StringUtil.checkNull(cmmCnts.get("TeamName"));
			String rolePath = StringUtil.checkNull(cmmCnts.get("rolePath"));
			String Description = StringUtil.checkNull(cmmCnts.get("Description"));
			String Reason = StringUtil.checkNull(cmmCnts.get("Reason"));
			String mainText = StringUtil.checkNull(cmmCnts.get("mainText"));
			String mainText2 = StringUtil.checkNull(cmmCnts.get("mainText2"));

			
			String emailHTMLForm = StringUtil.checkNull(cmmCnts.get("emailHTMLForm"));
			String LN00091 = StringUtil.checkNull(menu.get("LN00091"));
			String LN00026 = StringUtil.checkNull(menu.get("LN00026"));
			String ZLN019 = StringUtil.checkNull(menu.get("ZLN019"));
			String LN00101 = StringUtil.checkNull(menu.get("LN00101"));
			String LN00134 = StringUtil.checkNull(menu.get("LN00134"));
			String LN00358 = StringUtil.checkNull(menu.get("LN00358"));
			String LN00005 = StringUtil.checkNull(menu.get("LN00005"));
			String LN00360 = StringUtil.checkNull(menu.get("LN00360"));
			String LN00359 = StringUtil.checkNull(menu.get("LN00359"));
			String LN00145 = StringUtil.checkNull(menu.get("LN00145"));
			String ZLN021 = StringUtil.checkNull(menu.get("ZLN021"));
			String ZLN018 = StringUtil.checkNull(menu.get("ZLN018"));
			String ZLN014 = StringUtil.checkNull(menu.get("ZLN014"));
			String LN00313 = StringUtil.checkNull(menu.get("LN00313"));
			
			String returnHTML = emailHTMLForm;
			
			returnHTML = returnHTML.replaceAll("#ZLN019#", ZLN019);
			returnHTML = returnHTML.replaceAll("#LN00026#", LN00026);
			returnHTML = returnHTML.replaceAll("#LN00091#", LN00091);
			returnHTML = returnHTML.replaceAll("#LN00101#", LN00101);
			returnHTML = returnHTML.replaceAll("#LN00134#", LN00134);
			returnHTML = returnHTML.replaceAll("#LN00005#", LN00005);
			returnHTML = returnHTML.replaceAll("#LN00358#", LN00358);
			returnHTML = returnHTML.replaceAll("#LN00359#", LN00359);
			returnHTML = returnHTML.replaceAll("#LN00360#", LN00360);
			returnHTML = returnHTML.replaceAll("#LN00145#", LN00145);
			returnHTML = returnHTML.replaceAll("#LN00313#", LN00313);
			returnHTML = returnHTML.replaceAll("#ZLN021#", ZLN021);
			returnHTML = returnHTML.replaceAll("#ZLN018#", ZLN018);
			returnHTML = returnHTML.replaceAll("#ZLN014#", ZLN014);
			
			returnHTML = returnHTML.replaceAll("#itemTypeCode#", itemTypeCode);
			returnHTML = returnHTML.replaceAll("#itemPath#", itemPath);
			returnHTML = returnHTML.replaceAll("#Identifier#", Identifier);
			returnHTML = returnHTML.replaceAll("#ItemName#", ItemName);
			returnHTML = returnHTML.replaceAll("#TeamName#", TeamName);
			returnHTML = returnHTML.replaceAll("#rolePath#", rolePath);
			
			returnHTML = returnHTML.replaceAll("#Description#", Description);
			returnHTML = returnHTML.replaceAll("#Reason#", Reason);
			returnHTML = returnHTML.replaceAll("#mainText#", mainText);
			returnHTML = returnHTML.replaceAll("#mainText2#", mainText2);
			
				
			System.out.println(returnHTML);
			return returnHTML;
		}
		

		public String getWfPathInfo(Map wfMap,List roleList, String comType) throws Exception{
			String wfPath = "";
			if("H-WAY".equals(comType)) {
				wfPath = getWfPathInfoForHway(wfMap, roleList);
			}
			
			return wfPath;
		}	
		

		public String getWfDocTitle(Map cmmMap,String comType){
			String docTitle = "";
			String itemStatus = StringUtil.checkNull(cmmMap.get("itemStatus"));
			if("H-WAY".equals(comType)) {
				if("DEL1".equals(itemStatus)) {
					docTitle = "[폐기검토요청] " + StringUtil.checkNull(cmmMap.get("ItemName")).replace("&", "&amp;");
			    }
		    	else if("NEW1".equals(itemStatus)) {
		    		docTitle = "[제정검토요청] " + StringUtil.checkNull(cmmMap.get("ItemName")).replace("&", "&amp;");
			    }
		    	else if("MOD1".equals(itemStatus)) {
		    		docTitle = "[개정검토요청] " + StringUtil.checkNull(cmmMap.get("ItemName")).replace("&", "&amp;");
			    }
		    	else {
		    		docTitle = StringUtil.checkNull(cmmMap.get("ItemName")).replace("&", "&amp;");
			   }
			}
			
			return docTitle;
		}	
		
    	
		public String getWfPathInfoForHway(Map wfMap,List roleList) throws Exception {
			Map setMap = new HashMap();
			String itemTypeCode = StringUtil.checkNull(wfMap.get("itemTypeCode"));
			
			String samplePath = "<![CDATA[<root><depth approval_phase=\"1\">";
			
			setMap.put("empCode",wfMap.get("sessionLoginId"));
			Map wfPathInfo = commonService.select("custom_SQL.zhec_GetMemberWfPath", setMap);

			samplePath += "<step type=\"approve\">";
			samplePath += "<person dn_code=\"H139\"  dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\"1623923\" username=\"\" is_fixed=\"N\" is_hidden=\"Y\">";
			samplePath += "<status approved_date=\"\" status=\"inactive\" />";
			samplePath += "</person>";
			samplePath += "</step>";
			
			samplePath += "<step type=\"approve\">";
			samplePath += "<person dn_code=\"H139\"  dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\""+StringUtil.checkNull(wfPathInfo.get("PumCode"))+"\" username=\"\" is_fixed=\"N\" is_hidden=\"N\">";
			samplePath += "<status approved_date=\"\" status=\"inactive\" />";
			samplePath += "</person>";
			samplePath += "</step>";
			
			String TeamCode = StringUtil.checkNull(wfPathInfo.get("TeamCode"));
			if(!"".equals(TeamCode)) {
				samplePath += "<step type=\"approve\">";
				samplePath += "<person dn_code=\"H139\"  dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\""+TeamCode+"\" username=\"\" is_fixed=\"N\" is_hidden=\"N\">";
				samplePath += "<status approved_date=\"\" status=\"inactive\" />";
				samplePath += "</person>";
				samplePath += "</step>";
			}

			if(itemTypeCode.equals("OJ00001")) {
				List activityList = aprvByActivityRole(StringUtil.checkNull(wfMap.get("itemID")), "CNL0201A",StringUtil.checkNull(wfMap.get("languageID")));
				
				if(roleList != null && !roleList.isEmpty()) {
					for(int i=0; i< roleList.size(); i++) {
						Map temp = (Map)roleList.get(i);

						String RoleManagerID = StringUtil.checkNull(temp.get("curRoleManagerID"));
						setMap.put("userID",RoleManagerID);
						String loginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", setMap));

						samplePath += "<step type=\"approve\">";
						samplePath += "<person dn_code=\"H139\" dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\""+loginID+"\" username=\"\" is_fixed=\"N\" is_hidden=\"N\"><status approved_date=\"\" status=\"inactive\" /></person>";

						samplePath += "</step>";
					}
				}
				
			}
			else {
				if(roleList != null && !roleList.isEmpty()) {
					for(int i=0; i< roleList.size(); i++) {
						Map temp = (Map)roleList.get(i);

						String RoleManagerID = StringUtil.checkNull(temp.get("TeamManagerID"));
						setMap.put("userID",RoleManagerID);
						String loginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", setMap));

						samplePath += "<step type=\"approve\">";
						samplePath += "<person dn_code=\"H139\" dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\""+loginID+"\" username=\"\" is_fixed=\"N\" is_hidden=\"N\"><status approved_date=\"\" status=\"inactive\" /></person>";

						samplePath += "</step>";
					}
				}
			}
			String SilCode = StringUtil.checkNull(wfPathInfo.get("SilCode"));
			if(!"".equals(SilCode)) {
				samplePath += "<step type=\"approve\">";
				samplePath += "<person dn_code=\"H139\"  dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\""+SilCode+"\" username=\"\" is_fixed=\"N\" is_hidden=\"N\">";
				samplePath += "<status approved_date=\"\" status=\"inactive\" />";
				samplePath += "</person>";
				samplePath += "</step>";
			}

			String BonCode = StringUtil.checkNull(wfPathInfo.get("BonCode"));
			if(!"".equals(BonCode) && !"OJ00016".equals(itemTypeCode)) {
				samplePath += "<step type=\"approve\">";
				samplePath += "<person dn_code=\"H139\"  dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\""+BonCode+"\" username=\"\" is_fixed=\"N\" is_hidden=\"N\">";
				samplePath += "<status approved_date=\"\" status=\"inactive\" />";
				samplePath += "</person>";
				samplePath += "</step>";
			}
			
			samplePath += "</depth>";
			samplePath += "</root>]]>";	
			System.out.println(samplePath);
			return samplePath;
		}

		public List aprvByActivityRole(String itemID, String cxnCode, String languageID) throws Exception {
			HashMap target = new HashMap();
			List roleMangerList = new ArrayList();
			try {
					HashMap setMap = new HashMap();
					setMap.put("s_itemID", itemID);
					setMap.put("cxnCode", cxnCode);		
					setMap.put("languageID", languageID);		
					roleMangerList = commonService.selectList("role_SQL.getItemCxnRoleManagerList", setMap);
					
			} catch (Exception e) {
				System.out.println(e);
				return null;
			}
			return roleMangerList;
		}
		

		private List getRootItemPath(String itemID, String languageID, List itemPath) throws Exception {
			Map setMap = new HashMap();
			setMap.put("itemID", itemID);
			String ParentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setMap),"0");
					
			if(Integer.parseInt(ParentItemID) != 0 && Integer.parseInt(ParentItemID) > 100) {
				setMap.put("ItemID", ParentItemID);
				setMap.put("languageID", languageID);
				setMap.put("attrTypeCode", "AT00001");
				Map temp = commonService.select("attr_SQL.getItemAttrText",setMap);
				temp.put("itemID",ParentItemID);
				itemPath.add(temp);
				getRootItemPath(ParentItemID,languageID,itemPath);
			}
					 
			return itemPath;
		}
		

		public Map getWfDocformId(String itemTypeCode,String comType){
			String docTitle = "";
			Map tempMap = new HashMap();
			if("H-WAY".equals(comType)) {

		    	if("OJ00001".equals(itemTypeCode)) {
		    		tempMap.put("lgyFormId" ,"7017");
		    		tempMap.put("atyFormId" ,"555C2493-BFDB-4A7F-BEDC-2D31D48773CA");
		    	}
		    	else if("OJ00005".equals(itemTypeCode)) {
		    		tempMap.put("lgyFormId" ,"7018");
		    		tempMap.put("atyFormId" ,"7F721301-E949-4B6F-A6E3-C7F49ACE9A63");
		    	}
		    	else {
		    		tempMap.put("lgyFormId" ,"7019");
		    		tempMap.put("atyFormId" ,"5D040AA3-EAE5-45DA-B1CB-1C39AA3402C0");
		    	}
			}
			
			return tempMap;
		}
		
		

		public String createLoginXML(String encText) throws Exception {
			 String returnData = "";
			 try {
			        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();        
			        factory.setNamespaceAware(true);             
			        DocumentBuilder parser = factory.newDocumentBuilder();
			        String url = "https://autoway.hyundai.net/WebServices/Common/SitemapWSF/SitemapWS.asmx";
			        
			        String sendMessage = 
			        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" 
	              +"	<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
	              +"     <soap:Body>"
				   +"      <GetPlainText xmlns=\"http://tempuri.org/\">"			   
				   +"         <strEncID>KPAL</strEncID>"
				   +"         <strCompanyCode>H108</strCompanyCode>"
				   +"         <strEncText>"+encText+"</strEncText>"
				   +"      </GetPlainText>"
				   +"   </soap:Body>"		             
				   +"</soap:Envelope>";

				   returnData = connectSOAP(sendMessage,url,"GetPlainText");
				} catch (Exception e) {
				    //e.printStackTrace();
					return returnData;
				}    
			 return returnData;
		 } 
		
		

		public String checkSSOXML(String userID, String ip) throws Exception {
			String returnData = "";
			try {
			        String soapEndpointUrl = "https://xml.kefico.co.kr/SSO.XML/AUTHENTICATION/Login.asmx";
			        
			        String sendMessage = 
			        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" 
	               +"	<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
	               +"     <soap:Body>"
				   +"      <LoginProcess xmlns=\"http://kefico.co.kr/\">"			   
				   +"         <SystemID>KPAL</SystemID>"
				   +"         <UserID>"+userID+"</UserID>"
				   +"         <Password>$s0HighP@ss</Password>"
				   +"         <ClientIP>"+ip+"</ClientIP>"
				   +"      </LoginProcess>"
				   +"   </soap:Body>"		             
				   +"</soap:Envelope>";
			      
				   returnData = connectSOAP(sendMessage,soapEndpointUrl,"LoginProcessResult");
			 } catch (Exception e) {
				    e.printStackTrace();
			 }    
			 return returnData;
		}
		

		public String connectSOAP(String sendMessage, String soapEndpointUrl, String tagName) throws Exception {
			 String returnData = "";
			 try {
			        
			        String xml = sendMessage;
					OutputStreamWriter wr = null;
					BufferedReader in = null;
					
					URL url = new URL(soapEndpointUrl); 
					HttpURLConnection conn = (HttpURLConnection) url.openConnection();
						
					conn.setDoOutput(true);
					conn.setRequestMethod("POST");
					conn.addRequestProperty("Content-Type", "text/xml");
					wr = new OutputStreamWriter(conn.getOutputStream());
					wr.write(xml);
					wr.flush();
					int code = conn.getResponseCode();
			        
					String inputLine = null;
					StringBuffer buffer = new StringBuffer();
					in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
					while ((inputLine = in.readLine()) != null) {
						buffer.append(inputLine);
					}
					   
				   DocumentBuilderFactory factory  =  DocumentBuilderFactory.newInstance();
				   DocumentBuilder builder    =  factory.newDocumentBuilder();
				 
				   Document document     =  builder.parse(new InputSource(new StringReader(buffer.toString())));
				   
				   NodeList nodelist     =  document.getElementsByTagName(tagName);				
				   
				   Node node       =  nodelist.item(0);
				   
				   Node textNode      =  nodelist.item(0).getChildNodes().item(0);
				   
				   //element�쓽 text �뼸湲�
				   
				   if(textNode != null) {
				   
					   returnData = textNode.getNodeValue();
					   
				   }
				} catch (Exception e) {
				    e.printStackTrace();
				}    
			 return returnData;
		 } 
		

		public String updateWfInstCount(String userID, String subject, String wfCnt, HashMap wfInfoMap) throws Exception {
			String returnData = "";
			try {
			        String soapEndpointUrl = "http://appservice.kefico.co.kr/KIAC/KIACSvc.asmx";
			        String link = "";

			        String sendMessage = 
			        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" 
	               +"	<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
	               +"     <soap:Body>"
				   +"      <UpdateDocumentCount xmlns=\"http://Service.KASC.KEFICO.CO.KR/\">"			   
				   +"         <data>"	   
				   +"         	<CountInformation>"
				   +"         	<UserID>"+userID+"</UserID>"
				   +"         	<Count>"+wfCnt+"</Count>"
				   +"         	<Code>KEFICO0015</Code>"
				   +"         	<Title>"+subject+"</Title>"
				   +"         	<Link>"+link+"</Link>"
				   +"         	</UpdateDocumentCount>"
				   +"         </data>"
				   +"      </UpdateDocumentCount>"	   
				   +"   </soap:Body>"		             
				   +"</soap:Envelope>";
			      
				   returnData = connectSOAP(sendMessage,soapEndpointUrl,"UpdateDocumentCountResult");
			 } catch (Exception e) {
				    e.printStackTrace();
			 }    
			 return returnData;
		}
		
		
}
