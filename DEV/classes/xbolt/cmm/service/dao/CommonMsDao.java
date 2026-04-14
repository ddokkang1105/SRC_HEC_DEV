package xbolt.cmm.service.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.*;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.LoginMap;
import xbolt.cmm.framework.val.GlobalVal;








import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * @Class Name : CommonDao.java
 * @Description : 기본서비스 틀을 잡기 위함
 * @Modification Information
 * 수정일			수정자		수정내용
 * ---------	---------	------------------------------
 * 2010. 9. 9.	swchoi		최초생성
 *
 * @since 2010. 9. 9.
 * @version 1.0
 * @see
 */
@Repository(value="commonDao")
@SuppressWarnings("unchecked")
public class CommonMsDao{

	Log _log = LogFactory.getLog(this.getClass());
	
	@Autowired

	private SqlSession sqlSession;

	public final static String SQL_KEY = "SQL_KEY";
	public final static String SQL_TYPE = "type";
	public final static String SQL_TYPE_INSERT = "I";
	public final static String SQL_TYPE_UPDATE = "U";
	public final static String SQL_TYPE_DELETE = "D";

	// 초기 DAO연결시 DB connect 정보 선언
	/*@Resource(name="sqlMapClient")
	protected void initDao(SqlMapClient sqlMapClient){
		this.setSqlMapClient(sqlMapClient);
	}*/
	
	/**
	 * 등록한다.
	 * @param searchMap - 등록할 정보가 담긴 Map
	 * @return 등록 결과
	 * @exception Exception
	 */
    
	public String insert(Map searchMap) throws ExceptionUtil {
		printOperatorInfo(searchMap);
		return insert((String)searchMap.get(SQL_KEY), searchMap);
	}
	/**
	 * 등록한다.
	 * @param searchMap - 등록할 정보가 담긴 Map
	 * @return 등록 결과
	 * @exception Exception
	 */
	public String insert(String SQL_KEY, Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			
			return Integer.toString(sqlSession.update(SQL_KEY, searchMap));
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}

