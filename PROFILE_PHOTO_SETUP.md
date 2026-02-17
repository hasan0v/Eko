# Profile Photo Setup

## ✅ Supabase Storage Configuration

The app is now configured to upload profile photos to Supabase Storage.

### Storage Bucket
- **Bucket Name**: `avatars`
- **Public Access**: Enabled
- **File Size Limit**: 5MB
- **Allowed Types**: JPEG, JPG, PNG, WEBP

### Upload Flow

1. **Registration**: User can select a photo during registration
2. **Upload Process**:
   - Photo is read as bytes from local device
   - Uploaded to: `avatars/profile-photos/{user_id}/{timestamp}-{filename}`
   - Public URL is returned and saved to database
3. **Database Storage**: Photo URL saved in `profiles.photo_url` column
4. **Display**: Home screen shows profile photo from URL

### Security Policies

- ✅ Users can only upload to their own folder (`profile-photos/{their_user_id}/`)
- ✅ Users can update/delete their own photos
- ✅ Public can view all avatars (read-only)
- ✅ Authenticated users required for uploads

### Testing

**Test User Credentials**:
- Email: `test@ecobin.app`
- Password: `testpassword123`

**To Test Profile Upload**:
1. Register a new account
2. Select profile photo in step 1
3. Photo will be uploaded to Supabase Storage
4. Photo URL will be displayed on home screen

### Technical Details

**Files Modified**:
- `lib/core/services/supabase_service.dart` - Added upload methods
- `lib/features/auth/data/auth_repository.dart` - Integrated upload in registration
- `lib/features/dashboard/screens/home_screen.dart` - Display profile photo

**Storage Path Structure**:
```
avatars/
  └── profile-photos/
      └── {user_id}/
          └── {timestamp}-{filename}
```
