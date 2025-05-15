import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:affirmative_sentence/l10n/app_localizations.dart';

class Affirmation {
  String text;
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

class AffirmationGroup {
  String name;
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

  Future<void> _loadAffirmations(BuildContext context) async {
    setState(() => _isLoading = true);
    
    try {
      final file = 'assets/affirmations.json';
          
      final data = await rootBundle.loadString(file);
      _groups = (json.decode(data)['categories'] as List)
          .map((g) => AffirmationGroup.fromJson(g))
          .toList();
    } catch (e) {
      _groups = [];
    }
    
    setState(() => _isLoading = false);
  }

  void _addGroup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.addGroup),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: S.of(context)!.groupName),
          onSubmitted: (name) {
            if (name.isNotEmpty) {
              setState(() => _groups.add(AffirmationGroup(name)));
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
          onSubmitted: (name) {
            if (name.isNotEmpty) {
              setState(() => _groups[index].name = name);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _deleteGroup(int index) {
    setState(() => _groups.removeAt(index));
  }

  void _addAffirmation(int groupIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.add),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: S.of(context)!.affirmationText),
          onSubmitted: (text) {
            if (text.isNotEmpty) {
              setState(() => _groups[groupIndex].affirmations.add(Affirmation(text)));
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
          onSubmitted: (text) {
            if (text.isNotEmpty) {
              setState(() => _groups[groupIndex].affirmations[affirmationIndex].text = text);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _deleteAffirmation(int groupIndex, int affirmationIndex) {
    setState(() => _groups[groupIndex].affirmations.removeAt(affirmationIndex));
  }

  void _toggleAffirmation(int groupIndex, int affirmationIndex) {
    setState(() {
      _groups[groupIndex].affirmations[affirmationIndex].isEnabled = 
          !_groups[groupIndex].affirmations[affirmationIndex].isEnabled;
    });
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
                        final affirmationIndex = group.affirmations.indexOf(affirmation);
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
                              IconButton(
                                icon: Icon(
                                  affirmation.isEnabled
                                      ? Icons.toggle_on
                                      : Icons.toggle_off,
                                  color: affirmation.isEnabled
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                onPressed: () => _toggleAffirmation(index, affirmationIndex),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _editAffirmation(index, affirmationIndex),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                onPressed: () => _deleteAffirmation(index, affirmationIndex),
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
