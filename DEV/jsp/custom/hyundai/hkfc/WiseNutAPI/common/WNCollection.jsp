<%@ page pageEncoding = "UTF-8" %>
<%@ include file="api/WNDefine.jsp" %>
<%!

	static String SEARCH_IP="10.224.99.221";
	static int SEARCH_PORT=7003;
	static String MANAGER_IP="10.224.99.221";
	static int MANAGER_PORT=7800;

	public String[] COLLECTIONS = new String[]{"KPAL_ITEM","KPAL_FILE"};
	public String[] COLLECTIONS_NAME = new String[]{"KPAL_ITEM","KPAL_FILE"};
	public String[] MERGE_COLLECTIONS = new String[]{""};
	public class WNCollection{
	public String[][] MERGE_COLLECTION_INFO = null;
	public String[][] COLLECTION_INFO = null;
		WNCollection(){
			COLLECTION_INFO = new String[][]
			{
			{
			"KPAL_ITEM", // set index name
			"KPAL_ITEM", // set collection name
			"0,3",  // set pageinfo (start,count)
			"1,1,1,1,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
			"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
			"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
			"DOCID,ITEM_CD,ITEM_NM,ITEM_TYPE_NM,AUTHORID_NM,AUTHOR_EM,ITEM_STATUS_NM,TEAM_NM,ITEM_ATTR_CODE,ITEM_CONTENTS",// set search field
			"DOCID,DATE,ITEM_ID,CREATE_TIME,LAST_UPDATED,ITEM_CD,ITEM_NM/100,ITEM_TYPE_CD,ITEM_TYPE_NM,AUTHORID_NM,AUTHOR_EM,ITEM_STATUS,ITEM_STATUS_NM,ITEM_PATH,TEAM_NM,TEAM_CD,ITEM_ATTR_CODE,ITEM_CONTENTS/100,LANGUAGE_ID,LANGUAGE_CD,ALIAS",// set document field
			"", // set date range
			"", // set rank range
			"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
			"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
			"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
			"", // set filter operation (<fieldname:operator:value>)
			"", // set groupby field(field, count)
			"", // set sort field group(field/order,field/order,...)
			"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
			"", // set categoryGroupBy (fieldname:value)
			"", // set categoryQuery (fieldname:value)
			"", // set property group (fieldname,min,max, groupcount)
			"", // use check prefix query filed
			"", // set use check fast access field
			"", // set multigroupby field
			"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
			"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
			"KPAL_ITEM" // collection display name
			}
         ,
			{
			"KPAL_FILE", // set index name
			"KPAL_FILE", // set collection name
			"0,3",  // set pageinfo (start,count)
			"1,1,1,1,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
			"RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
			"basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
			"DOCID,ITEM_NM,FILE_REAL_NM,FILE_DESC,FILE_CONTENTS",// set search field
			"DOCID,DATE,FILE_ID,CREATE_TIME,MOD_DT,ITEM_ID,ITEM_CD,ITEM_NM,FILE_NM,FILE_REAL_NM/100,FILE_PATH,LANGUAGE_ID,LANGUAGE_CODE,FILE_BLOCKED,DOC_CATEGORY,FILE_DESC,FILE_CONTENTS/100,ALIAS",// set document field
			"", // set date range
			"", // set rank range
			"", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
			"", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
			"", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
			"", // set filter operation (<fieldname:operator:value>)
			"", // set groupby field(field, count)
			"", // set sort field group(field/order,field/order,...)
			"", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
			"", // set categoryGroupBy (fieldname:value)
			"", // set categoryQuery (fieldname:value)
			"", // set property group (fieldname,min,max, groupcount)
			"", // use check prefix query filed
			"", // set use check fast access field
			"", // set multigroupby field
			"", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
			"", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
			"KPAL_FILE" // collection display name
			}
			};
		}
	}
%>