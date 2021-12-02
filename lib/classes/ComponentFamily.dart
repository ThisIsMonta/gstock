import 'package:flutter/material.dart';

import 'Component.dart';

class ComponentFamily {
  final String name;
  final List<Component> components;

  ComponentFamily({
    required this.name,
    required this.components,
  });
}