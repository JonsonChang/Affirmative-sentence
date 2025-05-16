import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:affirmative_sentence/l10n/app_localizations.dart';
import 'package:hive/hive.dart';

part 'affirmations_screen.g.dart';

@HiveType(typeId: 2)
class Affirmation {
  @HiveField(0)
  String text;
  @HiveField(1)
  bool isEnabled;

  Affirmation(this.text, {this.isEnabled = true});

  Map<String, dynamic> toJson() => {
        'text': text,
        'isEnabled': isEnabled,
      };

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    return Affirmation(
      json['text'],
      isEnabled: json['isEnabled'] ?? true,
    );
  }
}

@HiveType(typeId: 3)
class AffirmationGroup {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<Affirmation> affirmations;

  AffirmationGroup(this.name, {List<Affirmation>? affirmations})
      : affirmations = affirmations ?? [];

  Map<String, dynamic> toJson() => {
        'name': name,
        'affirmations': affirmations.map((a) => a.toJson()).toList(),
      };

  factory AffirmationGroup.fromJson(Map<String, dynamic> json) {
    return AffirmationGroup(
      json['name'],
      affirmations: (json['affirmations'] as List)
          .map((a) => Affirmation.fromJson(a))
          .toList(),
    );
  }
}

class AffirmationsScreen extends StatefulWidget {
  const AffirmationsScreen({super.key});

  @override
  State<AffirmationsScreen> createState() => _AffirmationsScreenState();
}

class _AffirmationsScreenState extends State<AffirmationsScreen> {
  List<AffirmationGroup> _groups = [];
  bool _isLoading = true;

  Future<Box<AffirmationGroup>> _getBox() async {
    return await Hive.openBox<AffirmationGroup>('affirmation_groups');
  }

  Future<void> _loadAffirmations(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final box = await _getBox();

      if (box.isEmpty) {
        // 如果Hive中沒有數據，從assets讀取初始數據
        final file = 'assets/affirmations.json';
        final data = await rootBundle.loadString(file);
        _groups = (json.decode(data)['categories'] as List)
            .map((g) => AffirmationGroup.fromJson(g))
            .toList();
        
        // 將初始數據存入Hive
        await box.addAll(_groups);
      } else {
        // 從Hive讀取數據
        _groups = box.values.toList();
      }
    } catch (e) {
      _groups = [];
    }

    setState(() => _isLoading = false);
  }

  Future<void> _persistGroup(int index) async {
    final box = await _getBox();
    await box.putAt(index, _groups[index]);
  }

  void _addGroup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.addGroup),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: S.of(context)!.groupName),
          onSubmitted: (text) async {
            if (text.isNotEmpty) {
              final box = await _getBox();
              final newGroup = AffirmationGroup(text);

              setState(() => _groups.add(newGroup));
              await box.add(newGroup);

              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _editGroup(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.editGroup),
        content: TextField(
          autofocus: true,
          controller: TextEditingController(text: _groups[index].name),
          decoration: InputDecoration(hintText: S.of(context)!.groupName),
          onSubmitted: (name) async {
            if (name.isNotEmpty) {
              setState(() => _groups[index].name = name);
              await _persistGroup(index);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _deleteGroup(int index) async {
    final box = await _getBox();
    setState(() => _groups.removeAt(index));
    await box.deleteAt(index);
  }

  void _addAffirmation(int groupIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.add),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: S.of(context)!.affirmationText),
          onSubmitted: (text) async {
            if (text.isNotEmpty) {
              final newAffirmation = Affirmation(text);
              setState(() => _groups[groupIndex].affirmations.add(newAffirmation));
              await _persistGroup(groupIndex);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _editAffirmation(int groupIndex, int affirmationIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.editAffirmation),
        content: TextField(
          autofocus: true,
          controller: TextEditingController(
              text: _groups[groupIndex].affirmations[affirmationIndex].text),
          decoration: InputDecoration(hintText: S.of(context)!.affirmationText),
          onSubmitted: (text) async {
            if (text.isNotEmpty) {
              setState(() =>
                  _groups[groupIndex].affirmations[affirmationIndex].text = text);
              await _persistGroup(groupIndex);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _deleteAffirmation(int groupIndex, int affirmationIndex) async {
    setState(() => _groups[groupIndex].affirmations.removeAt(affirmationIndex));
    await _persistGroup(groupIndex);
  }

  void _toggleAllAffirmations(int groupIndex, bool value) async {
    setState(() {
      _groups[groupIndex].affirmations.forEach((a) => a.isEnabled = value);
    });
    await _persistGroup(groupIndex);
  }

  @override
  void initState() {
    super.initState();
    _loadAffirmations(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.myAffirmations),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addGroup,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Expanded(child: Text(group.name)),
                        Switch(
                          value: group.affirmations.isNotEmpty &&
                              group.affirmations.every((a) => a.isEnabled),
                          onChanged: group.affirmations.isEmpty
                              ? null
                              : (value) => _toggleAllAffirmations(index, value),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _editGroup(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () => _deleteGroup(index),
                        ),
                      ],
                    ),
                    children: [
                      ...group.affirmations.map((affirmation) {
                        final affirmationIndex =
                            group.affirmations.indexOf(affirmation);
                        return ListTile(
                          title: Text(
                            affirmation.text,
                            style: TextStyle(
                              color: affirmation.isEnabled
                                  ? null
                                  : Colors.grey,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: affirmation.isEnabled,
                                onChanged: (value) async {
                                  setState(() {
                                    affirmation.isEnabled = value;
                                  });
                                  await _persistGroup(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () =>
                                    _editAffirmation(index, affirmationIndex),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                onPressed: () =>
                                    _deleteAffirmation(index, affirmationIndex),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: Text(S.of(context)!.add),
                        onTap: () => _addAffirmation(index),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
