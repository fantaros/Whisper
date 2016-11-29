package io.github.fantaros.cipher.basement;

public class WhisperBlock {
    private Logix logix;
    private byte[] valuearray;

    public byte get(int offset) throws IllegalArgumentException {
        if (offset < 4) {
        	return valuearray[offset];
        } else {
        	throw new IllegalArgumentException("block get offset > 4");
        }
    }

    public void set(int offset, byte value) throws IllegalArgumentException {
        if (offset < 4)
            valuearray[offset] = value;
        else
            throw new IllegalArgumentException("block set offset > 4");
    }


    public WhisperBlock() {
        valuearray = new byte[]{
            0,0,0,0
        };
        logix = new Logix();
    }

    public void setValue(byte[] input, int offset) {
        for (int i = 0; i < 4; i++) {
            if (offset + i < input.length) {
            	valuearray[i] = input[offset + i];
            }
            else {
            	valuearray[i] = 0;
            }
        }
    }

    public WhisperBlock(byte a0, byte a1, byte a2, byte a3) {
        valuearray = new byte[4];
        valuearray[0] = a0;
        valuearray[1] = a1;
        valuearray[2] = a2;
        valuearray[3] = a3;
    }

    private byte[] newarray;

    public void blockSwap(byte swaper) {
        newarray = new byte[4];
        newarray[0] = valuearray[(byte) ((swaper & 0xc0) >>> 6)];
        newarray[1] = valuearray[(byte) ((swaper & 0x30) >>> 4)];
        newarray[2] = valuearray[(byte) ((swaper & 0x0c) >>> 2)];
        newarray[3] = valuearray[swaper & 0x03];
        valuearray = newarray;
    }

    public void deBlockSwap(byte swaper) {
        newarray = new byte[4];
        newarray[(byte) ((swaper & 0xc0) >>> 6)] = valuearray[0];
        newarray[(byte) ((swaper & 0x30) >>> 4)] = valuearray[1];
        newarray[(byte) ((swaper & 0x0c) >>> 2)] = valuearray[2];
        newarray[swaper & 0x03] = valuearray[3];
        valuearray = newarray;
    }

//    private void swap(int f, int t) {
//        valuearray[f] = (byte) (valuearray[f] ^ valuearray[t]);
//        valuearray[t] = (byte) (valuearray[f] ^ valuearray[t]);
//        valuearray[f] = (byte) (valuearray[f] ^ valuearray[t]);
//    }

    public void accept(byte[] output, int offset) {
        for (int i = 0; i < 4; i++) {
            if (offset + i < output.length) {
                output[offset + i] = valuearray[i];
            }
        }
    }

    public void whisping(int offset, byte function, byte keys) {
        valuearray[offset] = logix.logix(valuearray[offset], function, keys);
    }

    public String toString() {
        StringBuilder ret = new StringBuilder();
        for (byte num : valuearray) {
            ret.append(num);
        }
        ret.append("\r\n");
        return ret.toString();
    }
}
