package xbolt.cmm.framework.util;

import org.springframework.stereotype.Controller;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
/**
 * @Class Name : AESUtil.java
 * @Description : AESUtil.java
 * @Modification AES128 암호화 클래스
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2017. 06. 27. smartfactory		최초생성
 *
 * @since 2017. 06. 27.
 * @version 1.0
 * @see
 * Copyright (C) 2017 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unchecked")
public class AESUtil {
    private String IV = "F27E5C0927826BDEFEB5E0A11D33D137";
    private String SALT = "3AB2EC019C627B945752EABFD71A01B6985AC21D52A20BC133892B89E0E59E55";
    private String PASSPHRASE = "passPhrase passPhrase aes encoding algorithm";
    
	private int keySize = 128;
	private int ivSize = 128;
    private int iterationCount = 10000;
    private Cipher cipher;
 
    public AESUtil() {
    	
        try {
			cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			System.out.println(e.toString());
		} catch (NoSuchPaddingException e) {
			// TODO Auto-generated catch block
			System.out.println(e.toString());
		}
    }
    
    public void init() {
    	this.IV = "F27E5C0927826BDEFEB5E0A11D33D137";
    	this.SALT = "3AB2EC019C627B945752EABFD71A01B6985AC21D52A20BC133892B89E0E59E55";
    }
 
    public String getIV() {
		return IV;
	}

	public void setIV(String iV) {
		IV = iV;
	}

	public String getSALT() {
		return SALT;
	}

	public void setSALT(String sALT) {
		SALT = sALT;
	}

	public String encrypt(String plaintext) {
        try {
            SecretKey key = generateKey(this.SALT, this.PASSPHRASE);
            byte[] encrypted = doFinal(Cipher.ENCRYPT_MODE, key, this.IV,
                    plaintext.getBytes("UTF-8"));
            return base64(encrypted);
        } catch (Exception e) {
            throw fail(e);
        }
    }
 
    public String decrypt(String ciphertext) {
        try {
            SecretKey key = generateKey(this.SALT, this.PASSPHRASE);
            byte[] decrypted = doFinal(Cipher.DECRYPT_MODE, key, this.IV,
                    base64(ciphertext));
            return new String(decrypted, "UTF-8");
        } catch (Exception e) {
            throw fail(e);
        }
    }
 
    private byte[] doFinal(int encryptMode, SecretKey key, String iv,
            byte[] bytes) {
        try {
            cipher.init(encryptMode, key, new IvParameterSpec(hex(iv)));
            return cipher.doFinal(bytes);
        } catch (Exception e) {
            throw fail(e);
        }
    }
 
    private SecretKey generateKey(String salt, String passphrase) {
        try {
            SecretKeyFactory factory = SecretKeyFactory
                    .getInstance("PBKDF2WithHmacSHA1");
    KeySpec spec = new PBEKeySpec(passphrase.toCharArray(),
            hex(salt), iterationCount, keySize);
    SecretKey key = new SecretKeySpec(factory.generateSecret(spec)
            .getEncoded(), "AES");
            return key;
        } catch (Exception e) {
            throw fail(e);
        }
    }
 
    public static String random(int length) {
        byte[] salt = new byte[length];
        new SecureRandom().nextBytes(salt);
        return hex(salt);
    }
 
    public static String base64(byte[] bytes) {
        return Base64.encodeBase64String(bytes);
    }
 
    public static byte[] base64(String str) {
        return Base64.decodeBase64(str);
    }
 
    public static String hex(byte[] bytes) {
        return Hex.encodeHexString(bytes);
    }
 
    public static byte[] hex(String str) {
        try {
            return Hex.decodeHex(str.toCharArray());
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
 
    private IllegalStateException fail(Exception e) {
        return new IllegalStateException(e);
    }
    
    public byte[] creteSecureRandom() {
    	 SecureRandom random = new SecureRandom();
	      byte bytes[] = new byte[20];
	      random.nextBytes(bytes);
	      byte seed[] = random.generateSeed(20);
	      
	      System.out.println("seed ==> " + seed.toString());
	      
	      return seed;
	      
    }
    
    public String decrypt(String ciphertext, String passphrase) {
        try {
        	System.out.println(ciphertext);
            // 텍스트를 BASE64 형식으로 디코드 한다.
            byte[] ctBytes = base64(ciphertext);
        	System.out.println(ctBytes.length);
 
            // 솔트를 구한다. (생략된 8비트는 Salted__ 시작되는 문자열이다.) 
            byte[] saltBytes = Arrays.copyOfRange(ctBytes, 8, 16);
        	System.out.println(saltBytes.length);
            
            // 암호화된 테스트를 구한다.( 솔트값 이후가 암호화된 텍스트 값이다.)
            byte[] ciphertextBytes = Arrays.copyOfRange(ctBytes, 16, ctBytes.length);
        	System.out.println(ciphertextBytes.length);
                      
            // 비밀번호와 솔트에서 키와 IV값을 가져온다.
            byte[] key = new byte[keySize / 8];
            byte[] iv = new byte[ivSize / 8];
            EvpKDF(passphrase.getBytes("UTF-8"), keySize, ivSize, saltBytes, key, iv);
            
            // 복호화 
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(key, "AES"), new IvParameterSpec(iv));
            byte[] recoveredPlaintextBytes = cipher.doFinal(ciphertextBytes);
            System.out.println(new String(recoveredPlaintextBytes));
            return new String(recoveredPlaintextBytes);
        } catch (Exception e) {
            e.printStackTrace();
        }
 
        return null;
    }
    
    private byte[] EvpKDF(byte[] password, int keySize, int ivSize, byte[] salt, byte[] resultKey, byte[] resultIv) throws NoSuchAlgorithmException {
        return EvpKDF(password, keySize, ivSize, salt, 1, "MD5", resultKey, resultIv);
    }
 
    private byte[] EvpKDF(byte[] password, int keySize, int ivSize, byte[] salt, int iterations, String hashAlgorithm, byte[] resultKey, byte[] resultIv) throws NoSuchAlgorithmException {
    	keySize = keySize / 32;
    	ivSize = ivSize / 32;
    	
        int targetKeySize = keySize + ivSize;
        byte[] derivedBytes = new byte[targetKeySize * 4];
        int numberOfDerivedWords = 0;
        byte[] block = null;
        MessageDigest hasher = MessageDigest.getInstance(hashAlgorithm);
        while (numberOfDerivedWords < targetKeySize) {
            if (block != null) {
                hasher.update(block);
            }
            hasher.update(password);            
            // Salting 
            block = hasher.digest(salt);
            hasher.reset();
            // Iterations : 키 스트레칭(key stretching)  
            for (int i = 1; i < iterations; i++) {
                block = hasher.digest(block);
                hasher.reset();
            }
            System.arraycopy(block, 0, derivedBytes, numberOfDerivedWords * 4, Math.min(block.length, (targetKeySize - numberOfDerivedWords) * 4));
            numberOfDerivedWords += block.length / 4;
        }
        System.arraycopy(derivedBytes, 0, resultKey, 0, keySize * 4);
        System.arraycopy(derivedBytes, keySize * 4, resultIv, 0, ivSize * 4);
        return derivedBytes; // key + iv
    }    

}
