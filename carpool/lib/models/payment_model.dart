class PaymentModel {
  String _selectedPaymentMethod = '';

  String get selectedPaymentMethod => _selectedPaymentMethod;

  void setSelectedPaymentMethod(String method) {
    _selectedPaymentMethod = method;
  }
}
