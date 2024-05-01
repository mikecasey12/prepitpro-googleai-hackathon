import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/pages/auth/auth.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  static const routeName = "/onboarding";

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  List<Map<String, dynamic>> obs = [
    {
      "image": "assets/images/obs-1.png",
      "title": "Welcome to PrepIt Pro",
      "summary": "Let's make learning fun!",
      "color": 0x00C68DFF,
      "textColor": 0x00FFFFFF
    },
    {
      "image": "assets/images/obs-2.png",
      "title": "Your ultimate study tool",
      "summary":
          "Practice subjects with quizzes and track progress effortlessly. Master your learning, anytime, anywhere.",
      "color": 0x00FFE2A8,
      "textColor": 0x001E1E1E
    },
    {
      "image": "assets/images/obs-3.png",
      "title": "Ladder to success",
      "summary":
          "Mastering test questions is climbing the ladder to success in education.",
      "color": 0x00F0AF99,
      "textColor": 0x00FFFFFF
    },
    {
      "image": "assets/images/obs-4.png",
      "title": "Ladder to success",
      "summary":
          "Mastering test questions is climbing the ladder to success in education.",
      "color": 0x00A07AF7,
      "textColor": 0x00FFFFF
    },
  ];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final size = MediaQuery.of(context).size;
    final lastPage = currentIndex + 1 == obs.length;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(obs[currentIndex]["color"]).withOpacity(1),
        body: Column(
          children: [
            const Gap(),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!lastPage)
                    InkWell(
                        onTap: () {
                          setState(() {
                            currentIndex = obs.length - 1;
                            _pageController.jumpToPage(obs.length - 1);
                          });
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Color(obs[currentIndex]["textColor"])
                                  .withOpacity(1)),
                        ))
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                // physics: const NeverScrollableScrollPhysics(),

                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 40),
                      children: [
                        Image.asset(
                          obs[index]["image"],
                          fit: BoxFit.cover,
                          height: size.height * 0.4,
                        ),
                        const Gap(),
                        Text(
                          "${obs[index]["title"]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(obs[index]["textColor"])
                                  .withOpacity(1)),
                        ),
                        Text(
                          "${obs[index]["summary"]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(obs[index]["textColor"])
                                  .withOpacity(1)),
                        )
                      ],
                    ),
                  );
                },
                itemCount: obs.length,
                controller: _pageController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: PageViewDotIndicator(
                  currentItem: currentIndex,
                  borderRadius: BorderRadius.circular(999),
                  count: obs.length,
                  size: const Size(28, 4),
                  boxShape: BoxShape.rectangle,
                  unselectedColor: Colors.grey,
                  selectedColor: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
              child: PrimaryButton(
                text: lastPage ? "Sign in/Sign up" : "Next",
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                padding: 12,
                hideTrailingButton: lastPage,
                spacing: lastPage ? MainAxisAlignment.center : null,
                onTap: () {
                  if (!lastPage) {
                    _pageController.nextPage(
                        duration: Durations.short4, curve: Curves.easeIn);
                    return;
                  }
                  Navigator.pushNamed(context, AuthPage.routeName);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
