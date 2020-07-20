import 'package:flutter/material.dart';
import 'package:flutter_crud/model/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  void _loadFormData(User user) {
    if (user != null) {
      _formData['id'] = user.id;
      _formData['name'] = user.name;
      _formData['email'] = user.email;
      _formData['avatarUrl'] = user.avatarUrl;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final User user = ModalRoute.of(context).settings.arguments;

    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Usuário'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final isValid = _form.currentState.validate();
              if (isValid) {
                _form.currentState.save();
                Provider.of<Users>(context, listen: false).put(
                  User(
                      id: _formData['id'],
                      name: _formData['name'],
                      email: _formData['email'],
                      avatarUrl: _formData['avatarUrl']),
                );
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                TextFormField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    initialValue: _formData['name'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo deve ser informado.';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['name'] = value),
                TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    initialValue: _formData['email'],
                    onSaved: (value) => _formData['email'] = value),
                TextFormField(
                    decoration: InputDecoration(labelText: 'URL do Avatar'),
                    initialValue: _formData['avatarUrl'],
                    onSaved: (value) => _formData['avatarUrl'] = value),
              ],
            ),
          )),
    );
  }
}
