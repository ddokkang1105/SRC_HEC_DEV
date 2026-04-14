package xbolt.custom.hyundai.hkfc.web;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;



import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;



@Controller
public class HKFCBatchActionController {    
    


	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	// 반영 시 주석해제
	//@Resource(name="orclSession")
	//private SqlSession orclSession;
	
	private final Log _log = LogFactory.getLog(this.getClass());
	
	public void zHKFC_sendMailBatch() throws Exception {  
		
		System.out.println("배치 메일 시작");
		
		try{
			
			String languageID = GlobalVal.DEFAULT_LANGUAGE;
			Map setdata = new HashMap();
			setdata.put("languageID", languageID);	
			
			String BatchYN = "Y";
			
			// 배치 메일 테이블에서 메일 정보 출력
			String emailCode = "ESPMAIL012";
			List mailList = commonService.selectList("custom_SQL.zHKFC_getBatchMail", setdata);

			System.out.println("mailList.size():"+mailList.size());
		    if(mailList != null && mailList.size() > 0){
		    	for(int i=0; i < mailList.size(); i++){
		    		HashMap mailMap = (HashMap) mailList.get(i);
		    		
		    		
		    		// ReportCode가 존재하면 withDrawCS 호출
		            String reportCode = StringUtil.checkNull(mailMap.get("ReportCode"));
		            String itemID = StringUtil.checkNull(mailMap.get("ItemID")); // mailMap에서 itemID 추출
					HashMap setMap = new HashMap();
		        	setMap.put("s_itemID", itemID);
					setMap.put("languageID", languageID);
					Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
					String status = StringUtil.checkNull(itemInfo.get("Status"));
					
		            
		            if(reportCode.equals("RP00056")) {
		            	// ReportCode가 존재하면 메일 전송 대신 withDraw 실행
		            	
		            	HttpServletRequest request = null;
		            	HashMap<String,String> commandMap = new HashMap<>();
		            	ModelMap model = new ModelMap();
		            	commandMap.put("itemID", itemID);
	                    commandMap.put("sessionCurrLangType", languageID);
		            	try {
		            	
		                        // withDrawCS 호출 (같은 클래스 or 주입된 컨트롤러 통해 호출해야 함)
		            		if(status.equals("MOD1")) {
		            			
		            			this.withDrawCSForBatch(request, commandMap, model);
		            			System.out.println("withDrawCSForBatch 실행 완료 :: itemID = " + itemID);
		            		}

		            	   
		            	} catch (Exception ex) {
		            		 System.out.println("withDrawCSForBatch 오류: " + ex.getMessage());
		            	}
		            	
		            }else {
		            	// 메일 전송
			    		BatchMail(mailMap, emailCode, BatchYN);
		            }
		    		
		    	}
		    }
		    
		    // 배치 메일 테이블 삭제
		    commonService.delete("custom_SQL.zHKFC_truncateBatchMail", setdata);
		    
		} catch (Exception e) {
			System.out.println("zHKFCBatchActionController ::: zSK_sendMailBatch " + e);
		}
		
	    // Batch Log Insert
		System.out.println("배치 메일 전송 완료");
		
	}
	
