package xbolt.app.esp.main.util;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.util.TimezoneThreadLocal;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.framework.val.TimezoneGlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.daelim.cmm.DLMCmmActionController;


@SuppressWarnings("unchecked")
public class ESPUtil extends XboltController {
	
	
	private static final Log _log = LogFactory.getLog(ESPUtil.class);
	
	// Status 분기처리 후 Next 값 가져오기
	public static Map getNextSpeCode(HttpServletRequest request, CommonService commonService, Map map) throws Exception {
		
		Map nextSpeMap = new HashMap();
		String speCode = "";
		String nextSortNum = "";
		
		try {
			Map setMap = new HashMap();
			
			String srID = StringUtil.checkNull(map.get("srID"));
			setMap.put("srID",srID);
			
			String languageID = StringUtil.checkNull(map.get("languageID"));
			setMap.put("languageID",languageID);
			
			// 현재 status 구하기
			String status = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRStatus", setMap));
			setMap.put("status", status);
			// 현재 sortNum 구하기
			String sortNum = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPStatusSortNum", setMap));
			setMap.put("sortNum", sortNum);
			
			// return paramter 구하기 
			String actionParameter = StringUtil.checkNull(map.get("actionParameter")); // ex : wfInstanceID
			String actionValue = "";
			
			if(!"".equals(actionParameter)){
				actionValue = StringUtil.checkNull(map.get(actionParameter));
			} else {
				// MethodName (rule=decision 의 경우)
				String methodName = StringUtil.checkNull(request.getServletPath());
				actionValue = StringUtil.checkNull(methodName.replace("/", ""));
			}
			
			// 분기 결정 값 setting
			setMap.put("resultParameter",actionValue);
			
			// 결과 값 조회
			setMap.put("rulePass", "N");
			List nextStatusList = commonService.selectList("esm_SQL.getESPNextEventList",setMap);
			if(nextStatusList.size() > 0 && !nextStatusList.isEmpty()){
				Map nextMap = (Map) nextStatusList.get(0);
				speCode = StringUtil.checkNull(nextMap.get("SRNextStatus"),"");
				nextSpeMap.put("speCode", speCode);
				nextSortNum = StringUtil.checkNull(nextMap.get("NextSortNum"),"");
				nextSpeMap.put("nextSortNum", nextSortNum);
				String nextPgrVarfilter = StringUtil.checkNull(nextMap.get("SRNextSpePgrVarFilter"),"");
				nextSpeMap.put("nextPgrVarfilter", nextPgrVarfilter);
			}
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextSpeMap;
		
	}
	
	// ESP Update 공통 ( SR 상태변경 / Log 기록 / ProcRoleType 비교 )
	public static void updateESP(HttpServletRequest request, CommonService commonService, Map map) throws Exception {
		
		try {
			// * map = update 정보 담긴 Map / srGoNextYN - SR 상태 변경 옵션 / srLogType - SR 로그 옵션
			String srID = StringUtil.checkNull(map.get("srID"));
			String activityStatus = StringUtil.checkNull(map.get("activityStatus")); // activity status
			String srGoNextYN = StringUtil.checkNull(map.get("srGoNextYN")); // 상태변경 옵션
			String srLogType = StringUtil.checkNull(map.get("srLogType")); // 로그 여부
			String resetRoleTP = StringUtil.checkNull(map.get("resetRoleTP")); // 담당자 정보 삭제 옵션
			String emailCode = StringUtil.checkNull(map.get("emailCode")); // 이메일 옵션 - 코드 ( 현재  )
			String nextEmailCode = StringUtil.checkNull(map.get("nextEmailCode")); // 이메일 옵션 - 코드 ( 이벤트진행 시 )
			String changeCategory = StringUtil.checkNull(map.get("changeCategory")); // 서비스/파트 & 카테고리 변경 옵션
			String speCode = StringUtil.checkNull(map.get("speCode")); // now speCode ##전자결재일경우 승인요청단계의 SPECODE 변경계회
			
			// TimeZone setting start
			String dueDate = StringUtil.checkNull(map.get("dueDate"));
			if(!"".equals(dueDate)) {
				dueDate = changeTimeZoneDateType(dueDate);
				map.put("dueDate", dueDate);
			}
			String reqdueDate = StringUtil.checkNull(map.get("reqdueDate"));
			if(!"".equals(reqdueDate)) {
				reqdueDate = changeTimeZoneDateType(reqdueDate);
				map.put("reqdueDate", reqdueDate);
			}
			// TimeZone setting end
			
			
			// * changeCategory = Y 인 경우만 clientID 업데이트
			if(!"Y".equals(changeCategory)) map.remove("clientID");
			
			// 01. [ 현재 status의 input filter 추가 ]
			if("".equals(speCode)){
				speCode = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRStatus", map));
			}
			map.put("speCode", speCode);
			Map param = getStatusParams(commonService, map);
			map.putAll(param);
			
			// * 접수 or 저장 or 보안 일 경우 param에서 해당 옵션 제거
			if("01".equals(activityStatus) || "".equals(activityStatus) || "09".equals(activityStatus)){
				map.remove("svcCompl");
				map.remove("blocked");
				map.remove("emailCode");
				param.remove("emailCode");
			
				map.remove("nextEmailCode");
				param.remove("nextEmailCode");
				if(!"09".equals(activityStatus)) map.put("activityBlocked","0");
			}
			// [저장]의 경우 제외 모두 isPublic = 1 ( 0 : 임시저장 )
			if(!"".equals(activityStatus)) map.put("isPublic", "1");
			
			// 02. [ Send Mail ] -- 메일 보내기 ( get 우선 / param 2순위 ) -- 현재상태 메일 발송 
			if("".equals(emailCode)) emailCode = StringUtil.checkNull(param.get("emailCode"));
			if(!"".equals(emailCode)) {
				// 메일&push 현상태 발송
				map.put("emailCode", emailCode);
				sendSRMail(request,commonService,map);
			}
			
			// 03. [ get next status && Update SR ]
			String nextSpeCode = ""; // next speCode
			String nextSortNum = "";
			
			if(!"N".equals(srGoNextYN)){
				// [ Update SR ] - Next 진행상태로 업데이트

				// * Next 단계, sortnum 가져오기
				Map nextSpeMap = ESPUtil.getNextSpeCode(request,commonService,map);
				nextSpeCode = StringUtil.checkNull(nextSpeMap.get("speCode"));
				nextSortNum = StringUtil.checkNull(nextSpeMap.get("nextSortNum"));
				
				// * 맵의 다음단계가 END 일 경우 종료처리
				if ("END".equals(nextSpeCode)){
					map.remove("activityStatus");
					completeActivity(request, commonService, map);
				}else if(!"".equals(nextSpeCode) && !"END".equals(nextSpeCode)){
					map.put("status", nextSpeCode);
					map.put("sortNum", nextSortNum);
					
					String nextPgrVarfilter = StringUtil.checkNull(nextSpeMap.get("nextPgrVarfilter"));
					Map NextParam = getQueryParams(nextPgrVarfilter);
					
					// procRoleTP 예외 체크
					String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPProcRoleTP",map)); // next procRoleTP 예외처리 체크
					// * 예외 없을 경우 다음단계의 input의 procRoleTP 체크 후 업데이트 
					if("".equals(procRoleTP)){
						procRoleTP = StringUtil.checkNull(NextParam.get("procRoleTP")); // procRoleTP가 없을 시 CLIENT
					}
					map.put("procRoleTP", procRoleTP);
					
					// procRoleTP 가 'CLIENT' 일 경우 요청자 = receiptUser
					if("CLIENT".equals(procRoleTP)){
						map.put("receiptUserID",StringUtil.checkNull(map.get("requestUserID")));
			        	map.put("receiptTeamID",StringUtil.checkNull(map.get("requestTeamID")));
					}
					// update sr mst
					commonService.update("esm_SQL.updateESMSR", map);

					// 단계 진행 시 무조건 receiver 삭제
					if((!"N".equals(resetRoleTP) && !"CLIENT".equals(procRoleTP))){
						commonService.update("esm_SQL.deleteReceiptUser", map);
			        	map.remove("receiptUserID");
			        	map.remove("receiptTeamID");
			        	
			        	// role
						Map roleChkMap = new HashMap();
			        	String srArea2 = StringUtil.checkNull(map.get("srArea2"));
			        	String srArea1 = StringUtil.checkNull(map.get("srArea1"));
			        	String srArea = ("".equals(srArea2) || "undefined".equals(srArea2) || "0".equals(srArea2)) ? srArea1 : srArea2;
			        	
						roleChkMap.put("srArea",StringUtil.checkNull(srArea));
						roleChkMap.put("languageID",StringUtil.checkNull(map.get("languageID")));
			        	roleChkMap.put("RoleType",procRoleTP);
						List RoleTPList = commonService.selectList("esm_SQL.getReceiptUserList", roleChkMap);
						
			        	// 단계 진행 시 다음 그룹에 인원이 할당되어있는지 체크
						if(RoleTPList.size() < 1){
							map.put("roleGroupNull", "Y");
						}
			        }
					
					// next의 emailCode 확인 
					if("".equals(nextEmailCode)) nextEmailCode = StringUtil.checkNull(NextParam.get("nextEmailCode"));
					
					System.out.println("_________next의 emailCode 확인 ::::"+nextEmailCode );
					if(!"".equals(nextEmailCode)) {
						// 메일&push 
						String emailLangID = StringUtil.checkNull(NextParam.get("emailLangID"));
						map.put("emailLangID", emailLangID);
						map.put("emailCode", nextEmailCode);
						sendSRMail(request,commonService,map);
					}
					
				}
			} else {
				System.out.println("changeCategory:"+changeCategory);
				if("Y".equals(changeCategory)) {
					// changeCategory 인 항목들은 무조건 변경 시 저장하도록 개선되었음. ( 단계이동과 함께 사용 불가 )
					
					// 서비스/파트 설정 시 clientID변경되면서 projectID도 변경시켜줘야함
					String ProjectID = StringUtil.checkNull(ESPUtil.getEspProjectID(commonService, map));
					map.put("projectID",ProjectID);
					
					// 단순 저장 시, 동일한 sortNum에 맞는 speCode 및 담당자로 재변경
					String changeInfo = StringUtil.checkNull(map.get("changeInfo"));
					if("".equals(activityStatus) && "Y".equals(changeInfo)) {
						String sessionUserID = StringUtil.checkNull(map.get("sessionUserId"));
						map = changeNewSpeCode(map, commonService, request, speCode, srID, sessionUserID);
						speCode = StringUtil.checkNull(map.get("status"));
					}
				}
				
				// [ Update SR ] - 단순 내용 업데이트
				if("Y".equals(StringUtil.checkNull(map.get("fromAprvProcessing")))) {	// 25.12.22 수정 :: 결재 후처리일때는 procRoleTP update 안되도록수정, 이유는 activityLogID 가 현재 단게가 아닌 결재단계의 activityLogID라서, input 값에 설정된 procRoleTp 가 안맞는 오류 때문
					map.remove("procRoleTP");
				}
				commonService.update("esm_SQL.updateESMSR", map);
			}
			
			// 04. [ Save Log ] -- N : 로그저장 x / U : Log 업데이트 ( 추가  없음 ) / I : Log 추가 ( 업데이트 없음 )
			if(!"N".equals(srLogType) && !"END".equals(nextSpeCode)){
				
				Map setActivityLogMapRst = new HashMap();
				String updateStatus = "05"; // 다음 activity 진행 시 현재 activityStatus를 어떤 값으로 업데이트 할 것인지 [ default : 완료 ]
				if("03".equals(activityStatus) || "02".equals(activityStatus)) updateStatus = activityStatus; // 승인처리 or 승인 중(선처리)
				
				String delWF = StringUtil.checkNull(map.get("delWF"));
				String wfInstanceID = StringUtil.checkNull(map.get("wfInstanceID"));
				if("".equals(wfInstanceID)) wfInstanceID = StringUtil.checkNull(map.get("curWFInstanceID"));
				if("Y".equals(delWF)) wfInstanceID = "";
				map.put("wfInstanceID", wfInstanceID);
				
				String activityComment = StringUtil.checkNull(map.get("activityComment"));
				
				// * next 단계 넘어갈 때 로그
				if(!"U".equals(srLogType) && !"".equals(nextSpeCode)){
					// * Next 진행상태 log 추가 [default : 접수 전]
					map.put("speCode", nextSpeCode);
					map.remove("startTime");
					map.remove("endTime");
					map.remove("activityComment");
					map.remove("wfInstanceID"); // 추후 테스트
					map.put("activityStatus", "00");
					setActivityLogMapRst = (Map)setActivityLog(request, commonService, map);
					
					// * 기존 status log 완료처리
					if(!"I".equals(srLogType)){
						Map updateMap = new HashMap();
						updateMap.put("srID", srID);
						updateMap.put("speCode", speCode);
						updateMap.put("activityStatus", updateStatus);
						updateMap.put("activityComment", activityComment);
						updateMap.put("activityBlocked", "1");
						updateMap.put("endTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
						updateMap.put("wfInstanceID", wfInstanceID);
						updateMap.put("maxSeq", "Y");
						updateMap.put("prevSRCategory", StringUtil.checkNull(map.get("prevSRCategory")));
						setActivityLogMapRst = (Map)updateActivityLog(request, commonService, updateMap);
					}
					
				}
				// * 단순 로그 업데이트
				else if("U".equals(srLogType) && !"".equals(speCode)){
					// logType이 update일 경우 speCode는 기존 speCode 사용
					map.put("speCode", speCode);
					map.put("maxSeq", "Y");
					setActivityLogMapRst = (Map)updateActivityLog(request, commonService, map);
				}
				
				// * 기각&반려&강제종료의 경우 SR 종료처리
				if("06".equals(activityStatus) || "04".equals(activityStatus) || "08".equals(activityStatus)){
					completeActivity(request, commonService, map);
				}
				
				if(setActivityLogMapRst.get("type").equals("FAILE")){
					System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setActivityLogMapRst.get("msg")));
				}
			}
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		
	}
	
	// SR / Activity 완료처리
	public static void completeActivity(HttpServletRequest request, CommonService commonService, Map map) throws Exception {
			
		try {
			// 01. update SR
			String CompletionDT = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRCompetionDT", map));
			if("".equals(CompletionDT)) map.put("svcCompl", "Y");
			else map.remove("svcCompl");
			
			map.put("blocked", "2"); // SR Blocked
			commonService.update("esm_SQL.updateESMSR", map);
			
			// 02. log update (default : 05)
			String activityStatus = StringUtil.checkNull(map.get("activityStatus"),"05");
			map.put("maxSeq", "Y");
			map.put("activityStatus", activityStatus);
			map.put("activityBlocked", "1"); // Activity Blocked
			map.put("EndTime", ESPUtil.getCurrentLocalDate("yyyy-MM-dd HH:mm:ss"));
			
			// 03. 완료처리 안 된 항목 
			Map setActivityLogMapRst = (Map)updateActivityLog(request, commonService, map);
			if(setActivityLogMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setActivityLogMapRst.get("msg")));
			}
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	// 결재 상신 & 결재 후 처리
	public static void srAprvProcessingMaster(HttpServletRequest request, CommonService commonService, Map map) throws Exception {
			
		try {
			Map setData = new HashMap();
			// get WFInstanceID
			String wfInstanceID = StringUtil.checkNull(map.get("curWFInstanceID"));
			if("".equals(wfInstanceID)) wfInstanceID = StringUtil.checkNull(map.get("wfInstanceID"));
			if("".equals(wfInstanceID)) wfInstanceID = StringUtil.checkNull(map.get("newWFInstanceID"));
			
			String srID = StringUtil.checkNull(map.get("srID"));
			String roleType = StringUtil.checkNull(map.get("roleType"));
			String languageID = StringUtil.checkNull(map.get("languageID"));
			String srGoNextYN = "N";
			String srLogType = "U";
			String emailCode = "";
			String approveYN = StringUtil.checkNull(map.get("approveYN"));
			String sessionUserId = StringUtil.checkNull(map.get("sessionUserId"));
			
			if("".equals(languageID))languageID = StringUtil.checkNull(map.get("sessionCurrLangType"));
			String lastUser = StringUtil.checkNull(map.get("lastUser"));
			
			if("".equals(lastUser))lastUser = StringUtil.checkNull(map.get("sessionUserId"));
			String activityStatus = "";
			setData.put("wfInstanceID", wfInstanceID );
			
			
			// session 정보 강제 생성( 메일보낼때 xboltController쪽에서 session에 loginInfo 정보사용해야 해서 )
			HttpSession session = request.getSession(true);
			Map loginInfo = (Map)session.getAttribute("loginInfo");
			if (loginInfo == null) {
			    loginInfo = new HashMap(); // 새 Map 생성
			    session.setAttribute("loginInfo", loginInfo); // 세션에 다시 등록
			}

			// 값 주입
			loginInfo.put("sessionUserId", sessionUserId);      
			loginInfo.put("sessionCurrLangType", languageID);           

			
			// 02. Update Data setting
			setData.put("srID", srID);
			setData.put("languageID",languageID);
			setData.put("procRoleTP", roleType);
			setData.put("lastUser", StringUtil.checkNull(map.get("sessionUserId")) );
			
			Map srInfoMap =  commonService.select("esm_SQL.getESMSRInfo", setData);	
			setData.put("clientID", StringUtil.checkNull(srInfoMap.get("ClientID")) );
			
			// 03. resultParameter 셋팅 [ 임시저장 & 상신 & 승인 & 반려 ]
			if(!"D".equals(approveYN) && !"".equals(wfInstanceID)){
				
				Map wfMap = commonService.select("wf_SQL.getWFInstDetail", setData);
				String wfInstanceStatus = StringUtil.checkNull(wfMap.get("StatusCode"));
				String AprvOption = StringUtil.checkNull(wfMap.get("AprvOption"));
				
				
				// [승인 or 반려]
				if(!"0".equals(wfInstanceStatus) && !"-1".equals(wfInstanceStatus)){
					// [정상로직]
					if(!"POST".equals(AprvOption)){

						setData.put("actionParameter", "wfInstanceStatus");
						setData.put("wfInstanceStatus", wfInstanceStatus);
						
						// [결재진행중/상신]
						if("1".equals(wfInstanceStatus)) {
							activityStatus = "02"; // 1:상신 => 02 - 승인 중
							setData.put("activityBlocked","1");
						}
						// [승인완료]
						else if("2".equals(wfInstanceStatus)) {
							// 선처리가 아닐 경우만 next activity로 이동
							srGoNextYN = "Y";
							srLogType = "";
							activityStatus = "03"; // 2:승인 => 03 - 승인
							emailCode = "ESPMAIL002"; // 완료
						}
						// [반려]
						else if("3".equals(wfInstanceStatus)) {
							activityStatus = "04"; // 3:반려 => 04 - 반려
							emailCode = "ESPMAIL007"; // 전자결재반려
						}
						
						setData.put("curWFInstanceID", wfInstanceID); // SR 업데이트용
						
					// [선처리]
					} else if("POST".equals(AprvOption)) {
						
						setData.put("wfInstanceID", wfInstanceID);
						setData.put("delWF","Y"); // 단계진행 후 log에 wfInstanceID 삭제해야함.
						
						// [승인완료]
						if("2".equals(wfInstanceStatus)){
							activityStatus = "03";
							String speCode = "";
							
							setData.put("notInActivityStatusList","'05'");
							List logList = commonService.selectList("esm_SQL.getESMProLogInfo_gridList", setData);
							if(logList.size() > 0){
								Map logMap = (Map) logList.get(0);
								speCode = StringUtil.checkNull(logMap.get("speCode"));
								setData.put("speCode",speCode);
							}
						}
						// [반려]
						else if("3".equals(wfInstanceStatus)){
							activityStatus = "04"; // 3:반려 => 04 - 반려
							emailCode = "ESPMAIL007"; // 전자결재반려
						}
					}
				}
				
				// [상신] or [임시저장]
				if(!"D".equals(approveYN) && !"2".equals(wfInstanceStatus) && !"3".equals(wfInstanceStatus)){
					
					// 요청메일 발송
					if("0".equals(wfInstanceStatus)){
						emailCode = "ESPMAIL006";
					}
					
					activityStatus = "02"; 
					
					// [정상로직]의 경우엔 단계 이동 없이 티켓에 WFInstanceID 추가 및 현재로그 상태 변경
					String speCode = StringUtil.checkNull(srInfoMap.get("Status"));
					map.put("speCode", speCode);
					
					// [선처리 진행 후 재상신]여부 체크
					String reqReApprovalYN = "N";
					String activityLogID = StringUtil.checkNull(map.get("activityLogID"));
					if(!"".equals(activityLogID)){
						setData.put("activityLogID",activityLogID);
						String acitivityLogSpeCode = StringUtil.checkNull(commonService.selectString("esm_SQL.getActivitySpeCode", setData));
						
						if(!speCode.equals(acitivityLogSpeCode)) {
							reqReApprovalYN = "Y";
							speCode = acitivityLogSpeCode;
							setData.put("speCode",speCode);
						}
					}
					setData.remove("activityLogID");
					
					// [선처리]기능이 있는 경우 단계이동 처리 ( * 단 [재상신]이 아닐 때 )
					if(!"Y".equals(reqReApprovalYN)){
						Map param = getStatusParams(commonService, map);
						if (param.containsKey("aprvBlock")) {
							String aprvBlock = StringUtil.checkNull(param.get("aprvBlock"));
							
							if("1".equals(aprvBlock)){
								
								// update - aprvOption = POST
								setData.put("WFInstanceID", wfInstanceID);
								setData.put("aprvOption", "POST");
								commonService.update("wf_SQL.updateWfInst", setData); 
								
								// Update Data setting
								srGoNextYN = "Y";
								srLogType = "";
								setData.remove("activityBlocked");
								setData.put("wfInstanceStatus", "2");
							}
						}
					}
				}
				
				// [공통] SR Update
				if(!"D".equals(approveYN)){
					setData.put("srGoNextYN", srGoNextYN);
					setData.put("srLogType", srLogType);
					setData.put("activityStatus",activityStatus);
					setData.put("emailCode", emailCode);
					setData.put("fromAprvProcessing", "Y"); // 25.12.22 수정 :: 결재 후처리일때는 procRoleTP update 안되도록수정, 이유는 activityLogID 가 현재 단게가 아닌 결재단계의 activityLogID라서, input 값에 설정된 procRoleTp 가 안맞는 오류 때문

					updateESP(request, commonService, setData);
				}
				
			}
			
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
			
	}
	
	// INSERT SR FILE
	public static void insertESPSRFiles(HashMap commandMap, CommonService commonService, CommonService esmService, String srID) throws ExceptionUtil {
		Map fileMap  = new HashMap();
		List fileList = new ArrayList();
			try {
				fileMap.put("fltpCode", "SRDOC");
				String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId"))+"//";
				//int seqCnt;	
		        Path path = Paths.get(orginPath);		        
		        if (Files.exists(path)) {
		        	//seqCnt = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));			        	
					fileMap.put("fltpCode", "SRDOC");
					String filePath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath",fileMap)); 
					String targetPath = filePath;
					List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
					
					String docCategory = StringUtil.checkNull(commandMap.get("docCategory"));
					String fltpCode = StringUtil.checkNull(commandMap.get("fltpCode"));
					if(docCategory.equals("")) {
						docCategory = "SR";
					}
					if(fltpCode.equals("")) {
						fltpCode = "SRDOC";
					}
					
					if(tmpFileList.size() != 0){
						for(int i=0; i<tmpFileList.size();i++){
							fileMap = new HashMap(); 
							HashMap resultMap = (HashMap)tmpFileList.get(i);
							//fileMap.put("Seq", seqCnt);
							fileMap.put("DocumentID",srID);
							fileMap.put("DocCategory",docCategory);
							fileMap.put("projectID", commandMap.get("projectID"));
							fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
							fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
							fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
							fileMap.put("FileMgt", "SR");
							fileMap.put("FltpCode", fltpCode);
							fileMap.put("userId", commandMap.get("sessionUserId"));
							fileMap.put("RegUserID", commandMap.get("sessionUserId"));
							fileMap.put("LastUser", commandMap.get("sessionUserId"));
							fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
							fileMap.put("speCode", commandMap.get("speCode"));
							fileMap.put("refDocumentID", commandMap.get("activityLogID"));
							
							fileMap.put("KBN", "insert");
							fileMap.put("SQLNAME", "esm_SQL.espFile_insert");					
							fileList.add(fileMap);
							//seqCnt++;
						}
					}
					if(fileList.size() != 0){
						esmService.save(fileList, fileMap);
					}
					
					if (!orginPath.equals("")) {
						FileUtil.deleteDirectory(orginPath);
					}
		        } 			
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}
	
	// INSERT SR FILE
		public static void insertESPFilesByFiletype(HashMap commandMap, CommonService commonService, CommonService esmService, String srID, List<Map<String, Object>> list) throws ExceptionUtil {
			Map fileMap  = new HashMap();
			List fileList = new ArrayList();
				try {
				//int seqCnt = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));		
				//Read Server File
				String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId"))+"//";
				fileMap.put("fltpCode", StringUtil.checkNull(commandMap.get("fltpCode")));
				String filePath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath",fileMap)); 
				String targetPath = filePath;
				List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
				
				String docCategory = StringUtil.checkNull(commandMap.get("docCategory"));
				String fltpCode = "";
				if(docCategory.equals("")) {
					docCategory = "SR";
				}
				if(fltpCode.equals("")) {
					fltpCode = "SRDOC";
				}
				
				if(tmpFileList.size() != 0){
					for(int i=0; i<tmpFileList.size();i++){
						fileMap = new HashMap(); 
						HashMap resultMap = (HashMap)tmpFileList.get(i);
						Map result = list.stream().filter(x -> x.get("fileName").equals(resultMap.get(FileUtil.ORIGIN_FILE_NM))).findAny().get();
						if(result.get("fileType")!=null){
							fltpCode = (String) result.get("fileType");
				        }
						// fileMap.put("Seq", seqCnt);
						fileMap.put("DocumentID",srID);
						fileMap.put("DocCategory",docCategory);
						fileMap.put("projectID", commandMap.get("projectID"));
						fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
						fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
						fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
						fileMap.put("FileMgt", "SR");
						fileMap.put("FltpCode", fltpCode);
						fileMap.put("userId", commandMap.get("sessionUserId"));
						fileMap.put("RegUserID", commandMap.get("sessionUserId"));
						fileMap.put("LastUser", commandMap.get("sessionUserId"));
						fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
						fileMap.put("speCode", commandMap.get("speCode"));
						fileMap.put("refDocumentID", commandMap.get("activityLogID"));
						fileMap.put("KBN", "insert");
						fileMap.put("SQLNAME", "esm_SQL.espFile_insert");
						fileList.add(fileMap);
						//seqCnt++;
					}
				}
				if(fileList.size() != 0){
					esmService.save(fileList, fileMap);
				}
				
				if (!orginPath.equals("")) {
					FileUtil.deleteDirectory(orginPath);
				}
	        } catch(Exception e) {
	        	throw new ExceptionUtil(e.toString());
	        }
		}
	
	//PROCESS Activity_LOG
	public static Map setActivityLog(HttpServletRequest request, CommonService commonService, Map cmmMap) throws Exception{
			
			HashMap resultMap = new HashMap();
			HashMap setMap = new HashMap();
			
			String SRType = StringUtil.checkNull(cmmMap.get("srType"));
			String ActivityCode = StringUtil.checkNull(cmmMap.get("activityCode"));
			String SpeCode = StringUtil.checkNull(cmmMap.get("speCode"));
			String ProcRoleTP = StringUtil.checkNull(cmmMap.get("procRoleTP"));
			String DocCategory = StringUtil.checkNull(cmmMap.get("docCategory"));
			String PID = StringUtil.checkNull(cmmMap.get("srID"));
			String DocumentID = StringUtil.checkNull(cmmMap.get("documentID"));
			if("".equals(DocumentID)) DocumentID = PID;
			String Status = StringUtil.checkNull(cmmMap.get("activityStatus"));
			
			// max seq setting
			setMap.put("srID", PID);
			setMap.put("status", SpeCode);
			String maxSeq = StringUtil.checkNull(commonService.selectString("esm_SQL.getSeqActivityLog", setMap),"0");
			
			int nextSeq = Integer.parseInt(maxSeq) + 1;
			String Seq = StringUtil.checkNull(nextSeq,"1");
			
			String StartTime = StringUtil.checkNull(cmmMap.get("startTime"));
			String DueDate = StringUtil.checkNull(cmmMap.get("activityDueDate"));
			String EndTime = StringUtil.checkNull(cmmMap.get("endTime"));
			String Comment = StringUtil.checkNull(cmmMap.get("activityComment"));
			String SortNum = StringUtil.checkNull(cmmMap.get("sortNum"));
			String Blocked = StringUtil.checkNull(cmmMap.get("activityBlocked"),"0");
			String WFInstanceID = StringUtil.checkNull(cmmMap.get("wfInstanceID"));
			String receiptTeamID = StringUtil.checkNull(cmmMap.get("receiptTeamID"),"");
			String receiptUserID = StringUtil.checkNull(cmmMap.get("receiptUserID"),"");
			String ActorID = StringUtil.checkNull(cmmMap.get("actorID"),receiptUserID);
			String TeamID = StringUtil.checkNull(cmmMap.get("actorTeamID"),receiptTeamID);
			String PrevSRCategory = StringUtil.checkNull(cmmMap.get("prevSRCategory"));
			String PrevSRType = StringUtil.checkNull(cmmMap.get("prevSRType"));
			
			// 완료 & 기각 & 강제종료 & 보류 Blocked 처리
			if("05".equals(Status) || "06".equals(Status) || "08".equals(Status) || "09".equals(Status)) Blocked = "1";
			
			//=======================
			//save Activity_LOG
			try{
				if(cmmMap!=null && cmmMap.size() > 0){
					HttpSession session = request.getSession(true);
					Map loginInfo = (Map)session.getAttribute("loginInfo");
					
					// 필수항목
					setMap.put("TeamID", TeamID);					
					setMap.put("ActorID", ActorID);	
					
					if(!"".equals(SRType)) setMap.put("SRType", SRType);
					if(!"".equals(ActivityCode)) setMap.put("ActivityCode", ActivityCode);
					if(!"".equals(SpeCode)) setMap.put("SpeCode", SpeCode);
					if(!"".equals(ProcRoleTP)) setMap.put("ProcRoleTP", ProcRoleTP);
					if(!"".equals(DocCategory)) setMap.put("DocCategory", DocCategory);
					if(!"".equals(PID)) setMap.put("PID", PID);
					if(!"".equals(DocumentID)) setMap.put("DocumentID", DocumentID);
					if(!"".equals(Status)) setMap.put("Status", Status);
					if(!"".equals(StartTime)) setMap.put("StartTime", StartTime);
					if(!"".equals(DueDate)) setMap.put("DueDate", DueDate);
					if(!"".equals(EndTime)) setMap.put("EndTime", EndTime);
					if(!"".equals(Comment)) setMap.put("Comment", Comment);
					if(!"".equals(SortNum)) setMap.put("SortNum", SortNum);
					if(!"".equals(Blocked)) setMap.put("Blocked", Blocked);
					if(!"".equals(Seq)) setMap.put("Seq", Seq);
					if(!"".equals(WFInstanceID)) setMap.put("WFInstanceID", WFInstanceID);
					if(!"".equals(PrevSRCategory)) setMap.put("PrevSRCategory", PrevSRCategory);
					if(!"".equals(PrevSRType)) setMap.put("PrevSRType", PrevSRType);
					
					commonService.insert("esm_SQL.insertActivityLog", setMap);
				}
				resultMap.put("type", "SUCESS");
			}catch(Exception ex){
				resultMap.put("type", "FAILE");
				resultMap.put("msg", ex.getMessage());
			}
			
			return resultMap;
	}
	
	//PROCESS Activity_LOG UPDATE
	public static Map updateActivityLog(HttpServletRequest request, CommonService commonService, Map cmmMap) throws Exception{
				
			HashMap resultMap = new HashMap();
			HashMap setMap = new HashMap();
			
			String SRType = StringUtil.checkNull(cmmMap.get("srType"));
			String ActivityCode = StringUtil.checkNull(cmmMap.get("activityCode"));
			String SpeCode = StringUtil.checkNull(cmmMap.get("speCode"));
			String newSpeCode = StringUtil.checkNull(cmmMap.get("newSpeCode"));
			String ProcRoleTP = StringUtil.checkNull(cmmMap.get("procRoleTP"));
			String DocCategory = StringUtil.checkNull(cmmMap.get("docCategory"));
			String PID = StringUtil.checkNull(cmmMap.get("srID"));
			String DocumentID = StringUtil.checkNull(cmmMap.get("documentID"));
			String Status = StringUtil.checkNull(cmmMap.get("activityStatus"));
			String StartTime = StringUtil.checkNull(cmmMap.get("startTime"));
			String DueDate = StringUtil.checkNull(cmmMap.get("activityDueDate"));
			String EndTime = StringUtil.checkNull(cmmMap.get("endTime"));
			String Comment = StringUtil.checkNull(cmmMap.get("activityComment"));
			String SortNum = StringUtil.checkNull(cmmMap.get("sortNum"));
			String Blocked = StringUtil.checkNull(cmmMap.get("activityBlocked"));
			String WFInstanceID = StringUtil.checkNull(cmmMap.get("wfInstanceID"));
			String Seq = StringUtil.checkNull(cmmMap.get("activitySeq"));
			String receiptTeamID = StringUtil.checkNull(cmmMap.get("receiptTeamID"),"");
			String receiptUserID = StringUtil.checkNull(cmmMap.get("receiptUserID"),"");
			String ActorID = StringUtil.checkNull(cmmMap.get("actorID"),receiptUserID);
			String TeamID = StringUtil.checkNull(cmmMap.get("actorTeamID"),receiptTeamID);
			String maxSeq = StringUtil.checkNull(cmmMap.get("maxSeq"));
			String PrevSRCategory = StringUtil.checkNull(cmmMap.get("prevSRCategory"));
			String PrevSRType = StringUtil.checkNull(cmmMap.get("prevSRType"));
			String activityLogID = StringUtil.checkNull(cmmMap.get("activityLogID"));
			
			// 완료 & 기각 & 강제종료는 Blocked 처리
			if("05".equals(Status) || "06".equals(Status) || "08".equals(Status)) Blocked = "1";
			
			//=======================
			//save Activity_LOG
			try{
				if(cmmMap!=null && cmmMap.size() > 0){
					HttpSession session = request.getSession(true);
					Map loginInfo = (Map)session.getAttribute("loginInfo");
					
					// 필수항목
					setMap.put("PID", PID);
					
					if(!"".equals(SRType)) setMap.put("SRType", SRType);
					if(!"".equals(ActorID)) setMap.put("ActorID", ActorID);
					if(!"".equals(TeamID)) setMap.put("TeamID", TeamID);
					if(!"".equals(ActivityCode)) setMap.put("ActivityCode", ActivityCode);
					if(!"".equals(SpeCode)) setMap.put("SpeCode", SpeCode);
					if(!"".equals(ProcRoleTP)) setMap.put("ProcRoleTP", ProcRoleTP);
					if(!"".equals(DocCategory)) setMap.put("DocCategory", DocCategory);
					if(!"".equals(DocumentID)) setMap.put("DocumentID", DocumentID);
					if(!"".equals(Status)) setMap.put("Status", Status);
					if(!"".equals(StartTime)) setMap.put("StartTime", StartTime);
					if(!"".equals(DueDate)) setMap.put("DueDate", DueDate);
					if(!"".equals(EndTime)) setMap.put("EndTime", EndTime);
					if(!"".equals(Comment)) setMap.put("Comment", Comment);
					if(!"".equals(SortNum)) setMap.put("SortNum", SortNum);
					if(!"".equals(Seq)) setMap.put("Seq", Seq);
					if(!"".equals(Blocked)) setMap.put("Blocked", Blocked);
					if(!"".equals(WFInstanceID)) setMap.put("WFInstanceID", WFInstanceID);
					if(!"".equals(maxSeq)) setMap.put("maxSeq", maxSeq);
					if(!"".equals(PrevSRCategory)) setMap.put("PrevSRCategory", PrevSRCategory);
					if(!"".equals(PrevSRType)) setMap.put("PrevSRType", PrevSRType);
					if(!"".equals(activityLogID)) setMap.put("activityLogID", activityLogID);
					if(!"".equals(newSpeCode)) setMap.put("newSpeCode", newSpeCode);
					
					commonService.update("esm_SQL.updateActivityLog", setMap);
				}
				resultMap.put("type", "SUCESS");
			}catch(Exception ex){
				resultMap.put("type", "FAILE");
				resultMap.put("msg", ex.getMessage());
			}
			
			return resultMap;
	}
	
	public static  List getSRAttrList(CommonService commonService, List attrList, Map<String, Object> cmdMap, String languageID) throws ExceptionUtil {
		
		Map<String, Object> setMap = cmdMap;
		Map setData = new HashMap();
		List mLovList = new ArrayList();
		List attrMbrList = new ArrayList();
		String attrMbrCode = "";
		String attrMbrName = "";
		String mLovAttrTypeCode = "";
		String mLovAttrTypeValue = "";
		
		String mLovValue = "";
		try {
			// isComLang = 1
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("languageID", languageID);
			setMap.put("IsComLang", "1");
			List comLangList = (List)commonService.selectList("esm_SQL.getSRAttr", setMap);
			
			for (int i = 0; i < attrList.size(); i++) {
				Map allMap = (Map) attrList.get(i);
				String removeAttrCode = String.valueOf(allMap.get("AttrTypeCode"));
				String attrTypeCode2 = String.valueOf(allMap.get("AttrTypeCode2"));
				
				String dataType = String.valueOf(allMap.get("DataType"));
				String isComLang = String.valueOf(allMap.get("IsComLang"));
				
				// isComLang = 1인 Item Attr 은  default언어로 취득한 data로 치환
				for (int j = 0; j < comLangList.size(); j++) {
					Map comLangMap = (Map) comLangList.get(j);
					String addAttrCode = String.valueOf(comLangMap.get("AttrTypeCode"));
				
					if (addAttrCode.equals(removeAttrCode)) {
						attrList.remove(i);						
						if(!attrTypeCode2.equals("") && attrTypeCode2 != null){ // 두번째 컬럼이 있으면 넣어준다 
							comLangMap.put("AttrTypeCode2", attrTypeCode2);
							comLangMap.put("Name2", allMap.get("Name2"));
							comLangMap.put("PlainText2", allMap.get("PlainText2"));
							comLangMap.put("LovCode2", allMap.get("LovCode2"));
							comLangMap.put("BaseLovCode2", allMap.get("BaseLovCode2"));
							comLangMap.put("DataType2", allMap.get("DataType2"));
							comLangMap.put("IsComLang2", allMap.get("IsComLang2"));
							comLangMap.put("HTML2", allMap.get("HTML2"));
							comLangMap.put("Mandatory2", allMap.get("Mandatory2"));
							comLangMap.put("Editable2", allMap.get("Editable2"));
							comLangMap.put("AreaHeight2", allMap.get("AreaHeight2"));
							comLangMap.put("editYN2", allMap.get("editYN2"));
							comLangMap.put("RowNum2", allMap.get("RowNum2"));
							comLangMap.put("ColumnNum2", allMap.get("ColumnNum2"));
							comLangMap.put("CtrlType2", allMap.get("CtrlType2"));
						}
						attrList.add(i, comLangMap);
					}
					
					if (addAttrCode.equals(attrTypeCode2)) {
						//returnData.remove(i);						
						if(!attrTypeCode2.equals("") && attrTypeCode2 != null){ // 두번째 컬럼이 있으면 넣어준다 
							allMap.put("PlainText2", comLangMap.get("PlainText"));
						}
						//returnData.add(i, comLangMap);
					}
				}
				
				// isComLang = 1이고, DataType = LOV인 Item Attr 은 TB_ITEM_ATTR 취득시만,  default언어설정 해서 값 치환
				if ("LOV".equals(dataType) && "1".equals(isComLang)) {
					setMap.put("languageID", languageID);
					setMap.put("defaultLang", defaultLang);
					setMap.put("IsComLang", "0");
					setMap.put("AttrTypeCode", removeAttrCode);
					
					List lovList = (List)commonService.selectList("esm_SQL.getSRAttr", setMap);
					
					for (int k = 0; k < lovList.size(); k++) {
						Map lovMap = (Map) lovList.get(k);
						String addAttrCode = String.valueOf(lovMap.get("AttrTypeCode"));
					
						if (addAttrCode.equals(removeAttrCode)) {
							attrList.remove(i);							
							if(!attrTypeCode2.equals("") && attrTypeCode2 != null){ // 두번째 컬럼이 있으면 넣어준다 
								lovMap.put("AttrTypeCode2", attrTypeCode2);
								lovMap.put("Name2", allMap.get("Name2"));
								lovMap.put("PlainText2", allMap.get("PlainText2"));
								lovMap.put("LovCode2", allMap.get("LovCode2"));
								lovMap.put("BaseLovCode2", allMap.get("BaseLovCode2"));
								lovMap.put("DataType2", allMap.get("DataType2"));
								lovMap.put("IsComLang2", allMap.get("IsComLang2"));
								lovMap.put("HTML2", allMap.get("HTML2"));
								lovMap.put("Mandatory2", allMap.get("Mandatory2"));
								lovMap.put("Editable2", allMap.get("Editable2"));
								// lovMap.put("Link2", allMap.get("Link2"));
								// lovMap.put("URL2", allMap.get("URL2"));
								lovMap.put("AreaHeight2", allMap.get("AreaHeight2"));
								lovMap.put("editYN2", allMap.get("editYN2"));
								lovMap.put("RowNum2", allMap.get("RowNum2"));
								lovMap.put("ColumnNum2", allMap.get("ColumnNum2"));
								lovMap.put("Style2", allMap.get("Style2"));
								lovMap.put("CtrlType2", allMap.get("CtrlType2"));
							}
							
							attrList.add(i, lovMap);
						}
					}
				}
			}
			
			// MBR, MLOV 추가 설정
			for (int k = 0; k < attrList.size(); k++) {
				Map attrTypeMap = (HashMap)attrList.get(k);
				
				if( StringUtil.checkNull(attrTypeMap.get("DataType")).equals("MBR")){	
					
					setMap.put("attrTypeCode",attrTypeMap.get("AttrTypeCode"));
					attrMbrList = commonService.selectList("esm_SQL.getSRATTRMbrList", setMap);
					if(attrMbrList.size() > 0) {
						for(int z=0; z<attrMbrList.size(); z++) {
							Map attrMbrInfo = (Map)attrMbrList.get(z);
							if(z == 0) {
								attrMbrCode = StringUtil.checkNull(attrMbrInfo.get("Code"));
								attrMbrName = StringUtil.checkNull(attrMbrInfo.get("Name"));
							}else {
								attrMbrCode = attrMbrCode + "," +StringUtil.checkNull(attrMbrInfo.get("Code"));
								attrMbrName = attrMbrName + "," +StringUtil.checkNull(attrMbrInfo.get("Name"));
							}
						}
					}
			        
					attrTypeMap.put(attrTypeMap.get("AttrTypeCode"), attrMbrCode);
					attrTypeMap.put("PlainText", attrMbrName);
				}
				
				if( StringUtil.checkNull(attrTypeMap.get("DataType2")).equals("MBR")){
					if(attrMbrList.size() > 0) {
						for(int z=0; z<attrMbrList.size(); z++) {
							Map attrMbrInfo = (Map)attrMbrList.get(z);
							if(z == 0) {
								attrMbrCode = StringUtil.checkNull(attrMbrInfo.get("Code"));
								attrMbrName = StringUtil.checkNull(attrMbrInfo.get("Name"));
							}else {
								attrMbrCode = attrMbrCode + "," +StringUtil.checkNull(attrMbrInfo.get("Code"));
								attrMbrName = attrMbrName + "," +StringUtil.checkNull(attrMbrInfo.get("Name"));
							}
						}
					}
			        
					attrTypeMap.put(attrTypeMap.get("AttrTypeCode2"), attrMbrCode);
					attrTypeMap.put("PlainText2", attrMbrName);
				}
				
				if( StringUtil.checkNull(attrTypeMap.get("DataType")).equals("MLOV")){
					setMap.put("s_itemID",attrTypeMap.get("AttrTypeCode"));
					setMap.put("languageID", languageID);
					mLovList = commonService.selectList("attr_SQL.selectAttrLovOption",setMap);
					
					attrTypeMap.put("mLovList", mLovList);				
				}
				
				if( StringUtil.checkNull(attrTypeMap.get("DataType2")).equals("MLOV")){
					setData.put("s_itemID",attrTypeMap.get("AttrTypeCode2"));
					setData.put("languageID", languageID);
					mLovList = commonService.selectList("attr_SQL.selectAttrLovOption",setData);
					
					attrTypeMap.put("mLovList2", mLovList);				
				}
			}
			
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
			
		return attrList;
	}
	
public static  List getSRAttrRevList(CommonService commonService, List attrList, Map<String, Object> cmdMap, String languageID) throws ExceptionUtil {
		
		Map<String, Object> setMap = cmdMap;
		Map setData = new HashMap();
		List mLovList = new ArrayList();
		List attrMbrList = new ArrayList();
		String attrMbrCode = "";
		String attrMbrName = "";
		String mLovAttrTypeCode = "";
		String mLovAttrTypeValue = "";
		
		String mLovValue = "";
		try {
			// isComLang = 1
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			if("".equals(languageID)){
				languageID = commonService.selectString("item_SQL.getDefaultLang", setMap);
			}
			setMap.put("languageID", languageID);
			setMap.put("IsComLang", "1");
			List comLangList = (List)commonService.selectList("esm_SQL.getSRAttrRev", setMap);
			
			for (int i = 0; i < attrList.size(); i++) {
				Map allMap = (Map) attrList.get(i);
				String removeAttrCode = String.valueOf(allMap.get("AttrTypeCode"));
				String attrTypeCode2 = String.valueOf(allMap.get("AttrTypeCode2"));
				
				String dataType = String.valueOf(allMap.get("DataType"));
				String isComLang = String.valueOf(allMap.get("IsComLang"));
				
				// isComLang = 1인 Item Attr 은  default언어로 취득한 data로 치환
				for (int j = 0; j < comLangList.size(); j++) {
					Map comLangMap = (Map) comLangList.get(j);
					String addAttrCode = String.valueOf(comLangMap.get("AttrTypeCode"));
				
					if (addAttrCode.equals(removeAttrCode)) {
						attrList.remove(i);						
						if(!attrTypeCode2.equals("") && attrTypeCode2 != null){ // 두번째 컬럼이 있으면 넣어준다 
							comLangMap.put("AttrTypeCode2", attrTypeCode2);
							comLangMap.put("Name2", allMap.get("Name2"));
							comLangMap.put("PlainText2", allMap.get("PlainText2"));
							comLangMap.put("LovCode2", allMap.get("LovCode2"));
							comLangMap.put("BaseLovCode2", allMap.get("BaseLovCode2"));
							comLangMap.put("DataType2", allMap.get("DataType2"));
							comLangMap.put("IsComLang2", allMap.get("IsComLang2"));
							comLangMap.put("HTML2", allMap.get("HTML2"));
							comLangMap.put("Mandatory2", allMap.get("Mandatory2"));
							comLangMap.put("Editable2", allMap.get("Editable2"));
							comLangMap.put("AreaHeight2", allMap.get("AreaHeight2"));
							comLangMap.put("editYN2", allMap.get("editYN2"));
							comLangMap.put("RowNum2", allMap.get("RowNum2"));
							comLangMap.put("ColumnNum2", allMap.get("ColumnNum2"));
						}
						attrList.add(i, comLangMap);
					}
					
					if (addAttrCode.equals(attrTypeCode2)) {
						//returnData.remove(i);						
						if(!attrTypeCode2.equals("") && attrTypeCode2 != null){ // 두번째 컬럼이 있으면 넣어준다 
							allMap.put("PlainText2", comLangMap.get("PlainText"));
						}
						//returnData.add(i, comLangMap);
					}
				}
				
				// isComLang = 1이고, DataType = LOV인 Item Attr 은 TB_ITEM_ATTR 취득시만,  default언어설정 해서 값 치환
				if ("LOV".equals(dataType) && "1".equals(isComLang)) {
					setMap.put("languageID", languageID);
					setMap.put("defaultLang", languageID);
					setMap.put("IsComLang", "0");
					setMap.put("AttrTypeCode", removeAttrCode);
					
					List lovList = (List)commonService.selectList("esm_SQL.getSRAttrRev", setMap);
					
					for (int k = 0; k < lovList.size(); k++) {
						Map lovMap = (Map) lovList.get(k);
						String addAttrCode = String.valueOf(lovMap.get("AttrTypeCode"));
					
						if (addAttrCode.equals(removeAttrCode)) {
							attrList.remove(i);							
							if(!attrTypeCode2.equals("") && attrTypeCode2 != null){ // 두번째 컬럼이 있으면 넣어준다 
								lovMap.put("AttrTypeCode2", attrTypeCode2);
								lovMap.put("Name2", allMap.get("Name2"));
								lovMap.put("PlainText2", allMap.get("PlainText2"));
								lovMap.put("LovCode2", allMap.get("LovCode2"));
								lovMap.put("BaseLovCode2", allMap.get("BaseLovCode2"));
								lovMap.put("DataType2", allMap.get("DataType2"));
								lovMap.put("IsComLang2", allMap.get("IsComLang2"));
								lovMap.put("HTML2", allMap.get("HTML2"));
								lovMap.put("Mandatory2", allMap.get("Mandatory2"));
								lovMap.put("Editable2", allMap.get("Editable2"));
								// lovMap.put("Link2", allMap.get("Link2"));
								// lovMap.put("URL2", allMap.get("URL2"));
								lovMap.put("AreaHeight2", allMap.get("AreaHeight2"));
								lovMap.put("editYN2", allMap.get("editYN2"));
								lovMap.put("RowNum2", allMap.get("RowNum2"));
								lovMap.put("ColumnNum2", allMap.get("ColumnNum2"));
							}
							
							attrList.add(i, lovMap);
						}
					}
				}
			}
			
			// MBR, MLOV 추가 설정
			for (int k = 0; k < attrList.size(); k++) {
				Map attrTypeMap = (HashMap)attrList.get(k);
				
				if( StringUtil.checkNull(attrTypeMap.get("DataType")).equals("MBR")){	
					
					setMap.put("attrTypeCode",attrTypeMap.get("AttrTypeCode"));
					attrMbrList = commonService.selectList("esm_SQL.getSRATTRRevMbrList", setMap);
					if(attrMbrList.size() > 0) {
						for(int z=0; z<attrMbrList.size(); z++) {
							Map attrMbrInfo = (Map)attrMbrList.get(z);
							if(z == 0) {
								attrMbrCode = StringUtil.checkNull(attrMbrInfo.get("Code"));
								attrMbrName = StringUtil.checkNull(attrMbrInfo.get("Name"));
							}else {
								attrMbrCode = attrMbrCode + "," +StringUtil.checkNull(attrMbrInfo.get("Code"));
								attrMbrName = attrMbrName + "," +StringUtil.checkNull(attrMbrInfo.get("Name"));
							}
						}
					}
			        
					attrTypeMap.put(attrTypeMap.get("AttrTypeCode"), attrMbrCode);
					attrTypeMap.put("PlainText", attrMbrName);
				}
				
				if( StringUtil.checkNull(attrTypeMap.get("DataType2")).equals("MBR")){
					if(attrMbrList.size() > 0) {
						for(int z=0; z<attrMbrList.size(); z++) {
							Map attrMbrInfo = (Map)attrMbrList.get(z);
							if(z == 0) {
								attrMbrCode = StringUtil.checkNull(attrMbrInfo.get("Code"));
								attrMbrName = StringUtil.checkNull(attrMbrInfo.get("Name"));
							}else {
								attrMbrCode = attrMbrCode + "," +StringUtil.checkNull(attrMbrInfo.get("Code"));
								attrMbrName = attrMbrName + "," +StringUtil.checkNull(attrMbrInfo.get("Name"));
							}
						}
					}
			        
					attrTypeMap.put(attrTypeMap.get("AttrTypeCode2"), attrMbrCode);
					attrTypeMap.put("PlainText2", attrMbrName);
				}
				
				
				if( StringUtil.checkNull(attrTypeMap.get("DataType")).equals("MLOV")){
					setMap.put("s_itemID",attrTypeMap.get("AttrTypeCode"));
					setMap.put("languageID", languageID);
					mLovList = commonService.selectList("attr_SQL.selectAttrLovOption",setMap);
					
					attrTypeMap.put("mLovList", mLovList);				
				}
				
				if( StringUtil.checkNull(attrTypeMap.get("DataType2")).equals("MLOV")){
					setData.put("s_itemID",attrTypeMap.get("AttrTypeCode2"));
					setData.put("languageID", languageID);
					mLovList = commonService.selectList("attr_SQL.selectAttrLovOption",setData);
					
					attrTypeMap.put("mLovList2", mLovList);				
				}
			}
			
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
			
		return attrList;
	}

	// update SR/SCR ATTR 
	public static void updateSRAttr(HashMap cmmMap, CommonService commonService) throws Exception {
		try {
			Map setData = new HashMap();
			String scrID = StringUtil.checkNull(cmmMap.get("scrID"));
			String srID = StringUtil.checkNull(cmmMap.get("srID"));
			String docCategory = StringUtil.checkNull(cmmMap.get("docCategory"));
			String speCode = StringUtil.checkNull(cmmMap.get("speCode"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			List srAttrList = new ArrayList();
			
			setData.put("srID", srID);
			setData.put("scrID", scrID);
			setData.put("speCode", speCode);
			setData.put("languageID", languageID);
			setData.put("docCategory", docCategory);
			setData.put("srType", StringUtil.checkNull(cmmMap.get("srType")));
			
			setData.put("showInvisible", StringUtil.checkNull(cmmMap.get("showInvisible")));
			srAttrList = commonService.selectList("esm_SQL.getSRAttr", setData);
			
			if(srAttrList.size()>0) {
				for(int i=0; i<srAttrList.size(); i++) {
					Map srAttrMap = (Map) srAttrList.get(i);
					String attrTypeCode = StringUtil.checkNull(srAttrMap.get("AttrTypeCode"));
					String dataType = StringUtil.checkNull(srAttrMap.get("DataType"));
					String html = StringUtil.checkNull(srAttrMap.get("HTML"));
					String value = StringUtil.checkNull(cmmMap.get(attrTypeCode));
					
					setData = new HashMap();
					setData.put("srID", srID);
					setData.put("scrID", scrID);
					setData.put("attrTypeCode", attrTypeCode);
					setData.put("value", value);	
					setData.put("userID", StringUtil.checkNull(cmmMap.get("sessionUserId")));
					
					setData.put("languageID", languageID);
					setData.put("docCategory", docCategory);
					
					commonService.delete("esm_SQL.deleteSRAttr", setData);	
					setData.put("speCode", speCode); // speCode 상관없이 한SR에 공유하는것이므로 speCode 지금put
					if(!value.equals("")) {
						if(dataType.equals("MLOV")){				
							List MLovList = commonService.selectList("esm_SQL.getMLovListWidthSRAttr", setData);
						
							for(int j=0; MLovList.size()> j; j++) {
								Map MLovListMap = (Map)MLovList.get(j);
								String MLovValue = StringUtil.checkNull(cmmMap.get(attrTypeCode+MLovListMap.get("CODE")));
								if(!MLovValue.equals("")) {
									setData.put("value", MLovValue);	
									setData.put("lovCode", MLovValue);
									
									commonService.insert("esm_SQL.insertSRAttr", setData);
								}
							}
						} else if(dataType.equals("MBR")) {
							if(!StringUtil.checkNull(cmmMap.get(attrTypeCode)).equals("")){
								String attrMbr[] = StringUtil.checkNull(cmmMap.get(attrTypeCode)).split(",");
								for(int z=0; z<attrMbr.length; z++) {
									setData.put("value", attrMbr[z]);	
									setData.put("lovCode", attrMbr[z]);	
									
									commonService.insert("esm_SQL.insertSRAttr", setData);
								}
							}
						} else if(dataType.equals("Time")) {
							String timeValue = StringUtil.checkNull(cmmMap.get(attrTypeCode + "_Time"));
							if(!"".equals(value)){
								if(!"".equals(timeValue) ) {
									value = value+" "+timeValue;
								}
								setData.put("value", value);
								commonService.insert("esm_SQL.insertSRAttr", setData);
							}
						}
						 else if(dataType.equals("Date")) {
								if(!"".equals(value)){
									value = changeTimeZoneDateType(value);
									setData.put("value", value);
									commonService.insert("esm_SQL.insertSRAttr", setData);
								}
						} else{	
							if(html.equals("1")){
								value =  StringEscapeUtils.escapeHtml4(value);
							}
							if(dataType.equals("LOV")) setData.put("lovCode", value);	
							
							commonService.insert("esm_SQL.insertSRAttr", setData);
						}
					}
				}
			}
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	// INSERT SR_ATTR_REV
	public static void insertSRAttrRev(Map updateLogMap, CommonService commonService) throws Exception {
		try {
			Map setData = new HashMap();
			String srID = StringUtil.checkNull(updateLogMap.get("srID"));
			String docCategory = StringUtil.checkNull(updateLogMap.get("docCategory"));
			String speCode = StringUtil.checkNull(updateLogMap.get("speCode"));
			String activitySeq = StringUtil.checkNull(updateLogMap.get("activitySeq"));
			String languageID = StringUtil.checkNull(updateLogMap.get("languageID"));
			String userID = StringUtil.checkNull(updateLogMap.get("actorID"));
			String srType = StringUtil.checkNull(updateLogMap.get("srType"));
			String showInvisible = StringUtil.checkNull(updateLogMap.get("showInvisible"));
			
			setData.put("srID", srID);
			setData.put("speCode", speCode);
			setData.put("languageID", languageID);
			setData.put("docCategory", docCategory);
			setData.put("srType", srType);
			setData.put("showInvisible", showInvisible);
			setData.put("activitySeq", activitySeq);
			
			String revTotal = commonService.selectString("esm_SQL.getSRAttrRevCount", setData);
			
			// REV가 없을 경우에만 저장
			if("0".equals(revTotal)){
				List srAttrList = (List)commonService.selectList("esm_SQL.getSRAttrList", setData);
				
				if(srAttrList.size()>0) {
					HashMap insertData = new HashMap();
					for(int h=0; h<srAttrList.size(); h++){
						Map attrListInfo = (Map)srAttrList.get(h);
						String value = StringUtil.checkNull(attrListInfo.get("PlainText"));
						if(!"".equals(value)) {
							insertData.put("activitySeq", activitySeq);
							insertData.put("srID", srID);
							insertData.put("activityLogID", attrListInfo.get("ActivityLogID"));
							insertData.put("attrTypeCode", attrListInfo.get("AttrTypeCode"));
							insertData.put("value", attrListInfo.get("PlainText"));
							insertData.put("lovCode", attrListInfo.get("LovCode"));
							insertData.put("speCode", speCode);
							insertData.put("userID", userID);
							commonService.insert("esm_SQL.insertSRAttrRev", insertData);	
						}
					}
				}
			}
			// SR_ATTR DELETE ( 현재버전 삭제 )
			/*for(int h=0; h<srAttrList.size(); h++){
				commonService.update("esm_SQL.deleteSRAttr", setData);	
			}*/
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}

	public static String getEspProjectID(CommonService commonService, Map map) throws Exception {
		
		String projectID = "";
		
		try {
			map.put("ProjectType", "CSR");
			// sr의 CustomerNo => project 의 ClientID
			projectID = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectIDForESP", map));
			 
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return projectID;
		
	}
	
	public static Map<String, String> setButtonMap(int cnt , String[] value) {
		
		Map<String, String> result = new HashMap();
		try {
			
			// class 추가 
			/*
			String cls = "primary";
			if (cnt % 2 == 0) cls = "secondary";
			result.put("cls",cls);
			*/
			
			// id , name , function 추가
			String[] key = {"cls","id","name","func"};
			
			for (int i = 0; i < value.length; i++) {
                result.put(key[i], value[i]);
            }
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        return result;
    }
	
	public static Map<String, String> getStatusParams(CommonService commonService , Map map) {
		
		Map setData = new HashMap();
		Map<String, String> params = new HashMap();
		try {
			setData.put("identifier", StringUtil.checkNull(map.get("speCode")));
			setData.put("attrTypeCode", "AT00015");
			setData.put("languageID", StringUtil.checkNull(map.get("languageID")));

			String inputValue = StringUtil.checkNull(commonService.selectString("item_SQL.getPlainTextByIdentifier", setData));
			params = getQueryParams(inputValue);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        return params;
    }
	
	public static Map<String, String> getQueryParams(String query) {
        Map<String, String> params = new HashMap<>();
        
        if (query == null || query.isEmpty()) {
            return params;
        }
        
        String[] pairs = query.substring(1).split("&");
        
        for (String pair : pairs) {
            String[] keyValue = pair.split("=");
            if (keyValue.length == 2) {
                String key = keyValue[0];
                String value = keyValue[1];
                params.put(key, value);
            }
        }
        
        return params;
    }
	
	// SR MAIL
	public static void sendSRMail(HttpServletRequest request, CommonService commonService, Map map) throws Exception  {
       
		Map setData = new HashMap();
		Map setMap = new HashMap();
		
		try {
			
			// [00]  기본정보 setting
			String emailCode = StringUtil.checkNull(map.get("emailCode"));
			String srID = StringUtil.checkNull(map.get("srID"));
			String languageID = StringUtil.checkNull(map.get("languageID"));
			String emailLangID = StringUtil.checkNull(map.get("emailLangID"));
			
			if(!"".equals(emailLangID)) languageID = emailLangID;
			
			// [03] 메일 수신자 정보
			map.put("type","EMAIL");
			map.put("languageID", languageID);
			
			List receiverList = commonService.selectList("esm_SQL.getSREmailReceiverList", map);
			
			System.out.println("=======================TVL cc send mail start================================================");
			// 영원 방글라데시 참조메일 수신자 조회 메소드 
			appendCommonCcReceivers(commonService, map, receiverList, emailCode);
			System.out.println("=======================TVL cc send mail end================================================");
			
			// [03] push 수신자 정보
			map.put("type","PUSH");
			List pushReceiverList = commonService.selectList("esm_SQL.getSREmailReceiverList", map);
			
			
			// [04] 메일수신자 or push수신자 존재 시 실행
			if(receiverList.size()> 0 || pushReceiverList.size()> 0){
				
				String procRoleTP = StringUtil.checkNull(map.get("procRoleTP")); // 다음단계
				String srType = StringUtil.checkNull(map.get("srType"));
				String mailSubject = StringUtil.checkNull(map.get("mailSubject")); // mail 제목
				
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				HashMap cntsMap =  (HashMap) commonService.select("esm_SQL.getESMSRInfo", setMap);	
				String status = StringUtil.checkNull(cntsMap.get("SRStatusName"));
				String subject = StringUtil.checkNull(cntsMap.get("Subject")); // sr 제목
				String clientID = StringUtil.checkNull(map.get("clientID"),StringUtil.checkNull(cntsMap.get("ClientID")));
				String srCode = StringUtil.checkNull(cntsMap.get("SRCode"));
				subject = "(" + status + ")" + subject;
				
				// [01] 메일 타입 정보
				Map setMailData = new HashMap();
				setMailData.put("EMAILCODE", emailCode);
				setMailData.put("subject", subject);
				setMailData.put("receiverList", receiverList);
				setMailData.put("srCode", srCode);
				
				// [04] 메일 로그
				if(receiverList.size() > 0){
					Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, emailCode);
					
					if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
						
						// [05] mail 송,수신자 정보 
						HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
						
						String baseUrl = GlobalVal.EMAIL_TYPE;
						
						if("MULTISMTP".equals(baseUrl)){
							
							String sender = GlobalVal.EMAIL_SENDER;
							String senderName = GlobalVal.EMAIL_SENDER_NAME;
							String EmailSvrDomain = GlobalVal.EMAIL_HOST_IP;
							String senderPwd = GlobalVal.SMTP_ACCOUNT_PWD;
							
							setMap.put("customerNo", clientID);
							Map mailInfoMap = (HashMap)commonService.select("crm_SQL.getCustMailInfo", setMap);
							
							sender = StringUtil.checkNull(mailInfoMap.get("SenderAcc"), GlobalVal.EMAIL_SENDER);
							senderName = StringUtil.checkNull(mailInfoMap.get("SenderName"), GlobalVal.EMAIL_SENDER_NAME);
							EmailSvrDomain = StringUtil.checkNull(mailInfoMap.get("EmailSvrDomain"), GlobalVal.EMAIL_HOST_IP);
							senderPwd = StringUtil.checkNull(mailInfoMap.get("SenderPwd"), GlobalVal.SMTP_ACCOUNT_PWD);
							
							if("REG".equals(sender)){
								senderName = StringUtil.checkNull(cntsMap.get("ReqUserNM"));
								setMap.put("userID", StringUtil.checkNull(cntsMap.get("RequestUserID")));
								sender =  StringUtil.checkNull(commonService.selectString("user_SQL.userEmail", setMap),GlobalVal.EMAIL_SENDER);	
							}
							
							mailMap.put("Sender",sender);
							mailMap.put("SenderName",senderName);
							mailMap.put("SenderPwd",senderPwd);
							mailMap.put("EmailSvrDomain",EmailSvrDomain);
							
							if(!"".equals(senderPwd)){
								mailMap.put("smtpAuthentification","Y");
							}
							
						}
						
						// [06] 메일안에 들어갈 내용 정보
						cntsMap.put("emailCode", emailCode);
						cntsMap.put("languageID", languageID);
						String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", cntsMap));
						cntsMap.put("emailHTMLForm", emailHTMLForm);
						
						// 요청자 parentOrgPath
						Map tempMap = new HashMap();
						String RequestTeamID = StringUtil.checkNull(cntsMap.get("RequestTeamID"));
						if(!"".equals(RequestTeamID)){
							tempMap.put("s_itemID", RequestTeamID);
							tempMap.put("languageID", languageID);
							Map reqUserMap = commonService.select("organization_SQL.getOrganizationInfo", tempMap);
							String ParentOrgPath = StringUtil.checkNull(reqUserMap.get("ParentOrgPath"));
							cntsMap.put("ParentOrgPath", ParentOrgPath);
						}
						// 다음 단계 그룹
						HashMap procMap = new HashMap();
						procMap.put("Category", "SRROLETP");
						procMap.put("TypeCode", procRoleTP);
						procMap.put("LanguageID", languageID);
						Map procRoleMap = (HashMap)commonService.select("common_SQL.label_commonSelect", procMap);
						String procRoleTPName = StringUtil.checkNull(procRoleMap.get("LABEL_NM"));
						cntsMap.put("procRoleTPName", procRoleTPName);
						
						// ZLN0198 : AssignmentRequired 할당필요 문구 추가 
						procMap.put("Category", "LN");
						procMap.put("TypeCode", "ZLN0198");
						procMap.put("LanguageID", languageID);
						Map dicMap = (HashMap)commonService.select("common_SQL.label_commonSelect", procMap);
						String AssignmentRequired = StringUtil.checkNull(dicMap.get("LABEL_NM"));
						cntsMap.put("AssignmentRequired", AssignmentRequired);
						
						// 영원무역 ONLY url
						if(receiverList.size() == 1) {
							// 수신자가 한명일 경우에만 Link 생성
							Map receiptUserMap = (Map)receiverList.get(0);
							Map<String, String> receiptUser = (HashMap)commonService.select("custom_SQL.zYOH_getReceiptUserEmailInfo", receiptUserMap);
							// 사번 , teamCode, companyCode base64 인코딩
							StringBuilder result = new StringBuilder();
							for (Map.Entry<String, String> entry : receiptUser.entrySet()) {
					            String key = entry.getKey();
					            String value = entry.getValue();

					            if (value != null) {
					                String encodedValue = Base64.getEncoder().encodeToString(value.getBytes());
					                result.append(key).append("=").append(encodedValue).append("&");
					            }
					        }
					        if (result.length() > 0) result.setLength(result.length() - 1);
					        String linkParameter = result.toString();
					        linkParameter += "&esType=ITSP&srID=" + srID + "&srType=" + srType;
					        cntsMap.put("linkParameter", linkParameter);
						}
						
						cntsMap.put("languageID", StringUtil.checkNull(map.get("languageID")));
						String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
						cntsMap.put("loginID", requestLoginID);
						
						// [07] 메일 보내기
						Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
						
					}else{
						System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
					}
				}
				
				// [08] push -- othersysproperties 에서 push 설정있을때만 실행 [TODO]
				if(pushReceiverList.size() > 0){
										
					for(int i=0; i < pushReceiverList.size(); i++){
						Map pushMap = (Map) pushReceiverList.get(i);
						HashMap tmpMap = new HashMap();
						
						if(!"".equals(StringUtil.checkNull(pushMap.get("receiptUserLoginID")))){
							tmpMap.put("RecvEmpNo",StringUtil.checkNull(pushMap.get("receiptUserLoginID"))); // LoginID
							tmpMap.put("RecvInfo",StringUtil.checkNull(pushMap.get("receiptTelNum"))); // Tel
							tmpMap.put("RecvEmpName",StringUtil.checkNull(pushMap.get("receiptUserName"))); // Name
							tmpMap.put("RecvDeptName",StringUtil.checkNull(pushMap.get("receiptTeamName"))); // Dept Name
							tmpMap.put("CompanyCode",StringUtil.checkNull(pushMap.get("receiptTeamCode"))); // Company Code
							tmpMap.put("EmailCode", emailCode);
							tmpMap.put("srCode", srCode);
							tmpMap.put("subject", subject);
							
							DLMCmmActionController.zdlm_sendPush(tmpMap, commonService);
						}
					}
					
				}
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
	
	// 참조 수신자 조회후  receiverList 에 추가 
	private static void appendCommonCcReceivers(CommonService commonService, Map map, List receiverList, String emailCode) throws Exception {
		List ccReceiverList = getCommonCcReceiverList(commonService, map, emailCode);

		if(ccReceiverList.size() > 0) {
			for(int i=0; i<ccReceiverList.size(); i++) {
				Map ccReceiverMap = new HashMap((Map) ccReceiverList.get(i));
				ccReceiverMap.put("receiptType", "CC");

				String ccReceiptUserID = StringUtil.checkNull(ccReceiverMap.get("receiptUserID"));
				boolean isExists = false;

				for(int j=0; j<receiverList.size(); j++) {
					Map receiverMap = (Map) receiverList.get(j);
					if(ccReceiptUserID.equals(StringUtil.checkNull(receiverMap.get("receiptUserID")))) {
						isExists = true;
						break;
					}
				}

				if(!isExists) {
					receiverList.add(ccReceiverMap);
				}
			}
		}

		System.out.println(" appendCommonCcReceivers ccReceiverList +   receiverList :"+receiverList);
	}

	// 조건에 따른 참조 수신자 조회 (영원무역(YO) && 방글라데시(0000000064) 일경우 사용
	private static List getCommonCcReceiverList(CommonService commonService, Map map, String emailCode) throws Exception {
		/* [영원 무역]Email CC 수신자 로직 추가
		 * 서비스요청 방글라데시 일경우만
		 */
		map.put("refPGID", "4,11,12"); // Bangladesh-CEPZ,Bangladesh-DEPZ,Bangladesh-KEPZ 를 workspace (refPGID) 로 갖고 있는 CSR의 clientID 조회 
		String workSpaceClientCount = StringUtil.checkNull(commonService.selectString("esm_SQL.getWorkspaceClientCount", map)); // 방글라데시 workSpace 에 해당하는 csr의 client count 
		int workSpaceClientCountInt = Integer.parseInt(StringUtil.checkNull(workSpaceClientCount, "0"));
		String speCode = StringUtil.checkNull(map.get("speCode"));
		String activityStatus = StringUtil.checkNull(map.get("activityStatus"));
		String approvalSystem = GlobalVal.DEF_APPROVAL_SYSTEM;

		if(workSpaceClientCountInt < 1 || !"YO".equals(approvalSystem)) { // 영원ITSM이면서, 방글라데시가 아니면 끝내기
			return new ArrayList();
		}

		System.out.println("in 0000000064-clientID :"+workSpaceClientCount+", DEF_APPROVAL_SYSTEM:"+approvalSystem+",speCode:"+speCode);

		if("REQ2009".equals(speCode) && "ESPMAIL007".equals(emailCode)) {
			List ccReceiverList = selectActivityActorList(commonService, map, "REQ3009", "REQ", "05");
			System.out.println("500076 전자결재 반려 서비스요청 이관검토 담당자 ESPMAIL007 ccReceiverList :" + ccReceiverList);
			return ccReceiverList;
		}

		if("REQ2009".equals(speCode) && "06".equals(activityStatus)) {
			List ccReceiverList = selectActivityActorList(commonService, map, "REQ3009", "REQ", "05");
			System.out.println("500076 서비스요청접수(2선) 기각(06) -> 서비스이관검토 담당자 ccReceiverList :" + ccReceiverList);
			return ccReceiverList;
		}

		if("REQ2012".equals(speCode) && "06".equals(activityStatus)) {
			List ccReceiverList = selectActivityActorList(commonService, map, "REQ1012", "REQ", "05");
			System.out.println("500075 서비스요청접수(2선) 기각(06) -> 서비스요청접수(1선) 담당자 ccReceiverList :" + ccReceiverList);
			return ccReceiverList;
		}

		if("REQ2004".equals(speCode) && "05".equals(activityStatus)) {
			List ccReceiverList = selectActivityActorList(commonService, map, "REQ1012", "REQ", "05");
			System.out.println("500075 서비스처리(2선) REQ2004 -> 서비스요청접수(1선) REQ1012 담당자 ccReceiverList :" + ccReceiverList);

			List transferReceiverList = selectActivityActorList(commonService, map, "REQ3009", "REQ", "05");
			System.out.println("500076 서비스처리(2선) REQ2004 -> 서비스이관검토 REQ3009 담당자 ccReceiverList :" + transferReceiverList);
			ccReceiverList.addAll(transferReceiverList);
			return ccReceiverList;
		}

		return new ArrayList();
	}
    
	// ESM_ACTIVITY_LOG.ACTOR 조회 (speCode,srType,status)
	private static List selectActivityActorList(CommonService commonService, Map map, String speCode, String srType, String status) throws Exception {
		Map queryMap = new HashMap(map);
		queryMap.put("speCode", speCode);
		queryMap.put("srType", srType);
		queryMap.put("status", status);
		return commonService.selectList("esm_SQL.getActivityActorID", queryMap);
	}

	public static String getCurrentLocalDate(String format) {
		String defaultZone = "Asia/Seoul";
		String serverZone = StringUtil.checkNull(TimezoneGlobalVal.SERVER_TIMEZONE, defaultZone);
		String userTimezone = TimezoneThreadLocal.get();
		
		ZoneId zoneId;
		
		try {
		    if (userTimezone != null && !userTimezone.trim().isEmpty()) {
		        zoneId = ZoneId.of(userTimezone);
		    } else {
		        zoneId = ZoneId.of(serverZone);
		    }
		} catch (Exception e) {
		    zoneId = ZoneId.of(defaultZone);
		}
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern(format);
		ZonedDateTime now = ZonedDateTime.now(zoneId);
        
		if("HH:mm:ss.SSS".equals(format)) {
			return now.toLocalTime().format(formatter);
        } else {
        	return now.format(formatter);
        }
		
	}
	 
	 private static final Pattern DATE_ONLY_PATTERN = Pattern.compile("^\\d{4}-\\d{2}-\\d{2}$");
	 
	 public static String changeTimeZoneDateType(String value) {

		 //YYYY-MM-DD 형식만 TimeZone을 위해, UserTime으로 시간을 붙여준다. 
		 String newDate = value;
		 
		 boolean rs = DATE_ONLY_PATTERN.matcher(value).matches();
		 if(rs) {
			String currentTime = getCurrentLocalDate("HH:mm:ss.SSS");
			newDate = newDate +" "+currentTime;
		 }
		 
		 return newDate;
	 }
	 
	 public static Map changeNewSpeCode(
			 Map map, CommonService commonService, HttpServletRequest request, 
			 String speCode, String srID, String sessionUserID) throws Exception {
		 
		 
		String languageID = StringUtil.checkNull(map.get("languageID"));
		String clientID = StringUtil.checkNull(map.get("ClientID"));
		
		// 01. 현재 srArea와 담당그룹 체크 후 현재 담당자에게 권한이 없을 경우 담당자 삭제
		map.put("status", speCode);

		// procRoleTP 예외 체크
		String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPProcRoleTP",map)); // next procRoleTP 예외처리 체크
		if("".equals(procRoleTP)){
			procRoleTP = StringUtil.checkNull(map.get("procRoleTP"));
		}
		
		String srArea2 = StringUtil.checkNull(map.get("srArea2"));
    	String srArea1 = StringUtil.checkNull(map.get("srArea1"));
    	String srArea = ("".equals(srArea2) || "undefined".equals(srArea2) || "0".equals(srArea2)) ? srArea1 : srArea2;
    	
    	Map cngMap = new HashMap();
    	cngMap.put("srArea",StringUtil.checkNull(srArea));
    	cngMap.put("languageID",StringUtil.checkNull(map.get("languageID")));
    	cngMap.put("RoleType",procRoleTP);
    	cngMap.put("clientID",clientID);
		List RoleTPList = commonService.selectList("esm_SQL.getReceiptUserList", cngMap);
		String checkOutYN = "N";
		
    	// 단계 진행 시 다음 그룹에 인원이 할당되어있는지 체크
		if(RoleTPList.size()>0){
			for(int i=0; i<RoleTPList.size(); i++){
				Map RoleMap = (Map)RoleTPList.get(i);
				String RoleTPID = StringUtil.checkNull(RoleMap.get("CODE"));
				if(RoleTPID.equals(sessionUserID))checkOutYN = "Y";
			}
		}
		
		if("N".equals(checkOutYN)) {
			// 티켓 담당자 삭제
			cngMap.put("SRID", srID);
			cngMap.put("lastUser", sessionUserID);
			commonService.update("esm_SQL.deleteReceiptUser", map); // lastUser , srID
			map.remove("receiptUserID");
			map.remove("receiptTeamID");
	     	
			// 로그 담당자 삭제
			cngMap.put("PID", srID);
			cngMap.put("speCode", speCode);
			cngMap.put("maxSeq","Y");
			cngMap.put("docCategory","SR");
			commonService.update("esm_SQL.deleteActorInLog", cngMap);
			
			// 로그 상태 변경 ( 접수 전 )
			cngMap.put("srID", srID);
			cngMap.put("activityStatus", "00");
			Map setActivityLogMapRst2 = (Map)ESPUtil.updateActivityLog(request, commonService, cngMap);
			
			// 실적 삭제 ( 해당 담당자 실적만 )
			cngMap.put("LanguageID", StringUtil.checkNull(map.get("languageID")));
			cngMap.put("memberID", sessionUserID);
			cngMap.put("assignmentType", "SRROLETP");
			cngMap.put("assignmentType", "SRROLETP");
			cngMap.put("roleType",procRoleTP);
	     	
	        List<HashMap> mbrList2 = commonService.selectList("esm_SQL.selectMbrRcd_gridList", cngMap);
	     	commonService.delete("esm_SQL.deleteSRMbr", cngMap);
	     	
	     	for (HashMap deleteMap : mbrList2) {
	     		// 삭제할 mbrRcdId를 기준으로 삭제 
	     		String mbrRcdID = StringUtil.checkNull(deleteMap.get("MbrRcdID"));
	     		if(!"".equals(mbrRcdID)) {
	     			deleteMap.put("mbrRcdID", mbrRcdID);
		        		commonService.delete("esm_SQL.deleteMbrRcd", deleteMap);
	     		}
	     	}
	     	
	     	// attr 삭제
	     	cngMap.put("srID", srID);
	     	commonService.update("esm_SQL.deleteSRAttrAll", cngMap);
		}
		 
		 // 02. 카테고리 변경인 경우 procPath 재설정
		 String subCategory = StringUtil.checkNull(map.get("subCategory"));
		 String category = StringUtil.checkNull(map.get("category"));
		
		 if(!"".equals(subCategory))map.put("srCatID", subCategory);
		 else map.put("srCatID", category);
			
		 Map RoleAssignMap =  commonService.select("esm_SQL.getESPSRAreaFromSrCat", map);
		 String procPathID = StringUtil.checkNull(RoleAssignMap.get("ProcPathID"));
		 map.put("procPathID", procPathID);
		 
		 Map categoryMap = new HashMap();
		 categoryMap.put("status", speCode);
		 categoryMap.put("srID", srID);
		 categoryMap.put("procPathID", procPathID);
			
		 // speCode 변경 확인
		 String sortNum = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPStatusSortNum", categoryMap));
		 categoryMap.put("sortNum", sortNum);
		 String newSpeCode = StringUtil.checkNull(commonService.selectString("esm_SQL.GetProcPathEventCodeBySortNum", categoryMap));
		
		 if(!newSpeCode.equals(speCode) && !"".equals(newSpeCode) && !"".equals(speCode)){
			
			// 티켓 status 변경
			map.put("status",newSpeCode);
			
			// 담당그룹 변경
			categoryMap.put("speCode", newSpeCode);
			categoryMap.put("languageID",StringUtil.checkNull(map.get("languageID")));
			Map param = getStatusParams(commonService, categoryMap);
			procRoleTP = StringUtil.checkNull(param.get("procRoleTP"));
			map.put("procRoleTP",procRoleTP);
			
			// update log
			categoryMap.put("newSpeCode", newSpeCode);
			categoryMap.put("speCode", speCode);
			categoryMap.put("maxSeq", "Y");
			categoryMap.put("PID", srID);
			Map setActivityLogMapRst = new HashMap();
			setActivityLogMapRst = (Map)updateActivityLog(request, commonService, categoryMap);
			
			// update mbr
			Map mbrMap = new HashMap();
			mbrMap.put("SRID", srID);
			mbrMap.put("LanguageID", StringUtil.checkNull(map.get("languageID")));
			mbrMap.put("speCode", speCode);
			
	        List<HashMap> mbrList = commonService.selectList("esm_SQL.selectMbrRcd_gridList", mbrMap);
	        
	        // 실적 존재 할 경우 운영실적 업데이트
	        if(mbrList.size() > 0){
	        	
	        	for (HashMap updateMap : mbrList) {
	        		// 새로운 status로 업데이트
	        		String getMbrRcdID = StringUtil.checkNull(updateMap.get("MbrRcdID"));
	        		if(!"".equals(getMbrRcdID)) {
	        			updateMap.put("getMbrRcdID", getMbrRcdID);
	        			updateMap.put("speCode", newSpeCode);
		        		commonService.delete("esm_SQL.updateMbrRcd", updateMap);
	        		}
	        	}
	        }
		 }
	 
		 return map;
	 }
	
}
