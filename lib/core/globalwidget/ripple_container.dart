
import 'package:flutter/material.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class RippleContainer extends StatelessWidget {

Function()? onTap;
Widget? child;
BorderRadius? borderRadius;
Color? color;
   RippleContainer({
    Key? key,
    this.onTap,
    this.child,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return  TouchRippleEffect(
      onTap: onTap,
                borderRadius: borderRadius ?? BorderRadius.circular(5), 
                rippleColor: color ??  Colors.white60,
                child: child,
                );
  }
}