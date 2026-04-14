package xbolt.custom.sk.cmm.ldap;

import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.servlet.http.HttpServletRequest;

import com.azure.core.util.Base64Util;

import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;

// LDAP
public class LdapUserChecker {
	
	//SKon (H67)
    private final static String skonProviderUrl = "LDAP://skdir1.skcorp.net:389";
    private final static String skonPrincipalSuffix = "@skcorp.net";

    //SKoh
    private final static String skohProviderUrl = "LDAP://10.92.94.31:389";
    private final static String skohPrincipalSuffix = "@skoneu.com";
    
    //SKoy
    private final static String skoyProviderUrl = "LDAP://10.98.2.31:389";
    private final static String skoyPrincipalSuffix = "@skoncn.com";

    public static boolean isLdapUser(String username, String password, String companyCode) {
        //
    	boolean result = false;
        Hashtable<String, String> env = genEnvHashtable(username, password, companyCode);
        DirContext ctx = null;
        try {
            ctx = new InitialDirContext(env); 
            System.out.println("ctx : " + ctx); //REMOVE
            // 인증 성공
            result = true;
        }
        catch (NamingException exc) {
        	result = false;
        	// [LDAP: error code 49 - 80090308: LdapErr: DSID-0C090447, comment: AcceptSecurityContext error, data 52e, v3839 ]
        	
        }
        finally {
            try {
                if (ctx != null) {
                    ctx.close();
                }
            }
            catch (Exception e) {
            }
        }
        
        return result;
    }

    private static Hashtable<String, String> genEnvHashtable(String username, String password, String companyCode) {
        
        if ("SKO1".equals(companyCode) || "SKO2".equals(companyCode) || "SKBA".equals(companyCode) || "SKOJ".equals(companyCode) || "SKOS".equals(companyCode)) { // SKO1, SKO2, SKBA, SKOJ, SKOS
            return genEnvHashtableForSkon(username, password);
        } else if ("SKOH1".equals(companyCode) || "SKOH2".equals(companyCode) || "SKBM".equals(companyCode)) { // SKOH1, SKOH2, SKBM
        	return genEnvHashtableForSkoh(username, password);
        } else {
        	return genEnvHashtableForSkoy(username, password);
        }
    }

    private static Hashtable<String, String> genEnvHashtableForSkoh(String username, String password) {
        //
        Hashtable<String, String> env = new Hashtable<>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.SECURITY_AUTHENTICATION, "simple");

        String ldapUser = username + skohPrincipalSuffix;
        env.put(Context.PROVIDER_URL, skohProviderUrl);
        env.put(Context.SECURITY_PRINCIPAL, ldapUser);
        env.put(Context.SECURITY_CREDENTIALS, password);
        return env;
    }

    private static Hashtable<String, String> genEnvHashtableForSkon(String username, String password) {
        //
        Hashtable<String, String> env = new Hashtable<>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.SECURITY_AUTHENTICATION, "simple");

        String ldapUser = username + skonPrincipalSuffix;
        env.put(Context.PROVIDER_URL, skonProviderUrl);
        env.put(Context.SECURITY_PRINCIPAL, ldapUser);
        env.put(Context.SECURITY_CREDENTIALS, password);
        return env;
    }
    
    private static Hashtable<String, String> genEnvHashtableForSkoy(String username, String password) {
        //
        Hashtable<String, String> env = new Hashtable<>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.SECURITY_AUTHENTICATION, "simple");

        String ldapUser = username + skoyPrincipalSuffix;
        env.put(Context.PROVIDER_URL, skoyProviderUrl);
        env.put(Context.SECURITY_PRINCIPAL, ldapUser);
        env.put(Context.SECURITY_CREDENTIALS, password);
        return env;
    }
    
}