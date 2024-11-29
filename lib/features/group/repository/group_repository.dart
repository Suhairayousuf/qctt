import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:qctt/models/group_model.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/member_model.dart';

final groupRepositoryProvider = Provider((ref) => GroupRepository(firestore: ref.watch(firestoreProvider),
)
);
class GroupRepository{
  final FirebaseFirestore _firestore;


  GroupRepository({required FirebaseFirestore firestore, }) : _firestore = firestore;
  CollectionReference get _group =>
      _firestore.collection(FirebaseConstants.groups);


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
  ///add group
  addGroup({
    required BuildContext context,
    required GroupModel groupModel,
    required List<MemberModel> members, // Explicitly a list of MemberModel
  }) async {
    try {
      // Add the group and get the document reference
      DocumentReference groupDoc = await _group.add(groupModel.toJson());

      // Update the groupId field in the group document
      await groupDoc.update({'groupId': groupDoc.id});

      // Add members to the subcollection
      if(members.isNotEmpty){
        for (var member in members) {
          // Convert the member to a map and add it to Firestore
          DocumentReference memberDoc = await groupDoc.collection('members').add(member.toJson());

          // Update the memberId field in the member document
          await memberDoc.update({'memberId': memberDoc.id});
        }
      }


      return right("Group and members added successfully!");
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? "An error occurred with Firebase"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
  ///update group
  Future<void> updateGroup({
    required BuildContext context,
    required GroupModel groupModel,
    required List<MemberModel> members, // Explicitly a list of MemberModel
  }) async {
    try {
      // Reference to the group document in Firestore
      DocumentReference groupDocRef = FirebaseFirestore.instance.collection(FirebaseConstants.groups).doc(groupModel.groupId);

      // Update the group data
      await groupDocRef.update(groupModel.toJson());

      // Reference to the 'members' subcollection within the group document
      CollectionReference membersCollectionRef = groupDocRef.collection(FirebaseConstants.members);

      // Iterate over the list of members to update or add them to the subcollection
      for (var member in members) {
        if (member.memberId.isNotEmpty) {
          // Update existing member document
          await membersCollectionRef.doc(member.memberId).update(member.toJson());
        } else {
          // Add a new member document and update its memberId
          DocumentReference newMemberDoc = await membersCollectionRef.add(member.toJson());
          await newMemberDoc.update({'memberId': newMemberDoc.id});
        }
      }

      // Inform the user that the update was successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group and members updated successfully!')),
      );
    } on FirebaseException catch (e) {
      // Handle Firebase-specific exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase error: ${e.message}')),
      );
      debugPrint('FirebaseException: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      debugPrint('Exception: $e');
    }
  }


  Stream<List<GroupModel>> getGroups() {
    return  _firestore.collection(FirebaseConstants.groups)
        .snapshots()
        .map((event) =>
        event.docs.map((e) => GroupModel.fromJson(e.data() )).toList());



  }
  // Stream<List<MemberModel>> getMembers(String groupId) {
  //   print(groupId);
  //   print('groupId');
  //   return  _firestore.collection(FirebaseConstants.groups).doc(groupId).collection('members')
  //       .snapshots().map((event) => event.docs.map((e) => MemberModel.fromJson(e.data() )).toList());
  //
  //
  //
  // }
  Future<List<MemberModel>> getMembers(String groupId) async {
    try {
      final snapshot = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .get();

      return snapshot.docs
          .map((doc) => MemberModel.fromJson(doc.data())) // Assuming fromMap exists
          .toList();
    } catch (e) {
      print("Error fetching members: $e");
      return [];
    }
  }
}