	// 배치 메일 발송
	public void BatchMail( HashMap map, String emailCode, String BatchYN ) throws Exception {  
		try {
			
			// 01. lang
			String languageID = GlobalVal.DEFAULT_LANGUAGE;
			
			// 03. receiver 셋팅
			List receiverList = new ArrayList();
			
			// Batch Mail
			String receiptUserList = StringUtil.checkNull(map.get("Receiver"));
			if(!"".equals(receiptUserList)){
				String[] receiptUsers = receiptUserList.split(";");
				for (int i = 0; i < receiptUsers.length; i++) {
					Map receiverMap = new HashMap();
					receiverMap.put("receiptUserID", receiptUsers[i]);
				    receiverList.add(i, receiverMap);
				}
			};
			
			// 04. 메일 셋팅
			map.put("EMAILCODE", emailCode);
			map.put("receiverList", receiverList);
			
			// 05. 메일 로그 및 전송
			if(receiverList.size() > 0){
				
				// 06. 메일 로그
				
				map.put("loginID", "paladm2025");
				Map setMailMapRst = (Map)setBatchEmailLog(commonService, map, emailCode);
				System.out.println("setMailMapRst : "+setMailMapRst );
				
				if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
					
					// mail 송,수신자 정보 
					HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
					
					String mailSubject = StringUtil.checkNull(map.get("Subject"));
					String Body = StringUtil.checkNull(map.get("Body"));
					
					mailMap.put("mailSubject", mailSubject);
					map.put("emailHTMLForm", Body);
				
					//	메일안에 들어갈 내용 정보
					map.put("emailCode", "ESPMAIL012");
					map.put("languageID", languageID);
					
					// [07] 메일 보내기
					Map menu = getBatchLabel(commonService, languageID); //getLabel(request, commonService)
					Map resultMailMap = EmailUtil.sendMail(mailMap, map, menu);
					System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
					
				}else{
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
				}
			}
		} catch (Exception e) {
			System.out.println("SKONBatchActionController ::: " + e);
		}
	}
	
	
	// COMMON
	public static Map getBatchLabel(CommonService commonService, String languageID) throws Exception{
		HashMap cmmMap = new HashMap();
		HashMap getMap = new HashMap();
		cmmMap.put("languageID", languageID);
		cmmMap.put("mnCategory", "LN");
		List labelList = commonService.selectList("menu_SQL.menuName",cmmMap);
		
		cmmMap = new HashMap();
		for(int i = 0; i < labelList.size(); i++){
			cmmMap = (HashMap)labelList.get(i);
			getMap.put(cmmMap.get("TypeCode"), cmmMap.get("Name"));
		}
		
		return getMap;
	}
	
	public Map setBatchEmailLog(CommonService commonService, Map cmmMap, String dicTypeCode) throws Exception{
		
		HashMap resultMap = new HashMap();		

		if( StringUtil.checkNull(GlobalVal.USE_EMAIL).equals("Y")){
			Map mMailInfo = new HashMap();
			mMailInfo.put("dicTypeCode", dicTypeCode);
			try{
				Map setMap = new HashMap();
				List receiverList = (List)cmmMap.get("receiverList");
				//보내는 사람
				String sendUserID= StringUtil.checkNull(cmmMap.get("loginID"));
				setMap.put("userID", sendUserID);
				
				// multi mail check
				String baseUrl = GlobalVal.EMAIL_TYPE;
				String sender = GlobalVal.EMAIL_SENDER;
				String senderName = GlobalVal.EMAIL_SENDER_NAME;
				String EmailSvrDomain = GlobalVal.EMAIL_HOST_IP;
				String senderPwd = GlobalVal.SMTP_ACCOUNT_PWD;
				
				if(receiverList.size()>0 && !sender.equals("")){
					Map setDicMap = new HashMap();
					setDicMap.put("Category", "EMAILCODE");
					setDicMap.put("TypeCode", dicTypeCode);
					setDicMap.put("LanguageID", StringUtil.checkNull(cmmMap.get("languageID")));
					List mailDtlList = new ArrayList();
					mailDtlList = commonService.selectList("common_SQL.label_commonSelect",setDicMap);
					String mailSubject="";
					for(int i=0; i<mailDtlList.size(); i++){
						mailSubject = StringUtil.checkNull(((HashMap)mailDtlList.get(i)).get("LABEL_NM")); break;
					}
					//String subject = StringUtil.checkNull(cmmMap.get("subject"));
					mMailInfo.put("mailSubject", mailSubject);
					///insert emailLog
					String maxId = null;
					List receiverInfoList = new ArrayList();
					Map receiverInfoMap = new HashMap();
					Map receiverListMap = new HashMap();
					String receiptEmail = null;
					
					mMailInfo.put("Sender", sender);					
					mMailInfo.put("EmailCode", "BATCH");
					
					for(int i=0; receiverList.size()>i; i++){
						receiverInfoMap = new HashMap();
						receiverListMap = (Map)receiverList.get(i);
						maxId = StringUtil.checkNull(commonService.selectString("email_SQL.emailLog_nextVal", setMap)).trim();
						receiverInfoMap.put("seqID", maxId);
						setMap.put("userID", receiverListMap.get("receiptUserID"));
						receiptEmail =  StringUtil.checkNull(commonService.selectString("user_SQL.userEmail", setMap));	
						receiverInfoMap.put("receiptEmail", receiptEmail);						
						receiverInfoMap.put("receiptType", StringUtil.checkNull(receiverListMap.get("receiptType"),"TO") );
						receiverInfoMap.put("receiptUserID", receiverListMap.get("receiptUserID"));
						
						receiverInfoList.add(i, receiverInfoMap);						
						mMailInfo.put("Receiver", receiptEmail);
						mMailInfo.put("SEQ", maxId);
						commonService.insert("email_SQL.insertEmailLog", mMailInfo);
					}
					
					mMailInfo.put("receiverInfoList", receiverInfoList);
					mMailInfo.put("sendUserID", sendUserID);	
					
					resultMap.put("type", "SUCESS");
					resultMap.put("mailLog", mMailInfo);
				}else{
					resultMap.put("type", "FAILE");
					resultMap.put("msg", "not exists email address : emailSender="+sender+", receiverList.Size="+receiverList.size());
				}
			}catch(Exception ex){
				resultMap.put("type", "FAILE");
				resultMap.put("msg", ex.getMessage());
			}
		}else{
			resultMap.put("type", "DONT");
			resultMap.put("msg", "not use email");
		}
		return resultMap;
	}

	
	

	public void withDrawCSForBatch(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		HashMap withDrawMap = new HashMap();

		try {
			
			// itemID 가져오기
			String itemID = StringUtil.checkNull(commandMap.get("itemID"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", itemID);
			setMap.put("languageID", languageID);
			
			if(itemID != null && !"".equals(itemID)){

				// 1. itemID status check ( MOD1 ONLY )
				Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
				String status = StringUtil.checkNull(itemInfo.get("Status"));
				
				if("MOD1".equals(status)) {
					// 2. get itemID curchangeSet , releaseNo , status , ProjectID
					
					withDrawMap.put("itemID", itemID);
					withDrawMap.put("status",status);
					withDrawMap.put("languageID", languageID);
					
					withDrawMap.put("changeSetID", StringUtil.checkNull(itemInfo.get("CurChangeSet"), "")); 
					
					String releaseNo = StringUtil.checkNull(itemInfo.get("ReleaseNo"), "");
					withDrawMap.put("releaseNo",releaseNo);
					
					withdrawCSdata(withDrawMap, commandMap);
					//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00171"));
				
				} else {
					//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00173")); 
				}
				
			}
			
			//target.put(AJAX_SCRIPT, "this.doCallBack();parent.fnRefreshTree('"+ itemID +"',true);	parent.fnGetItemClassMenuURL('"+ itemID +"');this.$('#isSubmit').remove();");

		} catch (Exception e) {
			//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00167"));
			//target.put(AJAX_SCRIPT, "this.doCallBack();");
			System.out.println(e);
		}

		//model.addAttribute(AJAX_RESULTMAP, target);
		 //return nextUrl(AJAXPAGE);
	}
	
	//@Transactional
	public void withdrawCSdata(HashMap withDrawMap, HashMap commandMap) throws Exception{
		
		Map getChildData = new HashMap();
		Map setPjtData = new HashMap();
		Map setPreData = new HashMap();
		Map setItemData = new HashMap();
		Map setChildData = new HashMap();
		Map setNewChildData = new HashMap();
		
		Map setTeamData = new HashMap();
		setTeamData.put("assigned", "2");
		setTeamData.put("assgnVal", "3");
		
		try {
			
			// item status MOD1 only 
			String rjtProcOption = StringUtil.checkNull(withDrawMap.get("rjtProcOption"));
			
			// mando 제외
			if(!"2".equals(rjtProcOption)){
				
				String curChangeSet = StringUtil.checkNull(withDrawMap.get("changeSetID"), "");
				String releaseNo = StringUtil.checkNull(withDrawMap.get("releaseNo"), "");
				String itemID = StringUtil.checkNull(withDrawMap.get("itemID"), "");
				
				if(curChangeSet != null && !"".equals(curChangeSet) &&
				   releaseNo != null && !"".equals(releaseNo) &&
				   itemID != null && !"".equals(itemID))
				{
				
					// 1. pre version projectID get
					setPjtData.put("s_itemID",releaseNo);
					String projectID = StringUtil.checkNull(commonService.selectString("cs_SQL.getProjectIDForCSID", setPjtData));
					
					// 2. new file & new team_role delete
					setItemData.put("changeSetID",curChangeSet);
					setItemData.put("assgnVal", "1");
					commonService.delete("fileMgt_SQL.deleteFile", setItemData);
					commonService.delete("role_SQL.deleteTeamRole", setItemData);
					
					// 3. child item ( MOD or DEL ) -- 해당 아이템의 curChangeSet이 동일해야함. 예전에 삭제된 것 복구하면 안되니까 ..
					setChildData.put("Blocked", "2");
					setChildData.put("Status", "REL");
					setChildData.put("changeSetID", curChangeSet);
					setChildData.put("releaseNo", releaseNo);
					setChildData.put("CurChangeSet", releaseNo);
					setChildData.put("ProjectID", projectID);
					setChildData.put("Deleted", "0");
					setChildData.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
					
					withDrawMap.put("s_itemID", itemID);
					withDrawMap.put("accMode", "OPS");
					withDrawMap.put("delItemsYN","Y");
					withDrawMap.put("changeSetID",curChangeSet);
					List childItemList = commonService.selectList("item_SQL.getChildItemList_gridList", withDrawMap);
					
					for (int i = 0; childItemList.size() > i; i++) {
						getChildData = (Map) childItemList.get(i);
						setChildData.put("itemID", getChildData.get("ItemID"));
						setChildData.put("ItemID", getChildData.get("ItemID"));
						setChildData.put("s_itemID", getChildData.get("ItemID"));
						// 3-1. child item attr recover
						commonService.update("attr_SQL.recoverItemAttr", setChildData);
						// 3-2. update child item status ( DEL&MOD => REL ) 
						commonService.update("item_SQL.updateCNItemDelRecover", setChildData);
						commonService.update("project_SQL.updateItemStatus", setChildData);
						// 3-3. remove item_attr_rev
						commonService.delete("item_SQL.deleteAttrRev", setChildData);
						// 3-4. remove revision
						commonService.delete("item_SQL.deleteRevision", setChildData);
						// 3-5. update team role
						setTeamData.put("itemID", getChildData.get("ItemID"));
						commonService.update("role_SQL.updateTeamRole", setTeamData);
					}
					
					// 4. child item ( NEW )
					setNewChildData.put("changeSetID", curChangeSet);
					setNewChildData.put("Status", "DEL1");
					setNewChildData.put("Deleted", "1");
					setNewChildData.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
					
					withDrawMap.remove("accMode");
					withDrawMap.remove("delItemsYN");
					withDrawMap.remove("changeSetID");
					withDrawMap.put("statusList", "'NEW1','NEW2'");
					childItemList = commonService.selectList("item_SQL.getChildItemList_gridList", withDrawMap);
					
					for (int i = 0; childItemList.size() > i; i++) {
						getChildData = (Map) childItemList.get(i);
						setNewChildData.put("itemID", getChildData.get("ItemID"));
						setNewChildData.put("s_itemID", getChildData.get("ItemID"));
						setNewChildData.put("ItemID", getChildData.get("ItemID"));
						setNewChildData.put("DimTypeID", getChildData.get("ItemID"));
						// 4-1. update child item status ( NEW => DEL ) 
						commonService.update("item_SQL.updateCNItemDeleted", setNewChildData);
						commonService.update("project_SQL.updateItemStatus",setNewChildData);
					}
					
					// 5. item
					setItemData.put("Status", "REL");
					setItemData.put("changeSetID", curChangeSet);
					setItemData.put("CurChangeSet", releaseNo);
					setItemData.put("ProjectID", projectID);
					setItemData.put("itemID", itemID);
					setItemData.put("s_itemID", itemID);
					setItemData.put("Blocked", 2);
					
					// 5-1. update item status ( MOD1,MOD2 => REL / curChangeSet , releaseNo, projectID, blocked recover )
					commonService.update("project_SQL.updateItemStatus", setItemData);
					// 5-2. item_attr recover
					commonService.update("attr_SQL.recoverItemAttr", setItemData);
					// 5-3. remove item_attr_rev
					commonService.delete("item_SQL.deleteAttrRev", setItemData);
					// 5-4. remove revision
					commonService.delete("item_SQL.deleteRevision", setItemData);
					// 5-5. update team role ( del(3) -> release(2) ) 
					setTeamData.put("itemID", itemID);
					commonService.update("role_SQL.updateTeamRole", setTeamData);
					
					// 6. model
					String modelID = commonService.selectString("item_SQL.getModelIDFromChangSet", setItemData);
					setItemData.put("ModelID", modelID);
					commonService.delete("report_SQL.delElementAndModelTxt", setItemData);
					
					setItemData.put("ChangeSetID", curChangeSet);
					setItemData.put("ItemID", itemID);
					
					// 7. changeSetID delete
					commonService.delete("cs_SQL.delChangeSetInfo", setItemData);
					
					// 8. board delete (제/개정 검토 의견 해당 버전 삭제)
					List boardIDs = commonService.selectList("board_SQL.getBoardID", setItemData);
					Map boardMap = new HashMap();
					String boradID = "";
					
					if(boardIDs.size() > 0) {
						for (int i = 0; boardIDs.size() > i; i++) {
							boardMap = (Map) boardIDs.get(i);
							boradID = StringUtil.checkNull(boardMap.get("BoardID"));
							setItemData.put("boardID", boradID);
							// 파일 폴더에 저장된 해당 파일을 삭제
							List<String> deletefileList = new ArrayList<String>();
							deletefileList = commonService.selectList("forumFile_SQL.forumFile_select3", setItemData);
							File file;
							for (int j = 0; j < deletefileList.size(); j++) {
								file = new File(deletefileList.get(j));
								if (file.exists())
									file.delete();
							}
							
							// [TB_BOARD_ATTCH][TB_BOARD_COMMENT][TB_BOARD_SCORE][TB_BOARD]테이블의 해당 데이터를 모두 삭제
							Map deleteValMap = new HashMap();
							Map deleteInfoMap = new HashMap();
							List deleteList = new ArrayList();
							deleteValMap.put("boardID", boradID);
							
							deleteList.add(deleteValMap);
							deleteInfoMap.put("KBN", "delete");
							deleteInfoMap.put("SQLNAME", "forum_SQL.forumDelete");
							commonService.save(deleteList, deleteInfoMap);

							deleteValMap.put("documentID", boradID);
							commonService.delete("schedule_SQL.deleteSchedlByDocumentID", deleteValMap);
							
						}
					}
					
				}
				
				
			} else {
				// 1. model category update
				commonService.update("model_SQL.updateModelCat", withDrawMap);
				// 2. item_attr recover
				commonService.update("attr_SQL.recoverItemAttr", withDrawMap);
			}
		
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

	}
	
}
	
