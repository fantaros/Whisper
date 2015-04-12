using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace io.github.fantaros.Whisper.Base
{
    public class WhisperException : Exception
    {
        public WhisperException(String msg) : base(msg) {}
    }
}
