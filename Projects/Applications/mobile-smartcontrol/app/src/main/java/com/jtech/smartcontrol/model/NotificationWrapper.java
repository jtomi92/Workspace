package com.jtech.smartcontrol.model;

import java.util.LinkedList;
import java.util.List;

public class NotificationWrapper {
  List<Notification> notifications;

  public List<Notification> getNotifications() {
    return notifications;
  }

  public void setNotifications(List<Notification> notifications) {
    this.notifications = notifications;
  }
  
  public void addNotification(Notification notification){
    if (notifications == null){
      notifications = new LinkedList<Notification>();
    }
    notifications.add(notification);
  }
  
}
