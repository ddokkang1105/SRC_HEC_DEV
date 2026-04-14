package xbolt.custom.daelim.itsm;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.ScriptStyle;
import jxl.format.UnderlineStyle;
import jxl.format.VerticalAlignment;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import org.springframework.util.StringUtils;
import org.springframework.web.servlet.view.document.AbstractJExcelView;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

//import com.ligs.itsm.value.close.service.ValueCloseServiceAdminDataExcelViewVO;

@SuppressWarnings("deprecation")
public class ValueCloseServiceAdminDataExcelView extends AbstractJExcelView{
	// logging
	//private static final Logger LOGGER = LoggerFactory.getLogger(ValueCloseServiceAdminDataExcelView.class);
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Override
	protected void buildExcelDocument(Map<String, Object> model, WritableWorkbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		//System.out.println("======> sApplyYm 1 : " + request.getParameter("applyYm"));
		//System.out.println("======> sCorpId 1 : " + request.getParameter("corpId"));
		
		String sApplyYm = StringUtil.checkNull(request.getParameter("applyYm"),"");
		String sCorpId = StringUtil.checkNull(request.getParameter("corpId"),"");

		
		//Map getData = new HashMap();
		//getData.put("APPLY_YM", sApplyYm);
		//getData.put("CORP_ID", sCorpId);
		
    	//ValueCloseServiceAdminDataExcelViewVO valueCloseAdminDataExcelViewVO = (ValueCloseServiceAdminDataExcelViewVO) model.get("ValueCloseServiceAdminDataExcelViewVO");
		//List<HashMap> dataList_SVC_CI_DATA_ITS000100 = (List<HashMap>) model.get("DataList_SVC_CI_DATA_ITS000100"); //운영관리
		//List<HashMap> dataList_SVC_CI_DATA_ITS000101 = (List<HashMap>) model.get("DataList_SVC_CI_DATA_ITS000101"); //장애관리
		//List<HashMap> dataList_SVC_CI_DATA_ITS000102 = (List<HashMap>) model.get("DataList_SVC_CI_DATA_ITS000102"); //개선관리
    	
    	//List<?> result1 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel", getData);
    	//List<?> result2 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_list1", getData);
    	//List<?> result3 = commonService.selectList("zDLMserviceCal_SQL.zDlm_selectServiceCalExcel_list2", getData);
		List<HashMap> result1 = (List<HashMap>) model.get("result1");
		List<HashMap> result2 = (List<HashMap>) model.get("result2");
		List<HashMap> result3 = (List<HashMap>) model.get("result3");
    	
    	Map<?, ?> excelMap1 = null;
    	Map<?, ?> excelMap2 = null;

    	//System.out.println("======> result1.size() 1 : " + result1.size());
    	//System.out.println("======> result2.size() 1 : " + result2.size());
    	//System.out.println("======> result3.size() 1 : " + result3.size());
    	
    	
    	
    	if(result1.size()>0){
    		//System.out.println("======> tot_v 1 : " + result1.get(0).get("TOT_V"));
    		//System.out.println("======> tot_v 2 : " + result1.get(1).get("TOT_V"));
    		
    		excelMap1 = (Map<?, ?>) result1.get(0);
    		excelMap2 = (Map<?, ?>) result1.get(1);
    		
    		//System.out.println("======> tot_v 3 : " + excelMap1.get("TOT_V"));
    		//System.out.println("======> tot_v 4 : " + excelMap2.get("TOT_V"));
    	}
    	
    	
		//HashMap _paramInfo = (HashMap) model.get("_paramInfo");
    	
		
		String fileName = createFileName(sApplyYm);
		setFileNameToResponse(request, response, fileName);
		
		// 검색된 데이터없음
		/*
		if (dataList_CLOSE_INFO.isEmpty() && dataList_ITEM.isEmpty() && dataList_SVC_TYPE.isEmpty() && dataList_SVC.isEmpty() && dataList_SVC_UNIT_PRICE.isEmpty() && dataList_SVC_ITS000103_APPLY.isEmpty() && dataList_SVC_APPLY_YN.isEmpty()) {
			workbook.createSheet("NODATA", 0);
			return;
		}
		*/
		
		//DarkTeal
		WritableCellFormat cellFormat_DarkTeal = new WritableCellFormat();    //셀의 스타일을 지정하기 위한 부분입니다.
		WritableFont font_DarkTeal = new WritableFont(WritableFont.ARIAL,
			10,
			WritableFont.BOLD,
			false,
			UnderlineStyle.NO_UNDERLINE,
			Colour.WHITE,
			ScriptStyle.NORMAL_SCRIPT);
		cellFormat_DarkTeal.setFont(font_DarkTeal);
		cellFormat_DarkTeal.setBorder(Border.ALL , BorderLineStyle.THIN);
		cellFormat_DarkTeal.setBackground(Colour.DARK_TEAL);
		cellFormat_DarkTeal.setAlignment(Alignment.CENTRE); 
		cellFormat_DarkTeal.setVerticalAlignment(VerticalAlignment.CENTRE);
		
		//Gray
		WritableCellFormat cellFormat_Gray = new WritableCellFormat();
		cellFormat_Gray.setBorder(Border.ALL , BorderLineStyle.THIN);
		cellFormat_Gray.setBackground(Colour.GRAY_25);
		cellFormat_Gray.setAlignment(Alignment.CENTRE); 
		cellFormat_Gray.setVerticalAlignment(VerticalAlignment.CENTRE);
		
		//LightBlue
		WritableCellFormat cellFormat_LightBlue = new WritableCellFormat();
		cellFormat_LightBlue.setBorder(Border.ALL , BorderLineStyle.THIN);
		cellFormat_LightBlue.setBackground(Colour.LIGHT_TURQUOISE2);
		cellFormat_LightBlue.setAlignment(Alignment.CENTRE); 
		cellFormat_LightBlue.setVerticalAlignment(VerticalAlignment.CENTRE);
		
		//White (none)
		WritableCellFormat cellFormat_None = new WritableCellFormat();
		cellFormat_None.setBorder(Border.ALL , BorderLineStyle.THIN);
		cellFormat_None.setAlignment(Alignment.CENTRE);
		cellFormat_None.setVerticalAlignment(VerticalAlignment.CENTRE);
		
		/************************** 파라미터
		Cell 생성 : COLUMN, ROW, Cell Text, Cell Style
		Cell 병합 : startCOLUMN, startROW, endCOLUMN, endROW
		***************************/
		
		/**** 개선관리 ****/
		WritableSheet sheet3 = workbook.createSheet("개선관리",0);
		//Cell 가로 너비 조정
		sheet3.setColumnView(0, 15);
		sheet3.setColumnView(1, 20);
		sheet3.setColumnView(2, 20);
		sheet3.setColumnView(3, 20);
		sheet3.setColumnView(4, 20);
		sheet3.setColumnView(5, 20);
		sheet3.setColumnView(6, 20);
		sheet3.setColumnView(7, 20);
		sheet3.setColumnView(8, 20);
		sheet3.setColumnView(9, 20);
		sheet3.setColumnView(10, 20);
		sheet3.setColumnView(11, 20);
		sheet3.setColumnView(12, 20);
		
		//Cell 세로 높이 조정
		sheet3.setRowView(0, 600);
		sheet3.setRowView(1, 600);
		sheet3.setRowView(2, 600);
		sheet3.setRowView(3, 600);
		sheet3.setRowView(4, 600);
		sheet3.setRowView(5, 600);
		sheet3.setRowView(6, 600);
		sheet3.setRowView(7, 600);
		sheet3.setRowView(8, 600);
		sheet3.setRowView(9, 600);
		sheet3.setRowView(10, 600);
		sheet3.setRowView(11, 600);
		sheet3.setRowView(12, 600);
		sheet3.setRowView(13, 600);
		
		/* Header Start */
		sheet3.addCell(new jxl.write.Label(0, 0, "서비스종류", cellFormat_DarkTeal));
		
		sheet3.addCell(new jxl.write.Label(1, 0, "기본규모 측정요소", cellFormat_DarkTeal));
		sheet3.mergeCells(1, 0, 7, 0);
		
		sheet3.addCell(new jxl.write.Label(8, 0, "특정규모 측정요소", cellFormat_DarkTeal));
		sheet3.mergeCells(8, 0, 9, 0);
		
		sheet3.addCell(new jxl.write.Label(10, 0, "역량규모 측정요소", cellFormat_DarkTeal));
		sheet3.mergeCells(10, 0, 12, 0);
		/* Header End */
		
		/* Content Start */
			/* 서비스 종류 Start */
			sheet3.addCell(new jxl.write.Label(0, 1, "개선관리", cellFormat_Gray));
			sheet3.mergeCells(0, 1, 0, 12);
			/* 서비스 종류 End */
			
			/* 기본규모 측정요소 Start */
			
			
			/************************** 파라미터
			Cell 생성 : COLUMN, ROW, Cell Text, Cell Style
			Cell 병합 : startCOLUMN, startROW, endCOLUMN, endROW
			***************************/
			
			sheet3.addCell(new jxl.write.Label(1, 1, "구분", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(2, 1, "가중치", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(3, 1, "구분", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 1, "산출물", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(5, 1, "산출물개수", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(6, 1, "ITO가중치", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(7, 1, "계", cellFormat_None));
			
			sheet3.addCell(new jxl.write.Label(1, 2, "① 신규", cellFormat_None));
			sheet3.mergeCells(1, 2, 1, 6);
			sheet3.addCell(new jxl.write.Label(1, 7, "② 변경/삭제", cellFormat_None));
			sheet3.mergeCells(1, 7, 1, 11);
			
			sheet3.addCell(new jxl.write.Label(2, 2, "1.0", cellFormat_None));
			sheet3.mergeCells(2, 2, 2, 6);
			sheet3.addCell(new jxl.write.Label(2, 7, "0.7", cellFormat_None));
			sheet3.mergeCells(2, 7, 2, 11);
			
			sheet3.addCell(new jxl.write.Label(3, 2, "트랜잭션기능", cellFormat_None));
			sheet3.mergeCells(3, 2, 3, 5);
			
			sheet3.addCell(new jxl.write.Label(3, 7, "트랜잭션기능", cellFormat_None));
			sheet3.mergeCells(3, 7, 3, 10);
			
			sheet3.addCell(new jxl.write.Label(3, 6, "데이터기능", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(3, 11, "데이터기능", cellFormat_None));

			sheet3.addCell(new jxl.write.Label(1, 12, "기본규모산정", cellFormat_None));
			sheet3.mergeCells(1, 12, 3, 12);
			
			sheet3.addCell(new jxl.write.Label(4, 2, "화면기능 *", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 3, "배치프로그램 *", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 4, "Config. 화면(패키지) *", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 5, "Data( SQL) 프로 그램 *", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 6, "테이블 *", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 7, "화면기능 *", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 8, "배치프로그램 *", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 9, "Config. 화면(패키지) *", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 10, "Data( SQL) 프로 그램 *", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 11, "테이블 *", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(4, 12, "=① + ②", cellFormat_None));
			
			/*
			sheet3.addCell(new jxl.write.Number(5, 2, ((BigDecimal)excelMap2.get("SMI015_SMID020_1")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 3, ((BigDecimal)excelMap2.get("SMI015_SMID021_1")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 4, ((BigDecimal)excelMap2.get("SMI015_SMID022_1")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 5, ((BigDecimal)excelMap2.get("SMI016_SMID023_1")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 6, ((BigDecimal)excelMap2.get("SMI017_SMID024_1")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 7, ((BigDecimal)excelMap2.get("SMI015_SMID025_1")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 8, ((BigDecimal)excelMap2.get("SMI015_SMID026_1")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 9, ((BigDecimal)excelMap2.get("SMI015_SMID027_1")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 10, ((BigDecimal)excelMap2.get("SMI016_SMID028_1")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 11, ((BigDecimal)excelMap2.get("SMI017_SMID029_1")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 12, ((BigDecimal)excelMap2.get("TOT_V")), cellFormat_None));
			*/
			sheet3.addCell(new jxl.write.Number(5, 2, ((BigDecimal)excelMap2.get("SMI015_SMID020_1")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 3, ((BigDecimal)excelMap2.get("SMI015_SMID021_1")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 4, ((BigDecimal)excelMap2.get("SMI015_SMID022_1")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 5, ((BigDecimal)excelMap2.get("SMI016_SMID023_1")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 6, ((BigDecimal)excelMap2.get("SMI017_SMID024_1")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 7, ((BigDecimal)excelMap2.get("SMI015_SMID025_1")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 8, ((BigDecimal)excelMap2.get("SMI015_SMID026_1")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 9, ((BigDecimal)excelMap2.get("SMI015_SMID027_1")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 10, ((BigDecimal)excelMap2.get("SMI016_SMID028_1")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 11, ((BigDecimal)excelMap2.get("SMI017_SMID029_1")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(5, 12, ((BigDecimal)excelMap2.get("TOT_V")).doubleValue(), cellFormat_None));
			
			sheet3.mergeCells(5, 12, 7, 12);
			
			sheet3.addCell(new jxl.write.Label(6, 2, "4.3", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(6, 3, "4.3", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(6, 4, "4.3", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(6, 5, "1.4", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(6, 6, "6.8", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(6, 7, "4.3", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(6, 8, "4.3", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(6, 9, "4.3", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(6, 10, "1.4", cellFormat_None));
			sheet3.addCell(new jxl.write.Label(6, 11, "6.8", cellFormat_None));
			/*
			sheet3.addCell(new jxl.write.Number(7, 2, ((BigDecimal)excelMap2.get("SMI015_SMID020")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 3, ((BigDecimal)excelMap2.get("SMI015_SMID021")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 4, ((BigDecimal)excelMap2.get("SMI015_SMID022")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 5, ((BigDecimal)excelMap2.get("SMI016_SMID023")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 6, ((BigDecimal)excelMap2.get("SMI017_SMID024")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 7, ((BigDecimal)excelMap2.get("SMI015_SMID025")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 8, ((BigDecimal)excelMap2.get("SMI015_SMID026")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 9, ((BigDecimal)excelMap2.get("SMI015_SMID027")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 10, ((BigDecimal)excelMap2.get("SMI016_SMID028")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 11, ((BigDecimal)excelMap2.get("SMI017_SMID029")), cellFormat_None));
			*/
			sheet3.addCell(new jxl.write.Number(7, 2, ((BigDecimal)excelMap2.get("SMI015_SMID020")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 3, ((BigDecimal)excelMap2.get("SMI015_SMID021")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 4, ((BigDecimal)excelMap2.get("SMI015_SMID022")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 5, ((BigDecimal)excelMap2.get("SMI016_SMID023")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 6, ((BigDecimal)excelMap2.get("SMI017_SMID024")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 7, ((BigDecimal)excelMap2.get("SMI015_SMID025")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 8, ((BigDecimal)excelMap2.get("SMI015_SMID026")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 9, ((BigDecimal)excelMap2.get("SMI015_SMID027")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 10, ((BigDecimal)excelMap2.get("SMI016_SMID028")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(7, 11, ((BigDecimal)excelMap2.get("SMI017_SMID029")).doubleValue(), cellFormat_None));
			/* 기본규모 측정요소 End */
			
			/* 특정규모 측정요소 Start */
			sheet3.addCell(new jxl.write.Label(8, 1, "측정요소", cellFormat_LightBlue));
			
			sheet3.addCell(new jxl.write.Label(8, 2, "① 개선사이즈 *", cellFormat_LightBlue));
			sheet3.mergeCells(8, 2, 8, 3);
			
			sheet3.addCell(new jxl.write.Label(8, 4, "② 애플리케이션유형 *", cellFormat_LightBlue));
			sheet3.mergeCells(8, 4, 8, 5);
			
			sheet3.addCell(new jxl.write.Label(8, 6, "③ 프로그래밍 언어 *", cellFormat_LightBlue));
			sheet3.mergeCells(8, 6, 8, 7);
			
			sheet3.addCell(new jxl.write.Label(8, 8, "", cellFormat_LightBlue));
			sheet3.mergeCells(8, 8, 8, 9);
			
			sheet3.addCell(new jxl.write.Label(8, 10, "", cellFormat_LightBlue));
			sheet3.mergeCells(8, 10, 8, 11);
			
			sheet3.addCell(new jxl.write.Label(8, 12, "특정규모산정", cellFormat_LightBlue));
			
			sheet3.addCell(new jxl.write.Label(9, 1, "보정계수", cellFormat_LightBlue));
			
			sheet3.addCell(new jxl.write.Number(9, 2, stringToDoubleValue("0"), cellFormat_LightBlue));
			sheet3.mergeCells(9, 2, 9, 3);
			
			sheet3.addCell(new jxl.write.Number(9, 4, stringToDoubleValue("0"), cellFormat_LightBlue));
			sheet3.mergeCells(9, 4, 9, 5);
			
			sheet3.addCell(new jxl.write.Number(9, 6, stringToDoubleValue("0"), cellFormat_LightBlue));
			sheet3.mergeCells(9, 6, 9, 7);
			
			sheet3.addCell(new jxl.write.Label(9, 8, "", cellFormat_LightBlue));
			sheet3.mergeCells(9, 8, 9, 9);
			
			sheet3.addCell(new jxl.write.Label(9, 10, "", cellFormat_LightBlue));
			sheet3.mergeCells(9, 10, 9, 11);
			
			sheet3.addCell(new jxl.write.Label(9, 12, "= 기본규모 * ( ① + ② + ③ * 0.57)   " + "0", cellFormat_LightBlue));
			/* 특정규모 측정요소 End */
			
			/* 역량규모 측정요소 Start */
			sheet3.addCell(new jxl.write.Label(10, 1, "", cellFormat_None));
			
			sheet3.addCell(new jxl.write.Label(10, 2, "① 긴급개선요청비율 *", cellFormat_None));
			sheet3.mergeCells(10, 2, 10, 3);
			
			sheet3.addCell(new jxl.write.Label(10, 4, "② 최초합의 납기일 준수율 *", cellFormat_None));
			sheet3.mergeCells(10, 4, 10, 5);
			
			sheet3.addCell(new jxl.write.Label(10, 6, "③ 성능향상비율 *", cellFormat_None));
			sheet3.mergeCells(10, 6, 10, 7);
			
			sheet3.addCell(new jxl.write.Label(10, 8, "④ 품질역량 수준", cellFormat_None));
			sheet3.mergeCells(10, 8, 10, 9);
			
			sheet3.addCell(new jxl.write.Label(10, 10, "", cellFormat_None));
			sheet3.mergeCells(10, 10, 10, 11);
			
			sheet3.addCell(new jxl.write.Label(10, 12, "역량규모산정", cellFormat_None));
			
			sheet3.addCell(new jxl.write.Label(11, 1, "", cellFormat_None));
			
			sheet3.addCell(new jxl.write.Number(11, 2, stringToDoubleValue("0"), cellFormat_None));
			sheet3.mergeCells(11, 2, 11, 3);
			
			sheet3.addCell(new jxl.write.Number(11, 4, stringToDoubleValue("0"), cellFormat_None));
			sheet3.mergeCells(11, 4, 11, 5);
			
			sheet3.addCell(new jxl.write.Number(11, 6, stringToDoubleValue("0"), cellFormat_None));
			sheet3.mergeCells(11, 6, 11, 7);
			
			/*
			if(StringUtils.isEmpty(valueCloseAdminDataExcelViewVO.getId_SMI025_1())) {
				sheet3.addCell(new jxl.write.Label(11, 8, "", cellFormat_None));
			} else {
				sheet3.addCell(new jxl.write.Label(11, 8, "CMMI " + valueCloseAdminDataExcelViewVO.getId_SMI025_1() + "레벨", cellFormat_None));
			}
			*/
			sheet3.addCell(new jxl.write.Label(11, 8, "", cellFormat_None));
			
			
			sheet3.mergeCells(11, 8, 11, 9);
			
			sheet3.addCell(new jxl.write.Label(11, 10, "", cellFormat_None));
			sheet3.mergeCells(11, 10, 12, 11);
			
			sheet3.addCell(new jxl.write.Label(11, 12, "'= (기본 규모 + 특성 규모) * ( ① + ② + ③ + ④ )", cellFormat_None));
			sheet3.addCell(new jxl.write.Number(12, 12, stringToDoubleValue("0"), cellFormat_None));
			
			sheet3.addCell(new jxl.write.Label(12, 1, "", cellFormat_None));
			
			sheet3.addCell(new jxl.write.Number(12, 2, stringToDoubleValue("0"), cellFormat_None));
			sheet3.mergeCells(12, 2, 12, 3);
			
			sheet3.addCell(new jxl.write.Number(12, 4, stringToDoubleValue("0"), cellFormat_None));
			sheet3.mergeCells(12, 4, 12, 5);
			
			sheet3.addCell(new jxl.write.Number(12, 6, stringToDoubleValue("0"), cellFormat_None));
			sheet3.mergeCells(12, 6, 12, 7);
			
			sheet3.addCell(new jxl.write.Number(12, 8, stringToDoubleValue("0"), cellFormat_None));
			sheet3.mergeCells(12, 8, 12, 9);
			
			sheet3.addCell(new jxl.write.Label(12, 10, "", cellFormat_None));
			sheet3.mergeCells(12, 10, 12, 11);
			/* 역량규모 측정요소 End */
		/* Content End */
			
		/* Footer Start */
		sheet3.addCell(new jxl.write.Label(0, 13, "서비스규모", cellFormat_Gray));
		sheet3.mergeCells(0, 13, 1, 13);
		
		sheet3.addCell(new jxl.write.Label(2, 13, "= 기본 규모 + 특성규모 + 역량규모 ", cellFormat_Gray));
		sheet3.mergeCells(2, 13, 4, 13);
		
		sheet3.addCell(new jxl.write.Number(5, 13, ((BigDecimal)excelMap2.get("TOT_V")).doubleValue(), cellFormat_Gray));
		sheet3.mergeCells(5, 13, 7, 13);
	
		sheet3.addCell(new jxl.write.Label(8, 13, "개선 관리 서비스 대가 산정", cellFormat_DarkTeal));
		sheet3.mergeCells(8, 13, 9, 13);
		
		sheet3.addCell(new jxl.write.Label(10, 13, "= 서비스 규모 x " + ((BigDecimal)excelMap2.get("PRICE")).doubleValue() + "원", cellFormat_DarkTeal));
		sheet3.mergeCells(10, 13, 11, 13);
		
		sheet3.addCell(new jxl.write.Number(12, 13, ((BigDecimal)excelMap2.get("TOT_P")).doubleValue(), cellFormat_DarkTeal));
		/* Footer End */
		
		//개선관리 서비스CI 조회 목록 시작
		int row = 14; //한줄띄움
		int col = 0;
		sheet3.addCell(new jxl.write.Label(col++, row, "NO", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "서비스", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "신규트랜잭션기능-화면기능", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "신규트랜잭션기능-배치프로그램", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "신규트랜잭션기능-Config화면", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "신규DATA(SQL)프로그램기능", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "신규데이터기능", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "변경트랜잭션기능-화면기능", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "변경트랜잭션기능-배치프로그램", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "변경트랜잭션기능-Config화면", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "변경DATA(SQL)프로그램기능", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "변경데이터기능", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "개선사이즈보정계수", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "애플리케이션유형보정계수", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "프로그래밍언어보정계수", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "구현품질보정계수", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "긴급개선요청비율", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "최초합의납기일준수율", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "성능향상비율", cellFormat_DarkTeal));
		sheet3.addCell(new jxl.write.Label(col++, row, "개선-품질역량수준", cellFormat_DarkTeal));
		row++;
		col = 0;
		for(int i=0; i < result3.size(); i++){
			
			Map excelMap3 = (Map) result3.get(i);
			
			col = 0;
			sheet3.addCell(new jxl.write.Label(col++, row, Integer.toString(i+1), cellFormat_None));
			sheet3.addCell(new jxl.write.Label(col++, row, (String) (excelMap3.get("SVC_CI_NAME")), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI015_SMID020")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI015_SMID021")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI015_SMID022")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI016_SMID023")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI017_SMID024")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI015_SMID025")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI015_SMID026")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI015_SMID027")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI016_SMID028")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI017_SMID029")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI018")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI019")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI020")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI021")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI022")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI023")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI024")).doubleValue(), cellFormat_None));
			sheet3.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap3.get("SMI025")).doubleValue(), cellFormat_None));
			row++;
		}
		
		
		
		
		
		/**** 장애관리 ****/
		WritableSheet sheet2 = workbook.createSheet("장애관리",0);
		
		//Cell 가로 너비 조정
		sheet2.setColumnView(0, 15);
		sheet2.setColumnView(1, 20);
		sheet2.setColumnView(2, 20);
		sheet2.setColumnView(3, 20);
		sheet2.setColumnView(4, 20);
		sheet2.setColumnView(5, 20);
		sheet2.setColumnView(6, 20);
		sheet2.setColumnView(7, 20);
		
		//Cell 세로 높이 조정
		sheet2.setRowView(0, 600);
		sheet2.setRowView(1, 600);
		sheet2.setRowView(2, 600);
		sheet2.setRowView(3, 600);
		sheet2.setRowView(4, 600);
		sheet2.setRowView(5, 600);
		
		/* Header Start */
		sheet2.addCell(new jxl.write.Label(0, 0, "서비스종류", cellFormat_DarkTeal));
		
		sheet2.addCell(new jxl.write.Label(1, 0, "기본규모 측정요소", cellFormat_DarkTeal));
		sheet2.mergeCells(1, 0, 2, 0);
		
		sheet2.addCell(new jxl.write.Label(3, 0, "특정규모 측정요소", cellFormat_DarkTeal));
		sheet2.mergeCells(3, 0, 4, 0);
		
		sheet2.addCell(new jxl.write.Label(5, 0, "역량규모 측정요소", cellFormat_DarkTeal));
		sheet2.mergeCells(5, 0, 7, 0);
		/* Header End */
		
		/* Content Start */
			/* 서비스 종류 Start */
			sheet2.addCell(new jxl.write.Label(0, 1, "장애관리", cellFormat_Gray));
			sheet2.mergeCells(0, 1, 0, 4);
			/* 서비스 종류 End */
			
			/* 기본규모 측정요소 Start */
			sheet2.addCell(new jxl.write.Label(1, 1, "① 기본규모 *", cellFormat_None));
			sheet2.addCell(new jxl.write.Number(2, 1, stringToDoubleValue("0"), cellFormat_None));
			
			sheet2.addCell(new jxl.write.Label(1, 2, "", cellFormat_None));
			sheet2.addCell(new jxl.write.Label(2, 2, "", cellFormat_None));
			
			sheet2.addCell(new jxl.write.Label(1, 3, "", cellFormat_None));
			sheet2.addCell(new jxl.write.Label(2, 3, "", cellFormat_None));
			
			sheet2.addCell(new jxl.write.Label(1, 4, "기본규모산정", cellFormat_None));
			sheet2.addCell(new jxl.write.Label(2, 4, "= ①   " + "0", cellFormat_None));
			/* 기본규모 측정요소 End */
			
			/* 특정규모 측정요소 Start */
			sheet2.mergeCells(3, 1, 4, 4);
			/* 특정규모 측정요소 End */
			
			/* 역량규모 측정요소 Start */
			sheet2.addCell(new jxl.write.Label(5, 1, "① 문제 적기 해결률 *", cellFormat_None));
			sheet2.addCell(new jxl.write.Label(5, 2, "② 일평균 Exception", cellFormat_None));
			sheet2.addCell(new jxl.write.Label(5, 3, "③ 동일장애 재발률 *", cellFormat_None));
			sheet2.addCell(new jxl.write.Label(5, 4, "역량규모산정", cellFormat_None));
			
			sheet2.addCell(new jxl.write.Number(6, 1, stringToDoubleValue("0"), cellFormat_None));
			sheet2.addCell(new jxl.write.Number(6, 2, stringToDoubleValue("0"), cellFormat_None));
			sheet2.addCell(new jxl.write.Number(6, 3, stringToDoubleValue("0"), cellFormat_None));
			sheet2.addCell(new jxl.write.Label(6, 4, "= (기본 규모) * ( ① + ② + ③ )", cellFormat_None));
			sheet2.mergeCells(6, 4, 7, 4);
			
			sheet2.addCell(new jxl.write.Number(7, 1, stringToDoubleValue("0"), cellFormat_None));
			sheet2.addCell(new jxl.write.Number(7, 2, stringToDoubleValue("0"), cellFormat_None));
			sheet2.addCell(new jxl.write.Number(7, 3, stringToDoubleValue("0"), cellFormat_None));
			sheet2.addCell(new jxl.write.Number(7, 4, stringToDoubleValue("0"), cellFormat_None));
			/* 역량규모 측정요소 End */
		/* Content End */
			
		/* Footer Start */
		sheet2.addCell(new jxl.write.Label(0, 5, "서비스규모", cellFormat_Gray));
		sheet2.addCell(new jxl.write.Label(1, 5, "= 기본 규모 + 특성규모 + 역량규모", cellFormat_Gray));
		sheet2.mergeCells(1, 5, 2, 5);
		sheet2.addCell(new jxl.write.Number(3, 5, stringToDoubleValue("0"), cellFormat_Gray));
	
		sheet2.addCell(new jxl.write.Label(4, 5, "장애관리서비스대가산정", cellFormat_DarkTeal));
		sheet2.addCell(new jxl.write.Label(5, 5, "= 서비스 규모 x " + "0" + "원", cellFormat_DarkTeal));
		sheet2.mergeCells(5, 5, 6, 5);
		sheet2.addCell(new jxl.write.Number(7, 5, stringToDoubleValue("0"), cellFormat_DarkTeal));
		/* Footer End */
		
		//장애관리 서비스CI 조회 목록 시작
		row = 6; //한줄띄움
		col = 0;
		sheet2.addCell(new jxl.write.Label(col++, row, "NO", cellFormat_DarkTeal));
		sheet2.addCell(new jxl.write.Label(col++, row, "서비스", cellFormat_DarkTeal));
		sheet2.addCell(new jxl.write.Label(col++, row, "장애 기본규모", cellFormat_DarkTeal));
		sheet2.addCell(new jxl.write.Label(col++, row, "문제적기해결율", cellFormat_DarkTeal));
		sheet2.addCell(new jxl.write.Label(col++, row, "일평균 Exception", cellFormat_DarkTeal));
		sheet2.addCell(new jxl.write.Label(col++, row, "동일장애 재발율", cellFormat_DarkTeal));
		row++;
		
		/*
		col = 0;
		for(int i=0; i < dataList_SVC_CI_DATA_ITS000101.size(); i++){
			col = 0;
			sheet2.addCell(new jxl.write.Label(col++, row, Integer.toString(i+1), cellFormat_None));
			sheet2.addCell(new jxl.write.Label(col++, row, dataList_SVC_CI_DATA_ITS000101.get(i).get("SVC_CI_NAME").toString(), cellFormat_None));
			sheet2.addCell(new jxl.write.Number(col++, row, Double.parseDouble(dataList_SVC_CI_DATA_ITS000101.get(i).get("SMI011").toString()), cellFormat_None));
			sheet2.addCell(new jxl.write.Number(col++, row, Double.parseDouble(dataList_SVC_CI_DATA_ITS000101.get(i).get("SMI012").toString()), cellFormat_None));
			sheet2.addCell(new jxl.write.Number(col++, row, Double.parseDouble(dataList_SVC_CI_DATA_ITS000101.get(i).get("SMI013").toString()), cellFormat_None));
			sheet2.addCell(new jxl.write.Number(col++, row, Double.parseDouble(dataList_SVC_CI_DATA_ITS000101.get(i).get("SMI014").toString()), cellFormat_None));
			row++;
		}
		*/
		
		
		
		/**** 운영관리 ****/
		WritableSheet sheet = workbook.createSheet("운영관리",0);
		
		//Cell 가로 너비 조정
		sheet.setColumnView(0, 15);
		sheet.setColumnView(1, 20);
		sheet.setColumnView(2, 20);
		sheet.setColumnView(3, 20);
		sheet.setColumnView(4, 20);
		sheet.setColumnView(5, 20);
		sheet.setColumnView(6, 20);
		sheet.setColumnView(7, 20);
		sheet.setColumnView(8, 20);
		sheet.setColumnView(9, 20);
		
		//Cell 세로 높이 조정
		sheet.setRowView(0, 600);
		sheet.setRowView(1, 600);
		sheet.setRowView(2, 600);
		sheet.setRowView(3, 600);
		sheet.setRowView(4, 600);
		sheet.setRowView(5, 600);
		sheet.setRowView(6, 600);
		sheet.setRowView(7, 600);
		sheet.setRowView(8, 600);

		/* Header Start */
		sheet.addCell(new jxl.write.Label(0, 0, "서비스종류", cellFormat_DarkTeal));
		
		sheet.addCell(new jxl.write.Label(1, 0, "기본규모 측정요소", cellFormat_DarkTeal));
		sheet.mergeCells(1, 0, 3, 0);
		
		sheet.addCell(new jxl.write.Label(4, 0, "특정규모 측정요소", cellFormat_DarkTeal));
		sheet.mergeCells(4, 0, 6, 0);
		
		sheet.addCell(new jxl.write.Label(7, 0, "역량규모 측정요소", cellFormat_DarkTeal));
		sheet.mergeCells(7, 0, 9, 0);
		/* Header End */
		
		/* Content Start */
			/* 서비스 종류 Start */
			sheet.addCell(new jxl.write.Label(0, 1, "운영관리", cellFormat_Gray));
			sheet.mergeCells(0, 1, 0, 7);
			/* 서비스 종류 End */
			
			/* 기본규모 측정요소 Start */
			sheet.addCell(new jxl.write.Label(1, 1, "① 정기업무량 *", cellFormat_None));
			sheet.mergeCells(1, 1, 1, 3);
			sheet.addCell(new jxl.write.Number(2, 1, ((BigDecimal)excelMap1.get("SMI001_VAL")).doubleValue(), cellFormat_None));
			sheet.mergeCells(2, 1, 3, 3);
			
			sheet.addCell(new jxl.write.Label(1, 4, "② 비정기업무량 *", cellFormat_None));
			sheet.mergeCells(1, 4, 1, 6);
			
			sheet.addCell(new jxl.write.Label(2, 4, "(1) 일정기간 비정기 업무 서비스 시간 *", cellFormat_None));
			sheet.addCell(new jxl.write.Number(3, 4, ((BigDecimal)excelMap1.get("SMI002_VAL")).doubleValue(), cellFormat_None));
			
			sheet.addCell(new jxl.write.Label(2, 5, "(2) 12개월/일정기간", cellFormat_None));
			sheet.addCell(new jxl.write.Label(3, 5, "12개월 / " + "1" + " 개월", cellFormat_None));
			
			sheet.addCell(new jxl.write.Label(2, 6, "비정기업무량 (1)*(2)", cellFormat_None));
			sheet.addCell(new jxl.write.Number(3, 6, ((BigDecimal)excelMap1.get("SMI002_VAL")).doubleValue(), cellFormat_None));
			
			sheet.addCell(new jxl.write.Label(1, 7, "기본규모산정", cellFormat_None));
			sheet.addCell(new jxl.write.Label(2, 7, "= ① + ②", cellFormat_None));
			sheet.addCell(new jxl.write.Number(3, 7, ((BigDecimal)excelMap1.get("SVS00001_VAL")).doubleValue(), cellFormat_None));
			
			/* 기본규모 측정요소 End */
		
			/* 특정규모 측정요소 Start */
			sheet.addCell(new jxl.write.Label(4, 1, "① 정규시간외 서비스 *", cellFormat_LightBlue));
			sheet.mergeCells(4, 1, 4, 3);
			
			sheet.addCell(new jxl.write.Label(4, 4, "② 정기일수 외 서비스 *", cellFormat_LightBlue));
			sheet.mergeCells(4, 4, 4, 6);
			
			sheet.addCell(new jxl.write.Label(4, 7, "특정규모산정", cellFormat_LightBlue));
			
			sheet.addCell(new jxl.write.Label(5, 1, "(1) 기본규모", cellFormat_LightBlue));
			sheet.addCell(new jxl.write.Number(6, 1, ((BigDecimal)excelMap1.get("SVS00001_VAL")).doubleValue(), cellFormat_LightBlue));
			
			sheet.addCell(new jxl.write.Label(5, 2, "(2) 정규시간 (일8시간)외 서비스 비중 *0.5", cellFormat_LightBlue));
			sheet.addCell(new jxl.write.Number(6, 2, ((BigDecimal)excelMap1.get("SMI003_P")).doubleValue(), cellFormat_LightBlue));
			
			sheet.addCell(new jxl.write.Label(5, 3, "특성규모(1)*(2)", cellFormat_LightBlue));
			sheet.addCell(new jxl.write.Number(6, 3, ((BigDecimal)excelMap1.get("SMI003_VAL")).doubleValue(), cellFormat_LightBlue));
			
			
			sheet.addCell(new jxl.write.Label(5, 4, "(1) 기본규모", cellFormat_LightBlue));
			sheet.addCell(new jxl.write.Number(6, 4, ((BigDecimal)excelMap1.get("SVS00001_VAL")).doubleValue(), cellFormat_LightBlue));
			
			sheet.addCell(new jxl.write.Label(5, 5, "(2) 정규시간(주5일) 외 서비스 비중 *0.5", cellFormat_LightBlue));
			sheet.addCell(new jxl.write.Number(6, 5, ((BigDecimal)excelMap1.get("SMI004_P")).doubleValue(), cellFormat_LightBlue));
			
			sheet.addCell(new jxl.write.Label(5, 6, "특성규모 (1)*(2)", cellFormat_LightBlue));
			sheet.addCell(new jxl.write.Number(6, 6, ((BigDecimal)excelMap1.get("SMI004_VAL")).doubleValue(), cellFormat_LightBlue));
			
			sheet.addCell(new jxl.write.Label(5, 7, "= ① + ②", cellFormat_LightBlue));
			sheet.addCell(new jxl.write.Number(6, 7, ((BigDecimal)excelMap1.get("SVS00002_VAL")).doubleValue(), cellFormat_LightBlue));
			
			/* 특정규모 측정요소 End */
			
			/* 역량규모 측정요소 Start */
			sheet.addCell(new jxl.write.Label(7, 1, "① 서비스가용성 *", cellFormat_None));
			sheet.addCell(new jxl.write.Label(7, 2, "② 장애복구 시간 *", cellFormat_None));
			sheet.addCell(new jxl.write.Label(7, 3, "③ 장애보고 시간 *", cellFormat_None));
			sheet.addCell(new jxl.write.Label(7, 4, "④ 정기작업 적정 처리율 *", cellFormat_None));
			sheet.addCell(new jxl.write.Label(7, 5, "⑤ 품질역량 수준", cellFormat_None));
			sheet.addCell(new jxl.write.Label(7, 6, "⑥ 가치제안 효과 *", cellFormat_None));
			sheet.addCell(new jxl.write.Label(7, 7, "역량규모산정", cellFormat_None));
			
			sheet.addCell(new jxl.write.Number(8, 1, stringToDoubleValue("0"), cellFormat_None));
			sheet.addCell(new jxl.write.Number(8, 2, stringToDoubleValue("0"), cellFormat_None));
			sheet.addCell(new jxl.write.Number(8, 3, stringToDoubleValue("0"), cellFormat_None));
			sheet.addCell(new jxl.write.Number(8, 4, stringToDoubleValue("0"), cellFormat_None));
			
			sheet.addCell(new jxl.write.Label(8, 5, "", cellFormat_None));
			/*
			if(StringUtils.isEmpty(valueCloseAdminDataExcelViewVO.getId_SMI009_1())) {
				sheet.addCell(new jxl.write.Label(8, 5, "", cellFormat_None));
			} else {
				sheet.addCell(new jxl.write.Label(8, 5, "CMMI " + valueCloseAdminDataExcelViewVO.getId_SMI009_1() + " 레벨", cellFormat_None));
			}
			*/
			
			sheet.addCell(new jxl.write.Label(8, 6, "0" + " 원", cellFormat_None));
			sheet.addCell(new jxl.write.Label(8, 7, "= (기본 규모 + 특성 규모) * ( ① + ② + ③ + ④ + ⑤ + ⑥ )", cellFormat_None));
			sheet.addCell(new jxl.write.Number(9, 7, stringToDoubleValue("0"), cellFormat_None));
			
			sheet.addCell(new jxl.write.Number(9, 1, stringToDoubleValue("0"), cellFormat_None));
			sheet.addCell(new jxl.write.Number(9, 2, stringToDoubleValue("0"), cellFormat_None));
			sheet.addCell(new jxl.write.Number(9, 3, stringToDoubleValue("0"), cellFormat_None));
			sheet.addCell(new jxl.write.Number(9, 4, stringToDoubleValue("0"), cellFormat_None));
			sheet.addCell(new jxl.write.Number(9, 5, stringToDoubleValue("0"), cellFormat_None));
			sheet.addCell(new jxl.write.Number(9, 6, stringToDoubleValue("0"), cellFormat_None));
			/* 역량규모 측정요소 End */
		/* Content End */
			
		/* Footer Start */
		sheet.addCell(new jxl.write.Label(0, 8, "서비스규모", cellFormat_Gray));
		sheet.addCell(new jxl.write.Label(1, 8, "= 기본 규모 + 특성규모 + 역량규모", cellFormat_Gray));
		sheet.mergeCells(1, 8, 3, 8);
		sheet.addCell(new jxl.write.Number(4, 8, ((BigDecimal)excelMap1.get("TOT_V")).doubleValue(), cellFormat_Gray));
		sheet.addCell(new jxl.write.Label(5, 8, "운영관리서비스대가산정", cellFormat_DarkTeal));
		sheet.mergeCells(5, 8, 6, 8);
		sheet.addCell(new jxl.write.Label(7, 8, "= 서비스 규모 x " + ((BigDecimal)excelMap1.get("PRICE")).doubleValue() + "원", cellFormat_DarkTeal));
		sheet.mergeCells(7, 8, 8, 8);
		sheet.addCell(new jxl.write.Number(9, 8, ((BigDecimal)excelMap1.get("TOT_P")).doubleValue(), cellFormat_DarkTeal));
		/* Footer End */
		
		//운영관리 서비스CI 조회 목록 시작
		row = 9; //한줄띄움
		col = 0;
		sheet.addCell(new jxl.write.Label(col++, row, "NO", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "서비스", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "정기업무량", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "비정기업무량", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "정규시간 외 서비스", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "정기일수 외 서비스", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "서비스 가용성", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "장애복구 시간", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "장애보고 시간", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "정기작업적정처리율", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "운영-품질역량수준", cellFormat_DarkTeal));
		sheet.addCell(new jxl.write.Label(col++, row, "가치제안효과", cellFormat_DarkTeal));
		row++;
		
		col = 0;
		for(int i=0; i < result2.size(); i++){
			
			Map excelMap4 = (Map) result2.get(i);
			
			col = 0;
			sheet.addCell(new jxl.write.Label(col++, row, Integer.toString(i+1), cellFormat_None));
			sheet.addCell(new jxl.write.Label(col++, row, excelMap4.get("SVC_CI_NAME").toString(), cellFormat_None));
			sheet.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap4.get("SMI001")).doubleValue(), cellFormat_None));
			sheet.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap4.get("SMI002")).doubleValue(), cellFormat_None));
			sheet.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap4.get("SMI003")).doubleValue(), cellFormat_None));
			sheet.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap4.get("SMI004")).doubleValue(), cellFormat_None));
			sheet.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap4.get("SMI005")).doubleValue(), cellFormat_None));
			sheet.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap4.get("SMI006")).doubleValue(), cellFormat_None));
			sheet.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap4.get("SMI007")).doubleValue(), cellFormat_None));
			sheet.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap4.get("SMI008")).doubleValue(), cellFormat_None));
			sheet.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap4.get("SMI009")).doubleValue(), cellFormat_None));
			sheet.addCell(new jxl.write.Number(col++, row, ((BigDecimal)excelMap4.get("SMI010")).doubleValue(), cellFormat_None));
			row++;
		}
	}
	
