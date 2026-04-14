package xbolt.project.chgInf.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;

@Service("CSService")
@SuppressWarnings("unchecked")
public class CSActionServiceImpl  extends CommonDataServiceImpl implements CommonService{
	
	@Override
	public void save(List lst, Map map) throws Exception{

		if("insert".equals(map.get("KBN").toString())){
			for (int i = 0; i < lst.size(); i++) {
				Map data =(HashMap) lst.get(i);
				insert(data.get("SQLNAME").toString(), data);
			}
		} 
		
		if("update".equals(map.get("KBN").toString())){
			for (int i = 0; i < lst.size(); i++) {
				Map data =(HashMap) lst.get(i);
				update(map.get("SQLNAME").toString(), data);
			}
		} 
		
		if("delete".equals(map.get("KBN").toString())){
			for (int i = 0; i < lst.size(); i++) {
				Map data =(HashMap) lst.get(i);
				delete(map.get("SQLNAME").toString(), data);
			}
		}
		
		if("insertCNG".equals(map.get("KBN").toString())){
			/* Insert to TB_CHANGE_SET */
			HashMap setMap = new HashMap();
			HashMap insertCngMap = new HashMap();
			HashMap userInfoMap = new HashMap();
			HashMap projectMap = new HashMap();
			
			setMap.put("s_itemID", map.get("itemID"));
			setMap.put("userId", map.get("userId"));
			userInfoMap = (HashMap) select("project_SQL.getUserInfo", setMap);
			setMap.put("projectID", map.get("projectID"));
			projectMap = (HashMap) select("project_SQL.getProjectCategory", setMap);
			int changeSetID = Integer.parseInt(selectString("cs_SQL.getMaxChangeSetData", setMap));
			
			setMap.put("itemClassCode", StringUtil.checkNull(map.get("classCode")));			
			insertCngMap.put("checkInOption",  selectString("project_SQL.getCheckInOption", setMap));	
			
			insertCngMap.put("ChangeSetID", changeSetID);
			insertCngMap.put("ProjectID", map.get("projectID"));
			insertCngMap.put("PJTCategory", projectMap.get("PJCategory"));
			insertCngMap.put("ItemID", map.get("itemID"));
			insertCngMap.put("ItemClassCode", StringUtil.checkNull(map.get("classCode")));
			insertCngMap.put("ItemTypeCode", selectString("item_SQL.selectedItemTypeCode", setMap));
			insertCngMap.put("AuthorID", map.get("userId"));
			insertCngMap.put("AuthorName", userInfoMap.get("Name"));
			insertCngMap.put("AuthorTeamID", userInfoMap.get("TeamID"));
			insertCngMap.put("CompanyID", userInfoMap.get("CompanyID"));
			insertCngMap.put("Reason", map.get("Reason"));
			insertCngMap.put("Description", map.get("Description"));
			insertCngMap.put("ChangeType", "NEW");
			insertCngMap.put("Status", StringUtil.checkNull(map.get("status"),"MOD"));
			insertCngMap.put("version", StringUtil.checkNull(map.get("version")));
			insert("cs_SQL.insertToChangeSet", insertCngMap);
			
			insertCngMap.remove("Status");
			insertCngMap.put("CurChangeSet", changeSetID);
			insertCngMap.put("s_itemID", map.get("itemID"));
			update("project_SQL.updateItemStatus", insertCngMap); //update TB_ITEM.CurChangeSet 
		} 

	}

}
