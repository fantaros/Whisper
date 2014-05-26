package io.github.fantaros.cipher.base;

import java.util.Map;

/**
 * 密码接口.
 * @author 颜禄涵
 *
 */
public interface Cipher {
	/**
	 * 获取算法名称.
	 * @return
	 */
	String getChipherName();
	
	/**
	 * 获取扩展名.
	 * @return
	 */
	String getExtName();
	
	/**
	 * 执行.
	 * @param params
	 * @return
	 */
	CipherResult execute(Map<String, Object> params);
}
