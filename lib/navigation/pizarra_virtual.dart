import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenPizarraVirtual/wave_clipper.dart';

class PizarraVirtual extends StatefulWidget {
  const PizarraVirtual({super.key});

  @override
  _AgendaPizarraState createState() => _AgendaPizarraState();
}

class _AgendaPizarraState extends State<PizarraVirtual> {
  List<Offset?> puntos = [];
  List<NotaAgenda> notas = [];
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  bool _mostrandoPizarra = true;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _guardarNota() {
    if (_tituloController.text.isNotEmpty) {
      setState(() {
        notas.add(NotaAgenda(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          titulo: _tituloController.text,
          descripcion: _descripcionController.text,
          dibujo: List.from(puntos),
          fechaCreacion: DateTime.now(),
        ));

        // Limpiar campos
        _tituloController.clear();
        _descripcionController.clear();
        puntos.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nota guardada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un título para la nota'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _eliminarNota(String id) {
    setState(() {
      notas.removeWhere((nota) => nota.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nota eliminada'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _verNota(NotaAgenda nota) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        nota.titulo,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF455A64),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Creada el ${_formatearFecha(nota.fechaCreacion)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                if (nota.descripcion.isNotEmpty) ...[
                  const Text(
                    'Descripción:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nota.descripcion,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                ],
                if (nota.dibujo.isNotEmpty) ...[
                  const Text(
                    'Dibujo:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: CustomPaint(
                        painter: PizarraPainter(nota.dibujo),
                        child: const SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo con curva
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: screenHeight * 0.6,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A4D69), Color(0xFF3C5A74)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar personalizado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Agenda con Pizarra',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const Spacer(),
                      // Botones para cambiar vista
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: _mostrandoPizarra ? Colors.white : Colors.white70,
                              size: 24,
                            ),
                            onPressed: () => setState(() => _mostrandoPizarra = true),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.list,
                              color: !_mostrandoPizarra ? Colors.white : Colors.white70,
                              size: 20,
                              weight: 80,
                            ),
                            onPressed: () => setState(() => _mostrandoPizarra = false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _mostrandoPizarra ? _buildPizarraView() : _buildNotasView(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPizarraView() {
    return Column(
      children: [
        const Text(
          'Nueva Nota',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF455A64),
          ),
        ),
        const SizedBox(height: 16),

        // Campo título
        TextField(
          controller: _tituloController,
          decoration: InputDecoration(
            labelText: 'Título de la nota',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.title),
          ),
        ),
        const SizedBox(height: 12),

        // Campo descripción
        TextField(
          controller: _descripcionController,
          decoration: InputDecoration(
            labelText: 'Descripción (opcional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.description),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        const Text(
          'Zona de Dibujo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF455A64),
          ),
        ),
        const SizedBox(height: 8),

        // Zona de dibujo
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              RenderBox box = context.findRenderObject() as RenderBox;
              Offset point = box.globalToLocal(details.globalPosition);
              setState(() {
                puntos.add(point);
              });
            },
            onPanEnd: (_) {
              setState(() {
                puntos.add(null);
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: PizarraPainter(puntos),
                child: Container(
                  color: Colors.grey[200],
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Botones de acción
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  puntos.clear();
                });
              },
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _guardarNota,
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotasView() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Mis Notas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF455A64),
              ),
            ),
            const Spacer(),
            Text(
              '${notas.length} nota${notas.length != 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (notas.isEmpty)
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_add,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay notas guardadas',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Crea tu primera nota usando la pizarra',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: notas.length,
              itemBuilder: (context, index) {
                final nota = notas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF2A4D69),
                      child: Text(
                        nota.titulo[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      nota.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (nota.descripcion.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            nota.descripcion,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          _formatearFecha(nota.fechaCreacion),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (nota.dibujo.isNotEmpty)
                          const Icon(
                            Icons.brush,
                            color: Colors.blue,
                            size: 20,
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarNota(nota.id),
                        ),
                      ],
                    ),
                    onTap: () => _verNota(nota),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class NotaAgenda {
  final String id;
  final String titulo;
  final String descripcion;
  final List<Offset?> dibujo;
  final DateTime fechaCreacion;

  NotaAgenda({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.dibujo,
    required this.fechaCreacion,
  });
}

class PizarraPainter extends CustomPainter {
  final List<Offset?> puntos;
  PizarraPainter(this.puntos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < puntos.length - 1; i++) {
      if (puntos[i] != null && puntos[i + 1] != null) {
        canvas.drawLine(puntos[i]!, puntos[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(PizarraPainter oldDelegate) => true;
}
