import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget {
  String image;
  String firstName;
  String lastName;
  String contact;
  String location;
  String email;
  ProfileEdit(
      {this.image,
      this.firstName,
      this.lastName,
      this.contact,
      this.location,
      this.email});

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      nameController.text = widget.email;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Edit"),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                color: Colors.pink,
              ),
              widget.image == ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        'https://i.pinimg.com/originals/83/c0/0f/83c00f59d66869aa22d3bd5f35e26c6d.png',
                        height: 120,
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.network(
                            widget.image,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
              InkWell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0, left: 120),
                    child: Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                )),
          ),
          RaisedButton(
            onPressed: () {
              print(nameController.text);
            },
            child: Text("Update"),
          )
        ],
      ),
    );
  }
}
