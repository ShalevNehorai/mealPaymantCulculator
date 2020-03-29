import 'package:meal_payment_culculator/person.dart';

class Meal{
  String _name;
  double _price;
  List<Person> _eaters = new List<Person>();

  String get name{
    return _name;
  }

  set name(String name){
    this._name = name;
  }

  double get price{
    return _price;
  }

  set price(double price){
    this._price = price;
  }

  Meal(this._name, this._price);

  void addEater(Person eater){
    if(!this._eaters.contains(eater)){
      this._eaters.add(eater);
    }
  }

  void addEaters(List<Person> eaters){
    eaters.forEach((eater) { addEater(eater); });
  }

  void removeEater(Person eater){
    this._eaters.remove(eater);
  }

  void removeEaters(List<Person> eaters){
    eaters.forEach((eater) { removeEater(eater); });
  }

  void removeAllEates() {
    this._eaters.clear();
  }

  bool haveEater(Person eater){
    return this._eaters.contains(eater);
  }

  void addMealPriceToEatersPayment(){
    int numberOfEaters = _eaters.length;

    for (var eater in _eaters) {
      eater.addPayment(_price / numberOfEaters);
    }
  }

  @override
  String toString(){
    return 'name: $name, price: $price';
  }

  void printEaters(){
    String msg = '$name [';
    _eaters.forEach((element) {msg += ' ${element.name}, ';});
    msg += ']';
    print(msg);
  }
}