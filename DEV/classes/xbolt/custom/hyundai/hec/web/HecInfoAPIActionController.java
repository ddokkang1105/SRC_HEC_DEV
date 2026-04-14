package xbolt.custom.hyundai.hec.web;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONException;
import com.org.json.JSONObject;

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
import xbolt.file.util.FileUploadUtil;
import xbolt.itm.inf.dto.ItemListDTO;
import xbolt.itm.inf.dto.ItemSearchDTO;
import xbolt.itm.inf.service.ItemInfoAPIServiceImpl;
import xbolt.project.cs.dto.ChangeSetListInfoDTO;
import xbolt.project.cs.service.CSInfoAPIServiceImpl;

/**
 * 업무 처리
 * 
 * @Class Name : CsInfoAPIActionController.java
 * @Description : cs 관련 API 호출용 자바 
 * @Modification Information
 * @수정일 수정자 수정내용
 * @--------- --------- -------------------------------
 * @2012. 09. 01. smartfactory 최초생성
 * 
 * @since 2026. 01. 26.
 * @version 1.0
 */
@Controller
public class HecInfoAPIActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name="CSService")
	private CommonService CSService;
	
	@Autowired
    private FileUploadUtil fileUploadUtil;
	
	@Resource(name = "ItemInfoApiService")
	private ItemInfoAPIServiceImpl itemInfoAPIService;
	
	private static final ObjectMapper DTO_MAPPER;

    static {
        DTO_MAPPER = new ObjectMapper();
        // JSON에만 있는 필드는 무시하고 진행
        DTO_MAPPER.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        // 메서드(Getter/Setter)는 무시하고, 실제 변수(Field)로 확인
        DTO_MAPPER.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.NONE);
        DTO_MAPPER.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
    }
	
    
    @RequestMapping({"/zHecSopMainV4.do"})
    public String zHecSopMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception { 

    	String scrnUrl = StringUtil.checkNull(cmmMap.get("scrnUrl"), "zHecSopMainV4");
    	if ("".equals(scrnUrl)) scrnUrl = "zHecSopMainV4";
    	
    	try {
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
    	return nextUrl("/custom/hyundai/hec/subMain/" + scrnUrl); 
    	
    } 
    
    
    //STP 메인
    
    @RequestMapping({"/zHecStpMainV4.do"})
    public String zHecStpMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception { 
    	String scrnUrl = StringUtil.checkNull(cmmMap.get("scrnUrl"), "zHecStpMainV4");
    	if ("".equals(scrnUrl)) scrnUrl = "zHecStpMainV4";
    	
    	try {
    		Map setMap = new HashMap();
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

      return nextUrl("/custom/hyundai/hec/subMain/" + scrnUrl); 
      
    } 
    
	// 아이템 리스트
	@RequestMapping(value = "zhec_getItemListInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public void zhec_getItemListInfo(ItemListDTO itemListDTO, ItemSearchDTO itemSearchDTO, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    JSONObject resultMap = new JSONObject();
	    Map setMap = new HashMap();
	    List subItemList = new ArrayList();
	    
	    boolean success = false;

	    try {
	    	
	    	// parameter put
	        setMap = DTO_MAPPER.convertValue(itemListDTO, Map.class);
	        Map searchMap = DTO_MAPPER.convertValue(itemSearchDTO, Map.class);
	        setMap.putAll(searchMap);
	        
	        // attr 값 setting
	        List<Map<String, Object>> attrList = new ArrayList<>();
	    	attrList = itemInfoAPIService.getAttrCodeList(itemSearchDTO.getAttrCodeOLM_MULTI_VALUE());
	        setMap.put("AttrCode", attrList);
	    	
	    	// dimension 값 setting
	    	String DimValueIDOLM_ARRAY_VALUE = itemSearchDTO.getDimValueIDOLM_ARRAY_VALUE();
	    	if (DimValueIDOLM_ARRAY_VALUE != null && !DimValueIDOLM_ARRAY_VALUE.isEmpty()) {
	    	    String[] dimValueArray = DimValueIDOLM_ARRAY_VALUE.split(",");
	    	    setMap.put("DimValueID", dimValueArray);
	    	}
	    	
	    	setMap.put("sessionUserID", itemListDTO.getSessionUserId());
	    	
	        // select
	        if("child".equals(itemListDTO.getListType())) {
	        	if("OPS".equals(itemListDTO.getAccMode())) subItemList = commonService.selectList("zHEC_SQL.zhec_getChildItemList_gridList", setMap);
	        	else subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
	        } else {
	        	subItemList = commonService.selectList("zHEC_SQL.zhec_getSearchMultiList_gridList",setMap);
	        }
	    	
	        resultMap.put("data", subItemList);
	        success = true;

	    } catch (IllegalArgumentException e) {
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (DataAccessException e) {
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (JSONException e) {
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (Exception e) {
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } finally {

	        resultMap.put("success", success);

	        try {
	            // send to json
	            response.getWriter().print(resultMap);
	        } catch (Exception e) {
	            System.err.println(e.getMessage());
	        }
	    }
	}
	
	@RequestMapping({"/zhec_saveItemInfoAPI.do"})
	public String zhec_saveItemInfoAPI(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception { HashMap target = new HashMap();
	    try {
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
	        target = zhec_CreateItemFunctionAPI(request, commandMap, model);
	      }
	      else if (scrnMode.equals("D")) {
	        target = zhec_DeleteItemFunctionAPI(request, commandMap, model);
	      }
	      else
	      {
	        target = zhec_UpdateItemFunctionAPI(request, commandMap, model);
	      }
	    }
	    catch (Exception e) {
	      System.out.println(e);
	      target.put("SCRIPT", "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
	      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
	    }
	    model.addAttribute("resultMap", target);
	    return nextUrl("/cmm/ajaxResult/ajaxPage"); 
    } 
	
	public HashMap zhec_CreateItemFunctionAPI(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
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
	          insertCngMap.put("projectID", projectID);
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
	
	public HashMap zhec_UpdateItemFunctionAPI(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
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
	        
	        
	        // file upload 공통 사용
	        String errorMessage = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068");
	        String fltpCode = "FLTP003";
	        if (itemTypeCode.equals("OJ00016")) {
	          fltpCode = "FLTP1601";
	        }
	        
	        Map fileUploadMap = new HashMap();
			String uploadToken = StringUtil.checkNull(commandMap.get("uploadToken"), "");
			commandMap.put("fltpCode",fltpCode);
			commandMap.put("fileMgt", "ITM"); 
			commandMap.put("DocumentID", itemId);
			commandMap.put("ItemID", itemId); 
			commandMap.put("ChangeSetID", changeSetID);
			commandMap.put("DocCategory", "ITM");	
			commandMap.put("projectID", commandMap.get("projectId"));
			commandMap.put("uploadToken",uploadToken);
			
			fileUploadMap = fileUploadUtil.fileUpload(commandMap, request);
			
			boolean fileUploadResult = (boolean) fileUploadMap.getOrDefault("result",false);
			if(!fileUploadResult) {
				errorMessage = StringUtil.checkNull(fileUploadMap.get("message"),"파일 업로드 실패");
				throw new Exception(errorMessage);
			} else {
				
			  // file upload 성공 경우
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
	          String l0Cnt = StringUtil.checkNull(this.commonService.selectString("zHEC_SQL.zhec_GetL0ItemIDCnt", setMap), "0");

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
			
			// 성공 시 업로드 토큰 업데이트
			// file upload token
			HttpSession session = request.getSession(true);
			uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
			
			target.put("uploadToken", uploadToken);
	        target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
	        target.put("SCRIPT", "parent.fnEditCallBack('" + plantYN + "', '" + uploadToken + "')");
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
	
	public HashMap zhec_DeleteItemFunctionAPI(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception
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
	
}
