import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:hex/hex.dart';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';

class MessageCrypto {
  static String _appointmentID;

  static const MessageCrypto _singleton = MessageCrypto._internal();

  factory MessageCrypto() => _singleton;

  const MessageCrypto._internal();

  static void setAppointmentID(String appointmentID) {
    _appointmentID = appointmentID;
  }

  static String encryptMessage(String message) {
    Random rand = Random.secure();
    int ivArrayLength = 16;
    Uint8List iv = Uint8List(ivArrayLength);
    for (int i = 0; i < ivArrayLength; ++i) {
      iv[i] = rand.nextInt(256);
    }

    PaddedBlockCipher cipher = getCipher(true, iv);
    String encodedText =
        HEX.encode(iv) + HEX.encode(cipher.process(utf8.encode(message)));
    return encodedText;
  }

  static String decryptMessage(String message) {
    String encodedIV = message.substring(0, 32);
    Uint8List iv = HEX.decode(encodedIV);

    PaddedBlockCipher cipher = getCipher(false, iv);
    String encodedMessage = message.substring(32);
    String decodedMessage =
        utf8.decode(cipher.process(HEX.decode(encodedMessage)));
    return decodedMessage;
  }

  static PaddedBlockCipher getCipher(bool mode, Uint8List iv) {
    Digest md5 = Digest("MD5");
    String hexEncryptedIV = HEX.encode(md5.process(iv));
    Uint8List keyArray = utf8.encode(_appointmentID + hexEncryptedIV);
    String hexEncryptedKey = HEX.encode(md5.process(keyArray));
    Uint8List encryptedKeyArray = utf8.encode(hexEncryptedKey);

    Mac mac = new Mac("SHA-512/HMAC");
    mac.init(KeyParameter(encryptedKeyArray));
    String keyHash = HEX.encode(mac.process(Uint8List(0))).substring(0, 32);
    Uint8List keyHashList = utf8.encode(keyHash);

    PaddedBlockCipher cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESFastEngine()),
    );

    cipher.init(
      mode ? true : false,
      PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
        ParametersWithIV<KeyParameter>(KeyParameter(keyHashList), iv),
        null,
      ),
    );
    return cipher;
  }
}
