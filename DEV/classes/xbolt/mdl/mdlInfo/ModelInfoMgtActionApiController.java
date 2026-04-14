package xbolt.mdl.mdlInfo;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;
import xbolt.mdl.mdItm.dto.item.ModelElmDTO;
import org.springframework.web.bind.annotation.ModelAttribute;

@Controller
@SuppressWarnings("unchecked")
public class ModelInfoMgtActionApiController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/getModelElmList.do", produces = "application/json; charset=utf8")
	@ResponseBody
	public void getModelElmList(@ModelAttribute ModelElmDTO modelElmDTO, HttpServletRequest request, HttpServletResponse response, HashMap cmmMap) throws Exception {

		List<Map<String, Object>> resultData = new ArrayList<>();
		Map modelMap = new HashMap();
		List<Map<String, Object>> prcList = new ArrayList();

		try {
			String s_itemID = StringUtil.checkNull(modelElmDTO.getS_itemID(), "");
			String modelID = StringUtil.checkNull(modelElmDTO.getModelID(), "");
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),
			StringUtil.checkNull(modelElmDTO.getLanguageID()));
			String gridChk = StringUtil.checkNull(modelElmDTO.getGridChk(), "element");

			String MTCategory = StringUtil.checkNull(modelElmDTO.getMTCategory(), "");

			cmmMap.put("ItemID", s_itemID);
			cmmMap.put("languageID", languageID);
			cmmMap.put("ModelID", modelID);
			cmmMap.put("MTCategory", MTCategory);

			if ("connection".equals(gridChk)) {
				resultData = commonService.selectList("model_SQL.getElementCxnItemList_gridList", cmmMap);
			} else {
				modelMap = commonService.select("model_SQL.getModelViewer", cmmMap);
				if (modelMap == null || modelMap.isEmpty()) {
					 response.setContentType("application/json; charset=UTF-8");
					 response.getWriter().print("[]");
					 return;
				}

				cmmMap.put("modelID", modelMap.get("ModelID"));
				cmmMap.put("gridChk", gridChk);
				cmmMap.put("cxnYN", "N");

				if (gridChk.equals("element")) {
					cmmMap.put("classCode", StringUtil.checkNull(modelElmDTO.getClassCode(), ""));
					cmmMap.put("searchKey", StringUtil.checkNull(modelElmDTO.getSearchKey(), ""));
					cmmMap.put("searchValue", StringUtil.checkNull(modelElmDTO.getSearchValue(), ""));

					List<Map<String, Object>> classCodes = (List) commonService
							.selectList("common_SQL.getElementClassCode_commonSelect", cmmMap);
					prcList = (List) commonService.selectList("model_SQL.getElementItemList_gridList", cmmMap);

					List<Map<String, Object>> classCodeList = classCodes.stream().map(item -> {
						Map<String, Object> newMap = new java.util.HashMap<>(item);
						newMap.put("id", newMap.get("CODE"));
						newMap.put("ItemName", newMap.get("NAME"));
						newMap.put("parent", "1");
						newMap.remove("CODE");
						newMap.remove("NAME");
						return newMap;
					}).collect(Collectors.toList());

					for (int i = 0; i < prcList.size(); i++) {
						Map<String, Object> newMap = new java.util.HashMap<>(prcList.get(i));
						newMap.put("ItemName", newMap.get("Identifier") + " " + newMap.get("ItemName"));
						classCodeList.add(newMap);
					}

					modelMap.put("id", "1");
					modelMap.put("ItemName", modelMap.get("ModelName") + "(" + modelMap.get("MCName") + ")");
					modelMap.remove("LastUpdated");
					classCodeList.add(modelMap);
					resultData = classCodeList;
				} else if (gridChk.equals("group")) {
					cmmMap.put("groupClassCode", StringUtil.checkNull(modelElmDTO.getGroupClassCode(), ""));
					cmmMap.put("groupElementCode", StringUtil.checkNull(modelElmDTO.getGroupElementCode(), ""));

					prcList = (List) commonService.selectList("model_SQL.getGroupElementItemList_gridList", cmmMap);

					prcList = prcList.stream().map(item -> {
						Map<String, Object> newMap = new java.util.HashMap<>(item);
						newMap.put("parent", item.get("GroupItemID"));
						newMap.put("ItemName", item.get("ChildID") + " " + item.get("ChildItemName"));
						return newMap;
					}).collect(Collectors.toList());

					List<Map<String, Object>> classCodes = commonService
							.selectList("common_SQL.getGroupElementClassCode_commonSelect", cmmMap);
					List<Map<String, Object>> elementList = new ArrayList<>();

					for (int i = 0; i < classCodes.size(); i++) {
						Map classInfo = classCodes.get(i);
						cmmMap.put("classCode", classInfo.get("CODE"));
						List<Map<String, Object>> elementGroup = (List) commonService
                                .selectList("common_SQL.getGroupElementCode_commonSelect", cmmMap);

						elementGroup.stream().map(item -> {
							Map<String, Object> newMap = new java.util.HashMap<>(item);
							newMap.put("id", item.get("ItemID"));
							newMap.put("ItemName", classInfo.get("NAME") + " - " + item.get("NAME"));
							newMap.put("parent", "1");
							return newMap;
						}).forEach(elementList::add);
					}

					modelMap.put("id", "1");
					modelMap.put("ItemName", modelMap.get("ModelName") + "(" + modelMap.get("MCName") + ")");
					modelMap.remove("LastUpdated");
					elementList.add(modelMap);
					elementList.addAll(prcList);
					resultData = elementList;
				}
			}
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		}

		JSONArray jsonArray = new JSONArray(resultData);
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(jsonArray.toString());
	}
}