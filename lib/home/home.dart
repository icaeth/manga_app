import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_app/home/manga.dart';
import 'package:manga_app/home/manga_service.dart';
import 'dart:ui';

final mangasFutureProvider =
    FutureProvider.autoDispose<List<Manga>>((ref) async {
  ref.maintainState = true;

  final mangaService = ref.read(mangaServiceProvider);
  final mangas = await mangaService.getMangas();
  return mangas;
});

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('MangaApp'),
      ),
      body: watch(mangasFutureProvider).when(
          data: (mangas) {
            return RefreshIndicator(
              onRefresh: () {
                return context.refresh(mangasFutureProvider);
              },
              child: GridView.extent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
                children:
                    mangas.map((manga) => _MangaBox(manga: manga)).toList(),
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, s) {
            return _ErrorBody(message: "error");
          }),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => context.refresh(mangasFutureProvider),
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}

class _MangaBox extends StatelessWidget {
  final Manga manga;

  const _MangaBox({Key key, this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          manga.fullImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _FrontBanner(text: manga.title),
        ),
      ],
    );
  }
}

class _FrontBanner extends StatelessWidget {
  const _FrontBanner({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          height: 60,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
