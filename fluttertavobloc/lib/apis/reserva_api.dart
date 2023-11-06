import 'package:dio/dio.dart';
import 'package:fluttertavobloc/modelo/reservaModelo.dart';
import 'package:fluttertavobloc/utils/UrlApi.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';

part 'reserva_api.g.dart';
@RestApi(baseUrl: UrlApi.urlApix)
abstract class ReservaApi {
  factory ReservaApi(Dio dio, {String baseUrl}) = _ReservaApi;

  static ReservaApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return ReservaApi(dio);
  }

  @POST("/reservas")
  Future<ReservaModelo> createReserva(@Body() ReservaModelo reserva);

  @GET("/reservas/{id}")
  Future<ReservaModelo> getReserva(@Path() int id);

  @PUT("/reservas/{id}")
  Future<ReservaModelo> updateReserva(@Path() int id, @Body() ReservaModelo reserva);

  @DELETE("/reservas/{id}")
  Future<void> deleteReserva(@Path() int id);

  @GET("/reservas")
  Future<List<ReservaModelo>> listReserva();

}