import 'dart:math';

void main() {
  int e = 0, d = 0, n = 0;

  // let's take example values:
  int p = 7, q = 11;
  int plainText = 9;
  int cipherText = 0;
  // find out ciphter text? it should be 37

  // step 1: obtain public key
  (e, n) = generatePublicKey(p, q);
  // show public key: should be 7, 77
  print("public key <e, n> : < $e, $n >");

  int e_copy = e;
  int n_copy = n;
  // step 2: encrypt the text.
  cipherText = encryptText(plainText, e_copy, n_copy);
  // show plaintext and ciphertext: should be 9 and 37
  print("plain text: $plainText, cipherText: $cipherText");

  // step 3: obtain private key
  (d, n) = obtainPrivateKey(p, q, n);
  // show private key <d, n>: should be (43, 77)
  print("private key <d, n>: < $d, $n >");

  // step 4: decrypt cipher text (37) result should be 9.
  plainText = decryptText(cipherText, d, n);
  print("cipher text: $cipherText, plain text: $plainText");
}

// function to generate the public key (e, n)
final primes = [
  2,
  3,
  5,
  7,
  11,
  13,
  17,
  19,
  23,
  29,
  31,
  37,
  41,
  43,
  47,
  53,
  59,
  61,
  67,
  71,
  73,
  79,
  83,
  89,
  97
];

// finding the bezout identity,
// a backwards process of the euclidean algorithm.
// in out case, e * d + phi * y = 1, 1 is the gcd,
// are sure of that, we now need to find d.
// ax + by = 1 becomes ed + phi*y = 1
int bezout(int phiN, int e) {
  int x = 0, y = 1, lastX = 1, lastY = 0;
  // my mediocre implementation :)
  while (e != 0) {
    if (e == 1) {
      //int returnVal = (lastX % phiN + phiN) % phiN;
      //print("when e is 1:");
      //print("e: $e * x: $x + phi: $phiN * y: $y");
      //print("return val: $returnVal");
      //return returnVal;
      return x;
    }
    //print("e: $e * x: $x + phi: $phiN * y: $y");
    int quo = phiN ~/ e;
    int rem = phiN % e;

    phiN = e;
    e = rem;

    int tempX = x;
    x = lastX - quo * x;
    lastX = tempX;

    int tempY = y;
    y = lastY - quo * y;
    lastY = tempY;
  }

  int returnVal = (lastX % phiN + phiN) % phiN;

  //return returnVal;
  return x;
}

// decrypt the code with the private key obtained
// convert cipher text c, into m using private key (d, n)
int decryptText(int cipherText, int d, int n) {
  return powMod(cipherText, d, n);
}

// generate cipher text from plain text m, using public key (e, n)
int encryptText(int plainText, int e, int n) {
  // C = m ^ e mod n,
  // here C is cipherText, m is plainText
  int power = pow(plainText, e) as int;
  print("$plainText ^ $e % $n");
  int cipherText = power % n;
  return cipherText;
}

// we use this recursive method to find gcd of the two numbers,
// using the euclidean algorithm.
int findGcd(int phiN, int e) {
  int rem = phiN % e;
  if (rem == 0) {
    return e;
  }
  return findGcd(e, rem);
}

(int, int) generatePublicKey(int p, int q) {
  int n = p * q;
  int phi = (p - 1) * (q - 1);

  for (int i = 0; i < primes.length; i++) {
    if (findGcd(phi, primes[i]) == 1) {
      return (primes[i], n);
    }
  }

  throw Exception('Unable to find a suitable public key exponent e');
}

// function to generate private key (d, n)
(int, int) obtainPrivateKey(int p, int q, int e) {
  int phi = (p - 1) * (q - 1);
  // use bezout's algorithm, find numbers x and y
  // such that e * x + phi * y = 1
  // now, we can substiture x with d, so that
  // e * d + phi * y = 1
  // let's pass it on to the bezout function to obtain x.
  // since y is not our concern here.
  int d = bezout(phi, e);

  return (d, p * q);
}

int powMod(int base, int exponent, int modulus) {
  int result = 1;
  base = base % modulus;
  while (exponent > 0) {
    if (exponent % 2 == 1) {
      result = (result * base) % modulus;
    }
    exponent = exponent ~/ 2;
    base = (base * base) % modulus;
  }
  return result;
}
