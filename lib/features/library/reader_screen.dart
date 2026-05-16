import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/theme/kitabu_theme.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key, required this.slug});
  final String slug;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  bool _showControls = true;
  double _fontSize = 17;
  bool _showSettings = false;

  static const _sampleText = '''
    The moment Okonkwo's old father died, the clan gathered. They came from all nine villages of Umuofia. The narrow paths that led to his compound were crowded with people. Some came because they had to, some came because of curiosity, and a few came because they loved him.

    The old man had lived for many rains. He had seen things change around him, had watched the white men come with their roads and their church. Yet he remained, a stubborn fixture in the earth like an old iroko tree whose roots went too deep to be pulled out.

    His son sat apart from the mourners. Okonkwo did not weep. He had learned long ago that weeping was for women and for men who had no more use for the world. He sat with his back straight and his chin lifted, the way a man should sit when grief comes for him, unbidden and shameless.

    The birds called out from the trees, and somewhere a drum was beginning.

    In those days the land had its own voice. It spoke through the rustling of the dry-season grass, through the creak of the great iroko trees at night, through the sound a machete makes when it first breaks the earth in the morning. Every child born into Umuofia learned to read these signs before they could read the signs of men.

    Okonkwo had been born in a year of plenty, when the yams grew fat and the harmattan came and went without cruelty. His father had named him in celebration of that abundance, a name that meant "man who achieved fame by his fists" — though the fists part would come much later.
  ''';

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: KitabuTheme.dark(),
      child: Builder(builder: (ctx) {
        final k = ctx.kit;
        final bookAsync = ref.watch(bookBySlugProvider(widget.slug));

        return bookAsync.when(
          loading: () => Scaffold(
            backgroundColor: k.bg,
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Scaffold(
            backgroundColor: k.bg,
            body: Center(child: Text('Error: $e')),
          ),
          data: (book) {
            if (book == null) {
              return Scaffold(
                backgroundColor: k.bg,
                body: const Center(child: Text('Book not found')),
              );
            }
            return Scaffold(
              backgroundColor: k.bg,
              body: GestureDetector(
                onTap: _toggleControls,
                child: Stack(
                  children: [
                    // Reading content
                    ListView(
                      padding: EdgeInsets.fromLTRB(
                        kGutter * 1.2,
                        _showControls ? 100 : 40,
                        kGutter * 1.2,
                        100,
                      ),
                      children: [
                        Text(book.title,
                            style: KitabuText.serif(22,
                                weight: FontWeight.w700,
                                color: k.ink)),
                        const SizedBox(height: 4),
                        Text(book.author,
                            style: KitabuText.ui(13, color: k.muted)),
                        const SizedBox(height: 32),
                        Text(
                          _sampleText.trim(),
                          style: KitabuText.serif(_fontSize,
                              color: k.ink, height: 1.85),
                        ),
                      ],
                    ),
                    // Top bar
                    if (_showControls)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                k.bg,
                                k.bg.withValues(alpha: 0),
                              ],
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            kGutter,
                            MediaQuery.of(ctx).padding.top + 8,
                            kGutter,
                            24,
                          ),
                          child: Row(
                            children: [
                              CircleButton(
                                icon: KSvg(KIcons.arrowLeft,
                                    size: 18, color: k.ink),
                                onTap: () => ctx.pop(),
                                color: k.surface,
                              ),
                              const Spacer(),
                              CircleButton(
                                icon: KSvg(KIcons.settings,
                                    size: 18, color: k.ink),
                                onTap: () => setState(
                                    () => _showSettings = !_showSettings),
                                color: k.surface,
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Settings panel
                    if (_showSettings)
                      Positioned(
                        top: MediaQuery.of(ctx).padding.top + 60,
                        right: kGutter,
                        child: Container(
                          width: 220,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: k.paper,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: k.hairline),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Font Size',
                                  style: KitabuText.ui(12,
                                      weight: FontWeight.w600,
                                      color: k.muted)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() =>
                                        _fontSize = (_fontSize - 1)
                                            .clamp(12, 24)),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: k.surface,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text('A',
                                          style: KitabuText.serif(13,
                                              color: k.muted)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Slider(
                                      value: _fontSize,
                                      min: 12,
                                      max: 24,
                                      activeColor: k.accent,
                                      inactiveColor: k.hairline,
                                      onChanged: (v) =>
                                          setState(() => _fontSize = v),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() =>
                                        _fontSize = (_fontSize + 1)
                                            .clamp(12, 24)),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: k.surface,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text('A',
                                          style: KitabuText.serif(18,
                                              color: k.ink)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Bottom progress bar
                    if (_showControls)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                k.bg,
                                k.bg.withValues(alpha: 0),
                              ],
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            kGutter,
                            24,
                            kGutter,
                            MediaQuery.of(ctx).padding.bottom + 16,
                          ),
                          child: Column(
                            children: [
                              ProgressBar(0.35, height: 3),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text('Page 73 of ${book.pageCount}',
                                      style: KitabuText.ui(11,
                                          color: k.muted)),
                                  const Spacer(),
                                  Text('35%',
                                      style: KitabuText.ui(11,
                                          color: k.muted)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
