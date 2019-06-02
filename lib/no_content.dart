import 'package:flutter/material.dart';

class NoContent extends StatelessWidget {
    const NoContent();

    @override
    Widget build(BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    // SvgPicture.asset(
                    //     'assets/undraw_code_typing_7jnv.svg',
                    //     height: 200.0,
                    // ),
                    const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: const Text('Do things, big.'),
                    )
                ],
            )
        );
    }    
}