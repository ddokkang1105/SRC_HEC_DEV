package xbolt.custom.daelim.itsm;

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

import xbolt.cmm.framework.util.StringUtil;

public class ValueManualCalcExcelView extends AbstractJExcelView{
	// logging
	private static final Logger LOGGER = LoggerFactory.getLogger(ServiceValidationExcelView.class);
	
	@Override
	protected void buildExcelDocument(Map<String, Object> model, WritableWorkbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		//String type = (String) model.get("type");
		
		String sApplyYm = StringUtil.checkNull(request.getParameter("applyYm"),"");
		String sCorpId = StringUtil.checkNull(request.getParameter("corpId"),"");
		
		
		//String fileName = createFileName(type);
		String fileName = createFileName(sApplyYm);
		setFileNameToResponse(request, response, fileName);
		
		//List<IndividualMHVO> result = (List<IndividualMHVO>) model.get("resultList");
		List<HashMap> result = (List<HashMap>) model.get("result");
		
		// 검색된 데이터없음
		if (result.size() == 0) {
			workbook.createSheet("NODATA", 0);
			return;
		}
		
		WritableSheet sheet1  = workbook.createSheet("실적집계 예외티켓",0);
		
		WritableCellFormat colFormat = new WritableCellFormat();    //셀의 스타일을 지정하기 위한 부분입니다.
		WritableCellFormat colFormatSum = new WritableCellFormat();    //셀의 스타일을 지정하기 위한 부분입니다.
		
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
			
			sheet1.addCell(new jxl.write.Label(0,  0, "티켓아이디", colFormat)); 			//0
			sheet1.addCell(new jxl.write.Label(1,  0, "서비스대가산정구분", colFormatSum));    //1
			sheet1.addCell(new jxl.write.Label(2,  0, "프로세스구분", colFormat));			//2
			sheet1.addCell(new jxl.write.Label(3,  0, "서비스구분", colFormat));			//3
			sheet1.addCell(new jxl.write.Label(4,  0, "요청자", colFormat));				//4
			sheet1.addCell(new jxl.write.Label(5,  0, "접수자", colFormat));				//5
			sheet1.addCell(new jxl.write.Label(6,  0, "등록일자", colFormatSum)); 				//6    
			sheet1.addCell(new jxl.write.Label(7,  0, "제목", colFormat));					//7		 
			sheet1.addCell(new jxl.write.Label(8,  0, "진행상태", colFormat)); 				//9 
            sheet1.addCell(new jxl.write.Label(9,  0, "종료상태", colFormat));    			//10
            sheet1.addCell(new jxl.write.Label(10, 0, "담당자", colFormat));    			//11
 	
			int row = 1;
			int num = 0;
			for(int i=0; i < result.size(); i++){
				num = 0;
				
				Map excelMap = (Map) result.get(i);
				
				/*
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getId(), cellFormat));  				//0
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getService_name(), cellFormat)); 		//1
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getProc_name(), cellFormat));			//2
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getSvc_ci_name(), cellFormat));		//3
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getReq_usr_name(), cellFormat));		//4
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getReg_usr_name(), cellFormat));		//5
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getReg_date(), cellFormat));			//6
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getTitle(), cellFormat));				//7
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getStatus_name(), cellFormat));		//8
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getClose_status(), cellFormat));	    //9
				sheet1.addCell(new jxl.write.Label(num++, row, result.get(i).getAssignee(), cellFormat));		//10
				*/
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Id")), cellFormat));  				//0
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Service_name")), cellFormat)); 		//1
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Proc_name")), cellFormat));			//2
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Svc_ci_name")), cellFormat));		//3
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Req_usr_name")), cellFormat));		//4
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Reg_usr_name")), cellFormat));		//5
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Reg_date")), cellFormat));			//6
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Title")), cellFormat));				//7
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Status_name")), cellFormat));		//8
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Close_status")), cellFormat));	    //9
				sheet1.addCell(new jxl.write.Label(num++, row, (String) (excelMap.get("Assignee")), cellFormat));		//10
				
				row++;
			}
			
}
	

	private String createFileName(String type) {
		SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREA);
		return "valueManualCalcExcelView_"+fileFormat.format(new Date())+".xls";
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
	
}
