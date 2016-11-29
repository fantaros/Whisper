package io.github.fantaros.cipher.basement;

/**
 * Created by fantaros on 2014/5/24.
 */
public class Logix {
    private byte[] logixTable;

    public Logix() {
        init(199848);
    }

    public Logix(int seed) {
        init(seed);
    }

    public void init (int seed) {
        logixTable = new byte[256];
        int i;
        for (i = 0; i < 256; ++i) {
            logixTable[i] = (byte)i;
        }
        for (i = 0; i < 32; ++i) {
            logixTable[i] = (byte)(logixTable[seek(i,seed)] ^ logixTable[i]);
            logixTable[seek(i, seed)] = (byte)(logixTable[seek(i, seed)] ^ logixTable[i]);
            logixTable[i] = (byte)(logixTable[seek(i, seed)] ^ logixTable[i]);
        }
    }

    private int seek(int offset, int seed) {
        return unsignedByte((byte)((28403 + (seed ^ (offset * 997 + 15541)) * 59) % 256));
    }

    public byte mappedLogixTableH(int src) {
        return logixTable[src & 31];
    }

    public byte logix (byte op1, byte op2, byte s) {
        return (byte)(op1 ^ op2 ^ mappedLogixTableH(unsignedByte(s)));
    }
    
    private int unsignedByte(byte data) {
		if (data >= 0) {
			return data;
		} else {
			return 256 + data;
		}
	}
}
