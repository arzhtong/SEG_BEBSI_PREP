import 'package:flutter_test/flutter_test.dart';
import 'package:prep/utils/message_crypto.dart';
import 'package:prep/utils/query.dart';

void main() {
  testDecryptGivenMessage(String msgEncrypted, String msgUnencrypted) {
    String msgDecrypted = MessageCrypto.decryptMessage(msgEncrypted);
    expect(msgDecrypted, msgUnencrypted);
  }

  testCryptoEqual(String msgUnencrypted) {
    String msgEncrypted = MessageCrypto.encryptMessage(msgUnencrypted);
    testDecryptGivenMessage(msgEncrypted, msgUnencrypted);
  }

  setUp(() => Queries.setAppointmentInfo("ach9s8abt", null, null));

  group('Given message can be encrypted, and decrypted back to original:', () {
    const List<String> messages = [
      'This is the first message.',
      'This is the second message.',
      'This is the third message.',
    ];

    for (String message in messages)
      test('Test ' + (1 + messages.indexOf(message)).toString(),
          () => testCryptoEqual(message));
  });

  group('Given encrypted message can be decrypted:', () {
    const List<List<String>> messagePairs = [
      [
        '6873939c6801e72df333d1a281a95c1b0b16e1872cc728bda281c54d04262c51dbbd320064e035a445683c61246f5275',
        'This is the first message.'
      ],
      [
        '16023ca6c55809c2dc4ca01aba5daa795a4f7b6dd652f9c4aaa9494cee589f5a6d5c5161a0c1be796be29f077d2c60ea',
        'This is the second message.'
      ],
      [
        'a976dfcb74f7df592eddbfb1a90df7e84ca8e222513f5a73f201f91176146e9aeb7c8b4ccf8c72641ae61a3e1c762008',
        'This is the third message.'
      ],
    ];

    for (List<String> messagePair in messagePairs)
      test('Test ' + (1 + messagePairs.indexOf(messagePair)).toString(),
          () => testDecryptGivenMessage(messagePair[0], messagePair[1]));
  });

  tearDown(() => Queries.setAppointmentInfo(null, null, null));
}
