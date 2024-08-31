// Create a list of sample NotificationModel objects
import 'package:geolocation/features/notification/widget/model/notification_model.dart';

List<NotificationModel> notifications = [
  NotificationModel(
    id: "1",
    notifiable_id: 101,
    read_at: "2024-08-30 10:15:00",
    created_at: "2024-08-30 09:00:00",
  ),
  NotificationModel(
    id: "2",
    notifiable_id: 102,
    read_at: null, // This notification is not yet read
    created_at: "2024-08-31 12:30:00",
  ),
  NotificationModel(
    id: "3",
    notifiable_id: 103,
    read_at: "2024-08-31 13:45:00",
    created_at: "2024-08-31 13:00:00",
  ),
  NotificationModel(
    id: "4",
    notifiable_id: 104,
    read_at: null,
    created_at: "2024-08-31 14:00:00",
  ),
  NotificationModel(
    id: "5",
    notifiable_id: 105,
    read_at: "2024-08-31 15:00:00",
    created_at: "2024-08-31 14:30:00",
  ),
];
