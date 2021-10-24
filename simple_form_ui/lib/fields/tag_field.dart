import 'package:entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:simple_form_ui/common/color/color_circle.dart';
import 'package:simple_form_ui/common/color/color_select.dart';
import 'package:simple_form_ui/common/field_label.dart';
import 'package:simple_form_ui/common/modal/text_field_modal.dart';
import 'package:simple_form_ui/simple_form/simple_form_style.dart';
import 'package:uuid/uuid.dart';

class TagItem extends Equatable implements Entity<String> {
  @override
  final String id;
  final String name;
  final Color color;

  const TagItem({
    required this.id,
    required this.name,
    required this.color,
  });

  TagItem copyWith({
    String? id,
    String? name,
    Color? color,
  }) {
    return TagItem(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  factory TagItem.create({required String name, required Color color}) {
    return TagItem(id: const Uuid().v4(), name: name, color: color);
  }

  @override
  List<Object?> get props => [
        name,
        color,
      ];
}

typedef TagItems = Entities<String, TagItem>;

class SFTagFieldxx extends ReactiveFormField<TagItems, TagItems> {
  // ignore: use_key_in_widget_constructors
  SFTagFieldxx({
    Key? key,
    required Widget label,
    // required List<Tag> tags,
    required String formControlName,
    required Future<TagItems?> Function(
            BuildContext context, TagItems selectedTags)
        onTapSelectTags,
    SFStyle style = const SFStyle(),
  }) : super(
            formControlName: formControlName,
            builder: (field) {
              final selectedTags = field.value ?? TagItems.empty();
              return Builder(builder: (context) {
                return InkWell(
                  onTap: () async {
                    final result = await onTapSelectTags(context, selectedTags);
                    print(result);
                    field.didChange(result ?? TagItems.empty());
                  },
                  child: FieldLabel(
                    label: label,
                    style: style,
                    child: Wrap(
                      children: selectedTags.entities.isNotEmpty
                          ? [
                              ...selectedTags.entities.map(
                                (tag) => Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Chip(
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    label: Text(
                                      tag.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: tag.color,
                                  ),
                                ),
                              ),
                            ]
                          : [
                              const Text(
                                "タグを設定",
                                // style:
                                //     Theme.of(context).inputDecorationTheme.labelStyle,
                              ),
                            ],
                    ),
                  ),
                );
              });
            });
}

class TagField2 extends StatelessWidget {
  final Widget label;
  final List<TagItem> tags;
  final String formControlName;
  final SFStyle style;
  final Future<TagItems> Function() selectTags;

  const TagField2({
    Key? key,
    required this.label,
    required this.tags,
    required this.formControlName,
    required this.selectTags,
    this.style = const SFStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConsumer(builder: (context, form, child) {
      final control = form.control(formControlName) as FormControl<TagItems>;
      final selectedTags = control.value ?? TagItems.empty();
      return InkWell(
        onTap: () async {
          final result = await selectTags();
          print(result);
        },
        child: FieldLabel(
          label: label,
          style: style,
          child: ReactiveFormConsumer(
            builder: (context, form, _) {
              final control =
                  form.control(formControlName) as FormControl<Set<TagItem>>;
              final selectedTags = control.value ?? {};
              return Wrap(
                children: selectedTags.isNotEmpty
                    ? [
                        ...selectedTags.map(
                          (tag) => Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Chip(
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              label: Text(
                                tag.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: tag.color,
                            ),
                          ),
                        ),
                      ]
                    : [
                        const Text(
                          "タグを設定",
                          // style:
                          //     Theme.of(context).inputDecorationTheme.labelStyle,
                        ),
                      ],
              );
            },
          ),
        ),
      );
    });
  }
}

class TagSelect extends StatefulWidget {
  final TagItems selectedTags;
  final List<TagItem> tagOptions;
  final void Function(TagItem) onDelete;
  final void Function(TagItem) onUpdate;
  final void Function(TagItem) onCreate;
  const TagSelect({
    Key? key,
    required this.selectedTags,
    required this.tagOptions,
    required this.onDelete,
    required this.onUpdate,
    required this.onCreate,
  }) : super(key: key);

  @override
  _TagSelectState createState() => _TagSelectState();
}

class _TagSelectState extends State<TagSelect> {
  late TagItems _selectedTags;

  @override
  void initState() {
    _selectedTags = widget.selectedTags;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_selectedTags);
        return true;
      },
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(_selectedTags);
                  },
                  icon: const Icon(Icons.close),
                ),
                const Spacer(),
              ],
            ),
            Expanded(
              child: ListView(
                children: widget.tagOptions.isNotEmpty
                    ? [
                        ...widget.tagOptions.map(
                          (tag) => Slidable(
                            actionPane: const SlidableDrawerActionPane(),
                            child: ListTile(
                              leading: ColorCircle(
                                color: tag.color,
                                onChanged: (v) {},
                                isSelected: false,
                              ),
                              title: Text(tag.name),
                              trailing: _selectedTags.exist(tag.id)
                                  ? const Icon(Icons.check)
                                  : const SizedBox(),
                              onTap: () {
                                setState(() {
                                  if (_selectedTags.exist(tag.id)) {
                                    _selectedTags = _selectedTags.remove(tag);
                                  } else {
                                    _selectedTags = _selectedTags.put(tag);
                                  }
                                });
                                // if (tags.contains(tag)) {
                                //   field.didChange({...tags}..remove(tag));
                                // } else {
                                //   field.didChange({...tags, tag});
                                // }
                              },
                            ),
                            secondaryActions: [
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  // BlocProvider.of<TagBloc>(context).add(
                                  //   DeleteTagEvent(e.id),
                                  // );
                                  // widget.onDelete(tag);
                                },
                              ),
                              IconSlideAction(
                                caption: "Edit",
                                color: Colors.blue,
                                icon: Icons.edit,
                                onTap: () {
                                  showTagModal(
                                    context,
                                    initTag: tag,
                                    onSaved: (newTag) {
                                      widget.onUpdate(newTag);
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ]
                    : [
                        const Text(
                          "タグを設定",
                          // style:
                          //     Theme.of(context).inputDecorationTheme.labelStyle,
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TagEdit extends StatefulWidget {
  final TagItem? initTag;
  final ValueChanged<TagItem> onSaved;

  const TagEdit({
    Key? key,
    this.initTag,
    required this.onSaved,
  }) : super(key: key);

  @override
  _TagEditState createState() => _TagEditState();
}

class _TagEditState extends State<TagEdit> {
  late ColorSelectController controller;
  late TextEditingController textEditingController;

  @override
  void initState() {
    final tag = widget.initTag;
    if (tag != null) {
      // 更新
      controller = ColorSelectController.init(tag.color);
      textEditingController = TextEditingController(text: tag.name);
    } else {
      // 新規作成
      controller = ColorSelectController.init(null);
      textEditingController = TextEditingController(text: "");
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  final initTag = widget.initTag;
                  if (initTag != null) {
                    print("update");
                    widget.onSaved(
                      initTag.copyWith(
                        name: textEditingController.text,
                        color: controller.value.selectedColor,
                      ),
                    );
                  } else {
                    print("create");
                    widget.onSaved(
                      TagItem.create(
                        name: textEditingController.text,
                        color: controller.value.selectedColor,
                      ),
                    );
                  }

                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (
                      BuildContext context,
                      ColorSelectState value,
                      Widget? child,
                    ) =>
                        ColorCircle(
                      isSelected: false,
                      color: value.selectedColor,
                      onChanged: (_) {},
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration:
                        const InputDecoration.collapsed(hintText: "タグ名を入力"),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ColorSelectWidget(
              controller: controller,
            ),
          )
        ],
      ),
    );
  }
}

void showTagModal(
  BuildContext context, {
  required ValueChanged<TagItem> onSaved,
  TagItem? initTag,
}) {
  showCustomModalBottomSheet(
    context: context,
    builder: (_) {
      return TagEdit(
        onSaved: onSaved,
        initTag: initTag,
      );
    },
    containerWidget:
        (BuildContext context, Animation<double> animation, Widget child) {
      return SafeArea(
        bottom: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Scaffold(
            body: child,
          ),
        ),
      );
    },
  );
}

class SFTagField extends StatefulWidget {
  final Widget label;
  // final List<TagItem> tags;
  final String formControlName;
  final List<String> tagsOption;
  final SFStyle style;
  // final Future<TagItems> Function() selectTags;
  const SFTagField({
    Key? key,
    required this.label,
    required this.formControlName,
    this.style = const SFStyle(),
    required this.tagsOption,
  }) : super(key: key);

  @override
  _SFTagFieldState createState() => _SFTagFieldState();
}

class _SFTagFieldState extends State<SFTagField> {
  late List<String> tagsOption;

  @override
  void initState() {
    tagsOption = widget.tagsOption;
    super.initState();
  }

  void addTagsOption(String newTagName) {
    if (newTagName.isNotEmpty && !tagsOption.contains(newTagName)) {
      setState(() {
        tagsOption.add(newTagName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FieldLabelVertical(
      style: widget.style,
      label: widget.label,
      child: ReactiveTagChoice(
        formControlName: widget.formControlName,
        tagsOption: tagsOption,
        onTapAddTag: () async {
          final text = await showTextFieldModal(context);
          if (text != null) {
            addTagsOption(text);
          }
        },
      ),
    );
  }
}

class ReactiveTagChoice extends ReactiveFormField<Set<String>, Set<String>> {
  ReactiveTagChoice({
    required String formControlName,
    required List<String> tagsOption,
    required Function onTapAddTag,
  }) : super(
          formControlName: formControlName,
          builder: (field) {
            final selected = field.value ?? {};
            return Wrap(
              spacing: 4,
              children: [
                ...tagsOption.map(
                  (tag) => ChoiceChip(
                    label: Text(tag),
                    selected: selected.contains(tag),
                    visualDensity: VisualDensity.compact,
                    // padding: const EdgeInsets.symmetric(horizontal: 4),
                    // labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    onSelected: (value) {
                      if (value) {
                        field.didChange({...selected, tag});
                      } else {
                        field.didChange({...selected}..remove(tag));
                      }
                    },
                  ),
                ),
                InputChip(
                  avatar: const Icon(Icons.add),
                  label: const Text("タグを追加"),
                  // padding: const EdgeInsets.symmetric(horizontal: 4),
                  // labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  onSelected: (value) async {
                    onTapAddTag();
                  },
                ),
              ],
            );
          },
        );
}
