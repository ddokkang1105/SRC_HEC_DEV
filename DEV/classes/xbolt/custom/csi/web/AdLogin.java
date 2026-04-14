package xbolt.custom.csi.web;

import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

import xbolt.custom.csi.val.csiGlobalVal;

public class AdLogin{

	private DirContext ldapContext;
	private String host = csiGlobalVal.CSI_HOST; // 변동가능
	private String baseDn = csiGlobalVal.CSI_BASEDN; // 변동가능
	private String ldap = csiGlobalVal.CSI_LDAP; // // 변동가능 : 203.228.108.2 또는 3 

	public boolean loginAD(String username, String password) {

		boolean isSuccess = false;
		
		try {
			Hashtable<String, String> ldapEnv = new Hashtable<String, String>(5);
			ldapEnv.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
			ldapEnv.put(Context.PROVIDER_URL, "ldap://" + ldap);
			ldapEnv.put(Context.SECURITY_AUTHENTICATION, "simple");
			ldapEnv.put(Context.SECURITY_PRINCIPAL, username + "@" + host);
			ldapEnv.put(Context.SECURITY_CREDENTIALS, password);
			
			ldapContext = new InitialDirContext(ldapEnv);
	        isSuccess = hasUser(username);
		}catch (NamingException ne) {
			ne.printStackTrace();
			isSuccess = false;
		}finally {
			close();
		}
		return isSuccess;
	}

	public boolean hasUser(String username) {
		try {
			NamingEnumeration<SearchResult> all = ldapContext.search(baseDn, "sAMAccountName=" + username, getSearchControl());
			return all.hasMoreElements();
		}catch (NamingException ne) {
			ne.printStackTrace();
			return false;
		}
	}	
	
	public SearchControls getSearchControl() {
		String returnedAtts[] ={ "sn", "givenName", "mail", "sAMAccountName" };
		SearchControls sControl = new SearchControls();
		sControl.setReturningAttributes(returnedAtts);
		sControl.setCountLimit(1);
		sControl.setSearchScope(SearchControls.SUBTREE_SCOPE);
		return sControl;
	}	
	
	public void close() {
		if (ldapContext != null) {
			try {
				ldapContext.close();
			}catch(NamingException ne) {
				System.out.println(ne.toString());
			}
		}
	}	
}