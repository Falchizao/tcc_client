import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scarlet_graph/models/offer_model.dart';
import 'package:scarlet_graph/utils/handler.dart';
import "package:http/http.dart" as http;
import '../utils/constants.dart';
import '../utils/requests.dart';
import 'jwtservice.dart';

class RegisterOffer extends StatefulWidget {
  @override
  _RegisterOfferState createState() => _RegisterOfferState();
}

class _RegisterOfferState extends State<RegisterOffer> {
  final _formKey = GlobalKey<FormState>();
  String _salary = '';
  String _content = '';
  String _title = '';
  String _hours = '';
  String _location = '';
  String _requirements = '';
  bool _accRemote = false;

  Future _addOffer() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    var token = await JwtService().getToken();
    var response = await http.post(Uri.parse('$BASE_URL/$OFFER/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          "content": _content,
          "salary": _salary,
          "title": _title,
          "hours": _hours,
          "location": _location,
          "remote": _accRemote,
          "requirements": _requirements,
        }));

    Navigator.of(context).pop();
    if (response.statusCode == 201) {
      handleToast("Offer added with success!");
      Get.back();
    } else {
      handleToast("Erro while trying to add new offer!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'New Offer',
              style: GoogleFonts.pacifico(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: TextEditingController(text: _title),
                  onChanged: (title) {
                    _title = title;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Offer title',
                  ),
                  validator: (title) {
                    if (title != null && title.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (title) {
                    if (title != null && title.isEmpty) {
                      _title = title;
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: TextEditingController(text: _content),
                  onChanged: (content) {
                    _content = content;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  validator: (content) {
                    if (content != null && content.isEmpty) {
                      return 'Please enter some description';
                    }
                    return null;
                  },
                  onSaved: (content) {
                    if (content != null && content.isEmpty) {
                      _content = content;
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: TextEditingController(text: _hours),
                  onChanged: (value) {
                    _hours = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hours per day',
                  ),
                  validator: (hours) {
                    if (hours == null) {
                      return 'Please enter some text';
                    }
                    if (hours.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (double.tryParse(hours) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (hours) {
                    if (hours != null) {
                      _hours = hours;
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: TextEditingController(text: _salary),
                  onChanged: (salary) {
                    _salary = salary;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Salary',
                    border: OutlineInputBorder(),
                  ),
                  validator: (salary) {
                    if (salary != null && salary.isEmpty) {
                      return 'Please enter the salary';
                    }
                    return null;
                  },
                  onSaved: (salary) {
                    if (salary != null && salary.isEmpty) {
                      _salary = salary;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: TextEditingController(text: _requirements),
                  onChanged: (requirement) {
                    _requirements = requirement;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Requirements',
                  ),
                  validator: (requirement) {
                    return null;
                  },
                  onSaved: (requirement) {
                    if (requirement != null && requirement.isEmpty) {
                      _requirements = requirement;
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: TextEditingController(text: _location),
                  onChanged: (location) {
                    _location = location;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Location',
                  ),
                  validator: (location) {
                    return null;
                  },
                  onSaved: (location) {
                    if (location != null && location.isEmpty) {
                      _location = location;
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Checkbox(
                      value: _accRemote,
                      onChanged: (value) {
                        setState(() {
                          _accRemote = value!;
                        });
                      },
                    ),
                    Text('Accepts Remote?'),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null) {
                      _addOffer();
                    }
                  },
                  child: Text('Register new offer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
