import 'package:flutter/material.dart';

class DropdownComponent extends StatelessWidget {

  final FocusNode? focusNode;
  final List<DropdownMenuItem<String>>? items;
  final String label;
  final String hint;
  final String? value;
  final String? Function(String?)? validator;
  final Function(dynamic)? onChanged;
  const DropdownComponent({ 
    Key? key,
    required this.label,
    required this.items,
    required this.validator,
    required this.onChanged,
    required this.hint,
    this.value,
    this.focusNode,
  }) : super(key: key);

  TextStyle textoNormal(double sizet) {
    return TextStyle(
      color: Colors.black,
      fontSize: sizet,
      height: 1.5,
    );
  }

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          value: value,
          focusNode: focusNode,
          items: items,
          // declaramos un validator para validar el campo
          validator: validator,
          
          // declaramos un onChanged para obtener el valor seleccionado
          onChanged: onChanged ,

          style: textoNormal(18),
          
          // cambiamos el color del dropdown
          dropdownColor: Colors.white,
          
          // cambiamos el icono
          icon: Icon(Icons.keyboard_arrow_down_outlined,),
          isExpanded: true,
          
          // cambiamos el tamaño del icono
          iconSize: 32,
          
          // cambiamos el color del dropdown
          

          // Le damos un estilo al dropdown
          decoration: InputDecoration(
            // ponemos el fondo del dropdown transparente
            filled: true,
            
            // le damos un color al fondo del dropdown
            fillColor:Colors.grey[300],
            
            // Le damos un icono al dropdown
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontSize: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
            )
          ),
        ),
      ],
    );
  }
}