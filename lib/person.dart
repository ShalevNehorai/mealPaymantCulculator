class Person {
  String _name;
  double _payment;

  String get name{
    return this._name;
  }

  set name(String name){
    this._name = name;
  }

  double get payment{
    return this._payment;
  }

  Person(String name){
    this._name = name;
    this._payment = 0.0;
  }

  void addPayment(addedPayment) => this._payment += addedPayment;

  void removePayment(removedPayment) => this._payment -= removedPayment;

  void resetPayment() => this._payment = 0.0;

  double getPaymentWithTip(double tipPersentage){
    return (tipPersentage + 1) * payment;
  }

}