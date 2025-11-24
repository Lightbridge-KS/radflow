# How to Add a New Calculator

This guide walks through the complete process of adding a new calculator with customizable templates to RadFlow.

## Overview

RadFlow's calculator system has three main components:
1. **Business Logic** - Calculation functions that return data Maps
2. **Template System** - Mustache templates for customizable output
3. **UI Components** - Flutter widgets for user interaction

## Step-by-Step Guide

### 1. Create the Calculator Business Logic

**Location:** `lib/services/calculator/`

Create a new calculator file (e.g., `my_calculator.dart`) with the following structure:

```dart
import 'shared/_parser.dart';

/// Calculator for [description]
///
/// **Methods**
///
/// * [myCalculationFromString] - Parse string input and calculate
/// * [myCalculation] - Calculate from numeric values
/// * [myCalculationDataFromString] - Return data Map for template rendering from string
/// * [myCalculationData] - Return data Map with all calculated values for template rendering
class MyCalculator {

  /// Returns calculation data as a Map for template rendering from string input
  ///
  /// **Parameters**
  ///
  /// * `input` : String - Input values separated by commas and/or spaces
  ///
  /// **Returns**
  ///
  /// * `Map<String, dynamic>?` - Data map with calculated values
  /// * null if input cannot be parsed
  static Map<String, dynamic>? myCalculationDataFromString(String input) {
    dynamic parsed = parseStrToNumOrList(input);

    if (parsed == "") {
      return null;
    }

    try {
      List<double> values = parsed is double ? [parsed] : parsed;

      if (values.length != 2) {  // Adjust based on your needs
        return null;
      }

      return myCalculationData(values[0], values[1]);
    } catch (e) {
      return null;
    }
  }

  /// Returns calculation data as a Map for template rendering
  ///
  /// **Parameters**
  ///
  /// * `value1` : double - First input value
  /// * `value2` : double - Second input value
  ///
  /// **Returns**
  ///
  /// * `Map<String, dynamic>` with keys for template variables
  static Map<String, dynamic> myCalculationData(double value1, double value2) {
    // Perform calculations
    double result = value1 + value2;  // Example calculation
    String interpretation = result > 10 ? "High" : "Normal";

    // Return ALL variables you want available in templates
    return {
      "result": result.round(),
      "resultRaw": result,
      "interpretation": interpretation,
      "value1": value1,
      "value2": value2,
    };
  }

  /// Calculates and returns formatted string (backward compatibility)
  ///
  /// **Parameters**
  ///
  /// * `value1` : double - First input value
  /// * `value2` : double - Second input value
  ///
  /// **Returns**
  ///
  /// * `String` - Formatted result
  static String myCalculation(double value1, double value2) {
    final data = myCalculationData(value1, value2);
    return "${data['interpretation']} result: ${data['result']}";
  }

  /// String input version (backward compatibility)
  static String myCalculationFromString(String input) {
    final data = myCalculationDataFromString(input);
    if (data == null) return "";
    return "${data['interpretation']} result: ${data['result']}";
  }
}
```

**Key Points:**
- Always return `Map<String, dynamic>` from `*Data()` methods
- Include raw and rounded values when needed
- Return `null` for invalid input
- Keep backward-compatible string-returning methods

---

### 2. Create the Default Template

**Location:** `lib/services/calculator/templates/`

Create a Mustache template file: `my_calculator.mustache`

```mustache
{{interpretation}} result: {{result}}
```

**Template Guidelines:**
- Use `{{variableName}}` for simple interpolation
- Keep default template concise and clear
- Match the variable names from your `*Data()` method
- Test with sample data to ensure it renders correctly

**Advanced Mustache Features (optional):**
```mustache
{{! Conditional sections }}
{{#isHigh}}
High risk detected: {{result}}
{{/isHigh}}

{{! Inverted sections }}
{{^isNormal}}
Further evaluation recommended.
{{/isNormal}}

{{! Lists }}
{{#measurements}}
- {{name}}: {{value}}
{{/measurements}}
```

---

### 3. Register in Template Service

**Location:** `lib/services/preferences/snippet_templates_service.dart`

**Step 3.1:** Add calculator ID constant:
```dart
class SnippetTemplatesService {
  static const String _keyPrefix = 'snippet_template_';

  // Add your calculator ID here
  static const String myCalculatorId = 'my_calculator';  //  ADD THIS
  static const String prostateVolumeId = 'prostate_volume';
  static const String spineHeightLossId = 'spine_height_loss';

  // ...
}
```

