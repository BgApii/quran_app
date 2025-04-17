import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/routes/app_pages.dart';
import 'package:quran/app/constant/color.dart';
import 'package:quran/app/data/models/meta.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.fetchAllSurah();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.SETTINGS);
            },
            icon: Icon(Icons.settings),
          ),
        ],
        title: Text(
          "Al-Quran App",
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? appGreenLight2 : appGreenDark,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assalamu'alaikum,",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? appGreyLight : appGrey,
                ),
              ),
              SizedBox(height: 10),
              GetBuilder<HomeController>(
                builder:
                    (controller) => FutureBuilder<Map<String, dynamic>?>(
                      future: controller.getLastRead(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [appGreenLight, appGreen],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  right: 10,
                                  child: Opacity(
                                    opacity: 0.3,
                                    child: Image.asset(
                                      "assets/images/quran.png",
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.menu_book,
                                            color: appWhite,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Last Read",
                                            style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              color: appWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Loading...",
                                        style: GoogleFonts.nunito(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: appWhite,
                                        ),
                                      ),
                                      // SizedBox(height: 3),
                                      Text(""),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        Map<String, dynamic>? lastRead = snapshot.data;

                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [appGreenLight, appGreen],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onLongPress: () {
                                if (lastRead != null) {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text(
                                        "Delete Last Read",
                                        style: GoogleFonts.nunito(),
                                      ),
                                      content: Text(
                                        "Are you sure you want to delete this last read?",
                                        style: GoogleFonts.nunito(),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: Text(
                                            "Cancel",
                                            style: GoogleFonts.nunito(
                                              color: appGreenLight2,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller.deleteBookmark(
                                              lastRead['id'],
                                            );
                                            Get.back();
                                            Get.snackbar(
                                              "Success",
                                              "Last read have been deleted",
                                            );
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              onTap: () {
                                if (lastRead != null) {
                                  controller.navigateToBookmark(lastRead);
                                }
                              },
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    right: 10,
                                    child: Opacity(
                                      opacity: 0.3,
                                      child: Image.asset(
                                        "assets/images/quran.png",
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.menu_book,
                                              color: appWhite,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Last Read",
                                              style: GoogleFonts.nunito(
                                                fontSize: 12,
                                                color: appWhite,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),

                                        Text(
                                          lastRead == null
                                              ? "Add Last Read"
                                              : "${lastRead["surah"]}",
                                          style: GoogleFonts.nunito(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: appWhite,
                                          ),
                                        ),
                                        // SizedBox(height: 3),
                                        Text(
                                          lastRead == null
                                              ? "No Last Read"
                                              : "Verse ${lastRead["ayah"]} | Juz ${lastRead["juz"]}",
                                          style: GoogleFonts.nunito(
                                            fontSize: 12,
                                            color: appWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              ),
              SizedBox(height: 20),
              TabBar(
                indicatorColor: Get.isDarkMode ? appGreenLight2 : appGreenDark,
                labelColor: Get.isDarkMode ? appGreenLight2 : appGreenDark,
                unselectedLabelColor: Get.isDarkMode ? appGreyLight : appGrey,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    child: Text(
                      "Surah",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Juz",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Bookmark",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    KeepAliveWrapper(
                      child: FutureBuilder<Surahs?>(
                        future: controller.getAllSurah(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color:
                                    Get.isDarkMode
                                        ? appGreenLight
                                        : appGreenDark,
                              ),
                            );
                          }
                          if (!snapshot.hasData) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Tidak ada data!",
                                    style: GoogleFonts.nunito(),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.offAllNamed(Routes.HOME);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Get.isDarkMode
                                              ? appGreenLight
                                              : appGreenDark,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Refresh",
                                      style: GoogleFonts.nunito(
                                        color: appWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.references!.length,
                            itemBuilder: (context, index) {
                              References surah =
                                  snapshot.data!.references![index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          Get.isDarkMode
                                              ? appGreyLight.withOpacity(0.1)
                                              : appGrey.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.DETAIL_SURAH,
                                      arguments: surah,
                                    );
                                  },
                                  leading: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          Get.isDarkMode
                                              ? "assets/images/list_dark.png"
                                              : "assets/images/list_light.png",
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${surah.number}",
                                        style: GoogleFonts.nunito(),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    "${surah.englishName}",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${surah.numberOfAyahs} Verse | ${surah.revelationType}",
                                    style: GoogleFonts.nunito(
                                      color:
                                          Get.isDarkMode
                                              ? appGreyLight
                                              : appGrey,
                                    ),
                                  ),
                                  trailing: Text(
                                    "${surah.name}",
                                    style: GoogleFonts.scheherazadeNew(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    KeepAliveWrapper(
                      child: FutureBuilder<Juzs?>(
                        future: controller.getAllJuz(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData ||
                              snapshot.data?.references == null) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Tidak ada data!",
                                    style: GoogleFonts.nunito(),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.offAllNamed(Routes.HOME);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Get.isDarkMode
                                              ? appGreenLight
                                              : appGreenDark,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Refresh",
                                      style: GoogleFonts.nunito(
                                        color: appWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.references!.length,
                            itemBuilder: (context, index) {
                              juzReferences juz =
                                  snapshot.data!.references![index];
                              String surahName = controller.getSurahName(
                                juz.surah ?? 0,
                              );
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          Get.isDarkMode
                                              ? appGreyLight.withOpacity(0.1)
                                              : appGrey.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.DETAIL_JUZ,
                                      arguments: index,
                                    );
                                  },
                                  leading: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          Get.isDarkMode
                                              ? "assets/images/list_dark.png"
                                              : "assets/images/list_light.png",
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${index + 1}",
                                        style: GoogleFonts.nunito(),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    "Juz ${index + 1}",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Start $surahName : ${juz.ayah}",
                                    style: GoogleFonts.nunito(
                                      color:
                                          Get.isDarkMode
                                              ? appGreyLight
                                              : appGrey,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    GetBuilder<HomeController>(
                      builder: (c) {
                        return FutureBuilder(
                          future: controller.getBookmark(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.data?.isEmpty ?? true) {
                              return Center(
                                child: Text(
                                  "Tidak ada Bookmark!",
                                  style: GoogleFonts.nunito(),
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data![index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            Get.isDarkMode
                                                ? appGreyLight.withOpacity(0.1)
                                                : appGrey.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      controller.navigateToBookmark(data);
                                    },
                                    leading: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            Get.isDarkMode
                                                ? "assets/images/list_dark.png"
                                                : "assets/images/list_light.png",
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${index + 1}",
                                          style: GoogleFonts.nunito(),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      "${data["surah"]}",
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Verse ${data["ayah"]} | Juz ${data["juz"]}",
                                      style: GoogleFonts.nunito(
                                        color:
                                            Get.isDarkMode
                                                ? appGreyLight
                                                : appGrey,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Get.dialog(
                                          AlertDialog(
                                            title: Text(
                                              "Delete Bookmark",
                                              style: GoogleFonts.nunito(),
                                            ),
                                            content: Text(
                                              "Are you sure you want to delete this bookmark?",
                                              style: GoogleFonts.nunito(),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: Text(
                                                  "Cancel",
                                                  style: GoogleFonts.nunito(
                                                    color: appGreenLight2,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  controller.deleteBookmark(
                                                    data['id'],
                                                  );
                                                  Get.back();
                                                  Get.snackbar(
                                                    "Success",
                                                    "Bookmark have been deleted",
                                                  );
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                      color:
                                          Get.isDarkMode
                                              ? appGreyLight
                                              : appGrey,
                                      tooltip: "delete Bookmark",
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
