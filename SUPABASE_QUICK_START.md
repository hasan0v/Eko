# EcoBin Supabase Quick Start Guide 🚀

## What Changed?

Your EcoBin app now uses **Supabase** (cloud PostgreSQL database) instead of local Hive storage!

## Benefits:
✅ Data syncs across all devices (web, Android, iOS)  
✅ Real-time updates  
✅ Never lose data (cloud backup)  
✅ Free for development  
✅ Production-ready scalability  

---

## Run the App

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on emulator
flutter run

# 3. Or build APK for Android
flutter build apk --release
```

---

## How It Works Now

### 🔐 Authentication
- App signs in **anonymously** on startup
- Each device gets a unique user ID
- All data is private to that user

### 💾 Data Storage
- **Chat messages** → Saved to cloud instantly
- **Water tanks** → Real-time monitoring
- **Compost batches** → Cloud tracking
- **Soil analyses** → Persistent storage

### 🌐 Cross-Platform
Works perfectly on:
- ✅ Web (already deployed: https://ecobin-nicat.web.app)
- ✅ Android (APK ready)
- ✅ iOS (when you build)
- ✅ Desktop (future)

---

## Testing Checklist

### 1. Test Chat History
- [ ] Open AI chatbot
- [ ] Send a message
- [ ] Close app completely
- [ ] Reopen app
- [ ] Check chat history - message should still be there! ✨

### 2. Test Water Management  
- [ ] View water tank
- [ ] Toggle auto-irrigation
- [ ] Create irrigation schedule
- [ ] Close/reopen app
- [ ] Settings should persist

### 3. Test Composting
- [ ] Create new batch
- [ ] Add sensor reading
- [ ] View active batches
- [ ] Data saves to cloud

---

## Database Access

**View Your Data:**
1. Go to https://supabase.com/dashboard
2. Login with your account
3. Select project: "EcoBin Smart Farming"
4. Click "Table Editor" to see all your data!

**Tables:**
- profiles
- chat_messages  
- water_tanks
- irrigation_schedules
- irrigation_events
- compost_batches
- sensor_data
- soil_analyses

---

## Configuration

**Supabase URL:** https://txbwrqlwcqvnzkhytbdq.supabase.co  
**Project ID:** txbwrqlwcqvnzkhytbdq  
**Region:** Europe (Ireland)  

All credentials are in:
`lib/core/config/supabase_config.dart`

---

## Migration Notes

### ✅ What Was Added
- Supabase Flutter package
- Cloud database services
- Real-time data sync
- Secure authentication

### ❌ What Was Removed  
- Hive local database
- Old chat history service
- Database seeder files

### ⚠️ Important
Old local data **was not** migrated. This is a fresh start with cloud storage.

---

## Troubleshooting

**App won't build?**
```bash
flutter clean
flutter pub get
flutter run
```

**No internet warning?**
- Supabase requires internet
- Check network connection
- Verify firewall settings

**Data not saving?**
- Check console for errors
- Verify authentication status
- Check Supabase dashboard logs

---

## Next Steps

### Want Email/Password Login?
Edit `lib/main.dart`, replace:
```dart
await SupabaseService.instance.signInAnonymously();
```

With:
```dart
await SupabaseService.instance.signInWithEmail(
  email: 'user@example.com',
  password: 'password123',
);
```

### Want Real-Time Features?
Use `.stream()` in services:
```dart
waterService.watchTanks().listen((tanks) {
  // Auto-updates when data changes!
});
```

### Want File Uploads?
Supabase has built-in storage:
```dart
final file = await FilePicker.getFile();
await supabase.storage.from('avatars').upload('path', file);
```

---

## Resources

📚 **Supabase Docs:** https://supabase.com/docs  
🎓 **Flutter Tutorial:** https://supabase.com/docs/guides/getting-started/tutorials/with-flutter  
💬 **Community:** https://discord.supabase.com  
📊 **Dashboard:** https://supabase.com/dashboard/project/txbwrqlwcqvnzkhytbdq  

---

## Summary

Your EcoBin app is now:
- ☁️ Cloud-powered
- 🔄 Real-time capable  
- 🔐 Secure with RLS
- 🌍 Cross-platform ready
- 💰 Free to use (Free Tier)

**You're ready to farm smart! 🌾🚜**

---

Need help? Check [SUPABASE_MIGRATION_COMPLETE.md](./SUPABASE_MIGRATION_COMPLETE.md) for full details!
