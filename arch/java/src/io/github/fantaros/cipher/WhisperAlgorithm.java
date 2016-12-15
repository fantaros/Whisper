package io.github.fantaros.cipher;

import java.lang.reflect.Array;
import java.util.List;

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
	
	public static byte[] encrypto(byte[] baseData, WhisperKey password, int blockSize) {
		if (baseData != null && password != null) {
			int len = baseData.length;
	        int olen = (int)((len / (double)blockSize) + 0.9) * blockSize;
			List<Integer> blockList = password.recook(olen, blockSize);
	        byte[] oData = new byte[olen + 1];
	        WhisperBlock block = new WhisperBlock(blockSize);
	        int j;
	        byte dataSalt = (byte)(unsignedByte(password.calculateSalt(baseData)) ^ unsignedByte(password.getKeySalt()));
	        byte[] cookedBaseData = new byte[olen];
	        for (int i = 0; i < baseData.length; ++i) {
	        	cookedBaseData[i] = (byte)(baseData[i] ^ unsignedByte(dataSalt));
	        }
	        if(olen > len) {
	        	for (int i = 0; i < (olen - len); ++i) {
	        		if (len + i < olen) {
	        			cookedBaseData[len + i] = (byte)(0 ^ unsignedByte(dataSalt));
	        		}
	        	}
	        }
	        
	        int location = 0;
	        for (int i = 0; i < blockList.size(); ++i) {
	        	int offset = blockList.get(i) * blockSize;
	        	block.refreshData(cookedBaseData, offset);
	        	byte ring = password.getRing((int)(location / blockSize));
	            byte key;
	            block.blockSwapWithKey(password, ring);
	            for (j = 0; j < blockSize; ++j) {
	            	key = password.getKey((location + j));
	            	block.whisping(j, key, password.getKey(key));
	            }
	            block.accept(oData, location);
	            location = location + blockSize;
	        }
	        oData[olen] = (byte)unsignedByte((int)dataSalt ^ (int)password.getKey(0));
	        return oData;
		}
		return null;
	}
	
	public static byte[] decrypto(byte[] baseData, WhisperKey password, int blockSize) {
		if (baseData != null && password != null) {
			int len = baseData.length;
	        int olen = len - 1;
	        List<Integer> blockList = password.recook(olen, blockSize);
	        byte[] oData = new byte[olen];
	        WhisperBlock block = new WhisperBlock(blockSize);
	        int j;
	        int location = 0;
	        byte dataSalt = (byte)(unsignedByte(baseData[baseData.length - 1])  ^ unsignedByte(password.getKey(0)));
	        for (int i = 0; i < blockList.size(); ++i) {
	            int offset = blockList.get(i) * blockSize;
	            block.refreshData(baseData, location);
	            byte ring = password.getRing(location / blockSize);
	            byte key;
	            for (j = 0; j < blockSize; ++j) {
	                key = password.getKey(location + j);
	                block.whisping(j, key, password.getKey(key));
	            }
	            block.deBlockSwapWithKey(password, ring);
	            block.accept(oData, offset);
	            location = location + blockSize;
	        }
	        for (int i = 0; i < oData.length; ++i) {
	        	oData[i] = (byte)(oData[i] ^ unsignedByte(dataSalt));
	        }
	        return oData;
		}
		return null;
	}
	
}
