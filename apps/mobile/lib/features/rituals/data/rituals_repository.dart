import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/providers.dart';
import '../domain/ritual.dart';

part 'rituals_repository.g.dart';

// Stub data used until the API is wired in.
const _mockRituals = [
  Ritual(
    id: '1',
    name: 'Diwali Lakshmi Puja',
    nameHi: 'दीवाली लक्ष्मी पूजा',
    category: RitualCategory.festival,
    tradition: RitualTradition.north,
    isLocked: false,
    description: 'Worship of Goddess Lakshmi on the night of Diwali.',
    durationMinutes: 60,
  ),
  Ritual(
    id: '2',
    name: 'Ganesh Chaturthi Puja',
    nameHi: 'गणेश चतुर्थी पूजा',
    category: RitualCategory.festival,
    tradition: RitualTradition.south,
    isLocked: false,
    description: 'Celebration of Lord Ganesha\'s birth.',
    durationMinutes: 90,
  ),
  Ritual(
    id: '3',
    name: 'Navratri Vrat',
    nameHi: 'नवरात्रि व्रत',
    category: RitualCategory.festival,
    tradition: RitualTradition.north,
    isLocked: true,
    description: 'Nine nights of fasting and worship of Goddess Durga.',
    durationMinutes: 45,
  ),
  Ritual(
    id: '4',
    name: 'Onam Puja',
    nameHi: null,
    category: RitualCategory.festival,
    tradition: RitualTradition.south,
    isLocked: true,
    description: 'Harvest festival celebrating King Mahabali\'s return.',
    durationMinutes: 30,
  ),
  Ritual(
    id: '5',
    name: 'Vivah Sanskar',
    nameHi: 'विवाह संस्कार',
    category: RitualCategory.lifecycle,
    tradition: RitualTradition.north,
    isLocked: false,
    description: 'Sacred marriage ceremony.',
    durationMinutes: 180,
  ),
  Ritual(
    id: '6',
    name: 'Namakarana',
    nameHi: 'नामकरण',
    category: RitualCategory.lifecycle,
    tradition: RitualTradition.south,
    isLocked: false,
    description: 'Naming ceremony for a newborn.',
    durationMinutes: 45,
  ),
  Ritual(
    id: '7',
    name: 'Annaprashan',
    nameHi: 'अन्नप्राशन',
    category: RitualCategory.lifecycle,
    tradition: RitualTradition.east,
    isLocked: true,
    description: 'First rice-feeding ceremony for an infant.',
    durationMinutes: 60,
  ),
  Ritual(
    id: '8',
    name: 'Somvati Amavasya',
    nameHi: 'सोमवती अमावस्या',
    category: RitualCategory.monthly,
    tradition: RitualTradition.north,
    isLocked: false,
    description: 'New moon falling on a Monday — sacred for ancestral rites.',
    durationMinutes: 30,
  ),
  Ritual(
    id: '9',
    name: 'Ekadashi Vrat',
    nameHi: 'एकादशी व्रत',
    category: RitualCategory.monthly,
    tradition: RitualTradition.north,
    isLocked: false,
    description: 'Fasting on the eleventh day of each lunar fortnight.',
    durationMinutes: 20,
  ),
  Ritual(
    id: '10',
    name: 'Pradosh Vrat',
    nameHi: 'प्रदोष व्रत',
    category: RitualCategory.monthly,
    tradition: RitualTradition.south,
    isLocked: true,
    description: 'Worship of Lord Shiva on the thirteenth day.',
    durationMinutes: 40,
  ),
  Ritual(
    id: '11',
    name: 'Makar Sankranti Puja',
    nameHi: 'मकर संक्रान्ति पूजा',
    category: RitualCategory.seasonal,
    tradition: RitualTradition.north,
    isLocked: false,
    description: 'Sun\'s entry into Capricorn — harvest festival.',
    durationMinutes: 30,
  ),
  Ritual(
    id: '12',
    name: 'Vasant Panchami',
    nameHi: 'वसन्त पञ्चमी',
    category: RitualCategory.seasonal,
    tradition: RitualTradition.north,
    isLocked: false,
    description: 'Worship of Goddess Saraswati at the start of spring.',
    durationMinutes: 45,
  ),
  Ritual(
    id: '13',
    name: 'Paryushana',
    nameHi: 'पर्युषण',
    category: RitualCategory.festival,
    tradition: RitualTradition.jain,
    isLocked: true,
    description: 'Eight-day festival of fasting and reflection.',
    durationMinutes: 60,
  ),
  Ritual(
    id: '14',
    name: 'Gurpurab',
    nameHi: 'ਗੁਰਪੁਰਬ',
    category: RitualCategory.festival,
    tradition: RitualTradition.sikh,
    isLocked: false,
    description: 'Celebration of a Sikh Guru\'s birthday.',
    durationMinutes: 120,
  ),
];

class RitualsRepository {
  const RitualsRepository(this._client);

  final dynamic _client;

  Future<List<Ritual>> fetchRituals({
    required RitualCategory category,
    RitualTradition? tradition,
    String? query,
  }) async {
    // TODO(dev): Replace with real API call:
    // final response = await _client.get<List<dynamic>>(
    //   '/rituals',
    //   queryParameters: {
    //     'category': category.name,
    //     if (tradition != null) 'tradition': tradition.name,
    //     if (query != null && query.isNotEmpty) 'q': query,
    //   },
    // );
    // return (response.data as List)
    //     .map((j) => Ritual.fromJson(j as Map<String, dynamic>))
    //     .toList();

    await Future<void>.delayed(const Duration(milliseconds: 600));

    var results = _mockRituals.where((r) => r.category == category);

    if (tradition != null) {
      results = results.where((r) => r.tradition == tradition);
    }

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      results = results.where(
        (r) =>
            r.name.toLowerCase().contains(q) ||
            (r.nameHi?.contains(q) ?? false),
      );
    }

    return results.toList();
  }
}

@riverpod
RitualsRepository ritualsRepository(RitualsRepositoryRef ref) =>
    RitualsRepository(ref.watch(dioClientProvider));
