package xbolt.custom.daelim.plant;

import java.security.Key;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.axis.encoding.Base64;

public class Rfc2898DeriveBytes {
	
	private final byte[] BYTE_PASSWORD = new byte[] { 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x11, 0x11, 0x12, 0x13, 0x14, 0x0e, 0x16, 0x17 };
	private final String SALT = "fasdfocvagjqe!@#";
	private final String ENCODING_TYPE = "UTF-8";
	
	
	public Rfc2898DeriveBytes()
	{
	}
	
	public String getEncryptBase64(String sInput) throws Exception
	{
		String sReturnBase64 = getBase64(getCypher(getKeySpec()).doFinal(sInput.getBytes(ENCODING_TYPE)));
		return sReturnBase64;
	}
	
	private String getBase64(byte[] byteInput) throws Exception
	{
		return new String(Base64.encode(byteInput));
	}
	
	private Cipher getCypher(SecretKeySpec skKey) throws Exception
	{
		AlgorithmParameterSpec ivSpec = new IvParameterSpec(skKey.getEncoded());
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.ENCRYPT_MODE, skKey, ivSpec);
		return cipher;
	}
	
	private SecretKeySpec getKeySpec() throws Exception
	{
		String sPASSWORD = new String(BYTE_PASSWORD, ENCODING_TYPE);
		byte[] byteSalt = new String(SALT).getBytes(ENCODING_TYPE);
		
		SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
		PBEKeySpec pbeKeySpec = new PBEKeySpec(sPASSWORD.toCharArray(), byteSalt  , 1000, 128);
		Key secretKey = factory.generateSecret(pbeKeySpec);
		SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");
		
		return secret;
	}

}
