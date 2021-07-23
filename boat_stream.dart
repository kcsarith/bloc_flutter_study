// SENDER
Stream<int> boatStream() async* {
  for (int i = 1; i <= 10; i++) {
    print('SENT boat no. ' + i.toString());
    await Future.delayed(Duration(seconds: 2));
    yield i;
  }
}

// RECEIVER
void main() async {
  Stream<int> stream = boatStream();

  stream.listen((receivedData) {
    print("RECEIVED boat no. " + receivedData.toString());
  });
}

// async* is used for an async generator function, which means it generates async data.
// if I take out the star in async*, then I cannot yield.
// await is
// yield sends data to the stream but not close out the function. Has to be in an async* function.
