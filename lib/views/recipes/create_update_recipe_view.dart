import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipe_box/models/recipe.dart';
import 'package:my_recipe_box/services/auth/auth_service.dart';
import 'package:my_recipe_box/services/crud/recipe_service.dart';
import 'package:my_recipe_box/services/crud/recipe_user_service.dart';
import 'package:my_recipe_box/utils/constants/view_constants.dart';
import 'package:my_recipe_box/utils/dialogs/error_dialog.dart';
import 'package:my_recipe_box/widgets/sized_box.dart';
import 'package:my_recipe_box/widgets/text_widgets/views_text_widgets.dart';
import 'package:my_recipe_box/widgets/waiting/spinkit_rotating_circle.dart';
import 'dart:developer' as dev_tool show log;

class CreateUpdateRecipeView extends StatefulWidget {
  final Recipe? recipe;
  const CreateUpdateRecipeView({super.key, this.recipe});

  @override
  State<CreateUpdateRecipeView> createState() => _CreateUpdateRecipeViewState();
}

class _CreateUpdateRecipeViewState extends State<CreateUpdateRecipeView> {
  late final bool isEdit;

  bool _isSaving = false;

  late List<TextEditingController> ingredientControllers;
  late List<TextEditingController> stepControllers;
  late TextEditingController titleController;
  bool isFavoriteSelected = false;
  String? selectedCategory;
  String? photoPath;
  File? pickedImageFile;
  final ImagePicker _picker = ImagePicker();

  Recipe? _cachedRecipe;
  late final RecipeService _recipeService;
  late final RecipeUserService _recipeUserService;

  late Future<Recipe> _recipeFuture;

  void addIngredientField() {
    setState(() => ingredientControllers.add(TextEditingController()));
  }

  void removeIngredientField(int index) {
    setState(() => ingredientControllers.removeAt(index));
  }

  void addStepsField() {
    setState(() => stepControllers.add(TextEditingController()));
  }

  void removeStepsField(int index) {
    setState(() => stepControllers.removeAt(index));
  }

  bool isThereEmptyField() {
    for (TextEditingController controller in ingredientControllers) {
      if (controller.text.isEmpty) return true;
    }

    for (TextEditingController controller in stepControllers) {
      if (controller.text.isEmpty) return true;
    }
    return false;
  }

  void saveRecipe() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    final title = titleController.text;
    final ingredients = ingredientControllers.map((c) => c.text).toList();
    final steps = stepControllers.map((c) => c.text).toList();
    final category = selectedCategory;
    final photoPath = pickedImageFile?.path;
    final isFavorite = isFavoriteSelected;

    if (title.isEmpty || isThereEmptyField()) {
      await showErrorDialog(
        context: context,
        errorMessage: pleaseFillOutTheFieldsErrorMessage,
      );
      setState(() => _isSaving = false);
      return;
    }

    if (_cachedRecipe == null) {
      await showErrorDialog(
        context: context,
        errorMessage: recipeNotInitializedErrorMessage,
      );
      setState(() => _isSaving = false);
      return;
    }

    final updatedRecipe = Recipe(
      id: _cachedRecipe!.id,
      userId: _cachedRecipe!.userId,
      title: title,
      ingredients: ingredients,
      steps: steps,
      category: category,
      photoPath: photoPath,
      isFavorite: isFavorite,
    );

