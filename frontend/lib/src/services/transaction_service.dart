import 'dart:convert';
import 'dart:io';

import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/models/transaction.dart';

class TransactionService {
  static Future<dynamic> postTransaction(
    Transaction transaction,
    String accountId,
  ) async {
    final response = await NetworkConfig().client.post(
      accountTransactionsUrl.replaceFirst('{id}', accountId),
      data: {
        'amount': transaction.amount,
        'transaction_type': transaction.transactionType.name,
        'category': transaction.category.name,
        'description': transaction.description,
      },
    );

    if (response.statusCode == HttpStatus.created) {
      return true;
    }

    return jsonDecode(response.data.toString())['error']['message'];
  }

  static Future<List<Transaction>> getTransactions({
    String accountId = '',
  }) async {
    final url = accountTransactionsUrl.replaceFirst('{id}', accountId);
    final transactionResponse = await NetworkConfig().client.get(url);

    if (transactionResponse.statusCode == HttpStatus.ok) {
      final Iterable data = transactionResponse.data['data'];
      final List<Transaction> transactions = List<Transaction>.from(
        data.map(
          (transaction) => Transaction.fromJson(transaction),
        ),
      );
      return transactions;
    }
    return [];
  }
}
