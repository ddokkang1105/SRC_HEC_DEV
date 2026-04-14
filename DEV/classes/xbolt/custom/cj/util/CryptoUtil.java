package xbolt.custom.cj.util;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;

import sun.misc.BASE64Decoder;
import xbolt.cmm.framework.util.ExceptionUtil;

public class CryptoUtil {

	public static SecretKey generateKey(String keyValue) throws NoSuchAlgorithmException, UnsupportedEncodingException, InvalidKeyException, InvalidKeySpecException {
		final MessageDigest md = MessageDigest.getInstance("md5");
		final byte[] digestOfPassword = md.digest(keyValue.getBytes("utf-8"));

		byte[] keyBytes = new byte[24];
		System.arraycopy(digestOfPassword, 0, keyBytes, 0, digestOfPassword.length);
		for (int j = 0, k = 16; j < 8; k++, j++) {
			keyBytes[k] = keyBytes[j];
		}

		DESedeKeySpec key = new DESedeKeySpec(keyBytes);
		SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DESede");

		return keyFactory.generateSecret(key);
	}

	public static String decrypt(String keyValue, String codedID) throws ExceptionUtil  {
		if (codedID == null || codedID.length() == 0) return "";
		String strResult = "";
		try {
			Cipher cipher = Cipher.getInstance("DESede/ECB/PKCS5Padding");
			cipher.init(Cipher.DECRYPT_MODE, generateKey(keyValue));
			
			BASE64Decoder decoder = new BASE64Decoder();
			byte[] inputBytes1 = decoder.decodeBuffer(codedID);
			
			byte[] outputBytes2 = cipher.doFinal(inputBytes1);
			strResult = new String(outputBytes2, "UTF-8");
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return strResult;
	}

	public static void main(String[] args) throws Exception {
		String keyValue = "SFOL";		// 상호간에 협의한 키값을 지정하세요
		String encodedtext = "T6z7bSd6cOWhFZLiNu+DrA==";	// 인코딩된 아이디 혹은 사번을 셋팅하세요
		
		String decodedtext = decrypt(keyValue, encodedtext);

	}
}

