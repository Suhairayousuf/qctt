import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:qctt/models/card_model.dart';
import 'package:qctt/models/group_model.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/member_model.dart';

final cardRepositoryProvider = Provider((ref) => CardRepository(firestore: ref.watch(firestoreProvider),
)
);
class CardRepository{
  final FirebaseFirestore _firestore;


  CardRepository({required FirebaseFirestore firestore, }) : _firestore = firestore;
  CollectionReference get _cards =>
      _firestore.collection(FirebaseConstants.cards);


  // addGroup({
  //   required BuildContext context,
  //   required GroupModel groupModel,
  //   required List members,
  // }) async {
  //   try {
  //     // Add the group and get the document reference
  //     DocumentReference groupDoc = await _group.add(groupModel.toJson());
  //
  //     // Update the groupId field in the group document
  //     await groupDoc.update({'groupId': groupDoc.id});
  //
  //     // Add members to the subcollection
  //     for (var member in members) {
  //       await groupDoc.collection('members').add({
  //         'displayName': member.displayName ?? "No Name",
  //         'phone': member.phones != null && member.phones!.isNotEmpty ? member.phones!.first.value : "No Number",
  //
  //       }).then((value){
  //         value.update({
  //           "memberId":value.id,
  //
  //         });
  //       });
  //     }
  //
  //     return right("Group and members added successfully!");
  //   } on FirebaseException catch (e) {
  //     return left(Failure(e.message ?? "An error occurred with Firebase"));
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }




  Stream<List<CardModel>> getCards() {
    return  _firestore.collection(FirebaseConstants.cards)
        .snapshots()
        .map((event) =>
        event.docs.map((e) => CardModel.fromJson(e.data() )).toList());



  }

}