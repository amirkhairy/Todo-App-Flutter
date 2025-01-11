import 'package:flutter/material.dart';
import 'package:todo_app/layout/cubit.dart';

Widget taskItem(Map item, context) {
  return Dismissible(
    key:Key(item['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: item['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Text(
              '${item['time']}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item['name']}',
                  style:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${item['date']}',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(status: 'done', id: item['id']);
            },
            icon: const Icon(
              Icons.done_all,
              color: Colors.green,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
                  AppCubit.get(context).updateData(status: 'archived', id: item['id']);
            },
            icon: const Icon(
              Icons.archive,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
    ),
  );
}
