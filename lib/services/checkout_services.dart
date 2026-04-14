import '../models/payment_card_model.dart';
import '../utils/api_paths.dart';
import 'firestore_services.dart';

abstract class CheckoutServices {
  Future<void> setCard(String userId, PaymentCardModel paymentCard);
  Future<List<PaymentCardModel>> fetchPaymentCards(String userId,[bool isSelected=false]);
  Future<PaymentCardModel> fetchPaymentCard(String userId,String paymentCardId);
}

class CheckoutServicesImpl implements CheckoutServices {
  final fireStoreServices = FirestoreServices.instance;
  @override
  Future<void> setCard(String userId, PaymentCardModel paymentCard) async {
    await fireStoreServices.setData(
      path: ApiPaths.paymentCard(userId, paymentCard.id),
      data: paymentCard.toMap(),
    );
  }

  @override
  Future<List<PaymentCardModel>> fetchPaymentCards(String userId,[bool isSelected=false]) async {
    final result = await fireStoreServices.getCollection(
      path: ApiPaths.paymentCards(userId),
      builder: (data, documentId) => PaymentCardModel.fromMap(data),
      queryBuilder:isSelected? (query) => query.where('isSelected', isEqualTo: true):null,
    );
    return result;
  }

  @override
  Future<PaymentCardModel> fetchPaymentCard(String userId, String paymentCardId) async {
    final result = await fireStoreServices.getDocument(
      path: ApiPaths.paymentCard(userId,paymentCardId),
      builder: (data, documentId) => PaymentCardModel.fromMap(data),
    );
    return result;
  }
}
