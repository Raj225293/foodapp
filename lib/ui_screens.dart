import 'package:flutter/material.dart';
import 'package:user_details_api/service.dart';

class UiScreens extends StatefulWidget {
  const UiScreens({super.key});

  @override
  State<UiScreens> createState() => _UiScreensState();
}

class _UiScreensState extends State<UiScreens> {
  late Future<List<Userdetails>> userDetailsFuture;

  @override
  void initState() {
    super.initState();
    userDetailsFuture = UserService.fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Info App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        cardColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('User Details'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Userdetails>>(
          future: userDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found.'));
            }

            final users = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 16),
                            const SizedBox(width: 6),
                            Text(user.email),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                  '${user.street}, ${user.suite}, ${user.city} (${user.zipcode})'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.map, size: 16),
                            const SizedBox(width: 6),
                            Text(
                                'Lat: ${user.latitude}, Lng: ${user.longitude}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
