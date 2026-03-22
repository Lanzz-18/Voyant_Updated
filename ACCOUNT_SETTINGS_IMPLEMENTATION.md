# Account Settings Implementation Guide

## Overview
This document outlines the complete implementation of the Account Settings screen and related backend/frontend infrastructure for the Voyant application.

## Architecture

### Frontend (Flutter)

#### 1. **BLoC State Management** (`lib/blocs/account_settings_bloc/`)

##### `account_settings_bloc.dart`
- Main BLoC class that manages all account settings operations
- Handles events and emits states
- Integrates with `UserRepository` for business logic

##### `account_settings_event.dart`
Defines events:
- `UpdateProfileEvent` - Update display name, bio, location
- `UploadProfileImageEvent` - Upload profile picture to Firebase Storage
- `ChangePasswordEvent` - Change password (with re-authentication)
- `UpdateLocationSharingEvent` - Toggle location sharing
- `UpdateTwoFAEvent` - Enable/disable two-factor authentication
- `UpdateBiometricEvent` - Enable/disable biometric login
- `DownloadPersonalDataEvent` - Export personal data (GDPR)
- `LinkSocialAccountEvent` - Link Google/Facebook account
- `UnlinkSocialAccountEvent` - Unlink social account
- `DeleteAccountEvent` - Delete account permanently
- `GetLoginSessionsEvent` - Fetch active login sessions

##### `account_settings_state.dart`
Defines states with status:
- `initial` - Initial state
- `loading` - Operation in progress
- `success` - Operation completed successfully
- `failure` - Operation failed
- `accountDeleted` - Account successfully deleted

State includes:
- Profile data (displayName, bio, location)
- Settings (locationSharingEnabled, twoFactorEnabled, biometricLoginEnabled)
- Media (profileImageUrl)
- Data (downloadedData, loginSessions)
- Errors (errorMessage)

#### 2. **User Repository** (`packages/user_repository/`)

##### Extended `MyUser` Model
```dart
class MyUser {
  String userId;
  String email;
  String username;
  String? displayName;
  String? bio;
  String? location;
  String? profileImageUrl;
  bool locationSharingEnabled;
  bool twoFactorEnabled;
  bool biometricLoginEnabled;
  DateTime? lastLoginAt;
  Map<String, dynamic>? connectedAccounts;
  DateTime? dataDownloadedAt;
}
```

##### Extended `UserRepository` Abstract Class
New methods:
- `updateProfile()` - Update profile information
- `uploadProfileImage()` - Upload image to Firebase Storage
- `reauthenticateUser()` - Re-authenticate for sensitive operations
- `changePassword()` - Update password
- `updateLocationSharing()` - Toggle preference
- `updateTwoFA()` - Configure 2FA
- `updateBiometric()` - Configure biometric
- `getLoginSessions()` - Retrieve sessions
- `downloadPersonalData()` - Export user data
- `linkSocialAccount()` - Link social provider
- `unlinkSocialAccount()` - Unlink social provider
- `deleteAccountWithCleanup()` - Delete account and all data

##### `FirebaseUserRepo` Implementation
Implements all methods using:
- **Firebase Auth** - Password changes, email updates, user deletion
- **Firestore** - Store profile and settings data
- **Firebase Storage** - Store profile images at `users/{uid}/profile.jpg`
- **Cloud Firestore Transactions** - Atomic operations for safety

#### 3. **UI Screen** (`lib/screens/settings/account_settings_screen.dart`)

The screen is organized into sections:

1. **Profile Section**
   - Profile picture with image picker
   - Display name input
   - Bio input
   - Location input

2. **Authentication Section**
   - Email display
   - Change password button
   - Logout button

3. **Preferences Section**
   - Location sharing toggle

4. **Security Section**
   - Two-factor authentication toggle
   - Biometric login toggle

5. **Account Management Section**
   - Download personal data button
   - Delete account button

