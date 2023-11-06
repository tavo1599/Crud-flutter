class ReservaModelo {
  ReservaModelo({
    required this.idReserva,
    required this.cliente,
    required this.telefono,
    required this.fecha,
    required this.hora,
    required this.cantidadPersonas,
    required this.precio,
  });
  late final int idReserva;
  late final String cliente;
  late final String telefono;
  late final String fecha;
  late final String hora;
  late final String cantidadPersonas;
  late final String precio;

  factory ReservaModelo.fromJson(Map<String, dynamic> json){
    return ReservaModelo (
        idReserva : json['id_reserva'],
        cliente : json['cliente'],
        telefono : json['telefono'],
        fecha : json['fecha'],
        hora : json['hora'],
        cantidadPersonas : json['cantidad_Personas'],
        precio : json['precio']
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_reserva'] = idReserva;
    _data['cliente'] = cliente;
    _data['telefono'] = telefono;
    _data['fecha'] = fecha;
    _data['hora'] = hora;
    _data['cantidad_Personas'] = cantidadPersonas;
    _data['precio'] = precio;
    return _data;
  }
}