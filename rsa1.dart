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

  // step 2: encrypt the text.
  cipherText = encryptText(plainText, e, n);
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

//  valuable contribution from Eyouel Melkamu.
/* Using a custom integer only power function with mod support
 I* think the built-in power function has precision issues because it uses floats */
int powr(int num, int exp, int mod) {
  // Base case
  if (exp == 0) {
    return 1;
  }
  // Recursive case: exp is even
  if (exp % 2 == 0) {
    int halfPower = powr(num, exp ~/ 2, mod);
    return (halfPower * halfPower) % mod;
  }
  // Recursive case: exp is odd
  return (num * powr(num, exp - 1, mod)) % mod;
}

// helper function to generate prime numbers up to N.
// uses the "sieve of eratosthenes" algorithm
List<int> sieveOfEratosthenes(int N) {

  // create a list of numbers from 0 to N
  List<int> nonCrosses = List.generate(N+1, (i) => i);

  // mark 0 and 1 as non-prime as they're not prime numbers
  // we do this by making them 0 in the list. 
  // later we filter the list by taking only non-zero values

  nonCrosses[0] = 0; nonCrosses[1] = 0;
  // iterate thru the numbers starting from 2 (the first prime)
  int i = 2;
  while(i <= sqrt(N)) {
    // check if current number 'i' is still marked as prime
    // i.e. check if it's still not turned to 0
    if (nonCrosses[i] != 0) {
      // mark all multiples of i as prime. i.e. make them 0 in this list
      for (int n = i * i; n <= N; n += i) {
        // adding i at each iteration cause multiple of i
        // reason for starting from i * i is because 
        // all the multiples of i less than i * i would have already 
        // been marked as non-prime in the previous iterations of the 
        // for loop.
        nonCrosses[n] = 0;
      }
    }
    // move to the next number
    i++;

  }

  // return list of primes by filtering out the non-primes (the ones we turned to 0)
  return nonCrosses.where((num) => num != 0).toList();
}


// finding the bezout identity,
// a backwards process of the euclidean algorithm.
// in out case, e * d + phi * y = 1, 1 is the gcd,
// we are sure of that, we now need to find d.
// ax + by = 1 becomes ed + phi*y = 1
(int, int) bezout(int a, int b) {
  if (b == 0) {
    return (1, 0);
  }
  int x =0, y = 0;

  (x,y) = bezout(b, a % b);
  return (y,  x - (a ~/ b)  *  y);
}

// decrypt the code with the private key obtained
// convert cipher text c, into m using private key (d, n)
int decryptText(int cipherText, int d, int n) {
  //return pow(cipherText, d).toInt() % n;

  return powr(cipherText, d, n);
}

// generate cipher text from plain text m, using public key (e, n)
int encryptText(int plainText, int e, int n) {
  // C = m ^ e mod n,
  // here C is cipherText, m is plainText
  //int power = pow(plainText, e) as int;
  //print("$plainText ^ $e % $n");
  int cipherText = powr(plainText, e, n);
  return cipherText;
}

// we use this recursive method to find gcd of the two numbers,
// using the euclidean algorithm.
int findGcd(int phiN, int e) {
  if (e == 0) {
    return phiN;
  }
  return findGcd(e, phiN % e);
}

// function to generate the public key (e, n)
(int, int) generatePublicKey(int p, int q) {
  int n = p * q;
  // phi (φ) is called euclid's totient, and now
  // we are computing φ(n) below.
  int phi = (p - 1) * (q - 1);

  // generate primes with sieveOfEratosthenes function:
  List<int> thePrimes = sieveOfEratosthenes(n ~/ 2);
  print("the primes btw:");
  print(thePrimes);

  for (int i = 0; i < thePrimes.length; i++) {
    if (findGcd(phi, thePrimes[i]) == 1) {
      return (thePrimes[i], n);
    }
  }

  throw Exception('Unable to find a suitable public key exponent e');
}

// function to generate private key (d, n)
(int, int) obtainPrivateKey(int p, int q, int e) {
  int phi = (p - 1) * (q - 1);
  int n = p * q;
  // use bezout's algorithm, find numbers x and y
  // such that e * x + phi * y = 1
  // now, we can substiture x with d, so that
  // e * d + phi * y = 1
  // let's pass it on to the bezout function to obtain x.
  // since y is not our concern here.
  int d= 0, x = 0, prevX = 0, y = 1, prevY = 0;

  (d,  y) = bezout(e, phi);
  // in case d is negative, ensuring it is positive
  d = (d + phi) % phi;

  return (d, n);
}
