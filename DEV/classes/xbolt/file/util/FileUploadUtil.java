package xbolt.file.util;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.file.AccessDeniedException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.tika.Tika;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.FileGlobalVal;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;


@SuppressWarnings("unchecked")
@Component
public class FileUploadUtil extends XboltController{
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "fileUploadService")
	private CommonService fileUploadService;
	
	private final Log _log = LogFactory.getLog(this.getClass());
	
	/** 파일ROOT경로 */		
	public static final String FILE_UPLOAD_DIR = GlobalVal.FILE_UPLOAD_TMP_DIR;
	// 최대 파일 사이즈 설정 - dthmlx
	private static final long MAX_FILE_SIZE = 2000000;
	// 개별 파일 max size
	public static final long FILE_MAX_SIZE = GlobalVal.FILE_MAX_SIZE;
	// 전체 파일 max size
	public static final long UPLOAD_ALL_FILES_MAX_SIZE = GlobalVal.UPLOAD_ALL_FILES_MAX_SIZE;
	
	// front 파일 업로드
	@RequestMapping(value="/fileUploadHandler.do")
	public void fileUploadHandler(@RequestParam(value="file", required=false) MultipartFile file, HttpServletRequest req, HttpServletResponse resp) throws IOException, org.apache.commons.fileupload.FileUploadException {	
		
		String mode = req.getParameter("mode");
		String action = "";

		ServletFileUpload uploader = null;
		FileItem items = null;
		try{
			String scrnType=StringUtil.checkNull(req.getParameter("scrnType"));
			String mgtId=StringUtil.checkNull(req.getParameter("mgtId"));
			String id =StringUtil.checkNull(req.getParameter("id")); // 사용 안함
			String uploadToken=StringUtil.checkNull(req.getParameter("uploadToken"));
			String uploadDir=GlobalVal.FILE_UPLOAD_BASE_DIR;
			
			HttpSession session = req.getSession(false); // 세션이 없으면 null 반환
	        if (session == null) {
	        	System.err.println("세션이 존재하지 않습니다. ");
	            throw new RuntimeException("세션이 존재하지 않습니다.");
	        }

	        // JSP에서 전달받은 토큰
	        if (uploadToken == null || uploadToken.trim().isEmpty()) {
	        	System.err.println("업로드 토큰이 없습니다. ");
	            throw new RuntimeException("업로드 토큰이 없습니다.");
	        }

			
			if (mode == null || (mode != null && !mode.equals("conf") && !mode.equals("sl"))) {
				uploader = new ServletFileUpload(new DiskFileItemFactory());
			}
			
			// mode값이 없을 경우 , item에서 mode 와 action 값 재확인
			if (mode == null) {
				mode = "";
				
				if (mode == null || mode.isEmpty()) {
				    mode = StringUtil.checkNull(req.getParameter("mode"));
				}
				if (action == null || action.isEmpty()) {
				    action = StringUtil.checkNull(req.getParameter("action"));
				}
			}
			// mode가 conf 인 경우, max File Size 반환
			if (mode.equals("conf")) {
				writeJsonResponse(resp, new HashMap<String, Object>() {{
                    put("maxFileSize", MAX_FILE_SIZE);
                }});
			}
			
			// 파일 업로드 처리
			if (mode.equals("html4") || mode.equals("flash") || mode.equals("html5")) {
				if (action.equals("cancel")) {
					// action이 cancel인 경우, 취소 처리
					writeJsonResponse(resp, new HashMap<String, Object>() {{
                        put("state", "cancelled");
                    }});
				} else {
					//make root dir 루트 폴더 생성
					Path baseDir = Paths.get(uploadDir).normalize();
					if (!Files.isDirectory(baseDir)) {
	                    Files.createDirectories(baseDir);
	                }
					
					//make second dir 하위 폴더 생성
	                Path targetDir = baseDir.resolve(uploadToken).normalize();
	                
	                // 경로 조작 확인
	                if (!targetDir.startsWith(baseDir)) {
	                	System.err.println("Invalid upload path. ");
	                	throw new RuntimeException("Invalid upload path. ");
	                }
	                
	                // session token 비교
	                @SuppressWarnings("unchecked")
	                List<String> tokenList = (List<String>) session.getAttribute("UPLOAD_TOKEN_LIST");
	                if (tokenList == null) {
	                    tokenList = new ArrayList<>();
	                    session.setAttribute("UPLOAD_TOKEN_LIST", tokenList);
	                }
	                if (tokenList.contains(uploadToken)) {
	                	// 최종 업로드 폴더 생성
	                	if (!Files.isDirectory(targetDir)) {
	                		Files.createDirectories(targetDir); 
	                	}
	                }
	                
					// 파일 업로드
					String filename = "";
					Integer filesize = 0;		
					
					// 업로드 된 file 없으면 종료
					if (file == null || file.isEmpty()) {
						System.err.println("no files ");
	                	throw new RuntimeException("no files");
	                }
					
					
					long totalUploadedSize = 0;
					// 파일명 경로 정보 제거
					filename = FilenameUtils.getName(file.getOriginalFilename());
					
					// 최종 파일명 검증 ( path 검증 )
					Path serverFilePath = targetDir.resolve(filename).normalize();
					if (!serverFilePath.startsWith(targetDir)) {
					    System.err.println("Invalid filename. (Path Traversal in filename)");
					    throw new RuntimeException("Invalid filename. (Path Traversal in filename)");
					}
					
					// 파일 사이즈 재확인
					long itemFileSize = file.getSize();
					totalUploadedSize = validateFileSize(itemFileSize, totalUploadedSize);
					
					// 확장자 점검
					Map<String, List<String>> allowedMapping = FileGlobalVal.getExtensionMimeMapping();
					String ext = StringUtil.checkNull(FileUtil.getExt(filename)).toLowerCase();
					if (!allowedMapping.containsKey(ext)) {
			            System.err.println("Validation Failed: Disallowed extension: " + ext);
			            throw new RuntimeException("Validation Failed: Disallowed extension: " + ext);
			        }
					
					File f = serverFilePath.toFile();
					
					InputStream filecontent = file.getInputStream();
					try (BufferedInputStream in = new BufferedInputStream(filecontent)) {
						
						 // stream을 통한 file Mime 검증 
						in.mark(10 * 1024 * 1024); 
					    String detectedTypeStream = detectMimeTypeFromStream(in, filename);
					    // 확장자에 따른 mime 점검
						List<String> allowedMimeTypes = allowedMapping.get(ext);
				        String lowerDetectedMime = detectedTypeStream.toLowerCase();
				        boolean isValid = allowedMimeTypes.stream().anyMatch(allowed -> allowed.equals(lowerDetectedMime));
					    
			            if (!isValid) {
						    System.err.println("Mime 오류 ");
			            	throw new RuntimeException("확장자 검증 실패");
			            }
			            
			            in.reset();
			            
			            FileOutputStream fout = new FileOutputStream(f);
					    byte[] buf = new byte[1024];
					    int len;
					    while ((len = in.read(buf)) > 0) {
					        fout.write(buf, 0, len);
					        filesize += len;
					    }
					    
					} catch (IOException e) {
						// rollbak
					    if (f.exists()) f.delete();
					    System.err.println("파일 업로드 ioException ");
					    throw e; 
					}
					// Manual filesize value only for demo!  // filesize = 28428;			
					
					Map<String, Object> responseData = new HashMap<>();
                    responseData.put("state", true);
                    responseData.put("name", filename.replace("\"","\\\""));
                    responseData.put("serverName", filename);
                    responseData.put("size", filesize);
                    responseData.put("uploadToken",uploadToken);
                    writeJsonResponse(resp, responseData);
					
				}
			}

			HashMap p = new HashMap();
			Enumeration params = req.getParameterNames();
			while (params.hasMoreElements()) {
				String name = (String)params.nextElement();
				p.put(name, req.getParameter(name));
			}

		}catch(SecurityException se) {
            // 허용되지 않은 경로 삭제 시도 등 보안 예외
			System.err.println("허용되지 않은 경로 삭제 시도 등 보안 예외 ");
			writeJsonResponse(resp, new HashMap<String, Object>() {{
	               put("state", false);
	               put("error", "Upload failed");
				}});
		}catch(IOException ioE) {
           // I/O 오류 처리 (파일 저장 실패, 디렉터리 생성 실패 등)
			System.err.println("I/O 오류 처리 (파일 저장 실패, 디렉터리 생성 실패 등) ");
            writeJsonResponse(resp, new HashMap<String, Object>() {{
               put("state", false);
               put("error", "Server I/O error during file operation.");
            }});
		} catch(Exception ex){
           // 기타 모든 예외 처리
			System.err.println("기타 모든 예외 처리 ");
            writeJsonResponse(resp, new HashMap<String, Object>() {{
               put("state", false);
               put("error", "An unknown error occurred on the server.");
            }});
       }
		
	}
	
	// java 파일 업로드
	public Map fileUpload(HashMap cmmMap, HttpServletRequest req) { 
	        
		Map resultMap = new HashMap();
		boolean result = false;
		String message = "";
		
		try {
			
			// 01. 경로 확인
			String type = StringUtil.checkNull(cmmMap.get("type"));
			String KBN = StringUtil.checkNull(cmmMap.get("KBN"));
			String targetPath = "";
			if("BOARD".equals(type)) targetPath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
			else targetPath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath",cmmMap), GlobalVal.FILE_UPLOAD_ITEM_DIR);
			
			String filePath = targetPath;
			Path base = Paths.get(GlobalVal.FILE_UPLOAD_BASE_DIR).toAbsolutePath().normalize();
			
	        String uploadToken = StringUtil.checkNull(cmmMap.get("uploadToken"));
	        
	        // session token 비교
	        HttpSession session = req.getSession(false); // 세션이 없으면 null 반환
	        if (session == null) {
	            throw new RuntimeException("세션이 존재하지 않습니다.");
	        }
	        
            @SuppressWarnings("unchecked")
            List<String> tokenList = (List<String>) session.getAttribute("UPLOAD_TOKEN_LIST");
            if (tokenList == null) {
                tokenList = new ArrayList<>();
                session.setAttribute("UPLOAD_TOKEN_LIST", tokenList);
            }
            if (tokenList.contains(uploadToken)) {
            	
            	Path safe = base.resolve(uploadToken).normalize();
    	        if (!safe.startsWith(base)) {
    	        	message = "허용되지 않은 경로 접근 시도";
    	        	resultMap.put("result",false);
    				resultMap.put("message",message);
    				System.out.println(message);
    	            throw new SecurityException(message);
    	        }
    	        
    			String orginPath = safe.toString();
    			
    			cmmMap.put("targetPath", targetPath);
    			cmmMap.put("filePath", filePath);
    			cmmMap.put("orginPath", orginPath);
    			
    			// 02. Service 로직 호출 ( copy )
    			if("update".equals(KBN)) resultMap = updateFile(cmmMap);
    			else resultMap = storeFile(cmmMap);
    			
    			// 03. session 토큰 삭제
    			deleteFileUploadFolderToken(session, uploadToken);
    			
    			
            } else {
            	throw new RuntimeException("token이 일치하지 않습니다");
            }
	        
			
		} catch (Exception e) {
			
			String causeMsg = e.getMessage();
	        if (causeMsg != null && !causeMsg.trim().isEmpty()) {
	            message = causeMsg;
	        } else {
	            message = "fileUpload 중 예상치 못한 오류가 발생했습니다.";
	        }
			
			resultMap.put("result",false);
			resultMap.put("message",message);
			System.out.println(e.toString());
		}
		
	    return resultMap;

	}
	
	@Transactional(rollbackFor = Exception.class)
	public Map storeFile(Map cmmMap) throws IOException {
        
		// 01. parameter setting
		boolean result = false; // result
		String message = ""; // error message
		Map resultMap = new HashMap();
		
		Map fileMap  = new HashMap();
		List fileList = new ArrayList();
		String type = StringUtil.checkNull(cmmMap.get("type")); // FILE or BOARD
		String KBN = "insert";
		
		String orginPath = StringUtil.checkNull(cmmMap.get("orginPath"));
		String targetPath = StringUtil.checkNull(cmmMap.get("targetPath"));
		
		String itemFileOption = StringUtil.checkNull(cmmMap.get("itemFileOption"));
		String filePath = StringUtil.checkNull(cmmMap.get("filePath"));
		
		// type: file
		String fltpCode = StringUtil.checkNull(cmmMap.get("fltpCode"));
		String fileMgt = StringUtil.checkNull(cmmMap.get("fileMgt"));
		String DocumentID = StringUtil.checkNull(cmmMap.get("DocumentID"));
		String ItemID = StringUtil.checkNull(cmmMap.get("ItemID"));
		String linkType = StringUtil.checkNull(cmmMap.get("linkType"));
		String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
		String RefFileID = StringUtil.checkNull(cmmMap.get("RefFileID"));
		String ChangeSetID = StringUtil.checkNull(cmmMap.get("ChangeSetID"));
		String userId = StringUtil.checkNull(cmmMap.get("userId"));
		String revisionYN = StringUtil.checkNull(cmmMap.get("revisionYN"));
		String DocCategory = StringUtil.checkNull(cmmMap.get("DocCategory"));
		// type : board
		String BoardID = StringUtil.checkNull(cmmMap.get("BoardID"));
		String BoardMgtID = StringUtil.checkNull(cmmMap.get("BoardMgtID"));
		
		String sql = "fileMgt_SQL.itemFile_insert";
		
		if("BOARD".equals(type)) sql = "boardFile_SQL.boardFile_insert"; // seq 자동저장으로 변경 TODO
		
		// 02. drm setting
		HashMap drmInfoMap = new HashMap();			
		String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
		String userName = StringUtil.checkNull(cmmMap.get("sessionUserNm"));
		String teamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
		String teamName = StringUtil.checkNull(cmmMap.get("sessionTeamName"));			
		String returnValue = ""; // drm return 값
		
		drmInfoMap.put("userID", userID);
		drmInfoMap.put("userName", userName);
		drmInfoMap.put("teamID", teamID);
		drmInfoMap.put("teamName", teamName);
		drmInfoMap.put("loginID", cmmMap.get("sessionLoginId"));
		drmInfoMap.put("sessionEmail", cmmMap.get("sessionEmail"));
		
		
		// 03. file Copy
		List tmpFileList = null;
		try {
		    tmpFileList = copyFiles(orginPath, targetPath);
		} catch (FileNotFoundException e) {
		    message = "원본 파일이 존재하지 않습니다. 경로: {" + orginPath + "}";
		    System.out.println(e.toString());
		    throw new RuntimeException(message);
		} catch (AccessDeniedException e) {
		    message = "파일 접근 권한이 없습니다. 경로: {" + orginPath + "}";
		    System.out.println(e.toString());
		    throw new RuntimeException(message);
		} catch (IOException e) {
		    message = "파일 복사 중 IO 오류 발생";
		    System.out.println(e.toString());
		    throw new RuntimeException(message);
		} catch (Exception e) {
		    message = "파일 복사 중 알 수 없는 예외 발생";
		    System.out.println(e.toString());
		    throw new RuntimeException(message);
		}
		
		// 04. db insert map setting
		if(tmpFileList != null){
			
			// 샤이냅뷰어 로직
			if("VIEWER".equals(itemFileOption)) filePath = "";
			
			for(int i=0; i<tmpFileList.size();i++){
				
				fileMap=new HashMap(); 
				HashMap tempMap=(HashMap)tmpFileList.get(i);
				
				if("BOARD".equals(type)) {
					// TODO : BOARD 도 FILE 과 동일하게 FileName 을 SysFileNM으로 들어가도록 수정 필요
					fileMap.put("FileName", tempMap.get("FileNm")); // origin file name
					fileMap.put("FileRealName", tempMap.get("SysFileNm")); // new file name
				} else {
					fileMap.put("FileName", tempMap.get("SysFileNm")); // new file name 
					fileMap.put("FileRealName", tempMap.get("FileNm")); // origin file name
				}
				
				
				
				fileMap.put("FileSize", tempMap.get("FILE_SIZE"));
				fileMap.put("FilePath", filePath);
				// type: file
				fileMap.put("DocumentID", DocumentID);
				fileMap.put("ItemID", ItemID);
				fileMap.put("FileFormat", tempMap.get("FILE_EXT"));
				fileMap.put("FltpCode", fltpCode);
				fileMap.put("FileMgt", fileMgt);
				fileMap.put("LinkType", linkType);
				fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				fileMap.put("userId", userId);
				fileMap.put("projectID", projectID);
				fileMap.put("DocCategory", "ITM");
				fileMap.put("RefFileID", RefFileID);
				fileMap.put("ChangeSetID", ChangeSetID);
				fileMap.put("revisionYN", revisionYN);
				fileMap.put("DocCategory", DocCategory);
				// type : board
				fileMap.put("BoardMgtID", BoardMgtID);
				fileMap.put("BoardID", BoardID);
				
				fileMap.put("SQLNAME", sql);
				
				// File DRM 복호화
				String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
				String DRM_UPLOAD_USE = StringUtil.checkNull(GlobalVal.DRM_UPLOAD_USE);
				if(!"".equals(useDRM) && !"N".equals(DRM_UPLOAD_USE)){
					drmInfoMap.put("ORGFileDir", orginPath);
					drmInfoMap.put("DRMFileDir", targetPath); 
					drmInfoMap.put("Filename", tempMap.get("SysFileNm"));
					drmInfoMap.put("FileRealName", tempMap.get("FileNm"));							
					drmInfoMap.put("funcType", "upload");
					try {
						returnValue = DRMUtil.drmMgt(drmInfoMap);
						
						// drm 실행 후 return Value 값 없으면 오류처리
						if (returnValue == null || returnValue.isEmpty()) {
					        message = "파일 DRM 처리 중 알 수 없는 오류 발생";
					        _log.info("fileUploadUtil::storeFile::Error::" + message + "//");
					        throw new RuntimeException(message);
					    }
						
						resultMap.put("returnValue",returnValue);
						
					} catch (ExceptionUtil e) {
						message = "파일 DRM 처리 중 알 수 없는 오류 발생";
						System.out.println(e.toString());
						throw new RuntimeException(message);
					}
				}
				
				fileList.add(fileMap);
			}
		}
		
		// 05. db insert
		try {
			cmmMap.put("KBN","insert");
			fileUploadService.save(fileList, cmmMap);
		    result = true;
		} catch (DataAccessException e) {
			message = "파일 저장 중 DB 접근오류 발생";
		    TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		    System.out.println(e.toString());
		    throw new RuntimeException(message);
		} catch (SQLException e) {
			message = "파일 저장 DB 쿼리 실행 중 오류 발생";
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			System.out.println(e.toString());
		    throw new RuntimeException(message);
		} catch (Exception e) {
			message = "파일 저장 DB 저장 중 알 수 없는 오류 발생";
		    TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		    System.out.println(e);
		    throw new RuntimeException(message);
		}
		
		// 06. 임시폴더 삭제 ( 임시폴더 삭제 중 문제에선 트랜잭션 미적용 )
		if (!orginPath.equals("")) {
			try {
				deleteDirectory(orginPath);
			} catch (Exception e) {
				message = "임시폴더 삭제 중 오류 발생";
				System.out.println(e.toString());
			}
		}
		
		resultMap.put("result", result);
		resultMap.put("message", message);
        return resultMap; // upload 파일명 return
        
    }
	
	@Transactional(rollbackFor = Exception.class)
	public Map updateFile(Map cmmMap) throws IOException {
        
		// 01. parameter setting
		boolean result = false; // result
		String message = ""; // error message
		Map resultMap = new HashMap();
		
		Map fileMap  = new HashMap();
		List fileList = new ArrayList();
		String type = StringUtil.checkNull(cmmMap.get("type")); // FILE or BOARD
		
		String orginPath = StringUtil.checkNull(cmmMap.get("orginPath"));
		String targetPath = StringUtil.checkNull(cmmMap.get("targetPath"));
		
		String itemFileOption = StringUtil.checkNull(cmmMap.get("itemFileOption"));
		String filePath = StringUtil.checkNull(cmmMap.get("filePath"));
		
		String fileID = StringUtil.checkNull(cmmMap.get("fileID"));
		String fltpCode = StringUtil.checkNull(cmmMap.get("fltpCode"));
		String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
		String ChangeSetID = StringUtil.checkNull(cmmMap.get("ChangeSetID"));
		String userId = StringUtil.checkNull(cmmMap.get("userId"));
		
		String sql = "fileMgt_SQL.itemFile_update";
		
		// parameter check
		if (fileID.isEmpty()) {
             throw new IllegalArgumentException("fileID is required.");
        }
		
		
		// 02. drm setting
		HashMap drmInfoMap = new HashMap();			
		String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
		String userName = StringUtil.checkNull(cmmMap.get("sessionUserNm"));
		String teamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
		String teamName = StringUtil.checkNull(cmmMap.get("sessionTeamName"));			
		String returnValue = ""; // drm return 값
		
		drmInfoMap.put("userID", userID);
		drmInfoMap.put("userName", userName);
		drmInfoMap.put("teamID", teamID);
		drmInfoMap.put("teamName", teamName);
		drmInfoMap.put("loginID", cmmMap.get("sessionLoginId"));
		drmInfoMap.put("sessionEmail", cmmMap.get("sessionEmail"));
		
		
		// 03. file Copy
		List tmpFileList = null;
		try {
		    tmpFileList = copyFiles(orginPath, targetPath);
		} catch (FileNotFoundException e) {
		    message = "원본 파일이 존재하지 않습니다. 경로: {" + orginPath + "}";
		    System.out.println(e.toString());
		    throw new RuntimeException(message);
		} catch (AccessDeniedException e) {
		    message = "파일 접근 권한이 없습니다. 경로: {" + orginPath + "}";
		    System.out.println(e.toString());
		    throw new RuntimeException(message);
		} catch (IOException e) {
		    message = "파일 복사 중 IO 오류 발생";
		    System.out.println(e.toString());
		    throw new RuntimeException(message);
		} catch (Exception e) {
		    message = "파일 복사 중 알 수 없는 예외 발생";
		    System.out.println(e.toString());
		    throw new RuntimeException(message);
		}
		
		// 04. db insert map setting
		if(tmpFileList != null){
			
			// 샤이냅뷰어 로직
			if("VIEWER".equals(itemFileOption)) filePath = "";
			
			for(int i=0; i<tmpFileList.size();i++){
				
				fileMap=new HashMap(); 
				HashMap tempMap=(HashMap)tmpFileList.get(i);
				
				fileMap.put("FileName", tempMap.get("SysFileNm")); // new file name 
				fileMap.put("FileRealName", tempMap.get("FileNm")); // origin file name
				fileMap.put("FileSize", tempMap.get("FILE_SIZE"));
				fileMap.put("FilePath", filePath);
				
				// type: file
				fileMap.put("Seq", fileID);
				fileMap.put("FileFormat", tempMap.get("FILE_EXT"));
				fileMap.put("FltpCode", fltpCode);
				fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				fileMap.put("sessionUserId", userId);
				fileMap.put("projectID", projectID);
				fileMap.put("ChangeSetID", ChangeSetID);
				
				fileMap.put("SQLNAME", sql);
				
				// File DRM 복호화
				String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
				String DRM_UPLOAD_USE = StringUtil.checkNull(GlobalVal.DRM_UPLOAD_USE);
				if(!"".equals(useDRM) && !"N".equals(DRM_UPLOAD_USE)){
					drmInfoMap.put("ORGFileDir", orginPath);
					drmInfoMap.put("DRMFileDir", targetPath); 
					drmInfoMap.put("Filename", tempMap.get("SysFileNm"));
					drmInfoMap.put("FileRealName", tempMap.get("FileNm"));							
					drmInfoMap.put("funcType", "upload");
					try {
						returnValue = DRMUtil.drmMgt(drmInfoMap);
						
						// drm 실행 후 return Value 값 없으면 오류처리
						if (returnValue == null || returnValue.isEmpty()) {
					        message = "파일 DRM 처리 중 알 수 없는 오류 발생";
					        _log.info("fileUploadUtil::storeFile::Error::" + message + "//");
					        throw new RuntimeException(message);
					    }
						
						resultMap.put("returnValue",returnValue);
						
					} catch (ExceptionUtil e) {
						message = "파일 DRM 처리 중 알 수 없는 오류 발생";
						System.out.println(e.toString());
						throw new RuntimeException(message);
					}
				}
				
				fileList.add(fileMap);
			}
		}
		
		// 05. db update
		try {
			cmmMap.put("KBN","update");
			fileUploadService.save(fileList, cmmMap);
		    result = true;
		} catch (DataAccessException e) {
			message = "파일 저장 중 DB 접근오류 발생";
		    TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		    System.out.println(e.toString());
		    throw new RuntimeException(message);
		} catch (SQLException e) {
			message = "파일 저장 DB 쿼리 실행 중 오류 발생";
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			System.out.println(e.toString());
		    throw new RuntimeException(message);
		} catch (Exception e) {
			message = "파일 저장 DB 저장 중 알 수 없는 오류 발생";
		    TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		    System.out.println(e);
		    throw new RuntimeException(message);
		}
		
		// 06. 임시폴더 삭제 ( 임시폴더 삭제 중 문제에선 트랜잭션 미적용 )
		if (!orginPath.equals("")) {
			try {
				deleteDirectory(orginPath);
			} catch (Exception e) {
				message = "임시폴더 삭제 중 오류 발생";
				System.out.println(e.toString());
			}
		}
		
		resultMap.put("result", result);
		resultMap.put("message", message);
        return resultMap; // upload 파일명 return
        
    }
	
	// 폴더 삭제
    private void deleteDirectory(String path) throws IOException {
    	
    	// 01. 접근경로 정규화
    	Path targetDir = Paths.get(path).normalize();
    	
    	// 02. 폴더 존재 여부 체크
        if (!Files.exists(targetDir)) return;

        // 03. baseDir 이하만 허용
        Path baseDir = Paths.get(GlobalVal.FILE_UPLOAD_BASE_DIR).normalize();
        if (!targetDir.startsWith(baseDir)) {
            throw new SecurityException("허용되지 않은 경로 삭제 시도: " + targetDir);
        }

        // 04. 모든 하위 항목 역순 삭제
        Files.walk(targetDir)
            .sorted(Comparator.reverseOrder())
            .forEach(p -> {
                try {
                    Files.deleteIfExists(p); // 파일이 존재할 경우 삭제
                } catch (Exception e) {
                	System.out.println(e.toString());
                }
            });
    }
    
    // 파일 삭제
    private void deleteFile(String path, String fileName) throws IOException {
    	
    	// 01. 접근경로 정규화
    	Path targetDir = Paths.get(path).normalize();
    	
    	// 02. 폴더 존재 여부 체크
        if (!Files.exists(targetDir)) return;

        // 03. baseDir 이하만 허용
        Path baseDir = Paths.get(GlobalVal.FILE_UPLOAD_BASE_DIR).normalize();
        if (!targetDir.startsWith(baseDir)) {
            throw new SecurityException("허용되지 않은 경로 삭제 시도: " + targetDir);
        }
        
        // 04. 실제 파일 삭제
        Path targetFile = targetDir.resolve(fileName).normalize();
        
        // 05. baseDir 이하 파일 재검증 
        if (!targetFile.startsWith(baseDir)) {
            throw new SecurityException("허용되지 않은 경로 삭제 시도: " + targetDir);
        }

        // 06. 파일 존재 여부 확인 후 삭제
        if (Files.exists(targetFile) && Files.isRegularFile(targetFile)) {
            Files.delete(targetFile);
        }
    }
    
    public static List copyFiles(String orginPath, String targetPath) throws Exception {
		HashMap<String, String> map = new HashMap<String, String>();
		List fileList = new ArrayList();
		String newFileName="";
		
		// 복사할 타켓 폴더 설정
		File fTargetFolder = new File (targetPath);
		// 복사할 타켓 폴더가 없다면 생성
		if ( !fTargetFolder.isDirectory()){fTargetFolder.mkdir();}
		
		// 복사할 원본 폴더에서 파일가져오기
		File fOrginFolder = new File (orginPath);
	    String[] FileList = fOrginFolder.list();
	    
	    long totalUploadedSize = 0;
	    
	    if(FileList!=null){
	    for( int i = 0; i < FileList.length; i++)
	    {
	    	map = new HashMap<String, String>();
	    	
	    	// 원본 폴더에서 복사할 파일 가져오기
	    	File fOri = new File ( orginPath , FileList[i]);
			
	    	// 파일이름 , 확장자, 사이즈 가져오기
	    	String orginFileName = fOri.getName();
			String fileExt = FileUtil.getExt(orginFileName);
			long size = fOri.length();
			
			// file size 검증
			totalUploadedSize = validateFileSize(size, totalUploadedSize);
		    
			// 확장자 점검
			Map<String, List<String>> allowedMapping = FileGlobalVal.getExtensionMimeMapping();
			String ext = StringUtil.checkNull(FileUtil.getExt(orginFileName)).toLowerCase();
			if (!allowedMapping.containsKey(ext)) {
	            System.err.println("Validation Failed: Disallowed extension: " + ext);
	            throw new RuntimeException("Validation Failed: Disallowed extension: " + ext);
	        }
		    
		    // path를 통한 file Mime 검증 
		    Path fOriPath = fOri.toPath();
		    String detectedType = detectMimeType(fOriPath);
		    // 확장자에 따른 mime 점검
			List<String> allowedMimeTypes = allowedMapping.get(ext);
	        String lowerDetectedMime = detectedType.toLowerCase();
	        boolean isValid = allowedMimeTypes.stream().anyMatch(allowed -> allowed.equals(lowerDetectedMime));
		   
            if (!isValid) {
            	throw new RuntimeException("확장자 검증 실패");
            }
		    
			//newName 은 Naming Convention에 의해서 생성
			newFileName = DateUtil.getCurrentTime() + "_" + UUID.randomUUID().toString().substring(0, 8) + "." + fileExt;
			
			// 타켓 폴더에 복사
			File fTarget = new File ( targetPath + newFileName);
			
			//너무 빠른 처리 시 파일명이 중복되어 1개 파일만 저장되는 경우가 있어서 잠시 멈춰주는 부분 추가
			Thread.sleep(1000);
			//file copy
			Files.copy(fOri.toPath(), fTarget.toPath()); 
			
			
			// 파일 정보 담기
			map.put("FileNm", fOri.getName());
			//map.put(ORIGIN_FILE_NM, fOri.getName());
			map.put("SysFileNm", newFileName);
			map.put("FILE_EXT", fileExt);
			map.put("FilePath", targetPath);
			map.put("FILE_SIZE", String.valueOf(size));
			
			fileList.add(map);
	    
	    }}
		return fileList;
	}
    
    // 파일 사이즈 체크
 	private static long validateFileSize(long size, long totalUploadedSize) {
 		
 		// 개별 파일 사이즈
 		if (size > FILE_MAX_SIZE) {
 	        throw new RuntimeException("개별 파일 용량 초과");
 	    }
 		
 		long newTotalSize = totalUploadedSize + size;
 				
 		if (newTotalSize > UPLOAD_ALL_FILES_MAX_SIZE) {
 	        throw new RuntimeException("총 파일 용량 초과");
 	    }	
 		
 		// 총 파일 사이즈
 		return newTotalSize;
 	}
 	
 	// 경로를 통한 Mime 검증
 	public static String detectMimeType(Path filePath) {
        try {
        	Tika TIKA = new Tika();
            String mimeType = TIKA.detect(filePath); //  MIME Type 추출
            return mimeType;
        } catch (Exception e) {
            System.err.println("파일 MIME Type 감지 중 오류 발생: " + e.getMessage());
            throw new RuntimeException();
        }
    }
 	
 	// input stream을 통한 Mime 검증
  	public static String detectMimeTypeFromStream(BufferedInputStream inputStream, String fileName) {
         try {
         	Tika TIKA = new Tika();
             String mimeType = TIKA.detect(inputStream, fileName);
             return mimeType;
         } catch (Exception e) {
             System.err.println("스트림 MIME Type 감지 중 오류 발생: " + e.getMessage());
             return "application/octet-stream";
         }
     }
  	
 	// session에 file 토큰 저장
  	public static String makeFileUploadFolderToken(HttpSession session) {
         try {
        	 // UUID 생성
             String token = UUID.randomUUID().toString();

             // 기존 세션의 토큰 리스트를 가져오기 (없으면 새로 생성)
             @SuppressWarnings("unchecked")
             List<String> tokenList = (List<String>) session.getAttribute("UPLOAD_TOKEN_LIST");
             if (tokenList == null) {
                 tokenList = new ArrayList<>();
             }

             // 새 토큰 추가
             tokenList.add(token);

             // 세션에 다시 저장
             session.setAttribute("UPLOAD_TOKEN_LIST", tokenList);
             
             // 반환
             return token;
         } catch (Exception e) {
             System.err.println("파일 업로드 토큰 생성 중 오류 발생: " + e.getMessage());
             throw new RuntimeException();
         }
     }
  	
  	// session에 file 토큰 삭제
   	public static void deleteFileUploadFolderToken(HttpSession session, String token) {
          try {

              // 기존 세션의 토큰 리스트를 가져오기 (없으면 새로 생성)
              @SuppressWarnings("unchecked")
              List<String> tokenList = (List<String>) session.getAttribute("UPLOAD_TOKEN_LIST");
              if (tokenList == null) {
                  return;
              }
              
              boolean removed = tokenList.remove(token);

              // token이 리스트에 존재할 경우 세션에서 삭제
              if (tokenList.isEmpty()) {
                  session.removeAttribute("UPLOAD_TOKEN_LIST");
              } else {
                  session.setAttribute("UPLOAD_TOKEN_LIST", tokenList);
              }
              
          } catch (Exception e) {
              System.err.println("파일 업로드 토큰 삭제 중 오류 발생: " + e.getMessage());
              throw new RuntimeException();
          }
      }
   	
   	// 임시폴더에서 파일 삭제
   	@RequestMapping(value="/removeTempFile.do")
	public String removeTempFile(Map cmmMap, ModelMap model, HttpServletRequest req) throws Exception {
		Map target = new HashMap();
		String errorMessage = StringUtil.checkNull(cmmMap.get("sessionCurrLangCode") + ".WM00076");

		try {
			Path base = Paths.get(GlobalVal.FILE_UPLOAD_BASE_DIR).toAbsolutePath().normalize();
			String uploadToken = StringUtil.checkNull(cmmMap.get("uploadToken"));
			String fileName = StringUtil.checkNull(cmmMap.get("fileName")); 
			String removeAll = StringUtil.checkNull(cmmMap.get("removeAll")); 
			String isInit = StringUtil.checkNull(cmmMap.get("isInit")); 
			
			// session token 비교
	        HttpSession session = req.getSession(false); // 세션이 없으면 null 반환
	        if (session == null) {
	            throw new RuntimeException("세션이 존재하지 않습니다.");
	        }
	        
			@SuppressWarnings("unchecked")
            List<String> tokenList = (List<String>) session.getAttribute("UPLOAD_TOKEN_LIST");
            if (tokenList.contains(uploadToken)) {
            	
            	Path safe = base.resolve(uploadToken).normalize();
    	        if (!safe.startsWith(base)) {
    	        	errorMessage = "허용되지 않은 경로 접근 시도";
    				System.out.println(errorMessage);
    	            throw new SecurityException(errorMessage);
    	        }
    	        
    			String orginPath = safe.toString();
    			File existFile = new File(orginPath);
    			
    			if(removeAll.equals("Y")) {
    				deleteDirectory(orginPath.toString());
    			}else {
    				deleteFile(orginPath.toString(),fileName);
    			}
            }else {
            	errorMessage = "token이 일치하지 않습니다";
				System.out.println(errorMessage);
	            throw new RuntimeException(errorMessage);
            }

		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, errorMessage); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
   	
	// 클라이언트 전송 JSON 
	private void writeJsonResponse(HttpServletResponse resp, Map<String, Object> data) throws IOException {
        resp.setContentType("application/json"); 
        resp.setCharacterEncoding("UTF-8");
        
        ObjectMapper mapper = new ObjectMapper();
        PrintWriter out = resp.getWriter();
        
        try {
            mapper.writeValue(out, data);
        } catch (JsonProcessingException e) {
            out.write("{\"state\":false,\"error\":\"Internal server error during response generation.\"}");
        }
        out.flush();
    }
 	
}
