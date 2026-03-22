# Quick Start Guide - Account Settings Implementation

## 🚀 Quick Integration Steps

### Step 1: Import the BLoC
```dart
import 'package:voyant/blocs/account_settings_bloc/account_settings_bloc.dart';
```

### Step 2: Provide the BLoC in Your Widget Tree
In your main app or relevant screen:

```dart
BlocProvider(
  create: (context) => AccountSettingsBloc(
    userRepository: context.read<UserRepository>(),
  ),
  child: const AccountSettingsScreen(),
)
```

### Step 3: Use the Screen
The `AccountSettingsScreen` is already fully integrated and ready to use:

```dart
import 'package:voyant/screens/settings/account_settings_screen.dart';

// In your navigation:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AccountSettingsScreen(),
  ),
);
```

---

## 📱 Available Features

### Profile Management
```dart
// Update profile information
context.read<AccountSettingsBloc>().add(
  UpdateProfileEvent(
    displayName: 'John Doe',
    bio: 'Adventure seeker',
    location: 'San Francisco',
  ),
);

// Upload profile image
context.read<AccountSettingsBloc>().add(
  UploadProfileImageEvent(imageFile),
);
```

### Security
```dart
// Change password
context.read<AccountSettingsBloc>().add(
  ChangePasswordEvent(
    email: 'user@example.com',
    currentPassword: 'old_password',
    newPassword: 'new_password',
  ),
);

// Delete account
context.read<AccountSettingsBloc>().add(
  DeleteAccountEvent(
    email: 'user@example.com',
    password: 'current_password',
  ),
);
```

### Preferences
```dart
// Toggle location sharing
context.read<AccountSettingsBloc>().add(
  UpdateLocationSharingEvent(true),
);
```

### Security Settings
```dart
// Enable 2FA
context.read<AccountSettingsBloc>().add(
  UpdateTwoFAEvent(true),
);

// Enable biometric login
context.read<AccountSettingsBloc>().add(
  UpdateBiometricEvent(true),
);
```

### Data & Activity
```dart
// Download personal data
context.read<AccountSettingsBloc>().add(
  const DownloadPersonalDataEvent(),
);

// Get login sessions
context.read<AccountSettingsBloc>().add(
  const GetLoginSessionsEvent(),
);
```

### Social Accounts
```dart
// Link social account
context.read<AccountSettingsBloc>().add(
  LinkSocialAccountEvent(
    provider: 'google',
    accessToken: 'oauth_token',
  ),
);

// Unlink social account
context.read<AccountSettingsBloc>().add(
  UnlinkSocialAccountEvent('facebook'),
);
```

---

## 🎨 Listening to State Changes

### Using BlocListener
```dart
BlocListener<AccountSettingsBloc, AccountSettingsState>(
  listener: (context, state) {
    if (state.status == AccountSettingsStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved successfully!')),
      );
    } else if (state.status == AccountSettingsStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.errorMessage}')),
      );
    }
  },
  child: YourWidget(),
)
```

### Using BlocBuilder
```dart
BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
  builder: (context, state) {
    if (state.status == AccountSettingsStatus.loading) {
      return const CircularProgressIndicator();
    }
    
    return Column(
      children: [
        Text('Location Sharing: ${state.locationSharingEnabled}'),
        Text('2FA: ${state.twoFactorEnabled}'),
        Text('Biometric: ${state.biometricLoginEnabled}'),
      ],
    );
  },
)
```

---

## 🔧 Backend API Endpoints

All endpoints are under `/api/user-account-details/`

### Profile
- `PUT /:uid/profile` - Update profile
- `PUT /:uid/profile-image` - Update image URL

### Preferences
- `PUT /:uid/preferences/location-sharing` - Toggle location sharing

### Security
- `PUT /:uid/security/2fa` - Update 2FA
- `PUT /:uid/security/biometric` - Update biometric

### Sessions
- `GET /:uid/sessions` - Get login sessions
- `POST /:uid/sessions` - Add new session

### Social Accounts
- `POST /:uid/social-accounts/link` - Link account
- `POST /:uid/social-accounts/unlink` - Unlink account

### Data
- `GET /:uid/personal-data` - Download personal data
- `PUT /:uid/last-login` - Update last login

---

## 📊 State Properties

```dart
class AccountSettingsState {
  // Status
  final AccountSettingsStatus status;
  
  // Profile
  final String? displayName;
  final String? bio;
  final String? location;
  final String? profileImageUrl;
  
  // Preferences
  final bool locationSharingEnabled;
  
  // Security
  final bool twoFactorEnabled;
  final bool biometricLoginEnabled;
  
  // Data
  final String? errorMessage;
  final String? downloadedData;
  final List<Map<String, dynamic>>? loginSessions;
}
```

---

## ✅ Tested & Ready

- ✅ BLoC implementation verified with `dart analyze`
- ✅ All 11 event handlers implemented
- ✅ All 5 status states configured
- ✅ Firebase integration complete
- ✅ Backend endpoints configured
- ✅ Error handling included
- ✅ Loading states implemented

---

## 🐛 Troubleshooting

### "BLoC not found" error
Make sure to wrap your widget with `BlocProvider`:
```dart
BlocProvider(
  create: (context) => AccountSettingsBloc(
    userRepository: context.read<UserRepository>(),
  ),
  child: const AccountSettingsScreen(),
)
```

### Image upload fails
1. Check Firebase Cloud Storage is enabled
2. Verify Storage Rules allow authenticated users
3. Ensure file size < 5MB
4. Check user is authenticated

### Password change fails
1. Verify current password is correct
2. Ensure user is currently logged in
3. Check email address matches
4. Verify new password meets requirements

### Data export returns empty
1. Make sure user is authenticated
2. Check Firestore has user document
3. Verify read permissions
4. Check user UID is correct

---

## 📚 Additional Resources

- **Full Documentation**: See `ACCOUNT_SETTINGS_IMPLEMENTATION.md`
- **Summary**: See `IMPLEMENTATION_SUMMARY.md`
- **BLoC Pattern Guide**: [flutter_bloc documentation](https://bloclibrary.dev)
- **Firebase Auth**: [Firebase Docs](https://firebase.google.com/docs/auth)
- **Firestore**: [Cloud Firestore Docs](https://firebase.google.com/docs/firestore)

---

## 🎯 Common Use Cases

### Use Case 1: User Updates Profile
```dart
final bloc = context.read<AccountSettingsBloc>();

// User fills form and taps save
bloc.add(UpdateProfileEvent(
  displayName: nameController.text,
  bio: bioController.text,
  location: locationController.text,
));

// Listen for result
if (state.status == AccountSettingsStatus.success) {
  showSuccessSnackbar();
}
```

### Use Case 2: User Changes Password
```dart
final bloc = context.read<AccountSettingsBloc>();

// After showing password dialog
bloc.add(ChangePasswordEvent(
  email: user.email,
  currentPassword: currentPassword,
  newPassword: newPassword,
));
```

### Use Case 3: User Deletes Account
```dart
final bloc = context.read<AccountSettingsBloc>();

// After confirmation dialog
bloc.add(DeleteAccountEvent(
  email: user.email,
  password: confirmPassword,
));

// Navigate back to login
if (state.status == AccountSettingsStatus.accountDeleted) {
  Navigator.popUntil(context, (route) => route.isFirst);
}
```

---

**Need help?** Check the full implementation guide for more details!

