class User {
  final String email;
  final String password;
  final String celular;
  final String usuario;
  final String foto;

  const User({
    required this.email,
    required this.password,
    required this.celular,
    required this.usuario,
    required this.foto,
  });

  Map<String, dynamic> toMap() => {
    "email": email,
    "password": password,
    "celular": celular,
    "usuario": usuario,
    "foto": foto,
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    email: map["email"],
    password: map["password"],
    celular: map["celular"],
    usuario: map['usuario'],
    foto: map['foto'],
  );
}
