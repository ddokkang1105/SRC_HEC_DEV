package xbolt.cmm.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import xbolt.cmm.service.dao.CommonOraDao;
import xbolt.cmm.framework.util.GlovalStoreUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;



/**
 * @Class Name : CommonOraServiceImpl.java
 * @Description : 공통 서비스 - 오라클 연결 
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0 
 * @see
 */
@Service("commonOraService")
@SuppressWarnings("unchecked")
public class CommonOraServiceImpl implements CommonService {

	/** commonOraDao */
	@Resource(name="commonOraDao")
	protected CommonOraDao commonOraDao;
	
	protected GlovalStoreUtil gloval;

	protected final String _INSERT = "_insert";
	protected final String _UPDATE = "_update";
	protected final String _DELETE = "_delete";

	public CommonOraServiceImpl() {
		super();
		gloval = new GlovalStoreUtil(commonOraDao);
	}
	/**
	 * 등록한다.
	 * @param vo - 등록할 정보가 담긴 Map
	 * @return 등록 결과
	 * @exception Exception
	 */
	public String insert(Map vo) throws Exception {
		String id = StringUtil.checkNull((String)vo.get("id"), "");
		commonOraDao.insert(vo);
		return id;
	}
	public String insert(String sqlId, Map vo) throws Exception {
		String id = StringUtil.checkNull((String)vo.get("id"), "");
		commonOraDao.insert(sqlId, vo);
		return id;
	}
	public String insertReturnParam(String sqlId, Map vo) throws Exception {
		return commonOraDao.insert(sqlId, vo);
	}

	/**
	 * 수정한다.
	 * @param vo - 수정할 정보가 담긴 Map
	 * @return void형
	 * @exception Exception
	 */
	public void update(Map vo) throws Exception {
		commonOraDao.update(vo);
	}
	public void update(String sqlId, Map vo) throws Exception {
		commonOraDao.update(sqlId, vo);
	}

	/**
	 * 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 Map
	 * @return void형
	 * @exception Exception
	 */
	public void delete(Map vo) throws Exception {
		commonOraDao.delete(vo);
	}
	public void delete(String sqlId, Map vo) throws Exception {
		commonOraDao.delete(sqlId, vo);
	}
	public String deleteReturnString(String sqlId, Map vo) throws Exception {
		String str = "";
		commonOraDao.delete(sqlId, vo);
		return str;
	}
	public int deleteReturnParam(String sqlId, Map vo) throws Exception {
		return commonOraDao.delete(sqlId, vo);
	}

	/**
	 * 조회한다.
	 * @param vo - 조회할 정보가 담긴 Map
	 * @return 조회한 결과
	 * @exception Exception
	 */
	public Map select(Map vo) throws Exception {
		Map resultVO = commonOraDao.select(vo);
		if (resultVO == null) {
			return new HashMap();
		}
		return resultVO;
	}
	public Map select(String sqlId, Map vo) throws Exception {
		return commonOraDao.select(sqlId, vo);
	}

	/**
	 * 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 목록
	 * @exception Exception
	 */
	public List selectList(Map searchVO) throws Exception {
		return commonOraDao.selectList(searchVO);
	}
	/**
	 * 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 목록
	 * @exception Exception
	 */
	public List selectList(String sqlId, Map searchVO) throws Exception {
		return commonOraDao.selectList(sqlId, searchVO);
	}

	/**
	 * 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 총 갯수
	 * @exception
	 */
	public int selectListTotCnt(Map searchVO) throws Exception {
		return commonOraDao.selectListTotCnt(searchVO);
	}
	public int selectListTotCnt(String sqlId, Map searchVO) throws Exception {
		return commonOraDao.selectListTotCnt(sqlId, searchVO);
	}
	public Object selectToObject(String sqlId, Map searchVO) throws Exception {
		return commonOraDao.selectToObject(sqlId, searchVO);
	}

	public String nextId(String tableName) throws Exception {
		return nextId(tableName, false, 13);
	}
	public String nextId(String tableName, int length) throws Exception {
		return nextId(tableName, false, length);
	}
	public String nextId(String tableName, boolean needDate) throws Exception {
		return nextId(tableName, needDate, 13);
	}
	public String nextId(String tableName, boolean needDate, int length) throws Exception {
		return commonOraDao.nextId(tableName, needDate, length);
	}
	public String selectString(String sqlId, Map searchVO) throws Exception{
		return commonOraDao.selectString(sqlId, searchVO);
	}

	public void save(Map map) throws Exception {
		saveGrid((String) map.get(commonOraDao.SQL_KEY), map);
	}

	/**
	 * 추가, 수정된 row 단위로 type별로 1건의 sql을 실행한다.
	 * type : I, U, D
	 */
	public void save(String sqlId, Map map) throws Exception {
		saveGrid(sqlId, map);
	}

	public void save(Map map, String key) throws Exception {
		if( key.equals("") ){
			save((String) map.get(commonOraDao.SQL_KEY), map);
		}
	}
	public void saveGrid(Map map) throws Exception {
		save((String) map.get(commonOraDao.SQL_KEY), map);
	}
	public void saveGrid(Map map, String key) throws Exception {
		if( key.equals("") ){
			save((String) map.get(commonOraDao.SQL_KEY), map);
		}
	}

	public int saveGridReturn(Map map, String key) throws Exception {
		return 0;
	}

