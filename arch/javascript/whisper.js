//whisper - fantaros
window.Whisper = (function AppDomain($){
    var WhisperTable = [
        
    ];
    function ucs2ValueArray(str) {
        var ucs2Array = [], len = str.length, i;
        for(i = 0; i < len; ++i) {
            ucs2Array.push(str.charCodeAt(i));
        }
        return ucs2Array;
    }

    function ucs2ArrayToByteArray(ucs2Array) {
        var byteArray = [], len = ucs2Array.length, i, ucs2Code, usc2h, usc2l;
        for(i = 0; i < len; ++i) {
            ucs2Code = ucs2Array[i];
            ucs2h = (ucs2Code & 0xff00) >> 8;
            ucs2l = (ucs2Code & 0x00ff);
            byteArray.push(ucs2h);
            byteArray.push(ucs2l);
        }
        return byteArray;
    }

    function stringGetBytes(str) {
        var ucs2Array = ucs2ValueArray(str);
        return ucs2ArrayToByteArray(ucs2Array);
    }

	$.WhisperKey = function (password, keyLength) {
		var whisperStoredKey = [];

        if(typeof password === "string") {
            var pwd = password, keylen = keyLength, passwordBytes = stringGetBytes(password);
            return {
                getKey : function getKey (index) {
			
				},
                getRing : function getRing (index) {

				}
            };
        }
        return {
            getKey : function (index) {
                    
            },
            getRing : function (index) {

            }
        };
    };
    return $;
})(window.Whisper || function WhisperHost(){

});