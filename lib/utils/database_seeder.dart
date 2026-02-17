import '../core/services/supabase_service.dart';
import '../core/services/water_management_service.dart';
import '../core/services/composting_service.dart';
import '../core/services/soil_analysis_service.dart';
import '../features/chatbot/services/supabase_chat_history_service.dart';
import '../models/water_tank.dart';
import '../models/irrigation.dart';
import '../models/compost_batch.dart';
import '../models/sensor_data.dart';
import '../models/soil_analysis.dart';
import '../features/chatbot/models/chat_message.dart';

/// Database seeder for creating realistic test data
class DatabaseSeeder {
  static final _waterService = WaterManagementService();
  static final _compostService = CompostingService();
  static final _soilService = SoilAnalysisService();
  static final _chatService = ChatHistoryService();

  /// Seed all tables with realistic data
  static Future<void> seedAll() async {
    print('🌱 Starting database seeding...');

    try {
      // Ensure user is authenticated
      if (!SupabaseService.instance.isAuthenticated) {
        print('❌ User not authenticated. Please sign in first.');
        return;
      }

      print('✅ User authenticated: ${SupabaseService.instance.currentUserId}');

      // Seed in order
      await seedWaterTanks();
      await seedIrrigationSchedules();
      await seedIrrigationHistory();
      await seedCompostBatches();
      await seedSoilAnalyses();
      await seedChatMessages();

      print('✅ Database seeding completed successfully!');
    } catch (e) {
      print('❌ Seeding failed: $e');
      rethrow;
    }
  }

  /// Seed water tanks
  static Future<void> seedWaterTanks() async {
    print('💧 Seeding water tanks...');

    final tanks = [
      WaterTank(
        id: '',
        name: 'Ana Su Çəni',
        capacity: 5000.0,
        currentLevel: 3750.0, // 75%
        quality: WaterQuality.excellent,
        ph: 7.2,
        dissolvedOxygen: 8.5,
        nitrate: 12.5,
        electricalConductivity: 420.0,
        temperature: 22.5,
        turbidity: 1.8,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        autoIrrigate: true,
      ),
      WaterTank(
        id: '',
        name: 'Ehtiyat Çəni',
        capacity: 3000.0,
        currentLevel: 1200.0, // 40%
        quality: WaterQuality.good,
        ph: 7.5,
        dissolvedOxygen: 7.8,
        nitrate: 18.3,
        electricalConductivity: 485.0,
        temperature: 23.1,
        turbidity: 2.5,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        autoIrrigate: false,
      ),
      WaterTank(
        id: '',
        name: 'Günəş Sistemli Çən',
        capacity: 2000.0,
        currentLevel: 1800.0, // 90%
        quality: WaterQuality.excellent,
        ph: 6.9,
        dissolvedOxygen: 9.2,
        nitrate: 10.1,
        electricalConductivity: 390.0,
        temperature: 21.8,
        turbidity: 1.2,
        lastUpdated: DateTime.now(),
        autoIrrigate: true,
      ),
    ];

    for (final tank in tanks) {
      await _waterService.createTank(tank);
    }

    print('✅ Created ${tanks.length} water tanks');
  }

  /// Seed irrigation schedules
  static Future<void> seedIrrigationSchedules() async {
    print('⏰ Seeding irrigation schedules...');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final schedules = [
      IrrigationSchedule(
        id: '',
        scheduledTime: today.add(const Duration(hours: 6)),
        duration: 15,
        isActive: true,
        zone: 'Zona A - Tərəvəz bağı',
      ),
      IrrigationSchedule(
        id: '',
        scheduledTime: today.add(const Duration(hours: 18)),
        duration: 20,
        isActive: true,
        zone: 'Zona B - Meyvə bağı',
      ),
      IrrigationSchedule(
        id: '',
        scheduledTime: today.add(const Duration(hours: 7)),
        duration: 12,
        isActive: true,
        zone: 'Zona C - İstixana',
      ),
      IrrigationSchedule(
        id: '',
        scheduledTime: today.add(const Duration(hours: 19)),
        duration: 18,
        isActive: true,
        zone: 'Zona C - İstixana',
      ),
    ];

    for (final schedule in schedules) {
      await _waterService.createSchedule(schedule);
    }

    print('✅ Created ${schedules.length} irrigation schedules');
  }

