package io.github.fantaros.cipher;

import io.github.fantaros.cipher.basement.WhisperBlock;
import io.github.fantaros.cipher.data.WhisperKey;

public class WhisperAlgorithm {

	public static byte[] addHeader(byte[] baseData) {
		int len = baseData.length;
		byte[] newArray = new byte[len + 4];
		newArray[0] = (byte)(unsignedByte(((len & 0xff000000)>>>24) & 0xff) ^ ((byte)'w'));
		newArray[1] = (byte)(unsignedByte(((len & 0x00ff0000)>>>16) & 0xff) ^ ((byte)'s'));
		newArray[2] = (byte)(unsignedByte(((len & 0x0000ff00)>>>8) & 0xff) ^ ((byte)'p'));
		newArray[3] = (byte)(unsignedByte((len & 0x000000ff) & 0xff) ^ ((byte)'f'));
		for (int i = 0; i < len; ++i) {
			newArray[i + 4] = baseData[i];
		}
		return newArray;
	}

	public static int decodeHeader (byte[] decrypted) {
		long i0 = (decrypted[0] ^ ((byte) 'w')) << 24;
		int i1 = (decrypted[1] ^ ((byte) 's')) << 16;
		int i2 = (decrypted[2] ^ ((byte) 'p')) << 8;
		int i3 = (decrypted[3] ^ ((byte) 'f'));
		long length = (i0 | i1 | i2 | i3);
		return (int) length;
	}

	public static byte[] decodeContent (byte[] decrypted) {
		int len = decodeHeader(decrypted);
		if (len < 1) {
			len = decrypted.length;
		}
		byte[] newArray = new byte[len];
		for (int i = 0; i < len; ++i) {
			newArray[i] = decrypted[i + 4];
		}
		return newArray;
	}

	public static int unsignedByte(int data) {
		if (data >= 0) {
			return data;
		} else {
			return 256 + data;
		}
	}

	public static int unsignedByteToInt(int data) {
		if (data >= 0) {
			return data;
		} else {
			return 256 + data;
		}
	}
	
	public static byte[] encrypto(byte[] baseData, WhisperKey password) {
		if (baseData != null && password != null) {
			int len = baseData.length;
	        int olen = (int)((len / 4.0) + 0.9) * 4;
			password.recook(olen);
	        byte[] oData = new byte[olen];
	        WhisperBlock block = new WhisperBlock();
	        int j;
	        for (int i = 0; i < baseData.length; i += 4) {
	        	block.setValue(baseData, i);
	        	byte ring = password.getRing((int)(i/4));
	            byte key;
	            block.blockSwap(ring);
	            for (j = 0; j < 4; ++j) {
	            	key = password.getKey(i + j);
	            	block.whisping(j, key, password.getKey(key));
	            }
	            block.accept(oData, i);
	        }
	        return oData;
		}
		return null;
	}
	
	public static byte[] decrypto(byte[] baseData, WhisperKey password) {
		if (baseData != null && password != null) {
			int len = baseData.length;
	        int olen = len;
			password.recook(olen);
	        byte[] oData = new byte[olen];
	        WhisperBlock block = new WhisperBlock();
	        int j;
	        for (int i = 0; i < baseData.length; i += 4) {
	        	block.setValue(baseData, i);
	        	byte ring = password.getRing((int)(i/4));
	            byte key;
	            for (j = 0; j < 4; ++j) {
	            	key = password.getKey(i + j);
	            	block.whisping(j, password.getKey(key), key);
	            }
	            block.deBlockSwap(ring);
	            block.accept(oData, i);
	        }
	        return oData;
		}
		return null;
	}
	
}