	public void save(List lst) throws Exception {
		Map map = new HashMap();
		for (int i=0;i <lst.size();i++){
			map = (Map) lst.get(i);
			if(map.get(commonOraDao.SQL_TYPE).equals(commonOraDao.SQL_TYPE_INSERT)){
				insert(map.get(commonOraDao.SQL_KEY)+_INSERT,(HashMap) map.get("commandMap"));
			}
			else if(map.get(commonOraDao.SQL_TYPE).equals(commonOraDao.SQL_TYPE_UPDATE)){
				update(map.get(commonOraDao.SQL_KEY)+_UPDATE,(HashMap) map.get("commandMap"));
			}
			else if(map.get(commonOraDao.SQL_TYPE).equals(commonOraDao.SQL_TYPE_DELETE)){
				delete(map.get(commonOraDao.SQL_KEY)+_DELETE,(HashMap) map.get("commandMap"));
			}
		}
	}
	public void save(List lst1, List lst2) throws Exception {
		Map map = new HashMap();
		for (int i=0;i <lst1.size();i++){
			map = (Map) lst1.get(i);
			if(map.get(commonOraDao.SQL_TYPE).equals(commonOraDao.SQL_TYPE_INSERT)){
				insert(map.get(commonOraDao.SQL_KEY)+_INSERT,(HashMap) map.get("commandMap"));
			}
			else if(map.get(commonOraDao.SQL_TYPE).equals(commonOraDao.SQL_TYPE_UPDATE)){
				update(map.get(commonOraDao.SQL_KEY)+_UPDATE,(HashMap) map.get("commandMap"));
			}
			else if(map.get(commonOraDao.SQL_TYPE).equals(commonOraDao.SQL_TYPE_DELETE)){
				delete(map.get(commonOraDao.SQL_KEY)+_DELETE,(HashMap) map.get("commandMap"));
			}
		}
	}
	public void save(List lst, Map commandMap) throws Exception {
		Map map;
		for (int i=0;i <lst.size();i++){
			map = (Map) lst.get(i);
			if(map.get(commonOraDao.SQL_TYPE).equals(commonOraDao.SQL_TYPE_INSERT)){
				insert(map.get(commonOraDao.SQL_KEY)+_INSERT,commandMap);
			}
			else if(map.get(commonOraDao.SQL_TYPE).equals(commonOraDao.SQL_TYPE_UPDATE)){
				update(map.get(commonOraDao.SQL_KEY)+_UPDATE,commandMap);
			}
			else if(map.get(commonOraDao.SQL_TYPE).equals(commonOraDao.SQL_TYPE_DELETE)){
				delete(map.get(commonOraDao.SQL_KEY)+_DELETE,commandMap);
			}
		}
	}
	/**
	 * 추가, 수정된 row 단위로 type별로 1건의 sql을 실행한다.
	 * type : I, U, D
	 */
	public void saveGrid(String sqlId, Map map) throws Exception {
		for (int i = 0; i < NumberUtil.getIntValue(map.get("rowCount")); i++) {
			Map data = fetchRowData(map, i);
			if (data !=null && data.size()>0) {
				String type = (String)data.get(commonOraDao.SQL_TYPE);
				if(type!=null && type.equals(commonOraDao.SQL_TYPE_INSERT)) {
					insert(sqlId + _INSERT, data);
				}
				else if(type!=null && type.equals(commonOraDao.SQL_TYPE_UPDATE)) {
					if("1".equals(data.get("DEL_YN"))) {
						delete(sqlId + _DELETE, data);
					}
					else {
						update(sqlId + _UPDATE, data);
					}
				}
				else if(type!=null && type.equals(commonOraDao.SQL_TYPE_DELETE)) {
					delete(sqlId + _DELETE, data);
				}
			}
		}
	}

	public void deleteGrid(Map map) throws Exception {
		deleteGrid((String) map.get(commonOraDao.SQL_KEY), map);
	}

	/**
	 * row 단위로 1건의 sql을 실행한다.
	 */
	public void deleteGrid(String sqlId, Map map) throws Exception {
		for (int i = 0; i < NumberUtil.getIntValue(map.get("rowCount")); i++) {
			Map data = fetchRowData(map, i);
			if (data !=null && data.size()>0) {
				delete(sqlId, data);
			}
		}
	}

	protected Map fetchRowData(Map map, int index) throws Exception{
		Map result = new HashMap();
		int colNum = NumberUtil.getIntValue(map.get("colNum"));
		String[]cols = ((String) map.get("colName")).split("[|]");
		//		System.out.println("colName:" + (String) map.get("colName"));
		for(int i = 1; i < colNum; i++) {
			//			System.out.println("colNum:" + colNum + " cols[" + (i-1) + "]" );
			result.put(cols[i-1], map.get("r"+index+"_col"+i));
		}
		result.put(commonOraDao.SQL_TYPE, map.get("r"+index+"_type"));
		if (map.get("loginInfo")!=null) {
			result.putAll((Map)map.get("loginInfo"));
		}
		return result;
	}

	public Map fetchData(Map map, int rowNum, String col) throws Exception{
		Map result = new HashMap();
		String[]cols = col.split("[|]");
		for(int i = 0; i < cols.length; i++) {
			Object o = map.get(cols[i]);
			if(o instanceof String[]) {
				if(rowNum < ((String[])o).length) {
					result.put(cols[i], ((String[])o)[rowNum]);
				}
			}
			else {
				result.put(cols[i], o);
			}
		}
		if (map.get("loginInfo")!=null) {
			result.putAll((Map)map.get("loginInfo"));
		}
		return result;
	}

	public Object getNextId(String COL_NAME) throws Exception{
		Map map = new HashMap();
		map.put("COL_NAME", COL_NAME);
		return selectToObject("common_SQL.commonSeqId_select", map);
	}
}
