using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace io.github.fantaros.Whisper.Base
{
    /// <summary>
    /// WHipser Block
    /// </summary>
    public sealed class WhisperBlock
    {
        private Logix logix;
        private byte[] valuearray;

        internal byte this[int offset]
        {
            get
            {
                if (offset < 4) 
                {
                    return valuearray[offset];
                }
                else
                {
                    throw new WhisperException("offset is too big");
                }
            }
            set
            {
                if (offset < 4)
                {
                    valuearray[offset] = value;
                }
                else
                {
                    throw new WhisperException("offset is too big");
                }
            }
        }

        public WhisperBlock() :
            this(0, 0, 0, 0)
        {
            //valuearray = new byte[]{
            //    0,0,0,0
            //};
        }

        public void SetValue(byte[] input, int offset)
        {
            for (int i = 0; i < 4; i++)
            {
                if (offset + i < input.Length)
                {
                    valuearray[i] = input[offset + i];
                }
                else
                {
                    valuearray[i] = 0;
                }
            }
        }

        public WhisperBlock(byte a0, byte a1, byte a2, byte a3)
        {
            valuearray = new byte[4];
            valuearray[0] = a0;
            valuearray[1] = a1;
            valuearray[2] = a2;
            valuearray[3] = a3;
            logix = new Logix();
        }

        public WhisperBlock(byte[] a, int offset)
        {
            valuearray = new byte[4];
            for (int i = 0; i < 4; i++)
            {
                if (offset + i < a.Length)
                {
                    valuearray[i] = a[offset + i];
                }
                else
                {
                    valuearray[i] = 0;
                }
            }
            logix = new Logix();
        }
        private byte[] newarray;
        public void BlockSwap(byte swaper)
        {
            newarray = new byte[4];
            newarray[0] = valuearray[(byte)((swaper & 0xc0) >> 6)];
            newarray[1] = valuearray[(byte)((swaper & 0x30) >> 4)];
            newarray[2] = valuearray[(byte)((swaper & 0x0c) >> 2)];
            newarray[3] = valuearray[swaper & 0x03];
            valuearray = newarray;
        }

        public void DeBlockSwap(byte swaper)
        {
            newarray = new byte[4];
            newarray[(byte)((swaper & 0xc0) >> 6)] = valuearray[0];
            newarray[(byte)((swaper & 0x30) >> 4)] = valuearray[1];
            newarray[(byte)((swaper & 0x0c) >> 2)] = valuearray[2];
            newarray[swaper & 0x03] = valuearray[3];
            valuearray = newarray;
        }

        private void Swap(int f, int t)
        {
            valuearray[f] = (byte)(valuearray[f] ^ valuearray[t]);
            valuearray[t] = (byte)(valuearray[f] ^ valuearray[t]);
            valuearray[f] = (byte)(valuearray[f] ^ valuearray[t]);
        }

        public void Accept(byte[] output, int offset)
        {
            for (int i = 0; i < 4; i++)
            {
                if (offset + i < output.Length)
                {
                    output[offset + i] = valuearray[i];
                }
            }
        }

        public void Whisping(int offset, byte function, byte keys)
        {
            valuearray[offset] = logix.logix(valuearray[offset], keys, function);
        }

        public override string ToString()
        {
            StringBuilder ret = new StringBuilder();
            foreach (byte num in valuearray)
            {
                ret.Append(string.Format("{0:X}", num));
            }
            ret.Append("\r\n");
            return ret.ToString();
        }

    }
}
