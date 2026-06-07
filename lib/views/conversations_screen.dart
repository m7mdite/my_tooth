import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/conversations_controller.dart';
import '../../models/conversation_model.dart';
import '../services/functions/show_image_preview.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConversationsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchConversations();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.errorMessage.value),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.refreshConversations(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          if (controller.conversations.isEmpty) {
            return const Center(
              child: Text('لا توجد محادثات بعد'),
            );
          }
          return ListView.builder(
            itemCount: controller.conversations.length,
            itemBuilder: (context, index) {
              final conversation = controller.conversations[index];
              return _buildConversationTile(conversation, controller);
            },
          );
        }),
      ),
    );
  }

  Widget _buildConversationTile(
      ConversationModel conversation, ConversationsController controller) {
    final other = conversation.otherParty;
    return ListTile(
      leading: InkWell(
        onTap: () {
          if (other.profilePhoto != null &&
              other.profilePhoto!['url'] != null &&
              other.profilePhoto!['url']!.isNotEmpty) {
            showImagePreview("http://localhost:5000/${other.profilePhoto!['url']}");
          }
        },
        child: _buildAvatar(other),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              other.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          _buildRoleChip(other.role),
        ],
      ),
      subtitle: Text(
        conversation.lastMessage.isNotEmpty
            ? conversation.lastMessage
            : 'لا توجد رسائل',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        "",
        // _formatDate(conversation.updatedAt),
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      onTap: () => controller.goToChat(conversation.conversationId, other),
    );
  }

  Widget _buildAvatar(OtherPartyModel other) {
    return CircleAvatar(
      backgroundImage: other.profilePhoto!['url'] != null &&
              other.profilePhoto!.isNotEmpty &&
              other.profilePhoto!['url'] != ""
          ? CachedNetworkImageProvider(
              "http://localhost:5000/${other.profilePhoto!['url']}")
          : null,
      child: other.profilePhoto!['url'] == null || other.profilePhoto!.isEmpty
          ? Text(other.fullName.isNotEmpty ? other.fullName[0] : '?')
          : null,
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    IconData icon;
    // String label;

    switch (role) {
      case 'student':
        color = Colors.blue;
        icon = Icons.school;
        // label = 'طالب';
        break;
      case 'patient':
        icon = Icons.supervised_user_circle_sharp;
        color = Colors.green;
        // label = 'مريض';
        break;
      case 'overseer':
        color = Colors.orange;
        icon = Icons.health_and_safety;
        // label = 'مشرف';
        break;
      case 'admin':
        color = Colors.red;
        icon = Icons.admin_panel_settings;
        // label = 'أدمن';
        break;
      default:
        color = Colors.grey;
        icon = Icons.person;
      // label = 'مستخدم';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          // Text(
          //   label,
          //   style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
          // ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
