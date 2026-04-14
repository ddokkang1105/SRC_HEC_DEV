package xbolt.cmm.framework.util.drm;

import SCSL.SLDsFile;
import java.io.PrintStream;
import java.util.HashMap;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;

public class DRM_SOFTCAMP
{
  public static String FileTypeStr(int i)
  {
    String ret = null;
    switch (i) {
    case 20:
      ret = "�뙆�씪�쓣 李얠쓣 �닔 �뾾�뒿�땲�떎."; break;
    case 21:
      ret = "�뙆�씪 �궗�씠利덇� 0 �엯�땲�떎."; break;
    case 22:
      ret = "�뙆�씪�쓣 �씫�쓣 �닔 �뾾�뒿�땲�떎."; break;
    case 29:
      ret = "�븫�샇�솕 �뙆�씪�씠 �븘�떃�땲�떎."; break;
    case 26:
      ret = "FSD �뙆�씪�엯�땲�떎."; break;
    case 105:
      ret = "Wrapsody �뙆�씪�엯�땲�떎."; break;
    case 106:
      ret = "NX �뙆�씪�엯�땲�떎."; break;
    case 101:
      ret = "MarkAny �뙆�씪�엯�땲�떎."; break;
    case 104:
      ret = "INCAPS �뙆�씪�엯�땲�떎."; break;
    case 103:
      ret = "FSN �뙆�씪�엯�땲�떎.";
    }
    return ret;
  }

  public static String upload(HashMap drmInfoMap) throws ExceptionUtil
  {
    String returnValue = "";
    String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("ORGFileDir"), "");
    String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"), "");
    String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"), "");
    String FileRealName = StringUtil.checkNull(drmInfoMap.get("FileRealName"), "");

    String userID = StringUtil.checkNull(drmInfoMap.get("userLoginID"), "");
    String userName = StringUtil.checkNull(drmInfoMap.get("userName"), "");
    String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"), "");
    String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"), "");

    SLDsFile sFile = new SLDsFile();

    sFile.SettingPathForProperty("c:\\softcamp\\02_Module\\02_ServiceLinker\\softcamp.properties");

    int retVal = sFile.CreateDecryptFileDAC(
      "c:\\softcamp\\04_KeyFile\\keyDAC_SVR0.sc", 
      userID, 
      ORGFileDir.replace("//", "\\").replace("/", "\\") + FileRealName, 
      DRMFileDir.replace("//", "\\").replace("/", "\\") + Filename);
    System.out.println(" CreateDecryptFileDAC [" + retVal + "]");
    return returnValue;
  }

  public static String download(HashMap drmInfoMap) throws ExceptionUtil
  {
    String returnValue = "";

    System.out.println("start");

    String ORGFileDir = StringUtil.checkNull(drmInfoMap.get("downFile"), "").replace("//", "\\").replace("/", "\\");
    String DRMFileDir = StringUtil.checkNull(drmInfoMap.get("DRMFileDir"), "").replace("//", "\\").replace("/", "\\");
    String Filename = StringUtil.checkNull(drmInfoMap.get("Filename"), "");

    String userID = StringUtil.checkNull(drmInfoMap.get("userLoginID"), "");
    String userName = StringUtil.checkNull(drmInfoMap.get("userName"), "");
    String teamID = StringUtil.checkNull(drmInfoMap.get("teamID"), "");
    String teamName = StringUtil.checkNull(drmInfoMap.get("teamName"), "");

    SLDsFile sFile = new SLDsFile();
    sFile.SettingPathForProperty("c:\\softcamp\\02_Module\\02_ServiceLinker\\softcamp.properties");

    sFile.SLDsInitDAC();
    sFile.SLDsAddUserDAC("SECURITYDOMAIN", "111001101", 0, 0, 0);

    int ret = sFile.SLDsEncFileDACV2("c:\\softcamp\\04_KeyFile\\keyDAC_SVR0.sc", "Hway", ORGFileDir, StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH).replace("//", "\\").replace("/", "\\") + "\\" + Filename, 1);
    System.out.println("SLDsEncFileDAC :" + ret);
    return StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH) + "//" + Filename;
  }

  public static String report(HashMap drmInfoMap) throws ExceptionUtil {
    String returnValue = "";

    boolean bret = false;
    boolean nret = false;
    boolean iret = false;
    int fileType = 0;
    try {
      String filePath = StringUtil.checkNull(drmInfoMap.get("filePath"), "");
      if (filePath.equals("")) {
        filePath = FileUtil.FILE_EXPORT_DIR;
      }

      String filename_org = StringUtil.checkNull(drmInfoMap.get("orgFileName"));
      String userID = StringUtil.checkNull(drmInfoMap.get("userLoginID"), "");

      SLDsFile sFile = new SLDsFile();
      sFile.SettingPathForProperty("c:\\softcamp\\02_Module\\02_ServiceLinker\\softcamp.properties");

      sFile.SLDsInitDAC();
      sFile.SLDsAddUserDAC("SECURITYDOMAIN", "111001101", 0, 0, 0);

      int ret = sFile.SLDsEncFileDACV2("c:\\softcamp\\04_KeyFile\\keyDAC_SVR0.sc", "Hway", filePath.replace("//", "\\").replace("/", "\\") + filename_org, StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH).replace("//", "\\").replace("/", "\\") + "\\" + filename_org, 0);
      System.out.println("SLDsEncFileDAC :" + ret);
      returnValue = StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH) + "//" + filename_org;
    } catch (Exception e) {
      throw new ExceptionUtil(e.toString());
    }

    return returnValue;
  }
}