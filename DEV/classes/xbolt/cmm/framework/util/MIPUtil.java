/*
package xbolt.cmm.framework.util;

import org.springframework.core.ParameterizedTypeReference;
import xbolt.cmm.framework.val.DrmGlobalVal;

import java.util.List;
import java.util.Map;

*/
/**
 * MIP API 호출용 간단 유틸.
 * - POST JSON 요청
 * - 응답 JSON을 JSONObject로 반환
 * - 호출 실패 시 Exception throw
 *//*

public class MIPUtil {

    */
/**
     * Tenants 조회
     * @param systemId
     * @return
     * @throws Exception
     *//*

    public static List<Map<String, Object>> getTenants(String systemId) throws Exception {
        //String body = "{\"SystemId\":\"" + StringUtil.checkNull(systemId) + "\"}";

        Map<String, Object> requestBody = new MapBuilder()
                .put("SystemId", StringUtil.checkNull(systemId))
                .build();

        String api = StringUtil.checkNull(DrmGlobalVal.DRM_MIP_API_URL) + "/api/MIPP/GetTenants";
        return RestTemplateUtil.restTemplateWithPostMethod(api, requestBody, new ParameterizedTypeReference<List<Map<String, Object>>>() {});
    }

    */
/**
     * Label(민감도) 조회
     * @param systemId
     * @param tenantId
     * @return
     * @throws Exception
     *//*

    public static List<Map<String, Object>> getLabels(String systemId, String tenantId) throws Exception {
        //String body = "{\"SystemId\":\"" + StringUtil.checkNull(systemId) + "\"}";

        Map<String, Object> requestBody = new MapBuilder()
                .put("SystemId", StringUtil.checkNull(systemId))
                .put("TalentId", StringUtil.checkNull(tenantId))
                .build();

        String api = StringUtil.checkNull(DrmGlobalVal.DRM_MIP_API_URL) + "/api/MIPP/GetLabels";
        return RestTemplateUtil.restTemplateWithPostMethod(api, requestBody, new ParameterizedTypeReference<List<Map<String, Object>>>() {});
    }


    */
/**
     * MIP 암호화 여부
     * @param systemId
     * @param path
     * @param fileName
     * @return
     * @throws Exception
     *//*

    public static boolean isProtected(String systemId, String path, String fileName) throws Exception {
        //String body = "{\"SystemId\":\"" + StringUtil.checkNull(systemId) + "\",\"Path\":\"" + escapePath(path) + "\",\"FileName\":\"" + fileName + "\"}";

        Map<String, Object> requestBody = new MapBuilder()
                .put("SystemId", StringUtil.checkNull(systemId))
                .put("Path", escapePath(StringUtil.checkNull(path)))
                .put("FileName", StringUtil.checkNull(fileName))
                .build();

        String api = StringUtil.checkNull(DrmGlobalVal.DRM_MIP_API_URL) + "/api/MIPP/IsProtected";
        Map<String,Object> result = RestTemplateUtil.restTemplateWithPostMethod(api, requestBody, new ParameterizedTypeReference<Map<String, Object>>() {});

        return (boolean) result.get("IsProtected");
    }


    */
/**
     * MIP 분류 상태 조회
     * @param systemId
     * @param path
     * @param fileName
     * @return
     * @throws Exception
     *//*

    public static boolean isLabeled(String systemId, String path, String fileName) throws Exception {
        //String body = "{\"SystemId\":\"" + StringUtil.checkNull(systemId) + "\",\"Path\":\"" + escapePath(path) + "\",\"FileName\":\"" + fileName + "\"}";

        Map<String, Object> requestBody = new MapBuilder()
                .put("SystemId", StringUtil.checkNull(systemId))
                .put("Path", escapePath(StringUtil.checkNull(path)))
                .put("FileName", StringUtil.checkNull(fileName))
                .build();

        String api = StringUtil.checkNull(DrmGlobalVal.DRM_MIP_API_URL) + "/api/MIPP/IsLabeled";
        Map<String,Object> result = RestTemplateUtil.restTemplateWithPostMethod(api, requestBody, new ParameterizedTypeReference<Map<String, Object>>() {});

        return (boolean) result.get("isLabeled");
    }

    */
/**
     * MIP 분류 및 암호화 상태 조회
     * @param systemId
     * @param path
     * @param fileName
     * @return
     * @throws Exception
     *//*

    public static Map<String, Object> isLabeledOrProtected(String systemId, String path, String fileName) throws Exception {
        //String body = "{\"SystemId\":\"" + StringUtil.checkNull(systemId) + "\",\"Path\":\"" + escapePath(path) + "\",\"FileName\":\"" + fileName + "\"}";

        Map<String, Object> requestBody = new MapBuilder()
                .put("SystemId", StringUtil.checkNull(systemId))
                .put("Path", escapePath(StringUtil.checkNull(path)))
                .put("FileName", StringUtil.checkNull(fileName))
                .build();

        String api = StringUtil.checkNull(DrmGlobalVal.DRM_MIP_API_URL) + "/api/MIPP/IsLabeledOrProtected";
        return RestTemplateUtil.restTemplateWithPostMethod(api, requestBody, new ParameterizedTypeReference<Map<String, Object>>() {});
    }


    */
