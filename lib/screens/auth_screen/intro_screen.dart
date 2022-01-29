import 'package:flutter/material.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/auth_screen/login_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_tracker_client/style/theme.dart' as style;

class IntroPage extends StatefulWidget {
  final UserRepository userRepository;

  const IntroPage({Key? key, required this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IntroPageState(userRepository);
}

class _IntroPageState extends State<IntroPage> {
  final UserRepository userRepository;
  _IntroPageState(this.userRepository);
  bool clicked = false;

  void afterIntroCompleted() {
    setState(() {
      clicked = true;
    });
  }

  final List<PageViewModel> pages = [
    PageViewModel(
        titleWidget: Container(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              const Text(
                'Fuel tracker',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 3,
                width: 100,
                decoration: BoxDecoration(
                    color: style.Colors.mainColor,
                    borderRadius: BorderRadius.circular(10)),
              )
            ],
          ),
        ),
        body: "fuel log, mileage and costs tracker.",
        // image: Center(child: SvgPicture.asset("assets/icons/fuel-15.svg")),
        decoration: const PageDecoration(
            pageColor: Colors.white,
            bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 16),
            descriptionPadding: EdgeInsets.only(left: 20, right: 20),
            imagePadding: EdgeInsets.all(20))),
  ];

  @override
  Widget build(BuildContext context) {
    return clicked
        ? LoginScreen(userRepository: userRepository)
        : IntroductionScreen(
            pages: pages,
            onDone: () {
              afterIntroCompleted();
            },
            onSkip: () {
              afterIntroCompleted();
            },
            showSkipButton: true,
            skip: const Text('Skip',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
            next: const Icon(Icons.navigate_next),
            done: const Text("DONE",
                style: TextStyle(fontWeight: FontWeight.w600)),
            dotsDecorator: DotsDecorator(
                size: const Size.square(7.0),
                activeSize: const Size(20.0, 5.0),
                activeColor: style.Colors.mainColor,
                color: Colors.black12,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0))),
          );
  }
}
