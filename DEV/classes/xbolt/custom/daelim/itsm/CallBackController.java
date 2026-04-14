package xbolt.custom.daelim.itsm;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import net.sf.json.JSONException;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

/**
 * 
 * @Class Name : CCActionController.java
 * @Description : Daelim Call Center Action Controller
 * @since 2024. 12. 31.
 * @version 1.0
 * @see shkim
 */

@Controller
@SuppressWarnings("unchecked")
public class CallBackController extends XboltController {
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;

	// TODO 운영 반영 시 주석해제
	/*
	@Resource(name = "xsqlSession")
	private SqlSession xsqlSession;	
	*/
	
	private final DataSource dataSource;

	@Autowired
	public CallBackController(@Qualifier("xboltDataSource") DataSource dataSource) { 
		this.dataSource = dataSource;
	}

	@RequestMapping(value = "/callBackPop.do")
	public String callBackPop(HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model)
			throws Exception {
		String url = "/custom/daelim/itsm/cc/callBackPop";
		String crudMode = StringUtil.checkNull(cmmMap.get("crudMode"));
		String callbackResult = StringUtil.checkNull(cmmMap.get("callbackResult"));
		String CallBackKey = String.valueOf(request.getParameter("CallBackKey"));
		String AgentID = StringUtil.checkNull(cmmMap.get("AgentID")); // 내선번호
		String sessionLoginID = StringUtil.checkNull(request.getParameter("sessionLoginId"));
		String reqSeq = null;
		String makeSeq = null;
		String cbStartTime  = StringUtil.checkNull(request.getParameter("cbStartTime"));
		
		System.out.println("cbStartTime ::" + cbStartTime);
	
		try {
			Map setMap = new HashMap();

			String memo = StringUtil.checkNull(cmmMap.get("memo"));
		

			setMap.put("CallBackKey", CallBackKey);
			setMap.put("CallRet", callbackResult);
			setMap.put("Memo", memo);
			setMap.put("AgentID", AgentID);
			setMap.put("Creator", sessionLoginID);
			setMap.put("LastUser", sessionLoginID);
			setMap.put("CreationTime", cbStartTime);
			

			// 콜백등록
			if (crudMode.equals("C")) {

				commonService.insert("callback_SQL.insertCallbackDtl", setMap);

				Map<String, Object> maxSeqMap = (Map<String, Object>) commonService.select("callback_SQL.getCallbacklistSeq", setMap);
				makeSeq = maxSeqMap.get("makeSeq") != null ? maxSeqMap.get("makeSeq").toString() : null;

				setMap.put("reqSeq", makeSeq);

				// 통화실패 일때
				if (callbackResult.equals("02")) {

					setMap.put("CallYn", 'N');

					commonService.insert("callback_SQL.updateCallbackDtl", setMap);
				} else {

					setMap.put("CallYn", "Y");

					commonService.insert("callback_SQL.updateCallbackDtl", setMap);
					commonService.update("callback_SQL.updateCallbackMst_suc", setMap);

					// cti장비 ( 운영 반영 시 주석 해제 )
					// xsqlSession.update("daelim_SQL.updateCtiCallback_User", setMap);
				}

				  
			}
			// 담당자 변경
			else if (crudMode.equals("U")) {

				String NewAgentID = StringUtil.checkNull(cmmMap.get("NewAgentID"));
				String NewAgentName = StringUtil.checkNull(cmmMap.get("NewAgentName"));

				setMap.put("NewAgentID", NewAgentID);
				setMap.put("NewAgentName", NewAgentName);
				
				commonService.update("callback_SQL.updateCallbackMst_User", setMap);

				//cti장비 ( 운영 반영 시 주석 해제 )
				// int result = xsqlSession.update("daelim_SQL.updateCtiCallback_AgentID", setMap);

			}


			Map callbackDtl = commonService.select("callback_SQL.selectCallbackDtl", setMap);

			String reqSeqParam = StringUtil.checkNull(request.getParameter("reqSeq")); // reqSeq 파라미터 값 확인
	
			if (reqSeqParam != null && !reqSeqParam.isEmpty()) {
			      reqSeq = reqSeqParam; // reqSeq 값이 존재하면 해당 값 사용
			} else {
			      reqSeq = makeSeq; // reqSeq 값이 없으면 makeSeq 값 사용
			}
			
			model.put("callbackDtl", callbackDtl);
			model.put("reqSeq", reqSeq); 
			model.put("crudMode", crudMode);
			model.put("CallBackKey",CallBackKey);
			model.put("AgentID",AgentID); 
			model.put("status", StringUtil.checkNull(cmmMap.get("status")));
			model.put("isPopup", StringUtil.checkNull(request.getParameter("isPopup")));
			 
		        
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	public static void sendToJson(String jObj, HttpServletResponse res) {
		try {
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if (!jObj.equals("{data: [ ]}")) {
				res.getWriter().print(jObj);
			} else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/callbackGetList.do")
	public void callbackGetList(HashMap cmmMap, HttpServletResponse response) throws Exception {
		Map setMap = new HashMap();
		Map userMap = new HashMap();

		try {
			String SQL_CODE = getString(cmmMap.get("sqlID"), "commonCode");

			String tFilterCode = StringUtil.checkNull(cmmMap.get("tFilterCode"));
			String sqlGridList = StringUtil.checkNull(cmmMap.get("sqlGridList"));

			if (!"".equals(tFilterCode)) {
				SQL_CODE = StringUtil
						.checkNull(commonService.selectString("menu_SQL.getSqlNameForTfilterCode", cmmMap));
			}

			String sessionLoginId = getString(cmmMap.get("sessionLoginId"), "sessionLoginId");
			userMap.put("CC_USR_EMP_NO", sessionLoginId);

			// 로그인한 사용자의 내선번호 가져오기
			List<HashMap<String, Object>> userResultList = (List<HashMap<String, Object>>) commonService
					.selectList("callback_SQL.getCallbackUserlist", userMap);
			HashMap<String, Object> userResult = userResultList.get(0);
			String AgentID = userResult.get("CODE") != null ? userResult.get("CODE").toString() : "";
			setMap.put("AgentID", AgentID);

			// CTI쪽 CALLBACK 테이블의 로그인 사용자 데이터 가져오기 ( 운영 반영 시 주석 해제 )
			// List<Map> callCenterResult = xsqlSession.selectList("daelim_SQL.getCallCenter_List", setMap);

			// CTI CALLBACK TBL -> CTI_TO_E_CALLBACK TBL에 INSERT
			try (Connection conn = dataSource.getConnection()) {
				conn.setAutoCommit(false);
				
				 //( 운영 반영 시 주석 해제 )
				// insertCallBackData(conn, callCenterResult);
				conn.commit(); // 커밋

			} catch (Exception e) {
				e.printStackTrace();
			}

			// CTI_TO_E_CALLBACK TBL 데이터 eClick MST/DTL TBL에 넣기
			commonService.insert("callback_SQL.insertCALLBACK_MST", setMap);
			commonService.insert("callback_SQL.insertCALLBACK_DTL", setMap);

			String sqlCode = "";
			if (sqlGridList.equals("N"))
				sqlCode = SQL_CODE;
			else
				sqlCode = SQL_CODE + SQL_GRID_LIST;

			cmmMap.put("AgentID", AgentID);

			List<Map> result = commonService.selectList(sqlCode, cmmMap);

			JSONArray resultJosnList = new JSONArray(result);
			
			// 변환 오류 발생 시 빈 JSON 배열로 처리
		    if (result == null) {
			   resultJosnList = new JSONArray();
	        } else {
	            try {
	            	resultJosnList = new JSONArray(result);
	            } catch (JSONException e) {
	            	resultJosnList = new JSONArray(); 
	            }
	        }
		   
			sendToJsonV7(StringUtil.checkNull(resultJosnList), response);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}

	public static void sendToJsonV7(String jObj, HttpServletResponse res) {
		try {
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if (!jObj.equals("{rows: [ ]}")) {
				res.getWriter().print(jObj);
			} else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}

	// CTI쪽 TBL 데이터 가져와서 eClick CTI_TO_E_CALLBACK TBL 넣는 함수
	public void insertCallBackData(Connection conn, List<Map> callCenterResult) throws Exception {
		String mergeSQL = "MERGE INTO XBOLTDLM.CTI_TO_E_CALLBACK AS target "
				+ "USING (VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)) AS source "
				+ "(CallBackKey, RegDate, RegTime, RegWeek, TelNum, CustInfo, AgentID, "
				+ "CallDate, CallTime, CallRet, Memo, ReqGrp, VoiceMsg, AgentName, "
				+ "CID, ServiceID, Del_YN, VoiceFile, VoiceSec, S_Sec, E_Sec) "
				+ "ON target.CallBackKey = source.CallBackKey " + "WHEN NOT MATCHED THEN "
				+ "INSERT (CallBackKey, RegDate, RegTime, RegWeek, TelNum, CustInfo, AgentID, "
				+ "CallDate, CallTime, CallRet, Memo, ReqGrp, VoiceMsg, AgentName, "
				+ "CID, ServiceID, Del_YN, VoiceFile, VoiceSec, S_Sec, E_Sec) "
				+ "VALUES (source.CallBackKey, source.RegDate, source.RegTime, source.RegWeek, source.TelNum, source.CustInfo, "
				+ "source.AgentID, source.CallDate, source.CallTime, source.CallRet, source.Memo, source.ReqGrp, "
				+ "source.VoiceMsg, source.AgentName, source.CID, source.ServiceID, source.Del_YN, "
				+ "source.VoiceFile, source.VoiceSec, source.S_Sec, source.E_Sec);";

		System.out.println("mergeSQL:" + mergeSQL);

		try (PreparedStatement pstmt = conn.prepareStatement(mergeSQL)) {
			for (Map<String, Object> row : callCenterResult) {
				pstmt.setString(1, Optional.ofNullable((String) row.get("CallBackKey")).orElse(""));
				pstmt.setString(2, Optional.ofNullable((String) row.get("RegDate")).orElse(""));
				pstmt.setString(3, Optional.ofNullable((String) row.get("RegTime")).orElse(""));
				pstmt.setString(4, Optional.ofNullable(row.get("RegWeek")).map(String::valueOf).orElse("0"));
				pstmt.setString(5, Optional.ofNullable((String) row.get("TelNum")).orElse(""));
				pstmt.setString(6, Optional.ofNullable((String) row.get("CustInfo")).orElse(""));
				pstmt.setString(7, Optional.ofNullable((String) row.get("AgentID")).orElse(""));
				pstmt.setString(8, Optional.ofNullable((String) row.get("CallDate")).orElse(""));
				pstmt.setString(9, Optional.ofNullable((String) row.get("CallTime")).orElse(""));
				pstmt.setString(10, Optional.ofNullable((String) row.get("CallRet")).orElse(""));
				pstmt.setString(11, Optional.ofNullable((String) row.get("Memo")).orElse(""));
				pstmt.setString(12, Optional.ofNullable((String) row.get("ReqGrp")).orElse(""));
				pstmt.setString(13, Optional.ofNullable(row.get("VoiceMsg")).map(String::valueOf).orElse("0"));
				pstmt.setString(14, Optional.ofNullable((String) row.get("AgentName")).orElse(""));
				pstmt.setString(15, Optional.ofNullable((String) row.get("CID")).orElse(""));
				pstmt.setString(16, Optional.ofNullable((String) row.get("ServiceID")).orElse(""));
				pstmt.setString(17, Optional.ofNullable((String) row.get("Del_YN")).orElse("N"));
				pstmt.setString(18, Optional.ofNullable((String) row.get("VoiceFile")).orElse(""));
				pstmt.setInt(19, Optional.ofNullable((Integer) row.get("VoiceSec")).orElse(0));
				pstmt.setInt(20, Optional.ofNullable((Integer) row.get("S_Sec")).orElse(0));
				pstmt.setInt(21, Optional.ofNullable((Integer) row.get("E_Sec")).orElse(0));

				pstmt.addBatch(); // 배치 처리
			}
			pstmt.executeBatch(); // 한 번에 실행
		}
	}

}