  /// Seed irrigation history
  static Future<void> seedIrrigationHistory() async {
    print('📊 Seeding irrigation history...');

    final now = DateTime.now();
    final events = <IrrigationEvent>[];

    // Create 14 days of history
    for (int i = 0; i < 14; i++) {
      final day = now.subtract(Duration(days: i));
      
      // Morning irrigation
      events.add(
        IrrigationEvent(
          id: '',
          startTime: DateTime(day.year, day.month, day.day, 6, 0),
          endTime: DateTime(day.year, day.month, day.day, 6, 15),
          duration: 15,
          waterUsed: 45.0 + (i % 5) * 3.0,
          zone: 'Zona A - Tərəvəz bağı',
          isAutomatic: true,
        ),
      );

      // Evening irrigation
      events.add(
        IrrigationEvent(
          id: '',
          startTime: DateTime(day.year, day.month, day.day, 18, 0),
          endTime: DateTime(day.year, day.month, day.day, 18, 20),
          duration: 20,
          waterUsed: 60.0 + (i % 7) * 4.0,
          zone: 'Zona B - Meyvə bağı',
          isAutomatic: true,
        ),
      );

      // Greenhouse irrigation
      if (i % 2 == 0) {
        events.add(
          IrrigationEvent(
            id: '',
            startTime: DateTime(day.year, day.month, day.day, 7, 30),
            endTime: DateTime(day.year, day.month, day.day, 7, 42),
            duration: 12,
            waterUsed: 36.0 + (i % 4) * 2.5,
            zone: 'Zona C - İstixana',
            isAutomatic: true,
          ),
        );
      }
    }

    for (final event in events) {
      await _waterService.createEvent(event);
    }

    print('✅ Created ${events.length} irrigation events');
  }

  /// Seed compost batches
  static Future<void> seedCompostBatches() async {
    print('🌿 Seeding compost batches...');

    final now = DateTime.now();

    // Active batch
    final activeBatch = CompostBatch(
      id: '',
      batchNumber: 'KB-2024-12-001',
      startDate: now.subtract(const Duration(days: 15)),
      status: CompostStatus.active,
      initialWeight: 250.0,
      currentWeight: 195.0,
      notes: 'Tərəvəz tullantıları və ot qalıqları qarışığı',
    );

    final activeBatchId = (await _compostService.createBatch(activeBatch)).id;

    // Add sensor readings for active batch
    final readings = <SensorData>[];
    for (int i = 0; i < 15; i++) {
      final day = now.subtract(Duration(days: 14 - i));
      
      // Temperature decreases over time (60°C → 45°C)
      final temp = 60.0 - (i * 1.0) + (i % 3 - 1) * 2.0;
      
      // Humidity increases slightly (55% → 65%)
      final humidity = 55.0 + (i * 0.7) + (i % 2) * 2.0;
      
      // CO2 varies
      final co2 = 450.0 + (i % 5) * 50.0;
      
      // Weight decreases
      final weight = 250.0 - (i * 3.5);

      readings.add(
        SensorData(
          id: '',
          timestamp: DateTime(day.year, day.month, day.day, 12, 0),
          temperature: temp,
          humidity: humidity,
          co2Level: co2,
          weight: weight,
          ph: 6.8 + (i % 4) * 0.1,
          moisture: humidity * 0.9,
          sensorType: 'compost',
        ),
      );
    }

    for (final reading in readings) {
      await _compostService.addSensorReading(
        batchId: activeBatchId,
        reading: reading,
      );
    }

    // Curing batch
    final curingBatch = CompostBatch(
      id: '',
      batchNumber: 'KB-2024-11-003',
      startDate: now.subtract(const Duration(days: 45)),
      endDate: now.subtract(const Duration(days: 15)),
      status: CompostStatus.curing,
      initialWeight: 300.0,
      currentWeight: 180.0,
      finalWeight: 175.0,
      notes: 'Meyvə qalıqları və bağ tullantıları',
    );

    await _compostService.createBatch(curingBatch);

    // Ready batch
    final readyBatch = CompostBatch(
      id: '',
      batchNumber: 'KB-2024-10-002',
      startDate: now.subtract(const Duration(days: 75)),
      endDate: now.subtract(const Duration(days: 30)),
      status: CompostStatus.ready,
      initialWeight: 280.0,
      currentWeight: 165.0,
      finalWeight: 165.0,
      rating: 5,
      notes: 'Yüksek keyfiyyətli kompost, istifadəyə hazır',
    );

    await _compostService.createBatch(readyBatch);

    // Harvested batch
    final harvestedBatch = CompostBatch(
      id: '',
      batchNumber: 'KB-2024-09-001',
      startDate: now.subtract(const Duration(days: 105)),
      endDate: now.subtract(const Duration(days: 60)),
      status: CompostStatus.harvested,
      initialWeight: 320.0,
      finalWeight: 185.0,
      rating: 4,
      notes: 'Bağda istifadə edildi',
    );

    await _compostService.createBatch(harvestedBatch);

    print('✅ Created 4 compost batches with sensor data');
  }

