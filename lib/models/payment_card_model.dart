class PaymentCardModel {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final bool isSelected;

  PaymentCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    this.isSelected = false,
  });

  PaymentCardModel copyWith({
    String? id,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cvv,
    bool? isSelected,
  }) {
    return PaymentCardModel(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'isSelected': isSelected,
    };
  }

  factory PaymentCardModel.fromMap(Map<String, dynamic> map) {
    return PaymentCardModel(
      id: map['id'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      cardHolderName: map['cardHolderName'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cvv: map['cvv'] ?? '',
      isSelected: map['isSelected'] ?? false,
    );
  }
}

final List<PaymentCardModel> dummyCards = [
  PaymentCardModel(
    id: 'card_1',
    cardNumber: '1234567812345678',
    cardHolderName: 'John Doe',
    expiryDate: '12/25',
    cvv: '123',
  ),
  PaymentCardModel(
    id: 'card_2',
    cardNumber: '8765432187654321',
    cardHolderName: 'Jane Smith',
    expiryDate: '10/26',
    cvv: '456',
  ),
  PaymentCardModel(
    id: 'card_3',
    cardNumber: '1122334455667788',
    cardHolderName: 'Alex Johnson',
    expiryDate: '05/27',
    cvv: '789',
  ),
  PaymentCardModel(
    id: 'card_4',
    cardNumber: '1122334455664444',
    cardHolderName: 'Alex Johnson',
    expiryDate: '05/27',
    cvv: '789',
  ),
  PaymentCardModel(
    id: 'card_5',
    cardNumber: '1122334455665555',
    cardHolderName: 'Alex Johnson',
    expiryDate: '05/27',
    cvv: '789',
  ),
  PaymentCardModel(
    id: 'card_6',
    cardNumber: '1122334455666666',
    cardHolderName: 'Alex Johnson',
    expiryDate: '05/27',
    cvv: '789',
  ),
];
