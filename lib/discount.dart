enum DiscountType{
  PERSANTAGE, AMOUNT //TODO check spelling
}

class Discount {

  DiscountType type;
  double amount;

  Discount({this.amount, this.type});

  double getPriceAfterDiscount(double price){
    return price - getDiscountAmount(price);
  }

  double getDiscountAmount(double price){
    if(type == DiscountType.AMOUNT){
      return amount;
    }
    double discount = price * amount / 100;
    return discount;
  } 

  bool isEmpty(){
    return amount == 0;
  }

  @override
  String toString() {
    return 'discount type: $type, amount $amount';
  }
}