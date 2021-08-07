import 'package:bloc/bloc.dart';
import 'package:livraison_mobile/screens/ModeLiv.dart';
import 'package:livraison_mobile/screens/creer_colis.dart';
import 'package:livraison_mobile/screens/home.dart';


enum NavigationEvents {
  HomePageCliClickedEvent,
 HomeLivClickedEvent,

}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc(NavigationStates initialState) : super(initialState);


  @override
  NavigationStates get initialState => Home();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageCliClickedEvent:
        yield Home();
        break;
      case NavigationEvents.HomeLivClickedEvent:
        yield HomeLiv();
        break;

    }
  }
}