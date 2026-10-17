import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fridge_cubit.dart';

class FridgePage extends StatefulWidget {
  const FridgePage({super.key});
  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CookTime')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Hôm nay ăn gì?', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Phiên bản hiện tại tìm món theo tên (TheMealDB).'),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              onSubmitted: (value) => context.read<FridgeCubit>().search(value),
              decoration: const InputDecoration(
                labelText: 'Tên món (ví dụ: chicken)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(spacing: 8, children: [
              FilledButton.icon(
                onPressed: () => context.read<FridgeCubit>().search(_controller.text),
                icon: const Icon(Icons.restaurant_menu), label: const Text('Tìm món'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.read<FridgeCubit>().showFavorites(),
                icon: const Icon(Icons.favorite_border), label: const Text('Yêu thích'),
              ),
            ]),
            const SizedBox(height: 12),
            Expanded(child: BlocBuilder<FridgeCubit, FridgeState>(
              builder: (context, state) {
                switch (state.status) {
                  case FridgeStatus.initial:
                    return const Center(child: Text('Nhập tên món ăn để bắt đầu.'));
                  case FridgeStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case FridgeStatus.empty:
                    return Center(child: Text(state.message ?? 'Không có món ăn.'));
                  case FridgeStatus.error:
                    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(state.message ?? 'Đã xảy ra lỗi.'),
                      TextButton(onPressed: () => context.read<FridgeCubit>().retry(), child: const Text('Thử lại')),
                    ]));
                  case FridgeStatus.success:
                    return ListView.builder(
                      itemCount: state.meals.length,
                      itemBuilder: (context, index) {
                        final meal = state.meals[index];
                        return Card(child: ListTile(
                          leading: meal.imageUrl.isEmpty
                              ? const Icon(Icons.fastfood)
                              : Image.network(meal.imageUrl, width: 56, height: 56, fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(Icons.fastfood)),
                          onTap: () {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(meal.name),
        content: SingleChildScrollView(
          child: Text(
            meal.instructions.isEmpty
                ? 'Chưa có công thức cho món này.'
                : meal.instructions,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  },
                          title: Text(meal.name),
                          subtitle: Text(meal.from.isEmpty ? 'Không rõ xuất xứ' : meal.from),
                          trailing: state.showingFavorites ? null : IconButton(
                            icon: const Icon(Icons.favorite_border),
                            tooltip: 'Lưu yêu thích',
                            onPressed: () async {
                              final ok = await context.read<FridgeCubit>().saveFavorite(meal);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(ok ? 'Đã lưu món yêu thích' : 'Không thể lưu món yêu thích'),
                              ));
                            },
                          ),
                        ));
                      },
                    );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
