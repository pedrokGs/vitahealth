class Profile {
  final String id;
  final String userEmail;

  final String nome;
  final DateTime dataNascimento;

  final double peso;
  final double altura;
  final double imc;
  final String faixaImc;

  final Map<String, bool> caminhadaDays;
  final String horaCaminhada;

  final Map<String, bool> corridaDays;
  final String horaCorrida;

  final Map<String, bool> pularCordaDays;
  final String horaPularCorda;

  Profile({
    required this.id,
    required this.userEmail,
    required this.nome,
    required this.dataNascimento,
    required this.peso,
    required this.altura,
    required this.imc,
    required this.faixaImc,
    required this.caminhadaDays,
    required this.horaCaminhada,
    required this.corridaDays,
    required this.horaCorrida,
    required this.pularCordaDays,
    required this.horaPularCorda,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map["id"],
      userEmail: map["userEmail"],
      nome: map["nome"],
      dataNascimento: DateTime.parse(map["dataNascimento"]),
      peso: map["peso"],
      altura: map["altura"],
      imc: map["imc"],
      faixaImc: map["faixaImc"],
      caminhadaDays: Map<String, bool>.from(map["caminhadaDays"]),
      horaCaminhada: map["horaCaminhada"],
      corridaDays: Map<String, bool>.from(map["corridaDays"]),
      horaCorrida: map["horaCorrida"],
      pularCordaDays: Map<String, bool>.from(map["pularCordaDays"]),
      horaPularCorda: map["horaPularCorda"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userEmail": userEmail,
      "nome": nome,
      "dataNascimento": dataNascimento.toIso8601String(),
      "peso": peso,
      "altura": altura,
      "imc": imc,
      "faixaImc": faixaImc,
      "caminhadaDays": caminhadaDays,
      "horaCaminhada": horaCaminhada,
      "corridaDays": corridaDays,
      "horaCorrida": horaCorrida,
      "pularCordaDays": pularCordaDays,
      "horaPularCorda": horaPularCorda,
    };
  }
}
