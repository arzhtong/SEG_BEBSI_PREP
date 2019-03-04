var aes = require("aes-js");
const crypto = require("crypto");

function encryptMessage(message, id, date) {
  var currentEpoch = date
  var key_array = aes.utils.utf8.toBytes(generateKey(id + currentEpoch));
  var iv_array = generateIV();
  var textBytes = aes.utils.utf8.toBytes(message);
  //alert(textBytes.length)
  var aesCbc = new aes.ModeOfOperation.cbc(key_array, iv_array);
  var encryptedBytes = aesCbc.encrypt(aes.padding.pkcs7.pad(textBytes));
  //alert(encryptedBytes.length)
  var hex = aes.utils.hex.fromBytes(encryptedBytes);
  var encryptedHex = aes.utils.hex.fromBytes(iv_array) + hex;
  return encryptedHex;
}

function generateKey(key) {
  var newKey = aes.utils.utf8.toBytes(key)
  const hmac = crypto.createHmac('sha512', aes.utils.hex.fromBytes(newKey));
  var digest = hmac.digest('hex')
  return digest.substring(0, 32)
}

function generateIV() {
  return crypto.randomBytes(16);
}

function getIV(encryptedHex) {
  return encryptedHex.substring(0, 32);
}


function decryptMessage(encryptedHex, id, date) {
  var currentEpoch = date
  var key_array = aes.utils.utf8.toBytes(generateKey(id + currentEpoch));
  var message = encryptedHex.substring(32);
  var decryptIV = aes.utils.hex.toBytes(getIV(encryptedHex));
  var encryptedBytes = aes.utils.hex.toBytes(message);
  var aesCbc = new aes.ModeOfOperation.cbc(key_array, decryptIV);
  var decryptedBytes = aesCbc.decrypt(encryptedBytes);
  var decryptedText = aes.utils.utf8.fromBytes(
    aes.padding.pkcs7.strip(decryptedBytes)
  );
  return decryptedText;
}

export { encryptMessage, decryptMessage, generateKey };
