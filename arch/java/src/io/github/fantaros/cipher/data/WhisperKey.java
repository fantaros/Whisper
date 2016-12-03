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

	private static final int[] WhisperSwapMagic = new int[] {
			27,30,39,45,54,57,
			75,78,99,108,114,120,
			135,141,147,156,177,180,
			198,201,210,216,225,228
	};

	private byte[] whisperStoredKey;
	private byte[] whisperStoredRing;
	private String password;
	private int keyLength;

	private WhisperKey (String password) {
		this.password = password;
		this.keyLength = 163;
		setupKey();
		setupRing();
	}

	private WhisperKey (String password, int keyLength) {
		this.password = password;
		this.keyLength = (keyLength >= 163 ? keyLength : 163 );
		setupKey();
		setupRing();
	}

	public void recook(long seed) {
		if (this.whisperStoredKey != null) {
			if (seed < 0) {
				seed = Math.abs(seed);
			}
			seed = (long)unsignedByte( (int)(seed % 256) );
			byte[] keys = new byte[this.whisperStoredKey.length];
			for (int i = 0; i < this.whisperStoredKey.length; ++i) {
				byte val = this.whisperStoredKey[i];
				keys[i] = (byte) unsignedByte(((int) (val ^ seed)));
			}
			this.whisperStoredKey = keys;
		}

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

	private void setupRing (){
		int i;
		List<Byte> mutableRing = new ArrayList<Byte>();
	    for (i = 0; i < this.whisperStoredKey.length - 1; i += 2) {
	        byte res = (byte)WhisperSwapMagic[reget((int)(this.whisperStoredKey[i % this.keyLength]), (int)(this.whisperStoredKey[(i + 1) % this.keyLength])) % WhisperSwapMagic.length];
	        mutableRing.add(res);
	    }
	    this.whisperStoredRing = new byte[mutableRing.size()];
		for(i = 0; i < mutableRing.size(); ++i) {
			this.whisperStoredRing[i] = mutableRing.get(i).byteValue();
		}
	}
	
//	 private byte reget(byte a, byte b) {
//         byte ret = (byte)(a & 0xf0);
//         ret = (byte)(ret | (b & 0x0f));
//         return ret;
//     }
	
	private int unsignedByte(int data) {
		if (data >= 0) {
			return data;
		} else {
			return 256 + data;
		}
	}
	
	private int unsignedByteToInt(int data) {
		if (data >= 0) {
			return data;
		} else {
			return 256 + data;
		}
	}

     public byte getKey(int offset) {
         return this.whisperStoredKey[unsignedByteToInt(offset) % this.keyLength];
     }

     public byte getRing(int offset) {
         return this.whisperStoredRing[unsignedByteToInt(offset) % this.whisperStoredRing.length];
     }

     public int reget(int a, int b) {
    	 int ret = (int)(a & 0x000000f0);
         ret = (int)(ret | (b & 0x0000000f));
         return ret;
     }

}
