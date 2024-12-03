## RSA Encryption in Dart

A (very) simple implementation of the RSA encryption algorithm in Dart. RSA is a widely used public-key cryptography algorithm that allows secure communication over an insecure channel.

### How it Works

There are several steps shown in this code in order to perform the RSA algorithm:

- **Generate Public Key**: The public key is generated using two prime numbers, `p` and `q`. The public key consists of the exponent `e` and the modulus `n`.
  - `generatePublicKey(p, q)`
- **Encrypt Text**: The plaintext is encrypted using the public key, resulting in the ciphertext.
  - `encryptText(plainText, e, n)`
- **Generate Private Key**: The private key is generated using the same prime numbers `p` and `q`, and the public key exponent `e`. The private key consists of the exponent `d` and the modulus `n`.
  - `obtainPrivateKey(p, q, e)`
- **Decrypt Text**: The ciphertext is decrypted using the private key, resulting in the original plaintext.
  - `decryptText(cipherText, d, n)`

The program uses two vital mathematical functions:

- **`findGcd(phiN, e)`**: Finds the greatest common divisor (gcd) of two numbers using the Euclidean algorithm.
- **`bezout(phiN, e)`**: Implements the Bézout's identity algorithm to find the private key exponent `d`. It is the reverse process of Euclid's algorithm, i.e., the `findGcd` function.

### Usage

The `main()` function demonstrates the usage of the RSA algorithm by:

- Generating the public key (`e`, `n`).
- Encrypting a plainText using the public key.
- Generating the private key (`d`, `n`).
- Decrypting the cipherText using the private key.

The example values used in the `main()` function are:

```
public key <e, n> : < 7, 77 >
9 ^ 7 % 77
plain text: 9, cipherText: 37
private key <d, n>: < 9, 77 >
cipher text: 37, plain text: 9
```
