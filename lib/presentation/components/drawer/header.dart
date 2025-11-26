import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatelessWidget {
  final bool isColapsed;
  final VoidCallback? onToggle;

  const CustomDrawerHeader({Key? key, required this.isColapsed, this.onToggle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logo-dago.webp", width: 64),
          if (isColapsed) const SizedBox(width: 10),
          if (isColapsed)
            const Expanded(
              flex: 3,
              child: Text(
                'Dago Valley',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (isColapsed) const Spacer(),
          if (isColapsed)
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: onToggle,
                icon: Icon(
                  isColapsed ? Icons.menu_open : Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
