using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace io.github.fantaros.Whisper.Keys
{
    public class Keys : IKeys
    {

        #region WhisperTable(64)
        private const byte[] WHISPERTABLE ={
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

        private const byte[] MAGIC ={
                    27,30,39,45,54,57,
                    75,78,99,108,114,120,
                    135,141,147,156,177,180,
                    198,201,210,216,225,228
        };
        #endregion

        public byte[] GenerateKey(byte[] inputs)
        {
            throw new NotImplementedException();
        }


        public byte[] GenerateKey(string inputs)
        {
            throw new NotImplementedException();
        }
    }
}
