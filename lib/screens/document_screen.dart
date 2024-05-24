import 'package:docs_clone_flutter/colors.dart';
import 'package:docs_clone_flutter/models/document_model.dart';
import 'package:docs_clone_flutter/models/error_model.dart';
import 'package:docs_clone_flutter/repository/auth_repository.dart';
import 'package:docs_clone_flutter/repository/document_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final titleController = TextEditingController(text: 'Untitled Document');
  final quill.QuillController _controller = quill.QuillController.basic();
  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    fetchDocumentData();
  }

  void fetchDocumentData() async {
    errorModel = await ref
        .read(documentRepositoryProvider)
        .getDocumentById(token: ref.read(userProvider)!.token, id: widget.id);

    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
      setState(() {});
    }
  }

  void updateTitle(WidgetRef ref, String title) async {
    await ref.read(documentRepositoryProvider).updateTitle(
        token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          actions: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.lock,
                    size: 16,
                    color: kWhiteColor,
                  ),
                  label: const Text(
                    'Share',
                    style: TextStyle(color: kWhiteColor),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: kBlueColor),
                )),
          ],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Image.asset(
                  './assets/images/docs-logo.png',
                  height: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kBlueColor)),
                          contentPadding: EdgeInsets.only(left: 10)),
                      onSubmitted: (value) => updateTitle(ref, value)),
                )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(11),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: kGreyColor)),
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              quill.QuillToolbar.simple(
                  configurations: quill.QuillSimpleToolbarConfigurations(
                      controller: _controller)),
              Expanded(
                child: SizedBox(
                  width: 750,
                  child: Card(
                    color: kWhiteColor,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: quill.QuillEditor.basic(
                        configurations: quill.QuillEditorConfigurations(
                            controller: _controller),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
