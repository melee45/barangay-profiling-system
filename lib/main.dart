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
  _WelcomeAnimationScreenState createState() => _WelcomeAnimationScreenState();
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
      setState(() {
        opacity = 0.0;
      });
    });

    Future.delayed(Duration(seconds: 4), () {
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
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

// Main Registration Screen with Smooth Transitions
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double opacity = 0.0;
  int step = 0;
  TextEditingController surnameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  String? selectedAddress;
  String? selectedPurpose;
  DateTime? selectedBirthdate;
  int? calculatedAge;

  List<String> addressOptions = ["New York", "Los Angeles", "Chicago", "Houston", "Miami"];
  List<String> purposeOptions = ["Work", "Education", "Tourism", "Business", "Other"];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  void goToNextStep() {
    setState(() {
      opacity = 0.0;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        step++;
        opacity = 1.0;
      });
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
    if (today.month < birthdate.month || (today.month == birthdate.month && today.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    String questionText = "";
    Widget inputWidget;

    if (step == 0) {
      questionText = "What is your surname?";
      inputWidget = TextField(
        controller: surnameController,
        decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter your surname"),
      );
    } else if (step == 1) {
      questionText = "What is your first name?";
      inputWidget = TextField(
        controller: firstNameController,
        decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter your first name"),
      );
    } else if (step == 2) {
      questionText = "What is your middle name?";
      inputWidget = TextField(
        controller: middleNameController,
        decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter your middle name"),
      );
    } else if (step == 3) {
      questionText = "What is your address?";
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
        decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Select your address"),
      );
    } else if (step == 4) {
      questionText = "What is your birthdate?";
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
            child: Text("Pick a Date"),
          ),
        ],
      );
    } else if (step == 5) {
      questionText = "Your calculated age is:";
      inputWidget = Center(
        child: Text(
          calculatedAge == null ? "Age not available" : "$calculatedAge years old",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    } else if (step == 6) {
      questionText = "What is your purpose?";
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
        decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Select your purpose"),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Hello Flutter!"), backgroundColor: Colors.blueAccent),
        body: Center(
          child: Text("Thank you! Registration complete.", style: TextStyle(fontSize: 20)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Hello Flutter!"), backgroundColor: Colors.blueAccent),
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(seconds: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(questionText, style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              SizedBox(width: 300, child: inputWidget),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: goToNextStep,
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
