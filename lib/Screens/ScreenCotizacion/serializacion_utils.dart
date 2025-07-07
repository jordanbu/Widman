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
        // Aquí serializamos la lista de productos como una sola lista anidada
        res += serializarListaProductos(obj);
      } else {
        throw Exception('Tipo no soportado: ${obj.runtimeType}');
      }
    }
    return res;
  }

  // Serializa la lista de productos correctamente
  static String serializarListaProductos(List lista) {
    String res = '';
    for (var item in lista) {
      if (item is List) {
        // Cada producto es una lista de sus atributos
        for (var elemento in item) {
          if (elemento is String) {
            res += '0$elemento|';
          } else if (elemento is int) {
            res += '1$elemento|';
          } else if (elemento is double) {
            res += '2$elemento|';
          } else if (elemento is bool) {
            res += '3${elemento ? 1 : 0}|';
          } else if (elemento == null) {
            res += '5|';
          } else {
            res += '$elemento|';
          }
        }
        // Delimitador de producto
        res += '7|';
      }
    }
    // Delimitador de fin de lista de productos (importante)
    res += '7|';
    return res;
  }
}

