import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {

  final String option; //the abcd inside circle
  final String ansOptions; // the 4 options
  final String crtAns, optSel;
  OptionTile({@required this.optSel, @required this.crtAns, @required this.ansOptions, @required this.option});

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: widget.ansOptions == widget.optSel ?
              widget.optSel == widget.crtAns ?
              Colors.green.withOpacity(0.7):
              Colors.red.withOpacity(0.7) :
              Colors.grey,
                width: 1.4,
              ),
              color: widget.optSel == widget.ansOptions
                  ? widget.ansOptions == widget.crtAns
                  ? Colors.green.withOpacity(0.7)
                  : Colors.red.withOpacity(0.7)
                  : Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              widget.option,
              style: TextStyle(
                color: widget.optSel == widget.ansOptions
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          ),
          SizedBox(width: 8,),
          Text(widget.ansOptions,style: TextStyle(fontSize: 16, color: Colors.black54),)
        ],
      ),
    );
  }
}
