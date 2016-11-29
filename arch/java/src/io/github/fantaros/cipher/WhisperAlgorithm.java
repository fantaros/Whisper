package io.github.fantaros.cipher;

import io.github.fantaros.cipher.basement.WhisperBlock;
import io.github.fantaros.cipher.data.WhisperKey;

public class WhisperAlgorithm {
	
	byte[] encrypto(byte[] baseData, WhisperKey password) {
		if (baseData != null && password != null) {
			int len = baseData.length;
	        int olen = (int)((len / 4.0) + 0.9) * 4;
	        byte[] oData = new byte[olen];
	        WhisperBlock block = new WhisperBlock();
	        int j;
	        for (int i = 0; i < baseData.length; i += 4) {
	        	block.setValue(baseData, i);
	        	byte ring = password.getRing(i);
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
	
	byte[] decrypto(byte[] baseData, WhisperKey password) {
		if (baseData != null && password != null) {
			int len = baseData.length;
	        int olen = len;
	        byte[] oData = new byte[olen];
	        WhisperBlock block = new WhisperBlock();
	        int j;
	        for (int i = 0; i < baseData.length; i += 4) {
	        	block.setValue(baseData, i);
	        	byte ring = password.getRing(i);
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
