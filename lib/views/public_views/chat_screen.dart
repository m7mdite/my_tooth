import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/models/conversations_models/conversation_model.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
import 'package:gr_flutter/views/widgets/custom_icon_app_bar.dart';
import '../../controllers/conversations_controllers/chat_controller.dart';
import '../../models/conversations_models/message_model.dart';
import 'profile_screen_public.dart'; // تأكد من المسار الصحيح

class ChatScreenn extends StatelessWidget {
  final String conversationId;
  final OtherPartyProfile otherPartyProfile;
  // final String otherPartyName;
  // final String otherUserId;      // userId الخاص بالطرف الآخر
  // final String? otherProfilePhotoUrl; // رابط صورة المستخدم الآخر

  const ChatScreenn({
    super.key,
    // required this.otherUserId,
    required this.conversationId,
    required this.otherPartyProfile,

    // required this.otherPartyName,
    // this.otherProfilePhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController(
        conversationId: conversationId, otherPartyProfile: otherPartyProfile));

    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          CustomIconAppBar(
            iconData: Icons.menu_outlined,
            onTap: () {
              // الانتقال إلى صفحة تفاصيل المحادثة أو الملف الشخصي للطرف الآخر
              Get.to(
                  () => PublicProfileScreen(userId: otherPartyProfile.userId!));
            },
          )
        ],
        automaticallyImplyLeading: true,
        notifacation: false,
        showVerifiedBadge: true,
        centerTitle: false,
        title: otherPartyProfile.fullName ?? "ماكو اسم",

        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        //   onPressed: () => Get.back(),
        // ),
        titleWidget: InkWell(
          onTap: () {
            // الانتقال إلى الملف الشخصي العام للمستخدم الآخر
            Get.to(
                () => PublicProfileScreen(userId: otherPartyProfile.userId!));
          },
          borderRadius: BorderRadius.circular(30),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: (otherPartyProfile.profilePhoto != null &&
                        otherPartyProfile.profilePhoto!.url != null)
                    ? NetworkImage(
                        "http://127.0.0.1:5000/${otherPartyProfile.profilePhoto!.url}")
                    : AssetImage(AppConstants.defaultBackgroundImage)
                        as ImageProvider,
              ),
              const SizedBox(width: 8),
              Text(
                otherPartyProfile.fullName ?? "ماكو اسم",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        // onTitleTap: () {
        //   // الانتقال إلى الملف الشخصي العام للمستخدم الآخر
        //   Get.to(() => PublicProfileScreen(userId: otherPartyProfile.userId!));
        // },
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.defaultBackgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.linearToSrgbGamma(),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.messages.isEmpty) {
                  return const Center(
                      child: Text('لا توجد رسائل بعد، ابدأ المحادثة'));
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return _buildMessageBubble(message);
                  },
                );
              }),
            ),
            _buildMessageInput(controller),
          ],
        ),
      ),
    );
  }

  // AppBar مخصص ومتوافق مع التصميم
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      elevation: 0,
      automaticallyImplyLeading: false, // إزالة السهم الافتراضي
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: InkWell(
        onTap: () {
          // الانتقال إلى الملف الشخصي العام للمستخدم الآخر
          Get.to(() => PublicProfileScreen(userId: otherPartyProfile.userId!));
        },
        borderRadius: BorderRadius.circular(30),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: (otherPartyProfile.profilePhoto != null &&
                      otherPartyProfile.profilePhoto!.url != null)
                  ? NetworkImage(
                      "http://127.0.0.1:5000/${otherPartyProfile.profilePhoto!.url}")
                  : AssetImage(AppConstants.defaultBackgroundImage)
                      as ImageProvider,
            ),
            const SizedBox(width: 8),
            Text(
              otherPartyProfile.fullName ?? "ماكو اسم",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
      centerTitle: false, // العنوان ليس في الوسط، بل على اليسار بجانب السهم
      // يمكن إضافة أزرار إضافية في actions إذا لزم الأمر
      actions: [
        // مثال: زر معلومات إضافية
        // IconButton(
        //   icon: const Icon(Icons.more_vert, color: Colors.white),
        //   onPressed: () {},
        // ),
      ],
    );
  }

  // باقي الكود كما هو (_buildMessageBubble, _buildMessageInput, _formatTime)
  // ... (سأضعه كاملاً في الأسفل للحفاظ على التكامل)

  Widget _buildMessageBubble(MessageModel message) {
    final isMe = !message.isFromMe;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: EdgeInsets.only(
                bottom: 12.5,
                top: 12.5,
                right: isMe ? 50 : 10,
                left: isMe ? 10 : 50),
            decoration: BoxDecoration(
              color: isMe && message.messageType == 'text'
                  ? const Color.fromARGB(217, 68, 137, 255)
                  : const Color.fromARGB(149, 255, 255, 255),
              border: Border.symmetric(
                vertical: BorderSide(
                    color: isMe ? Colors.white : Colors.blue,
                    width: 1,
                    strokeAlign: 10),
                horizontal: BorderSide(
                    color: isMe ? Colors.white : Colors.blue,
                    width: 1.5,
                    strokeAlign: 12),
              ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: !isMe ? const Radius.circular(20) : Radius.zero,
                bottomRight: !isMe ? Radius.zero : const Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: message.messageType == "text"
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        message.content,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(message.createdAt),
                            style: TextStyle(
                              fontSize: 10,
                              color: isMe ? Colors.white70 : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.copy,
                                size: 16, color: Colors.grey[400]),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "${message.content}"),
                          fit: BoxFit.cover),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput(ChatController controller) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 2)],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: controller.pickAndSendImage,
          ),
          Expanded(
            child: TextField(
              maxLines: 4,
              minLines: 1,
              controller: controller.textController,
              decoration: const InputDecoration(
                hintText: 'اكتب رسالة...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: controller.sendMessage,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
