// ignore_for_file: prefer_const_constructors_in_immutables

part of 'widget.dart';

class ChatWidget extends StatelessWidget {
  final bool isSender;
  final String message;
  final String dateTime;

  ChatWidget({
    super.key,
    required this.isSender,
    required this.dateTime,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: isSender ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  10,
                )),
            child: Text(
              '$message',
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(DateFormat.jm().format(DateTime.parse(dateTime)))
        ],
      ),
    );
  }
}
