
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fridge_cubit.dart';

class FridgePage extends StatefulWidget {
  const FridgePage({super.key});

  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchMeals() {
    context.read<FridgeCubit>().search(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CookTime'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Hôm nay ăn gì?',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Phiên bản hiện tại tìm món theo tên (TheMealDB).',
            ),
            const SizedBox(height: 12),

            // Nhap ten mon an
            TextField(
              controller: _controller,
              onSubmitted: (value) {
                context.read<FridgeCubit>().search(value);
              },
              decoration: const InputDecoration(
                labelText: 'Tên món (ví dụ: chicken)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Nut tim mon
            FilledButton.icon(
              onPressed: _searchMeals,
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Tìm món'),
            ),

            const SizedBox(height: 12),

            // Hien thi trang thai va danh sach mon an
            Expanded(
              child: BlocBuilder<FridgeCubit, FridgeState>(
                builder: (context, state) {
                  switch (state.status) {
                    case FridgeStatus.initial:
                      return const Center(
                        child: Text('Nhập tên món ăn để bắt đầu.'),
                      );

                    case FridgeStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    case FridgeStatus.empty:
                      return Center(
                        child: Text(
                          state.message ?? 'Không có món ăn.',
                        ),
                      );

                    case FridgeStatus.error:
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.message ?? 'Đã xảy ra lỗi.',
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                context.read<FridgeCubit>().retry();
                              },
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      );

                    case FridgeStatus.success:
                      return ListView.builder(
                        itemCount: state.meals.length,
                        itemBuilder: (context, index) {
                          final meal = state.meals[index];

                          return Card(
                            child: ListTile(
                              // Hinh anh mon an
                              leading: meal.imageUrl.isEmpty
                                  ? const Icon(Icons.fastfood)
                                  : Image.network(
                                      meal.imageUrl,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          const Icon(Icons.fastfood),
                                    ),

                              // Ten mon
                              title: Text(meal.name),

                              // Xuat xu
                              subtitle: Text(
                                meal.from.isEmpty
                                    ? 'Không rõ xuất xứ'
                                    : meal.from,
                              ),

                              // Xem cong thuc khi bam vao mon
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog(
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
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                          },
                                          child: const Text('Đóng'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
