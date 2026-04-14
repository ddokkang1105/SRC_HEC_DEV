package xbolt.custom.daelim.itsm;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.view.document.AbstractJExcelView;


@SuppressWarnings("deprecation")
public class ServiceValidationExcelView extends AbstractJExcelView{
	// logging
	private static final Logger LOGGER = LoggerFactory.getLogger(ServiceValidationExcelView.class);
	
	@Override
	protected void buildExcelDocument(Map<String, Object> model, WritableWorkbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		String type = (String) model.get("type");
		
		String fileName = createFileName(type);
		setFileNameToResponse(request, response, fileName);
		
		List<HashMap> result1 = (List<HashMap>) model.get("result1");
		List<HashMap> result2 = (List<HashMap>) model.get("result2");
		
		// 검색된 데이터없음
		if (result1.size() == 0) {
			workbook.createSheet("NODATA", 0);
			return;
		}
		
		WritableSheet sheet1  = workbook.createSheet("운영관리",0);
		
		WritableCellFormat colFormat = new WritableCellFormat();    //셀의 스타일을 지정하기 위한 부분입니다.
		WritableCellFormat colFormatSum = new WritableCellFormat();    //셀의 스타일을 지정하기 위한 부분입니다.
		WritableCellFormat colFormatOceanBlue = new WritableCellFormat();    //셀의 스타일을 지정하기 위한 부분입니다.
		
		WritableFont font = new WritableFont(WritableFont.ARIAL,
			10,
			WritableFont.BOLD,
			false,
			UnderlineStyle.NO_UNDERLINE,
			Colour.WHITE,
			ScriptStyle.NORMAL_SCRIPT);
		
		colFormat.setFont(font);
		colFormat.setBorder(Border.ALL , BorderLineStyle.THIN);
		colFormat.setBackground(Colour.DARK_TEAL);
		colFormat.setAlignment(Alignment.CENTRE); 
		colFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
		
		colFormatSum.setFont(font);
		colFormatSum.setBorder(Border.ALL , BorderLineStyle.THIN);
		colFormatSum.setBackground(Colour.DARK_RED);
		colFormatSum.setAlignment(Alignment.CENTRE); 
		colFormatSum.setVerticalAlignment(VerticalAlignment.CENTRE);
		
		WritableCellFormat cellFormat = new WritableCellFormat();    //셀의 스타일을 지정하기 위한 부분입니다.
		cellFormat.setBorder(Border.ALL , BorderLineStyle.THIN);
		cellFormat.setAlignment(Alignment.CENTRE);
		cellFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
		
		colFormatOceanBlue.setFont(font);
		colFormatOceanBlue.setBorder(Border.ALL , BorderLineStyle.THIN);
		colFormatOceanBlue.setBackground(Colour.OCEAN_BLUE);
		colFormatOceanBlue.setAlignment(Alignment.CENTRE); 
		colFormatOceanBlue.setVerticalAlignment(VerticalAlignment.CENTRE);
		
		//if(type.equals("ticket")) {
			sheet1.setColumnView(0, 25);
			sheet1.setColumnView(1, 20);
			sheet1.setColumnView(2, 20);
			sheet1.setColumnView(3, 20);
			sheet1.setColumnView(4, 20);
			sheet1.setColumnView(5, 20);
			
			sheet1.setColumnView(6, 20);
			sheet1.setColumnView(7, 20);
			sheet1.setColumnView(8, 20);
			
			sheet1.setColumnView(9, 20);
			sheet1.setColumnView(10, 20);
			sheet1.setColumnView(11, 20);
			sheet1.setColumnView(12, 20);
			sheet1.setColumnView(13, 20);
			sheet1.setColumnView(14, 20);
			
			sheet1.setColumnView(15, 20);
			sheet1.setColumnView(16, 20);
			sheet1.setColumnView(17, 20);
			sheet1.setColumnView(18, 20);
			sheet1.setColumnView(19, 20);
			sheet1.setColumnView(20, 20);
			sheet1.setColumnView(21, 20);
			sheet1.setColumnView(22, 20);
			sheet1.setColumnView(23, 20);
			sheet1.setColumnView(24, 20);
			sheet1.setColumnView(25, 20);
			sheet1.setColumnView(26, 20);
			sheet1.setColumnView(27, 20);
			sheet1.setColumnView(28, 20);
			sheet1.setColumnView(29, 20);
			sheet1.setColumnView(30, 20);
			
			// 
			sheet1.addCell(new jxl.write.Label(0,  0, "관계사코드", colFormat)); 	//0
			sheet1.mergeCells(0, 0, 0, 2);
			sheet1.addCell(new jxl.write.Label(1,  0, "관계사명", colFormat));		//1
			sheet1.mergeCells(1, 0, 1, 2);
			sheet1.addCell(new jxl.write.Label(2,  0, "프로세스구분", colFormat));	//2
			sheet1.mergeCells(2, 0, 2, 2);
			sheet1.addCell(new jxl.write.Label(3,  0, "서비스ID", colFormat));		//3
			sheet1.mergeCells(3, 0, 3, 2);
			sheet1.addCell(new jxl.write.Label(4,  0, "서비스명", colFormat));		//4
			sheet1.mergeCells(4, 0, 4, 2);
			sheet1.addCell(new jxl.write.Label(5,  0, "티켓ID", colFormat));		//5
			sheet1.mergeCells(5, 0, 5, 2);
			sheet1.addCell(new jxl.write.Label(6,  0, "의뢰유형", colFormat)); 		//6    
			sheet1.mergeCells(6, 0, 6, 2);
			sheet1.addCell(new jxl.write.Label(7,  0, "사번", colFormat));			//7		    
			sheet1.mergeCells(7, 0, 7, 2);
			sheet1.addCell(new jxl.write.Label(8,  0, "성명", colFormat));  		//8
			sheet1.mergeCells(8, 0, 8, 2);
			sheet1.addCell(new jxl.write.Label(9,  0, "부서명", colFormat)); 		//9 
			sheet1.mergeCells(9, 0, 9, 2);
			sheet1.addCell(new jxl.write.Label(10, 0, "규모합계", colFormatSum));   //10
            sheet1.mergeCells(10, 0, 10, 2);
			sheet1.addCell(new jxl.write.Label(11, 0, "접수일자", colFormat));    	//11
            sheet1.mergeCells(11, 0, 11, 2);
            sheet1.addCell(new jxl.write.Label(12, 0, "작업일자", colFormat));    	//12
            sheet1.mergeCells(12, 0, 12, 2);
            sheet1.addCell(new jxl.write.Label(13, 0, "종료일자", colFormat));    	//13
            sheet1.mergeCells(13, 0, 13, 2);
            sheet1.addCell(new jxl.write.Label(14, 0, "공휴일여부", colFormat));  	//14
            sheet1.mergeCells(14, 0, 14, 2);
            sheet1.addCell(new jxl.write.Label(15, 0, "정규시간내", colFormat));  	//15
            sheet1.mergeCells(15, 0, 15, 2);
            sheet1.addCell(new jxl.write.Label(16, 0, "정규시간외", colFormat));  	//16
            sheet1.mergeCells(16, 0, 16, 2);
            
            /* Header Start */			
			sheet1.addCell(new jxl.write.Label(17, 0, "운영관리(기본규모)", colFormat));
			sheet1.mergeCells(17, 0, 19, 0);
			
			sheet1.addCell(new jxl.write.Label(20, 0, "운영관리(특성규모)", colFormat));
			sheet1.mergeCells(20, 0, 22, 0);
			
			sheet1.addCell(new jxl.write.Label(17, 1, "정기업무량 + 비정기업무량", colFormat));
			sheet1.mergeCells(17, 1, 19, 1);
			/* Header End */
			
			sheet1.addCell(new jxl.write.Label(17, 2, "정기업무량", colFormat)); 	//17
			sheet1.addCell(new jxl.write.Label(18, 2, "비정기업무량", colFormat));	//18
			sheet1.addCell(new jxl.write.Label(19, 2, "규모산정", colFormatSum));   //19
			
			sheet1.addCell(new jxl.write.Label(20, 1, "공휴일이 N인 경우, 정규시간외/(정규시간내+정규시간외)*0.5", colFormat));	//17
			sheet1.addCell(new jxl.write.Label(21, 1, "공휴일이 Y인 경우, (정규시간내+정규일수외)/(정규시간내+정규일수외)*0.5", colFormat));	//18
			sheet1.addCell(new jxl.write.Label(22, 1, "기본규모*(정규시간외비중+정규일수외비중)", colFormat)); 		//19
			
			sheet1.addCell(new jxl.write.Label(20, 2, "정규시간외비중", colFormat));	//17
			sheet1.addCell(new jxl.write.Label(21, 2, "정규일수외비중", colFormat));	//18
			sheet1.addCell(new jxl.write.Label(22, 2, "규모산정", colFormatSum)); 		//19
			
			sheet1.addCell(new jxl.write.Label(23, 0, "요청자사번", colFormat));	//20
			sheet1.mergeCells(23, 0, 23, 2);
			sheet1.addCell(new jxl.write.Label(24, 0, "요청자명", colFormat));		//21
			sheet1.mergeCells(24, 0, 24, 2);
			sheet1.addCell(new jxl.write.Label(25, 0, "요청부서명", colFormat));	//22
			sheet1.mergeCells(25, 0, 25, 2);
			sheet1.addCell(new jxl.write.Label(26, 0, "처리상태ID", colFormat));	//23	
			sheet1.mergeCells(26, 0, 26, 2);
			sheet1.addCell(new jxl.write.Label(27, 0, "처리상태", colFormat));		//24
			sheet1.mergeCells(27, 0, 27, 2);
			sheet1.addCell(new jxl.write.Label(28, 0, "작업자사번", colFormat));	//25
			sheet1.mergeCells(28, 0, 28, 2);
			sheet1.addCell(new jxl.write.Label(29, 0, "작업자명", colFormat));		//26
			sheet1.mergeCells(29, 0, 29, 2);
			sheet1.addCell(new jxl.write.Label(30, 0, "제목", colFormat)); 			//27
			sheet1.mergeCells(30, 0, 30, 2);
			sheet1.addCell(new jxl.write.Label(31, 0, "요청내용", colFormat)); 			//28
			sheet1.mergeCells(31, 0, 31, 2);
			sheet1.addCell(new jxl.write.Label(32, 0, "작업내용", colFormat)); 			//28
			sheet1.mergeCells(32, 0, 32, 2);
			
			int row = 3;
			int num = 0;
			for(int i=0; i < result1.size(); i++){
				num = 0;
				
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("cd_company"), cellFormat)); //0.관계사코드
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("cd_company_nm"), cellFormat));//1.관계사명
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("tbl_nm"), cellFormat));//2.프로세스구분
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("svc_ci_id"), cellFormat));//3.서비스ID
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("name_lv1"), cellFormat));//4.서비스명
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("id"), cellFormat));//5.티켓ID
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("cat_name"), cellFormat));//6.의뢰유형
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("usr_id"), cellFormat));//7.사번
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("user_nm"), cellFormat));//8.성명
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("nm_dept"), cellFormat)); //9.부서명
				sheet1.addCell(new jxl.write.Number(num++, row, (double) (result1.get(i).get("totalSum")), cellFormat)); //10.(운영관리+개선관리)규모합계
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("rcpt_date"), cellFormat));//11.작업일자
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("work_date"), cellFormat)); 
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("close_date"), cellFormat));
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("holyday"), cellFormat));
				sheet1.addCell(new jxl.write.Number(num++, row, ((double)result1.get(i).get("business_hour")), cellFormat));
				sheet1.addCell(new jxl.write.Number(num++, row, ((double)result1.get(i).get("overtime")), cellFormat));
				sheet1.addCell(new jxl.write.Number(num++, row, ((double)result1.get(i).get("regular_work_val")), cellFormat));
				sheet1.addCell(new jxl.write.Number(num++, row, ((double)result1.get(i).get("casual_work_val")), cellFormat));
				sheet1.addCell(new jxl.write.Number(num++, row, ((double)result1.get(i).get("msr_val")), cellFormat));
				sheet1.addCell(new jxl.write.Number(num++, row, ((double)result1.get(i).get("mng_sps1")), cellFormat));
				sheet1.addCell(new jxl.write.Number(num++, row, ((double)result1.get(i).get("mng_sps2")), cellFormat));
				sheet1.addCell(new jxl.write.Number(num++, row, ((double)result1.get(i).get("mng_sps")), cellFormat));
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("req_usr_id"), cellFormat));
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("req_usr_name"), cellFormat));
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("req_usr_dept_name"), cellFormat));
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("status_id"), cellFormat));
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("status_name"), cellFormat));
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("step_mng_id"), cellFormat));
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("step_mng_nm"), cellFormat));			
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("title"), cellFormat));
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("notice"), cellFormat));
				sheet1.addCell(new jxl.write.Label(num++, row, (String) result1.get(i).get("solvnt"), cellFormat));
				
				row++;
			}
			
