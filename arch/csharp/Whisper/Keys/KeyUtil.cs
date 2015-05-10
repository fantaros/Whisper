using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace io.github.fantaros.Whisper.Keys
{
    public class KeyUtil
    {
        public static IKeys generator() {
            return new Keys();
        }
    }
}
