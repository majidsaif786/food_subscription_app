
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const FoodSubscriptionApp());
}

const Color green = Color(0xFF198754);
const Color dark = Color(0xFF18352B);
const Color bg = Color(0xFFF6F8F5);

class FoodSubscriptionApp extends StatelessWidget {
  const FoodSubscriptionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FreshBox',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          foregroundColor: dark,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ---------------- LOGIN / REGISTRATION ----------------

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void continueToApp() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name and email')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigation(
          customerName: nameController.text.trim(),
          email: emailController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.lunch_dining,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Fresh food.\nBetter everyday.',
                style: TextStyle(
                  fontSize: 36,
                  height: 1.15,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Subscribe to your favorite meals and pick them up whenever you need.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 35),
              const Text('Create your account',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              const SizedBox(height: 22),
              TextField(
                controller: nameController,
                decoration: inputDecoration('Full name', Icons.person_outline),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration('Email address', Icons.email_outlined),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: continueToApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Get Started',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text('FRESHBOX  •  EAT FRESH, LIVE BETTER',
                    style: TextStyle(
                        letterSpacing: 1.5,
                        color: green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration inputDecoration(String hint, IconData icon) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, color: green),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.all(18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );
}

// ---------------- MAIN NAVIGATION ----------------

class MainNavigation extends StatefulWidget {
  final String customerName;
  final String email;

  const MainNavigation({
    super.key,
    required this.customerName,
    required this.email,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;
  bool subscribed = false;
  int selectedPlan = 0;

  DateTime? pickupDate;
  String pickupTime = '12:00 PM';
  String? pickupCode;

  final plans = [
    {
      'name': 'Basic Plan',
      'price': '4,999',
      'meals': '20 meals',
      'description': 'Perfect for everyday lunches',
      'icon': Icons.lunch_dining,
    },
    {
      'name': 'Standard Plan',
      'price': '7,999',
      'meals': '40 meals',
      'description': 'More meals, more savings',
      'icon': Icons.restaurant,
    },
    {
      'name': 'Premium Plan',
      'price': '11,999',
      'meals': '60 meals',
      'description': 'The complete food experience',
      'icon': Icons.workspace_premium,
    },
  ];

  void subscribe(int index) {
    setState(() {
      selectedPlan = index;
      subscribed = true;
      currentIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Subscription activated successfully!')),
    );
  }

  void schedulePickup(DateTime date, String time) {
    setState(() {
      pickupDate = date;
      pickupTime = time;
      pickupCode = 'FB-${DateTime.now().millisecondsSinceEpoch}';
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        name: widget.customerName,
        subscribed: subscribed,
        plan: plans[selectedPlan],
        pickupDate: pickupDate,
        pickupTime: pickupTime,
        pickupCode: pickupCode,
        onExplore: () => setState(() => currentIndex = 1),
        onSchedule: () => setState(() => currentIndex = 2),
        onQR: () => setState(() => currentIndex = 3),
      ),
      PlansScreen(
        plans: plans,
        subscribed: subscribed,
        selectedPlan: selectedPlan,
        onSubscribe: subscribe,
      ),
      ScheduleScreen(
        pickupDate: pickupDate,
        pickupTime: pickupTime,
        subscribed: subscribed,
        onSchedule: schedulePickup,
      ),
      QRScreen(
        pickupCode: pickupCode,
        pickupDate: pickupDate,
        pickupTime: pickupTime,
      ),
      ProfileScreen(
        name: widget.customerName,
        email: widget.email,
        subscribed: subscribed,
        plan: plans[selectedPlan],
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        backgroundColor: Colors.white,
        indicatorColor: green.withOpacity(0.13),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: green),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            selectedIcon: Icon(Icons.restaurant_menu, color: green),
            label: 'Plans',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month, color: green),
            label: 'Pickup',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_2),
            selectedIcon: Icon(Icons.qr_code_2, color: green),
            label: 'My QR',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: green),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ---------------- COMMON WIDGETS ----------------

Widget sectionTitle(String title, {String? subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: dark)),
      if (subtitle != null) ...[
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    ],
  );
}

Widget primaryButton(String title, VoidCallback onPressed,
    {IconData? icon}) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward, size: 19),
      label: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      style: ElevatedButton.styleFrom(
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}

// ---------------- HOME SCREEN ----------------

class HomeScreen extends StatelessWidget {
  final String name;
  final bool subscribed;
  final Map<String, dynamic> plan;
  final DateTime? pickupDate;
  final String pickupTime;
  final String? pickupCode;
  final VoidCallback onExplore;
  final VoidCallback onSchedule;
  final VoidCallback onQR;

  const HomeScreen({
    super.key,
    required this.name,
    required this.subscribed,
    required this.plan,
    required this.pickupDate,
    required this.pickupTime,
    required this.pickupCode,
    required this.onExplore,
    required this.onSchedule,
    required this.onQR,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.lunch_dining,
                      color: Colors.white, size: 25),
                ),
                const SizedBox(width: 10),
                const Text('FreshBox',
                    style: TextStyle(
                        fontSize: 23, fontWeight: FontWeight.bold, color: dark)),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: green.withOpacity(0.12),
                  child: const Icon(Icons.notifications_none, color: green),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Hello, $name 👋',
                style: const TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: dark)),
            const SizedBox(height: 5),
            const Text('What would you like to eat today?',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Food banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF198754), Color(0xFF0E6240)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('HEALTHY FOOD, EVERY DAY',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  const Text(
                    'Your meals.\nYour schedule.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        height: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('Subscribe monthly and collect fresh meals.',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: onExplore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: green,
                    ),
                    child: const Text('Explore Plans'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            if (subscribed) ...[
              sectionTitle('Your Subscription'),
              const SizedBox(height: 13),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFFE7F5EC),
                          child: Icon(Icons.verified, color: green),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(plan['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                              Text(plan['meals'],
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        const Text('ACTIVE',
                            style: TextStyle(
                                color: green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payment method'),
                        const Text('Pay at pickup',
                            style: TextStyle(
                                color: green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (pickupDate != null) ...[
                      Text(
                        'Next pickup: ${pickupDate!.day}/${pickupDate!.month}/${pickupDate!.year}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(pickupTime,
                          style: const TextStyle(color: Colors.grey)),
                    ] else
                      const Text('No pickup scheduled yet',
                          style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 17),
                    primaryButton('Schedule Pickup', onSchedule,
                        icon: Icons.calendar_month),
                  ],
                ),
              ),
            ] else ...[
              sectionTitle('Get Started'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.restaurant,
                        size: 45, color: green),
                    const SizedBox(height: 10),
                    const Text('You have no active subscription',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 7),
                    const Text('Choose a monthly package to get started.',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 15),
                    primaryButton('View Subscription Plans', onExplore),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 26),
            sectionTitle('How FreshBox Works'),
            const SizedBox(height: 15),
            Row(
              children: [
                processItem(Icons.card_membership, 'Subscribe'),
                processItem(Icons.calendar_month, 'Schedule'),
                processItem(Icons.qr_code_2, 'Show QR'),
                processItem(Icons.restaurant, 'Collect'),
              ],
            ),
            const SizedBox(height: 25),
            if (pickupCode != null)
              InkWell(
                onTap: onQR,
                child: Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F5EC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.qr_code_2, color: green, size: 30),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text('Your pickup QR is ready',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: dark)),
                      ),
                      Icon(Icons.arrow_forward_ios, color: green, size: 17),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget processItem(IconData icon, String title) {
  return Expanded(
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: green.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: green, size: 23),
        ),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

// ---------------- SUBSCRIPTION PLANS ----------------

class PlansScreen extends StatelessWidget {
  final List<Map<String, dynamic>> plans;
  final bool subscribed;
  final int selectedPlan;
  final Function(int) onSubscribe;

  const PlansScreen({
    super.key,
    required this.plans,
    required this.subscribed,
    required this.selectedPlan,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          sectionTitle('Subscription Plans',
              subtitle: 'Choose a package that suits your lifestyle.'),
          const SizedBox(height: 22),
          ...List.generate(plans.length, (index) {
            final p = plans[index];
            final recommended = index == 1;

            return Container(
              margin: const EdgeInsets.only(bottom: 17),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: recommended ? green : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recommended)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 5),
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('MOST POPULAR',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(p['icon'], color: green, size: 28),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['name'],
                                style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold)),
                            Text(p['description'],
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Rs. ${p['price']}',
                      style: const TextStyle(
                          fontSize: 27,
                          color: green,
                          fontWeight: FontWeight.bold)),
                  const Text('per month',
                      style: TextStyle(color: Colors.grey)),
                  const Divider(height: 25),
                  feature(Icons.check_circle, '${p['meals']} per month'),
                  feature(Icons.check_circle, 'Freshly prepared meals'),
                  feature(Icons.check_circle, 'Flexible pickup scheduling'),
                  feature(Icons.check_circle, 'QR-based pickup verification'),
                  feature(Icons.check_circle, 'Pay at pickup point'),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 49,
                    child: ElevatedButton(
                      onPressed: () {
                        if (subscribed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('You already have an active subscription in this demo.')),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Confirm Subscription'),
                              content: Text(
                                'Subscribe to ${p['name']} for Rs. ${p['price']} per month?\n\nPayment will be collected at the pickup point.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onSubscribe(index);
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: recommended ? green : dark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: Text(subscribed && selectedPlan == index
                          ? 'Current Plan'
                          : 'Subscribe Now'),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

Widget feature(IconData icon, String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, color: green, size: 18),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );
}

// ---------------- PICKUP SCHEDULING ----------------

class ScheduleScreen extends StatefulWidget {
  final DateTime? pickupDate;
  final String pickupTime;
  final bool subscribed;
  final Function(DateTime, String) onSchedule;

  const ScheduleScreen({
    super.key,
    required this.pickupDate,
    required this.pickupTime,
    required this.subscribed,
    required this.onSchedule,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime? selectedDate;
  String selectedTime = '12:00 PM';

  final times = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.pickupDate;
    selectedTime = widget.pickupTime;
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      7,
      (i) => DateTime.now().add(Duration(days: i + 1)),
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          sectionTitle('Schedule Pickup',
              subtitle: 'Select your preferred collection date and time.'),
          const SizedBox(height: 25),
          if (!widget.subscribed)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  Icon(Icons.lock_outline, color: green, size: 40),
                  SizedBox(height: 10),
                  Text('Subscription Required',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 7),
                  Text('Please subscribe to a monthly package before scheduling a pickup.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          else ...[
            const Text('Select a pickup date',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ...days.map((day) {
              final isSelected = selectedDate != null &&
                  selectedDate!.year == day.year &&
                  selectedDate!.month == day.month &&
                  selectedDate!.day == day.day;

              return InkWell(
                onTap: () => setState(() => selectedDate = day),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isSelected ? green.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: isSelected ? green : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: isSelected ? green : Colors.grey),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          '${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day.weekday - 1]}, ${day.day}/${day.month}/${day.year}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: green),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            const Text('Select pickup time',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 13),
            Wrap(
              spacing: 9,
              runSpacing: 10,
              children: times.map((time) {
                final selected = selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: selected,
                  selectedColor: green.withOpacity(0.15),
                  onSelected: (_) => setState(() => selectedTime = time),
                  labelStyle: TextStyle(
                    color: selected ? green : dark,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                      color: selected ? green : Colors.grey.shade300),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.payments_outlined, color: green, size: 27),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment at Pickup',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Pay directly at the collection point.',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            primaryButton('Confirm Pickup Schedule', () {
              if (selectedDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a pickup date')),
                );
                return;
              }

              widget.onSchedule(selectedDate!, selectedTime);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Pickup scheduled! Your QR code is ready.')),
              );
            }, icon: Icons.check_circle_outline),
          ],
        ],
      ),
    );
  }
}

// ---------------- QR CODE SCREEN ----------------

class QRScreen extends StatelessWidget {
  final String? pickupCode;
  final DateTime? pickupDate;
  final String pickupTime;

  const QRScreen({
    super.key,
    required this.pickupCode,
    required this.pickupDate,
    required this.pickupTime,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          sectionTitle('My Pickup QR',
              subtitle: 'Show this code at the collection point.'),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.qr_code_2, color: green, size: 30),
                ),
                const SizedBox(height: 14),
                const Text('Your Pickup Pass',
                    style: TextStyle(
                        fontSize: 21, fontWeight: FontWeight.bold, color: dark)),
                const SizedBox(height: 6),
                const Text('FreshBox food collection',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                if (pickupCode != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: QrImageView(
                      data: pickupCode!,
                      version: QrVersions.auto,
                      size: 210,
                      backgroundColor: Colors.white,
                      foregroundColor: dark,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(pickupCode!,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5)),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F5EC),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: green, size: 18),
                            SizedBox(width: 7),
                            Text('Pickup Scheduled',
                                style: TextStyle(
                                    color: green,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Date: ${pickupDate!.day}/${pickupDate!.month}/${pickupDate!.year}',
                          style: const TextStyle(color: dark),
                        ),
                        Text('Time: $pickupTime',
                            style: const TextStyle(color: dark)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Please present this QR code to the staff member when collecting your food pack.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                ] else ...[
                  const SizedBox(height: 20),
                  const Icon(Icons.qr_code_2,
                      size: 90, color: Colors.black12),
                  const SizedBox(height: 12),
                  const Text('No QR code available yet',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Subscribe to a package and schedule your first pickup to generate your QR code.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(Icons.info_outline, color: green),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your QR code is linked to your pickup reference.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------- PROFILE SCREEN ----------------

class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final bool subscribed;
  final Map<String, dynamic> plan;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.subscribed,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          sectionTitle('My Profile',
              subtitle: 'Manage your personal information.'),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(23),
            decoration: BoxDecoration(
              color: dark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: green),
                ),
                const SizedBox(height: 13),
                Text(name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold)),
                Text(email,
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 25),
          sectionTitle('Account Information'),
          const SizedBox(height: 12),
          profileTile(Icons.person_outline, 'Personal Details',
              'Manage your name and email'),
          profileTile(Icons.card_membership, 'My Subscription',
              subscribed ? plan['name'] : 'No active subscription'),
          profileTile(Icons.history, 'Pickup History',
              'View your previous collections'),
          profileTile(Icons.location_on_outlined, 'Pickup Locations',
              'Find your collection point'),
          profileTile(Icons.notifications_none, 'Notifications',
              'Manage your alerts'),
          profileTile(Icons.help_outline, 'Help & Support',
              'Get assistance'),
          profileTile(Icons.privacy_tip_outlined, 'Privacy Policy',
              'Terms and privacy information'),
          const SizedBox(height: 25),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Log Out',
                style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Colors.redAccent),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text('FreshBox App • Version 1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

Widget profileTile(IconData icon, String title, String subtitle) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: ListTile(
      leading: Icon(icon, color: green),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 15, color: Colors.grey),
    ),
  );
}
