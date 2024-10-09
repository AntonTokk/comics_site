import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Комиксы',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Комиксы'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Comic> comics = [
    Comic(
      title: 'Spider-Man: Blue',
      author: 'Jeph Loeb',
      price: 14.99,
      imageUrl: 'https://i.pinimg.com/736x/1d/a4/3d/1da43d8742b591be0dd6557410e701b7.jpg',
      category: 'Spider-Man',
      description: 'Это трогательная история о Питере Паркере и Гвен Стейси.',
      quantity: 5,
      isFavorite: false,
    ),
    Comic(
      title: 'Spider-Man: Kraven\'s Last Hunt',
      author: 'J.M. DeMatteis',
      price: 17.99,
      imageUrl: 'https://cdn1.ozone.ru/s3/multimedia-1-d/6933150625.jpg',
      category: 'Spider-Man',
      description: 'Последняя охота Кравена на Человека-паука.',
      quantity: 3,
      isFavorite: false,
    ),
    Comic(
      title: 'Batman: Year One',
      author: 'Frank Miller',
      price: 19.99,
      imageUrl: 'https://s3.amazonaws.com/www.covernk.com/Covers/L/B/Batman+Year+One/batmanyearonetradepaperback1.jpg',
      category: 'Batman',
      description: 'Происхождение Бэтмена.',
      quantity: 7,
      isFavorite: false,
    ),
    Comic(
      title: 'Batman: The Long Halloween',
      author: 'Jeph Loeb',
      price: 22.99,
      imageUrl: 'https://static.tvtropes.org/pmwiki/pub/images/batman_long_halloween_cover.jpg',
      category: 'Batman',
      description: 'Годовая тайна для Бэтмена.',
      quantity: 4,
      isFavorite: false,
    ),
    Comic(
      title: 'Teenage Mutant Ninja Turtles: City at War',
      author: 'Kevin Eastman',
      price: 15.99,
      imageUrl: 'https://vignette.wikia.nocookie.net/tmnt/images/b/b0/Idw91.jpg/revision/latest?cb=20190214074102',
      category: 'Ninja Turtles',
      description: 'Черепашки сталкиваются с городской войной.',
      quantity: 6,
      isFavorite: false,
    ),
    Comic(
      title: 'Teenage Mutant Ninja Turtles: The Last Ronin',
      author: 'Kevin Eastman',
      price: 24.99,
      imageUrl: 'https://i.dailymail.co.uk/1s/2024/04/11/21/83526179-13298943-image-a-142_1712867277901.jpg',
      category: 'Ninja Turtles',
      description: 'Последний выживший Черепашка ищет мести.',
      quantity: 2,
      isFavorite: false,
    ),
  ];

  List<Comic> favorites = [];

  void _toggleFavorite(int index) {
    setState(() {
      comics[index].isFavorite = !comics[index].isFavorite;
      if (comics[index].isFavorite) {
        favorites.add(comics[index]);
      } else {
        favorites.remove(comics[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(comics: comics, toggleFavorite: _toggleFavorite),
      FavoritesScreen(favorites: favorites),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Comic> comics;
  final Function(int) toggleFavorite;

  const HomeScreen({super.key, required this.comics, required this.toggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Комиксы'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemCount: comics.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Image.network(comics[index].imageUrl),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(comics[index].title),
                ),
                IconButton(
                  icon: Icon(
                    comics[index].isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: () => toggleFavorite(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Comic> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favorites[index].title),
            leading: Image.network(favorites[index].imageUrl),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: const Center(
        child: Text('Профиль'),
      ),
    );
  }
}

class Comic {
  final String title;
  final String author;
  final double price;
  final String imageUrl;
  final String category;
  final String description;
  final int quantity;
  bool isFavorite;

  Comic({
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.quantity,
    this.isFavorite = false,
  });
}