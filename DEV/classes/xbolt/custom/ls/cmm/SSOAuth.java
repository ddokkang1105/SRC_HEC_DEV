package xbolt.custom.ls.cmm;

import java.io.*;
import java.util.*;

import io.jsonwebtoken.*;

import java.security.PublicKey;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SSOAuth {
	private HttpServletRequest request;
	private HttpServletResponse response;
	private boolean IsError = false;
	private String ErrorMessage;
	private Map<String, Object> attributes = new HashMap<String, Object>();
	private Properties properties;
	
	public SSOAuth (HttpServletRequest request, HttpServletResponse response) throws IOException
	{
		this.request = request;
		this.response = response; 
	
		this.properties = new Properties();
		InputStream inputStream = getClass().getResourceAsStream("/config.properties");
		this.properties.load(inputStream);
		inputStream.close();		
	}
	
	public void ssoLogin() throws IOException
	{
		String Adfs_Auth_Url = idpUrl()
				+ "?client_id=" + clientID()
				+ "&redirect_uri=" + acsUrl()
				+ "&response_mode=form_post"
				+ "&response_type=code+id_token"
				+ "&scope=openid+profile"
				+ "&nonce=" + UUID.randomUUID().toString();
				
		response.sendRedirect(Adfs_Auth_Url);	
	}
	
	public void processResponse() throws ExpiredJwtException, JwtException, Exception
	{	
		String id_Token = this.request.getParameter("id_token");
		
		if (id_Token != null && id_Token != "")
		{	
			try
			{
				byte[] certDer = Base64.getDecoder().decode(certKey());
				InputStream certStream = new ByteArrayInputStream(certDer);
				Certificate cert =  CertificateFactory.getInstance("X.509").generateCertificate(certStream);
				PublicKey pubKey = cert.getPublicKey();
				Jws<Claims> claimJws = Jwts.parser().setSigningKey(pubKey).parseClaimsJws(id_Token);	
							
				if (claimJws != null)
				{
					this.attributes = new HashMap<>(claimJws.getBody());
				}
				
			}
			catch(ExpiredJwtException e)
			{
				this.IsError = true;
				this.ErrorMessage = e.getMessage();
			}
			catch(JwtException e)
			{
				this.IsError = true;
				this.ErrorMessage = e.getMessage();
			}	
			catch(Exception e)
			{
				this.IsError = true;
				this.ErrorMessage = e.getMessage();
			}			
		}
		
	}
		
	public final boolean isAuthenticated()
	{
		return !this.IsError;
	}
	
	public final String getErrorMessage()
	{
		return this.ErrorMessage;
	}		

	public Map<String, Object> getAttributes()
	{
		return this.attributes;
	}
		
	private String idpUrl()
	{
		return this.properties.getProperty("idp_url");			
	}
	
	private String clientID()
	{
		return this.properties.getProperty("idp_client_id");		
	}
	
	private String certKey()
	{
		return this.properties.getProperty("idp_cert_key");		
	}	
	
	private String acsUrl()
	{
		return this.properties.getProperty("sp_acs_url");			
	}	
}
