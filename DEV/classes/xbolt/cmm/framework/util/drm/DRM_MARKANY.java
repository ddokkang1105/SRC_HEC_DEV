package xbolt.cmm.framework.util.drm;

import com.markany.nt.WDSCryptAll;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;

@SuppressWarnings("unused")
public class DRM_MARKANY {
	public static String report(HashMap drmInfoMap) throws ExceptionUtil {
		String returnValue = "";
		
		WDSCryptAll m_enc_dec = null;
		m_enc_dec = new WDSCryptAll();

		Calendar cal = Calendar.getInstance();
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
		java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
		String sdate = sdf.format(cal.getTime());
		String stime = sdf2.format(cal.getTime());
		String fileExt = FileUtil.getExt(StringUtil.checkNull(drmInfoMap.get("Filename")));
		String pstrFileId = new String( sdate+stime );
		
		
		String filePath = StringUtil.checkNull(drmInfoMap.get("filePath"),"");
		if(filePath.equals("")){
			filePath = FileUtil.FILE_EXPORT_DIR;
		}

		m_enc_dec.iUnicodeType = 1;	
		m_enc_dec.sSourceFilePath = StringUtil.checkNull(drmInfoMap.get("downFile"));		// [필수] 암호화 대상 파일
		m_enc_dec.sDestFilePath = filePath + StringUtil.checkNull(drmInfoMap.get("orgFileName"));			// [선택] 암호화 후 파일
		m_enc_dec.sUserId = StringUtil.checkNull(drmInfoMap.get("userID"));								// [필수] 사용자 아이디 또는 사번
		m_enc_dec.sEnterpriseId = "DAESANGG-582C-AC53-7258";		// [필수] 그룹아이디
		m_enc_dec.sEnterpriseName = "대상";					// [선택] 그룹명
		m_enc_dec.sCompanyId = "DAESANG-AD74-D7C8-A3A1|DSLS-AD74-D7C8-A3A1";			// [필수] 회사아이디
		m_enc_dec.sCompanyName = "대상";					// [선택] 회사명
		m_enc_dec.sDocId = pstrFileId;				// [필수] 파일별 Unique해야함 (로그 분석 시 사용되는 키값)
		m_enc_dec.sDocTitle = "DRM Doc Title";						// [선택] 문서 타이틀
		m_enc_dec.sServerOrigin = "OLM";							// [필수] 서버명 또는 시스템 약어
		m_enc_dec.sEncryptedBy = "0";								// [필수] 암호화 파일 속성 (0:서버 암호화, 1:자동 암호화, 2:암호화 툴 사용)
		m_enc_dec.sFileName = StringUtil.checkNull(drmInfoMap.get("orgFileName"));		// [필수] 파일명칭 (암호화 헤더에 들어가는 파일명)
		
		// [ACL 설정]
		m_enc_dec.sDocExchangePolicy = "1";							// [필수] 문서 교환 정책 (0:개인한, 1:사내한, 2:부서한)
		m_enc_dec.iDocOpenCount = -99;								// [필수] 오픈 횟수 (0~999 입력, -99 : 무제한)
		m_enc_dec.iDocPrintCount = -99;								// [필수] 인쇄 횟수 (0~999 입력, -99 : 무제한)
		m_enc_dec.iCanSave = 1;										// [필수] 저장 가능 여부 (0:저장 불가능, 1:저장 가능)
		m_enc_dec.iCanEdit = 1;										// [필수] 편집 가능 여부 (0:편집 불가능, 1:편집 가능)
		m_enc_dec.iClipboardOption = 0;								// [필수] 암호화 문서의 클립보드 제어(0:클립보드 제어, 1:제어하지 않음)
		m_enc_dec.iVisiblePrint = 1;								// [필수] 워터마크 적용 여부 (0:적용 안함, 1:적용함)
		m_enc_dec.iImageSafer = 0;									// [필수] 화면캡쳐 방지 여부 (1:방지, 0:허용 or 방지하지않음)
		m_enc_dec.sDocValidPeriod = "-99";							// [필수] sValidPeriodType 값이 1이면 숫자형식, 값이 2이면 yyyymmddhhmmss
		m_enc_dec.iDocOpenLog = 1;									// [필수] 오픈 시 로그 전송 (1:전송, 0:미전송)
		m_enc_dec.iDocSaveLog = 1;									// [필수] 저장 시 로그 전송 (1:전송, 0:미전송)
		m_enc_dec.iDocPrintLog = 1;									// [필수] 인쇄 시 로그 전송 (1:전송, 0:미전송)

		m_enc_dec.sServerInfo_Log = "drm.donghee.co.kr:40002";		// [필수] 로그 전송 url:port
		m_enc_dec.iOnlineAclControl = 0;							// [필수] 실시간 권한 제어(0:미사용, 1:사용)
		m_enc_dec.sDocType = fileExt;									// [필수] 파일명 확장자
		m_enc_dec.sSecurityLevelName = "암호화";					// [필수] 보안 등급명
		m_enc_dec.sCreatorName = StringUtil.checkNull(drmInfoMap.get("userName"));							// [선택] 생성자 이름 
		m_enc_dec.sUsableAlways = "0";								// [선택] 항상 사용 가능 설정 값 (1:무조건 열람)
		m_enc_dec.sValidPeriodType = "1";							// [필수] (1:sDocValidPeriod의 값을 숫자로 표기, 0:sDocValidPeriod의 값을 yyyymmddhhmmss로 표기)

		m_enc_dec.iEncryptPrevCipher = 0;							// [선택] 0:신버전 암호화, 1:구버전 암호화, 디폴트 : 신버전 암호화
		
		int enc_rs = m_enc_dec.iEncrypt();
		
		returnValue = filePath + StringUtil.checkNull(drmInfoMap.get("orgFileName"));
		return returnValue;
	}
		
	public static String upload(HashMap drmInfoMap){
		WDSCryptAll m_enc_dec = null;
		BufferedInputStream in = null;
		BufferedOutputStream out = null;
		String strRetCode = "";
		long OutFileLength = 0;
		// 생성자 초기화
		m_enc_dec = new WDSCryptAll();
		
		m_enc_dec.sSourceFilePath = StringUtil.checkNull(drmInfoMap.get("ORGFileDir")) + "/" + StringUtil.checkNull(drmInfoMap.get("FileRealName")); // 암호화 대상 평문 파일
		m_enc_dec.sDestFilePath =  StringUtil.checkNull(drmInfoMap.get("DRMFileDir")) + "/" + StringUtil.checkNull(drmInfoMap.get("Filename")); // 암호화 결과로 생성할 파일

		// 복호화 함수 호출
		int dec_rs = m_enc_dec.iDecrypt();	
 		
		return StringUtil.checkNull(drmInfoMap.get("DRMFileDir")) + "/" + StringUtil.checkNull(drmInfoMap.get("Filename"));
	}
	
	public static String download(HashMap drmInfoMap) {
		String returnValue = "";
		returnValue = StringUtil.checkNull(drmInfoMap.get("downFile"));
		return returnValue;
	}
}