package io.github.fantaros.cipher.data;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

public class WhisperKey {
	public static WhisperKey whisperKeyWithPassword(String password) {
		return new WhisperKey(password);
	}
	
	public static WhisperKey whisperKeyWithPassword(String password, int keyLength) {
		return new WhisperKey(password, keyLength);
	}

	private static final int[] WhisperTable = new int[] {
			0xd6, 0x9c, 0x2b, 0xd7, 0xbd, 0x66,
			0xb5, 0xf9, 0x27, 0xb7, 0x02, 0x86,
			0x68, 0x79, 0xa3, 0xfe, 0x0f, 0x78,
			0xa8, 0x8e, 0x7d, 0xc5, 0x99, 0x25,
			0xc3, 0x20, 0xc8, 0xbf, 0x80, 0x6e,
			0x6b, 0xbe, 0xd1, 0xb7, 0x7a, 0x50,
			0xe3, 0xa4, 0x52, 0x60, 0x5a, 0x26,
			0xb4, 0x1e, 0xaf, 0x73, 0xb1, 0x07,
			0x2d, 0x76, 0xc6, 0x9e, 0xa3, 0x6c,
			0x71, 0x23, 0x38, 0x6f, 0xcb, 0x63,
			0x6c, 0xf1, 0x40, 0x82
	};
	
	private byte[] whisperStoredKey;
	private String password;
	private int keyLength;
	private byte keySalt;
	private boolean keySaltCaculated;

	private WhisperKey (String password) {
		keySaltCaculated = false;
		this.password = password;
		this.keyLength = 163;
		setupKey();
	}

	private WhisperKey (String password, int keyLength) {
		keySaltCaculated = false;
		this.password = password;
		this.keyLength = (keyLength >= 163 ? keyLength : 163 );
		setupKey();
	}
	
	public byte getKeySalt() {
		if (!this.keySaltCaculated) {
			this.keySalt = (byte) this.calculateSalt(this.whisperStoredKey);
			this.keySaltCaculated = true;
		}
		return this.keySalt;
	}
	
	public int calculateSalt (byte[] src) {
		if(src == null) {
			return 0;
		}
		byte salt = this.getKey(0);
		for (int i = 0; i < src.length; ++i) {
			byte key = this.getKey(i);
			byte val = src[i];
			salt = (byte)(((unsignedByte(salt) * unsignedByte(val)) ^ key) % 256); 
		}
		return unsignedByte(salt) ^ unsignedByte(this.getKey(this.whisperStoredKey.length - 1));
	}

	public List<Integer> recook(long outputLength, int blockSize) {
		if (this.whisperStoredKey != null) {
			if (outputLength < 0) {
	            outputLength = Math.abs(outputLength);
	        }
	        byte seed = (byte)unsignedByte(outputLength % 256);
	        List<Byte> keys = new ArrayList<Byte>(this.whisperStoredKey.length);
	        for (int i = 0; i < this.whisperStoredKey.length; ++i) {
	        	byte val = this.whisperStoredKey[i];
	        	keys.add((byte)unsignedByte(val ^ seed));
	        }
	        this.whisperStoredKey = new byte[keys.size()];
	        for (int i = 0; i < keys.size(); ++i) {
	        	this.whisperStoredKey[i] = keys.get(i);
	        }
	        int blockCount = ((int)outputLength / blockSize);
	        return  this.buildSwapArray(blockCount, 0);
		}
		return null;
	}
	
	public List<Integer> buildSwapArray(int seed, int salt) {
		List<Integer> result = new ArrayList<Integer>(seed);
		for (int i = 0; i < seed; ++i) {
			result.add(i);
		}
		//乱序过程
		int tmp;
		for (int o = seed - 1; o > 0; o = o - 1) {
			int j = (int)(((int)((this.getKey(this.getRing(o ^ salt)) / 256.0) * o)) % seed);
			tmp = result.get(o).intValue();
			result.set(o, result.get(j).intValue());
			result.set(j, tmp);
		}
		return result;
	}

	private void setupKey (){
		if(this.password == null || this.password.length() < 1) {
			this.password = "1234567890";
		}
		byte [] passwordData = this.password.getBytes(Charset.forName("UTF8"));
		int i = 0;
		List<Byte> mutableKeys = new ArrayList<Byte>();
		for (; i < this.keyLength; ++i) {
			if (i < passwordData.length) {
				byte res = (byte)(passwordData[i] ^ WhisperTable[unsignedByte(passwordData[i % passwordData.length]) % WhisperTable.length]);
				mutableKeys.add(res);
			} else {
				byte res =  (byte)(
						(mutableKeys.get((i + 1) % passwordData.length) & 0xc0 |
								mutableKeys.get((i + 3) % passwordData.length) & 0x30 |
								mutableKeys.get(i % passwordData.length) & 0x0c |
								mutableKeys.get((i + 2) % passwordData.length) & 0x03) 
						^ WhisperTable[unsignedByte(passwordData[i % passwordData.length]) % WhisperTable.length]);
				mutableKeys.add(res);
			}
		}

		this.whisperStoredKey = new byte[mutableKeys.size()];
		for(i = 0; i < mutableKeys.size(); ++i) {
			this.whisperStoredKey[i] = mutableKeys.get(i).byteValue();
		}
	}
	
	private int unsignedByte(int data) {
		if (data >= 0) {
			return data;
		} else {
			return 256 + data;
		}
	}
	
	private int unsignedByte(short data) {
		if (data >= 0) {
			return data;
		} else {
			return 256 + data;
		}
	}
	
	private int unsignedByte(long data) {
		if (data >= 0) {
			return (int) data;
		} else {
			return (int) (256 + data);
		}
	}

     public byte getKey(int offset) {
         return this.whisperStoredKey[unsignedByte(offset) % this.keyLength];
     }

     public byte getRing(int offset) {
         return this.whisperStoredKey[(unsignedByte(offset) ^ this.keyLength) % this.keyLength];
     }

     public int reget(int a, int b) {
    	 int ret = (int)(a & 0x000000f0);
         ret = (int)(ret | (b & 0x0000000f));
         return ret;
     }

}
