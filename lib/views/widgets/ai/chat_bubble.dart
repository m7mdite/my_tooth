// widgets/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../controllers/ai_controllers/ai_chat_controller.dart';
import '../../../utils/app_constants/colors_constant.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onCopy;
  final VoidCallback? onRetry;

  const ChatBubble({
    super.key,
    required this.message,
    required this.onCopy,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: message.isUser
                    ? const Color.fromARGB(217, 68, 137, 255)
                    : message.isError
                        ? AppColors.error.shade50
                        : const Color.fromARGB(149, 255, 255, 255),
                border: Border.symmetric(
                  vertical: BorderSide(
                      color:message.isUser ? AppColors.white: AppColors.primary, width: 1.5, strokeAlign: 10),
                  horizontal: BorderSide(
                      color: message.isUser ? AppColors.white: AppColors.primary,
                      width: 1.5,
                      strokeAlign: 12),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft:
                      !message.isUser ? const Radius.circular(20) : Radius.zero,
                  bottomRight:
                      !message.isUser ? Radius.zero : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? AppColors.white : AppColors.black87,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: message.isUser ? AppColors.white70 : AppColors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!message.isUser)
                        IconButton(
                          icon: Icon(Icons.copy,
                              size: 16, color: AppColors.grey400),
                          onPressed: onCopy,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      if (onRetry != null && message.isUser && !message.isError)
                        IconButton(
                          icon: Icon(Icons.refresh,
                              size: 16, color: AppColors.grey400),
                          onPressed: onRetry,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryAccent, AppColors.successAccent],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child:
            FaIcon(FontAwesomeIcons.userDoctor, color: AppColors.white, size: 20),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'الآن';
    if (difference.inHours < 1) return 'منذ ${difference.inMinutes} دقيقة';
    if (difference.inDays < 1) return 'منذ ${difference.inHours} ساعة';
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
