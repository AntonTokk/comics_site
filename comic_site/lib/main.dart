import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
    final List<Widget> _screens = [
      HomeScreen(comics: comics, toggleFavorite: _toggleFavorite),
      FavoritesScreen(favorites: favorites),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _screens[_selectedIndex],
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

  HomeScreen({required this.comics, required this.toggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Комиксы'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemCount: comics.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComicDetailScreen(comic: comics[index]),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      comics[index].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      comics[index].title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(
                        comics[index].isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: comics[index].isFavorite ? Colors.red : null,
                      ),
                      onPressed: () => toggleFavorite(index),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Comic> favorites;

  FavoritesScreen({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
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

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Имя пользователя';
  String _email = 'email@example.com';
  File? _avatar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
              child: _avatar == null ? Icon(Icons.person, size: 50) : null,
            ),
            SizedBox(height: 20),
            Text('Имя: $_name'),
            Text('Email: $_email'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      name: _name,
                      email: _email,
                      avatar: _avatar,
                      onSave: (name, email, avatar) {
                        setState(() {
                          _name = name;
                          _email = email;
                          _avatar = avatar;
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text('Редактировать профиль'),
            ),
          ],
        ),
      ),
    );
  }
}

class ComicDetailScreen extends StatelessWidget {
  final Comic comic;

  ComicDetailScreen({required this.comic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(comic.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(comic.imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                comic.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Автор: ${comic.author}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Цена: \$${comic.price}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                comic.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final File? avatar;
  final Function(String, String, File?) onSave;

  EditProfileScreen({
    required this.name,
    required this.email,
    required this.avatar,
    required this.onSave,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late File? _avatar;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _email = widget.email;
    _avatar = widget.avatar;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _avatar = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
                  child: _avatar == null ? Icon(Icons.add_a_photo, size: 50) : null,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Имя'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите ваше имя';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите ваш email';
                  }
                  if (!value.contains('@')) {
                    return 'Пожалуйста, введите корректный email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSave(_name, _email, _avatar);
                    Navigator.pop(context);
                  }
                },
                child: Text('Сохранить'),
              ),
            ],
          ),
        ),
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