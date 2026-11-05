
import 'package:flutter/material.dart';

void main() {
  runApp(const JobApp());
}

class JobApp extends StatelessWidget {
  const JobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Job {
  final String title, company, location, type, salary, description;

  const Job(this.title, this.company, this.location,
      this.type, this.salary, this.description);
}

const jobs = [
  Job('Flutter Developer', 'Google', 'Bangalore',
      'Full-time', '6 LPA',
      'Develop mobile applications using Flutter and Dart.'),
  Job('Python Developer', 'Infosys', 'Hyderabad',
      'Full-time', '5 LPA',
      'Develop Python applications and backend systems.'),
  Job('Web Developer', 'TCS', 'Chennai',
      'Internship', '15K/month',
      'Design and develop responsive websites.'),
  Job('AI/ML Engineer', 'Microsoft', 'Bangalore',
      'Full-time', '8 LPA',
      'Develop AI and machine learning applications.'),
  Job('Java Developer', 'Wipro', 'Pune',
      'Part-time', '20K/month',
      'Build Java applications and backend services.'),
  Job('Data Analyst', 'Amazon', 'Hyderabad',
      'Internship', '18K/month',
      'Analyze data and prepare business reports.'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = '';
  String location = 'All';
  String type = 'All';
  int page = 0;

  final List<String> applications = [];

  List<Job> get filteredJobs {
    return jobs.where((job) {
      return (job.title.toLowerCase().contains(search.toLowerCase()) ||
              job.company.toLowerCase().contains(search.toLowerCase())) &&
          (location == 'All' || job.location == location) &&
          (type == 'All' || job.type == type);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Board',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
      ),
      body: page == 0 ? homePage() : applicationPage(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (i) => setState(() => page = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.assignment), label: 'Applications'),
        ],
      ),
    );
  }

  Widget homePage() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: Colors.indigo,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Find Your Dream Job!',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(
                onChanged: (v) => setState(() => search = v),
                decoration: InputDecoration(
                  hintText: 'Search jobs or companies',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: location,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  items: ['All', 'Bangalore', 'Hyderabad',
                    'Chennai', 'Pune'].map((v) {
                    return DropdownMenuItem(value: v, child: Text(v));
                  }).toList(),
                  onChanged: (v) => setState(() => location = v!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(
                    labelText: 'Job Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['All', 'Full-time', 'Part-time',
                    'Internship'].map((v) {
                    return DropdownMenuItem(value: v, child: Text(v));
                  }).toList(),
                  onChanged: (v) => setState(() => type = v!),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Available Jobs',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text('${filteredJobs.length} Jobs Found'),
            ],
          ),
        ),
        Expanded(
          child: filteredJobs.isEmpty
              ? const Center(child: Text('No jobs found'))
              : ListView.builder(
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = filteredJobs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.business),
                        ),
                        title: Text(job.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${job.company}\n${job.location} • ${job.type}'),
                        isThreeLine: true,
                        trailing: Text(job.salary),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsPage(
                              job: job,
                              onApply: (name) {
                                setState(() {
                                  applications.add(
                                      '$name - ${job.title} at ${job.company}');
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget applicationPage() {
    return applications.isEmpty
        ? const Center(
            child: Text('No Applications Yet',
                style: TextStyle(fontSize: 20)))
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.check_circle,
                      color: Colors.green),
                  title: Text(applications[index]),
                  subtitle: const Text('Application submitted'),
                ),
              );
            },
          );
  }
}

class DetailsPage extends StatelessWidget {
  final Job job;
  final Function(String) onApply;

  const DetailsPage({
    super.key,
    required this.job,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.business_center,
                  size: 65, color: Colors.indigo),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(job.title,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            Center(child: Text(job.company)),
            const Divider(height: 35),
            Text('Location: ${job.location}'),
            Text('Job Type: ${job.type}'),
            Text('Salary: ${job.salary}'),
            const SizedBox(height: 25),
            const Text('Job Description',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(job.description),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15)),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ApplyPage(
                      job: job,
                      onApply: onApply,
                    ),
                  ),
                ),
                child: const Text('Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApplyPage extends StatefulWidget {
  final Job job;
  final Function(String) onApply;

  const ApplyPage({
    super.key,
    required this.job,
    required this.onApply,
  });

  @override
  State<ApplyPage> createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Application'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(widget.job.title,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'Enter your name'
                        : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null ||
                    !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v)
                        ? 'Enter a valid email'
                        : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null ||
                    !RegExp(r'^[0-9]{10}$').hasMatch(v)
                        ? 'Enter a valid 10-digit phone number'
                        : null,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      widget.onApply(name.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Application Submitted!'),
                        ),
                      );
                      Navigator.popUntil(
                          context, (route) => route.isFirst);
                    }
                  },
                  child: const Text('Submit Application'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
