import 'package:flutter/material.dart';

void main() {
  runApp(const ComplaintApp());
}

class ComplaintApp extends StatelessWidget {
  const ComplaintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Public Complaint Portal',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF145DA0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F7FC),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const ComplaintHome(),
    );
  }
}

class Complaint {
  final String id;
  final String name;
  final String category;
  final String subject;
  final String description;
  final String location;
  final String date;
  String status;

  Complaint({
    required this.id,
    required this.name,
    required this.category,
    required this.subject,
    required this.description,
    required this.location,
    required this.date,
    this.status = 'Submitted',
  });
}

class ComplaintHome extends StatefulWidget {
  const ComplaintHome({super.key});

  @override
  State<ComplaintHome> createState() => _ComplaintHomeState();
}

class _ComplaintHomeState extends State<ComplaintHome>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final AnimationController _animationController;

  int _selectedIndex = 0;
  final List<Complaint> _complaints = [];

  final List<String> _categories = [
    'Roads and Transport',
    'Water Supply',
    'Electricity',
    'Sanitation',
    'Public Safety',
    'Corruption',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward(from: 0);
  }

  void _addComplaint(Complaint complaint) {
    setState(() => _complaints.insert(0, complaint));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PUBLIC COMPLAINT PORTAL',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF145DA0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeIn,
              ),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _selectedIndex = index);
                  _animationController.forward(from: 0);
                },
                children: [
                  _homePage(),
                  _complaintForm(),
                  _trackingPage(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _changePage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note),
            label: 'Register',
          ),
          NavigationDestination(
            icon: Icon(Icons.track_changes),
            label: 'Track',
          ),
        ],
      ),
    );
  }

  Widget _homePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF145DA0), Color(0xFF0C2D57)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.account_balance, size: 50, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Your Voice Matters!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Report public issues, submit complaints, '
                'and follow their progress in one place.',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF145DA0),
                ),
                onPressed: () => _changePage(1),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Register a Complaint'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: _statCard(
                'Total Complaints',
                '${_complaints.length}',
                Icons.description_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                'Submitted',
                '${_complaints.where((c) => c.status == 'Submitted').length}',
                Icons.pending_actions,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Our Objectives',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _infoCard(
          Icons.balance,
          'Peace and Justice',
          'Support transparent and accountable public institutions.',
        ),
        _infoCard(
          Icons.security,
          'Responsible Reporting',
          'Provide clear information about genuine public issues.',
        ),
        _infoCard(
          Icons.track_changes,
          'Complaint Tracking',
          'Review complaints submitted during this app session.',
        ),
        const SizedBox(height: 15),
        const Center(
          child: Text(
            'Aligned with United Nations SDG 16',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: const Color(0xFF145DA0)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String description) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFDCEBFA),
          child: Icon(icon, color: const Color(0xFF145DA0)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

  Widget _complaintForm() {
    return ComplaintForm(
      categories: _categories,
      onSubmit: (complaint) {
        _addComplaint(complaint);
        _changePage(2);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Complaint submitted: ${complaint.id}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  Widget _trackingPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'My Complaints',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text('Track complaints submitted during this session.'),
        const SizedBox(height: 16),
        if (_complaints.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  const Icon(Icons.inbox_outlined,
                      size: 60, color: Colors.blueGrey),
                  const SizedBox(height: 12),
                  const Text('No complaints submitted yet.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => _changePage(1),
                    child: const Text('Register Now'),
                  ),
                ],
              ),
            ),
          )
        else
          ..._complaints.map(
            (complaint) => Card(
              child: ExpansionTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.description_outlined),
                ),
                title: Text(complaint.subject),
                subtitle: Text(
                  '${complaint.id} • ${complaint.status}',
                ),
                childrenPadding: const EdgeInsets.all(16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${complaint.name}'),
                  Text('Category: ${complaint.category}'),
                  Text('Location: ${complaint.location}'),
                  Text('Date: ${complaint.date}'),
                  const SizedBox(height: 8),
                  Text(complaint.description),
                  const SizedBox(height: 10),
                  const Text(
                    'Demo status: Submitted. '
                    'An authority must update the status in a real system.',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ComplaintForm extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<Complaint> onSubmit;

  const ComplaintForm({
    super.key,
    required this.categories,
    required this.onSubmit,
  });

  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $label';
    }
    return null;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a complaint category')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 500));

    final complaint = Complaint(
      id: 'CMP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: _nameController.text.trim(),
      category: _selectedCategory!,
      subject: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      date: DateTime.now().toLocal().toString().substring(0, 16),
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    widget.onSubmit(complaint);
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _locationController.clear();
    _subjectController.clear();
    _descriptionController.clear();
    setState(() => _selectedCategory = null);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register Complaint',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Please provide accurate information.'),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) => _required(v, 'your name'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                    .hasMatch(value.trim())) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Complaint Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: widget.categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location / Address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (v) => _required(v, 'the location'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Complaint Subject',
                prefixIcon: Icon(Icons.subject),
              ),
              validator: (v) => _required(v, 'a subject'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descriptionController,
              minLines: 4,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                labelText: 'Complaint Description',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 10) {
                  return 'Enter at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _isSubmitting ? 'Submitting...' : 'Submit Complaint',
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Privacy: This prototype does not send your details to a server.',
              style: TextStyle(color: Colors.blueGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
