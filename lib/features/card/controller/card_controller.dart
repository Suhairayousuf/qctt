import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qctt/models/card_model.dart';

import '../repository/card_repository.dart';

final cardControllerProvider = StateNotifierProvider((ref) {
  return CardController(cardRepository: ref.watch(cardRepositoryProvider), ref: ref);
});
final getCardProvider= StreamProvider.autoDispose((ref) {
  final getRepCard=ref.watch(cardControllerProvider.notifier);
  return getRepCard.getCards();
} );
class CardController extends StateNotifier<bool>{
  final CardRepository _cardRepository;
  final Ref _ref;

  CardController({required CardRepository cardRepository, required Ref ref})
      :_cardRepository = cardRepository, _ref = ref, super(false);
  ///add group

  ///fetch group
  Stream<List<CardModel>>getCards(){
    // final shopId=currentshopId;
    return
      // ref.watch(productRepositoryProvider).getProducts();
      _cardRepository.getCards();

  }


}