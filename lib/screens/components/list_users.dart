import 'package:crud_api/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_api/models/user.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({ Key? key }) : super(key: key);

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {

  @override
  void initState() {
    super.initState();
    // Llama a fetchUsers cuando se inicia el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  TextEditingController _editNameController = TextEditingController();
  TextEditingController _editLastnameController = TextEditingController();
  TextEditingController _editPhoneController = TextEditingController();

  void editUser(User user){
    _editNameController.text = user.name;
    _editLastnameController.text = user.lastname;
    _editPhoneController.text = user.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lista de usuarios", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<UserProvider>(
            builder: (context, userProvider, child){
              return ListView.builder(
                itemCount: userProvider.users.length,
                itemBuilder: (context, index){
                  User user = userProvider.users[index];
                  return ListTile(
                    title: Text(user.id ?? "algo") ,
                    subtitle: Text(user.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        updateUser(user, context),
                        deleteUser(userProvider, user, context),
                      ],
                    )
                  );
                },
              );
            }
          ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){  
          showDialog(context: context, 
            builder: (context){
              return addUser(context);
            }
          );
        },
        backgroundColor: Colors.grey.shade900,
        child: Icon(Icons.add, color: Colors.white,),
        
      ),
    );
  }

  IconButton updateUser(User user, BuildContext context) {
    return IconButton(
      onPressed: (){
        editUser(user);
        showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: Text("Editar Usuario"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _editNameController,
                    decoration: InputDecoration(label: Text("Nombre")),
                  ),
                  TextField(
                    controller: _editLastnameController,
                    decoration: InputDecoration(label: Text("Apellido")),
                  ),
                  TextField(
                    controller: _editPhoneController,
                    decoration: InputDecoration(label: Text("Celular")),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: (){
                    Provider.of<UserProvider>(context, listen: false).updateUser(
                      user.id ?? "XD", 
                      User(
                        name: _editNameController.text, 
                        lastname: _editLastnameController.text, 
                        phone: _editPhoneController.text
                      )
                    );
                    Navigator.pop(context);
                  }, 
                  child: Text("Actualizar usuario")
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: Text("Cancelar")
                  )
              ],
            );
          }
        );
      }, 
      icon: Icon(Icons.edit)
    );
  }

  IconButton deleteUser(UserProvider userProvider, User user, BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade500,),
      onPressed: (){
        userProvider.deleteUser(user.id ?? "XD");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario eliminado"))
        );
      },
    );
  }

  AlertDialog addUser(BuildContext context) {
    return AlertDialog(
      title: Text("Agregar usuarios"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(label: Text("Nombre")),
          ),
          TextField(
            controller: _lastnameController,
            decoration: InputDecoration(label: Text("Apellido")),
          ),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(label: Text("Celular")),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: (){
            Provider.of<UserProvider>(context, listen: false).addUser(
              User(
                name: _nameController.text, 
                lastname: _lastnameController.text, 
                phone: _phoneController.text
              )
            );
            _nameController.text = "";
            _lastnameController.text = "";
            _phoneController.text = "";
            Navigator.pop(context);
          }, 
          child: Text("Agregar")
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          child: Text("Cancelar")
        )
      ],
    );
  }

}