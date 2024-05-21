import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final String title;
  final Widget body;

  const Accordion({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> with TickerProviderStateMixin {
  bool _showContent = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(widget.title),
            trailing: IconButton(
              icon: Icon(
                _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
              onPressed: () {
                setState(
                  () {
                    _showContent = !_showContent;
                  },
                );
              },
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _showContent
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    child: widget.body,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
