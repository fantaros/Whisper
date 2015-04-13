using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace io.github.fantaros.Whisper.Keys
{
    public interface IKeys
    {
        /// <summary>
        /// generate the key.
        /// </summary>
        /// <param name="inputs"> input password as bytes </param>
        /// <returns></returns>
        byte[] GenerateKey(byte[] inputs);

        /// <summary>
        /// generate the key.
        /// </summary>
        /// <param name="inputs"> input password </param>
        /// <returns></returns>
        byte[] GenerateKey(string inputs);
    }
}
