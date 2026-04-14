class ApiPaths {
  static String users(String userId) => 'users/$userId'; //users//$userid
  static String cartItem(String userId,String cartItemId) => 'users/$userId/cart/$cartItemId'; //users//$userid/cart/$cartItemId
  static String favoriteProduct(String userId,String productId) => 'users/$userId/favorites/$productId'; //users//$userid/favorites/$productId
  static String favorites(String userId)=> 'users/$userId/favorites';
  static String paymentCards(String userId)=> 'users/$userId/cards';
  static String paymentCard(String userId,String cardId)=> 'users/$userId/cards/$cardId';
  static String location(String userId,String locationId)=> 'users/$userId/locations/$locationId';
  static String locations(String userId)=> 'users/$userId/locations';
  static String carts(String userId)=> 'users/$userId/cart';
  static String products() => 'products/'; //products/
  static String product(String productId) => 'products/$productId'; //products/$productId
  static String announcements() => 'announcements/'; //announcements/
  static String categories() => 'categories/'; //categories/
}
