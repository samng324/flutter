import 'package:ebapp/detailPage.dart';
import 'package:flutter/material.dart';
import 'package:ebapp/loginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => const MyHomePage(title: 'Ebay app'),
              settings: settings,
            );
          case '/detail':
            final args = settings.arguments;
            if (args is Photo) {
              return MaterialPageRoute(
                builder: (_) => ImageDetailPage(photo: args),
                settings: settings,
              );
            }
            return null;
          case '/Login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutPage());
          default:
            return null;
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Card showCard(BuildContext context, Photo p, Color c, String desc, String price) {
    return Card(
      elevation: 10,
      color: c,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/detail', arguments: p);
                },
                child: Image.network(
                  p.imagePath,
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 140,
                      height: 140,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox(
                      width: 140,
                      height: 140,
                      child: const Center(child: Icon(Icons.broken_image)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            // choose text color based on background luminance for readability
            Builder(builder: (context) {
              final textColor = c.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$$price',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.9)),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    ); //card()
  } //showCard()


  List<Color> c = [
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.yellow,
    Colors.green,
  ];

  // Replace with your actual network image URLs
  List<Map<String, dynamic>> p = [
    {
      "desc": "laptop",
      "price": "30,000",
      "Photo":
          "https://res-3.cloudinary.com/grover/image/upload/e_trim/c_limit,f_auto,fl_png8.lossy,h_1280,q_auto,w_1280/v1616063807/ayp85ximwummceejm6dn.png",
    },
    {
      "desc": "phone",
      "price": "30000",
      "Photo":
          "https://www.notebookcheck.net/fileadmin/_processed_/5/3/csm_asus_rog_phone_6_c538878ca1.png",
    },
    {
      "desc": "desktop",
      "price": "30000",
      "Photo":
          "https://i5.walmartimages.com/asr/d26e8151-6a5b-45c9-9823-30866b009c9d.3cf79fc4438e3ea1b11356806c28e646.png",
    },
    {
      "desc": "Ally",
      "price": "30000",
      "Photo":
          "https://dlcdnwebimgs.asus.com/files/media/74b143b1-767c-4513-a062-22dee4c08a3a/v1/images/large/1x/nr2501_hard_case_with_ally.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: p.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (BuildContext context, int index) {
            final item = p[index];
            final photo = Photo(item['Photo'] as String);
            final color = c[index % c.length];
            final desc = (item['desc'] ?? '') as String;
            final price = (item['price'] ?? '') as String;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: showCard(context, photo, color, desc, price)),
              ],
            );
          },
        ),
      ), //Container
    );
  }
}


class Photo {
  final String imagePath;

  Photo(this.imagePath);
}





class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About this app')),
    );
  }
}
