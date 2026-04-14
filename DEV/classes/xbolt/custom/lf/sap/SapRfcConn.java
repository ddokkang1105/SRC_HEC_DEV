// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   SapRfcConn.java

package xbolt.custom.lf.sap;

//import atom.xlog.XLog;
import com.sap.mw.jco.IFunctionTemplate;
import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.Client;
import com.sap.mw.jco.JCO.Function;
import com.sap.mw.jco.JCO.Table;

//import devon.core.config.LConfiguration;
//import java.io.PrintStream;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import xbolt.custom.lf.val.LfGlobalVal;

public class SapRfcConn
{
	private final Log _log = LogFactory.getLog(this.getClass());

    public SapRfcConn()
    {
    }

    public static com.sap.mw.jco.JCO.Client getClient()
        throws Exception
    {
        com.sap.mw.jco.JCO.Client client=null;
        //LConfiguration lconfiguration = LConfiguration.getInstance();
		try {
			/*
	        String s = lconfiguration.get("/devon/sapconfig/SAP_SYSTEM_ID");
	        String s1 = lconfiguration.get("/devon/sapconfig/SAP_POOL_NAME");
	        String s2 = lconfiguration.get("/devon/sapconfig/SAP_MAX_CONNECT");
	        String s3 = lconfiguration.get("/devon/sapconfig/SAP_CLIENT_NO");
	        String s4 = lconfiguration.get("/devon/sapconfig/SAP_USER_ID");
	        String s5 = lconfiguration.get("/devon/sapconfig/SAP_PASSWORD");
	        String s6 = lconfiguration.get("/devon/sapconfig/SAP_LANGUAGE");
	        String s7 = lconfiguration.get("/devon/sapconfig/SAP_SERVER_IP");
	        String s8 = lconfiguration.get("/devon/sapconfig/SAP_HOST_NAME");
	        String s9 = lconfiguration.get("/devon/sapconfig/SAP_SERVER_NAME");
	        String s10 = lconfiguration.get("/devon/sapconfig/SAP_R3_NAME");
	        String s11 = lconfiguration.get("/devon/sapconfig/SAP_SYSTEM_NO");
	        String s12 = lconfiguration.get("/devon/sapconfig/SAP_GROUP");
	        */
	        String s = LfGlobalVal.SAP_SYSTEM_ID;
	        String s1 = LfGlobalVal.SAP_POOL_NAME;
	        String s2 = LfGlobalVal.SAP_MAX_CONNECT;
	        String s3 = LfGlobalVal.SAP_CLIENT_NO;
	        String s4 = LfGlobalVal.SAP_USER_ID;
	        String s5 = LfGlobalVal.SAP_PASSWORD;
	        String s6 = LfGlobalVal.SAP_LANGUAGE;
	        String s7 = LfGlobalVal.SAP_SERVER_IP;
	        String s8 = LfGlobalVal.SAP_HOST_NAME;
	        String s9 = LfGlobalVal.SAP_SERVER_NAME;
	        String s10 = LfGlobalVal.SAP_R3_NAME;
	        String s11 = LfGlobalVal.SAP_SYSTEM_NO;
	        String s12 = LfGlobalVal.SAP_GROUP;
	        com.sap.mw.jco.JCO.Pool pool = null;
			try{
				System.out.println("SapRfcConn::getClient()::SAP_SYSTEM_ID="+s);
				pool = JCO.getClientPoolManager().getPool(s);
			} catch(Exception ex){
				System.out.println("SapRfcConn::getClient()::pool::"+ex);
				throw ex;
			}
			//System.out.println("pool :"+pool);
	        if(pool == null)
	        {
	        	/*
	        	System.out.println("SapRfcConn::getClient()::SAP_SYSTEM_ID="+s);
	        	System.out.println("SapRfcConn::getClient()::SAP_MAX_CONNECT="+s2);
	        	System.out.println("SapRfcConn::getClient()::SAP_CLIENT_NO="+s3);
	        	System.out.println("SapRfcConn::getClient()::SAP_USER_ID="+s4);
	        	System.out.println("SapRfcConn::getClient()::SAP_PASSWORD="+s5);
	        	System.out.println("SapRfcConn::getClient()::SAP_LANGUAGE="+s6);
	        	System.out.println("SapRfcConn::getClient()::SAP_SERVER_IP="+s7);
	        	System.out.println("SapRfcConn::getClient()::SAP_R3_NAME="+s10);
	        	System.out.println("SapRfcConn::getClient()::SAP_GROUP="+s12);
	        	*/
	        	
	            JCO.addClientPool(s, Integer.parseInt(s2), s3, s4, s5, s6, s7, s10, s12);
	            com.sap.mw.jco.JCO.Pool pool1 = JCO.getClientPoolManager().getPool(s);
	        }
	        client = JCO.getClient(s);
		}catch( Exception ex){
	        System.out.println("SapRfcConn::getClient()::"+ex);
	        throw ex;
		}
        return client;
    }

    public static void releaseClient(com.sap.mw.jco.JCO.Client client)
    {
    	//if(_log.isInfoEnabled()){_log.info("SAP Function END");}
		//XLog.print("SAP Function END");
        JCO.releaseClient(client);
    }

    public static com.sap.mw.jco.JCO.Function createFunc(String s, com.sap.mw.jco.JCO.Client client)
        throws Exception
    {
        IFunctionTemplate ifunctiontemplate;
       // LConfiguration lconfiguration = LConfiguration.getInstance();
        try{
	        //String s1 = lconfiguration.get("/devon/sapconfig/SAP_SERVER_NAME");
        	String s1 = LfGlobalVal.SAP_SERVER_NAME;
	        String s2 = s1;
	        com.sap.mw.jco.JCO.Repository repository = new com.sap.mw.jco.JCO.Repository(s2, client);
	        ifunctiontemplate = repository.getFunctionTemplate(s.toUpperCase());
	        if(ifunctiontemplate == null)
	            return null;
        } catch(Exception ex){
        	 System.out.println("SapRfcConn::createFunc()::"+ex);
            throw ex;
        }
        
        return ifunctiontemplate.getFunction();
    }
}