	/**
	 * 수정한다.
	 * @param searchMap - 수정할 정보가 담긴 Map
	 * @return void형
	 * @exception Exception
	 */
	public void update(Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			update((String)searchMap.get(SQL_KEY), searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	/**
	 * 수정한다.
	 * @param searchMap - 수정할 정보가 담긴 Map
	 * @return void형
	 * @exception Exception
	 */
	public void update(String SQL_KEY, Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			sqlSession.update(SQL_KEY, searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}

	/**
	 * 삭제한다.
	 * @param searchMap - 삭제할 정보가 담긴 Map
	 * @return void형
	 * @exception Exception
	 */
	public int delete(Map searchMap) throws ExceptionUtil {
			try {
			printOperatorInfo(searchMap);
			return delete((String)searchMap.get(SQL_KEY), searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	/**
	 * 삭제한다.
	 * @param searchMap - 삭제할 정보가 담긴 Map
	 * @return void형
	 * @exception Exception
	 */
	public int delete(String SQL_KEY, Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			return sqlSession.delete(SQL_KEY, searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}

	/**
	 * 조회한다.
	 * @param searchMap - 조회할 정보가 담긴 Map
	 * @return 조회한 글
	 * @exception Exception
	 */
	public Map select(Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			return select((String)searchMap.get(SQL_KEY), searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	/**
	 * 조회한다.
	 * @param searchMap - 조회할 정보가 담긴 Map
	 * @return 조회한 글
	 * @exception Exception
	 */
	public Map select(String SQL_KEY, Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			return (Map) selectObject(SQL_KEY, searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}

	/**
	 * 조회한다.
	 * @param searchMap - 조회할 정보가 담긴 Object
	 * @return 조회한 글
	 * @exception Exception
	 */
	public Object selectObject(String SQL_KEY, Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			List mapList = sqlSession.selectList(SQL_KEY, searchMap);
	
			if(!mapList.isEmpty() && mapList.size() > 0) {
				return mapList.get(0);
			}
			else
				return new HashMap();
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		
	}

	/**
	 * 목록을 조회한다.
	 * @param searchMap - 조회할 정보가 담긴 Map
	 * @return 목록
	 * @exception Exception
	 */
	public List selectList(Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			return selectList((String)searchMap.get(SQL_KEY), searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	/**
	 * 목록을 조회한다.
	 * @param searchMap - 조회할 정보가 담긴 Map
	 * @return 목록
	 * @exception Exception
	 */
	public List selectList(String SQL_KEY, Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			return sqlSession.selectList(SQL_KEY, searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}

	/**
	 * 총 갯수를 조회한다.
	 * @param searchMap - 조회할 정보가 담긴 Map
	 * @return 총 갯수
	 * @exception
	 */
	public int selectListTotCnt(Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			String sqlKey = (String)searchMap.get(SQL_KEY);
			return (Integer) selectObject(sqlKey, searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	/**
	 * 총 갯수를 조회한다.
	 * @param searchMap - 조회할 정보가 담긴 Map
	 * @return 총 갯수
	 * @exception
	 */
	public int selectListTotCnt(String SQL_KEY, Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			return (Integer)sqlSession.selectOne(SQL_KEY, searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}

	public Object selectToObject(String SQL_KEY, Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			return sqlSession.selectList(SQL_KEY, searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}

	/**
	 * 문자를 조회한다.
	 * @param searchMap - 조회할 정보가 담긴 Map
	 * @return 총 갯수
	 * @exception
	 */
	public String selectString(String SQL_KEY, Map searchMap) throws ExceptionUtil {
		try {
			printOperatorInfo(searchMap);
			return (String)sqlSession.selectOne(SQL_KEY, searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}

	/**
	 * 각종 ID를 생성한다.
	 * @param tableName
	 * @return
	 * @throws Exception
	 */
	public String nextId(String tableName) throws ExceptionUtil {
		try {
			return nextId(tableName, false, 10);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	/**
	 * 각종 ID를 생성한다.
	 * @param tableName
	 * @param date : true일 경우 TO_CHAR(SYSDATE, 'YYYYMMDD') || '_' 가 추가된다.
	 * @return
	 * @throws Exception
	 */
	public String nextId(String tableName, boolean date, int length) throws ExceptionUtil {
		try {
			Map searchMap = new HashMap();
			searchMap.put("TABLE_NAME", tableName);
			searchMap.put("DATE", date?"1":"0");
			searchMap.put("ID_LENGTH", length);
			return nextId(searchMap);
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	private String nextId(Map searchMap) throws ExceptionUtil {
		//Object object = selectObject("common_SQL.commonId_select", searchMap);

/*
		if(object==null) {
			insert("common_SQL.commonId_insert", searchMap);
		}
		else {
			update("common_SQL.commonId_update", searchMap);
		}*/

//		return (String) selectObject("common_SQL.commonId_select", searchMap);
		try {
			String returnId = "";
	
			returnId = selectString("CommonFile.TB_ATTFILE_NEXTVAL", searchMap);
	
			return returnId;
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	/**
			,USER_ID		/*사용자ID* /
			,CENTER_NO AS BR_CODE	/*지점코드* /
			,BRANCH_CODE	/*지점코드* /
			,USER_NAME		/*사용자명* /
			,PASSWORD		/*사용자 비밀번호* /
			,GRADE			/*역할(구분)* /
			,SABUN			/*사번* /
			,REMARK			/*비고* /
			,TM_GROUP		/*TM_GROUP* /
			,PARENT_BRANCH	/*상위지사* /
			,CAMPAIGN_ID	/*캠페인ID* /
			,GROUP_ID		/*그룹ID* /
			,USER_LEVEL		/*사용자등급* /
			,COMP_CODE		/*소속사* /
			,CALL_GRADE		/*콜등급* /
			,MAX_DC_RATE	/*최대할인가능율* /
			,AGENT_GROUP	/*상담그룹* /
			,MAJOR_GROUP	/*주그룹* /
			,MINOR_GROUP	/*종그릅* /
			,BIRTH_DATE		/*생일* /
			,USE_YN			/*사용여부* /
			,LOGIN_ID		/*로그인ID* /
			,CENTER_NO		/*센터번호* /
			,SIL_NO			/*실번호* /
			,PART_NO		/*파트번호* /
			,MAX_SMS		/*월최대SMS* /
			,AUTHORITY_CD	/* 권한 * /
			,AGENT_ID		/*에이전트ID* /
			,DN				/*내선번호* /
	 * @param map
	 * @throws Exception
	 */
	private void printOperatorInfo(Map map) throws ExceptionUtil {
		try {
			LoginMap loginInfo = (LoginMap) map.get("loginInfo");
			if(loginInfo != null) {
				if(GlobalVal.SESSIONINFO_PRINT_ALL) {
					loginInfo.printAll();
				}
				else {
					loginInfo.print();
				}
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}
}
