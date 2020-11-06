import 'package:bed_admin/provider/send_req/shippings_req.dart';
import 'package:bed_admin/ui/page/widget/custom_dialog.dart';
import 'package:bed_admin/view_models/theme_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:paginate_firestore/widgets/bottom_loader.dart';
import 'package:paginate_firestore/widgets/empty_separator.dart';
import 'package:provider/provider.dart';

class ManageShippingPage extends StatefulWidget {
  @override
  _ManageShippingPageState createState() => _ManageShippingPageState();
}

class _ManageShippingPageState extends State<ManageShippingPage> {
  bool searchIconEnabled = false;

  String recievedStatus = 'Recieved';
  String processingStatus = 'Processing';
  String onTheWayStatus = 'On The Way';
  String deliveredStatus = 'Delivered';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeGetData();
  }

  initializeGetData() async {
    await Future.delayed(Duration(seconds: 3));
    await Provider.of<ShippinReqs>(context, listen: false)
        .getAllShippingsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: searchIconEnabled
            ? Consumer<ShippinReqs>(builder: (context, shippingReq, child) {
                return Container(
                  height: 40,
                  child: TextFormField(
                      controller: shippingReq.searchController,
                      style: TextStyle(fontSize: 18),
                      onFieldSubmitted: shippingReq.handleSearch,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Search Shippings here',
                        fillColor: Colors.white,
                        suffixIcon: InkWell(
                            onTap: () => shippingReq.handleSearch(
                                shippingReq.searchController.text),
                            child: Icon(Icons.search)),
                      )),
                );
              })
            : Text('Manage Shippings'),
        centerTitle: true,
        actions: [
          InkWell(
              onTap: () {
                setState(() {
                  searchIconEnabled = !searchIconEnabled;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(searchIconEnabled ? Icons.close : Icons.search),
              )),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Consumer<ShippinReqs>(builder: (context, shippingReq, ch) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 3));
              await Provider.of<ShippinReqs>(context, listen: false)
                  .getAllShippingsFromFirestore();
            },
            child: StreamBuilder<QuerySnapshot>(
                stream: shippingReq.resultFromUserColloection,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshot.data.documents;
                  // if (data.isEmpty || data == null) {
                  //   return Center(child: Text('No Ship Order Found!'));
                  // }

                  return searchIconEnabled
                      ? _buildSearchView(data, context, shippingReq)
                      : PaginateFirestore(
                          query: Firestore.instance
                              .collection('shipments')
                              .orderBy('orderID'),
                          itemsPerPage: 10,
                          separator: Divider(),
                          initialLoader:  Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          bottomLoader: Container(
                              child: Center(
                            child: Column(
                              children: [
                                CupertinoActivityIndicator(),
                                Text('Getting more data!')
                              ],
                            ),
                          )),
                          itemBuilderType: PaginateBuilderType.listView,
                          itemBuilder: (i, context, snapshot) {
                            final shippingID = data[i]['orderID'];
                            final senderName = data[i]['senderName'];
                            final senderNo = data[i]['senderNo'];
                            final timeOrdered = data[i]['orderTime'];
                            final pickUpAddress = data[i]['pickUpAddress'];
                            final deliveryItem = data[i]['deliveryShippings'];
                            final totalQty = data[i]['totalQty'];
                            final totalAmount = data[i]['totalAmount'];
                            final status = data[i]['status'];

                            return ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SelectableText(
                                      '$shippingID',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Chip(
                                      label: status.isEmpty
                                          ? Text('New+',
                                              style: TextStyle(
                                                  color: Colors.white))
                                          : Text(status.toString()),
                                      backgroundColor: status.isEmpty
                                          ? Colors.red
                                          : (status.contains('Delivered')
                                              ? Colors.green[200]
                                              : Colors.blue[200]),
                                    )
                                  ],
                                ),
                                subtitle: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('$senderName \n$senderNo'),
                                    Text(DateTime.parse(
                                            timeOrdered.toDate().toString())
                                        .toString()
                                        .substring(0, 19)),
                                  ],
                                ),
                                // trailing: Icon(Icons.arrow_forward, size: 14),
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (ctx) => CustomDialog(
                                            title: Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                color: black,
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      Text('$shippingID',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ],
                                                  ),
                                                )),
                                            children: [
                                              titleWIthTrailingText(
                                                  leadingText: 'Shipping ID',
                                                  trailingText: '$shippingID'),
                                              SizedBox(height: 5),
                                              titleWIthTrailingText(
                                                  leadingText: 'sender No',
                                                  trailingText: '$senderNo'),
                                              SizedBox(height: 5),
                                              titleWIthTrailingText(
                                                  leadingText: 'sender Name:',
                                                  trailingText: '$senderName'),
                                              SizedBox(height: 5),
                                              titleWIthTrailingText(
                                                  leadingText:
                                                      'pick-Up-Address:',
                                                  trailingText:
                                                      "$pickUpAddress"),
                                              SizedBox(height: 5),
                                              titleWIthTrailingText(
                                                  leadingText: 'Order Time:',
                                                  trailingText: DateTime.parse(
                                                          timeOrdered
                                                              .toDate()
                                                              .toString())
                                                      .toString()
                                                      .substring(0, 19)),
                                              SizedBox(height: 5),
                                              Column(
                                                children: List.generate(
                                                    deliveryItem.length,
                                                    (index) => ListTile(
                                                          title: Text(data[i][
                                                                  'deliveryShippings']
                                                              [index]['title']),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                  height: 5),
                                                              deliveryItem[index]
                                                                          [
                                                                          'weight'] ==
                                                                      null
                                                                  ? Container()
                                                                  : Text(
                                                                      "Weight: ${deliveryItem[index]['weight']}"),
                                                              deliveryItem[index]
                                                                          [
                                                                          'quantity'] ==
                                                                      null
                                                                  ? Container()
                                                                  : Text(
                                                                      "Quantity: ${deliveryItem[index]['quantity']}"),
                                                              deliveryItem[index]
                                                                          [
                                                                          'price'] ==
                                                                      null
                                                                  ? Container()
                                                                  : Text(
                                                                      "Price: ₦${deliveryItem[index]['price']}"),
                                                              SizedBox(
                                                                  height: 5),
                                                              deliveryItem[index]
                                                                          [
                                                                          'recieversName'] ==
                                                                      null
                                                                  ? Container()
                                                                  : Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "Reciever's Name: ${deliveryItem[index]['recieversName']}"),
                                                                        Text(
                                                                            "Receiver's Phone: ${deliveryItem[index]['receiverPhone']}"),
                                                                        Text(
                                                                            "Drop-Off Address: ${deliveryItem[index]['recieversName']}"),
                                                                        Text(
                                                                            "Location Check: ${deliveryItem[index]['locationCheck']}"),
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        )),
                                              ),
                                              titleWIthTrailingText(
                                                  leadingText: 'TotalQty:',
                                                  trailingText: '$totalQty'),
                                              SizedBox(height: 5),
                                              titleWIthTrailingText(
                                                  leadingText: 'Total Amount:',
                                                  trailingText: '$totalAmount'),
                                              SizedBox(height: 5),
                                              titleWIthTrailingText(
                                                  leadingText: 'Status',
                                                  trailingText: '$status'),
                                              SizedBox(height: 10),
                                              Divider(),
                                              // Text('Update Shipping Status'),
                                              _statusButtons(
                                                  shippingReq, shippingID),
                                            ])));
                          },
                          // orderBy is compulsary to enable pagination
                        );
                  // return ListView.separated(
                  //     separatorBuilder: (ctx, i) => Divider(),
                  //     itemCount: data.length,
                  //     itemBuilder: (ctx, i) {

                  //     });
                }),
          );
        }),
      ),
    );
  }

  ListView _buildSearchView(List<DocumentSnapshot> data, BuildContext context, ShippinReqs shippingReq) {
    return ListView.separated(
                        separatorBuilder: (ctx, i) => Divider(),
                        itemCount: data.length,
                        itemBuilder: (ctx, i) {
                          final shippingID = data[i]['orderID'];
                          final senderName = data[i]['senderName'];
                          final senderNo = data[i]['senderNo'];
                          final timeOrdered = data[i]['orderTime'];
                          final pickUpAddress = data[i]['pickUpAddress'];
                          final deliveryItem = data[i]['deliveryShippings'];
                          final totalQty = data[i]['totalQty'];
                          final totalAmount = data[i]['totalAmount'];
                          final status = data[i]['status'];

                          return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SelectableText(
                                    '$shippingID',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Chip(
                                    label: status.isEmpty
                                        ? Text('New+',
                                            style: TextStyle(
                                                color: Colors.white))
                                        : Text(status.toString()),
                                    backgroundColor: status.isEmpty
                                        ? Colors.red
                                        : (status.contains('Delivered')
                                            ? Colors.green[200]
                                            : Colors.blue[200]),
                                  )
                                ],
                              ),
                              subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('$senderName \n$senderNo'),
                                  Text(DateTime.parse(
                                          timeOrdered.toDate().toString())
                                      .toString()
                                      .substring(0, 19)),
                                ],
                              ),
                              // trailing: Icon(Icons.arrow_forward, size: 14),
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (ctx) => CustomDialog(
                                          title: Container(
                                              padding:
                                                  const EdgeInsets.all(16),
                                              color: black,
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Text('$shippingID',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)),
                                                  ],
                                                ),
                                              )),
                                          children: [
                                            titleWIthTrailingText(
                                                leadingText: 'Shipping ID',
                                                trailingText: '$shippingID'),
                                            SizedBox(height: 5),
                                            titleWIthTrailingText(
                                                leadingText: 'sender No',
                                                trailingText: '$senderNo'),
                                            SizedBox(height: 5),
                                            titleWIthTrailingText(
                                                leadingText: 'sender Name:',
                                                trailingText: '$senderName'),
                                            SizedBox(height: 5),
                                            titleWIthTrailingText(
                                                leadingText:
                                                    'pick-Up-Address:',
                                                trailingText:
                                                    "$pickUpAddress"),
                                            SizedBox(height: 5),
                                            titleWIthTrailingText(
                                                leadingText: 'Order Time:',
                                                trailingText: DateTime.parse(
                                                        timeOrdered
                                                            .toDate()
                                                            .toString())
                                                    .toString()
                                                    .substring(0, 19)),
                                            SizedBox(height: 5),
                                            Column(
                                              children: List.generate(
                                                  deliveryItem.length,
                                                  (index) => ListTile(
                                                        title: Text(data[i][
                                                                'deliveryShippings']
                                                            [index]['title']),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                height: 5),
                                                            deliveryItem[index]
                                                                        [
                                                                        'weight'] ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    "Weight: ${deliveryItem[index]['weight']}"),
                                                            deliveryItem[index]
                                                                        [
                                                                        'quantity'] ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    "Quantity: ${deliveryItem[index]['quantity']}"),
                                                            deliveryItem[index]
                                                                        [
                                                                        'price'] ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    "Price: ₦${deliveryItem[index]['price']}"),
                                                            SizedBox(
                                                                height: 5),
                                                            deliveryItem[index]
                                                                        [
                                                                        'recieversName'] ==
                                                                    null
                                                                ? Container()
                                                                : Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "Reciever's Name: ${deliveryItem[index]['recieversName']}"),
                                                                      Text(
                                                                          "Receiver's Phone: ${deliveryItem[index]['receiverPhone']}"),
                                                                      Text(
                                                                          "Drop-Off Address: ${deliveryItem[index]['recieversName']}"),
                                                                      Text(
                                                                          "Location Check: ${deliveryItem[index]['locationCheck']}"),
                                                                    ],
                                                                  ),
                                                          ],
                                                        ),
                                                      )),
                                            ),
                                            titleWIthTrailingText(
                                                leadingText: 'TotalQty:',
                                                trailingText: '$totalQty'),
                                            SizedBox(height: 5),
                                            titleWIthTrailingText(
                                                leadingText: 'Total Amount:',
                                                trailingText: '$totalAmount'),
                                            SizedBox(height: 5),
                                            titleWIthTrailingText(
                                                leadingText: 'Status',
                                                trailingText: '$status'),
                                            SizedBox(height: 10),
                                            Divider(),
                                            // Text('Update Shipping Status'),
                                            _statusButtons(
                                                shippingReq, shippingID),
                                          ])));

                        });
  }

  Wrap _statusButtons(ShippinReqs shippingReq, shippingID) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        FlatButton(
            color: Colors.blue[200],
            onPressed: () => showDialog(
                context: context,
                builder: (ctx) => _customAlertDialog(
                      status: recievedStatus,
                      onPressed: () async {
                        setState(() => isLoading = true);

                        await shippingReq.updateShippingStatus(
                          shippingID: shippingID,
                          updateStatus: recievedStatus,
                        );
                        setState(() => isLoading = false);

                        Navigator.pop(context);
                      },
                    )),
            child: Text('Received')),
        SizedBox(width: 5),
        FlatButton(
            color: Colors.red[200],
            onPressed: () => showDialog(
                context: context,
                builder: (ctx) => _customAlertDialog(
                      status: processingStatus,
                      onPressed: () async {
                        setState(() => isLoading = true);

                        await shippingReq.updateShippingStatus(
                          shippingID: shippingID,
                          updateStatus: processingStatus,
                        );
                        setState(() => isLoading = false);

                        Navigator.pop(context);
                      },
                    )),
            child: Text('Processing')),
        SizedBox(width: 5),
        FlatButton(
            color: Colors.yellow[200],
            onPressed: () => showDialog(
                context: context,
                builder: (ctx) => _customAlertDialog(
                      status: onTheWayStatus,
                      onPressed: () async {
                        setState(() => isLoading = true);

                        await shippingReq.updateShippingStatus(
                          shippingID: shippingID,
                          updateStatus: onTheWayStatus,
                        );
                        setState(() => isLoading = false);

                        Navigator.pop(context);
                      },
                    )),
            child: Text('On The Way')),
        SizedBox(width: 5),
        FlatButton(
            color: Colors.green[400],
            onPressed: () => showDialog(
                context: context,
                builder: (ctx) => _customAlertDialog(
                      status: deliveredStatus,
                      onPressed: () async {
                        setState(() => isLoading = true);

                        await shippingReq.updateShippingStatus(
                          shippingID: shippingID,
                          updateStatus: deliveredStatus,
                        );
                        setState(() => isLoading = false);

                        Navigator.pop(context);
                      },
                    )),
            child: Text('Delivered')),
      ],
    );
  }

  RichText titleWIthTrailingText({String leadingText, String trailingText}) =>
      RichText(
        text: TextSpan(children: [
          TextSpan(
              text: '$leadingText:   '.toUpperCase(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          TextSpan(
              text: trailingText,
              style: TextStyle(color: Colors.blue, fontSize: 12)),
        ]),
      );

  _customAlertDialog({Function onPressed, String status}) => AlertDialog(
        title: Text(
          'Confirm Status Update',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
            'Are you sure you want to mark this status as [ ${status.toUpperCase()} ]?'),
        buttonPadding: const EdgeInsets.all(0),
        actions: [
          FlatButton(
              onPressed: onPressed,
              child: isLoading
                  ? Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator()))
                  : Text(
                      'Yes',
                      style: TextStyle(color: Colors.red),
                    )),
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'))
        ],
      );
}
