package io.github.fantaros.cipher.basement;

import java.util.ArrayList;
import java.util.List;

import io.github.fantaros.cipher.data.WhisperKey;

public class WhisperBlock {
    private Logix logix;
    private byte[] valuearray;
    private int blockSize;

    public byte get(int offset) throws IllegalArgumentException {
        if (offset < this.blockSize) {
        	return valuearray[offset];
        } else {
        	throw new IllegalArgumentException("block get offset > blockSize");
        }
    }

    public void set(int offset, byte value) throws IllegalArgumentException {
        if (offset < this.blockSize)
            valuearray[offset] = value;
        else
            throw new IllegalArgumentException("block set offset > blockSize");
    }


//    private WhisperBlock() {
//    	this.blockSize = 3;
//        valuearray = new byte[]{
//            0,0,0
//        };
//        logix = new Logix();
//    }
    
    public WhisperBlock(int blockSize) {
    	this.blockSize = blockSize;
    	this.valuearray = new byte[this.blockSize];
    	logix = new Logix();
    }

    public void refreshData(byte[] input, int offset) {
        for (int i = 0; i < this.blockSize; i++) {
            if (offset + i < input.length) {
            	valuearray[i] = input[offset + i];
            }
            else {
            	valuearray[i] = 0;
            }
        }
    }
    
    public static int unsignedByte(int data) {
		if (data >= 0) {
			return data;
		} else {
			return 256 + data;
		}
	}
    
    public void blockSwapWithKey(WhisperKey key, byte swaper) {
        List<Integer> swapList = key.buildSwapArray(this.blockSize, unsignedByte(swaper));
        byte tmp;
        int location = 0;
        for (int o = 0; o < swapList.size(); ++o) {
        	int offset = swapList.get(o)==null?-1:swapList.get(o);
        	if (offset >= 0) {
        		tmp = this.valuearray[location];
        		this.valuearray[location] = this.valuearray[offset];
        		this.valuearray[offset] = tmp;
        	}
        	++location;
        }
    }
    
    private List<Integer> reverseSwapArray(List<Integer> swapList) {
        if (swapList == null) {
            return null;
        }
        List<Integer> anti = new ArrayList<Integer>(swapList);
        int start = 0, end = swapList.size() - 1;
        while (start < end) {
        	int tmp = anti.get(start);
        	anti.set(start, anti.get(end));
        	anti.set(end, tmp);
        	
        	++start;
        	--end;
        }
        return anti;
    }

    public void deBlockSwapWithKey(WhisperKey key, byte swaper) {
        List<Integer> swapList = this.reverseSwapArray(key.buildSwapArray(this.blockSize, unsignedByte(swaper)));
        byte tmp;
        int location = swapList.size() - 1;
        for (int o = 0; (o < swapList.size() && location >= 0); ++o) {
        	int offset = swapList.get(o) == null ? -1 : swapList.get(o);
        	if (offset >= 0) {
        		tmp = this.valuearray[location];
        		this.valuearray[location] = this.valuearray[offset];
        		this.valuearray[offset] = tmp;
        	}
        	--location;
        }
    }


    public void accept(byte[] output, int offset) {
        for (int i = 0; i < this.blockSize; i++) {
            if (offset + i < output.length) {
                output[offset + i] = valuearray[i];
            }
        }
    }

    public void whisping(int offset, byte keys, byte function) {
        valuearray[offset] = logix.logix(valuearray[offset], keys, function);
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
