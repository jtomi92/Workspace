package com.jtech.apps.hcm.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jtech.apps.hcm.dao.UserProfileDAOImpl;
import com.jtech.apps.hcm.model.UserProfile;

@Service
public class UserProfileService {
  @Autowired
  UserProfileDAOImpl userProfileDAO;

  /**
   * Gets userProfile by userId
   * 
   * @param userId
   * @return UserProfile or null if not exists
   */
  @Transactional(readOnly = true)
  public UserProfile getUserProfileByUserId(Integer userId) {

    List<UserProfile> userProfiles = userProfileDAO.getUserProfiles();

    for (UserProfile userProfile : userProfiles) {
      if (userProfile.getUserId() == userId) {
        return userProfile;
      }
    }
    return null;
  }

  /**
   * Gets userProfile by userName (email)
   * 
   * @param userName
   * @return UserProfile or null if not exists
   */
  @Transactional(readOnly = true)
  public UserProfile getUserProfileByUserName(String userName) {

    List<UserProfile> userProfiles = userProfileDAO.getUserProfiles();
    for (UserProfile userProfile : userProfiles) {
      if (userProfile.getUserName().equals(userName)) {
        return userProfile;
      }
    }
    return null;
  }

  /**
   * Gets userProfile by registration Token
   * 
   * @param token
   * @return UserProfile or null if not exists
   */
  @Transactional(readOnly = true)
  public UserProfile getUserProfileByUserToken(String token) {
    List<UserProfile> userProfiles = userProfileDAO.getUserProfiles();
    for (UserProfile userProfile : userProfiles) {
      if (userProfile.getToken() != null && userProfile.getToken().equals(token)) {
        return userProfile;
      }
    }
    return null;
  }

  /**
   * get all userProfiles
   * 
   * @return List<UserProfile>
   */
  @Transactional(readOnly = true)
  public List<UserProfile> getUserProfiles() {
    return userProfileDAO.getUserProfiles();
  }

  /**
   * update userProfile
   * 
   * @param userProfile
   * @return
   */
  @Transactional
  public int updateUserProfile(UserProfile userProfile) {
    return userProfileDAO.updateUserProfile(userProfile);
  }

  /**
   * add userProfile
   * 
   * @param up
   * @return
   */
  @Transactional
  public int addUserProfile(UserProfile up) {

    List<UserProfile> userProfiles = getUserProfiles();

    for (UserProfile userProfile : userProfiles) {
      if (userProfile.getUserName().equals(up.getUserName())) {
        return 0;
      }
    }
    PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    up.setPassword(passwordEncoder.encode(up.getPassword()));

    return userProfileDAO.addUserProfile(up);
  }
}
