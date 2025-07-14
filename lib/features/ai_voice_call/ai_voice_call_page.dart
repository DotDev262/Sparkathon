// lib/features/ai_voice_call/ai_voice_call_page.dart

import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'package:walmart/core/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum CallStatus { idle, connecting, inCall, speaking, ended, error }

class AIVoiceCallPage extends StatefulWidget {
  const AIVoiceCallPage({super.key});

  @override
  State<AIVoiceCallPage> createState() => _AIVoiceCallPageState();
}

class _AIVoiceCallPageState extends State<AIVoiceCallPage> {
  CallStatus _callStatus = CallStatus.idle;
  String _transcript = ''; // Stores user's last input (if N8N provides it)
  String _aiResponse = ''; // Stores AI's response

  // --- N8N Webhook URL ---
  // IMPORTANT: Replace this with your actual N8N webhook URL
  static const String _n8nWebhookUrl =
      'http://11.12.18.245:5678/webhook-test/632370fd-f7f2-4592-be2f-20aacbb117cc';

  @override
  void dispose() {
    super.dispose();
  }

  // --- N8N Interaction Logic ---

  Future<void> _sendToN8n({required String eventType, String? message}) async {
    if (_n8nWebhookUrl == 'YOUR_N8N_WEBHOOK_URL_HERE' ||
        _n8nWebhookUrl.isEmpty) {
      logger.e(
        'N8N Webhook URL not set! Please replace "YOUR_N8N_WEBHOOK_URL_HERE" with your actual N8N webhook URL.',
      );
      if (mounted) {
        setState(() {
          _callStatus = CallStatus.error;
          _aiResponse = 'Configuration Error: N8N Webhook URL not set.';
        });
      }
      return;
    }

    try {
      logger.d('Sending event to N8N: $eventType with message: $message');
      setState(() {
        if (eventType == 'get_call') {
          _callStatus = CallStatus.connecting;
          _aiResponse = '';
          _transcript = '';
        } else if (eventType == 'end_call_system') {
          _callStatus = CallStatus.ended;
          _aiResponse = 'Call ending...'; // Temporarily show ending message
        }
      });

      final response = await http.post(
        Uri.parse(_n8nWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'eventType': eventType,
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
          // Add any other context needed by N8N, e.g., 'userId': '123'
        }),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          logger.d('N8N response received: ${response.body}');
          final Map<String, dynamic> responseData = json.decode(response.body);

          setState(() {
            _aiResponse = responseData['aiResponse'] ?? 'No response from AI.';
            // Assuming N8N might send a 'userTranscript' if it processed voice input
            _transcript = responseData['userTranscript'] ?? '';

            if (eventType == 'get_call') {
              _callStatus = CallStatus.inCall;
            } else if (responseData['callEnded'] == true) {
              // N8N signals call end
              _callStatus = CallStatus.ended;
              // Use AI's last message or default if N8N explicitly ended call
              _aiResponse = _aiResponse.isNotEmpty
                  ? _aiResponse
                  : 'Call ended.';
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted && _callStatus == CallStatus.ended) {
                  Navigator.of(context).pop();
                }
              });
            }
          });
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(
          //       'AI Response: ${_aiResponse.substring(0, _aiResponse.length > 50 ? 50 : _aiResponse.length)}...',
          //     ),
          //   ),
          // );
        } else {
          logger.e(
            'N8N request failed with status: ${response.statusCode}, body: ${response.body}',
          );
          setState(() {
            _callStatus = CallStatus.error;
            _aiResponse = 'Error communicating with AI: ${response.statusCode}';
          });
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Error: ${response.statusCode} - ${response.body}'),
          //   ),
          // );
        }
      }
    } catch (e) {
      logger.e('Network error sending to N8N: $e');
      if (mounted) {
        setState(() {
          _callStatus = CallStatus.error;
          _aiResponse = 'Network Error: Cannot reach N8N service.';
        });
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Network Error: $e')));
      }
    }
  }

  void _getCall() {
    _sendToN8n(eventType: 'get_call');
  }

  // Internal function to handle ending the call (e.g., on back button press or system signal)
  void _endCallInternally() {
    _sendToN8n(
      eventType: 'end_call_system',
    ); // Notify N8N the app is ending the session
    setState(() {
      _callStatus = CallStatus.ended;
      _aiResponse = 'Call ended. Thank you for using our AI assistant!';
      _transcript = ''; // Clear transcript on call end
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _callStatus == CallStatus.ended) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            if (_callStatus == CallStatus.inCall ||
                _callStatus == CallStatus.connecting ||
                _callStatus == CallStatus.speaking) {
              _endCallInternally(); // Ensure call ends if user goes back while active
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'AI Voice Assistant',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryBlue, AppColors.white],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primaryBlue.withValues(
                        alpha: 0.2,
                      ),
                      child: Icon(
                        _getCallIcon(),
                        size: 70,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _getCallStatusText(),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black87,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    if (_callStatus == CallStatus.connecting ||
                        _callStatus == CallStatus.speaking)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryBlue,
                        ),
                      ),
                    const SizedBox(height: 20),
                    // // Display AI Response
                    // if (_aiResponse.isNotEmpty)
                    //   Card(
                    //     margin: const EdgeInsets.symmetric(
                    //       vertical: 8.0,
                    //       horizontal: 0,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    //     elevation: 1,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(12.0),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             'AI:',
                    //             style: Theme.of(context).textTheme.bodyLarge
                    //                 ?.copyWith(
                    //                   fontWeight: FontWeight.bold,
                    //                   color: AppColors.primaryBlue,
                    //                 ),
                    //           ),
                    //           const SizedBox(height: 4),
                    //           Text(
                    //             _aiResponse,
                    //             style: Theme.of(context).textTheme.bodyMedium
                    //                 ?.copyWith(color: AppColors.black87),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // // Display User Transcript (if N8N sends one based on system's interpretation)
                    // if (_transcript.isNotEmpty)
                    //   Card(
                    //     margin: const EdgeInsets.symmetric(
                    //       vertical: 8.0,
                    //       horizontal: 0,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     color: AppColors.yellow.withValues(alpha: 0.1),
                    //     elevation: 1,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(12.0),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             'You (System Heard):',
                    //             style: Theme.of(context).textTheme.bodyLarge
                    //                 ?.copyWith(
                    //                   fontWeight: FontWeight.bold,
                    //                   color: AppColors.darkBlue,
                    //                 ),
                    //           ),
                    //           const SizedBox(height: 4),
                    //           Text(
                    //             _transcript,
                    //             style: Theme.of(context).textTheme.bodyMedium
                    //                 ?.copyWith(color: AppColors.black87),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
            // The ONE "Get Call" Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                // Center the button
                child: FloatingActionButton.extended(
                  onPressed:
                      _callStatus == CallStatus.idle ||
                          _callStatus == CallStatus.ended ||
                          _callStatus == CallStatus.error
                      ? _getCall // Only enable if idle/ended/error
                      : null, // Disable if already connecting or in call
                  icon: const Icon(Icons.call),
                  label: const Text('Get Call'),
                  backgroundColor:
                      AppColors.primaryBlue, // Blue color as requested
                  foregroundColor: AppColors.white,
                  heroTag: 'getCallButton', // Unique tag for this FAB
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods for UI state (updated for new states) ---

  String _getCallStatusText() {
    switch (_callStatus) {
      case CallStatus.idle:
        return 'Tap "Get Call" to receive system call.';
      case CallStatus.connecting:
        return 'Connecting to System Call...';
      case CallStatus.inCall:
        return 'Connected to System. Waiting for AI response.';
      case CallStatus.speaking:
        return 'Receiving AI response...';
      case CallStatus.ended:
        return 'Call ended.';
      case CallStatus.error:
        return 'Connection Error.';
    }
  }

  IconData _getCallIcon() {
    switch (_callStatus) {
      case CallStatus.idle:
      case CallStatus.ended:
        return Icons.phone;
      case CallStatus.connecting:
        return Icons.ring_volume;
      case CallStatus.inCall:
      case CallStatus.speaking:
        return Icons.headset_mic;
      case CallStatus.error:
        return Icons.error_outline;
    }
  }
}