6. **Connected Accounts Section**
   - Link Google account button
   - Link Facebook account button
   - Display connected accounts

7. **Activity Section**
   - Display active login sessions

8. **Save Changes Button**
   - Sends all profile updates to backend

### Backend (Node.js + Express)

#### 1. **Extended Models** (`backend/models/UserAccountDetails.js`)

Added fields:
```javascript
// Profile
displayName: String
bio: String
location: String
profileImageUrl: String

// Preferences
locationSharingEnabled: Boolean

// Security
twoFactorEnabled: Boolean
biometricLoginEnabled: Boolean

// Social Accounts
connectedAccounts: {
  google: { linkedAt: Date, email: String },
  facebook: { linkedAt: Date, email: String }
}

// Activity
lastLoginAt: Date
dataDownloadedAt: Date
loginSessions: [{
  device: String,
  ip: String,
  lastActivity: Date,
  createdAt: Date
}]
```

#### 2. **Extended Controllers** (`backend/controllers/userAccountDetailsController.js`)

New endpoints:

**Profile Management:**
- `PUT /api/user-account-details/:uid/profile` - Update profile
- `PUT /api/user-account-details/:uid/profile-image` - Update profile image URL

**Preferences:**
- `PUT /api/user-account-details/:uid/preferences/location-sharing` - Toggle location sharing

**Security:**
- `PUT /api/user-account-details/:uid/security/2fa` - Update 2FA setting
- `PUT /api/user-account-details/:uid/security/biometric` - Update biometric setting

**Session Management:**
- `GET /api/user-account-details/:uid/sessions` - Get login sessions
- `POST /api/user-account-details/:uid/sessions` - Add login session

**Social Accounts:**
- `POST /api/user-account-details/:uid/social-accounts/link` - Link social account
- `POST /api/user-account-details/:uid/social-accounts/unlink` - Unlink social account

**GDPR Compliance:**
- `GET /api/user-account-details/:uid/personal-data` - Download personal data

**Activity:**
- `PUT /api/user-account-details/:uid/last-login` - Update last login timestamp

#### 3. **Routes** (`backend/routes/userAccountDetailsRoutes.js`)

All new endpoints properly routed under `/api/user-account-details/`

## Data Flow

### Example: Updating Profile
1. User enters display name, bio, location in UI
2. Taps "Save Changes"
3. UI calls `context.read<AccountSettingsBloc>().add(UpdateProfileEvent(...))`
4. BLoC emits `loading` state
5. BLoC calls `userRepository.updateProfile(...)`
6. Repository updates:
   - Firestore document in `users/{uid}`
   - Firebase Auth displayName
7. Repository returns success/error
8. BLoC emits `success` or `failure` state
9. UI shows success/error snackbar

### Example: Uploading Profile Image
1. User taps profile picture
2. Image picker opens
3. User selects image from gallery
4. UI calls `UploadProfileImageEvent(File)`
5. BLoC calls `uploadProfileImage()`
6. Repository:
   - Uploads to `users/{uid}/profile.jpg` in Firebase Storage
   - Gets download URL
   - Updates `profileImageUrl` in Firestore
7. BLoC updates state with new image URL
8. UI displays new image

### Example: Deleting Account
1. User taps "Delete Account"
2. Confirmation dialog appears
3. User confirms
4. UI calls `DeleteAccountEvent(email, password)`
5. BLoC re-authenticates user (safety check)
6. BLoC calls `deleteAccountWithCleanup()`
7. Repository:
   - Deletes profile image from Cloud Storage
   - Deletes user document from Firestore
   - Deletes Firebase Auth user
8. BLoC emits `accountDeleted` state
9. UI navigates back to login screen

## Security Considerations

### ✅ Implemented:
1. **Re-authentication for Sensitive Operations**
   - Password changes require current password
   - Account deletion requires email + password verification

2. **Firestore Rules** (should be configured)
   ```
   match /users/{uid} {
     allow read: if request.auth.uid == uid;
     allow write: if request.auth.uid == uid;
   }
   ```

