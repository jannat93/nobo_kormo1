import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/job_model.dart';
import '../models/resource_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';


class DataProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<Job> _jobs = [];
  List<Resource> _resources = [];
  List<Job> _recommendedJobs = [];
  List<Resource> _recommendedResources = [];
  bool _isLoading = false;

  List<Job> get jobs => _jobs;
  List<Resource> get resources => _resources;
  List<Job> get recommendedJobs => _recommendedJobs;
  List<Resource> get recommendedResources => _recommendedResources;
  bool get isLoading => _isLoading;

  Future<void> fetchAllData() async {
    _isLoading = true;
    notifyListeners();
    await Future.wait([fetchJobs(), fetchResources()]);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchJobs() async {
    try {
      final response = await _api.get('/jobs');
      if (response.statusCode == 200) {
        // FIX: The 'data' field is a Map, so we must access 'rows' inside it to get the List.
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        final List<dynamic> jobList = data['rows'];
        // END FIX
        _jobs = jobList.map((j) => Job.fromJson(j)).toList();
      }
    } catch (e) {
      print('Error fetching jobs: $e');
    }
  }

  Future<void> fetchResources() async {
    try {
      final response = await _api.get('/resources');
      if (response.statusCode == 200) {
        // FIX: The 'data' field is a Map, so we must access 'rows' inside it to get the List.
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        final List<dynamic> resourceList = data['rows'];
        // END FIX
        _resources = resourceList.map((r) => Resource.fromJson(r)).toList();
      }
    } catch (e) {
      print('Error fetching resources: $e');
    }
  }

  Future<void> fetchMatchingData(User user) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _api.post('/matching/recommendations', {
        'skills': user.skills.take(3).toList(),
        'preferred_career_track': user.preferredCareerTrack,
        'experience_level': user.experienceLevel,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> recommendedJobList = data['recommendedJobs'];
        final List<dynamic> recommendedResourceList = data['recommendedResources'];

        _recommendedJobs = recommendedJobList.map((j) => Job.fromJson(j)).toList();
        _recommendedResources = recommendedResourceList.map((r) => Resource.fromJson(r)).toList();
      }
    } catch (e) {
      print('Error fetching matching data: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}