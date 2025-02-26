import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure this file exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase initialized successfully!");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeAnimationScreen(),
    );
  }
}

class WelcomeAnimationScreen extends StatefulWidget {
  const WelcomeAnimationScreen({super.key});
  @override
  WelcomeAnimationScreenState createState() => WelcomeAnimationScreenState();
}

class WelcomeAnimationScreenState extends State<WelcomeAnimationScreen> {
  double opacity = 0.0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        opacity = 1.0;
      });
    });
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(seconds: 2),
          child: Text(
            "Welcome!",
            style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int step = 0;
  TextEditingController surnameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  String? selectedAddress;
  String? selectedPurpose;
  DateTime? selectedBirthdate;
  int? calculatedAge;

  List<String> addressOptions = [
    "Purok 1", "Purok 2", "Purok 3", "Purok 4", "Purok 5",
    "Purok 6", "Purok 7", "Purok 8", "PLDT Subdivision",
    "Country Homes Subd.", "Vista Rosa"
  ];
  List<String> purposeOptions = [
    "Indigency", "Clearance", "Residency", "Certificate",
    "ID", "Incident Report", "Accident Report", "Other"
  ];

  Future<void> _selectBirthdate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedBirthdate ?? DateTime.now(), // Keeps last selection
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedBirthdate = pickedDate;
        calculatedAge = _calculateAge(pickedDate);
      });
    }
  }

  int _calculateAge(DateTime birthdate) {
    DateTime today = DateTime.now();
    int age = today.year - birthdate.year;
    if (today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  void saveUserData() {
    print("Attempting to save data:");
    print("Surname: ${surnameController.text}");
    print("Purpose: $selectedPurpose");
    print("Address: $selectedAddress");
    print("Birthdate: $selectedBirthdate");
    print("Calculated Age: $calculatedAge");
    
    if (surnameController.text.isEmpty || selectedPurpose == null || selectedAddress == null || selectedBirthdate == null) {
    print("⚠️ Missing required fields!");
    return;
  }
    FirebaseFirestore.instance.collection('users').add({
      'surname': surnameController.text,
      'firstName': firstNameController.text,
      'middleName': middleNameController.text,
      'address': selectedAddress,
      'purpose': selectedPurpose,
      'birthdate': selectedBirthdate?.toIso8601String(),
      'age': calculatedAge,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      print("✅ User data saved!");
    }).catchError((error) {
      print("❌ Failed to save user data: $error");
    });
  }

  void goToNextStep() {
    if (step == 3) {
      saveUserData();
    }
    setState(() {
      step++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // When survey is complete, display a thank-you screen with larger text.
    if (step > 3) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Maraming Salamat sa pagkumpleto ng survey!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    String questionText = "";
    Widget inputWidget = SizedBox();

    if (step == 0) {
      questionText = "Dahilan ng iyong pagpunta";
      inputWidget = DropdownButtonFormField<String>(
        value: selectedPurpose,
        items: purposeOptions.map((String purpose) {
          return DropdownMenuItem(value: purpose, child: Text(purpose));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedPurpose = newValue;
          });
        },
      );
    } else if (step == 1) {
      questionText = "Kumpletuhin ang sumusunod";
      inputWidget = Column(
        children: [
          TextField(
            controller: surnameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Apelyido",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: firstNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Pangalan",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: middleNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Gitnang Pangalan",
            ),
          ),
        ],
      );
    } else if (step == 2) {
      questionText = "Barangay ng pagkakakilanlan";
      inputWidget = DropdownButtonFormField<String>(
        value: selectedAddress,
        items: addressOptions.map((String address) {
          return DropdownMenuItem(value: address, child: Text(address));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedAddress = newValue;
          });
        },
      );
    } else if (step == 3) {
  questionText = "Araw ng kapanganakan";
  inputWidget = Column(
    children: [
      ElevatedButton(
        onPressed: () => _selectBirthdate(context),
        child: Text("Pumili ng araw"),
      ),
      SizedBox(height: 10),
      if (selectedBirthdate != null) // Show selected date & age
        Column(
          children: [
            Text(
              "Napili mong petsa: ${selectedBirthdate!.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "Edad: ${calculatedAge ?? '-'} taon",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
    ],
  );
}

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            questionText,
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          inputWidget,
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: goToNextStep,
                              child: Icon(Icons.arrow_forward),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LinearProgressIndicator(
              value: (step + 1) / 5,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
