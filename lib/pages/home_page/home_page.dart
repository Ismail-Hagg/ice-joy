import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icejoy/controllers/home_controller.dart';
import 'package:icejoy/utils/constants.dart';
import 'package:icejoy/widgets/custom_text.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var lst = [
              'thing',
              'other thing',
              'thing',
              'other thing',
              'thing',
              'other thing',
              'thing',
              'other thing'
            ];
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (width * 0.7) - 14,
                        child: CustomText(
                          text:
                              '${'hello'.tr} ${controller.userModel.userName}',
                          size: 24,
                          flow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: (width * 0.3) - 14,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Stack(children: [
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                splashRadius: 15,
                                icon: const Icon(Icons.notifications),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  height: width * 0.03,
                                  width: width * 0.03,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                ),
                              )
                            ]),
                            const Icon(
                              Icons.attach_money,
                              size: 20,
                            ),
                            CustomText(
                              text: controller.userModel.points.toString(),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: width,
                  height: width * 0.15,
                  child: Row(
                    children: [
                      Container(
                        color: Colors.red,
                        width: width * 0.85,
                        height: width * 0.1,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: lst.length,
                          itemBuilder: (context, index) {
                            return GetBuilder<HomeController>(
                              init: Get.find<HomeController>(),
                              builder: (build) => Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomText(text: lst[index]),
                                  ),
                                  Container(
                                    color: Colors.red,
                                    width: 20,
                                    height: 10,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        // color: Colors.yellow,
                        width: width * 0.15,
                        height: width * 0.1,
                        child: Center(
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: const Icon(Icons.filter_alt_outlined),
                            splashRadius: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.greenAccent,
                  ),
                )
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SalomonBottomBar(
          backgroundColor: greyAccent,
          onTap: (page) {
            print(page);
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('home'),
              unselectedColor: purpleColor,
              selectedColor: purpleAccent,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('bookings'),
              unselectedColor: whiteColor,
              selectedColor: orangeColor,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('market'),
              unselectedColor: whiteColor,
              selectedColor: orangeColor,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('profile'),
              unselectedColor: purpleColor,
              selectedColor: purpleAccent,
            )
          ],
        ),
      ),
    );
  }
}
