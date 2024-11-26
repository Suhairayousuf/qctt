
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qctt/models/group_model.dart';
import 'package:qctt/models/member_model.dart';

import '../repository/group_repository.dart';



final groupControllerProvider = StateNotifierProvider((ref) {
  return GroupController(groupRepository: ref.watch(groupRepositoryProvider), ref: ref);
});

final getGroupProvider= StreamProvider.autoDispose((ref) {
  final getRepGroup=ref.watch(groupControllerProvider.notifier);
  return getRepGroup.getGroups();
} );


class GroupController extends StateNotifier<bool>{
  final GroupRepository _groupRepository;
  final Ref _ref;

  GroupController({required GroupRepository groupRepository, required Ref ref})
      :_groupRepository = groupRepository, _ref = ref, super(false);

  addGroup(  {required BuildContext context, required GroupModel groupModel, required List<MemberModel> members}){
    _groupRepository.addGroup( context: context,groupModel: groupModel, members: members,);



  }
  Stream<List<GroupModel>>getGroups(){
    // final shopId=currentshopId;
    return
      // ref.watch(productRepositoryProvider).getProducts();
      _groupRepository.getGroups();

  }
  Future<List<MemberModel>> getMembers(String groupId)async{


    return _groupRepository.getMembers(groupId);

  }


}