**Step 3.2:** Add metadata in `getCalculatorMetadata()` method:
```dart
CalculatorMetadata getCalculatorMetadata(String calculatorId) {
  switch (calculatorId) {
    // Add your case here
    case myCalculatorId:  //  ADD THIS CASE
      return CalculatorMetadata(
        id: myCalculatorId,
        name: 'My Calculator',  // Display name in UI
        availableVariables: [
          VariableInfo('result', 'Rounded result (integer)'),
          VariableInfo('resultRaw', 'Raw calculated result (decimal)'),
          VariableInfo('interpretation', 'Result interpretation (High/Normal)'),
          VariableInfo('value1', 'First input value'),
          VariableInfo('value2', 'Second input value'),
        ],
        sampleData: {
          'result': 15,
          'resultRaw': 15.3,
          'interpretation': 'High',
          'value1': 8.5,
          'value2': 6.8,
        },
      );
    case prostateVolumeId:
      // ... existing cases
  }
}
```

**Step 3.3:** Add to calculator list in `getAllCalculatorIds()`:
```dart
List<String> getAllCalculatorIds() {
  return [
    myCalculatorId,  //  ADD THIS
    prostateVolumeId,
    spineHeightLossId,
  ];
}
```

---

### 4. Create the UI Component

**Location:** `lib/app/pages/calculators/`

Create a new file: `app_my_calculator.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/calculator/my_calculator.dart';
import '../../../services/calculator/shared/template_renderer.dart';
import '../../../services/preferences/snippet_templates_service.dart';
import '../../providers/snippet_templates_provider.dart';
import '../../widgets/buttons.dart';

class AppMyCalculator extends ConsumerStatefulWidget {
  const AppMyCalculator({super.key});

  @override
  ConsumerState<AppMyCalculator> createState() => _AppMyCalculatorState();
}

class _AppMyCalculatorState extends ConsumerState<AppMyCalculator> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    final data = MyCalculator.myCalculationDataFromString(_inputController.text);

    if (data == null) {
      setState(() {
        _outputController.text = '';
      });
      return;
    }

    // Get template from service (await the future)
    final service = ref.read(snippetTemplatesServiceProvider);
    final template = await service.getTemplate(SnippetTemplatesService.myCalculatorId);

    if (!mounted) return;

    try {
      final result = TemplateRenderer.render(template, data);
      setState(() {
        _outputController.text = result;
      });
    } catch (e) {
      setState(() {
        _outputController.text = 'Template error: $e';
      });
    }
  }

  void _resetInputs() {
    setState(() {
      _inputController.clear();
      _outputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Calculator',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      labelText: 'Input: Values',
                      hintText: 'e.g. 8.5 6.8',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Input two values separated by spaces or comma',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _outputController,
                    decoration: const InputDecoration(
                      labelText: 'Result snippet',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: false,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GenerateButton(onPressed: _calculate),
                          const SizedBox(width: 8),
                          CopyButton(controller: _outputController),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _resetInputs,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
```

**UI Component Checklist:**
-  Use `ConsumerStatefulWidget` for Riverpod access
-  Make `_calculate()` async and await template loading
-  Check `if (!mounted) return;` after async operations
-  Handle null data gracefully
-  Use `TemplateRenderer.render()` with template and data
-  Provide clear input hints and labels

---

### 5. Add to Calculator Screen

**Location:** `lib/app/pages/calculators/calculator_abdomen_screen.dart` (or create new screen)

Import and add your calculator widget:

```dart
import 'app_my_calculator.dart';  // Add import

// In the build method, add to your layout:
const SizedBox(height: 24),
const Divider(),
const SizedBox(height: 24),
const AppMyCalculator(),  // Add widget
```

---

### 6. Update Asset Configuration

**Location:** `pubspec.yaml`

Ensure the templates directory is included in assets (should already be configured):

```yaml
flutter:
  assets:
    - lib/services/calculator/templates/  #  Already configured
```

---

### 7. Test Your Calculator

**Run the app:**
```bash
fvm flutter run
```

**Test checklist:**
- [ ] Calculator computes correctly with valid input
- [ ] Returns empty string for invalid input
- [ ] First click calculates (no delay needed)
- [ ] Template renders with correct variables
- [ ] Settings  Calculator Templates shows your calculator
- [ ] Can edit template and see live preview
- [ ] Custom template persists after app restart
- [ ] Reset to default works correctly

---

## Architecture Diagram

```
User Input (String)
    
MyCalculator.*DataFromString()
    
parseStrToNumOrList()  [shared/_parser.dart]
    
MyCalculator.*Data()
    
Map<String, dynamic>
    {
      "result": 15,
      "interpretation": "High",
      ...
    }
    
SnippetTemplatesService.getTemplate()
    
SharedPreferencesAsync  Custom Template
    OR
rootBundle  Default Template
    
TemplateRenderer.render(template, data)
    
Mustache Processing
    
Output String  TextField
```

