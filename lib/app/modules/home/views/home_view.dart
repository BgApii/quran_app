import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/routes/app_pages.dart';
import 'package:quran/app/constant/color.dart';
import 'package:quran/app/data/models/meta.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.fetchAllSurah();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
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
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: appWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Loading...",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: appWhite,
                                        ),
                                      ),
                                      // SizedBox(height: 3),
                                      Text(
                                        "",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: appWhite,
                                        ),
                                      ),
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
                                  Get.defaultDialog(
                                    title: "Delete Last Read",
                                    middleText:
                                        "Are you sure to delete last read bookmark?",
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () => Get.back(),
                                        child: Text("CANCEL"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          controller.deleteBookmark(
                                            lastRead['id'],
                                          );
                                          Get.back();
                                        },
                                        child: Text("DELETE"),
                                      ),
                                    ],
                                  );
                                }
                              },
                              // Di dalam HomeView, pada bagian Last Read Container
                              onTap: () {
                                if (lastRead != null) {
                                  // Navigasi ke surah
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
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: appWhite,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),

                                        Text(
                                          lastRead == null
                                              ? "Tambahkan Last Read"
                                              : "${lastRead["surah"]}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: appWhite,
                                          ),
                                        ),
                                        // SizedBox(height: 3),
                                        Text(
                                          lastRead == null
                                              ? "Belum ada Last Read"
                                              : "Ayat ${lastRead["ayah"]} | Juz ${lastRead["juz"]}",
                                          style: TextStyle(
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Juz",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Bookmark",
                      style: TextStyle(
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
                    FutureBuilder<Surahs?>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData) {
                          return Center(child: Text("Tidak ada data!"));
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
                                  child: Center(child: Text("${surah.number}")),
                                ),
                                title: Text(
                                  "${surah.englishName}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  "${surah.numberOfAyahs} Ayat | ${surah.revelationType}",
                                  style: TextStyle(
                                    color:
                                        Get.isDarkMode ? appGreyLight : appGrey,
                                  ),
                                ),
                                trailing: Text(
                                  "${surah.name}",
                                  style: TextStyle(
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
                    FutureBuilder<Juzs?>(
                      future: controller.getAllJuz(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData ||
                            snapshot.data?.references == null) {
                          return Center(child: Text("Tidak ada data!"));
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
                                  child: Center(child: Text("${index + 1}")),
                                ),
                                title: Text(
                                  "Juz ${index + 1}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  "Start $surahName : ${juz.ayah}",
                                  style: TextStyle(
                                    color:
                                        Get.isDarkMode ? appGreyLight : appGrey,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
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
                              return Center(child: Text("Tidak ada Bookmark!"));
                            }

                            return ListView.builder(
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data![index];
                                return ListTile(
                                  // Di HomeView, pada bagian Bookmark tab
                                  onTap: () {
                                    controller.navigateToBookmark(data);
                                  },
                                  leading: Text("${index + 1}"),
                                  title: Text("surah : ${data["surah"]}"),
                                  subtitle: Text(
                                    "Ayat : ${data["ayah"]} | Juz : ${data["juz"]}",
                                    style: TextStyle(
                                      color:
                                          Get.isDarkMode
                                              ? appGreyLight
                                              : appGrey,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      controller.deleteBookmark(data['id']);
                                    },
                                    icon: Icon(Icons.delete),
                                    color:
                                        Get.isDarkMode ? appGreyLight : appGrey,
                                    tooltip: "Hapus Bookmark",
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
