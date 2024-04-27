import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:huggingface_client/huggingface_client.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/core/prompts.dart';
import 'package:thoughts/providers/thought.dart';
import 'package:thoughts/types/thought.dart';

final HF_TOKEN = dotenv.env['HF_TOKEN'];
final LLM_MODEL = dotenv.env['LLM_MODEL'];

String lastGeneratedContent = "";

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  String _content = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _generateContent(List<Thought> thoughts) async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String allThoughts = thoughts
          .map((thought) {
            final DateTime thoughtAt =
                DateTime.fromMillisecondsSinceEpoch(thought.dateCreated);
            return "At ${thoughtAt.hour}:${thoughtAt.minute}\n${thought.content}\n\n";
          })
          .join("\n")
          .trim();

      final uri =
          Uri.parse('https://api-inference.huggingface.co/models/$LLM_MODEL');
      final headers = {
        'Authorization': 'Bearer $HF_TOKEN',
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> body = {
        "inputs": STORY_PROMPT.replaceAll("%THOUGHTS%", allThoughts),
        "parameters": {
          "max_new_tokens": 4000,
          "temperature": 0.1,
          "top_p": 0.9,
          "top_k": 50,
          "repetition_penalty": 10.0,
        },
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      Response response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      int statusCode = response.statusCode;
      String responseBody = response.body;

      if (statusCode != 200) {
        print("Failed to generate content: $responseBody");
        return;
      }

      List<dynamic> responseJson = json.decode(responseBody);
      String generatedText =
          responseJson[0]["generated_text"].trim().split("---").last.trim();

      setState(() {
        _content = generatedText;
        lastGeneratedContent = generatedText;
      });
    } catch (e) {
      print("Failed to generate content");
      lastGeneratedContent = "";
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final thoughts = context.watch<ThoughtsProvider>().thoughts;

    if (thoughts == null || _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (thoughts.isEmpty) {
      return const Center(
          child: Text("Today's journey is not quite started yet."));
    }

    if (_content.isEmpty) {
      _generateContent(thoughts);
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Card(
          elevation: 1,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Text(_content),
          ),
        ),
      ),
    );
  }
}
