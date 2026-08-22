import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/collections/user_entity.dart';
import 'user_repository.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());

class StaffManagementScreen extends ConsumerStatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  ConsumerState<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends ConsumerState<StaffManagementScreen> {
  late Future<List<UserEntity>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = ref.read(userRepositoryProvider).getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        title: Text(
          'STAFF MANAGEMENT',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserDialog(),
        backgroundColor: AppTheme.emerald,
        icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
        label: Text('ADD STAFF', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: FutureBuilder<List<UserEntity>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppTheme.ink.withOpacity(0.05)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: _getRoleColor(user.role).withOpacity(0.1),
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w900,
                        color: _getRoleColor(user.role),
                      ),
                    ),
                  ),
                  title: Text(
                    user.name.toUpperCase(),
                    style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900),
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getRoleColor(user.role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: _getRoleColor(user.role),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(user.username, style: TextStyle(fontSize: 12, color: AppTheme.ink.withOpacity(0.4))),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () => _showUserDialog(user: user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppTheme.error),
                        onPressed: () => _confirmDelete(user),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin': return Colors.purple;
      case 'owner': return AppTheme.emerald;
      default: return Colors.blue;
    }
  }

  void _showUserDialog({UserEntity? user}) {
    final isEditing = user != null;
    final nameController = TextEditingController(text: user?.name);
    final usernameController = TextEditingController(text: user?.username);
    final passwordController = TextEditingController();
    String selectedRole = user?.role ?? 'cashier';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            isEditing ? 'EDIT STAFF' : 'ADD NEW STAFF',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username / Email'),
                  enabled: !isEditing,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: isEditing ? 'New Password (leave blank to keep)' : 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: ['admin', 'owner', 'cashier'].map((role) {
                    return DropdownMenuItem(value: role, child: Text(role.toUpperCase()));
                  }).toList(),
                  onChanged: (val) => setState(() => selectedRole = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () async {
                final repo = ref.read(userRepositoryProvider);
                final entity = user ?? UserEntity();
                
                entity.name = nameController.text;
                entity.username = usernameController.text;
                entity.role = selectedRole;
                entity.lastLogin = user?.lastLogin ?? DateTime.now();

                if (passwordController.text.isNotEmpty) {
                  entity.passwordHash = repo.hashPassword(passwordController.text);
                } else if (!isEditing) {
                  // Password required for new users
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password is required for new staff')),
                  );
                  return;
                }

                await repo.saveUser(entity);
                if (mounted) {
                  Navigator.pop(context);
                  _refreshUsers();
                }
              },
              child: Text(isEditing ? 'UPDATE' : 'CREATE'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(UserEntity user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DELETE STAFF'),
        content: Text('Are you sure you want to remove ${user.name}? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () async {
              await ref.read(userRepositoryProvider).deleteUser(user.id);
              if (mounted) {
                Navigator.pop(context);
                _refreshUsers();
              }
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
