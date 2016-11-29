package io.github.fantaros.cipher.basement;

/**
 * Created by fantaros on 2014/5/24.
 */
public class Logix {
    private int[] logixTable;

    public Logix() {
        init(198848);
        System.out.println("logix");
    }

    public Logix(int seed) {
        init(seed);
    }

    public void init (int seed) {
        logixTable = new int[256];
        int i;
        for (i = 0; i < 256; ++i) {
            logixTable[i] = i;
        }
        for (i = 0; i < 32; ++i) {
            logixTable[i] = unsignedByte((byte)(logixTable[seek(i, seed)] ^ logixTable[i]));
            logixTable[seek(i, seed)] = unsignedByte((byte)(logixTable[seek(i, seed)] ^ logixTable[i]));
            logixTable[i] = unsignedByte((byte)(logixTable[seek(i, seed)] ^ logixTable[i]));
        }
    }

    private int seek(int offset, int seed) {
    	int offsetCast = offset * 997 + 15541;
        int wSeed = 28403 + (seed ^ offsetCast) * 59;
        return unsignedByte((byte)(wSeed % 256));
    }

    public int mappedLogixTableH(int src) {
        return unsignedByte(logixTable[unsignedByte(src) & 31]);
    }

    public byte logix (byte op1, byte op2, byte s) {
        return (byte)(((int)op1) ^ ((int)op2) ^ ((int)mappedLogixTableH(s)));
    }
    
    private int unsignedByte(byte data) {
		if (data >= 0) {
			return data;
		} else {
			return 256 + data;
		}
	}
    
    private int unsignedByte(int data) {
		if (data >= 0) {
			return data;
		} else {
			return 256 + data;
		}
	}
}
