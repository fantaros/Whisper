using System;
using System.Collections.Generic;
using System.Text;

using fantaros.Model;
using fantaros.Security.SCRC;
using fantaros.Security.Base;

namespace fantaros.Security.Whisper
{
    public class WhisperParam : fantaros.Security.IParam
    {

        #region WhisperTable(64)

        private static byte[] WhisperTable ={
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

        private static byte[] Magic ={
                    27,30,39,45,54,57,
                    75,78,99,108,114,120,
                    135,141,147,156,177,180,
                    198,201,210,216,225,228
        };
        #endregion
        protected byte[] m_key;
        protected byte[] m_ring;
        protected int m_seed;
        private IHash hasher;

        public byte[] Key
        {
            get { return m_key; }
        }

        public byte[] Ring
        {
            get { return m_ring; }
        }

        public int Seed
        {
            get { return m_seed; }
        }

        /// <summary>
        /// 初始化密钥
        /// </summary>
        /// <param name="param">用户口令</param>
        public WhisperParam(string param)
        {
            m_key = new byte[128];
            m_ring = new byte[64];
            hasher = new SCRC32();
            Param(param);
        }

        public WhisperParam()
        {
            m_key = new byte[128];
            m_ring = new byte[64];
            hasher = new SCRC32();
            Param(null);
        }

        public virtual bool Param(string param)
        {
            try
            {
                if (!string.IsNullOrEmpty(param))
                {
                    GeneratePWD(param);
                    GenerateRing();
                    return true;
                }
                else
                {
                    int mac, os, ver;
                    hasher.Reset();
                    hasher.Update(Encoding.Default.GetBytes(Environment.MachineName));
                    mac = (int)hasher.Value;
                    hasher.Update(Encoding.Default.GetBytes(Environment.OSVersion.Platform.ToString()));
                    os = (int)hasher.Value;
                    hasher.Update(Encoding.Default.GetBytes(Environment.Version.ToString()));
                    ver = (int)hasher.Value;
                    hasher.Reset();
                    GeneratePWD(string.Format("☾{0}⊱{1:X}⋛{2:X}⊹{3}⋚{4}⊰{5:X}☽", Environment.MachineName, ver, mac, Environment.OSVersion.Platform,
                        Environment.Version, os));
                    GenerateRing();
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }

        internal virtual void GeneratePWD(string pwd)
        {
            int i;
            IList<byte> temp = new List<byte>();
            byte[] tmp;
            tmp = System.Text.Encoding.Default.GetBytes(pwd);
            hasher.Reset();
            hasher.Update(tmp);
            foreach (byte b in tmp)
            {
                temp.Add(b);
            }
            tmp = BitConverter.GetBytes(hasher.Value);
            foreach(byte b in tmp)
            {
                temp.Add(b);
            }
            for (i = 0; i < 128; i++)
            {
                if (i < temp.Count)
                    m_key[i] = (byte)(temp[i] ^ WhisperTable[temp[i % temp.Count] % 64]);
                else
                {
                    m_key[i] = (byte)((m_key[(i + 1) % temp.Count] & 0xc0 | m_key[(i + 3) % temp.Count] & 0x30 | m_key[i % temp.Count] & 0x0c | m_key[(i + 2) % temp.Count] & 0x03) ^ WhisperTable[temp[i % temp.Count] % 64]);
                }
            }
            hasher.Reset();
            hasher.Update(m_key);
            m_seed = (int)hasher.Value;
            KBox.initkbox(m_seed);
        }

        internal virtual void GenerateRing()
        {
            int i, j;
            for (i = 0; i < m_key.Length - 1; i += 2)
            {
                j = i / 2;
                m_ring[j] = Magic[Reget(m_key[i % 128], m_key[(i + 1) % 128]) % 24];
            }
        }

        private byte Reget(byte a, byte b)
        {
            byte ret = (byte)(a & 0xf0);
            ret = (byte)(ret | (b & 0x0f));
            return ret;
        }

        public byte GetKey(int offset)
        {
            return m_key[offset % 128];
        }

        public virtual byte GetRing(int offset)
        {
            return m_ring[offset % 64];
        }

        public virtual int Regets(byte a, byte b)
        {
            return (int)Reget(a, b);
        }

        public int ParamMaxLength
        {
            get { return -1; }
        }

        public string AlgorithmName
        {
            get { return "WhisperParam"; }
        }

        public bool Parse(string param)
        {
            return Param(param);
        }

        public object this[string attributename]
        {
            get
            {
                return PublicAttributeModelFiller.GetAttribute(this, attributename);
            }
            set
            {
                PublicAttributeModelFiller.SetAttribute(this, attributename, value);
            }
        }

        public object GetAttribute(string attributename)
        {
            return PublicAttributeModelFiller.GetAttribute(this, attributename);
        }

        public void SetAttribute(string attributename, object value)
        {
            PublicAttributeModelFiller.SetAttribute(this, attributename, value);
        }
    }

}