  /// Seed soil analyses
  static Future<void> seedSoilAnalyses() async {
    print('🌱 Seeding soil analyses...');

    final now = DateTime.now();

    final analyses = [
      // Latest analysis - Healthy soil
      SoilAnalysis(
        id: '',
        timestamp: now.subtract(const Duration(days: 2)),
        healthScore: 85.5,
        nitrogen: 3.2,
        phosphorus: 2.8,
        potassium: 3.5,
        ph: 6.8,
        moisture: 55.0,
        organicMatter: 4.5,
        temperature: 22.0,
        recommendations: [
          'Torpaq sağlamlığı əla səviyyədədir',
          'Nitrogen səviyyəsi optimaldır',
          'Rütubət müntəzəm saxlanmalıdır',
          'pH balansı ideal aralıqdadır',
        ],
        health: SoilHealth.healthy,
      ),

      // 1 week ago - Moderate
      SoilAnalysis(
        id: '',
        timestamp: now.subtract(const Duration(days: 7)),
        healthScore: 72.3,
        nitrogen: 2.5,
        phosphorus: 2.2,
        potassium: 2.8,
        ph: 6.5,
        moisture: 45.0,
        organicMatter: 3.8,
        temperature: 21.5,
        recommendations: [
          'Nitrogen səviyyəsi yüksəldilməlidir',
          'Kompost əlavə edilməsi tövsiyə olunur',
          'Suvarma tezliyini artırın',
        ],
        health: SoilHealth.moderate,
      ),

      // 2 weeks ago
      SoilAnalysis(
        id: '',
        timestamp: now.subtract(const Duration(days: 14)),
        healthScore: 68.0,
        nitrogen: 2.1,
        phosphorus: 1.9,
        potassium: 2.5,
        ph: 6.3,
        moisture: 40.0,
        organicMatter: 3.2,
        temperature: 20.8,
        recommendations: [
          'Üzvi gübrə tətbiq edilməlidir',
          'pH səviyyəsi yüksəldilməlidir',
          'Rütubət artırılmalıdır',
        ],
        health: SoilHealth.moderate,
      ),

      // 1 month ago - Before improvement
      SoilAnalysis(
        id: '',
        timestamp: now.subtract(const Duration(days: 30)),
        healthScore: 58.5,
        nitrogen: 1.8,
        phosphorus: 1.5,
        potassium: 2.0,
        ph: 6.0,
        moisture: 35.0,
        organicMatter: 2.5,
        temperature: 19.5,
        recommendations: [
          'Təcili üzvi gübrə lazımdır',
          'Kompost əlavə edin',
          'Suvarma sistemini təkmilləşdirin',
          'pH balansını nizamlayın',
        ],
        health: SoilHealth.unhealthy,
      ),
    ];

    for (final analysis in analyses) {
      await _soilService.createAnalysis(analysis);
    }

    print('✅ Created ${analyses.length} soil analyses');
  }

