import 'package:flutter/material.dart';
import 'package:fluttertavobloc/apis/reserva_api.dart';
import 'package:fluttertavobloc/modelo/reservaModelo.dart';

class ReservaScreen extends StatefulWidget {
  @override
  _ReservaScreenState createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  List<ReservaModelo> reservaList = [];
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController horaController = TextEditingController();
  final TextEditingController cantidadPersonasController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  ReservaModelo? editingReserva;

  @override
  void initState() {
    super.initState();
    loadReservaList();
  }

  Future<void> loadReservaList() async {
    try {
      final api = ReservaApi.create();
      final reservas = await api.listReserva();
      setState(() {
        reservaList = reservas;
      });
    } catch (e) {
      print("Error al cargar la lista de reservas: $e");
    }
  }

  Future<void> deleteReserva(int reservaId) async {
    try {
      final api = ReservaApi.create();
      await api.deleteReserva(reservaId);
      await loadReservaList();
    } catch (e) {
      print("Error al eliminar la reserva: $e");
    }
  }

  Future<void> createReserva() async {
    final String cliente = clienteController.text;
    final String fecha = fechaController.text;
    final String hora = horaController.text;
    final String cantidadPersonas = cantidadPersonasController.text;
    final String precio = precioController.text;

    if (cliente.isEmpty || fecha.isEmpty || hora.isEmpty || cantidadPersonas.isEmpty || precio.isEmpty) {
      print("Por favor, complete todos los campos");
      return;
    }

    try {
      final api = ReservaApi.create();
      final newReserva = ReservaModelo(
        idReserva: 1,
        cliente: cliente,
        telefono: '',
        fecha: fecha,
        hora: hora,
        cantidadPersonas: cantidadPersonas,
        precio: precio,
      );

      await api.createReserva(newReserva);
      await loadReservaList();
      clienteController.clear();
      fechaController.clear();
      horaController.clear();
      cantidadPersonasController.clear();
      precioController.clear();
    } catch (e) {
      print("Error al crear la reserva: $e");
    }
  }

  Future<void> editReserva(ReservaModelo reserva) {
    setState(() {
      editingReserva = reserva;
      clienteController.text = reserva.cliente;
      fechaController.text = reserva.fecha;
      horaController.text = reserva.hora;
      cantidadPersonasController.text = reserva.cantidadPersonas;
      precioController.text = reserva.precio;
    });

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservas'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: clienteController,
                  decoration: InputDecoration(labelText: 'Cliente'),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: fechaController,
                  decoration: InputDecoration(labelText: 'Fecha'),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: horaController,
                  decoration: InputDecoration(labelText: 'Hora'),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: cantidadPersonasController,
                  decoration: InputDecoration(labelText: 'Cantidad de Personas'),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: precioController,
                  decoration: InputDecoration(labelText: 'Precio'),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 10),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          if (editingReserva != null) {
                            updateReserva();
                          } else {
                            createReserva();
                          }
                          loadReservaList();
                        },
                        child: Text(editingReserva != null ? 'Actualizar' : 'Crear'),
                      ),
                      SizedBox(width: 10), // Añadir espacio entre los botones si es necesario
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            editingReserva = null;
                            clienteController.clear();
                            fechaController.clear();
                            horaController.clear();
                            cantidadPersonasController.clear();
                            precioController.clear();
                          });
                        },
                        child: Text('Cancelar'),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          reservaList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: reservaList.length,
              itemBuilder: (context, index) {
                final reserva = reservaList[index];
                return ListTile(
                  title: Text(reserva.cliente),
                  subtitle: Text('Fecha: ${reserva.fecha}, Hora: ${reserva.hora}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          editReserva(reserva);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Eliminar Reserva'),
                                content: Text('¿Estás seguro de que deseas eliminar esta reserva?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Eliminar'),
                                    onPressed: () {
                                      deleteReserva(reserva.idReserva);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateReserva() async {
    if (editingReserva == null) {
      return;
    }

    final String cliente = clienteController.text;
    final String fecha = fechaController.text;
    final String hora = horaController.text;
    final String cantidadPersonas = cantidadPersonasController.text;
    final String precio = precioController.text;

    if (cliente.isEmpty || fecha.isEmpty || hora.isEmpty || cantidadPersonas.isEmpty || precio.isEmpty) {
      print("Por favor, complete todos los campos");
      return;
    }

    try {
      final api = ReservaApi.create();
      final updatedReserva = ReservaModelo(
        idReserva: editingReserva!.idReserva,
        cliente: cliente,
        telefono: '',
        fecha: fecha,
        hora: hora,
        cantidadPersonas: cantidadPersonas,
        precio: precio,
      );

      await api.updateReserva(editingReserva!.idReserva, updatedReserva);
      await loadReservaList();
      editingReserva = null;
      clienteController.clear();
      fechaController.clear();
      horaController.clear();
      cantidadPersonasController.clear();
      precioController.clear();
    } catch (e) {
      print("Error al actualizar la reserva: $e");
    }
  }
}