	private Map<String, Integer> getColumnMap(List<String> meta) {
		Map<String, Integer> columnMap = new HashMap<String, Integer>();
		
		int cnt = 0;
		for (Iterator<?> iterator = meta.iterator(); iterator.hasNext();) {
			Object obj = iterator.next();
			columnMap.put(obj.toString(), cnt++);
		}
		
		return columnMap;
	}
	
	private String createFileName(String dateYYYYMM) {
		SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREA);
		return "ValuationAdminData_"+dateYYYYMM+"_"+fileFormat.format(new Date())+".xls";
	}
	
	private void setFileNameToResponse(HttpServletRequest request, HttpServletResponse response, String fileName) {
		String userAgent = request.getHeader("User-Agent");
		
		if (userAgent == null) return;
		
		if (userAgent.indexOf("MSIE 5.5") >= 0) {
			response.setContentType("doesn/matter");
			response.setHeader("Content-Disposition","filename=\""+fileName+"\"");
		} else {
			response.setHeader("Content-Disposition","attachment; filename=\""+fileName+"\"");
		}
	}
	
	private String convertSqlDateToString(Object dateValue) {
		String strDate = "";
		
		try {
			if (dateValue != null) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);
				strDate = sdf.format(dateValue);
			}
		} catch (Exception e) {
		}
		
		return strDate;
	}
	
	private Double stringToDoubleValue(String str) {
		if(StringUtils.isEmpty(str)) {
			return (double) 0;
		} else {
			str = str.replaceAll(",", "");
			return Double.parseDouble(str);
		}
	}
	
}
