import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ThemeProvider.dart';

class KonversiBMI extends StatefulWidget {
  @override
  _KonversiBMIState createState() => _KonversiBMIState();
}

class _KonversiBMIState extends State<KonversiBMI> {
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  String gender = "Male";
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BMI Calculator",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        backgroundColor: Colors.blue[700],
        actions: [
          Switch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField("Your Name", nameController),
              SizedBox(height: 16),
              _buildInputField("Your Age", ageController),
              SizedBox(height: 16),
              _buildInputField("Your Height (Cm)", heightController),
              SizedBox(height: 16),
              _buildInputField("Your Weight (Kg)", weightController),
              SizedBox(height: 16),
              _buildGenderSelection(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  calculateBMI();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25), // Updated to have a radius of 25
                  ),
                ),
                child: Text(
                  'Result BMI',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  resetForm();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25), // Updated to have a radius of 25
                  ),
                ),
                icon: Icon(Icons.refresh),
                label: Text(
                  'Reset BMI',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'BMI Calculator',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              _buildResultContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: "Input $label",
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(25), // Updated to have a radius of 30
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRadioButton("Male"),
        SizedBox(width: 16),
        _buildRadioButton("Female"),
      ],
    );
  }

  Widget _buildRadioButton(String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: gender,
          onChanged: (val) {
            setState(() {
              gender = val.toString();
            });
          },
        ),
        Text(value),
      ],
    );
  }

  Widget _buildResultContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Result Your BMI:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          isLoading
              ? CircularProgressIndicator()
              : Text(
                  result,
                  style: TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }

  void calculateBMI() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);
    String name = nameController.text;
    String age = ageController.text;
    double a = height / 100.roundToDouble();

    // double bmi = (gender == 'Male')
    //     ? weight / ((height/ 100) * (height / 100)/0.0001)
    //     : weight / ((height/ 100) * (height/ 100)) * 0.9;

    // String resultText = '';
    // if (bmi < 18.5) {
    //   resultText = 'Underweight (Kekurangan Berat Badan)';
    // } else if (bmi >= 18.5 && bmi < 24.9) {
    //   resultText = 'Normal weight (Ideal)';
    // } else if (bmi >= 25 && bmi < 29.9) {
    //   resultText = 'Overweight (Kelebihan Berat Badan)';
    // } else {
    //   resultText = 'Obese (Obesitas)';
    // }

    double heightInMeter =
        height / 100.0; // Mengubah tinggi dari sentimeter ke meter

    double bmi = (gender == 'Male')
        ? weight / (heightInMeter * heightInMeter / 0.0001)
        : weight / (heightInMeter * heightInMeter) * 0.9;

    String resultText = '';
    if (bmi < 18.5) {
      resultText = 'Underweight (Kekurangan Berat Badan)';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      resultText = 'Normal weight (Ideal)';
    } else if (bmi >= 25 && bmi < 29.9) {
      resultText = 'Overweight (Kelebihan Berat Badan)';
    } else {
      resultText = 'Obese (Obesitas)';
    }

    setState(() {
      result =
          'Name: $name\nAge: $age\nBMI: ${bmi.toStringAsFixed(2)}\nStatus: $resultText';
      isLoading = false;
    });
  }

  void resetForm() {
    setState(() {
      heightController.text = '';
      weightController.text = '';
      nameController.text = '';
      ageController.text = '';
      gender = 'Male';
      result = '';
    });
  }
}
