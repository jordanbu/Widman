class SerializacionUtils {
  static String generarCadenaEnvioAlServidor(List<Object?> lista) {
    String cadena = serializarDatos(lista);
    return cadena.endsWith('|') ? cadena.substring(0, cadena.length - 1) : cadena;
  }

  static String serializarDatos(List<Object?> lista) {
    String res = '';
    for (var obj in lista) {
      if (obj is String) {
        res += '0$obj|';
      } else if (obj is int) {
        res += '1$obj|';
      } else if (obj is double) {
        res += '2$obj|';
      } else if (obj is bool) {
        res += '3${obj ? 1 : 0}|';
      } else if (obj == null) {
        res += '5|';
      } else if (obj is DateTime) {
        String fecha = '${obj.day}/${obj.month}/${obj.year}';
        res += '4$fecha|';
      } else if (obj is List) {
        res += '6${serializarDatos(obj)}7|';
      } else {
        throw Exception('Tipo no soportado: ${obj.runtimeType}');
      }
    }
    return res;
  }
}
