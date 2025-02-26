import 'package:flutter/material.dart';

void main() {
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

// Initial Welcome Screen with Animation
class WelcomeAnimationScreen extends StatefulWidget {
  @override
  _WelcomeAnimationScreenState createState() =>
      _WelcomeAnimationScreenState();
}

class _WelcomeAnimationScreenState extends State<WelcomeAnimationScreen> {
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
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

// Main Registration Screen
class WelcomeScreen extends StatefulWidget {
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
    "Purok 1",
    "Purok 2",
    "Purok 3",
    "Purok 4",
    "Purok 5",
    "Purok 6",
    "Purok 7",
    "Purok 8",
    "PLDT Subdivision",
    "Country Homes Subd.",
    "Vista Rosa"
  ];
  List<String> purposeOptions = [
    "Indigency",
    "Clearance",
    "Residency",
    "Certificate",
    "ID",
    "Incident Report",
    "Accident Report",
    "Other"
  ];

  void goToNextStep() {
    setState(() {
      step++;
    });
  }

  Future<void> _selectBirthdate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
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
        decoration:
            InputDecoration(border: OutlineInputBorder(), hintText: "Pumili"),
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
        decoration:
            InputDecoration(border: OutlineInputBorder(), hintText: "Pumili"),
      );
    } else if (step == 3) {
      questionText = "Araw ng kapanganakan";
      inputWidget = Column(
        children: [
          Text(
            selectedBirthdate == null
                ? "No date selected"
                : "${selectedBirthdate!.month}/${selectedBirthdate!.day}/${selectedBirthdate!.year}",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _selectBirthdate(context),
            child: Text("Pumili ng araw"),
          ),
        ],
      );
    } else if (step == 4) {
      questionText = "Ang iyong edad ay:";
      inputWidget = Center(
        child: Text(
          calculatedAge == null ? "Hindi masuri" : "$calculatedAge taong gulang",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text("Maraming Salamat sa pagkumpleto ng survey!",
              style: TextStyle(fontSize: 20)),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(  // Ensures centering of text and input fields
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontally
                children: [
                  Text(
                    questionText,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 300, // Limit width
                    child: inputWidget,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: goToNextStep,
                    child: Icon(Icons.arrow_forward),
                  ),
                ],
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