//개선관리
			WritableSheet sheet2  = workbook.createSheet("개선관리",1);
			
			    sheet2.setColumnView(0, 25);
				sheet2.setColumnView(1, 20);
				sheet2.setColumnView(2, 20);
				sheet2.setColumnView(3, 20);
				sheet2.setColumnView(4, 20);
				sheet2.setColumnView(5, 20);
				sheet2.setColumnView(6, 20);
				
				sheet2.setColumnView(7, 20);
				sheet2.setColumnView(8, 20);
				sheet2.setColumnView(9, 20);
				
				sheet2.setColumnView(10, 20);
				sheet2.setColumnView(11, 20);
				sheet2.setColumnView(12, 20);
				sheet2.setColumnView(13, 20);
				sheet2.setColumnView(14, 30);
				
				sheet2.setColumnView(15, 30);
				sheet2.setColumnView(16, 30);
				sheet2.setColumnView(17, 30);
				sheet2.setColumnView(18, 30);
				sheet2.setColumnView(19, 30);
				sheet2.setColumnView(20, 30);
				sheet2.setColumnView(21, 30);
				sheet2.setColumnView(22, 30);
				sheet2.setColumnView(23, 30);
				sheet2.setColumnView(24, 30);
				sheet2.setColumnView(25, 30);
				sheet2.setColumnView(26, 30);
				sheet2.setColumnView(27, 30);
				sheet2.setColumnView(28, 30);
				sheet2.setColumnView(29, 30);
				sheet2.setColumnView(30, 30);
				sheet2.setColumnView(31, 30);
				sheet2.setColumnView(32, 30);
				sheet2.setColumnView(33, 30);
				sheet2.setColumnView(34, 30);
				sheet2.setColumnView(35, 30);
				sheet2.setColumnView(36, 30);
				
				/* Header Start */			
				sheet2.addCell(new jxl.write.Label(16, 0, "신규", colFormat));
				sheet2.mergeCells(16, 0, 20, 0);
				sheet2.addCell(new jxl.write.Label(16, 1, "( (화면 * 4.3) + (배치 * 4.3) + (config * 4.3) + (데이터 * 1.4) + (테이블 * 6.8) ) * 1", colFormat));
				sheet2.mergeCells(16, 1, 20, 1);
				
				sheet2.addCell(new jxl.write.Label(21, 0, "변경", colFormat));
				sheet2.mergeCells(21, 0, 25, 0);
				sheet2.addCell(new jxl.write.Label(21, 1, "( (화면 * 4.3) + (배치 * 4.3) + (config * 4.3) + (데이터 * 1.4) + (테이블 * 6.8) ) * 0.7", colFormat));
				sheet2.mergeCells(21, 1, 25, 1);
				
				sheet2.addCell(new jxl.write.Label(27, 0, "신규", colFormat));
				sheet2.mergeCells(27, 0, 31, 0);
				sheet2.addCell(new jxl.write.Label(27, 1, "트랜젝션기능", colFormat));
				sheet2.mergeCells(27, 1, 30, 1);
				sheet2.addCell(new jxl.write.Label(31, 1, "데이터기능", colFormat));
				
				
				sheet2.addCell(new jxl.write.Label(32, 0, "변경", colFormat));
				sheet2.mergeCells(32, 0, 36, 0);
				sheet2.addCell(new jxl.write.Label(32, 1, "트랜젝션기능", colFormat));
				sheet2.mergeCells(32, 1, 35, 1);
				sheet2.addCell(new jxl.write.Label(36, 1, "데이터기능", colFormat));
				
				
				/* Header End */
				
				sheet2.addCell(new jxl.write.Label(0,  0, "관계사코드", colFormat));
				sheet2.mergeCells(0, 0, 0, 2);
				sheet2.addCell(new jxl.write.Label(1,  0, "관계사명", colFormat));
				sheet2.mergeCells(1, 0, 1, 2);
				sheet2.addCell(new jxl.write.Label(2,  0, "서비스ID", colFormat));
				sheet2.mergeCells(2, 0, 2, 2);
				sheet2.addCell(new jxl.write.Label(3,  0, "서비스명", colFormat));
				sheet2.mergeCells(3, 0, 3, 2);
				sheet2.addCell(new jxl.write.Label(4,  0, "티켓ID", colFormat));
				sheet2.mergeCells(4, 0, 4, 2);
				sheet2.addCell(new jxl.write.Label(5,  0, "제목", colFormat));     
				sheet2.mergeCells(5, 0, 5, 2);
				sheet2.addCell(new jxl.write.Label(6,  0, "내용", colFormat));     
				sheet2.mergeCells(6, 0, 6, 2);
				sheet2.addCell(new jxl.write.Label(7, 0, "요청자사번", colFormat));
				sheet2.mergeCells(7, 0, 7, 2);
				sheet2.addCell(new jxl.write.Label(8, 0, "요청자명", colFormat));
				sheet2.mergeCells(8, 0, 8, 2);
				sheet2.addCell(new jxl.write.Label(9, 0, "요청부서명", colFormat));
				sheet2.mergeCells(9, 0, 9, 2);
				sheet2.addCell(new jxl.write.Label(10, 0, "등록일자", colFormat));
				sheet2.mergeCells(10, 0, 10, 2);
				sheet2.addCell(new jxl.write.Label(11, 0, "등록자사번", colFormat));
				sheet2.mergeCells(11, 0, 11, 2);
				sheet2.addCell(new jxl.write.Label(12, 0, "등록자명", colFormat));
				sheet2.mergeCells(12, 0, 12, 2);
				sheet2.addCell(new jxl.write.Label(13, 0, "등록부서명", colFormat));
				sheet2.mergeCells(13, 0, 13, 2);
				sheet2.addCell(new jxl.write.Label(14, 0, "접수일자", colFormat));
				sheet2.mergeCells(14, 0, 14, 2);
				sheet2.addCell(new jxl.write.Label(15, 0, "종료일자", colFormat));
				sheet2.mergeCells(15, 0, 15, 2);
				sheet2.addCell(new jxl.write.Label(16, 2, "화면기능산출물수(4.3)", colFormat));
				sheet2.addCell(new jxl.write.Label(17, 2, "배치프로그램산출물수(4.3)", colFormat));
				sheet2.addCell(new jxl.write.Label(18, 2, "Config화면패키지산출물수(4.3)", colFormat));
				sheet2.addCell(new jxl.write.Label(19, 2, "DataSQL프로그램산출물수(1.4)", colFormat));
				sheet2.addCell(new jxl.write.Label(20, 2, "테이블산출물수(6.8)", colFormat));
				sheet2.addCell(new jxl.write.Label(21, 2, "화면기능산출물수(4.3)", colFormat));
				sheet2.addCell(new jxl.write.Label(22, 2, "배치프로그램산출물수(4.3)", colFormat));
				sheet2.addCell(new jxl.write.Label(23, 2, "Config화면패키지산출물수(4.3)", colFormat));
				sheet2.addCell(new jxl.write.Label(24, 2, "DataSQL프로그램산출물수(1.4)", colFormat));
				sheet2.addCell(new jxl.write.Label(25, 2, "테이블산출물수(6.8)", colFormat));

				sheet2.addCell(new jxl.write.Label(26, 0, "개선관리[기본규모]  (신규 + 변경)", colFormatSum));
				sheet2.mergeCells(26, 0, 26, 2);
				
				sheet2.addCell(new jxl.write.Label(27, 2, "화면기능산출물[상세]", colFormat));
				sheet2.addCell(new jxl.write.Label(28, 2, "배치프로그램산출물[상세]", colFormat));
				sheet2.addCell(new jxl.write.Label(29, 2, "Config화면패키지산출물[상세]", colFormat));
				sheet2.addCell(new jxl.write.Label(30, 2, "DataSQL프로그램산출물[상세]", colFormat));
				sheet2.addCell(new jxl.write.Label(31, 2, "테이블산출물[상세]", colFormat));
				sheet2.addCell(new jxl.write.Label(32, 2, "화면기능산출물[상세]", colFormat));
				sheet2.addCell(new jxl.write.Label(33, 2, "배치프로그램산출물[상세]", colFormat));
				sheet2.addCell(new jxl.write.Label(34, 2, "Config화면패키지산출물[상세]", colFormat));
				sheet2.addCell(new jxl.write.Label(35, 2, "DataSQL프로그램산출물[상세]", colFormat));
				sheet2.addCell(new jxl.write.Label(36, 2, "테이블산출물[상세]", colFormat));
				
				int row2 = 3;
				int num2 = 0;
				for(int j= 0; j < result2.size(); j++){
					num2 = 0;
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("cd_company"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("cd_company_nm"), cellFormat));
					
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("svc_ci_id"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("name_lv1"), cellFormat));
					
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("id"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("title"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("notice"), cellFormat));
					
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("req_usr_id"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("req_usr_name"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("req_usr_dept_name"), cellFormat));
					
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("reg_date"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("usr_id"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("user_nm"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("nm_dept"), cellFormat));  
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("rcpt_date"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("close_date"), cellFormat));
					sheet2.addCell(new jxl.write.Number(num2++, row2, Double.parseDouble((String) result2.get(j).get("new_scrin_output_qy")), cellFormat));
					sheet2.addCell(new jxl.write.Number(num2++, row2, Double.parseDouble((String) result2.get(j).get("new_batch_output_qy")), cellFormat));
					sheet2.addCell(new jxl.write.Number(num2++, row2, Double.parseDouble((String) result2.get(j).get("new_config_output_qy")), cellFormat));
					sheet2.addCell(new jxl.write.Number(num2++, row2, Double.parseDouble((String) result2.get(j).get("new_data_output_qy")), cellFormat));
					sheet2.addCell(new jxl.write.Number(num2++, row2, Double.parseDouble((String) result2.get(j).get("new_table_output_qy")), cellFormat));
					
					sheet2.addCell(new jxl.write.Number(num2++, row2, Double.parseDouble((String) result2.get(j).get("change_scrin_output_qy")), cellFormat));
					sheet2.addCell(new jxl.write.Number(num2++, row2, Double.parseDouble((String) result2.get(j).get("change_batch_output_qy")), cellFormat));
					sheet2.addCell(new jxl.write.Number(num2++, row2, Double.parseDouble((String) result2.get(j).get("change_config_output_qy")), cellFormat));
					sheet2.addCell(new jxl.write.Number(num2++, row2, Double.parseDouble((String) result2.get(j).get("change_data_output_qy")), cellFormat));
					sheet2.addCell(new jxl.write.Number(num2++, row2, Double.parseDouble((String) result2.get(j).get("change_table_output_qy")), cellFormat));
					
					sheet2.addCell(new jxl.write.Number(num2++, row2, ((BigDecimal) result2.get(j).get("ap_impro_manage_cal")).doubleValue(), cellFormat));
					
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("new_scrin_output_dtl"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("new_batch_output_dtl"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("new_config_output_dtl"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("new_data_output_dtl"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("new_table_output_dtl"), cellFormat));
					
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("change_scrin_output_dtl"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("change_batch_output_dtl"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("change_config_output_dtl"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("change_data_output_dtl"), cellFormat));
					sheet2.addCell(new jxl.write.Label(num2++, row2, (String) result2.get(j).get("change_table_output_dtl"), cellFormat));
					
					row2++;
				}
	//}else
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
	
	private String createFileName(String type) {
		SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREA);
		return "ServiceValidation_"+fileFormat.format(new Date())+".xls";
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
}
