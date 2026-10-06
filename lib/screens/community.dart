import 'package:flutter/material.dart';

import '../ui.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  var _tab = 0;
  var _liked = false;
  var _requested = false;
  var _city = 'Hà Nội';
  var _goal = 'Giảm cân';
  final _comments = <String>[];
  final _commentInput = TextEditingController();

  @override
  void dispose() {
    _commentInput.dispose();
    super.dispose();
  }

  void _filters() {
    var city = _city;
    var goal = _goal;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, updateSheet) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tìm người cùng mục tiêu',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Thành phố',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final value in [
                      'Hà Nội',
                      'TP. Hồ Chí Minh',
                      'Đà Nẵng',
                    ])
                      ChoiceChip(
                        label: Text(value),
                        selected: city == value,
                        onSelected: (_) => updateSheet(() => city = value),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Mục tiêu',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final value in ['Giảm cân', 'Tăng cơ', 'Giữ dáng'])
                      ChoiceChip(
                        label: Text(value),
                        selected: goal == value,
                        onSelected: (_) => updateSheet(() => goal = value),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Bộ lọc áp dụng cho dữ liệu minh họa.',
                  style: TextStyle(color: GymColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 18),
                PrimaryButton(
                  label: 'Áp dụng',
                  onPressed: () {
                    setState(() {
                      _city = city;
                      _goal = goal;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openComments() {
    final input = _commentInput;
    input.clear();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, updateSheet) {
          void addComment() {
            final text = input.text.trim();
            if (text.isEmpty) return;
            setState(() => _comments.add(text));
            updateSheet(() {});
            input.clear();
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * .56,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Bình luận',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Đóng bình luận',
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const Text(
                        'Bình luận chỉ lưu trong phiên minh họa.',
                        style: TextStyle(fontSize: 11, color: GymColors.muted),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          children: [
                            const Text(
                              'Minh Anh',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 18),
                              child: Text(
                                'Quá đỉnh! Cùng cố gắng nhé 💪',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: GymColors.muted,
                                ),
                              ),
                            ),
                            for (final comment in _comments)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 17),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Bạn',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      comment,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: const Key('comment-input'),
                              controller: input,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => addComment(),
                              decoration: const InputDecoration(
                                hintText: 'Viết bình luận...',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            key: const Key('comment-send'),
                            tooltip: 'Gửi bình luận',
                            onPressed: addComment,
                            icon: const Icon(Icons.arrow_upward),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _profile() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/trainer.jpg',
                height: 210,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'HLV. Hải Đăng',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              '★ 4.9  •  5 năm kinh nghiệm',
              style: TextStyle(color: GymColors.purple),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chuyên môn: Đốt mỡ & Tăng cơ\nLịch rảnh: Sáng / Tối\nHuấn luyện cá nhân theo mục tiêu và trình độ.',
              style: TextStyle(height: 1.8),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hồ sơ minh họa • Chưa kết nối với huấn luyện viên thật.',
              style: TextStyle(fontSize: 12, color: GymColors.muted),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Đóng hồ sơ',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _tag(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFF28252E),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 10, color: GymColors.muted),
    ),
  );

  Widget _trainer() => GymCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 29,
              backgroundImage: AssetImage('assets/images/trainer.jpg'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'HLV. Hải Đăng',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '★ 4.9',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFFC857),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Chuyên môn: Đốt mỡ & Tăng cơ',
                    style: TextStyle(
                      fontSize: 11,
                      color: GymColors.muted,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    'Cách 1.2 km • $_city',
                    style: const TextStyle(
                      fontSize: 10,
                      color: GymColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [_tag('Lịch rảnh: Sáng / Tối'), _tag('Kinh nghiệm: 5 năm')],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _profile,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 41),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: const Text('Xem hồ sơ', style: TextStyle(fontSize: 11)),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: FilledButton(
                onPressed: () => setState(() => _requested = !_requested),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 41),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text(
                  _requested ? 'Đã gửi lời mời' : 'Kết nối ngay',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _requested
              ? 'Lời mời minh họa • Chạm lại để hủy.'
              : 'Kết nối minh họa, chỉ lưu trên thiết bị.',
          style: const TextStyle(fontSize: 9, color: GymColors.muted),
        ),
      ],
    ),
  );

  Widget _feed() => GymCard(
    padding: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Linh Nguyễn',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '2 giờ trước',
                      style: TextStyle(fontSize: 10, color: GymColors.muted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF352042),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Chia sẻ',
                  style: TextStyle(fontSize: 10, color: GymColors.purple),
                ),
              ),
            ],
          ),
        ),
        Image.asset(
          'assets/images/community.jpg',
          width: double.infinity,
          height: 204,
          fit: BoxFit.cover,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(14, 14, 14, 3),
          child: Text(
            'Hôm nay phá kỷ lục cá nhân Squat 100kg! Nhờ AI kiểm tra form đúng góc đỡ cực chuẩn luôn.',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          child: Row(
            children: [
              TextButton.icon(
                key: const Key('community-like'),
                onPressed: () => setState(() => _liked = !_liked),
                icon: Icon(
                  _liked ? Icons.favorite : Icons.favorite_border,
                  size: 19,
                ),
                label: Text(
                  _liked ? '129' : '128',
                  style: const TextStyle(fontSize: 11),
                ),
                style: TextButton.styleFrom(foregroundColor: GymColors.purple),
              ),
              const SizedBox(width: 4),
              TextButton.icon(
                key: const Key('community-comments'),
                onPressed: _openComments,
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: Text(
                  '${24 + _comments.length}',
                  style: const TextStyle(fontSize: 11),
                ),
                style: TextButton.styleFrom(foregroundColor: GymColors.muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 17, 20, 10),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Khám Phá',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              key: const Key('community-filter'),
              onPressed: _filters,
              icon: const Icon(Icons.tune, size: 14),
              label: Text(
                '$_city • $_goal',
                style: const TextStyle(fontSize: 10),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            for (var i = 0; i < 2; i++)
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _tab = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _tab == i
                              ? GymColors.purple
                              : GymColors.border,
                          width: _tab == i ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Text(
                      i == 0 ? 'Cộng đồng' : 'Tìm PT / Bạn tập',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _tab == i ? GymColors.purple : GymColors.muted,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_tab == 0) _feed(),
              if (_tab == 1) ...[
                const Text(
                  'Cùng nhau tiến bộ mỗi ngày',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kết quả minh họa tại $_city • $_goal',
                  style: const TextStyle(fontSize: 12, color: GymColors.muted),
                ),
              ],
              const SectionHeading(title: 'Gợi ý huấn luyện viên'),
              _trainer(),
            ],
          ),
        ),
      ),
    ],
  );
}
