import "package:flutter/material.dart";
import "package:lfti_app/classes/Constants.dart";

class SummaryCard extends StatelessWidget {
  final String label;
  final String data;
  final String subData;
  final String sub;
  final TextStyle style;

  SummaryCard({
    @required this.label,
    @required this.data,
    this.subData,
    this.sub = "",
    this.style = kLargeBoldTextStyle1x,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: kLabelTextStyle),
        Divider(thickness: 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(
              data,
              style: style,
            ),
            Text(
              "  $sub",
              style: kLabelTextStyle,
            ),
          ],
        ),
        subData != null
            ? Text(
                subData.toString(),
                style: kMediumLabelTextStyle,
              )
            : SizedBox(height: 0.0),
      ],
    );
  }
}
