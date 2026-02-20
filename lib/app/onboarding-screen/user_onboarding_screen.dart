import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../main_nav.dart';

/// Multi-step onboarding screen for new users to fill in their profile.
class UserOnboardingScreen extends StatefulWidget {
  const UserOnboardingScreen({super.key});

  @override
  State<UserOnboardingScreen> createState() => _UserOnboardingScreenState();
}

class _UserOnboardingScreenState extends State<UserOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 2;

  // Step 1: Basic Info
  final _fullNameController = TextEditingController();
  final _cityController = TextEditingController();

  // Step 2: Address & Contact
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_fullNameController.text.trim().isEmpty) {
        _showSnackBar('Please enter your full name');
        return;
      }
      if (_cityController.text.trim().isEmpty) {
        _showSnackBar('Please enter your city');
        return;
      }
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _submitProfile() async {
    if (_addressController.text.trim().isEmpty) {
      _showSnackBar('Please enter your complete address');
      return;
    }

    final authService = context.read<AuthService>();

    final profileData = <String, dynamic>{
      'fullName': _fullNameController.text.trim(),
      'city': _cityController.text.trim(),
      'completeAddress': _addressController.text.trim(),
    };

    if (_emailController.text.trim().isNotEmpty) {
      profileData['email'] = _emailController.text.trim();
    }

    final success = await authService.updateProfile(profileData);
    if (!mounted) return;

    if (success) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNav()),
        (route) => false,
      );
    } else {
      _showSnackBar(authService.error ?? 'Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<AuthService>(
          builder: (context, authService, _) {
            return Column(
              children: [
                // Header with progress
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Complete Your\nProfile',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan[900],
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Step ${_currentStep + 1} of $_totalSteps',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (_currentStep + 1) / _totalSteps,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.cyan[700]!,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),

                // Page Content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    children: [_buildStep1(), _buildStep2()],
                  ),
                ),

                // Bottom Buttons
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton(
                              onPressed: _previousStep,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.cyan[700],
                                side: BorderSide(color: Colors.cyan[700]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        flex: _currentStep > 0 ? 2 : 1,
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: authService.isLoading
                                ? null
                                : (_currentStep < _totalSteps - 1
                                      ? _nextStep
                                      : _submitProfile),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan[700],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: authService.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    _currentStep < _totalSteps - 1
                                        ? 'Continue'
                                        : 'Complete Profile',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Step 1: Full Name, Gender, City
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSectionTitle('Basic Information'),
          const SizedBox(height: 24),

          // Full Name
          _buildLabel('Full Name'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _fullNameController,
            hint: 'Enter your full name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 24),

          // City
          _buildLabel('City'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _cityController,
            hint: 'Enter your city',
            icon: Icons.location_city_outlined,
          ),
        ],
      ),
    );
  }

  /// Step 2: Address & Email
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSectionTitle('Address & Contact'),
          const SizedBox(height: 24),

          // Complete Address
          _buildLabel('Complete Address'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Icon(Icons.home_outlined, color: Colors.cyan[700]),
                ),
                hintText: 'Enter your complete address',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),

          // Email (Optional)
          _buildLabel('Email Address (Optional)'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'user@example.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),

          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.cyan[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.cyan[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your address helps us connect you with nearby washers.',
                    style: TextStyle(color: Colors.cyan[900], fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.cyan[700]),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