    try {
      await _recipeService.updateRecipe(newRecipe: updatedRecipe);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      dev_tool.log(error.toString());
      if (mounted) {
        await showErrorDialog(
          context: context,
          errorMessage: failedToSaveRecipe,
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder:
          (_) => SimpleDialog(
            title: pickImageTextWidget,
            children: [
              SimpleDialogOption(
                child: cameraTextWidget,
                onPressed: () => Navigator.pop(context, ImageSource.camera),
              ),
              SimpleDialogOption(
                child: galleryTextWidget,
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
    );

    if (source == null) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        pickedImageFile = File(image.path);
      });
    }
  }

  Future<Recipe> createOrGetRecipe(BuildContext context) async {
    final recivedRecipe = widget.recipe;
    if (recivedRecipe != null) {
      _cachedRecipe = recivedRecipe;
      return recivedRecipe;
    }
    final existingRecipe = _cachedRecipe;
    if (existingRecipe != null) {
      return existingRecipe;
    }

    final userEmail = AuthService.fireAuth().currentUser!.email!;
    final recipeUser = await _recipeUserService.getUser(email: userEmail);
    final userId = recipeUser.id;
    final newRecipe = await _recipeService.createRecipe(userId: userId);
    _cachedRecipe = newRecipe;
    return newRecipe;
  }

  deleteRecipeIfTitleIsEmpty() async {
    final currentRecipe = _cachedRecipe;
    if (currentRecipe != null) {
      if (titleController.text.isEmpty) {
        _recipeService.deleteRecipe(id: currentRecipe.id);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _recipeService = RecipeService();
    _recipeUserService = RecipeUserService();

    final recipe = widget.recipe;

    isEdit = recipe != null;

    _recipeFuture = createOrGetRecipe(context);

    titleController = TextEditingController(text: recipe?.title);
    isFavoriteSelected = recipe?.isFavorite ?? false;
    selectedCategory = recipe?.category;

    ingredientControllers =
        recipe?.ingredients
            .map((ingredient) => TextEditingController(text: ingredient))
            .toList() ??
        [TextEditingController()];
    dev_tool.log(ingredientControllers.runtimeType.toString());

    stepControllers =
        recipe?.steps
            .map((step) => TextEditingController(text: step))
            .toList() ??
        [TextEditingController()];

    if (recipe?.photoPath != null) {
      pickedImageFile = File(recipe!.photoPath!);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    for (var controller in ingredientControllers) {
      controller.dispose();
    }
    for (var controller in stepControllers) {
      controller.dispose();
    }
    deleteRecipeIfTitleIsEmpty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? editRecipeString : createRecipeString),
      ),
      body: FutureBuilder(
        future: _recipeFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => pickImage(), // choose from camera/gallery
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child:
                            pickedImageFile == null
                                ? Icon(Icons.camera_alt, size: 50)
                                : Image.file(
                                  pickedImageFile!,
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    sizedBoxHieght16,
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: recipeTitlestring,
                        hintText: requiredString,
                      ),
                    ),
                    sizedBoxHieght16,
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      onChanged:
                          (val) => setState(() => selectedCategory = val),
                      items:
                          categoryItemsList
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                      decoration: InputDecoration(labelText: categoryString),
                    ),
                    sizedBoxHieght16,
                    Row(
                      children: [
                        favoriteTextWidget,
                        IconButton(
                          icon: Icon(
                            isFavoriteSelected
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          onPressed:
                              () => setState(
                                () => isFavoriteSelected = !isFavoriteSelected,
                              ),
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ingredientsTextWidget,
                        ...ingredientControllers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final controller = entry.value;
                          return Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: requiredString,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () => removeIngredientField(index),
                              ),
                            ],
                          );
                        }),
                        TextButton.icon(
                          onPressed: addIngredientField,
                          icon: Icon(Icons.add),
                          label: addIngredientTextWidget,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        stepsTextWidget,
                        ...stepControllers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final controller = entry.value;
                          return Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: requiredString,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () => removeStepsField(index),
                              ),
                            ],
                          );
                        }),
                        TextButton.icon(
                          onPressed: addStepsField,
                          icon: Icon(Icons.add),
                          label: addStepsTextWidget,
                        ),
                      ],
                    ),
                    sizedBoxHieght16,
                    ElevatedButton.icon(
                      onPressed: _isSaving ? null : saveRecipe,
                      icon:
                          _isSaving
                              ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Icon(Icons.save),
                      label: Text(
                        _isSaving ? savingprogressString : saveRecipeString,
                      ),
                    ),
                  ],
                ),
              );
            default:
              return spinkitRotatingCircle;
          }
        },
      ),
    );
  }
}
