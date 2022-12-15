import 'package:assistantpro/src/constants/assets_strings.dart';
import 'package:assistantpro/src/features/home_page/components/product_data_form.dart';
import 'package:assistantpro/src/features/home_page/components/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../firebase/firebase_manage_data.dart';
import '../../../constants/app_init_constants.dart';

class Product extends StatelessWidget {
  const Product({
    Key? key,
    required this.screenHeight,
    required this.product,
  }) : super(key: key);
  final AssistantProProduct product;
  final double screenHeight;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
        padding: EdgeInsets.all(screenHeight * 0.01),
        decoration: BoxDecoration(
          color: product.getMqttProductHandler().countTracker.value >=
                  product.getMinimumQuantity()
              ? Colors.grey.shade300
              : Colors.red.shade200,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.getProductName().trim(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight * 0.015,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Bruno Ace',
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                      image: const AssetImage(kRefrigeratorTray),
                      height: screenHeight * 0.1,
                    ),
                    SizedBox(width: screenHeight * 0.01),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.getUsageName().trim(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Bruno Ace',
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          children: [
                            Text(
                              'countIs'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenHeight * 0.015,
                                fontFamily: 'Bruno Ace',
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              product
                                  .getMqttProductHandler()
                                  .countTracker
                                  .value
                                  .toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenHeight * 0.015,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Bruno Ace',
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              right: AppInit.currentDeviceLanguage == Language.english
                  ? 10.0
                  : null,
              left: AppInit.currentDeviceLanguage == Language.arabic
                  ? 10.0
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: screenHeight * 0.05,
                      ),
                      color: Colors.black,
                      onPressed: () {
                        Get.to(
                          () => ProductDataForm(
                            productId: product.getProductId(),
                            productName: product.getProductName(),
                            buttonText: 'registerDevice'.tr,
                            qrCodeAdd: false,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: screenHeight * 0.05,
                    ),
                    color: Colors.black,
                    onPressed: () async {
                      await FireBaseDataAccess.instance
                          .removeProduct(product.getProductId());
                      await product
                          .getMqttProductHandler()
                          .cancelSubscription(product.getGetTopic());
                    },
                  ),
                  SizedBox(height: screenHeight * 0.005),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
