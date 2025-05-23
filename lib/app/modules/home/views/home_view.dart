import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran/app/modules/home/views/nav_bar.dart';
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
    final user = FirebaseAuth.instance.currentUser;
    controller.fetchAllSurah();
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Al-Quran App",
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? appGreenLight2 : appGreenDark,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Get.isDarkMode ? appGreenLight : appGreenDark,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: GoogleFonts.nunito(),
              ),
            );
          } else if (snapshot.hasData) {
            return DefaultTabController(
              length: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
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
                    SizedBox(height: 5),
                    Text(
                      "${user?.displayName}",
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? appGreenLight2 : appGreenDark,
                      ),
                    ),
                    SizedBox(height: 10),
                    GetBuilder<HomeController>(
                      builder:
                          (controller) => StreamBuilder<
                            QuerySnapshot<Map<String, dynamic>>
                          >(
                            stream: controller.getLastReadStream(),
                            builder: (
                              context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot,
                            ) {
                              // Handle loading state
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return _buildLastReadContainer(
                                  context,
                                  title: "Loading...",
                                  subtitle: "",
                                  isLoading: true,
                                );
                              }

                              // Handle error state
                              if (snapshot.hasError) {
                                return _buildLastReadContainer(
                                  context,
                                  title: "Error",
                                  subtitle: snapshot.error.toString(),
                                );
                              }

                              // Handle no data or empty docs
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return _buildLastReadContainer(
                                  context,
                                  title: "Add Last Read",
                                  subtitle: "No Last Read",
                                  onTap: () {
                                    // Optionally navigate to a screen to add a last read
                                    // Example: Get.toNamed(Routes.ADD_BOOKMARK);
                                  },
                                );
                              }

                              // Data exists, extract the first document
                              var lastRead = snapshot.data!.docs.first.data();
                              var docId =
                                  snapshot
                                      .data!
                                      .docs
                                      .first
                                      .id; // Get document ID for deletion

                              return _buildLastReadContainer(
                                context,
                                title: lastRead['surah'] ?? "Unknown Surah",
                                subtitle:
                                    "Verse ${lastRead['ayah'] ?? 'N/A'} | Juz ${lastRead['juz'] ?? 'N/A'}",
                                onTap: () {
                                  controller.navigateToBookmark(lastRead);
                                },
                                onLongPress: () {
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
                                            controller.deleteBookmark(docId);
                                            Get.back();
                                            Get.snackbar(
                                              "Success",
                                              "Last read has been deleted",
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
                                },
                              );
                            },
                          ),
                    ),
                    SizedBox(height: 20),
                    TabBar(
                      indicatorColor:
                          Get.isDarkMode ? appGreenLight2 : appGreenDark,
                      labelColor:
                          Get.isDarkMode ? appGreenLight2 : appGreenDark,
                      unselectedLabelColor:
                          Get.isDarkMode ? appGreyLight : appGrey,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                    ? appGreyLight.withOpacity(
                                                      0.1,
                                                    )
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
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data?.references == null) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                    ? appGreyLight.withOpacity(
                                                      0.1,
                                                    )
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
                              return StreamBuilder<QuerySnapshot<Object?>>(
                                stream: controller.getDataStream(),
                                builder: (context, snapshot) {
                                  var listAllBookmark = snapshot.data?.docs;
                                  bool hasBookmarks = false;
                                  if (listAllBookmark != null) {
                                    for (var doc in listAllBookmark) {
                                      Map<String, dynamic> data =
                                          doc.data() as Map<String, dynamic>;
                                      if (data['last_read'] == 0) {
                                        hasBookmarks = true;
                                        break;
                                      }
                                    }
                                  }
                                  if (listAllBookmark == null ||
                                      listAllBookmark.isEmpty ||
                                      !hasBookmarks) {
                                    return Center(
                                      child: Text(
                                        "Tidak ada Bookmark!",
                                        style: GoogleFonts.nunito(),
                                      ),
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    var listAllBookmark = snapshot.data?.docs;
                                    return ListView.builder(
                                      itemCount: listAllBookmark?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> data =
                                            listAllBookmark![index].data()
                                                as Map<String, dynamic>;
                                        // Map<String, dynamic> data =
                                        //     snapshot.data![index];
                                        if (data['last_read'] == 0) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color:
                                                      Get.isDarkMode
                                                          ? appGreyLight
                                                              .withOpacity(0.1)
                                                          : appGrey.withOpacity(
                                                            0.1,
                                                          ),
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            child: ListTile(
                                              onTap: () {
                                                controller.navigateToBookmark(
                                                  data,
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
                                                "${data['surah']}",
                                                style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Text(
                                                "Verse ${data['ayah']} | Juz ${data['juz']}",
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
                                                        style:
                                                            GoogleFonts.nunito(),
                                                      ),
                                                      content: Text(
                                                        "Are you sure you want to delete this bookmark?",
                                                        style:
                                                            GoogleFonts.nunito(),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed:
                                                              () => Get.back(),
                                                          child: Text(
                                                            "Cancel",
                                                            style: GoogleFonts.nunito(
                                                              color:
                                                                  appGreenLight2,
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            controller
                                                                .deleteBookmark(
                                                                  listAllBookmark[index]
                                                                      .id,
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
                                        }
                                        return SizedBox();
                                      },
                                    );
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
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
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Get.isDarkMode ? appGreenLight : appGreenDark,
              ),
            );
          }
        },
      ),
    );
  }
}

// Helper method to build the Last Read container
Widget _buildLastReadContainer(
  BuildContext context, {
  required String title,
  required String subtitle,
  bool isLoading = false,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
}) {
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
        onTap: onTap,
        onLongPress: onLongPress,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Prevent Column from expanding
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book, color: appWhite, size: 20),
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
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(fontSize: 12, color: appWhite),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
