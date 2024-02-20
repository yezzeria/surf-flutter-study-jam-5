import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meme_generator/screen/meme_generator_screen.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final List<String> _images = [
    'https://creng.ru/wp-content/uploads/2014/09/xxh.jpg',
    'https://i.pinimg.com/550x/9b/fd/10/9bfd1059af5d16041b921bb712740e99.jpg',
    'https://sun9-70.userapi.com/impg/cT2K3bZWVNbF2qLCdweyqkZeUwD82DINLJ3TbA/cQJVWZ7hD1Q.jpg?size=800x706&quality=96&sign=6fd0f39c574d7adf378913bbd61e445b&c_uniq_tag=9jJMQkpW_-V3tfSmapl4p2gBKsVr7lUvgxrzVsrZ7HM&type=album',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "mematic",
                style: GoogleFonts.gloriaHallelujah(
                  textStyle: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: double.infinity,
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder: (_, __, ___) => MemeGeneratorScreen(
                              index: index,
                              url: _images[index],
                            ),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween(
                                        begin: Offset(0.0, 1.0),
                                        end: Offset.zero)
                                    .animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 20 : 0, right: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _images[index],
                            width: 200,
                            height: 150,
                            fit: BoxFit.fitHeight,
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
      ),
    );
  }
}
