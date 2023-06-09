import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CountryCodeDropdown extends StatefulWidget {
  const CountryCodeDropdown({super.key});

  @override
  _CountryCodeDropdownState createState() => _CountryCodeDropdownState();
}

class _CountryCodeDropdownState extends State<CountryCodeDropdown> {
  String? _selectedCountryCode;

  final List<Map<String, dynamic>> _countryCodes = [
    {'name': 'Tanzania', 'code': '+255'},
    {'name': 'Afghanistan', 'code': '+93'},
    {'name': 'Albania', 'code': '+355'},
    {'name': 'Algeria', 'code': '+213'},
    {'name': 'American Samoa', 'code': '+1-684'},
    {'name': 'Andorra', 'code': '+376'},
    {'name': 'Angola', 'code': '+244'},
    {'name': 'Anguilla', 'code': '+1-264'},
    {'name': 'Antarctica', 'code': '+672'},
    {'name': 'Antigua and Barbuda', 'code': '+1-268'},
    {'name': 'Argentina', 'code': '+54'},
    {'name': 'Armenia', 'code': '+374'},
    {'name': 'Aruba', 'code': '+297'},
    {'name': 'Australia', 'code': '+61'},
    {'name': 'Austria', 'code': '+43'},
    {'name': 'Azerbaijan', 'code': '+994'},
    // ...
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8),
        border: const OutlineInputBorder(gapPadding: 5),
        alignLabelWithHint: true,
        // contentPadding: const EdgeInsets.all(3),

        label: Center(
          child: AutoSizeText(
            'Country Code',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        // border: OutlineInputBorder(),
        // hintText: 'code',
      ),
      value: _selectedCountryCode,
      style: Theme.of(context).textTheme.labelSmall,
      // .copyWith(overflow: TextOverflow.ellipsis),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCountryCode = newValue;
        });
      },
      items: _countryCodes.map((Map<String, dynamic> country) {
        return DropdownMenuItem<String>(
          // alignment: Alignment.centerStart,
          value: country['code'].toString(),
          child: AutoSizeText(
            '${country['name']}(${country['code']})',
            // overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        );
      }).toList(),
    );
  }
}
