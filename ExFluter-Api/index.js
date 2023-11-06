const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();

app.use(function(req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', '*');
    next();
});

app.use(bodyParser.json());

const PUERTO = 8080;

const conexion = mysql.createConnection(
    {
        host: 'localhost',
        database: 'services',
        user: 'root',
        password: ''
    }
);

app.listen(PUERTO, () => {
    console.log(`Servidor corriendo en el puerto ${PUERTO}`);
});

conexion.connect(error => {
    if (error) throw error;
    console.log('Conexión exitosa a la base de datos');
});

app.get('/', (req, res) => {
    res.send('API');
});

// Ruta para obtener todas las reservas
app.get('/reservas', (req, res) => {
    const query = 'SELECT * FROM reservas;';
    conexion.query(query, (error, resultado) => {
        if (error) return console.error(error.message);

        if (resultado.length > 0) {
            res.json(resultado);
        } else {
            res.json([]);
        }
    });
});

// Ruta para obtener una reserva por ID
app.get('/reservas/:id', (req, res) => {
    const { id } = req.params;
    const query = `SELECT * FROM reservas WHERE id_reserva=${id};`;
    conexion.query(query, (error, resultado) => {
        if (error) return console.error(error.message);

        if (resultado.length > 0) {
            res.json(resultado);
        } else {
            res.json([]);
        }
    });
});

// Ruta para agregar una reserva
app.post('/reservas', (req, res) => {
    const reserva = {
        cliente: req.body.cliente,
        telefono: req.body.telefono,
        fecha: req.body.fecha,
        hora: req.body.hora,
        cantidad_Personas: req.body.cantidad_Personas,
        precio: req.body.precio
    };

    const query = 'INSERT INTO reservas SET ?';
    conexion.query(query, reserva, (error) => {
        if (error) {
            console.error(error.message);
            res.status(500).json({ mensaje: "Error al agregar la reserva" });
        } else {
            res.status(200).json({ mensaje: "Se insertó correctamente la reserva" });
        }
    });
});

// Ruta para actualizar una reserva por ID
app.put('/reservas/:id', (req, res) => {
    const { id } = req.params;
    const {
        cliente,
        telefono,
        fecha,
        hora,
        cantidad_Personas,
        precio
    } = req.body;

    const query = `UPDATE reservas SET
        cliente='${cliente}',
        telefono='${telefono}',
        fecha='${fecha}',
        hora='${hora}',
        cantidad_Personas='${cantidad_Personas}',
        precio='${precio}'
        WHERE id_reserva=${id};`;

    conexion.query(query, (error) => {
        if (error) {
            console.error(error.message);
            res.status(500).json({ mensaje: "Error al actualizar la reserva" });
        } else {
            res.status(200).json({ mensaje: "Se actualizó correctamente la reserva" });
        }
    });
});

// Ruta para eliminar una reserva por ID
app.delete('/reservas/:id', (req, res) => {
    const { id } = req.params;

    const query = `DELETE FROM reservas WHERE id_reserva=${id};`;
    conexion.query(query, (error) => {
        if (error) {
            console.error(error.message);
            res.status(500).json({ mensaje: "Error al eliminar la reserva" });
        } else {
            res.status(200).json({ mensaje: "Se eliminó correctamente la reserva" });
        }
    });
});
