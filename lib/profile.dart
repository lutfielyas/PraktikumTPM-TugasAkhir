import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final double crossAxisSpacing = isMobile ? 10.0 : 20.0;
    final double childAspectRatio = isMobile ? 0.9 : 0.8;
    final double fontSize = isMobile ? 14.0 : 16.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: GridView.count(
            crossAxisCount: isMobile ? 1 : 2,
            padding: EdgeInsets.all(isMobile ? 10.0 : 20.0),
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
            children: <Widget>[
              _buildProfileItem(
                imageUrl:
                    'https://images.pexels.com/photos/15044905/pexels-photo-15044905/free-photo-of-half-body-photography.jpeg?auto=compress&cs=larges2xsrgb&w=1260&h=750&dpr=1',
                text: 'Lutfi Elyas ( 123200032 )',
                context: context,
                fontSize: fontSize,
              ),
              _buildProfileItem(
                imageUrl:
                    'https://media.licdn.com/dms/image/D5603AQFX68faHko5Gg/profile-displayphoto-shrink_800_800/0/1678825055639?e=2147483647&v=beta&t=cPUEuVmMn-BN4NGfgqzvANZaVRsgR6R0qNvne1T95EA',
                text: 'Farhan Harvito ( 123200029 )',
                context: context,
                fontSize: fontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required String imageUrl,
    required String text,
    required BuildContext context,
    required double fontSize,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final double borderRadius = isMobile ? 8.0 : 12.0;
    final double imageHeight = isMobile ? 180.0 : 220.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileDetailPage(
              imageUrl: imageUrl,
              text: text,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.blueGrey.shade900,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadius),
                ),
                child: Hero(
                  tag: imageUrl,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: imageHeight,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailPage extends StatelessWidget {
  final String imageUrl;
  final String text;

  const ProfileDetailPage(
      {super.key, required this.imageUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final double borderRadius = isMobile ? 8.0 : 12.0;
    final double imageHeight = isMobile ? 300.0 : 600.0;
    final double fontSize = isMobile ? 15 : 15;
    final double containerWidth = isMobile ? 300.0 : 600.0;
    final double containerPadding = isMobile ? 12.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(text),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 0, 0, 0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: containerPadding,
            vertical: containerPadding,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Hero(
                    tag: imageUrl,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: 1.0,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: imageHeight,
                        width: imageHeight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: containerWidth,
                  padding: EdgeInsets.all(containerPadding),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Text(
                    'Mahasiswa Informatika UPNVYK 2020',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