/**
     * MIP 파일 상태 조회
     * @param systemId
     * @param path
     * @param fileName
     * @return
     * @throws Exception
     *//*

    public static Map<String, Object> getFileStatus(String systemId, String path, String fileName) throws Exception {
        //String body = "{\"SystemId\":\"" + StringUtil.checkNull(systemId) + "\",\"Path\":\"" + escapePath(path) + "\",\"FileName\":\"" + fileName + "\"}";

        Map<String, Object> requestBody = new MapBuilder()
                .put("SystemId", StringUtil.checkNull(systemId))
                .put("Path", escapePath(StringUtil.checkNull(path)))
                .put("FileName", StringUtil.checkNull(fileName))
                .build();

        String api = StringUtil.checkNull(DrmGlobalVal.DRM_MIP_API_URL) + "/api/MIPP/GetFileStatus";
        return RestTemplateUtil.restTemplateWithPostMethod(api, requestBody, new ParameterizedTypeReference<Map<String, Object>>() {});
    }


    */
/**
     * AIP 민감도 레이블 적용
     * @param systemId
     * @param path
     * @param fileName
     * @param labelId
     * @return
     * @throws Exception
     *//*

    public static Map<String, Object> setLabel(String systemId, String path, String fileName, String labelId) throws Exception {
        //String body = "{\"SystemId\":\"" + StringUtil.checkNull(systemId) + "\",\"Path\":\"" + escapePath(path) + "\",\"FileName\":\"" + fileName + "\",\"LabelId\":\"" + labelId + "\"}";

        Map<String, Object> requestBody = new MapBuilder()
                .put("SystemId", StringUtil.checkNull(systemId))
                .put("Path", escapePath(StringUtil.checkNull(path)))
                .put("FileName", StringUtil.checkNull(fileName))
                .put("LabelId", StringUtil.checkNull(labelId))
                .build();


        String api = StringUtil.checkNull(DrmGlobalVal.DRM_MIP_API_URL) + "/api/MIPP/SetLabel";
        return RestTemplateUtil.restTemplateWithPostMethod(api, requestBody, new ParameterizedTypeReference<Map<String, Object>>() {});
    }

    */
/**
     * AIP 보호 레이블 및 암호화 제거
     * @param systemId
     * @param path
     * @param fileName
     * @return
     * @throws Exception
     *//*

    public static Map<String, Object> removeProtection(String systemId, String path, String fileName) throws Exception {
        //String body = "{\"SystemId\":\"" + StringUtil.checkNull(systemId) + "\",\"Path\":\"" + escapePath(path) + "\",\"FileName\":\"" + fileName + "\"}";

        Map<String, Object> requestBody = new MapBuilder()
                .put("SystemId", StringUtil.checkNull(systemId))
                .put("Path", escapePath(StringUtil.checkNull(path)))
                .put("FileName", StringUtil.checkNull(fileName))
                .build();

        String api = StringUtil.checkNull(DrmGlobalVal.DRM_MIP_API_URL) + "/api/MIPP/RemoveProtection";
        return RestTemplateUtil.restTemplateWithPostMethod(api, requestBody, new ParameterizedTypeReference<Map<String, Object>>() {});
    }


    */
/**
     * 파일에 AIP 사용자 지정 보호 적용
     * @param systemId
     * @param path
     * @param fileName
     * @param tenantId
     * @param labelId
     * @param allowOfflineAccess
     * @param contentValidUntil
     * @param rights
     * @param users
     * @return
     * @throws Exception
     *//*

    public static Map<String, Object> setCustomProtection(
            String systemId,
            String path,
            String fileName,
            String tenantId,
            String labelId,
            boolean allowOfflineAccess,
            String contentValidUntil,
            List<String> rights,
            List<String> users
    ) throws Exception {
        */
/*
        StringBuilder body = new StringBuilder();
        body.append("{");
        body.append("\"SystemId\":\"").append(StringUtil.checkNull(systemId)).append("\",");
        body.append("\"Path\":\"").append(escapePath(path)).append("\",");
        body.append("\"FileName\":\"").append(fileName).append("\",");
        body.append("\"LabelId\":\"").append(labelId).append("\"");
        if (customProtection != null) {
            body.append(",\"CustomProtection\":").append(customProtection.toJSONString());
        }
        body.append("}");
        *//*


        Map<String, Object> customProtection = new MapBuilder()
                .put("AllowOfflineAccess", allowOfflineAccess)
                .put("ContentValidUntil", StringUtil.checkNull(contentValidUntil))
                .put("Rights", rights)
                .put("Users", users)
                .build();

        Map<String, Object> requestBody = new MapBuilder()
                .put("SystemId", StringUtil.checkNull(systemId))
                .put("Path", escapePath(StringUtil.checkNull(path)))
                .put("FileName", StringUtil.checkNull(fileName))
                .put("TenantId", StringUtil.checkNull(tenantId))
                .put("LabelId", StringUtil.checkNull(labelId))
                .put("CustomUserRights", customProtection)
                .build();

        String api = StringUtil.checkNull(DrmGlobalVal.DRM_MIP_API_URL) + "/api/MIPP/SetCustomProtection";
        return RestTemplateUtil.restTemplateWithPostMethod(api, requestBody, new ParameterizedTypeReference<Map<String, Object>>() {});
    }

    */
/**
     * UNC 경로로 customize
     * @param path
     * @return
     *//*

    private static String escapePath(String path) {
        if (path == null) return "";
        return path.replace("\\", "\\\\");
    }

}*/
