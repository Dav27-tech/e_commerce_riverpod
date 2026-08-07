import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/profile/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          32,
        ),
        child: Column(
          children: [
            _ProfileHeader(
              name: user.name,
              email: user.email,
              avatarUrl: user.avatarUrl,
            ),

            const SizedBox(height: 28),

            _ProfileSection(
              title: 'Mon compte',
              children: [
                _ProfileOptionTile(
                  icon: Icons.person_outline,
                  title: 'Informations personnelles',
                  subtitle: 'Consultez vos informations',
                  onTap: () {},
                ),
                _ProfileOptionTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Historique des commandes',
                  subtitle: 'Consultez vos commandes',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            _ProfileSection(
              title: 'Préférences',
              children: [
                _ProfileOptionTile(
                  icon: Icons.payment_outlined,
                  title: 'Paiements',
                  subtitle: 'Gérez vos moyens de paiement',
                  onTap: () {},
                ),
                _ProfileOptionTile(
                  icon: Icons.settings_outlined,
                  title: 'Paramètres',
                  subtitle: 'Gérez les préférences de l’application',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  'Déconnexion',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(
      BuildContext context,
      ) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Déconnexion',
          ),
          content: const Text(
            'La déconnexion est uniquement visuelle '
                'dans cette version de démonstration.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Fermer',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  final String name;
  final String email;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: SizedBox(
            width: 108,
            height: 108,
            child: Image.network(
              avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return ColoredBox(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 56,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          name,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          email,
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  const _ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context)
            .colorScheme
            .primaryContainer,
        child: Icon(
          icon,
          color: Theme.of(context)
              .colorScheme
              .onPrimaryContainer,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.chevron_right,
      ),
    );
  }
}