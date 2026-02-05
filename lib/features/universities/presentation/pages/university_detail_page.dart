import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';

// Página de detalle de universidad
class UniversityDetailPage extends StatefulWidget {
  final University university;

  const UniversityDetailPage({super.key, required this.university});

  @override
  State<UniversityDetailPage> createState() => _UniversityDetailPageState();
}

class _UniversityDetailPageState extends State<UniversityDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentCountController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    // Cargar datos existentes
    if (widget.university.imagePath != null) {
      _selectedImage = File(widget.university.imagePath!);
    }
    if (widget.university.studentCount != null) {
      _studentCountController.text = widget.university.studentCount.toString();
    }
  }

  @override
  void dispose() {
    _studentCountController.dispose();
    super.dispose();
  }

  // Método para mostrar el diálogo de selección
  Future<void> _showImageSourceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.add_photo_alternate,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 12),
              Text('Seleccionar imagen'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.blue, size: 28),
                ),
                title: Text(
                  'Cámara',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Tomar una foto nueva'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              Divider(),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
                title: Text(
                  'Galería',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Seleccionar de galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  // Método para seleccionar la imagen
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _hasChanges = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('¡Imagen cargada exitosamente!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Text('Error al cargar la imagen'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Método para guardar los datos
  void _saveData() {
    if (_formKey.currentState!.validate()) {
      final studentCount = int.parse(_studentCountController.text);

      setState(() {
        _hasChanges = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✓ Datos guardados exitosamente',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('Estudiantes: ${_formatNumber(studentCount.toString())}'),
              if (_selectedImage != null) Text('Imagen: Cargada'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatNumber(String value) {
    if (value.isEmpty) return '0';
    final number = int.parse(value);
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Devolver los datos modificados cuando se sale de la página
        if (_hasChanges) {
          Navigator.of(context).pop({
            'imagePath': _selectedImage?.path,
            'studentCount': _studentCountController.text.isNotEmpty 
                ? int.tryParse(_studentCountController.text) 
                : null,
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.university.name ?? 'Detalle'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenedor de imagen
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[200],
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Mostrar la imagen seleccionada o el ícono por defecto
                  _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Sin imagen',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                  // Botón flotante
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: _showImageSourceDialog,
                      child: Icon(Icons.add_a_photo),
                      tooltip: 'Cambiar imagen',
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: TextButton.icon(
                onPressed: _showImageSourceDialog,
                icon: Icon(Icons.camera_alt),
                label: Text('Cambiar imagen'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),

            // Encabezado con nombre
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.university.name ?? 'Universidad',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white70, size: 18),
                      SizedBox(width: 4),
                      Text(
                        widget.university.country ?? 'País desconocido',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formulario de estudiantes
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.people, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'Número de Estudiantes',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _studentCountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'Cantidad de estudiantes',
                                hintText: 'Ej: 5000',
                                prefixIcon: Icon(Icons.school),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa el número de estudiantes';
                                }

                                final number = int.tryParse(value);

                                if (number == null) {
                                  return 'Ingresa un número válido';
                                }

                                if (number <= 0) {
                                  return 'El número debe ser mayor a 0';
                                }

                                if (number > 1000000) {
                                  return 'El número no puede exceder 1,000,000';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _saveData,
                                icon: Icon(Icons.save),
                                label: Text('Guardar Datos'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Información general
                  _buildSectionTitle('Información General', Icons.info_outline),
                  SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            icon: Icons.public,
                            label: 'País',
                            value:
                                widget.university.country ?? 'No especificado',
                          ),
                          Divider(height: 24),
                          _buildInfoRow(
                            icon: Icons.flag,
                            label: 'Código País',
                            value: widget.university.alphaTwoCode ?? 'N/A',
                          ),
                          if (widget.university.stateProvince != null) ...[
                            Divider(height: 24),
                            _buildInfoRow(
                              icon: Icons.map,
                              label: 'Estado/Provincia',
                              value: widget.university.stateProvince!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Dominios
                  if (widget.university.domains != null &&
                      widget.university.domains!.isNotEmpty) ...[
                    _buildSectionTitle('Dominios', Icons.language),
                    SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.university.domains!.map((domain) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      domain,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],

                  // Páginas web
                  if (widget.university.webPages != null &&
                      widget.university.webPages!.isNotEmpty) ...[
                    _buildSectionTitle('Enlaces', Icons.link),
                    SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: widget.university.webPages!.map((url) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.open_in_new,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      url,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
