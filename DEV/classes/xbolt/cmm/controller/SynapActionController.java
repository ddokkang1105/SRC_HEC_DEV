package xbolt.cmm.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.*;
import xbolt.cmm.service.CommonService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.*;
import java.lang.ProcessBuilder.Redirect;
import java.util.*;
import java.util.zip.InflaterInputStream;
 
@Controller
public class SynapActionController extends XboltController {
   // static String DOC_UPLOAD_DIR_REL_PATH = GlobalVal.FILE_UPLOAD_TINY_DIR + "docs";
   // static String OUTPUT_DIR_REL_PATH = GlobalVal.FILE_UPLOAD_TINY_DIR + "output";
	
	//static String DOC_UPLOAD_DIR_REL_PATH = GlobalVal.FILE_UPLOAD_TMP_DIR + "docs";
	//static String OUTPUT_DIR_REL_PATH = GlobalVal.FILE_UPLOAD_TMP_DIR + "output";
    static String OUTPUT_DIR_URL_PATH = "/upload/output";

    @RequestMapping(value = "/synapEditorFrame.do", method = RequestMethod.GET)
    public String synapEditorFrame(HttpServletRequest request, ModelMap model) {
    	String url = "/cmm/editor/synapEditorFrame";
    	return nextUrl(url);
    }
   
	@RequestMapping(value = "/importDoc.do", method = RequestMethod.POST)
    public void importDoc(HttpServletRequest request, HttpServletResponse response, @RequestParam("file") MultipartFile importFile) throws IOException {
    	response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        try {
            Map<String, Object> map = new HashMap<String, Object>();
    	
	    	String uploadRoot = request.getServletContext().getRealPath("/upload");
	        String UPLOAD_DIR_ABS_PATH = FileUtil.FILE_UPLOAD_DIR; // D://OLMFILE//base//
	     
	        makeDirectory(UPLOAD_DIR_ABS_PATH); // D://OLMFILE//base//
	     
	        String fileName = importFile.getOriginalFilename();
	        String fileExt = "";
	        int dotIdx = fileName == null ? -1 : fileName.lastIndexOf('.');
	        if (dotIdx > -1) {
	        	fileExt = fileName.substring(dotIdx);
	        }
	        String safeImportFileName = UUID.randomUUID().toString() + fileExt;
	        
	        String inputFileAbsPath = new File(UPLOAD_DIR_ABS_PATH, safeImportFileName).getAbsolutePath();
	        System.out.println("importDoc : connected");
	        System.out.println("originalFileName:" + fileName);
	        System.out.println("safeImportFileName:" + safeImportFileName);
	        System.out.println("inputFileAbsPath:"+inputFileAbsPath);
	        
	        
	        writeFile(inputFileAbsPath, importFile.getBytes());
	     
	        // 파일별로 변환결과를 저장할 경로 생성
	        Calendar cal = Calendar.getInstance();
	        String yearMonth = String.format("%04d%02d", cal.get(Calendar.YEAR), cal.get(Calendar.MONTH)+1);
	        String uuid = UUID.randomUUID().toString();

	        String worksDirAbsPath = uploadRoot + File.separator + "output"  + File.separator + yearMonth + File.separator + uuid;
	 
	        makeDirectory(worksDirAbsPath);
	 
	        // 문서 변환
	        executeConverter(inputFileAbsPath, worksDirAbsPath);
	     
	        // 변환이 끝난 원본파일은 삭제한다.
	        deleteFile(inputFileAbsPath);
	     
	        // 변환된 pb파일을 읽어서 serialzie
	        // v2.3.0 부터 파일명이 document.word.pb에서 document.pb로 변경됨
	        String pbAbsPath = worksDirAbsPath + File.separator + "document.pb"; 
	        Integer[] serializedData = serializePbData(pbAbsPath);
	     
	        // pb파일은 삭제
	        // v2.3.0 부터 파일명이 document.word.pb에서 document.pb로 변경됨
	        deleteFile(pbAbsPath);
	     
	        map.put("serializedData", serializedData);
	        // 브라우저에서 접근가능한 경로를 importPath에 담아서 넘겨줍니다.
	        // OUTPUT_DIR_REL_PATH 경로에 맞춰서 수정해야 합니다.
	        String importPath = request.getContextPath() + OUTPUT_DIR_URL_PATH + "/" + yearMonth + "/" + uuid;
	        System.out.println(" put importPath OUTPUT_DIR_REL_PATH ::" + importPath); // /upload/output/202604/4db81a6d-df26-4915-b99f-8d8fd356ec93
	        map.put("importPath", importPath);
	                
	        System.out.println("serializedData is null ? " + (serializedData == null));
	        System.out.println("serializedData length : " + (serializedData == null ? 0 : serializedData.length));
	        System.out.println("importPath : " + importPath);
     

	        String json = toJson(map);

	        System.out.println("json length : " + json.length());
	        System.out.println("json preview : " + json.substring(0, Math.min(300, json.length())));

	        response.setStatus(HttpServletResponse.SC_OK);
	        response.getWriter().write(json);
	        response.getWriter().flush();
	        return;

	    } catch (Exception e) {
	        e.printStackTrace();
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        response.getWriter().write("{\"error\":true,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
	        response.getWriter().flush();
	    }
	}
    
    private static String toJson(Map<String, Object> map) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");

        sb.append("\"serializedData\":");
        Integer[] arr = (Integer[]) map.get("serializedData");
        sb.append("[");
        for (int i = 0; i < arr.length; i++) {
            if (i > 0) sb.append(",");
            sb.append(arr[i]);
        }
        sb.append("]");

        sb.append(",");
        sb.append("\"importPath\":\"").append(escapeJson(String.valueOf(map.get("importPath")))).append("\"");

        sb.append("}");
        return sb.toString();
    }

