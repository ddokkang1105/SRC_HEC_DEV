<%--------------------------------------------------------------------------------
                              IMPORT / INCLUDE AES JAVASCRIPT
---------------------------------------------------------------------------------%>
<script src="${root}cmm/js/aes/AesUtil.js" type="text/javascript"></script>
<script src="${root}cmm/js/aes/aes.js" type="text/javascript"></script>
<script src="${root}cmm/js/aes/pbkdf2.js" type="text/javascript"></script>
<script type="text/javascript">
var KEYSIZE = 128;
var ITERATIONCOUNT = 10000;
 
var IV = CryptoJS.lib.WordArray.random(128/8).toString(CryptoJS.enc.Hex);
var SALT = CryptoJS.lib.WordArray.random(128/8).toString(CryptoJS.enc.Hex);
var PASSPHARSE = "passPhrase passPhrase aes encoding algorithm";
</script>

