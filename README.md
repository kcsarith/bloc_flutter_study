# bloc_flutter_study
Cubits are a special kind of stream component that rebuild UI on state emitted by the stream.

Functions are not a part of a stream but are a pre-baked list of what the Cubit can do. The stream part of it is hidden.

Blocs on the otherhand do emit streams of state when it is triggered by events.

## Questions to ask when creating a Cubit
1. What is the initial state?
    * submitting, completed
2. What are the possible interactions?
    * Buttons a screen for example
3. What are the methods in the Cubit?
    * login(), logout()

# Basic Cubit template
It's okay to start off with Cubits, it is basically Bloc lite. If you need to extend to Bloc, the main change is to add event.dart.
## Make a new folder for the Cubit
1. Create a Cubit state
    * Define values
    ```dart
    class TestState{
        final int testInt;
    }
    ```
2. Create a class extending the Cubit state
    * Set initial values
    * Define methods to emit
    ```dart
    class TestCubit extends Cubit<TestState>{
        TestCubit(): super(TestState(testInt: 0));

        void increment(){
            emit(TestCubit(state.testValue: +1));
        }
    }
    ```
## Adding Cubits to the widgets
The pattern goes that we usually wrap the main widget, ```MaterialApp()``` for example, in a BlocProvider. Since it can be kind of expensive for every widget to have access to the Cubit, so we then wrap the widgets that use the state in a
* ```BlocBuilder``` for building widgets based on state.
* ```BlocListener``` for performing side effects such as showing dialog messages.
* ```BlocConsumer``` for building widgets and performing side effects.

For multiple Bloc/Cubit, we would use ```MultiBlocProvider```

1. Wrap a widget in the BlocProvider
    * add a ```create:``` method that takes in the context and return the Cubit.
    ```dart
    home: BlockProvider(
        create: (context) => TestCubit(TestRepository()),
        child: TestPage()
    ),
    ```
2. For the widget (```TestPage()``` in this case) that was child of the BlocProvider, add a ```BlocConsumer<Bloc, BlocState>``` to listen and build.
    * add a ```builder: (context, state) {}``` and return widgets to render based on conditions.
    ```dart
    builder: (context, state){
        if(state is BlocInitial){
            return buildInitialInput();
        }else{
            return buildErrorInput('An error has occured');
        }
    }
    ```
    * in addition to having a builder:, we can also add a ```listener: (context, state){}``` method to perform side effects such as showing Snackbars or AlertDialogs.
    ```dart
    listener: (context, state){
        if(state is TestError ){
            Scaffold.of(context).showSnackBar(
                SnackBar(context: Text(state.message))
            );
        }
    }
    ```
## Triggering state changes from Cubit
Calling methods on the Cubit requires creating a new method in the widget that takes in the context and simply call the method after grabbing it from the context.

There are two ways to get the Cubit.
```dart
final testCubit = BlocProvider.of(context)
```
or
```dart
final testCubit = context.bloc<TestCubit>()
```
Then we can call the method.
```dart
testCubit.increment();
```
# Bloc
The only difference between Cubit and Bloc is that Blocs have events while Cubits don't.
## BlocState
We can use the exact same state created by the Cubit onto Bloc.
## BlocEvent
On the Cubit, we had a method called "increment", and for Bloc, we will create an event also called ```TestIncrement```.
## BlocClass
Events come into the Bloc, and states come out. On Cubits, there are no events, only methods. Cubits hide the stream controller behind the ```emit()``` method while Blocs shows the stream.
```dart
// Cubit
class TestCubit extends Cubit<TestState>{
    TestCubit(): super(TestState(testInt: 0));

    void increment(){
        emit(TestCubit(state.testValue: +1)); // emit
    }
}
```
For Bloc, we would actually create a ```Stream<BlocState>``` called ```mapEventToState(event, callback)```, it actually uses shows the stream. Instead of emitting, Blocs will ```yield```. We retrieve state from the event. ```event.testValue```.
```dart
// Bloc
class TestBloc extends Bloc<TestEvent, TestState>{
    TestBloc(): super(TestState(testInt: 0));

    @override
    Stream<TestState> mapEventToState (TestEvent event, ) async* {
        if(event is TestIncrement){
            yield TestBloc(event.testValue: +1);
        }
    }
}
```

## Triggering event
Grabbing the Bloc from the context is the same as grabbing Blocs. There is only one simple change, instead of ```testCubit.increment()``` we  calling it ```testBloc.add(TestIncrement())```

# Using Bloc on the app

## BlocProvider/ MultiBlocProvider
1. Dependency injection widget that will pass Bloc down the Widget Tree.
2. New screens will NOT get the context or the provider.
    * Need to do Route Access to provide Bloc to multiple screens.
    * Pass in BlocProvider.value to pass the Bloc into newly created context.
3. For global access for all widgets, including newly created widgets, wrap the Material App in BlocProvider
```dart
BlocProvider.value(
    value: BlocProvider.of<Bloc>(context),
    child: CurrentScreen();
)
```
## BlocConsumer
BlocListener and BlocBuilder

# Communicating between two Blocs
## Stream Subscription
The foundations of listening to streams. They emit the initial state as soon as they are created.
```Dart
streamSubscription = testCubit.listen(
    (testState){
        if(testState is State1) increment();
    }
);
```
Remember to cancel the stream manually by overriding the close method, since it was created manually.

```dart
@override
Future<void> close(){
    streamSubscription.cancel();
    return super.close();
}
```
##
# Repository
If the app is going to communicate with the outer data layer such as asynchronous calls to a database or API from the internet, then this file helps organize the file structure. Most of the data here would be streams, sinks, and variables returned should be futures.

Streams can bring 0, or multiple values, instead of 1 value from futures.
