import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateko_purse_admin/models/invest/bonus.dart';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/url_api/url_api.dart';
import 'package:chateko_purse_admin/ui/utils/number_to_currency_format.dart';
import 'package:chateko_purse_admin/ui/views/widget/custom_dialog.dart';
import 'package:flutter/material.dart';

class ShowRequestDetails extends StatelessWidget {
  final Users user;
  final Bonus bonus;

  const ShowRequestDetails({
    Key key,
    this.user,
    this.bonus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Bonus Request',
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: CachedNetworkImageProvider(user.imageUrl),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _text('${user.fullName}', Icons.person),
                      _text('${user.email}', Icons.email,
                          size: 16, fontWeight: FontWeight.w400),
                      _text('${user.phone}', Icons.phone,
                          size: 16, fontWeight: FontWeight.w400),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              _text('${user.address == '' ? "No Address Found" : user.address}',
                  Icons.place,
                  size: 16, fontWeight: FontWeight.w400),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  shape: StadiumBorder(),
                  onPressed: () => UrlsApi.makePhoneCall('tel:${user.phone}'),
                  textColor: Colors.white,
                  color: Colors.pink,
                  child: Text('Call'),
                ),
              ),
              _textInLine('Request Amount',
                  'N${convertNumberToCurrency(bonus.amount)}'),
              _textInLine('Status', '${bonus.status}'),
              _textInLine('Date', '${convertTime(bonus.timeStamp)}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {
                      // model.updateStatus(
                      //     id: invest.id,
                      //     user: user,
                      //     status: 'active',
                      //     invest: invest);
                    },
                    textColor:
                        bonus.status == 'pending' ? Colors.white : Colors.black,
                    color:
                        bonus.status == 'pending' ? Colors.red : Colors.green,
                    child: Text('Pending'),
                  ),
                  SizedBox(width: 20),
                  FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {
                      // model.updateStatus(
                      //     id: invest.id,
                      //     user: user,
                      //     status: 'active',
                      //     invest: invest);
                    },
                    textColor:
                        bonus.status == 'paid' ? Colors.white : Colors.black,
                    color: bonus.status == 'paid' ? Colors.green : Colors.grey,
                    child: Text('Paid'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding _text(String text, icon, {double size, FontWeight fontWeight}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 16,
            ),
            SizedBox(width: 10),
            Text(
              '$text',
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: size ?? 24,
                color: Colors.grey[800],
                fontWeight: fontWeight ?? FontWeight.w500,
              ),
            ),
          ],
        ),
      );
  Padding _textInLine(String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$text1',
            style: TextStyle(
              color: Colors.purple[900],
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 5),
          Text(
            '$text2',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
