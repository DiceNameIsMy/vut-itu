import 'package:flutter/material.dart';
import 'package:vut_itu/trip/place_model.dart';

class PlaceCardView extends StatelessWidget {
  final PlaceModel p;
  final GestureTapCallback? onTap;
  final Widget? trailingWidget;

  const PlaceCardView(this.p, {super.key, this.onTap, this.trailingWidget});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.place),
      title: Text(p.title),
      subtitle: Text(p.description),
      trailing: trailingWidget,
      onTap: onTap,
    );
  }
}