  /// Seed chat messages
  static Future<void> seedChatMessages() async {
    print('💬 Seeding chat messages...');

    final now = DateTime.now();

    final messages = [
      // Welcome message
      ChatMessage(
        id: '',
        content:
            '🌾 Salam! Mən EcoKöməkçiyəm.\n\nKənd təsərrüfatı, torpaq sağlamlığı, suvarma və kompost haqqında suallarınıza cavab verməyə hazıram. Necə kömək edə bilərəm?',
        role: MessageRole.assistant,
        timestamp: now.subtract(const Duration(days: 5)),
      ),

      // User question 1
      ChatMessage(
        id: '',
        content: 'Kompost hazırlama prosesi nə qədər vaxt aparır?',
        role: MessageRole.user,
        timestamp: now.subtract(const Duration(days: 5, hours: -1)),
      ),

      // AI response 1
      ChatMessage(
        id: '',
        content:
            'Kompost hazırlama prosesi adətən 4-8 həftə arası vaxt aparır. Bu müddət bir neçə amilə bağlıdır:\n\n1. **Material qarışığı**: Yaşıl (azotlu) və qonur (karbonlu) materialların düzgün nisbəti (1:3)\n2. **Rütubət**: 50-60% rütubət optimal səviyyədir\n3. **Havalandırma**: Həftədə 1-2 dəfə qarışdırmaq lazımdır\n4. **Temperatura**: 55-65°C ideal temperatur aralığıdır\n\nSizin cari "KB-2024-12-001" partiyası 15 gündür fəaliyyətdədir və normal inkişaf göstərir. Temperatur 60°C-dən 45°C-ə düşüb ki, bu da normal prosesdir.',
        role: MessageRole.assistant,
        timestamp: now.subtract(const Duration(days: 5, hours: -2)),
      ),

      // User question 2
      ChatMessage(
        id: '',
        content: 'Su çənlərimin su keyfiyyəti necədir?',
        role: MessageRole.user,
        timestamp: now.subtract(const Duration(days: 3)),
      ),

      // AI response 2
      ChatMessage(
        id: '',
        content:
            'Su çənlərinizin keyfiyyəti əladır! 💧\n\n**Ana Su Çəni**: Əla keyfiyyət\n- pH: 7.2 (ideal aralıqda)\n- Həll olmuş oksigen: 8.5 mg/L (yüksək)\n- Nitrat: 12.5 mg/L (təhlükəsiz)\n\n**Ehtiyat Çəni**: Yaxşı keyfiyyət  \n- pH: 7.5 (qəbul ediləndir)\n- Həll olmuş oksigen: 7.8 mg/L\n\n**Günəş Sistemli Çən**: Əla keyfiyyət\n- pH: 6.9 (ideal)\n- Həll olmuş oksigen: 9.2 mg/L (çox yaxşı)\n\nBütün çənlər suvarma üçün təhlükəsizdir. Avtomatik suvarma sistemləri aktiv işləyir.',
        role: MessageRole.assistant,
        timestamp: now.subtract(const Duration(days: 3, hours: -1)),
      ),

      // User question 3
      ChatMessage(
        id: '',
        content: 'Torpağımın sağlamlığını necə yaxşılaşdıra bilərəm?',
        role: MessageRole.user,
        timestamp: now.subtract(const Duration(days: 1)),
      ),

      // AI response 3
      ChatMessage(
        id: '',
        content:
            'Son torpaq analiziniz (2 gün əvvəl) əla nəticələr göstərir! 🌱\n\n**Cari vəziyyət**: 85.5/100 - Sağlam torpaq\n\n**Mövcud güclü tərəflər**:\n- Nitrogen: 3.2% (optimal)\n- pH: 6.8 (ideal)\n- Üzvi maddə: 4.5% (əla)\n\n**Təkmilləşdirmə üçün tövsiyələr**:\n1. Hazır kompostunuzu (KB-2024-10-002) tətbiq edin\n2. Rütubəti 55-60% səviyyəsində saxlayın\n3. Növbəli əkinlə torpaq məhsuldarlığını artırın\n4. Fos for səviyyəsini 3.0%-ə çatdırmaq üçün təbii gübrələrdən istifadə edin\n\nSon 1 ayda 27 xal təkmilləşmə olub - əla nəticədir! 📈',
        role: MessageRole.assistant,
        timestamp: now.subtract(const Duration(days: 1, hours: -1)),
      ),
    ];

    for (final message in messages) {
      await _chatService.saveMessage(message);
    }

    print('✅ Created ${messages.length} chat messages');
  }

  /// Clear all data (for testing)
  static Future<void> clearAllData() async {
    print('🗑️  Clearing all data...');

    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) {
      print('❌ User not authenticated');
      return;
    }

    try {
      // Clear using Supabase client directly
      final client = SupabaseService.instance.client;

      await client.from('chat_messages').delete().eq('user_id', userId);
      await client.from('soil_analyses').delete().eq('user_id', userId);
      await client.from('sensor_data').delete().eq('user_id', userId);
      await client.from('compost_batches').delete().eq('user_id', userId);
      await client.from('irrigation_events').delete().eq('user_id', userId);
      await client
          .from('irrigation_schedules')
          .delete()
          .eq('user_id', userId);
      await client.from('water_tanks').delete().eq('user_id', userId);

      print('✅ All data cleared');
    } catch (e) {
      print('❌ Failed to clear data: $e');
      rethrow;
    }
  }
}
