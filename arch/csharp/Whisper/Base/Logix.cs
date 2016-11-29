using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace io.github.fantaros.Whisper.Base
{
    /// <summary>
    /// Logix class
    /// </summary>
    public class Logix
    {
        //some magic codes
        private const int __OFFSETMAGICCHANT__ = 0x03E5;
        private const int __OFFSETMAGICCAST__ = 0x3CB5;
        private const int __SEEDMAGICCHANT__ = 0x003B;
        private const int __SEEDMAGICCAST__ = 0x6EF3;

        //the table
        private byte[] logixTable;

        public Logix()
        {
            init(198848);
        }

        public Logix(int seed)
        {
            init(seed);
        }

        public void init(int seed)
        {
            logixTable = new byte[256];
            int i;
            for (i = 0; i < 256; ++i)
            {
                logixTable[i] = (byte)i;
            }
            for (i = 0; i < 32; ++i)
            {
                logixTable[i] = (byte)(logixTable[seek(i, seed)] ^ logixTable[i]);
                logixTable[seek(i, seed)] = (byte)(logixTable[seek(i, seed)] ^ logixTable[i]);
                logixTable[i] = (byte)(logixTable[seek(i, seed)] ^ logixTable[i]);
            }
        }

        private int seek(int offset, int seed)
        {
            return (byte)((__SEEDMAGICCAST__ + (seed ^ (offset * __OFFSETMAGICCHANT__ + __OFFSETMAGICCAST__)) * __SEEDMAGICCHANT__) % 256);
        }

        public byte mappedLogixTableH(int src)
        {
            return logixTable[(byte)src & 31];
        }

        public byte logix(byte op1, byte op2, byte s)
        {
            return (byte)(op1 ^ op2 ^ mappedLogixTableH(s));
        }
    }
        
}
