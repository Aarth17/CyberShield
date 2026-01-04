import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/device_service.dart';
import '../services/network_service.dart';
import '../widgets/info_card.dart';
import '../widgets/security_tip_card.dart';
import '../providers/auth_provider.dart';
import 'vault_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final DeviceService _deviceService = DeviceService();
  final NetworkService _networkService = NetworkService();

  Map<String, String> _deviceInfo = {};
  String _publicIP = 'Loading...';
  List<Map<String, String>> _securityTips = [];
  bool _isLoading = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final deviceInfo = await _deviceService.getDeviceInfo();
    final publicIP = await _networkService.getPublicIP();
    final tips = await _networkService.getSecurityNews();

    // Convert device info and tips to proper types
    setState(() {
      _deviceInfo = deviceInfo.map((key, value) => MapEntry(key.toString(), value.toString()));
      _publicIP = publicIP.toString();
      _securityTips = tips
          .map((tip) => tip.map((key, value) => MapEntry(key.toString(), value.toString())))
          .toList();
      _isLoading = false;
    });

    _controller.forward();
  }

  Future<void> _navigateToVault() async {
    final authProvider = context.read<AuthProvider>();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF00F5FF)),
      ),
    );

    final authenticated = await authProvider.authenticateUser();

    // Close loading
    if (mounted) Navigator.pop(context);

    if (authenticated && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VaultScreen()),
      );
    } else if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1F3A),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[400]),
              const SizedBox(width: 12),
              const Text('Access Denied', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Text(
            authProvider.lastError.isEmpty
                ? 'Biometric authentication is required to access the secure vault.'
                : authProvider.lastError,
            style: const TextStyle(color: Colors.white70, height: 1.5),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00F5FF)),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E27),
              const Color(0xFF1A1F3A).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : FadeTransition(
                  opacity: _fadeAnimation,
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    color: const Color(0xFF00F5FF),
                    backgroundColor: const Color(0xFF1A1F3A),
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildHardwareSection(),
                        const SizedBox(height: 20),
                        _buildNetworkSection(),
                        const SizedBox(height: 20),
                        _buildVaultAccessCard(),
                        const SizedBox(height: 20),
                        _buildSecurityFeedSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00F5FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00F5FF).withOpacity(0.3)),
            ),
            child: const Icon(Icons.shield, color: Color(0xFF00F5FF), size: 28),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CyberShield',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00F5FF),
                ),
              ),
              Text(
                'Security Monitor',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF00F5FF)),
          SizedBox(height: 16),
          Text('Scanning system...', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildHardwareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hardware Audit',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),
        InfoCard(
          icon: Icons.phone_android,
          title: 'Device Model',
          value: _deviceInfo['model'] ?? 'Unknown',
        ),
        const SizedBox(height: 12),
        InfoCard(
          icon: Icons.system_update,
          title: 'Operating System',
          value: _deviceInfo['os'] ?? 'Unknown',
        ),
      ],
    );
  }

  Widget _buildNetworkSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Network Intel',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),
        InfoCard(icon: Icons.public, title: 'Public IP Address', value: _publicIP, isHighlight: true),
      ],
    );
  }

  Widget _buildVaultAccessCard() {
    return Card(
      child: InkWell(
        onTap: _navigateToVault,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF6C63FF).withOpacity(0.3), const Color(0xFF00F5FF).withOpacity(0.3)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00F5FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fingerprint, color: Color(0xFF00F5FF), size: 32),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Secure Vault', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 4),
                    Text('Biometric authentication required', style: TextStyle(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Color(0xFF00F5FF), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityFeedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Security Feed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        ..._securityTips.map(
              (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SecurityTipCard(
              title: tip['title'] ?? '',
              description: tip['description'] ?? '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        boxShadow: [BoxShadow(color: const Color(0xFF00F5FF).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF00F5FF),
        unselectedItemColor: Colors.white54,
        currentIndex: 0,
        elevation: 0,
        onTap: (index) {
          if (index == 1) _navigateToVault();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Monitor'),
          BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'Vault'),
        ],
      ),
    );
  }
}
