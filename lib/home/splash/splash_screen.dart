import 'package:flutter/material.dart';
import 'package:myapp/home/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController(); // Tambahkan controller
  List<Map<String, String>> splashData = [
    {
      "text": "",
      "image": ""
    },
    {
      "text": "",
      "image": ""
    },
    {
      "text": "",
      "image": ""
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: _pageController, // Tambahkan controller
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"],
                    text: splashData[index]['text'],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 5),
                            height: 6,
                            width: currentPage == index ? 20 : 6,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? Color.fromARGB(255, 67, 142, 255)
                                  : const Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (currentPage != splashData.length - 1) // Tombol Skip hanya tampil di slide pertama dan kedua
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              // Lompat ke slide terakhir
                              _pageController.animateToPage(
                                splashData.length - 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      const Spacer(flex: 3),
                      if (currentPage == splashData.length - 1) // Tombol "Next" hanya pada slide terakhir
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  Colors.lightBlueAccent,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(60, 40),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                            child: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashContent extends StatefulWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        // const Text(
        //   "My Solonet",
        //   style: TextStyle(
        //     fontSize: 32,
        //     color: Colors.lightBlue,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // Text(
        //   widget.text!,
        //   textAlign: TextAlign.center,
        // ),
        const Spacer(flex: 2),
        Image.asset(
          'assets/images/solonet.png', // Ganti dengan path gambar Anda
          height: 200,
          width: 235,
        ),
        const Spacer(),
      ],
    );
  }
}
