import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'staff_list_page.dart';

class StaffFormPage extends StatefulWidget {
  final bool isEditing;
  final String? docId;
  final String? currentName;
  final String? currentId;
  final String? currentAge;

  StaffFormPage({
    this.isEditing = false,
    this.docId,
    this.currentName,
    this.currentId,
    this.currentAge,
  });

  @override
  _StaffFormPageState createState() => _StaffFormPageState();
}

class _StaffFormPageState extends State<StaffFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      nameController.text = widget.currentName ?? '';
      idController.text = widget.currentId ?? '';
      ageController.text = widget.currentAge ?? '';
    }
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': nameController.text,
        'id': idController.text,
        'age': int.parse(ageController.text),
      };

      final collection = FirebaseFirestore.instance.collection('staffs');

      if (widget.isEditing && widget.docId != null) {
        await collection.doc(widget.docId).update(data);
      } else {
        await collection.add(data);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => StaffListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Staff Member' : 'Add New Staff',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    widget.isEditing ? Icons.edit : Icons.person_add,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.isEditing ? 'Update Staff Information' : 'Enter Staff Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.purple[50]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInputField(
                        controller: nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                        validator: (val) => val == null || val.isEmpty ? 'Please enter full name' : null,
                      ),
                      SizedBox(height: 20),
                      _buildInputField(
                        controller: idController,
                        label: 'Staff ID',
                        icon: Icons.badge,
                        validator: (val) => val == null || val.isEmpty ? 'Please enter staff ID' : null,
                      ),
                      SizedBox(height: 20),
                      _buildInputField(
                        controller: ageController,
                        label: 'Age',
                        icon: Icons.cake,
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                            val == null || val.isEmpty || int.tryParse(val) == null 
                                ? 'Please enter a valid age' : null,
                      ),
                      SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitData,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            widget.isEditing ? 'Update Staff' : 'Add Staff',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
