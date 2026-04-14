package xbolt.custom.sk.skon;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.IOException;
import java.util.*;

/**
 * @Class Name : SKONAIController.java
 * @Description : SKONAIController.java
 * @Modification Information
 * @수정일 수정자 수정내용 @ @2025. 09. 16.
 * @since 2025. 09. 16.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class SKONAIController extends XboltController {
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping("/zSKON_processReportByMDFile.do")
	@ResponseBody
	public String zSKON_processReportByMDFile(HttpServletRequest request) {
		try {
			ProcessReportGenerator generator = new ProcessReportGenerator(commonService);
			generator.generate(request);
			return "Markdown has been created.";
		} catch (Exception e) {
			e.printStackTrace();
			return "An error has occurred during making Markdown File: " + e.getMessage();
		}
	}

	// === 클래스 ===
	public static class ProcessReportGenerator {

		@FunctionalInterface
		interface ThrowingRunnable {
			void run() throws Exception;
		}

		private final CommonService commonService;
		private static final String SAVE_PATH = "D:/OLM_MD/";

		private static final String SECTION_SEPARATOR = "---";

		// 연관문서
		private enum RelationType {
			PROCESS("OJ00001", "Process"),
			TECH_STANDARD("OJ00016", "Tech. Standard"),
			TERM_DEFINITION("OJ00011", "용어의 정의");

			private final String code;
			private final String displayName;

			RelationType(String code, String displayName) {
				this.code = code;
				this.displayName = displayName;
			}

			public String getCode() {
				return code;
			}

			public String getDisplayName() {
				return displayName;
			}
		}

		public ProcessReportGenerator(CommonService commonService) {
			this.commonService = commonService;
		}

		public void generate(HttpServletRequest request) {
			try {
				String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
				String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");

				Map<String, Object> map = new HashMap<>();
				map.put("languageID", languageID);
				map.put("itemID", itemID);

				StringBuilder fileContent = new StringBuilder();
				appendSection(fileContent, () -> appendBasicInfo(fileContent, map));
				appendSection(fileContent, () -> appendAttachments(fileContent, map));
				appendSection(fileContent, () -> appendRelations(fileContent, map, itemID, languageID));
				appendSection(fileContent, () -> appendCSInfo(fileContent, map, itemID));
				appendSection(fileContent, () -> appendActivity(fileContent, map));

				writeToFile(fileContent, itemID, languageID);

				System.out.println("\n=== Markdown Report Has Been Created ===");

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("An error has occurred: " + e.getMessage());
			}
		}

		private void appendBasicInfo(StringBuilder sb, Map<String, Object> map) throws Exception {
			Map<String, Object> process = commonService.select("zSK_AI_SQL.get_process_md", map);
			List<Map<String, Object>> attributes = commonService.selectList("zSK_AI_SQL.get_process_attr_md", map);

			List<String> attrOrder = Arrays.asList("문서명", "담당Site", "문서레벨", "영역", "상세영역", "문서유형", "목적", "적용범위", "책임과 권한", "기록 및 보관", "키워드");

			Map<String, String> attrMap = new HashMap<>();
			for (Map<String, Object> attr : attributes) {
				attrMap.put(safeString(attr.get("Name")), safeString(attr.get("PlainText")));
			}

			appendLine(sb,
					"## 기본정보",
					"- ID: " + safeString(process.get("ItemID")),
					"문서번호: " + safeString(process.get("Identifier")),
					"개정번호: " + safeString(process.get("Version")),
					"담당부서: " + safeString(process.get("TeamName")),
					"담당자: " + safeString(process.get("authorName")),
					"배포Site: " + safeString(process.get("dimSite"))
			);

			for (String key : attrOrder) {
				if (attrMap.containsKey(key)) {
					appendLine(sb, key + ": " + escapeYaml(attrMap.get(key)));
				}
			}
			appendLine(sb, "주요개정사항: " + escapeYaml(safeString(process.get("Description"))), "");
		}

		private void appendAttachments(StringBuilder sb, Map<String, Object> map) throws Exception {
			List<Map<String, Object>> files = commonService.selectList("zSK_AI_SQL.get_file_md", map);

			appendLine(sb, "## 첨부문서");
			int index = 1;
			for (Map<String, Object> f : files) {
				appendLine(sb, "- No. " + index++);
				appendMapLines(sb, f,
						Arrays.asList("FileType", "FileRealName", "Version", "authorName", "CreationDate", "FileRealPath"),
						Arrays.asList("문서유형 : ", "문서명 : ", "개정번호 : ", "작성자 : ", "등록일 : ", "파일 실제 경로 : ")
				);
				appendLine(sb, "");
			}
		}

		private void appendRelations(StringBuilder sb, Map<String, Object> map, String itemID, String languageID) throws Exception {
			map.put("defaultLang", languageID);
			map.put("s_itemID", itemID);

			appendLine(sb, "## 연관문서");

			for (RelationType rt : RelationType.values()) {
				map.put("ItemTypeCode", rt.getCode());
				List<Map<String, Object>> cxnList = commonService.selectList("zSK_SQL.getCxnItemList_gridList", map);

				if (cxnList != null && !cxnList.isEmpty()) {
					appendLine(sb, "### " + rt.getDisplayName());

					int index = 1;
					for (Map<String, Object> cxn : cxnList) {
						appendLine(sb, "- No. " + index++);
						if (!rt.equals(RelationType.TERM_DEFINITION)) {
							appendMapLines(sb, cxn,
									Arrays.asList("DocLevValue", "DocTypeValue", "path", "ItemName", "Identifier"),
									Arrays.asList("문서레벨 : ", "문서유형 : ", "문서경로 : ", "문서명 : ", "문서번호 : ")
							);
						} else {
							appendMapLines(sb, cxn,
									Arrays.asList("ItemName", "ProcessInfo"),
									Arrays.asList("용어 : ", "용어의 정의 : ")
							);
						}
						appendLine(sb, "");
					}
					appendLine(sb, "");
				}
			}
		}

		private void appendCSInfo(StringBuilder sb, Map<String, Object> map, String itemID) throws Exception {
			map.put("s_itemID", itemID);
			List<Map<String, Object>> csLists = commonService.selectList("cs_SQL.getItemChangeList_gridList", map);

			appendLine(sb, "## 변경이력");
			int index = 1;
			for (Map<String, Object> cs : csLists) {
				if (!"MOD".equals(cs.get("ChangeStsCode"))) {
					appendLine(sb, "- No. " + index++);
					appendMapLines(sb, cs,
							Arrays.asList("ChangeType", "Identifier", "ItemName", "Description", "Version", "RequestUserName", "RequestUserTeamName", "ApproveDate", "ChangeSts"),
							Arrays.asList("변경구분 : ", "문서번호 : ", "문서명 : ", "주요개정사항 : ", "개정번호 : ", "담당자 : ", "담당부서 : ", "제/개정일자 : ", "문서상태 : ")
					);
					appendLine(sb, "");
				}
			}
		}

		private void appendActivity(StringBuilder sb, Map<String, Object> map) throws Exception {
			List<Map<String, Object>> activityIDs = commonService.selectList("zSK_AI_SQL.get_actovity_md", map);

			appendLine(sb, "## 업무처리 절차");
			int index = 1;

			for (Map<String, Object> a : activityIDs) {
				map.put("s_itemID", a.get("ToItemID"));
				List<Map<String, Object>> activityLists = commonService.selectList("zSK_SQL.getPrcActivityList", map);

				for (Map<String, Object> act : activityLists) {
					appendLine(sb, "- No. " + index++);
					appendMapLines(sb, act,
							Arrays.asList("Activity", "ItemID"),
							Arrays.asList("문서명 : ", "ID : ")
					);

					appendLine(sb, "RASI");
					Arrays.asList("R", "A", "S", "I").forEach(role ->
							appendRoleList(sb, role, escapeYaml((String) act.get(role.toLowerCase() + "_text")))
					);

					appendMapLines(sb, act,
							Arrays.asList("Input", "Output", "PerformanceSystem"),
							Arrays.asList("입력물 : ", "출력물 : ", "수행 시스템 : ")
					);
					appendLine(sb, ""); // 줄바꿈
				}
			}
		}

		private void appendMapLines(StringBuilder sb, Map<String, Object> map, List<String> keys, List<String> labels) {
			for (int i = 0; i < keys.size(); i++) {
				String value = safeString(map.get(keys.get(i)));
				if ("ProcessInfo".equals(keys.get(i))) {
					value = escapeYaml(value);
				}
				sb.append(labels.get(i)).append(value).append("\n");
			}
		}

		private void appendSection(StringBuilder sb, ThrowingRunnable appendContent) {
			try {
				appendContent.run();
				appendLine(sb, SECTION_SEPARATOR);
			} catch (Exception e) {
				throw new RuntimeException("섹션 처리 중 오류 발생", e);
			}
		}

		private void appendLine(StringBuilder sb, String... lines) {
			for (String line : lines) {
				if (line != null) {
					sb.append(line).append("\n");
				}
			}
		}

		private void appendRoleList(StringBuilder sb, String role, String roleText) {
			appendLine(sb, "- " + role + " :");

			if (roleText != null && !roleText.trim().isEmpty()) {
				String[] items = roleText.split("\\$\\$");
				for (String item : items) {
					String escaped = escapeYaml(item.trim());
					if (!escaped.isEmpty()) {
						appendLine(sb, "  - " + escaped);
					}
				}
			}
		}

		private String safeString(Object obj) {
			return obj == null ? "" : String.valueOf(obj);
		}

		private void writeToFile(StringBuilder fileContent, String itemID, String languageID) throws IOException {
			File dir = new File(SAVE_PATH);
			if (!dir.exists()) {
				dir.mkdirs();
			}
			String filename = String.format("process_report_%s_%s.md", itemID, languageID);
			try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File(dir, filename)), "UTF-8"))) {
				writer.write(fileContent.toString());
				System.out.println("[+] Saved: " + filename);
			}
		}

		private static String escapeYaml(String input) {
			if (input == null || input.isEmpty()) return "";
			String escaped = input.replace("\"", "\\\"")
					.replace("\r\n", " ")
					.replace("\n", " ")
					.replace("\r", " ");

			escaped = escaped.replaceAll("&amp;", "&");

			escaped = escaped.replaceAll(":(\\S)", ": $1");
			return escaped.trim();
		}
	}
}
