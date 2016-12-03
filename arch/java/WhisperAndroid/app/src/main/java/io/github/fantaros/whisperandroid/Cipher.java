package io.github.fantaros.whisperandroid;

import android.util.Base64;
import android.util.StringBuilderPrinter;

import java.nio.charset.Charset;

import io.github.fantaros.cipher.WhisperAlgorithm;
import io.github.fantaros.cipher.data.WhisperKey;

/**
 * Created by fantaros on 2016/12/1.
 */

public class Cipher {

    public static String encryptoToBase64 (String msg, String password) {
        byte[] msgBytes = msg.getBytes(Charset.forName("UTF8"));
        WhisperKey key = WhisperKey.whisperKeyWithPassword(password);
        byte[] result = WhisperAlgorithm.encrypto(WhisperAlgorithm.addHeader(msgBytes), key);
        return Base64.encodeToString(result, Base64.URL_SAFE | Base64.NO_WRAP | Base64.NO_PADDING );
    }

    public  static String decryptoFromBase64 (String base64, String password) {
        byte[] base64Bytes = Base64.decode(base64, Base64.URL_SAFE);
        WhisperKey key = WhisperKey.whisperKeyWithPassword(password);
        byte[] result = WhisperAlgorithm.decrypto(base64Bytes, key);
        String res = new String(result);
        return Base64.encodeToString(result, Base64.URL_SAFE | Base64.NO_WRAP | Base64.NO_PADDING );
    }



}
