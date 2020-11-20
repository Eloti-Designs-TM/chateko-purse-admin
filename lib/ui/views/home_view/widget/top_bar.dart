import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/ui/views/start_view/auth_page/signup_login_views.dart';
import 'package:chateko_purse_admin/ui/views/widget/alert_dialog.dart';
import 'package:chateko_purse_admin/ui/views/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

enum PageEnum {
  Share,
  About,
  Policy,
  Bank,
  Logout,
}

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    Key key,
    @required this.authApi,
    @required this.user,
  }) : super(key: key);

  final AuthApi authApi;
  final Users user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: InkWell(
            onTap: () {
              // if (authApi.currentFirebase == null) {
              //   Navigator.of(context).pushReplacement(MaterialPageRoute(
              //       fullscreenDialog: true, builder: (_) => SignUpLogin()));
              // } else {
              //   // Navigator.of(context).push(MaterialPageRoute(
              //   //     builder: (_) => DetailView(
              //   //         title: 'Profile', state: DetailState.Profile)));
              // }
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: user.imageUrl == null
                      ? null
                      : NetworkImage(user.imageUrl),
                  backgroundColor: Colors.grey[100],
                  child: user.imageUrl == null
                      ? Icon(Icons.person, color: Colors.pink[700], size: 20)
                      : null,
                ),
              ],
            ),
          ),
        ),
        _childPopup(context),
      ],
    );
  }

  _onSelect(PageEnum value, context) {
    switch (value) {
      case PageEnum.About:
        showDialog(
            context: context,
            builder: (_) =>
                CustomDialog(title: 'About App', children: [Text(aboutApp)]));
        break;
      case PageEnum.Policy:
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true, builder: (_) => Policy()));
        break;
      case PageEnum.Share:
        Share.share(
            """"Hi there, I get 10% cash, of my savings every month, on Chateko Purse. 
Click this link to get your 10% monthly.\nhttps://play.google.com/store/apps/details?id=com.elotidesigns.chateko_purse""",
            subject: 'Chateko-Purse');
        break;
      case PageEnum.Bank:
        // showSuccessBankDetail(context);
        break;
      case PageEnum.Logout:
        showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                title: 'Log-out?',
                content: 'Are you sure you want to log-out?',
                onTapYes: () => authApi.signOut(context)));
        break;

      default:
        break;
    }
  }

  Widget _childPopup(context) => PopupMenuButton<PageEnum>(
        onSelected: (v) {
          _onSelect(v, context);
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: PageEnum.About,
            child: PopUpButton(title: 'About', icon: Icons.info_outline),
          ),
          PopupMenuItem(
            value: PageEnum.Share,
            child: PopUpButton(title: 'Share', icon: Icons.share),
          ),
          PopupMenuItem(
            value: PageEnum.Policy,
            child: PopUpButton(title: 'Privacy Policy', icon: Icons.security),
          ),
          authApi.currentFirebase == null
              ? null
              : PopupMenuItem(
                  value: PageEnum.Logout,
                  child: PopUpButton(title: 'Log-out', icon: Icons.exit_to_app),
                )
        ],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.more_vert, color: Colors.white),
        ),
      );
}

class PopUpButton extends StatelessWidget {
  const PopUpButton({
    Key key,
    this.title,
    this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(width: 10),
        Text(
          title.toString(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

class TopWriteUp extends StatelessWidget {
  const TopWriteUp({
    Key key,
    @required this.authApi,
    @required this.user,
  }) : super(key: key);

  final AuthApi authApi;
  final Users user;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
          text: 'Admin\n',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[200]),
        ),
        TextSpan(
          text: '${user.fullName}',
          style: TextStyle(fontSize: 14, color: Colors.grey[200]),
        ),
      ]),
    );
  }
}

String aboutApp =
    """Donec rutrum congue leo eget malesuada. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. Proin eget tortor risus. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. Cras ultricies ligula sed magna dictum porta. Nulla quis lorem ut libero malesuada feugiat.

Nulla porttitor accumsan tincidunt. Donec rutrum congue leo eget malesuada. Sed porttitor lectus nibh. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. Sed porttitor lectus nibh. Donec sollicitudin molestie malesuada.

Praesent sapien massa, convallis a pellentesque nec, egestas non nisi. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Quisque velit nisi, pretium ut lacinia in, elementum id enim. Curabitur aliquet quam id dui posuere blandit. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem.

Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula. Pellentesque in ipsum id orci porta dapibus. Quisque velit nisi, pretium ut lacinia in, elementum id enim. Vivamus suscipit tortor eget felis porttitor volutpat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula. Vivamus suscipit tortor eget felis porttitor volutpat.

Pellentesque in ipsum id orci porta dapibus. Praesent sapien massa, convallis a pellentesque nec, egestas non nisi. Sed porttitor lectus nibh. Quisque velit nisi, pretium ut lacinia in, elementum id enim. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula. Vivamus suscipit tortor eget felis porttitor volutpat.""";

class Policy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Policy')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(aboutApp),
        ),
      ),
    );
  }
}
