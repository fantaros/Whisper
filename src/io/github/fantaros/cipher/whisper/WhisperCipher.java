package io.github.fantaros.cipher.whisper;

import java.util.Map;

import io.github.fantaros.cipher.base.Cipher;
import io.github.fantaros.cipher.base.CipherResult;

public class WhisperCipher implements Cipher {

    private WhisperBlock con;

	public String getChipherName() {
		return "whisper";
	}

	public String getExtName() {
		return "wsp";
	}

	public CipherResult execute(Map<String, Object> params) {

        return null;

	}

}