---

## File Checklist

When adding a new calculator, you'll create/modify these files:

- [ ] `lib/services/calculator/my_calculator.dart` - NEW
- [ ] `lib/services/calculator/templates/my_calculator.mustache` - NEW
- [ ] `lib/app/pages/calculators/app_my_calculator.dart` - NEW
- [ ] `lib/services/preferences/snippet_templates_service.dart` - MODIFY
- [ ] `lib/app/pages/calculators/calculator_*_screen.dart` - MODIFY (add to screen)

**No changes needed:**
-  Providers (already generic)
-  Template renderer (shared service)
-  Router (unless creating new route)
-  pubspec.yaml (already configured)

---

## Common Patterns

### Multiple Input Fields

```dart
class _AppMyCalculatorState extends ConsumerState<AppMyCalculator> {
  final TextEditingController _input1Controller = TextEditingController();
  final TextEditingController _input2Controller = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  Future<void> _calculate() async {
    final data = MyCalculator.myCalculationData(
      double.tryParse(_input1Controller.text) ?? 0,
      double.tryParse(_input2Controller.text) ?? 0,
    );
    // ... rest of calculation
  }
}
```

### Dropdown Selectors

```dart
String _selectedOption = 'option1';

// In build method:
DropdownButton<String>(
  value: _selectedOption,
  items: ['option1', 'option2'].map((option) {
    return DropdownMenuItem(
      value: option,
      child: Text(option),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _selectedOption = value!;
    });
  },
)
```

### Complex Data Structures

```dart
static Map<String, dynamic> myCalculationData(...) {
  return {
    "result": 15,
    "items": [  // Lists for Mustache iteration
      {"name": "Item 1", "value": 10},
      {"name": "Item 2", "value": 5},
    ],
    "isHigh": true,  // Booleans for conditional sections
    "details": {  // Nested objects
      "subValue": 3.5,
      "notes": "Additional info"
    }
  };
}
```

Template:
```mustache
Result: {{result}}

{{#items}}
- {{name}}: {{value}}
{{/items}}

{{#isHigh}}
High result detected
{{/isHigh}}

Details: {{details.subValue}}
```

---

## Troubleshooting

### Issue: First click doesn't calculate

**Solution:** Ensure `_calculate()` is `async` and you `await` the template loading:
```dart
Future<void> _calculate() async {
  // ...
  final template = await service.getTemplate(...);  //  MUST await
  if (!mounted) return;  //  Check widget is still mounted
}
```

### Issue: Template variables not showing

**Solution:** Check that variable names in your `*Data()` method match template:
```dart
// In calculator:
return {"myValue": 123};  //  Must match template

// In template:
{{myValue}}  //  Exact name match
```

### Issue: Template not found error

**Solutions:**
1. Verify template file exists in `lib/services/calculator/templates/`
2. Check template ID matches in `SnippetTemplatesService`
3. Ensure `pubspec.yaml` includes templates directory in assets
4. Run `fvm flutter pub get` after changes

### Issue: Provider not updating after save

**Solution:** Invalidate the provider after saving:
```dart
await service.saveTemplate(calculatorId, template);
ref.invalidate(templateProvider(calculatorId));  //  Force refresh
```

---

## Best Practices

1. **Always return Maps from `*Data()` methods** - This is the contract for template rendering
2. **Provide both raw and rounded values** - Let users choose precision in templates
3. **Include all input parameters in output Map** - Users might want to reference them
4. **Use clear variable names** - `volume` is better than `v`, `diagnosis` better than `dx`
5. **Validate input early** - Return `null` for invalid input, don't throw exceptions
6. **Test with edge cases** - Zero values, negative numbers, very large numbers
7. **Keep templates simple by default** - Users can customize if needed
8. **Document available variables** - In `CalculatorMetadata.availableVariables`
9. **Use meaningful sample data** - In `CalculatorMetadata.sampleData` for preview
10. **Check `mounted` after async operations** - Prevent setState on disposed widgets

---

## Example: Complete Mini Calculator

See `lib/services/calculator/volume_calculator.dart` and `lib/services/calculator/spine_calculator.dart` for full working examples.

Quick reference:
- **Prostate Volume**: Single input string  3 values  Map with 6 variables
- **Spine Height Loss**: Two input strings  Lists  Map with 5 variables

---

## Need Help?

- Check existing calculators for patterns
- Review Mustache documentation: https://mustache.github.io/
- Test templates in Settings  Calculator Templates with live preview
- Use `fvm flutter analyze` to catch errors early
