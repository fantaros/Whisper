using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace io.github.fantaros.Whisper.Keys
{
    public interface IKey
    {
        byte[] GenerateKey(string password, params object[] paramArray);
    }
}
