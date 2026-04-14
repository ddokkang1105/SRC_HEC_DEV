package xbolt.link.sso.saml.web;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.saml.SAMLCredential;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.saml.userdetails.SAMLUserDetailsService;

public class SamlUserDetails implements SAMLUserDetailsService {
	
	private static final Log log = LogFactory.getLog(SamlUserDetails.class);
	
	protected String getEpId(SAMLCredential samlCredential) {
		String attrValue = samlCredential.getAttributeAsString("EP6_UTOKEN");
		if (attrValue == null) {
			throw new UsernameNotFoundException("EpId not found from assertion");
		}
		return attrValue;
	}
	
	@Override
	public Object loadUserBySAML(SAMLCredential credential) throws UsernameNotFoundException
	{
		List<GrantedAuthority> authorities = new ArrayList<>(); // add in an empty list of roles
		return new User(this.getEpId(credential), "", true, true, true, true, authorities);
	}
	
	
}
