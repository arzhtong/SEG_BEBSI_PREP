var aesjs = require("aes-js");
var pbkdf2 = require("pbkdf2");
var key_array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
var iv = [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36];

function encryptMessage(message) {
  var text = message;
  var textBytes = aesjs.utils.utf8.toBytes(text);
  var aesCbc = new aesjs.ModeOfOperation.cbc(key_array, iv);
  var encryptedBytes = aesCbc.encrypt(aesjs.padding.pkcs7.pad(textBytes));
  var encryptedHex = aesjs.utils.hex.fromBytes(encryptedBytes);
  return encryptedHex;
}

function generateKey(key) {
  return pbkdf2.pbkdf2Sync(key, "salt", 1, 256 / 8, "sha512");
}

function decryptMessage(encryptedHex, key) {
  var encryptedBytes = aesjs.utils.hex.toBytes(encryptedHex);
  var aesCbc = new aesjs.ModeOfOperation.cbc(key_array, iv);
  var decryptedBytes = aesCbc.decrypt(aesjs.padding.pkcs7.strip(encryptedBytes));
  var decryptedText = aesjs.utils.utf8.fromBytes(decryptedBytes);
  return decryptedText.toString()
}

export { encryptMessage, decryptMessage, generateKey };
