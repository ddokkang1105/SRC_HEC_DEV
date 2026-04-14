package xbolt.custom.hyundai.hec.web;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.nets.sso.agent.authcheck.AuthCheck;
import com.nets.sso.agent.configuration.SSOProvider;
import com.nets.sso.common.AgentExceptionCode;
import com.nets.sso.common.enums.AuthStatus;
import com.org.json.JSONArray;
import com.org.json.JSONObject;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Dictionary;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import javax.annotation.Resource;
import javax.imageio.ImageIO;
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
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import sun.misc.BASE64Decoder;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;

@Controller
public class HecActionController extends XboltController
{
  private final Log _log = LogFactory.getLog(getClass());

  @Resource(name="commonService")
  private CommonService commonService;

  @Resource(name="mdItemService")
  private CommonService mdItemService;

  @Resource(name="CSService")
  private CommonService CSService;

  @Resource(name="CSActionController")
  private CSActionController CSActionController;

  @RequestMapping({"/zHecProcMain.do"})
  public String zHecProcMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception { try { String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"), StringUtil.checkNull(cmmMap.get("itemID")));
      String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));
      Map setMap = new HashMap();
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), GlobalVal.DEFAULT_LANGUAGE);
      setMap.put("itemTypeCode", "OJ00001");
      setMap.put("categoryCode", "OJ");
      setMap.put("noMainItem", "Y");
      setMap.put("languageID", languageID);
      setMap.put("level", "0");
      setMap.put("itemClassCode", "CL01000");
      setMap.put("option", arcCode);

      List L0List = this.commonService.selectList("analysis_SQL.getL1List", setMap);

      String checkDim = this.commonService.selectString("item_SQL.selectCompanyID", setMap);

      if (!"".equals(checkDim)) {
        model.put("arcCode", arcCode);
      }

      model.put("L0List", L0List);
      model.put("defMenuItemID", defMenuItemID);
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e)
    {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    model.put("menu", getLabel(request, this.commonService));

    return nextUrl("/custom/hyundai/hec/subMain/zHecProcMain"); } 
  @RequestMapping({"/zHecSopMain.do"})
  public String zHecSopMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception { String scrnUrl = StringUtil.checkNull(cmmMap.get("scrnUrl"), "zHecSopMain");

    if ("".equals(scrnUrl))
      scrnUrl = "zHecSopMain";
    try
    {
      Map setMap = new HashMap();
      String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"), StringUtil.checkNull(cmmMap.get("itemID")));
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), GlobalVal.DEFAULT_LANGUAGE);
      String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));

      setMap.put("itemTypeCode", "OJ00005");
      setMap.put("categoryCode", "OJ");
      setMap.put("noMainItem", "Y");
      setMap.put("languageID", languageID);
      setMap.put("level", "0");
      setMap.put("itemClassCode", "CL05000");
      setMap.put("option", arcCode);

      List L0List = this.commonService.selectList("analysis_SQL.getL1List", setMap);

      String checkDim = StringUtil.checkNull(this.commonService.selectString("item_SQL.selectCompanyID", setMap));

      model.put("arcCode", arcCode);

      model.put("L0List", L0List);
      model.put("defMenuItemID", defMenuItemID);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    model.put("menu", getLabel(request, this.commonService));

    return nextUrl("/custom/hyundai/hec/subMain/" + scrnUrl); } 
  @RequestMapping({"/zHecStpMain.do"})
  public String zHecStpMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception { try { Map setMap = new HashMap();
      String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"), StringUtil.checkNull(cmmMap.get("itemID")));
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), GlobalVal.DEFAULT_LANGUAGE);
      String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));

      setMap.put("itemTypeCode", "OJ00016");
      setMap.put("categoryCode", "OJ");
      setMap.put("noMainItem", "Y");
      setMap.put("languageID", languageID);
      setMap.put("level", "0");
      setMap.put("itemClassCode", "CL16000");
      setMap.put("option", arcCode);

      List L0List = this.commonService.selectList("analysis_SQL.getL1List", setMap);

      String checkDim = this.commonService.selectString("item_SQL.selectCompanyID", setMap);

      if (!"".equals(checkDim)) {
        model.put("arcCode", arcCode);
      }

      model.put("L0List", L0List);
      model.put("defMenuItemID", defMenuItemID);
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e)
    {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    model.put("menu", getLabel(request, this.commonService));

    return nextUrl("/custom/hyundai/hec/subMain/zHecStpMain"); } 
  @RequestMapping({"/zHecCreateSubItemDiv.do"})
  public String zHecCreateSubItemDiv(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception { Map target = new HashMap();
    String url = "";
    int index = 0;
    try {
      Map setMap = new HashMap();
      String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
      String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));
      String level = StringUtil.checkNull(cmmMap.get("level"));
      String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), GlobalVal.DEFAULT_LANGUAGE);
      String itemClassCode = StringUtil.checkNull(cmmMap.get("itemClassCode"));
      String listText = "";

      setMap.put("itemID", itemID);
      setMap.put("languageID", languageID);
      setMap.put("itemClassCode", itemClassCode);

      setMap.put("option", arcCode);
      String checkDim = StringUtil.checkNull(this.commonService.selectString("item_SQL.selectCompanyID", setMap));

      if (!"".equals(checkDim)) {
        setMap.put("arcCode", arcCode);
      }
      else {
        arcCode = "";
      }
      setMap.put("index", Integer.valueOf(index));

      List subList = this.commonService.selectList("custom_SQL.zhec_GetSubItemIDListForFromItemID", setMap);

      if ((subList != null) && (!subList.isEmpty())) {
        for (int i = 0; i < subList.size(); i++) {
          Map tempMap = (HashMap)subList.get(i);

          if (i == 0) {
            listText = StringUtil.checkNull(tempMap.get("ItemID")) + "_" + 
              StringUtil.checkNull(tempMap.get("PlainText")) + "_" + 
              StringUtil.checkNull(tempMap.get("Level")) + "_" + 
              StringUtil.checkNull(tempMap.get("FileCount")) + "_" + 
              StringUtil.checkNull(tempMap.get("SubCount"));
          }
          else {
            listText = listText + "@" + StringUtil.checkNull(tempMap.get("ItemID")) + "_" + 
              StringUtil.checkNull(tempMap.get("PlainText")) + "_" + 
              StringUtil.checkNull(tempMap.get("Level")) + "_" + 
              StringUtil.checkNull(tempMap.get("FileCount")) + "_" + 
              StringUtil.checkNull(tempMap.get("SubCount"));
          }

          int cnt = Integer.parseInt(StringUtil.checkNull(tempMap.get("ChdCount")));

          if (cnt > 0) {
            listText = listText + setChildeItemList(StringUtil.checkNull(tempMap.get("ItemID")), arcCode, languageID, level, index + 1, itemClassCode);
          }
        }
      }
      target.put("SCRIPT", "createSubItemDiv('" + listText + "');$('#isSubmit').remove();");
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); }

  public String setChildeItemList(String itemID, String arcCode, String languageID, String level, int index, String itemClassCode) throws Exception
  {
    Map target = new HashMap();
    String listText = "";
    try
    {
      if (index > Integer.parseInt(level)) {
        return listText;
      }

      Map setMap = new HashMap();

      setMap.put("itemID", itemID);
      setMap.put("languageID", languageID);
      setMap.put("arcCode", arcCode);
      setMap.put("index", Integer.valueOf(index));
      setMap.put("itemClassCode", itemClassCode);

      List subList = this.commonService.selectList("custom_SQL.zhec_GetSubItemIDListForFromItemID", setMap);

      if ((subList != null) && (!subList.isEmpty())) {
        for (int i = 0; i < subList.size(); i++) {
          Map tempMap = (HashMap)subList.get(i);

          listText = listText + "@" + StringUtil.checkNull(tempMap.get("ItemID")) + "_" + 
            StringUtil.checkNull(tempMap.get("PlainText")) + "_" + 
            StringUtil.checkNull(tempMap.get("Level")) + "_" + 
            StringUtil.checkNull(tempMap.get("FileCount")) + "_" + 
            StringUtil.checkNull(tempMap.get("SubCount"));

          int cnt = Integer.parseInt(StringUtil.checkNull(tempMap.get("ChdCount")));

          if (cnt > 0) {
            listText = listText + setChildeItemList(StringUtil.checkNull(tempMap.get("ItemID")), arcCode, languageID, level, index + 1, itemClassCode);
          }
        }
      }
    }
    catch (Exception e)
    {
      System.out.println(e);
    }

    return listText; } 
  @RequestMapping({"/zhecOwnerItemList.do"})
  public String zhecOwnerItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { try { List returnData = new ArrayList();
      model.put("s_itemID", request.getParameter("s_itemID"));
      model.put("regFlg", request.getParameter("regFlg"));
      model.put("pageNum", request.getParameter("pageNum"));
      model.put("option", request.getParameter("option"));
      model.put("ownerType", request.getParameter("ownerType"));
      model.put("teamID", request.getParameter("teamID"));
      model.put("statusList", request.getParameter("statusList"));
      model.put("status", StringUtil.checkNull(request.getParameter("status"), ""));
      model.put("teamManagerID", request.getParameter("teamManagerID"));
      model.put("srID", request.getParameter("srID"));
      model.put("showTOJ", StringUtil.checkNull(commandMap.get("showTOJ")));
      model.put("accMode", StringUtil.checkNull(commandMap.get("accMode"), "DEV"));
      model.put("scrnMode", StringUtil.checkNull(commandMap.get("scrnMode"), "E"));
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e)
    {
      System.out.println(e.toString());
    }
    return nextUrl("/custom/hyundai/hec/zhecOwnerItemList"); } 
  @RequestMapping({"/zhec_saveItemInfo.do"})
  public String zhec_saveItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { HashMap target = new HashMap();
    try
    {
      String scrnMode = request.getParameter("scrnMode");
      String plainText = StringUtil.checkNull(commandMap.get("AT00501"));

      String spliteParam = "<img ";
      String replaceStartParam = "src=\"data:image/png;base64,";
      String replaceEndParam = "/>";
      String changImgSrc = spliteParam + " border='0' src=\"";
      String findEndParam = "/>";

      String usrK = StringUtil.checkNull(commandMap.get("sessionUserId"));

      if (!"".equals(plainText)) {
        String value = plainText;
        String uploadFileName = "";
        String uploadPath = GlobalVal.FILE_UPLOAD_TINY_DIR;
        String[] replaceValues = value.split(spliteParam);
        String changeValue = "";
        if (replaceValues.length > 1) {
          changeValue = replaceValues[0];
          for (int i = 1; i < replaceValues.length; i++) {
            String fileUrl = "upload/";
            String replaceValue = replaceValues[i];
            int endIndex = replaceValue.indexOf(replaceEndParam);
            if (replaceValue.indexOf(replaceStartParam) > -1) {
              String imageString = replaceValue.substring(replaceStartParam.length(), endIndex - 3);
              uploadFileName = DateUtil.getSysYearSecond() + usrK + i + ".png";
              fileUrl = fileUrl + uploadFileName;
              changeValue = changeValue + " " + changImgSrc + GlobalVal.OLM_SERVER_URL + fileUrl + "\"" + replaceValue.substring(endIndex - 1, replaceValue.length());

              File uploadDir = new File(uploadPath);
              if (!uploadDir.exists()) {
                uploadDir.mkdir();
              }

              BufferedImage image = null;

              BASE64Decoder decoder = new BASE64Decoder();
              byte[] imageByte = decoder.decodeBuffer(imageString);
              ByteArrayInputStream bis = new ByteArrayInputStream(imageByte);
              image = ImageIO.read(bis);
              bis.close();

              File outputfile = new File(uploadPath, uploadFileName);
              ImageIO.write(image, "png", outputfile);
            } else {
              changeValue = changeValue + spliteParam + replaceValue;
            }
          }

          commandMap.put("AT00501", changeValue);
        }
      } else {
        commandMap.put("AT00501", plainText);
      }

      if (scrnMode.equals("N")) {
        target = zhec_CreateItemFunction(request, commandMap, model);
      }
      else if (scrnMode.equals("D")) {
        target = zhec_DeleteItemFunction(request, commandMap, model);
      }
      else
      {
        target = zhec_UpdateItemFunction(request, commandMap, model);
      }
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); } 
  @RequestMapping({"/zhec_saveProcWfInfo.do"})
  public String zhec_saveProcWfInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { HashMap target = new HashMap();
    try
    {
      String itemId = StringUtil.checkNull(request.getParameter("s_itemID"));
      String Description = StringUtil.checkNull(request.getParameter("Description"));
      String Reason = StringUtil.checkNull(request.getParameter("Reason"));

      Map setValue = new HashMap();

      setValue.put("s_itemID", itemId);
      String changeSetID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemCurChangeSet", setValue));

      setValue.put("s_itemID", changeSetID);
      setValue.put("Description", Description);
      setValue.put("Reason", Reason);
      this.commonService.update("cs_SQL.updateChangeSet", setValue);

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnCallBack()");
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); }

  public HashMap zhec_DeleteItemFunction(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception
  {
    HashMap target = new HashMap();
    try
    {
      String itemId = StringUtil.checkNull(request.getParameter("s_itemID"));
      String Description = StringUtil.checkNull(request.getParameter("Description"));
      String Reason = StringUtil.checkNull(request.getParameter("Reason"));

      Map setValue = new HashMap();
      setValue.put("ItemID", itemId);
      setValue.put("Status", "DEL1");
      this.commonService.update("item_SQL.updateItemObjectInfo", setValue);

      setValue.put("s_itemID", itemId);
      String changeSetID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemCurChangeSet", setValue));

      setValue.put("s_itemID", changeSetID);
      setValue.put("Description", Description);
      setValue.put("Reason", Reason);
      setValue.put("ChangeType", "DEL");
      this.commonService.update("cs_SQL.updateChangeSet", setValue);

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnEditCallBack()");
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    return target;
  }

  public HashMap zhec_UpdateItemFunction(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    HashMap target = new HashMap();
    try
    {
      String setInfo = "";
      String itemId = StringUtil.checkNull(request.getParameter("s_itemID"));
      String option = StringUtil.checkNull(request.getParameter("option"));
      String identifier = StringUtil.checkNull(request.getParameter("Identifier"));
      String Description = StringUtil.checkNull(request.getParameter("Description"));
      String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
      String itemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"));
      String Reason = StringUtil.checkNull(request.getParameter("Reason"));
      String plantYN = "N";
      Map setValue = new HashMap();
      setValue.put("ItemID", itemId);
      setValue.put("Identifier", identifier);

      String itemCount = "0";

      if (!itemCount.equals("0")) {
        setValue.put("languageID", request.getParameter("languageID"));

        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081", new String[] { this.commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue) }));
        target.put("SCRIPT", "parent.$('#isSubmit').remove();");
      }
      else
      {
        setValue.put("languageID", request.getParameter("languageID"));
        setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
        setValue.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));

        if (!request.getParameter("AT00001").isEmpty()) {
          setValue.put("AttrTypeCode", "AT00001");
          setValue.put("PlainText", request.getParameter("AT00001"));
          setInfo = GetItemAttrList.attrUpdate(this.commonService, setValue);
        }

        setValue.put("Identifier", identifier);
        setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
        setValue.put("CompanyID", StringUtil.checkNull(request.getParameter("companyCode")));
        setValue.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("ownerTeamCode")));
        setValue.put("Version", StringUtil.checkNull(request.getParameter("Version")));
        setValue.put("AuthorID", StringUtil.checkNull(request.getParameter("AuthorID")));
        setValue.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));

        this.commonService.update("item_SQL.updateItemObjectInfo", setValue);

        List returnData = new ArrayList();

        commandMap.put("Editable", "1");
        returnData = this.commonService.selectList("attr_SQL.getItemAttr", commandMap);

        Map setMap = new HashMap();
        String dataType = "";
        String mLovValue = "";
        String html = "";
        for (int i = 0; i < returnData.size(); i++) {
          setMap = (HashMap)returnData.get(i);
          dataType = StringUtil.checkNull(setMap.get("DataType"));
          html = StringUtil.checkNull(setMap.get("HTML"));
          if (!dataType.equals("Text")) {
            if (dataType.equals("MLOV")) {
              String[] reqMLovValue = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode"))).split(",");
              Map delData = new HashMap();
              delData.put("ItemID", itemId);
              delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
              this.commonService.delete("attr_SQL.delItemAttr", delData);
              for (int j = 0; j < reqMLovValue.length; j++) {
                mLovValue = reqMLovValue[j].toString();
                setMap.put("PlainText", mLovValue);
                setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
                setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
                setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
                setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
                setMap.put("LovCode", mLovValue);
                setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
              }
            } else {
              Map delData = new HashMap();

              setMap.put("PlainText", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
              setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
              setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
              setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
              setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
              setMap.put("LovCode", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
              setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
            }
          } else {
            String plainText = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")), "");
            if (html.equals("1"))
            {
              plainText = StringEscapeUtils.escapeHtml4(plainText);
            }
            setMap.put("PlainText", plainText);
            setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
            setMap.put("languageID", request.getParameter("languageID"));
            setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
            setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
            setMap.put("LovCode", StringUtil.checkNull(this.commonService.selectString("attr_SQL.selectAttrLovCode", setMap), ""));
            setInfo = GetItemAttrList.attrUpdate(this.commonService, setMap);
          }
        }
        setMap.put("s_itemID", itemId);
        String changeSetID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemCurChangeSet", setMap));
        setMap.put("s_itemID", changeSetID);
        setMap.put("Description", Description);
        setMap.put("Reason", Reason);
        this.commonService.update("cs_SQL.updateChangeSet", setMap);

        String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
        String dimTypeValueID = StringUtil.checkNull(request.getParameter("dimTypeValueID"));
        if ((!dimTypeID.equals("")) && (!dimTypeValueID.equals(""))) {
          String[] temp = dimTypeValueID.split(",");
          Map setData = new HashMap();
          setData.put("s_itemID", itemId);
          setData.put("DimTypeID", dimTypeID);
          this.commonService.update("dim_SQL.delSubDimValue", setData);

          for (int i = 0; i < temp.length; i++) {
            setData.put("ItemTypeCode", itemTypeCode);
            setData.put("ItemClassCode", itemClassCode);
            setData.put("ItemID", itemId);
            setData.put("DimTypeID", dimTypeID);
            setData.put("DimValueID", temp[i]);
            this.commonService.update("dim_SQL.insertItemDim", setData);
          }
        }

        HashMap drmInfoMap = new HashMap();
        List fileList = new ArrayList();

        String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
        String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
        String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
        String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));

        drmInfoMap.put("userID", userID);
        drmInfoMap.put("userName", userName);
        drmInfoMap.put("teamID", teamID);
        drmInfoMap.put("teamName", teamName);
        int seqCnt = 0;
        String fltpCode = "FLTP003";

        if (itemTypeCode.equals("OJ00016")) {
          fltpCode = "FLTP1601";
        }

        setMap.put("fltpCode", fltpCode);
        String fltpPath = StringUtil.checkNull(this.commonService.selectString("fileMgt_SQL.getFilePath", setMap));
        seqCnt = Integer.parseInt(this.commonService.selectString("fileMgt_SQL.itemFile_nextVal", setMap));

        String orginPath = GlobalVal.FILE_UPLOAD_ITEM_DIR + StringUtil.checkNull(commandMap.get("sessionUserId")) + "//";

        String targetPath = fltpPath;
        List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);

        if (tmpFileList != null) {
          for (int i = 0; i < tmpFileList.size(); i++) {
            HashMap fileMap = new HashMap();
            HashMap resultMap = (HashMap)tmpFileList.get(i);
            fileMap.put("Seq", Integer.valueOf(seqCnt));
            fileMap.put("DocumentID", itemId);
            fileMap.put("FileName", resultMap.get("SysFileNm"));
            fileMap.put("FileRealName", resultMap.get("FileNm"));
            fileMap.put("FileSize", resultMap.get("FileSize"));
            fileMap.put("FilePath", fltpPath);
            fileMap.put("FltpCode", fltpCode);
            fileMap.put("ChangeSetID", changeSetID);
            fileMap.put("ItemID", itemId);
            fileMap.put("FileMgt", "ITM");
            fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
            fileMap.put("userId", userID);
            fileMap.put("projectID", commandMap.get("projectId"));
            fileMap.put("DocCategory", "ITM");
            fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");

            String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
            if ((useDRM != null) && (useDRM != ""))
            {
              drmInfoMap.put("ORGFileDir", orginPath);
              drmInfoMap.put("DRMFileDir", targetPath);
              drmInfoMap.put("Filename", resultMap.get("SysFileNm"));
              drmInfoMap.put("FileRealName", resultMap.get("FileNm"));
              drmInfoMap.put("funcType", "upload");
              String str1 = DRMUtil.drmMgt(drmInfoMap);
            }

            fileList.add(fileMap);
            seqCnt++;
          }
          commandMap.put("KBN", "insert");
          this.CSService.save(fileList, commandMap);

          String orgTeamID = StringUtil.checkNull(commandMap.get("orgTeamIDs"));
          String[] teamIDs = orgTeamID.split(",");
          String teamNames = StringUtil.checkNull(commandMap.get("orgNames"));

          HashMap teamData = new HashMap();
          teamData.put("itemID", itemId);
          teamData.put("teamRoleType", "REL");
          teamData.put("assigned", "1");
          teamData.put("creator", commandMap.get("sessionUserId"));
          teamData.put("languageID", commandMap.get("sessionCurrLangType"));
          teamData.put("teamRoleCat", "TEAMROLETP");
          Object teamRoleList = new ArrayList();

          if ((!"".equals(orgTeamID)) && (teamIDs != null) && (teamIDs.length > 0)) {
            teamData.put("ItemID", itemId);
            List teamList = this.commonService.selectList("role_SQL.getItemTeamRoleList_gridList", teamData);

            if ((teamList != null) && (!teamList.isEmpty())) {
              for (int i = 0; i < teamList.size(); i++) {
                Map tempMap = (Map)teamList.get(i);
                teamData.put("teamRoleIDs", StringUtil.checkNull(tempMap.get("TeamRoleID")));
                this.commonService.update("role_SQL.deleteTeamRole", teamData);
              }
            }

            for (int i = 0; i < teamIDs.length; i++)
            {
              if ((!"".equals(teamIDs[i])) && (!"0".equals(teamIDs[i]))) {
                teamData.put("teamID", teamIDs[i]);
                teamRoleList = this.commonService.selectList("role_SQL.getTeamRoleIDList", teamData);

                this.commonService.insert("role_SQL.insertTeamRole", teamData);
              }
            }
          }
          else if ("".equals(teamNames)) {
            teamData.put("ItemID", itemId);
            List teamList = this.commonService.selectList("role_SQL.getItemTeamRoleList_gridList", teamData);

            if ((teamList != null) && (!teamList.isEmpty())) {
              for (int i = 0; i < teamList.size(); i++) {
                Map tempMap = (Map)teamList.get(i);
                teamData.put("teamRoleIDs", StringUtil.checkNull(tempMap.get("TeamRoleID")));
                this.commonService.update("role_SQL.deleteTeamRole", teamData);
              }
            }
          }

          setMap.put("s_itemID", itemId);
          String parentid = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemParentID", setMap));

          setMap.put("s_itemID", itemId);
          String loItemID = "123850";
          String cnxType = "CNL0105";

          if (itemTypeCode.equals("OJ00016")) {
            loItemID = "133167";
            cnxType = "CNL0116";
          }

          setMap.put("itemID", parentid);
          setMap.put("l0ItemID", loItemID);
          String l0Cnt = StringUtil.checkNull(this.commonService.selectString("custom_SQL.zhec_GetL0ItemIDCnt", setMap), "0");

          if (!"0".equals(l0Cnt)) {
            setMap.put("classCode", cnxType);
            setMap.put("toItemID", itemId);
            List cxnList = this.commonService.selectList("item_SQL.getCxnItemIDList", setMap);

            if ((cxnList != null) && (!cxnList.isEmpty())) {
              plantYN = "N";
            }
            else {
              plantYN = "Y";
            }
          }

          String path = GlobalVal.FILE_UPLOAD_ITEM_DIR + commandMap.get("sessionUserId");
          if (!path.equals("")) FileUtil.deleteDirectory(path);
        }

        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
        target.put("SCRIPT", "parent.fnEditCallBack('" + plantYN + "')");
      }
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    return (HashMap)target;
  }

  public HashMap zhec_CreateItemFunction(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map setMap = new HashMap();
    Map insertCngMap = new HashMap();
    Map updateData = new HashMap();
    HashMap target = new HashMap();
    try
    {
      Map setValue = new HashMap();
      String autoID = StringUtil.checkNull(request.getParameter("autoID"));
      String preFix = StringUtil.checkNull(request.getParameter("preFix"));
      String cpItemID = StringUtil.checkNull(request.getParameter("cpItemID"));
      String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));
      String fromItemID = StringUtil.checkNull(commandMap.get("parentID"));
      String mstSTR = StringUtil.checkNull(request.getParameter("mstSTR"));
      String option = StringUtil.checkNull(request.getParameter("option"));
      String scrnMode = StringUtil.checkNull(request.getParameter("scrnMode"));

      String ItemID = this.commonService.selectString("item_SQL.getItemMaxID", setMap);

      if (!"".equals(s_itemID)) {
        setValue.put("ItemID", request.getParameter("s_itemID"));
      }
      else {
        setValue.put("ItemID", ItemID);
      }

      setMap.put("s_itemID", fromItemID);
      String maxIdentifier = "[최종 승인 후 채번예정]";

      setValue.put("Identifier", "[최종 승인 후 채번예정]");

      String itemCount = "0";
      String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
      String itemClassCode = "";

      if (itemTypeCode.equals("OJ00005")) {
        itemClassCode = "CL05003";
      }
      else if (itemTypeCode.equals("OJ00016")) {
        itemClassCode = "CL16004";
      }

      setMap.put("itemClassCode", itemClassCode);
      setMap.put("itemTypeCode", itemTypeCode);
      setMap.put("userID", StringUtil.checkNull(commandMap.get("sessionUserId")));
      String projectID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemClassDefCSRID", setMap));

      if (!itemCount.equals("0")) {
        setValue.put("languageID", commandMap.get("sessionCurrLangType"));

        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081", new String[] { this.commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue) }));
        target.put("SCRIPT", "parent.$('#isSubmit').remove();");
      }
      else
      {
        setMap.put("option", StringUtil.checkNull(request.getParameter("option")));
        setMap.put("Version", "0");
        setMap.put("Deleted", "0");
        setMap.put("Creator", StringUtil.checkNull(commandMap.get("sessionUserId")));
        setMap.put("CategoryCode", "TOJ");
        setMap.put("ClassCode", itemClassCode);
        setMap.put("OwnerTeamId", StringUtil.checkNull(commandMap.get("sessionTeamId")));
        setMap.put("Identifier", maxIdentifier);
        setMap.put("ItemID", ItemID);
        if (itemTypeCode.equals("")) {
          itemTypeCode = this.commonService.selectString("item_SQL.selectedItemTypeCode", setMap);
        }
        setMap.put("ItemTypeCode", itemTypeCode);

        setMap.put("AuthorID", StringUtil.checkNull(commandMap.get("sessionUserId")));
        setMap.put("IsPublic", StringUtil.checkNull(request.getParameter("IsPublic")));
        setMap.put("ProjectID", projectID);
        setMap.put("RefItemID", StringUtil.checkNull(request.getParameter("refItemID")));
        setMap.put("Status", "NEW1");

        setMap.put("itemId", StringUtil.checkNull(request.getParameter("s_itemID")));

        this.commonService.insert("item_SQL.insertItem", setMap);
        setMap.remove("CurChangeSet");

        setMap.put("PlainText", StringUtil.checkNull(request.getParameter("AT00001")));
        setMap.put("AttrTypeCode", "AT00001");
        List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setMap);
        for (int i = 0; i < getLanguageList.size(); i++) {
          Map getMap = (HashMap)getLanguageList.get(i);
          setMap.put("languageID", getMap.get("CODE"));
          this.commonService.insert("item_SQL.ItemAttr", setMap);
        }

        if (((!cpItemID.equals("")) && (mstSTR.equals("Y"))) || (cpItemID.equals(""))) {
          setMap.put("CategoryCode", "ST1");
          setMap.put("ClassCode", "NL00000");
          setMap.put("ToItemID", setMap.get("ItemID"));
          if (fromItemID.equals(""))
            setMap.put("FromItemID", s_itemID);
          else {
            setMap.put("FromItemID", fromItemID);
          }
          setMap.put("ItemID", this.commonService.selectString("item_SQL.getItemMaxID", setMap));

          setMap.remove("RefItemID");
          setMap.remove("Identifier");
          setMap.put("ItemTypeCode", this.commonService.selectString("item_SQL.selectedConItemTypeCode", setMap));
          this.commonService.insert("item_SQL.insertItem", setMap);
        }

        setMap.put("ItemID", ItemID);
        String changeMgt = StringUtil.checkNull(this.commonService.selectString("project_SQL.getChangeMgt", setMap));
        if (changeMgt.equals("1"))
        {
          insertCngMap.put("itemID", ItemID);
          insertCngMap.put("userId", StringUtil.checkNull(commandMap.get("sessionUserId")));
          insertCngMap.put("projectId", projectID);
          insertCngMap.put("classCode", itemClassCode);
          insertCngMap.put("KBN", "insertCNG");
          insertCngMap.put("Reason", StringUtil.checkNull(commandMap.get("Reason")));
          insertCngMap.put("Description", StringUtil.checkNull(commandMap.get("Description")));
          insertCngMap.put("status", "MOD");
          insertCngMap.put("version", "0");
          this.CSService.save(new ArrayList(), insertCngMap);
        } else if (!changeMgt.equals("1"))
        {
          setMap.put("itemID", s_itemID);
          String sItemIDCurChangeSetID = StringUtil.checkNull(this.commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap));
          if (!sItemIDCurChangeSetID.equals("")) {
            updateData = new HashMap();
            updateData.put("CurChangeSet", sItemIDCurChangeSetID);
            updateData.put("s_itemID", ItemID);
            this.commonService.update("project_SQL.updateItemStatus", updateData);
          }

        }

        String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
        String dimTypeValueID = StringUtil.checkNull(request.getParameter("dimTypeValueID"));
        if ((!dimTypeID.equals("")) && (!dimTypeValueID.equals(""))) {
          String[] temp = dimTypeValueID.split(",");
          Map setData = new HashMap();

          for (int i = 0; i < temp.length; i++) {
            setData.put("ItemTypeCode", itemTypeCode);
            setData.put("ItemClassCode", itemClassCode);
            setData.put("ItemID", ItemID);
            setData.put("DimTypeID", dimTypeID);
            setData.put("DimValueID", temp[i]);
            this.commonService.update("dim_SQL.insertItemDim", setData);
          }
        }

        HashMap insertData = new HashMap();

        String[] teamIDs = StringUtil.checkNull(request.getParameter("orgTeamIDs")).split(",");

        insertData.put("itemID", ItemID);
        insertData.put("teamRoleType", "REL");
        insertData.put("assigned", "1");
        insertData.put("creator", commandMap.get("sessionUserId"));
        insertData.put("teamRoleCat", "TEAMROLETP");
        List teamRoleList = new ArrayList();
        for (int i = 0; i < teamIDs.length; i++)
        {
          if ((!"".equals(teamIDs[i])) && (!"0".equals(teamIDs[i]))) {
            insertData.put("teamID", teamIDs[i]);
            teamRoleList = this.commonService.selectList("role_SQL.getTeamRoleIDList", insertData);
            if (teamRoleList.size() == 0) {
              this.commonService.insert("role_SQL.insertTeamRole", insertData);
            }
          }
        }

        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));

        target.put("SCRIPT", "parent.fnRefreshPage('" + option + "','" + ItemID + "', 'E')");
      }
    }
    catch (Exception e)
    {
      System.out.println(e);
      target.put("SCRIPT", "this.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    return target;
  }

  public void copyModel(HashMap commandMap, ModelMap model, Map itemInfoMap) throws Exception {
    String newItemID = StringUtil.checkNull(itemInfoMap.get("newItemID"), "");
    String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
    String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
    String modelGUBUN = StringUtil.checkNull(commandMap.get("modelGUBUN"), "");
    if (modelGUBUN.equals("")) modelGUBUN = "copy";

    Map setData = new HashMap();

    setData.put("orgModelID", StringUtil.checkNull(commandMap.get("modelID")));
    setData.put("includeItemMaster", StringUtil.checkNull(commandMap.get("includeItemMaster")));
    setData.put("newModelName", StringUtil.checkNull(commandMap.get("newModelName")));
    setData.put("newMTCTypeCode", StringUtil.checkNull(commandMap.get("MTCTypeCode")));
    setData.put("newModelTypeCode", StringUtil.checkNull(commandMap.get("ModelTypeCode")));
    setData.put("LanguageID", languageID);
    setData.put("Creator", userID);
    setData.put("ItemID", newItemID);
    setData.put("checkElmts", StringUtil.checkNull(commandMap.get("checkElmts")));
    setData.put("itemID", newItemID);
    setData.put("projectID", StringUtil.checkNull(commandMap.get("csrInfo")));
    setData.put("changeSetID", StringUtil.checkNull(this.commonService.selectString("item_SQL.getCurChangeSet", setData)));
    setData.put("mstSTR", StringUtil.checkNull(commandMap.get("mstSTR")));
    setData.put("checkElmts", StringUtil.checkNull(commandMap.get("checkElmts"), ""));
    setData.put("ModelName", StringUtil.checkNull(commandMap.get("newModelName"), ""));
    setData.put("GUBUN", modelGUBUN);

    this.mdItemService.save(setData);
  }

  public void copyItemInfo(HashMap commandMap, ModelMap model, Map itemInfoMap) throws Exception
  {
    String s_itemID = StringUtil.checkNull(itemInfoMap.get("s_itemID"), "");
    String cpItemID = StringUtil.checkNull(itemInfoMap.get("cpItemID"), "");
    String newItemID = StringUtil.checkNull(itemInfoMap.get("newItemID"), "");
    String newItemName = StringUtil.checkNull(itemInfoMap.get("newItemName"), "");

    String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
    String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
    String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
    String projectID = StringUtil.checkNull(itemInfoMap.get("ProjectID"), "");
    Map setData = new HashMap();

    setData.put("cpItemID", cpItemID);
    setData.put("newItemID", newItemID);
    this.commonService.insert("item_SQL.copyItemAttr", setData);

    setData = new HashMap();
    setData.put("fromItemID", cpItemID);
    setData.put("userID", userID);
    setData.put("OwnerTeamId", teamID);
    setData.put("categoryCode", "CN");
    setData.put("projectID", projectID);

    List toCxnList = this.commonService.selectList("item_SQL.getCxnItemIDList", setData);
    if (toCxnList.size() > 0) {
      for (int k = 0; k < toCxnList.size(); k++) {
        Map toCxnMap = (Map)toCxnList.get(k);
        String cxnItemID = StringUtil.checkNull(toCxnMap.get("ItemID"));

        setData.put("newItemID", this.commonService.selectString("item_SQL.getItemMaxID", setData));
        setData.put("fromItemID", newItemID);
        setData.put("cpItemID", cxnItemID);
        setData.put("userID", userID);
        setData.put("status", "NEW1");
        this.commonService.insert("item_SQL.copyItem", setData);
      }
    }

    setData = new HashMap();
    setData.put("toItemID", cpItemID);
    setData.put("userID", userID);
    setData.put("OwnerTeamId", teamID);
    setData.put("categoryCode", "CN");
    List fromCxnList = this.commonService.selectList("item_SQL.getCxnItemIDList", setData);
    if (fromCxnList.size() > 0)
      for (int l = 0; l < fromCxnList.size(); l++) {
        Map fromCxnMap = (Map)fromCxnList.get(l);
        String cxnItemID = StringUtil.checkNull(fromCxnMap.get("ItemID"));

        setData.put("newItemID", this.commonService.selectString("item_SQL.getItemMaxID", setData));
        setData.put("toItemID", newItemID);
        setData.put("orgItemID", cxnItemID);
        setData.put("status", "NEW1");
        this.commonService.insert("item_SQL.copyItem", setData);
      }
  }

  @RequestMapping({"/zhec_WFDocMgt.do"})
  public String zhec_WFDocMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    String url = "/custom/hyundai/hec/wf/zhec_goWorkflow";
    Map setMap = new HashMap();
    HashMap autoWayMap = new HashMap();
    String wfUrl = "";
    try {
      String isNew = StringUtil.checkNull(request.getParameter("isNew"));
      String wfStep = StringUtil.checkNull(request.getParameter("wfStep"));
      String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
      String isMulti = StringUtil.checkNull(request.getParameter("isMulti"));
      String wfStepInfo = StringUtil.checkNull(request.getParameter("wfStep"), "WF001");
      String wfDocType = StringUtil.checkNull(request.getParameter("wfDocType"), "CS");
      String wfDocumentIDs = StringUtil.checkNull(request.getParameter("wfDocumentIDs"));
      String isPop = StringUtil.checkNull(request.getParameter("isPop"), "N");
      String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"));
      String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID"));
      String preWfInstanceID = StringUtil.checkNull(request.getParameter("preWfInstanceID"));
      String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"));
      String actionType = StringUtil.checkNull(request.getParameter("actionType"), "create");
      String isView = StringUtil.checkNull(request.getParameter("isView"), "Y");
      String backFunction = "wfInstanceList.do";
      String backMessage = "";
      String callbackData = "&wfMode=AREQ&screenType=MyPg&wfStepID=AREQ";
      String returnedValue = "";
      String isProc = StringUtil.checkNull(request.getParameter("isProc"), "Y");

      if ("Y".equals(isProc)) {
        url = "/custom/hyundai/hec/wf/zhec_goProcess";
        String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), GlobalVal.DEFAULT_LANGUAGE);
        setMap.put("ChangeSetID", changeSetID);
        setMap.put("languageID", languageID);
        Map getPJTMap = this.commonService.select("wf_SQL.getChangeSetInfoWF", setMap);

        setMap.put("changeSetID", changeSetID);
        String itemID = StringUtil.checkNull(this.commonService.selectString("task_SQL.getCsrItemID", setMap));

        List itemPath = new ArrayList();

        itemPath = getRootItemPath(itemID, StringUtil.checkNull(commandMap.get("languageID")), itemPath);
        Collections.reverse(itemPath);

        String itemPathName = "";
        if ((itemPath != null) && (!itemPath.isEmpty())) {
          for (int i = 0; i < itemPath.size(); i++) {
            Map temp = (Map)itemPath.get(i);

            if (i == 0) {
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

      if (!"".equals(wfInstanceID)) {
        setMap.put("wfInstanceID", wfInstanceID);
        returnedValue = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWfReturnedValue", setMap));
      }

      if ((!"".equals(wfInstanceID)) && (!"".equals(returnedValue)) && ("Y".equals(isView)))
      {
        autoWayMap.put("dftCompId", "H139");
        autoWayMap.put("lgyDocId", wfInstanceID);
        autoWayMap.put("LangType", "ko-KR");
        autoWayMap.put("lgySystemId", "H-WAY");
        autoWayMap.put("dftUserId", commandMap.get("sessionLoginId"));
        autoWayMap.put("dftDeptCode", "");
        autoWayMap.put("PID", returnedValue);
        wfUrl = "https://autowaywf.hyundai.net/HECWebService/ExternalWebService.asmx?wsdl";

        String wfData = viewWfCreateXML(wfUrl, autoWayMap);

        if (!"".equals(wfData)) {
          JSONObject jo1 = new JSONObject(wfData);

          String returnUrl = StringUtil.checkNull(jo1.get("returnURL"));
          String resultCode = StringUtil.checkNull(jo1.get("resultCode"));
          String errMsg = StringUtil.checkNull(jo1.get("errMsg"));

          model.put("returnUrl", returnUrl);
          model.put("resultCode", resultCode);
          model.put("errMsg", errMsg);
        }
        else
        {
          model.put("returnUrl", "");
          model.put("resultCode", "E");
          model.put("errMsg", "Error");
        }
      }
      else
      {
        if ("".equals(projectID)) {
          setMap.put("s_itemID", changeSetID);
          projectID = this.commonService.selectString("cs_SQL.getProjectIDForCSID", setMap);
        }

        Map labelMap = getLabel(request, this.commonService);

        String newWFInstanceID = "";
        String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), GlobalVal.DEFAULT_LANGUAGE);
        String maxWFInstanceID = this.commonService.selectString("wf_SQL.MaxWFInstanceID", setMap);
        String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
        int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();
        String initLen = "%0" + (13 - OLM_SERVER_NAME_LENGTH) + "d";

        int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
        int maxcode = maxWFInstanceID2 + 1;
        newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, new Object[] { Integer.valueOf(maxcode) });

        if (!"".equals(preWfInstanceID)) {
          wfInstanceID = preWfInstanceID;
        }

        setMap.put("LanguageID", commandMap.get("languageID"));
        setMap.put("WFID", wfStepInfo);
        setMap.put("TypeCode", wfStepInfo);
        setMap.put("ProjectID", projectID);

        List wfStepList = this.commonService.selectList("wf_SQL.getWfStepList", setMap);

        String wfDescription = this.commonService.selectString("wf_SQL.getWFDescription", setMap);
        String MandatoryGRID = this.commonService.selectString("wf_SQL.getMandatoryGRID", setMap);

        setMap.put("languageID", commandMap.get("sessionCurrLangType"));
        setMap.put("projectID", projectID);
        String ProjectName = this.commonService.selectString("project_SQL.getProjectName", setMap);

        setMap.put("WFStepIDs", "'AREQ','APRV','AGR'");

        List wfStepInstList = this.commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
        int wfStepInstListSize = 0;
        if ((wfStepInstList != null) && (!wfStepInstList.isEmpty())) {
          wfStepInstListSize = wfStepInstList.size();
        }
        model.put("wfStepInstListSize", Integer.valueOf(wfStepInstListSize));

        String wfStepInstInfo = "";
        String wfStepInstREFInfo = "";
        String wfStepInstAGRInfo = "";

        String wfStepMemberIDs = "";
        String wfStepRoleTypes = "";

        Map wfStepInstInfoMap = new HashMap();
        Map getPJTMap = new HashMap();

        setMap.put("dimTypeID", "100001");
        List regionList = this.commonService.selectList("dim_SQL.getDimValueNameList", setMap);

        setMap.put("languageID", commandMap.get("sessionCurrLangType"));
        setMap.put("s_itemID", projectID);
        setMap.put("wfInstanceID", wfInstanceID);

        Map getMap = this.commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
        model.put("getMap", getMap);

        if ((getMap != null) && (!getMap.isEmpty())) {
          setMap.put("DocCategory", getMap.get("DocCategory"));
        }
        if (isMulti.equals("N")) {
          setMap.remove("s_itemID");
          setMap.put("ProjectID", projectID);
          setMap.put("ChangeSetID", changeSetID);
          getPJTMap = this.commonService.select("wf_SQL.getChangeSetInfoWF", setMap);
          backFunction = "itemChangeInfo.do";
          callbackData = "&changeSetID=" + request.getParameter("ChangeSetID") + "&screenMode=edit&StatusCode=MOD&isAuthorUser=&LanguageID=" + commandMap.get("sessionCurrLangType");
          backMessage = StringUtil.checkNull(labelMap.get("LN00206"));
        }
        else {
          setMap.put("wfInstanceID", wfInstanceID);
          getPJTMap = this.commonService.select("wf_SQL.getWFInstTXT", setMap);
        }

        setMap.put("languageID", commandMap.get("sessionCurrLangType"));
        setMap.put("s_itemID", projectID);
        model.put("getPJTMap", getPJTMap);

        Map setData = new HashMap();
        if (StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV")) {
          setData.put("ProjectID", projectID);
          setData.put("Status", "CNG");
          this.commonService.update("project_SQL.updateProject", setData);
        } else if (StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV2")) {
          setData.put("ProjectID", projectID);
          setData.put("Status", "QA");
          this.commonService.update("project_SQL.updateProject", setData);
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
        insertWFInstData.put("Status", "-1");
        insertWFInstData.put("aprvOption", "PRE");
        insertWFInstData.put("curSeq", "1");
        insertWFInstData.put("LastSigner", commandMap.get("sessionUserId"));

        this.commonService.insert("wf_SQL.insertToWfInst", insertWFInstData);

        String maxId = "";

        int lastSeq = 1;

        insertWFStepData.put("Seq", "0");
        String status = null;
        maxId = this.commonService.selectString("wf_SQL.getMaxStepInstID", setData);
        insertWFStepData.put("StepInstID", Integer.valueOf(Integer.parseInt(maxId) + 1));
        insertWFStepData.put("ProjectID", projectID);

        status = "0";
        insertWFStepData.put("Status", status);
        insertWFStepData.put("ActorID", commandMap.get("sessionUserId"));
        insertWFStepData.put("WFID", "WF001");
        insertWFStepData.put("WFStepID", "AREQ");

        if (wfInstanceID.isEmpty()) insertWFStepData.put("WFInstanceID", newWFInstanceID);
        this.commonService.insert("wf_SQL.insertWfStepInst", insertWFStepData);

        inserWFInstTxtData.put("WFInstanceID", newWFInstanceID);
        inserWFInstTxtData.put("subject", getPJTMap.get("ItemName"));
        inserWFInstTxtData.put("subjectEN", "");
        inserWFInstTxtData.put("description", getPJTMap.get("ItemName"));
        inserWFInstTxtData.put("descriptionEN", "");
        inserWFInstTxtData.put("comment", "");
        inserWFInstTxtData.put("actorID", commandMap.get("sessionUserId"));
        this.commonService.insert("wf_SQL.insertWfInstTxt", inserWFInstTxtData);

        updateCRData = new HashMap();
        HashMap updateSR = new HashMap();

        updateCRData.put("Status", "APRV");
        updateCRData.put("lastUser", commandMap.get("sessionUserId"));
        updateCRData.put("userID", commandMap.get("sessionUserId"));

        if (wfDocType.equals("CS"))
        {
          if (isMulti.equals("Y")) {
            String[] ids = wfDocumentIDs.split(",");
            for (int i = 0; i < ids.length; i++) {
              updateCRData.put("s_itemID", ids[i]);
              updateCRData.put("wfInstanceID", newWFInstanceID);
              this.commonService.update("cs_SQL.updateChangeSetForComDT", updateCRData);
            }
          }
          else {
            updateCRData.put("s_itemID", changeSetID);
            updateCRData.put("wfInstanceID", newWFInstanceID);
            this.commonService.update("cs_SQL.updateChangeSetForComDT", updateCRData);
          }

        }

        setMap.put("languageID", commandMap.get("languageID"));
        setMap.put("wfInstanceID", newWFInstanceID);
        Map menu = getLabel(request, this.commonService);

        setMap.remove("s_itemID");
        setMap.remove("projectID");
        setMap.remove("ChangeSetID");

        List csInstList = this.commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);
        String startHTML = "<![CDATA[<!doctype html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html><body>";
        String endHTML = "</body></html>]]>";
        String openTable = "<table style='table-layout:fixed;border-bottom:1px solid #000;text-align:center;' width='100%' border='1' cellpadding='0' cellspacing='0'>";
        String closeTable = "</table>";
        String openTh = " <th style='padding-left:5px;border-top:1px solid #000;background-color:#f2f2f2;color:#000;font-weight:bold;text-align:left;font-size:12px;font-family:맑은 고딕;height:25px; '>";
        String openTd = "<td style='padding-left:5px;border-top:1px solid #000;color:#000;text-align:left;font-size:12px;font-family:맑은 고딕;'>";

        String returnHTML = startHTML;

        setMap.put("changeSetID", changeSetID);
        String itemID = StringUtil.checkNull(this.commonService.selectString("task_SQL.getCsrItemID", setMap));

        setMap.put("s_itemID", itemID);
        String itemTypeCode = StringUtil.checkNull(this.commonService.selectString("item_SQL.selectedItemTypeCode", setMap));
        setMap.put("s_itemID", itemID);
        String itemStatus = StringUtil.checkNull(this.commonService.selectString("project_SQL.getItemStatus", setMap));

        Calendar calendar = Calendar.getInstance();
        Date date = calendar.getTime();

        String myResult = "";

        setMap.put("assigned", "1");
        setMap.put("itemID", itemID);
        List roleList = this.commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
        setMap.put("ItemID", itemID);
        setMap.put("attrTypeCode", "AT00501");
        Map mainTextMap = this.commonService.select("attr_SQL.getItemAttrText", setMap);

        List itemPath = new ArrayList();

        itemPath = getRootItemPath(itemID, StringUtil.checkNull(commandMap.get("languageID")), itemPath);
        Collections.reverse(itemPath);

        returnHTML = returnHTML + "<div style=\"margin: 0px auto; padding: 0px; width: 100%; \">";
        returnHTML = returnHTML + "<div style=\"padding:10px;\">";
        returnHTML = returnHTML + "<div style=\" text-align: center; padding-top:5px;background-color: #DFE9F7;width: 150px;height: 30px;border-top-right-radius:25px;font-weight: 600;line-height:30px;\">기본정보</div>";
        returnHTML = returnHTML + "<div style=\"padding: 30px; border:2px solid #DFE9F7;\">";
        returnHTML = returnHTML + "<table style=\"width:100%; ;table-layout:fixed;border-collapse:collapse;font-size:12px;font-family:Malgun Gothic;line-height:15pt\">";
        returnHTML = returnHTML + "<tr>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
        returnHTML = returnHTML + "표준유형";
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" >";
        if ("OJ00001".equals(itemTypeCode)) {
          returnHTML = returnHTML + "Process";
        }
        else if ("OJ00005".equals(itemTypeCode)) {
          returnHTML = returnHTML + "SOP";
        }
        else {
          returnHTML = returnHTML + "STP";
        }

        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
        returnHTML = returnHTML + "분류체계";
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\">";
        String itemPathName = "";
        if ((itemPath != null) && (!itemPath.isEmpty())) {
          for (int i = 0; i < itemPath.size(); i++) {
            Map temp = (Map)itemPath.get(i);

            if (i == 0) {
              itemPathName = StringUtil.checkNull(temp.get("PlainText"));
            }
            else {
              itemPathName = itemPathName + " > " + StringUtil.checkNull(temp.get("PlainText"));
            }
          }
        }

        returnHTML = returnHTML + itemPathName;
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "</tr>";
        returnHTML = returnHTML + "<tr>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
        returnHTML = returnHTML + "No.";
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" >";
        returnHTML = returnHTML + StringUtil.checkNull(getPJTMap.get("Identifier"));
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
        returnHTML = returnHTML + "표준 명";
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;word-break:break-all;\" >";
        
        // 표준명 : 표준명 -> [제정검토요청] 표준명 /  [개정검토요청] 표준명 / [폐기검토요청] 표준명  으로 26년3월 수정
        if ("DEL1".equals(itemStatus) || "DEL2".equals(itemStatus)) {
        	 returnHTML = returnHTML + "[폐기검토요청] " + StringUtil.checkNull(getPJTMap.get("ItemName")).replace("&", "&amp;");
        } else if ("NEW1".equals(itemStatus) || "NEW2".equals(itemStatus)) {
        	  returnHTML = returnHTML + "[제정검토요청] " + StringUtil.checkNull(getPJTMap.get("ItemName")).replace("&", "&amp;");
        } else if ("MOD1".equals(itemStatus) || "MOD2".equals(itemStatus)) {
        	  returnHTML = returnHTML + "[개정검토요청] " + StringUtil.checkNull(getPJTMap.get("ItemName")).replace("&", "&amp;");
        } else {
        	  returnHTML = returnHTML + StringUtil.checkNull(getPJTMap.get("ItemName")).replace("&", "&amp;");
        }
        
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "</tr>";
        returnHTML = returnHTML + "<tr>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
        returnHTML = returnHTML + "주관조직";
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;word-break:break-all;\">";
        returnHTML = returnHTML + StringUtil.checkNull(getPJTMap.get("OwnerTeamName"));
        returnHTML = returnHTML + "</td>";
        if (!"OJ00001".equals(itemTypeCode)) {
          returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
          returnHTML = returnHTML + "유관조직";
          returnHTML = returnHTML + "</td>";
          returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;word-break:break-all;\">";
          String rolePath = "";
          if ((roleList != null) && (!roleList.isEmpty())) {
            for (int i = 0; i < roleList.size(); i++) {
              Map temp = (Map)roleList.get(i);

              if (i == 0) {
                rolePath = StringUtil.checkNull(temp.get("TeamNM"));
              }
              else {
                rolePath = rolePath + " / " + StringUtil.checkNull(temp.get("TeamNM"));
              }
            }
          }

          returnHTML = returnHTML + rolePath;
          returnHTML = returnHTML + "</td>";
          returnHTML = returnHTML + "</tr>";
        }
        else {
          returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
          returnHTML = returnHTML + "</td>";
          returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;word-break:break-all;\">";
          returnHTML = returnHTML + "</td>";
          returnHTML = returnHTML + "</tr>";
        }

        returnHTML = returnHTML + "<tr>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
        returnHTML = returnHTML + "제/개정/폐기 사유";
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"3\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;word-break:break-all;\">";
        returnHTML = returnHTML + StringUtil.checkNull(getPJTMap.get("Description")).replace("&", "&amp;");
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "</tr>";
        returnHTML = returnHTML + "<tr>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
        returnHTML = returnHTML + "주요 제/개정 사항";
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"3\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;word-break:break-all;\">";
        returnHTML = returnHTML + StringUtil.checkNull(getPJTMap.get("Reason")).replace("&", "&amp;");
        returnHTML = returnHTML + "</td>";
        returnHTML = returnHTML + "</tr>";

        if ("OJ00005".equals(itemTypeCode))
        {
          returnHTML = returnHTML + "<tr>";
          returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
          returnHTML = returnHTML + "본문";
          returnHTML = returnHTML + "</td>";
          returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"3\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;font-size:10pt;\">";
          String palinTextAT00501 = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mainTextMap.get("PlainText")));

          palinTextAT00501 = palinTextAT00501.replaceAll("&amp;", "&")
            .replaceAll("&bull;", "•")
            .replaceAll("&lsquo;", "‘")
            .replaceAll("&rsquo;", "’")
            .replaceAll("&amp;ndash;", "-")
            .replaceAll("&ndash;", "-")
            .replaceAll("&ldquo;", "\"").replace("&rdquo;", "\"")
            .replaceAll("&middot;", "·");
            // .replaceAll("&nbsp;", " ");

          System.out.println("palinTextAT00501 :" + palinTextAT00501);

          returnHTML = returnHTML + palinTextAT00501.replace("src=\"/upload", "src=\"https://hway.hec.co.kr/upload");
          returnHTML = returnHTML + "</td>";
          returnHTML = returnHTML + "</tr>";
        }

        if ("OJ00001".equals(itemTypeCode)) {
          returnHTML = returnHTML + "<tr>";
          returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"1\" align=\"center\" bgcolor=\"#f4f4f4\" style=\"width:100px;font-weight:bold;border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;\" scope=\"col\">";
          returnHTML = returnHTML + "본문";
          returnHTML = returnHTML + "</td>";
          returnHTML = returnHTML + "<td rowspan=\"1\" colspan=\"3\" align=\"left\" style=\"border-style:solid;border-color:#D3D3D3;border-width:1px;padding:5px;font-size:10pt;\">";
          returnHTML = returnHTML + "<a href='" + GlobalVal.OLM_SERVER_URL + "olmChangeSetLink.do?arCode=AT00004A&olmLoginid=guest&object=itm&linkType=id&keyID=" + StringUtil.checkNull(getPJTMap.get("ItemID")) + "&linkID=" + StringUtil.checkNull(getPJTMap.get("ChangeSetID")) + "&languageID=" + StringUtil.checkNull(commandMap.get("sessionCurrLangType")) + "' target='_blank'>" + StringUtil.checkNull(menu.get("LN00313")) + "</a>";
          returnHTML = returnHTML + "</td>";
          returnHTML = returnHTML + "</tr>";
        }

        returnHTML = returnHTML + "</table>";
        returnHTML = returnHTML + "</div>";
        returnHTML = returnHTML + "</div>";
        returnHTML = returnHTML + endHTML;

        setMap.put("empCode", commandMap.get("sessionLoginId"));
        Map wfPathInfo = this.commonService.select("custom_SQL.zhec_GetMemberWfPath", setMap);

        String samplePath = "<![CDATA[<root><depth approval_phase=\"1\">";

        samplePath = samplePath + "<step type=\"approve\">";
        samplePath = samplePath + "<person dn_code=\"H139\"  dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\"  emp_no=\"" + StringUtil.checkNull(wfPathInfo.get("HiddenPumCode")) + "\"  username=\"\" is_fixed=\"Y\" is_hidden=\"Y\">";
        samplePath = samplePath + "<status approved_date=\"\" status=\"inactive\" />";
        samplePath = samplePath + "</person>";
        samplePath = samplePath + "</step>";

        String pumCode = StringUtil.checkNull(wfPathInfo.get("PumCode"));
        if (!"".equals(pumCode)) {
          samplePath = samplePath + "<step type=\"approve\">";
          samplePath = samplePath + "<person dn_code=\"H139\"  dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\"" + StringUtil.checkNull(wfPathInfo.get("PumCode")) + "\" username=\"\" is_fixed=\"Y\" is_hidden=\"N\">";
          samplePath = samplePath + "<status approved_date=\"\" status=\"inactive\" />";
          samplePath = samplePath + "</person>";
          samplePath = samplePath + "</step>";
        }

        String TeamCode = StringUtil.checkNull(wfPathInfo.get("TeamCode"));
        if (!"".equals(TeamCode)) {
          samplePath = samplePath + "<step type=\"approve\">";
          samplePath = samplePath + "<person dn_code=\"H139\"  dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\"" + TeamCode + "\" username=\"\" is_fixed=\"N\" is_hidden=\"N\">";
          samplePath = samplePath + "<status approved_date=\"\" status=\"inactive\" />";
          samplePath = samplePath + "</person>";
          samplePath = samplePath + "</step>";
        }

        String SilCode = StringUtil.checkNull(wfPathInfo.get("SilCode"));
        if (!"".equals(SilCode)) {
          samplePath = samplePath + "<step type=\"approve\">";
          samplePath = samplePath + "<person dn_code=\"H139\"  dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\"" + SilCode + "\" username=\"\" is_fixed=\"N\" is_hidden=\"N\">";
          samplePath = samplePath + "<status approved_date=\"\" status=\"inactive\" />";
          samplePath = samplePath + "</person>";
          samplePath = samplePath + "</step>";
        }

        String BonCode = StringUtil.checkNull(wfPathInfo.get("BonCode"));
        if ((!"".equals(BonCode)) && (!"OJ00016".equals(itemTypeCode))) {
          samplePath = samplePath + "<step type=\"approve\">";
          samplePath = samplePath + "<person dn_code=\"H139\"  dept_code=\"\" dept_name=\"\" jobtitlecode=\"\" jobtitlename=\"\" emp_no=\"" + BonCode + "\" username=\"\" is_fixed=\"N\" is_hidden=\"N\">";
          samplePath = samplePath + "<status approved_date=\"\" status=\"inactive\" />";
          samplePath = samplePath + "</person>";
          samplePath = samplePath + "</step>";
        }

        samplePath = samplePath + "</depth>";
        samplePath = samplePath + "</root>]]>";

        autoWayMap.put("sendDate", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
        autoWayMap.put("apprPhase", "1");
        autoWayMap.put("dftCompId", "H139");
        autoWayMap.put("lgyDocId", newWFInstanceID);
        autoWayMap.put("htmlType", "1");
        autoWayMap.put("LangType", "ko-KR");
        if ("DEL1".equals(itemStatus) || "DEL2".equals(itemStatus)) {
          autoWayMap.put("docTitle", "[폐기검토요청] " + StringUtil.checkNull(getPJTMap.get("ItemName")).replace("&", "&amp;"));
        }
        else if ("NEW1".equals(itemStatus) || "NEW2".equals(itemStatus)) {
          autoWayMap.put("docTitle", "[제정검토요청] " + StringUtil.checkNull(getPJTMap.get("ItemName")).replace("&", "&amp;"));
        }
        else if ("MOD1".equals(itemStatus) || "MOD2".equals(itemStatus)) {
          autoWayMap.put("docTitle", "[개정검토요청] " + StringUtil.checkNull(getPJTMap.get("ItemName")).replace("&", "&amp;"));
        }
        else {
          autoWayMap.put("docTitle", StringUtil.checkNull(getPJTMap.get("ItemName")).replace("&", "&amp;"));
        }

        autoWayMap.put("lgySystemId", "H-WAY");
        autoWayMap.put("oldPID", "");
        autoWayMap.put("checklistVisible", "");
        autoWayMap.put("dftUserId", commandMap.get("sessionLoginId"));
        autoWayMap.put("dftDeptCode", "");
        autoWayMap.put("fileList", "");
        autoWayMap.put("samplePath", samplePath);

        if ("OJ00001".equals(itemTypeCode)) {
          autoWayMap.put("lgyFormId", "7017");
          autoWayMap.put("atyFormId", "555C2493-BFDB-4A7F-BEDC-2D31D48773CA");
        }
        else if ("OJ00005".equals(itemTypeCode)) {
          autoWayMap.put("lgyFormId", "7018");
          autoWayMap.put("atyFormId", "7F721301-E949-4B6F-A6E3-C7F49ACE9A63");
        }
        else {
          autoWayMap.put("lgyFormId", "7019");
          autoWayMap.put("atyFormId", "5D040AA3-EAE5-45DA-B1CB-1C39AA3402C0");
        }

        autoWayMap.put("approvalPathLine", "");
        autoWayMap.put("mainContpdf", "");
        autoWayMap.put("lgyRefDocId", "");
        autoWayMap.put("minSerialCnt", "");
        autoWayMap.put("mainContHtml", returnHTML);

        wfUrl = GlobalVal.APPROVAL_SYS_URL;
        Map fileMap = new HashMap();
        fileMap.put("changeSetID", changeSetID);
        fileMap.put("DocumentID", itemID);
        fileMap.put("languageID", languageID);
        fileMap.put("fileListYN", "Y");
        List fileList = this.commonService.selectList("fileMgt_SQL.getFile_gridList", fileMap);
        String sendFileList = "";
        if ((fileList != null) && (!fileList.isEmpty())) {
          for (int i = 0; i < fileList.size(); i++) {
            Map temp = (Map)fileList.get(i);

            String isFlag = zhec_sendFile(StringUtil.checkNull(temp.get("FilePath")), 
              StringUtil.checkNull(temp.get("FileName")), 
              StringUtil.checkNull(temp.get("FileRealName")), newWFInstanceID);

            if (i == 0) {
              sendFileList = StringUtil.checkNull(temp.get("FileRealName")).replace("&", "&amp;");
            }
            else {
              sendFileList = sendFileList + "|" + StringUtil.checkNull(temp.get("FileRealName")).replace("&", "&amp;");
            }
          }
        }

        if (!"".equals(sendFileList)) {
          autoWayMap.put("fileList", "/H-WAY/attach/" + newWFInstanceID + "/" + sendFileList);
        }

        System.out.println(" zhec_WFDocMgt  wfUrl ::" + wfUrl);
        String wfData = createWfXML(wfUrl, autoWayMap);

        System.out.println(" zhec_WFDocMgt  wfData ::" + wfData);

        if (!"".equals(wfData)) {
          JSONObject jo1 = new JSONObject(wfData);

          String returnUrl = StringUtil.checkNull(jo1.get("returnUrl"));
          String resultCode = StringUtil.checkNull(jo1.get("resultCode"));
          String errMsg = StringUtil.checkNull(jo1.get("errMsg"));

          model.put("returnUrl", returnUrl);
          model.put("resultCode", resultCode);
          model.put("errMsg", errMsg);

          System.out.println(" zhec_WFDocMgt  returnUrl ::" + returnUrl);
          System.out.println(" zhec_WFDocMgt  resultCode ::" + resultCode);
          System.out.println(" zhec_WFDocMgt  errMsg ::" + errMsg);
        }
        else
        {
          model.put("returnUrl", "");
          model.put("resultCode", "E");
          model.put("errMsg", "Error");
        }
      }
    }
    catch (Exception e)
    {
      System.out.println(e);
      throw new Exception("EM00001");
    }
    return nextUrl(url);
  }
  private static String repeat(String str, int count) {
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < count; i++) {
      sb.append(str);
    }
    return sb.toString(); } 
  @RequestMapping({"/hec/zhec_UpdWFReValue.do"})
  public String zhec_UpdWFReValue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { String url = "";
    Map target = new HashMap();
    Map setMap = new HashMap();
    String status = "";
    try {
      System.out.println("zhec_UpdWFReValue ==> Start");

      String apprStatus = StringUtil.checkNull(request.getParameter("ApprovalStatus"));
      String wfInstanceID = StringUtil.checkNull(request.getParameter("DocID"));
      String ReturnedValue = StringUtil.checkNull(request.getParameter("InterfaceID"));
      String date = StringUtil.checkNull(request.getParameter("ApprovalDate"));
      String LoginId = StringUtil.checkNull(request.getParameter("UserID"));

      setMap.put("wfInstanceID", wfInstanceID);
      Map wfInfoMap = this.commonService.select("wf_SQL.getWFInstDoc", setMap);

      setMap.put("loginID", LoginId);
      String wfID = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getWFID", setMap), "");
      String memberID = StringUtil.checkNull(this.commonService.selectString("user_SQL.member_id_select", setMap), "");
      String projectID = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getProjectID", setMap), "");

      setMap.put("changeSetID", wfInfoMap.get("DocumentID"));
      String itemID = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getItemIDForCSID", setMap), "");

      if (apprStatus.equals("DRAFT")) {
        setMap.put("itemID", itemID);
        String version = StringUtil.checkNull(this.commonService.selectString("cs_SQL.getItemReleaseVersion", setMap), "");
        setMap.put("s_itemID", itemID);
        String itemStatus = StringUtil.checkNull(this.commonService.selectString("project_SQL.getItemStatus", setMap));

        if (itemStatus.equals("NEW1")) {
          itemStatus = "NEW2";
        }
        else if (itemStatus.equals("MOD1")) {
          itemStatus = "MOD2";
        }
        else if (itemStatus.equals("DEL1")) {
          itemStatus = "DEL2";
        }
        setMap.put("ItemID", itemID);
        setMap.put("Status", itemStatus);
        setMap.put("curChangeSet", wfInfoMap.get("DocumentID"));
        setMap.put("Blocked", "2");
        this.commonService.update("project_SQL.updateItemStatus", setMap);

        setMap.remove("itemID");
        setMap.remove("s_itemID");
        setMap.remove("ItemID");
        setMap.remove("changeSetID");
        setMap.remove("Status");

        if (("1.0".equals(version)) || ("1.01".equals(version))) {
          setMap.put("Version", "2");
        }

        setMap.put("status", "APRV");
        setMap.put("wfInstanceID", wfInstanceID);
        this.commonService.update("cs_SQL.updateChangeSetForWFInstID", setMap);

        setMap.put("Status", "1");
      } else if (apprStatus.equals("TOTALCOMPLETE"))
      {
        try {
          setMap.put("s_itemID", itemID);
          String parentID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemParentID", setMap));

          String itemStatus = StringUtil.checkNull(this.commonService.selectString("project_SQL.getItemStatus", setMap));

          setMap.put("s_itemID", parentID);
          String maxIdentifier = StringUtil.checkNull(this.commonService.selectString("item_SQL.getMaxIdentifierFromParentID", setMap));

          String itemTypeCode = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemTypeCode", setMap));

          if (("NEW2".equals(itemStatus)) && (!"OJ00001".equals(itemTypeCode))) {
            if (maxIdentifier.equals("")) {
              setMap.put("itemID", parentID);
              String parentIdentifier = this.commonService.selectString("item_SQL.s_itemIDentifier", setMap);
              setMap.remove("itemID");

              if ("OJ00005".equals(itemTypeCode)) {
                maxIdentifier = "SOP-" + parentIdentifier.replace(".", "-") + "-001";
              }
              else if ("OJ00016".equals(itemTypeCode))
                maxIdentifier = "STP-" + parentIdentifier.replace(".", "-") + "-001";
            }
            else {
              String lastCode = maxIdentifier.substring(maxIdentifier.length() - 3, maxIdentifier.length());
              int curIdentifierCode = Integer.parseInt(lastCode) + 1;
              maxIdentifier = maxIdentifier.substring(0, maxIdentifier.length() - 3) + String.format("%03d", new Object[] { Integer.valueOf(curIdentifierCode) });
            }

            setMap.put("Identifier", maxIdentifier);
            setMap.put("ItemID", itemID);
            setMap.put("CategoryCode", "OJ");
            this.commonService.update("item_SQL.updateItemObjectInfo", setMap);
          }

          setMap.put("wfID", "WF001");
          setMap.put("wfDocType", wfInfoMap.get("DocCategory"));

          String postProcessing = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getPostProcessing", setMap), "");

          if (postProcessing != "") {
            status = "CLS";
            if (postProcessing.split("\\?").length > 1) {
              String[] tmp = postProcessing.split("\\?");
              url = tmp[0];
            }
            else {
              url = postProcessing;
            }

            if ("updateCSStatusForWF.do".equals(url)) {
              commandMap.put("status", "CLS");
              commandMap.put("wfInstanceID", wfInstanceID);
              this.CSActionController.updateCSStatusForWF(request, commandMap, model);
            }

          }

          Calendar cal = Calendar.getInstance();
          cal.setTime(new Date(System.currentTimeMillis()));
          String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

          setMap.put("Status", "CLS");
          setMap.put("ValidFrom", thisYmd);
          setMap.put("s_itemID", wfInfoMap.get("DocumentID"));
          this.commonService.update("cs_SQL.updateChangeSetForWf", setMap);

          setMap.put("Status", "2");
        }
        catch (Exception e) {
          System.out.println("error");
          System.out.println(e);
        }
      }
      else if (apprStatus.equals("DENY")) {
        setMap.put("wfID", "WF001");
        setMap.put("wfDocType", wfInfoMap.get("DocCategory"));

        String postProcessing = StringUtil.checkNull(this.commonService.selectString("wf_SQL.getPostProcessing", setMap), "");

        if (postProcessing != "") {
          if (postProcessing.split("\\?").length > 1) {
            String[] tmp = postProcessing.split("\\?");
            url = tmp[0];
          }
          else {
            url = postProcessing;
          }

          if ("updateCSStatusForWF.do".equals(url)) {
            commandMap.put("status", "WTR");
            commandMap.put("wfInstanceID", wfInstanceID);
            this.CSActionController.updateCSStatusForWF(request, commandMap, model);
          }

        }

        setMap.put("Status", "3");
      } else if (apprStatus.equals("WITHDRAW"))
      {
        setMap.put("s_itemID", itemID);
        String itemStatus = StringUtil.checkNull(this.commonService.selectString("project_SQL.getItemStatus", setMap));

        if (itemStatus.equals("NEW2")) {
          itemStatus = "NEW1";
        }
        else if (itemStatus.equals("MOD2")) {
          itemStatus = "MOD1";
        }
        else if (itemStatus.equals("DEL2")) {
          itemStatus = "DEL1";
        }
        setMap.put("ItemID", itemID);
        setMap.put("Status", itemStatus);
        setMap.put("Blocked", "0");
        this.commonService.update("project_SQL.updateItemStatus", setMap);

        setMap.put("s_itemID", wfInfoMap.get("DocumentID"));
        setMap.put("cngItemId", itemID);
        setMap.put("Status", "MOD");
        setMap.put("isInitWFID", "Y");
        this.commonService.update("cs_SQL.updateChangeSetForWf", setMap);
      }

      setMap.put("LastUser", memberID);
      setMap.put("WFInstanceID", wfInstanceID);
      setMap.put("ReturnedValue", ReturnedValue);
      this.commonService.update("wf_SQL.updateWfInst", setMap);
      this.commonService.update("wf_SQL.updateWFStepInst", setMap);

      target.put("SCRIPT", "S");

      model.addAttribute("resultMap", target);
    }
    catch (Exception e)
    {
      System.out.println(e);

      target.put("SCRIPT", "E");

      model.addAttribute("resultMap", target);
    }

    return nextUrl("/cmm/ajaxResult/ajaxNoScriptPage"); } 
  @RequestMapping({"/hec/zhec_getNewItemList.do"})
  public String zhec_getNewItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { String url = "";
    Map target = new HashMap();
    Map setMap = new HashMap();
    String result = "";
    try {
      String apprStatus = StringUtil.checkNull(commandMap.get("ApprovalStatus"));
      String wfInstanceID = StringUtil.checkNull(commandMap.get("DocID"));
      String ReturnedValue = StringUtil.checkNull(commandMap.get("InterfaceID"));
      String date = StringUtil.checkNull(commandMap.get("ApprovalDate"));
      String LoginId = StringUtil.checkNull(commandMap.get("EmpID"));

      setMap.put("languageID", "1042");
      setMap.put("scrnType", "main");
      setMap.put("Status", "CLS");
      setMap.put("isDeleted", "YES");
      setMap.put("classCodeList", "'CL05003','CL16004'");
      List csList = this.commonService.selectList("cs_SQL.getChangeSetMultiList_gridList", setMap);
      result = "{\"ResultCode\":\"1000\",\"ResultMessage\":[";
      if ((csList != null) && (!csList.isEmpty())) {
        for (int i = 0; i < csList.size(); i++)
        {
          Map tempMap = (Map)csList.get(i);
          String linkUrl = "https://hway.hec.co.kr/olmLink.do?olmLoginid=" + LoginId + "&object=itm&linkType=id&linkID=" + StringUtil.checkNull(tempMap.get("ItemID")) + "&languageID=1042&option=";

          if (i > 0) {
            result = result + ",";
          }

          result = result + "{\"Title\":\"" + StringUtil.checkNull(tempMap.get("ItemName")) + "\"," + 
            "\"Writer\":\"" + StringUtil.checkNull(tempMap.get("AuthorTeamName")) + " " + StringUtil.checkNull(tempMap.get("AuthorName")) + "\"," + 
            "\"RegDateTime\":\"" + StringUtil.checkNull(tempMap.get("ValidFrom")) + "\"," + 
            "\"AttatchmentYN\":\"Y\"," + 
            "\"LinkUrl\":\"" + linkUrl + "\"}";
        }
      }
      result = result + "]}";

      target.put("SCRIPT", result);

      model.addAttribute("resultMap", target);
    }
    catch (Exception e) {
      result = "{\\\"ResultCode:2000\\\",\\\"ResultMessage\\\":[]}";
      target.put("SCRIPT", result);

      model.addAttribute("resultMap", target);
    }
    return nextUrl("/cmm/ajaxResult/ajaxNoScriptPage"); }

  public String createWfXML(String url, HashMap autoWayMap)
    throws Exception
  {
    String returnData = "";
    try {
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      factory.setNamespaceAware(true);
      DocumentBuilder parser = factory.newDocumentBuilder();
      System.out.println("createWfXML start");
      String sendMessage = 
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\t<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">     <soap:Body>        <OpenApprovalDraftWindow xmlns=\"http://tempuri.org/\">         <dftCompId>" + 
        autoWayMap.get("dftCompId") + "</dftCompId>" + 
        "         <dftUserId>" + autoWayMap.get("dftUserId") + "</dftUserId>" + 
        "         <dftDeptCode></dftDeptCode>" + 
        "         <sendDate>" + autoWayMap.get("sendDate") + "</sendDate>" + 
        "         <docTitle>" + autoWayMap.get("docTitle") + "</docTitle>" + 
        "         <lgySystemId>H-WAY</lgySystemId>" + 
        "         <lgyDocId>" + autoWayMap.get("lgyDocId") + "</lgyDocId>" + 
        "         <lgyRefDocId></lgyRefDocId>" + 
        "         <htmlType>1</htmlType>" + 
        "         <mainContpdf></mainContpdf>" + 
        "         <mainContHtml>" + autoWayMap.get("mainContHtml") + "</mainContHtml>" + 
        "         <approvalPathLine>" + autoWayMap.get("samplePath") + "</approvalPathLine>" + 
        "         <atyFormId>" + autoWayMap.get("atyFormId") + "</atyFormId>" + 
        "         <lgyFormId>" + autoWayMap.get("lgyFormId") + "</lgyFormId>" + 
        "         <fileList>" + autoWayMap.get("fileList") + "</fileList>" + 
        "         <apprPhase>1</apprPhase>" + 
        "         <minSerialCnt></minSerialCnt>" + 
        "         <checklistVisible></checklistVisible>" + 
        "         <oldPID></oldPID>" + 
        "         <LangType>ko-KR</LangType>" + 
        "      </OpenApprovalDraftWindow>" + 
        "   </soap:Body>" + 
        "</soap:Envelope>";
      StringReader reader = new StringReader(sendMessage);
      InputSource is = new InputSource(reader);
      Document document = parser.parse(is);
      DOMSource requestSource = new DOMSource(document);

      MessageFactory messageFactory = MessageFactory.newInstance();
      SOAPMessage requestSoapMessage = messageFactory.createMessage();
      SOAPPart requestSoapPart = requestSoapMessage.getSOAPPart();
      requestSoapPart.setContent(requestSource);

      SOAPConnectionFactory scf = SOAPConnectionFactory.newInstance();
      SOAPConnection connection = scf.createConnection();

      System.out.println("sendMessage :" + sendMessage);

      SOAPMessage responseSoapMessage = connection.call(requestSoapMessage, url);

      System.out.println("responseSoapMessage :" + responseSoapMessage);
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      responseSoapMessage.writeTo(out);
      String soapResult = new String(out.toByteArray(), "UTF-8");

      SOAPBody soapBody = responseSoapMessage.getSOAPBody();
      returnData = soapBody.getTextContent();

      System.out.println(" returnData :" + returnData);
    }
    catch (Exception e) {
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

      String sendMessage = 
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\t<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">     <soap:Body>        <CallDoc xmlns=\"http://tempuri.org/\">         <dftCompId>" + 
        autoWayMap.get("dftCompId") + "</dftCompId>" + 
        "         <dftUserId>" + autoWayMap.get("dftUserId") + "</dftUserId>" + 
        "         <dftDeptCode></dftDeptCode>" + 
        "         <lgySystemId>H-WAY</lgySystemId>" + 
        "         <lgyDocId>" + autoWayMap.get("lgyDocId") + "</lgyDocId>" + 
        "         <PID>" + autoWayMap.get("PID") + "</PID>" + 
        "         <LangType>ko-KR</LangType>" + 
        "      </CallDoc>" + 
        "   </soap:Body>" + 
        "</soap:Envelope>";

      StringReader reader = new StringReader(sendMessage);
      InputSource is = new InputSource(reader);
      Document document = parser.parse(is);
      DOMSource requestSource = new DOMSource(document);

      MessageFactory messageFactory = MessageFactory.newInstance();
      SOAPMessage requestSoapMessage = messageFactory.createMessage();
      SOAPPart requestSoapPart = requestSoapMessage.getSOAPPart();
      requestSoapPart.setContent(requestSource);

      SOAPConnectionFactory scf = SOAPConnectionFactory.newInstance();
      SOAPConnection connection = scf.createConnection();

      SOAPMessage responseSoapMessage = connection.call(requestSoapMessage, url);
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      responseSoapMessage.writeTo(out);
      String soapResult = new String(out.toByteArray(), "UTF-8");

      SOAPBody soapBody = responseSoapMessage.getSOAPBody();
      returnData = soapBody.getTextContent();
    }
    catch (Exception e) {
      e.printStackTrace();
    }
    return returnData; } 
  @RequestMapping({"/indexHEC.do"})
  public String indexHEC(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception { try { Map setData = new HashMap();
      String logonId = "";
      Map userInfo = new HashMap();
      Map ssoInfo = new HashMap();
      String scriptMsg = "";
      String returnUrlTagName = "";
      String siteTagName = "";

      System.out.println("SSO Start");
      AuthCheck auth = new AuthCheck(request, response);

      AuthStatus status = auth.checkLogon();

      returnUrlTagName = auth.getSsoProvider().getParamName("ReturnURL");
      siteTagName = auth.getSsoProvider().getParamName("SSOSite");

      if (status == AuthStatus.SSOFirstAccess)
      {
        auth.trySSO();
      } else if (status == AuthStatus.SSOSuccess)
      {
        logonId = auth.getUserID();

        if ((auth.getUserInfoCollection() != null) && (auth.getUserInfoCollection().size() > 0))
        {
          for (Enumeration e = auth.getUserInfoCollection().keys(); e.hasMoreElements(); ) {
            String key = (String)e.nextElement();
            ssoInfo.put(key, auth.getUserInfoCollection().get(key));
          }

        }

        setData.put("employeeNum", ssoInfo.get("empNO"));

        userInfo = this.commonService.select("common_SQL.getLoginIDFromMember", setData);

        if ((userInfo != null) && (!userInfo.isEmpty())) {
          String activeYN = "N";
          HashMap setMap = new HashMap();

          setMap.put("LOGIN_ID", StringUtil.checkNull(userInfo.get("LoginId")));

          activeYN = this.commonService.selectString("login_SQL.login_active_select", setMap);
          if (!"Y".equals(activeYN)) {
            return nextUrl("indexHEC");
          }

          model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
        }

        model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"), ""));
        model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"), ""));
        model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"), ""));
        model.put("srID", StringUtil.checkNull(cmmMap.get("srID"), ""));
        model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode"), ""));
        model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"), ""));
      }
      else if (status == AuthStatus.SSOFail)
      {
        if (auth.getErrCode() != AgentExceptionCode.NoException.getValue()) {
          model.put("errorCode", "other");
          model.put("errorMessage", Integer.valueOf(auth.getErrCode()));
        }

        if (auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue()) {
          model.put("errorCode", "overlap");
          model.put("errorMessage", "");
        }

        if ((auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue()) || 
          (auth.getErrCode() == AgentExceptionCode.TokenIdleTimeout.getValue()) || 
          (auth.getErrCode() == AgentExceptionCode.TokenExpired.getValue()) || 
          (auth.getErrCode() == AgentExceptionCode.NoExistUserIDSessionValue.getValue())) {
          scriptMsg = scriptMsg + "OnLogoff();";
        }
        else {
          scriptMsg = scriptMsg + "goLogonPage();";
        }
      }
      else if (status == AuthStatus.SSOUnAvailable)
      {
        scriptMsg = "alertError('현재 통합인증 서비스가 불가합니다.', '');";
      }
      else if (status == AuthStatus.SSOAccessDenied)
      {
        response.sendRedirect("denied.jsp");
      }
    }
    catch (Exception e)
    {
      if (this._log.isInfoEnabled()) this._log.info("MandoActionController::Mando Login ::Error::" + e);

      System.out.println(e.getMessage());
      return nextUrl("indexHEC");
    }

    return nextUrl("indexHEC"); } 
  @RequestMapping({"/hyundai/loginHecForm.do"})
  public String loginHecForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception { HttpSession session = request.getSession(true);

    Map loginInfo = (Map)session.getAttribute("loginInfo");

    if ((loginInfo != null) && (!loginInfo.isEmpty())) {
      if ("guest".equals(loginInfo.get("sessionLoginId"))) {
        session.invalidate();
        model.put("ssoYN", "N");
      }
      else {
        model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
        model.put("ssoYN", "Y");
      }
    }
    else {
      model.put("ssoYN", "N");
    }

    model = setLoginScrnInfo(model, cmmMap);

    model.put("screenType", cmmMap.get("screenType"));
    model.put("mainType", cmmMap.get("mainType"));
    model.put("srID", cmmMap.get("srID"));
    model.put("sysCode", cmmMap.get("sysCode"));
    model.put("proposal", cmmMap.get("proposal"));
    model.put("status", cmmMap.get("status"));
    return nextUrl("/custom/hyundai/login");
  }

  private ModelMap setLoginScrnInfo(ModelMap model, HashMap cmmMap)
    throws ExceptionUtil
  {
    String pass = StringUtil.checkNull(cmmMap.get("pwd"));
    model.addAttribute("loginid", StringUtil.checkNull(cmmMap.get("loginid"), ""));
    model.addAttribute("pwd", pass);
    model.addAttribute("lng", StringUtil.checkNull(cmmMap.get("lng"), ""));
    try {
      List langList = this.commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
      if ((langList != null) && (langList.size() > 0)) {
        for (int i = 0; i < langList.size(); i++) {
          Map langInfo = (HashMap)langList.get(i);
          if (langInfo.get("IsDefault").equals("1")) {
            model.put("langType", StringUtil.checkNull(langInfo.get("CODE"), ""));
            model.put("langName", StringUtil.checkNull(langInfo.get("NAME"), ""));
          }
        }
      } else {
        model.put("langType", ""); model.put("langName", "");
      }model.put("langList", langList);
      model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
    } catch (Exception e) {
      throw new ExceptionUtil(e.toString());
    }
    return model; } 
  @RequestMapping({"/hyundai/loginHec.do"})
  public String loginHec(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception { try { HttpSession session = request.getSession(true);
      Map resultMap = new HashMap();
      String langCode = GlobalVal.DEFAULT_LANG_CODE;
      String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"), StringUtil.checkNull(cmmMap.get("LANGUAGEID")));
      if ("".equals(languageID)) {
        languageID = GlobalVal.DEFAULT_LANGUAGE;
      }

      cmmMap.put("LANGUAGE", languageID);

      String ref = request.getHeader("referer");
      String protocol = request.isSecure() ? "https://" : "http://";

      String IS_CHECK = GlobalVal.PWD_CHECK;
      String url_CHECK = "Y";

      if ("".equals(IS_CHECK)) {
        IS_CHECK = "Y";
      }

      if ("".equals(url_CHECK)) {
        resultMap.put("SCRIPT", "parent.fnReload('N')");
        resultMap.put("ALERT", MessageHandler.getMessage(langCode + ".WM00002"));
      }
      else {
        Map idInfo = new HashMap();
        idInfo = this.commonService.select("login_SQL.login_id_select", cmmMap);

        if ((idInfo == null) || (idInfo.size() == 0)) {
          resultMap.put("SCRIPT", "parent.fnReload('N')");
          resultMap.put("ALERT", MessageHandler.getMessage(langCode + ".WM00002"));
        }
        else {
          Map loginInfo = this.commonService.select("login_SQL.login_select", cmmMap);
          if ((loginInfo == null) || (loginInfo.size() == 0)) {
            resultMap.put("SCRIPT", "parent.fnReload('N')");

            resultMap.put("ALERT", MessageHandler.getMessage(langCode + ".WM00102"));
          }
          else
          {
            if (loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0) loginInfo.put("loginType", "editor"); else
              loginInfo.put("loginType", "viewer");
            resultMap.put("SCRIPT", "parent.fnReload('Y')");

            session.setAttribute("loginInfo", loginInfo);
          }
        }
      }
      model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
      model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
      model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
      model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
      model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));

      model.addAttribute("resultMap", resultMap);
    } catch (Exception e)
    {
      System.out.println(e.toString());
      if (this._log.isInfoEnabled()) this._log.info("LoginActionController::loginbase::Error::" + e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/cmm/ajaxResult/ajaxPage"); } 
  @RequestMapping({"/zhec_saveMainText.do"})
  public String zhec_saveMainText(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { HashMap target = new HashMap();
    try
    {
      Map setMap = new HashMap();
      Map delData = new HashMap();

      String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
      String ItemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"));
      String ItemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
      String AT00501 = StringUtil.checkNull(request.getParameter("AT00501"));
      setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

      delData.put("ItemID", s_itemID);
      delData.put("AttrTypeCode", "AT00501");
      this.commonService.delete("attr_SQL.delItemAttr", delData);

      AT00501 = StringEscapeUtils.unescapeHtml4(AT00501);
      setMap.put("PlainText", AT00501);
      setMap.put("ItemID", s_itemID);
      setMap.put("ClassCode", ItemClassCode);
      setMap.put("ItemTypeCode", ItemTypeCode);
      setMap.put("AttrTypeCode", "AT00501");

      List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setMap);
      for (int i = 0; i < getLanguageList.size(); i++) {
        Map getMap = (HashMap)getLanguageList.get(i);
        setMap.put("languageID", getMap.get("CODE"));
        this.commonService.insert("item_SQL.ItemAttr", setMap);
      }

      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
    }
    catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); }

  private List getRootItemPath(String itemID, String languageID, List itemPath) throws Exception
  {
    Map setMap = new HashMap();
    setMap.put("itemID", itemID);
    String ParentItemID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getParentItemID", setMap), "0");

    if ((Integer.parseInt(ParentItemID) != 0) && (Integer.parseInt(ParentItemID) > 100)) {
      setMap.put("ItemID", ParentItemID);
      setMap.put("languageID", languageID);
      setMap.put("attrTypeCode", "AT00001");
      Map temp = this.commonService.select("attr_SQL.getItemAttrText", setMap);
      temp.put("itemID", ParentItemID);
      itemPath.add(temp);
      getRootItemPath(ParentItemID, languageID, itemPath);
    }

    return itemPath;
  }

  public String zhec_sendFile(String filePath, String fileName, String fileRealName, String wfInstanceID) throws Exception {
    HashMap target = new HashMap();
    try
    {
      String id = "SFTPHEC@grhq.hmgc.net";
      String pwd = "SftpHec!23";
      String url = "10.6.180.135";
      Session session = null;
      Channel channel = null;
      ChannelSftp channelSftp = null;

      JSch jsch = new JSch();
      session = jsch.getSession(id, url, 8988);

      session.setPassword(pwd);

      Properties config = new Properties();

      config.put("StrictHostKeyChecking", "no");
      session.setConfig(config);

      session.connect();

      channel = session.openChannel("sftp");
      channel.connect();
      channelSftp = (ChannelSftp)channel;
      File file = new File(filePath + fileName);
      FileInputStream in = null;

      in = new FileInputStream(file);
      String ftpPath = "/H-WAY/attach/" + wfInstanceID;
      try
      {
        channelSftp.mkdir(ftpPath);
        channelSftp.cd(ftpPath);
      }
      catch (Exception e)
      {
        channelSftp.cd(ftpPath);
      }

      channelSftp.put(in, file.getName());
      channelSftp.rename(file.getName(), fileRealName);
      in.close();
      channelSftp.quit();
      session.disconnect();
    } catch (Exception e) {
      return "false";
    }
    return "success"; } 
  @RequestMapping({"/zhec_SearchItem.do"})
  public String zhec_SearchItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { String url = "custom/hyundai/hec/searchList";
    try {
      Map setMap = new HashMap();

      String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
      String isNothingLowLank = "";
      String screenType = StringUtil.checkNull(request.getParameter("screenType"));
      String defDimTypeID = StringUtil.checkNull(request.getParameter("defDimTypeID"));
      String defDimValueID = StringUtil.checkNull(request.getParameter("defDimValueID"));

      String childItems = "";
      setMap.put("s_itemID", s_itemID);
      setMap.put("languageID", commandMap.get("sessionCurrLangType"));

      commandMap.put("Category", "ITMSTS");
      List statusList = this.commonService.selectList("common_SQL.dictionyCode_commonSelect", commandMap);
      model.put("statusList", statusList);
      commandMap.put("Deactivated", "1");

      List itemTypeList = this.commonService.selectList("common_SQL.itemTypeCode_commonSelect", commandMap);
      commandMap.remove("Deactivated");
      model.put("itemTypeList", itemTypeList);

      List dimTypeList = this.commonService.selectList("dim_SQL.getDimTypeList", commandMap);
      model.put("dimTypeList", dimTypeList);

      setMap.put("TeamType", "2");
      List companyOptionList = this.commonService.selectList("organization_SQL.getTeamList", setMap);
      model.put("companyOption", companyOptionList);

      List symbolCodeList = this.commonService.selectList("search_SQL.getSymbolCodeList", setMap);
      model.put("symbolCodeList", symbolCodeList);

      String defaultLang = this.commonService.selectString("item_SQL.getDefaultLang", commandMap);

      if (screenType.equals("main")) {
        model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
        model.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
        model.put("AttrCode", StringUtil.checkNull(request.getParameter("searchKey")));
        model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
        model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
        model.put("searchTeamName", StringUtil.checkNull(request.getParameter("searchTeamName")));
        model.put("searchAuthorName", StringUtil.checkNull(request.getParameter("searchAuthorName")));
      }

      model.put("isNothingLowLank", isNothingLowLank);
      model.put("defaultLang", defaultLang);
      model.put("defDimValueID", defDimValueID);
      model.put("defDimTypeID", defDimTypeID);
      model.put("childItems", childItems);
      model.put("menu", getLabel(request, this.commonService));
      model.put("idExist", StringUtil.checkNull(request.getParameter("idExist")));
    }
    catch (Exception e) {
      System.out.println(e.toString());
    }

    return nextUrl(url); } 
  @RequestMapping({"/hec/zhec_inboundLink.do"})
  public String zhec_inboundLink(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception { String url = "/project/changeInfo/olmChangeSetLink";
    try {
      String logonId = "";
      Map userInfo = new HashMap();
      Map ssoInfo = new HashMap();
      Map setMap = new HashMap();
      String scriptMsg = "";
      String returnUrlTagName = "";
      String siteTagName = "";

      AuthCheck auth = new AuthCheck(request, response);

      AuthStatus status = auth.checkLogon();
      System.out.println("SSO sTART");

      returnUrlTagName = auth.getSsoProvider().getParamName("ReturnURL");
      siteTagName = auth.getSsoProvider().getParamName("SSOSite");

      if (status == AuthStatus.SSOFirstAccess)
      {
        auth.trySSO();
      } else if (status == AuthStatus.SSOSuccess)
      {
        logonId = auth.getUserID();

        if ((auth.getUserInfoCollection() != null) && (auth.getUserInfoCollection().size() > 0))
        {
          for (Enumeration e = auth.getUserInfoCollection().keys(); e.hasMoreElements(); ) {
            String key = (String)e.nextElement();
            ssoInfo.put(key, auth.getUserInfoCollection().get(key));
          }

        }

        setMap.put("employeeNum", ssoInfo.get("empNO"));

        userInfo = this.commonService.select("common_SQL.getLoginIDFromMember", setMap);

        if ((userInfo != null) && (!userInfo.isEmpty())) {
          String activeYN = "N";
          HashMap setInfo = new HashMap();

          setInfo.put("LOGIN_ID", StringUtil.checkNull(userInfo.get("LoginId")));

          activeYN = this.commonService.selectString("login_SQL.login_active_select", setInfo);
          if (!"Y".equals(activeYN)) {
            return nextUrl("indexHEC");
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

        if ("".equals(changeSetID)) {
          setMap.put("s_itemID", itemID);
          changeSetID = this.commonService.selectString("item_SQL.getItemCurChangeSet", setMap);
        }

        if ("CNGREW".equals(option)) {
          model.put("accMode", "DEV");
        }

        model.put("itemID", itemID);
        model.put("changeSetID", changeSetID);
        model.put("arCode", option);
        model.put("option", option);
        model.put("languageID", languageID);

        model.put("olmLng", StringUtil.checkNull(commandMap.get("olmLng"), ""));
        model.put("screenType", StringUtil.checkNull(commandMap.get("screenType"), ""));
        model.put("mainType", StringUtil.checkNull(commandMap.get("mainType"), ""));
        model.put("srID", StringUtil.checkNull(commandMap.get("srID"), ""));
        model.put("sysCode", StringUtil.checkNull(commandMap.get("sysCode"), ""));
        model.put("proposal", StringUtil.checkNull(commandMap.get("proposal"), ""));
      }
      else if (status == AuthStatus.SSOFail)
      {
        if (auth.getErrCode() != AgentExceptionCode.NoException.getValue()) {
          model.put("errorCode", "other");
          model.put("errorMessage", Integer.valueOf(auth.getErrCode()));
        }
        if (auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue()) {
          model.put("errorCode", "overlap");
          model.put("errorMessage", "");
        }

        if ((auth.getErrCode() == AgentExceptionCode.SessionDuplicationCheckedLastPriority.getValue()) || 
          (auth.getErrCode() == AgentExceptionCode.TokenIdleTimeout.getValue()) || 
          (auth.getErrCode() == AgentExceptionCode.TokenExpired.getValue()) || 
          (auth.getErrCode() == AgentExceptionCode.NoExistUserIDSessionValue.getValue()))
          scriptMsg = scriptMsg + "OnLogoff();";
        else {
          scriptMsg = scriptMsg + "goLogonPage();";
        }
      }
      else if (status == AuthStatus.SSOUnAvailable)
      {
        scriptMsg = "alertError('현재 통합인증 서비스가 불가합니다.', '');";
      } else if (status == AuthStatus.SSOAccessDenied)
      {
        response.sendRedirect("denied.jsp");
      }

    }
    catch (Exception e)
    {
      System.out.println(e.toString());
    }

    return nextUrl(url); }

  public List aprvByActivityRole(String itemID, String cxnCode, String languageID) throws Exception
  {
    HashMap target = new HashMap();
    List roleMangerList = new ArrayList();
    try {
      HashMap setMap = new HashMap();
      setMap.put("s_itemID", itemID);
      setMap.put("cxnCode", cxnCode);
      setMap.put("languageID", languageID);
      roleMangerList = this.commonService.selectList("role_SQL.getItemCxnRoleManagerList", setMap);
    }
    catch (Exception e) {
      System.out.println(e);
      return null;
    }
    return roleMangerList; } 
  @RequestMapping({"/zhec_saveAndDeleteSubScrip.do"})
  public String zhec_saveAndDeleteSubScript(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception { HashMap target = new HashMap();
    try {
      HashMap setData = new HashMap();
      HashMap insertData = new HashMap();
      HashMap updateData = new HashMap();

      String seq = StringUtil.checkNull(request.getParameter("seq"));
      String saveMyItem = StringUtil.checkNull(request.getParameter("saveMyItem"));
      String delMyItem = StringUtil.checkNull(request.getParameter("delMyItem"));
      String roleType = StringUtil.checkNull(request.getParameter("roleType"));
      String assigned = StringUtil.checkNull(request.getParameter("assigned"));
      String assignmentType = StringUtil.checkNull(request.getParameter("assignmentType"));
      String orderNum = StringUtil.checkNull(request.getParameter("orderNum"));
      String accessRight = StringUtil.checkNull(request.getParameter("accessRight"));
      String memberID = StringUtil.checkNull(request.getParameter("memberID"));
      String[] arrayItems = saveMyItem.split(",");

      if (!"".equals(saveMyItem)) {
        for (int i = 0; i < arrayItems.length; i++) {
          if (seq.equals("")) {
            insertData.put("memberID", memberID);
            insertData.put("itemID", arrayItems[i]);
            insertData.put("roleType", roleType);
            insertData.put("assigned", assigned);
            insertData.put("assignmentType", assignmentType);
            insertData.put("orderNum", orderNum);
            insertData.put("accessRight", accessRight);
            insertData.put("creator", cmmMap.get("sessionUserId"));
            this.commonService.insert("role_SQL.insertRoleAssignment", insertData);
          } else {
            updateData.put("seq", seq);
            updateData.put("itemID", arrayItems[i]);
            updateData.put("roleType", roleType);
            updateData.put("assigned", assigned);
            updateData.put("assignmentType", assignmentType);
            updateData.put("orderNum", orderNum);
            updateData.put("accessRight", accessRight);
            updateData.put("lastUser", cmmMap.get("sessionUserId"));
            this.commonService.update("role_SQL.updateRoleAssignment", updateData);
          }
        }
      }
      if (!"".equals(delMyItem)) {
        updateData = new HashMap();
        String[] seqSpl = delMyItem.split(",");
        for (int i = 0; i < seqSpl.length; i++) {
          seq = seqSpl[i];
          updateData.put("itemID", seq);
          this.commonService.update("role_SQL.deleteRoleAssignment", updateData);
        }
      }
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "fnItemMenuReload();");
    } catch (Exception e) {
      System.out.println(e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
    }

    model.addAttribute("resultMap", target);
    return nextUrl("/cmm/ajaxResult/ajaxPage"); } 
  @RequestMapping({"/hec/zhec_getInboundLinkList.do"})
  public String zhec_getInboundLinkList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    Map setMap = new HashMap();
    String result = "";
    try {
      String code = StringUtil.checkNull(commandMap.get("code"));
      String itemTypeCode = StringUtil.checkNull(commandMap.get("itemTypeCode"));
      String classCode = StringUtil.checkNull(commandMap.get("classCode"));

      if (itemTypeCode.equals("")) itemTypeCode = "OJ00005";
      if (classCode.equals("")) classCode = "CL05003";

      setMap.put("identifier", code);
      setMap.put("itemTypeCode", itemTypeCode);
      setMap.put("languageID", Integer.valueOf(1042));
      setMap.put("classCode", classCode);
      List inboundLinkList = this.commonService.selectList("custom_SQL.zhec_getInboundLinkList", setMap);
      JSONArray inboundLinkData = new JSONArray(inboundLinkList);

      target.put("SCRIPT", inboundLinkData);

      model.addAttribute("resultMap", target);
    }
    catch (Exception e) {
      result = "{\\\"ResultCode:2000\\\",\\\"Result\\\":[]}";
      target.put("SCRIPT", result);

      model.addAttribute("resultMap", target);
      e.printStackTrace();
    }
    return nextUrl("/cmm/ajaxResult/ajaxNoScriptPage"); } 
  @RequestMapping({"/hec/checkConnectionHwayDB.do"})
  @ResponseBody
  @ResponseStatus(HttpStatus.OK)
  public void checkConnectionHwayDB(HttpServletResponse response) throws Exception { Map setData = new HashMap();
    Map returnValues = new HashMap();
    Map results = new HashMap();
    try
    {
      String result = this.commonService.selectString("custom_SQL.zhec_checkConnectionDB", setData);
      returnValues.put("status", "0");
      returnValues.put("contents", "정상");
    } catch (Exception e) {
      returnValues.put("status", "2");
      returnValues.put("contents", "에러");
    }

    JSONObject jsonData = new JSONObject();
    jsonData.put("results", returnValues);

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    PrintWriter out = response.getWriter();
    out.print(jsonData);
    out.flush();
  }
}