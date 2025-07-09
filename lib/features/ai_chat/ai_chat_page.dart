// lib/features/ai_chat/ai_chat_page.dart

import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'package:walmart/core/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final List<Map<String, String>> _messages = []; // Stores chat messages
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping =
      false; // Indicates if AI is currently "typing" (waiting for response)

  // --- Vapi.ai Configuration ---
  static const String _vapiApiUrl = 'https://api.vapi.ai/chat';
  // IMPORTANT: Replace with your actual Vapi.ai Authorization Key from your Vapi.ai dashboard
  // In a production app, never hardcode API keys directly in source code.
  // Use environment variables or a secure configuration management system.
  static const String _vapiApiKey = '9a1ae8e6-f57d-4fa8-82a9-1b98c77ef7b3';
  static const String _vapiAssistantId = 'e2a4856f-bf48-41bd-b1c9-195e9c76ede8';

  // --- New: Variable to store the chat/call ID for continuing the conversation ---
  String? _currentCallId;

  @override
  void initState() {
    super.initState();
    // Initial greeting from the AI. This is a static message.
    _addMessage({'sender': 'AI', 'text': 'Hello! How can I assist you today?'});
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addMessage(Map<String, String> message) {
    setState(() {
      _messages.add(message);
    });
    // Scroll to the bottom after adding a new message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendChatMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    _addMessage({'sender': 'User', 'text': userMessage});
    _messageController.clear();
    setState(() {
      _isTyping = true; // Show typing indicator
    });

    // Basic validation for Vapi.ai credentials
    if (_vapiApiKey == 'YOUR_VAPI_API_KEY_HERE' ||
        _vapiApiKey.isEmpty ||
        _vapiAssistantId == 'YOUR_VAPI_ASSISTANT_ID_HERE' ||
        _vapiAssistantId.isEmpty) {
      logger.e('Vapi.ai API Key or Assistant ID not set!');
      _addMessage({
        'sender': 'AI',
        'text':
            'Configuration Error: Vapi.ai API Key or Assistant ID not set. Please update the code.',
      });
      setState(() {
        _isTyping = false;
      });
      return;
    }

    try {
      logger.d('Sending chat message to Vapi.ai: $userMessage');

      // --- New: Prepare the request body ---
      final Map<String, dynamic> requestBody = {
        'assistantId': _vapiAssistantId,
        'input': userMessage, // Send the user's message as 'input'
      };

      // --- New: Add previousCallId if available ---
      if (_currentCallId != null) {
        requestBody['previousChatId'] = _currentCallId;
        logger.d('Including previousChatId: $_currentCallId');
      }

      final response = await http.post(
        Uri.parse(_vapiApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $_vapiApiKey', // Vapi.ai expects 'Bearer' prefix
        },
        body: json.encode(requestBody), // Use the prepared request body
      );

      if (mounted) {
        setState(() {
          _isTyping = false; // Hide typing indicator
        });

        if (response.statusCode >= 200 && response.statusCode < 300) {
          logger.d('Vapi.ai response received: ${response.body}');
          final Map<String, dynamic> responseData = json.decode(response.body);

          // --- New: Extract and store the current conversation ID ---
          if (responseData.containsKey('id') && responseData['id'] is String) {
            _currentCallId = responseData['id'];
            logger.d('Vapi.ai currentCallId updated to: $_currentCallId');
          } else {
            logger.w('Vapi.ai response missing "id" field.');
          }

          // Vapi.ai's /chat endpoint returns the assistant's message in the 'output' array's 'content' field
          final String aiResponse =
              responseData['output'][0]['content'] ?? 'No response from AI.';
          _addMessage({'sender': 'AI', 'text': aiResponse});
        } else {
          logger.e(
            'Vapi.ai chat failed with status: ${response.statusCode}, body: ${response.body}',
          );
          _addMessage({
            'sender': 'AI', // Sending error as AI message
            'text':
                'Error communicating with AI service: ${response.statusCode} - ${response.body}',
          });
        }
      }
    } catch (e) {
      logger.e('Network error sending chat to Vapi.ai: $e');
      if (mounted) {
        setState(() {
          _isTyping = false; // Hide typing indicator on error
        });
        _addMessage({
          'sender': 'AI', // Sending error as AI message
          'text': 'Network Error: Cannot reach Vapi.ai service.',
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'AI Chat Assistant',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'User';

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width *
                          0.7, // Limit bubble width
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primaryBlue
                          : AppColors.grey300.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser
                            ? const Radius.circular(16)
                            : const Radius.circular(4),
                        bottomRight: isUser
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? AppColors.white : AppColors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'AI is typing...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.grey600,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.grey300.withValues(
                        alpha: 0.5,
                      ), // Use withOpacity for alpha
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: _sendChatMessage,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  // Disable the button while AI is typing/responding
                  onPressed: _isTyping
                      ? null
                      : () => _sendChatMessage(_messageController.text),
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  child: _isTyping
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
