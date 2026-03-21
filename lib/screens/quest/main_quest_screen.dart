import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../components/quest_dialogue_widget.dart';
import '../../models/quest_models.dart';
import 'quest_map_screen.dart';

class MainQuestScreen extends StatefulWidget {
  final String userId;
  final String mainQuestId;

  const MainQuestScreen({
    super.key,
    required this.userId,
    required this.mainQuestId,
  });

  @override
  State<MainQuestScreen> createState() => _MainQuestScreenState();
}

class _MainQuestScreenState extends State<MainQuestScreen> {
  MainQuest? _mainQuest;
  SubQuest? _currentSubQuest;
  DialogueNode? _currentDialogueNode;
  UserSubQuestProgress? _subQuestProgress;
  bool _isLoading = true;
  String? _error;
  bool _isProcessingChoice = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentQuest();
  }

  Future<void> _loadCurrentQuest() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/main-quests/user/${widget.userId}/main-quest/${widget.mainQuestId}/current'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _currentSubQuest = SubQuest.fromJson(data['subQuest']);
          _subQuestProgress = UserSubQuestProgress.fromJson(data['progress']);
          _currentDialogueNode = DialogueNode.fromJson(data['currentNode']);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load quest: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _processChoice(String optionId, {String? userInput}) async {
    if (_isProcessingChoice || _currentDialogueNode == null) return;

    try {
      setState(() {
        _isProcessingChoice = true;
      });

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/main-quests/process-choice'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'userId': widget.userId,
          'mainQuestId': widget.mainQuestId,
          'dialogueNodeId': _currentDialogueNode!.id,
          'optionId': optionId,
          'userInput': userInput,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        setState(() {
          if (data['nextNode'] != null) {
            _currentDialogueNode = DialogueNode.fromJson(data['nextNode']);
          }
          _subQuestProgress = UserSubQuestProgress.fromJson(data['currentSubQuestProgress']);
          _isProcessingChoice = false;
        });

        //check if quest is completed
        if (data['isQuestCompleted'] == true) {
          _showQuestCompletedDialog();
        }
      } else {
        throw Exception('Failed to process choice: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isProcessingChoice = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showQuestCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quest Completed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              '${_currentSubQuest?.title ?? "Sub-quest"} completed!',
              textAlign: TextAlign.center,
            ),
            if (_subQuestProgress?.xpEarned != null && _subQuestProgress!.xpEarned! > 0)
              Text(
                'XP Earned: ${_subQuestProgress!.xpEarned}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); //back to quest list
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Normal map background (only darkened during dialogue)
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _currentDialogueNode != null ? 0.7 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  color: _currentDialogueNode != null 
                      ? Colors.black.withOpacity(0.3) 
                      : Colors.transparent,
                ),
                child: MapWidget(), //map widget
              ),
            ),
          ),

          //quest dialogue overlay
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else if (_error != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading quest',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadCurrentQuest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A148C),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (_currentDialogueNode != null)
            QuestDialogueWidget(
              dialogueNode: _currentDialogueNode!,
              onChoiceSelected: _processChoice,
              isProcessing: _isProcessingChoice,
            ),
        ],
      ),
    );
  }
}

//map widget - placeholder
class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: const Center(
        child: Text(
          'Map Background',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}