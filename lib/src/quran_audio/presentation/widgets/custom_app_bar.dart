import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const NavBarItem(
            icon: Icons.arrow_back_ios,
          ),
          Text(
            'Playing Now',
            style: TextStyle(
                fontSize: 20,
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w500),
          ),
          const NavBarItem(
            icon: Icons.list,
          )
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;

  const NavBarItem({super.key, this.icon = Icons.arrow_back});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                offset: const Offset(5, 10),
                spreadRadius: 3,
                blurRadius: 10),
            BoxShadow(
                color: theme.colorScheme.surface.withValues(alpha: 0.3),
                offset: const Offset(-3, -4),
                spreadRadius: -2,
                blurRadius: 20)
          ],
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10)),
      child: Icon(
        icon,
        color: theme.colorScheme.secondary,
      ),
    );
  }
}
