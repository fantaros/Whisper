using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace io.github.fantaros.Whisper.Keys
{
    public class DefaultKey : IKey
    {
        public byte[] GenerateKey(string password, params object[] paramArray)
        {
            if (string.IsNullOrWhiteSpace(password))
            {
                return Encoding.Unicode.GetBytes("default");
            }
            else
            {
                return Encoding.Unicode.GetBytes(password);
            }
        }
    }
}