    private static String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\r", "\\r")
                  .replace("\n", "\\n");
    }

    /**
     * 문서 변환 모듈을 실행합니다.
     */
    public static int executeConverter(String inputFilePath, String outputFilePath) {
        String SEDOC_CONVERTER_DIR_ABS_PATH = "D:/Synap/import_module";
        String FONT_DIR_ABS_PATH = SEDOC_CONVERTER_DIR_ABS_PATH + File.separator + "fonts";
        String TEMP_DIR_ABS_PATH = SEDOC_CONVERTER_DIR_ABS_PATH + File.separator + "temp";
        String SEDOC_CONVERTER_ABS_PATH = SEDOC_CONVERTER_DIR_ABS_PATH + File.separator + "sedocConverter.exe";
     
        makeDirectory(TEMP_DIR_ABS_PATH);
        makeDirectory(FONT_DIR_ABS_PATH);
 
        // 변화 명령 구성
        String[] cmd = {SEDOC_CONVERTER_ABS_PATH, "-f", FONT_DIR_ABS_PATH, inputFilePath, outputFilePath, TEMP_DIR_ABS_PATH};
        try {
            Timer t = new Timer();
             
             // JDK 1.7 이상
            ProcessBuilder builder = new ProcessBuilder(cmd);
            // 프로세스의 출력과 에러 스트림을 상속하도록 설정 (부모 프로세스의 콘솔로 출력됨)
            builder.redirectOutput(Redirect.INHERIT);
            builder.redirectError(Redirect.INHERIT);
             
            Process proc = builder.start();
             
            TimerTask killer = new TimeoutProcessKiller(proc);
            t.schedule(killer, 20000); // 20초 (변환이 20초 안에 완료되지 않으면 프로세스 종료)
         
            int exitValue = proc.waitFor();
            System.out.println("exitValue :"+exitValue);
            killer.cancel();
         
            return exitValue;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
     
    /**
     * 문서 모듈 실행 후 변환된 결과를 Serialize 합니다.
     */
    public static Integer[] serializePbData(String pbFilePath) throws IOException {
        List<Integer> serializedData = new ArrayList<Integer>();
        FileInputStream fis = null;
        InflaterInputStream ifis = null;
        Integer[] data = null;
     
        try {
            fis = new FileInputStream(pbFilePath);
            fis.skip(16);
     
            ifis = new InflaterInputStream(fis);
            byte[] buffer = new byte[1024];
     
            int len;
            while ((len = ifis.read(buffer)) != -1) {
                for (int i = 0; i < len; i++) {
                    serializedData.add(buffer[i] & 0xFF);
                }
            }
     
            data = serializedData.toArray(new Integer[serializedData.size()]);
        } finally {
            if (ifis != null) ifis.close();
            if (fis != null) fis.close();
        }
     
        return data;
    }
     
    /**
     * 파일을 씁니다.
     */
    private static void writeFile(String path, byte[] bytes) throws IOException {
        OutputStream os = null;
        try {
            os = new FileOutputStream(path);
            os.write(bytes);
        } finally {
            if (os != null) os.close();
        }
    }
     
    /**
     * 파일을 삭제합니다.
     */
    private static void deleteFile(String path) {
        File file = new File(path);
        if (file.exists()) {
            file.delete();
        }
    }
     
    /**
     * 디렉토리가 없는 경우 디렉토리를 생성합니다.
     */
    private static void makeDirectory(String dirPath) {
        File dir = new File(dirPath);
        if (!dir.exists()) {
            dir.mkdir();
        }
    }
     
    private static class TimeoutProcessKiller extends TimerTask {
        private Process p;
     
        public TimeoutProcessKiller(Process p) {
            this.p = p;
        }
     
        @Override
        public void run() {
            p.destroy();
        }
    }
}
