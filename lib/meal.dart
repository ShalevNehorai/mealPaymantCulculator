import 'package:meal_payment_culculator/person.dart';

class Meal{
  String _name;
  double _price;
  List<Person> _eaters = new List<Person>();
  List<MealExtra> _extras = new List<MealExtra>();

  String get name{
    return _name;
  }

  set name(String name){
    this._name = name;
  }

  double get rawPrice{
    return _price;
  }

  double get fullPrice{
    double fullPrice = rawPrice;
    _extras.forEach((extra) {
      fullPrice += extra.price;
    });
    return fullPrice;
  }

  set rawPrice(double price){
    this._price = price;
  }

  List<MealExtra> get extras{
    return this._extras;
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

  bool isEatersEmpty(){
    return _eaters.isEmpty;
  }

  void addExtra(MealExtra mealExtra){
    this._extras.add(mealExtra);
  }

  void addExtras(List<MealExtra> mealExtras){
    mealExtras.forEach((element) {this.addExtra(element); });
  }
  
  void removeExtra(MealExtra mealExtra){
    this._extras.remove(mealExtra);
  }

  void removeExtras(List<MealExtra> mealExtras){
    mealExtras.forEach((element) {this.removeExtra(element); });
  }

  void addMealPriceToEatersPayment(){
    int numberOfEaters = _eaters.length;

    for (var eater in _eaters) {
      eater.addPayment(fullPrice / numberOfEaters);
    }
  }

  @override
  String toString(){
    return 'name: $name, price: $rawPrice';
  }

  String eatersString(){
    String msg = '';
    _eaters.forEach((element) {msg += ' ${element.name}, ';});
    return msg;
  }

  void printEaters(){
    String msg = '$name [';
    msg += eatersString();
    msg += ']';
    print(msg);
  }

   void printExtras(){
    String msg = '$name [';
    _extras.forEach((element) {msg += ' ${element.name}, ';});
    msg += ']';
    print(msg);
  }
}

class MealExtra{
  String name;
  double price;

  MealExtra(this.name, this.price);
}