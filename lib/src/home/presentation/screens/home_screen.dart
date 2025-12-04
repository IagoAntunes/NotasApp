import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_images.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    super.key,
    required this.onTapLogout,
    required this.onTapDocumentation,
    required this.onTapNoteDetails,
    required this.onTapCreateNote,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Function() onTapLogout;
  final Function() onTapDocumentation;
  final Function(String, String, Color, int) onTapNoteDetails;
  final Function() onTapCreateNote;

  final List<String> myNotes = [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
    "Nota curta aqui.",
    "Esta é uma nota muito grande para testar o limite de linhas. Se este texto for muito longo, ele deve ser cortado no final para não quebrar o layout do card e manter a uniformidade visual que desejamos. Bla bla bla bla bla bla bla bla.",
    "Outro texto de exemplo para preencher o grid.",
    "Mais um teste de layout com texto variável.",
    "A ideia do Masonry é que cada card tenha a altura do seu conteúdo, mas com o maxLines nós colocamos um teto limite.",
  ];

  final List<Color> cardColors = [
    Color(0xFFE3F2FD),
    Color(0xFFFFEBEE),
    Color(0xFFE8F5E9),
    Color(0xFFFFF3E0),
    Color(0xFFF3E5F5),
    Color(0xFFFFFDE7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFFF5E6),
      floatingActionButton: FloatingActionButton(
        onPressed: onTapCreateNote,
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFFF5E6),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.black),
              title: Text('Documentação', style: TextStyle(color: Colors.black)),
              onTap: onTapDocumentation,
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('Sair', style: TextStyle(color: Colors.black)),
              onTap: onTapLogout,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF5E6),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.menu, color: Colors.black, size: 28),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      ),
                      SvgPicture.asset(
                        AppImages.logo,
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: MasonryGridView.count(
                padding: const EdgeInsets.all(8),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: myNotes.length,
                itemBuilder: (context, index) {
                  final noteColor = cardColors[index % cardColors.length];
                  final noteTitle = "Nota ${index + 1}";

                  return GestureDetector(
                    onTap: () => onTapNoteDetails(
                      noteTitle,
                      myNotes[index],
                      noteColor,
                      index,
                    ),
                    child: Hero(
                      tag: 'note_$index',
                      child: Card(
                        color: noteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                noteTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                myNotes[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
