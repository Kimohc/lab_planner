import 'package:bioartlab_planner/models/classes/AnimalType.dart';
import 'package:bioartlab_planner/models/classes/TaskType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import '../../models/classes/Task.dart';

class AddNewAnimalTypeFloatingActionButton extends StatefulWidget {
  final GlobalKey<ExpandableFabState> keyFab;

  const AddNewAnimalTypeFloatingActionButton({
    super.key,
    required this.keyFab,
  });

  @override
  State<AddNewAnimalTypeFloatingActionButton> createState() =>
      _AddNewAnimalTypeFloatingActionButtonState();
}

class _AddNewAnimalTypeFloatingActionButtonState
    extends State<AddNewAnimalTypeFloatingActionButton> {
  late TextEditingController animalTypeNameController;
  TaskType? dropDownValue;
  late GlobalKey<ExpandableFabState> keyToClose;

  @override
  void initState() {
    super.initState();
    animalTypeNameController = TextEditingController();
    keyToClose = widget.keyFab;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: null,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add new animal type',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                        animalTypeNameController, 'Animaltype name (required)'),
                    const SizedBox(height: 20),
                    Consumer<GlobalProvider>(
                      builder: (context, animalManager, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if (animalTypeNameController.text.isNotEmpty) {
                              final newAnimalType =
                              AnimalType(name: animalTypeNameController.text);
                              animalManager.createAnimalType(newAnimalType);
                              Navigator.pop(context);
                              animalTypeNameController.clear();
                            } else {
                              showSnackBar("Fill de required fields");
                            }
                          },
                          child: const Text("Add animal type"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ).whenComplete(() => keyToClose.currentState?.toggle());
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        TextInputType inputType = TextInputType.text,
        int maxLines = 1,
      }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        action: SnackBarAction(label: 'Close', onPressed: closeSnackBar)));
  }

  closeSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