3. **Cloud Storage Rules**
   ```
   match /users/{uid}/{allPaths=**} {
     allow read, write: if request.auth.uid == uid;
   }
   ```

4. **Data Encryption**
   - All data in transit uses HTTPS
   - Sensitive data (passwords) never stored in Firestore
   - Profile images stored in Cloud Storage with proper access controls

### 🔄 Recommended Next Steps:
1. Implement email verification for email changes
2. Add rate limiting for password change attempts
3. Add audit logging for sensitive operations
4. Implement device tracking for login sessions
5. Add SMS/Email OTP for 2FA
6. Integrate OAuth providers (Google, Facebook)

## Testing Checklist

- [ ] Profile update persists and displays correctly
- [ ] Profile image uploads and displays
- [ ] Password change works with correct current password
- [ ] Password change fails with incorrect current password
- [ ] Location sharing toggle persists
- [ ] 2FA toggle persists
- [ ] Biometric toggle persists
- [ ] Personal data export downloads correctly
- [ ] Account deletion removes all data
- [ ] Login sessions display correctly
- [ ] Social account linking/unlinking works
- [ ] Error messages display appropriately
- [ ] Loading states show during operations

## Dependencies Added

### Frontend (`pubspec.yaml`):
- `firebase_storage: ^12.0.0` - For profile image uploads

### Backend (`package.json`):
- No new dependencies needed (uses existing Express, Mongoose)

## File Structure

```
lib/
├── blocs/
│   └── account_settings_bloc/
│       ├── account_settings_bloc.dart
│       ├── account_settings_event.dart
│       └── account_settings_state.dart
├── screens/
│   └── settings/
│       └── account_settings_screen.dart
packages/
└── user_repository/
    ├── lib/src/
    │   ├── entities/user_entity.dart (extended)
    │   ├── models/user.dart (extended)
    │   ├── user_repo.dart (extended)
    │   └── firebase_user_repo.dart (extended)
backend/
├── controllers/userAccountDetailsController.js (extended)
├── models/UserAccountDetails.js (extended)
└── routes/userAccountDetailsRoutes.js (extended)
```

## Usage Example

```dart
// Accessing the AccountSettingsBloc
class AccountSettingsScreen extends StatefulWidget {
  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountSettingsBloc, AccountSettingsState>(
      listener: (context, state) {
        if (state.status == AccountSettingsStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saved successfully!'))
          );
        }
      },
      child: BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                Switch(
                  value: state.locationSharingEnabled,
                  onChanged: (value) {
                    context.read<AccountSettingsBloc>().add(
                      UpdateLocationSharingEvent(value)
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

## Troubleshooting

### Firebase Version Conflicts
If you encounter Firebase dependency conflicts, ensure all Firebase packages are compatible:
- `firebase_core: ^3.6.0`
- `firebase_auth: ^5.3.1+`
- `cloud_firestore: ^5.4.4+`
- `firebase_storage: ^12.0.0+`

### Image Upload Issues
- Verify Cloud Storage bucket is configured in Firebase Console
- Check Storage Rules allow authenticated users to write
- Ensure file size is reasonable (< 5MB recommended)

### Re-authentication Failures
- Current password must be correct
- User must be currently authenticated
- Session might have expired (require re-login)

## Future Enhancements

1. **Two-Factor Authentication** - Implement SMS/Email OTP
2. **Social Account Integration** - Complete Google/Facebook OAuth flow
3. **Device Management** - Sign out from other devices
4. **Account Recovery** - Backup codes for 2FA
5. **Activity Log** - Detailed login history
6. **Export Formats** - Support CSV, XML export formats
7. **Privacy Controls** - Granular data sharing controls
8. **Account Linking** - Link multiple email accounts

---

**Last Updated:** March 22, 2026
**Status:** ✅ Core Implementation Complete

