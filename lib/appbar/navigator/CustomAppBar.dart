import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  
  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true, // 제목을 중앙에 배치합니다.
      elevation: 4.0, // AppBar의 그림자 효과
      actions: actions, // 오른쪽 상단의 액션 버튼 리스트
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
