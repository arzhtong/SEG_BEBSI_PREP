import 'package:flutter_test/flutter_test.dart';
import 'package:prep/utils/message_crypto.dart';
import 'package:prep/utils/query.dart';

void main() {
  _testCryptoEqual(String msgUnencrypted) {
    String msgEncrypted = MessageCrypto.encryptMessage(msgUnencrypted);
    String msgDecrypted = MessageCrypto.decryptMessage(msgEncrypted);
    expect(msgDecrypted, msgUnencrypted);
  }

  setUp(() => Queries.setAppointmentInfo("ach9s8abt", null, null));

  group('Decrypted message should be the same as the unencrypted message:', () {
    test('first test', () => _testCryptoEqual("This is the first message."));
    test('second test', () => _testCryptoEqual("This is the second message."));
    test('third test', () => _testCryptoEqual("This is the third message."));
  });

  tearDown(() => Queries.setAppointmentInfo(null, null, null));
}
