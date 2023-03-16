import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/widgets/app_bars/food_appbar.dart';
import 'package:shop/widgets/cart/cart_mob_complete.dart';
import 'package:shop/widgets/cart/cart_widget.dart';

int currentStep = 0;
bool isComplete = false;

List<Step> getSteps() => [
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text('Cart'),
        content: const CartWidget(),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text('Payment'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UpText(
              "Need to know your details",
              type: UpTextType.heading4,
            ),
            const SizedBox(height: 8),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: [
                SizedBox(
                  width: 300,
                  child: UpTextField(label: 'YOUR NAME', style: UpStyle()),
                ),
                SizedBox(
                  width: 300,
                  child: UpTextField(label: 'TELEPHONE', style: UpStyle()),
                ),
                SizedBox(
                  width: 300,
                  child: UpTextField(label: 'EMAIL', style: UpStyle()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const UpText(
              "Pay by cash or card",
              type: UpTextType.heading4,
            ),
            const SizedBox(height: 8),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: [
                UpButton(
                  onPressed: () {},
                  text: "CASH",
                  icon: Icons.money,
                  style: UpStyle(buttonWidth: 300),
                ),
                UpButton(
                  onPressed: () {},
                  text: "CARD",
                  icon: Icons.credit_card,
                  style: UpStyle(buttonWidth: 300),
                ),
              ],
            )
          ],
        ),
      ),
      Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text('Confirm Details'),
          content: Container()),
    ];

class FoodCartMobPage extends StatefulWidget {
  const FoodCartMobPage({
    super.key,
  });

  @override
  State<FoodCartMobPage> createState() => _FoodCartMobPageState();
}

class _FoodCartMobPageState extends State<FoodCartMobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FoodAppbar(),
      body: isComplete
          ? const CartMobComplete()
          : Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color.fromRGBO(200, 16, 46, 1.0),
                ),
              ),
              child: Container(
                child: Stepper(
                  type: StepperType.horizontal,
                  currentStep: currentStep,
                  steps: getSteps(),
                  // onStepTapped: (step) => setState(() {
                  //   currentStep = step;
                  // }),
                  onStepContinue: () {
                    final isLastStep = currentStep == getSteps().length - 1;
                    if (isLastStep) {
                      setState(() {
                        isComplete = true;
                        print('Completed');
                      });
                    } else {
                      setState(() => currentStep += 1);
                    }
                  },
                  onStepCancel: () {
                    if (currentStep == 0) {
                      print('Goto Food List');
                    } else {
                      setState(() => currentStep -= 1);
                    }
                    // currentStep == 0 ? null : () => setState(() => currentStep -= 1);
                  },
                  controlsBuilder: (context, details) {
                    final isLastStep = currentStep == getSteps().length - 1;
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: Text(isLastStep ? "CONFIRM" : "NEXT"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (currentStep != 0)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: const Text("BACK"),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  // controlsBuilder: (context, {onStepContinue,onStepCancel}) {
                  //   return Container(
                  //     child: Row(children: [Expanded(child: ElevatedButton(child: Text("Next"),onPressed: onStepContinue,),
                  //     ),
                  //       Expanded(child: ElevatedButton(child: Text("BACK"),onPressed: onStepCancel,),
                  //     ),],),
                  //   )
                  // }
                ),
              ),
            ),
    );
  }
}
