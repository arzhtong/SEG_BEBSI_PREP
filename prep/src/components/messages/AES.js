const aes = require("aes-js");
const crypto = require("crypto");
const md5 = require('md5');

function encryptMessage(message, id) {
  var iv_array = generateIV();
  var hexIv = md5(iv_array)
  var key_array = aes.utils.utf8.toBytes((generateKey(id + hexIv)));
  var textBytes = aes.utils.utf8.toBytes(message);
  var aesCbc = new aes.ModeOfOperation.cbc(key_array, iv_array);
  var encryptedBytes = aesCbc.encrypt(aes.padding.pkcs7.pad(textBytes));
  var hex = aes.utils.hex.fromBytes(encryptedBytes);
  var encryptedHex = aes.utils.hex.fromBytes(iv_array) + hex;
  return encryptedHex;
}

function generateKey(key) {
  const hmac = crypto.createHmac('sha512', md5(key));
  var digest = hmac.digest('hex')
  return digest.substring(0, 32)
}

function generateIV() {
  return crypto.randomBytes(16);
}

function getIV(encryptedHex) {
  return encryptedHex.substring(0, 32);
}


function decryptMessage(encryptedHex, id) {
  var hexIv = getIV(encryptedHex)
  var md5IV = md5(Array.from(aes.utils.hex.toBytes(hexIv)))
  var key_array = aes.utils.utf8.toBytes(generateKey(id + md5IV));
  var message = encryptedHex.substring(32);
  var decryptIV = aes.utils.hex.toBytes(hexIv);
  var encryptedBytes = aes.utils.hex.toBytes(message);
  var aesCbc = new aes.ModeOfOperation.cbc(key_array, decryptIV);
  var decryptedBytes = aesCbc.decrypt(encryptedBytes);
  var decryptedText = aes.utils.utf8.fromBytes(
    aes.padding.pkcs7.strip(decryptedBytes)
  );
  return decryptedText;
}

export { encryptMessage, decryptMessage, generateKey };
