package io.github.fantaros.cipher;

import java.nio.charset.Charset;

import io.github.fantaros.cipher.data.WhisperKey;

/**
 * Created by fantaros on 2014/5/24.
 */
public class Entry {
    public static void main(String[] args){
    	WhisperAlgorithm algorithm = new WhisperAlgorithm();
    	String org = "习近平祝贺古特雷斯出任下届联合国秘书长，强调中国将坚定支持古特雷斯履行好秘书长工作职责。习近平指出，作为最具普遍性、权威性、代表性的政府间国际组织，联合国在应对全球性挑战中作用不可代替。第二次世界大战结束70多年来，世界实现了总体和平、持续发展的态势，联合国对此功不可没。随着国际形势的发展变化，各国对联合国的期待上升，赞成联合国发挥更大作用。联合国应当旗帜鲜明地维护《联合国宪章》宗旨和原则，积极有为维护国际和平与安全，持之以恒推进共同发展，特别是要落实好2030年可持续发展议程和气候变化《巴黎协定》，照顾发展中国家利益，多为发展中国家发声、办事";
    	byte[] orgdata = org.getBytes(Charset.forName("UTF8"));
    	WhisperKey key = WhisperKey.whisperKeyWithPassword("fantasy88");
    	byte[] output = algorithm.encrypto(orgdata, key);
    	System.out.println(output);
    }
}
