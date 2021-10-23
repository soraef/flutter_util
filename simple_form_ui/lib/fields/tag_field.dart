import 'package:entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:simple_form_ui/common/color_circle.dart';
import 'package:simple_form_ui/common/field_label.dart';
import 'package:simple_form_ui/simple_form/simple_form_style.dart';

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

  @override
  List<Object?> get props => [
        name,
        color,
      ];
}

typedef TagItems = Entities<String, TagItem>;

class SFTagField extends ReactiveFormField<TagItems, TagItems> {
  // ignore: use_key_in_widget_constructors
  SFTagField({
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
  const TagSelect({
    Key? key,
    required this.selectedTags,
    required this.tagOptions,
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
    return SafeArea(
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
                        (tag) => ListTile(
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
    );
  }
}

class ReactiveTagField extends ReactiveFormField<Set<TagItem>, Set<TagItem>> {
  // ignore: use_key_in_widget_constructors
  ReactiveTagField({
    required String formControlName,
    required List<TagItem> tagItems,
  }) : super(
            formControlName: formControlName,
            builder: (field) {
              final tags = field.value ?? {};
              return ListView(
                children: tagItems.isNotEmpty
                    ? [
                        ...tagItems.map(
                          (tag) => ListTile(
                            leading: ColorCircle(
                              color: tag.color,
                              onChanged: (v) {},
                              isSelected: false,
                            ),
                            title: Text(tag.name),
                            trailing: tags.contains(tag)
                                ? const Icon(Icons.check)
                                : const SizedBox(),
                            onTap: () {
                              if (tags.contains(tag)) {
                                field.didChange({...tags}..remove(tag));
                              } else {
                                field.didChange({...tags, tag});
                              }
                            },
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
            });
}
