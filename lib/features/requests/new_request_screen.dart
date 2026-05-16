import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/widgets/common.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key, this.prefillTitle});
  final String? prefillTitle;

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  late final TextEditingController _titleCtrl;
  final _authorCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.prefillTitle ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _submitting = false);
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request submitted for "${_titleCtrl.text}"'),
        backgroundColor: context.kit.free,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final k = context.kit;

    return Scaffold(
      backgroundColor: k.bg,
      appBar: BackTopBar(
        title: 'New Request',
        onBack: () => context.pop(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(kGutter),
          children: [
            Text(
              "Can't find a book? Let us know and we'll try to source it for you.",
              style: KitabuText.ui(14, color: k.muted, height: 1.5),
            ),
            const SizedBox(height: 24),
            _FieldGroup(
              label: 'Book Title *',
              child: TextFormField(
                controller: _titleCtrl,
                style: KitabuText.ui(15, color: k.ink),
                decoration: InputDecoration(
                  hintText: 'e.g. A Grain of Wheat',
                  hintStyle: KitabuText.ui(15, color: k.muted),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),
            ),
            const SizedBox(height: 16),
            _FieldGroup(
              label: 'Author',
              child: TextFormField(
                controller: _authorCtrl,
                style: KitabuText.ui(15, color: k.ink),
                decoration: InputDecoration(
                  hintText: "e.g. Ngũgĩ wa Thiong'o",
                  hintStyle: KitabuText.ui(15, color: k.muted),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _FieldGroup(
              label: 'Additional Notes',
              child: TextFormField(
                controller: _noteCtrl,
                style: KitabuText.ui(15, color: k.ink),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Edition, format, or any other details…',
                  hintStyle: KitabuText.ui(15, color: k.muted),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: StickyBottom(
        child: Cta(
          'Submit Request',
          full: true,
          loading: _submitting,
          onTap: _submit,
        ),
      ),
    );
  }
}

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: KitabuText.ui(13,
                weight: FontWeight.w600, color: k.ink)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
