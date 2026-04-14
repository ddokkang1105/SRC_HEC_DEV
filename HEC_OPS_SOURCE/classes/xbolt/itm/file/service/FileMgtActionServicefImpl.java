package xbolt.itm.file.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonDataServiceImpl;
import xbolt.cmm.service.CommonService;

@Service("fileMgtService")
public class FileMgtActionServiceImpl extends CommonDataServiceImpl
  implements CommonService
{
  public void save(List lst, Map map)
    throws Exception
  {
    if ("insert".equals(map.get("KBN").toString())) {
      if (StringUtil.checkNull(map.get("Status")).equals("REL")) {
        update("fileMgt_SQL.itemStatus_update", map);
      }
      for (int i = 0; i < lst.size(); i++) {
        Map data = (HashMap)lst.get(i);
        insert(data.get("SQLNAME").toString(), data);
      }
    }

    if ("update".equals(map.get("KBN").toString()))
    {
      for (int i = 0; i < lst.size(); i++) {
        Map data = (HashMap)lst.get(i);
        update(data.get("SQLNAME").toString(), data);
      }
    }

    if ("delete".equals(map.get("KBN").toString()))
      for (int i = 0; i < lst.size(); i++) {
        Map data = (HashMap)lst.get(i);
        delete(map.get("SQLNAME").toString(), data);
      }
  }
}