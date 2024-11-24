class User{
  final String ?id;
  final String name;
  final String lastname;
  final String phone;

  User({
    this.id,
    required this.name,
    required this.lastname,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      phone: json['phone']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'name': name,
      'lastname': lastname,
      'phone': phone
    };
  }
}