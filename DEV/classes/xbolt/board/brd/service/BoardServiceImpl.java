package xbolt.board.brd.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;
import xbolt.cmm.service.CommonDataServiceImpl;


@Service("boardService")
@SuppressWarnings("unchecked")
public class BoardServiceImpl extends CommonDataServiceImpl implements CommonService{

	@Override
	public void save(Map map) throws Exception{
		String gubun = (String)map.get("GUBUN");		
		String sqlInsertName = "";
		
		if("insert".equals(gubun)){
			//게시판정보추가
			if(!StringUtil.checkNull(map.get("folderName")).equals("ChangeSet")){
				insert("board_SQL.boardInsert", map);
			}
		} 
		else if("update".equals(gubun)){
			//게시판정보수정
			if(!StringUtil.checkNull(map.get("folderName")).equals("ChangeSet")){
				update("board_SQL.boardUpdate", map);
			}
		} 	
		else if("delete".equals(gubun)){
			map.put("mode", "delete");
			//게시판 좋아요 삭제
			delete("board_SQL.boardLikeDelete", map);
			//게시판 파일정보 정보 삭제
			delete("boardFile_SQL.boardFile_all_delete", map);
			//게시판정보 삭제
			delete("board_SQL.boardDelete", map);
		} 	
	}

}
