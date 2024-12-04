import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var textController = TextEditingController();
  String? encryptedText;
  String? decryptedText;

  // AES Encryption Key and IV
  final initVector = encrypt.IV.fromLength(16);
  final encrypter =
  encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8('16characterslong')));

  //encryption
  void convertToEncryptedText() {
    final plainText = textController.text;
    if (plainText.isNotEmpty) {
      final encrypted = encrypter.encrypt(plainText, iv: initVector);

      setState(() {
        // encryptedText = encrypted.base64;
        encryptedText = encrypted.base64;
        decryptedText = null; // Reset decrypted text on new encryption
      });


    }
  }


//decryption
  void convertToDecryptedText() {
    if (encryptedText != null) {
      final encryptedData = encrypt.Encrypted.fromBase64(encryptedText!);
      final decrypted = encrypter.decrypt(encryptedData, iv: initVector);

      setState(() {
        decryptedText = decrypted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Encryption",style: TextStyle(
            color: Colors.white
        ),),
      ),

      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Text',
              ),
            ),
          ),
          const SizedBox(height: 20),



          //button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            onPressed: ()
            {

              //call to function
              convertToEncryptedText();
            },
            child: const Text(
              'Encrypt',
              style: TextStyle(color: Colors.black),
            ),
          ),




          //encrypted text
          if (encryptedText != null) ...[
            const SizedBox(height: 20),
            const Text(
              'Encrypted Text:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(encryptedText!),
          ],


          const SizedBox(height: 20),


          //button
          if (encryptedText != null) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
              onPressed: convertToDecryptedText,
              child: const Text(
                'Decrypt',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],


          //decrypted text
          if (decryptedText != null) ...[
            const SizedBox(height: 20),
            const Text(
              'Decrypted Text:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(decryptedText!),
          ],



        ],
      ),

    );
  }
}
