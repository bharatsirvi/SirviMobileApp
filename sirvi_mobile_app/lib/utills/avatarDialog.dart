import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sirvi_mobile_app/models/userModel.dart';

class AvatarDialog extends StatefulWidget {
  final User? user;
  final VoidCallback onClose;

  AvatarDialog({required this.user, required this.onClose});

  @override
  AvatarDialogState createState() => AvatarDialogState();
}

class AvatarDialogState extends State<AvatarDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _scaleAnimation,
      child: GestureDetector(
        onTap: widget.onClose,
        child: Container(
          color: Colors.black54,
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Hero(
                tag: 'avatar',
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.transparent,
                  backgroundImage: widget.user!.profilePic != ""
                      ? Image.memory(base64Decode(widget.user!.profilePic!))
                          .image
                      : Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Color(0xFFFF0844),
                        ) as ImageProvider<Object>,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
