import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:hex/hex.dart';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';

//TODO: remove appointmentCode and read from file when merging with develop
const String appointmentID = "2vqqyqcc7";

class MessageCrypto {
  static const MessageCrypto _singleton = MessageCrypto._internal();

  factory MessageCrypto() => _singleton;

  const MessageCrypto._internal();

  String encryptMessage(String message, int millisSinceEpoch) {
    Random rand = Random.secure();
    int ivArrayLength = 16;
    Uint8List iv = Uint8List(ivArrayLength);
    for (int i = 0; i < ivArrayLength; ++i) {
      iv[i] = rand.nextInt(256);
    }

    String encodedIV = HEX.encode(iv);
    PaddedBlockCipher cipher = getCipher(true, iv, millisSinceEpoch);

    String encodedMessage =
        HEX.encode(cipher.process(utf8.encode(message)));
    String encodedText = encodedIV + encodedMessage;
    return encodedText;
  }

  String decryptMessage(String message, int millisSinceEpoch) {
    String encodedIV = message.substring(0, 32);
    Uint8List iv = HEX.decode(encodedIV);
    PaddedBlockCipher cipher = getCipher(false, iv, millisSinceEpoch);

    String encodedMessage = message.substring(32);
    String decodedMessage =
        utf8.decode(cipher.process(HEX.decode(encodedMessage)));
    return decodedMessage;
  }

  PaddedBlockCipher getCipher(bool mode, Uint8List iv, int millisSinceEpoch) {
    const appointmentCode = "2vqqyqcc7";
    String millisStr = millisSinceEpoch.toString();
    String keyToEncode =
        appointmentCode + millisStr.substring(millisStr.length - 7);

    String keyEncoded = HEX.encode(utf8.encode(keyToEncode));
    List<int> keyEncodedList = utf8.encode(keyEncoded);

    Mac mac = new Mac("SHA-512/HMAC");
    mac.init(KeyParameter(keyEncodedList));
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