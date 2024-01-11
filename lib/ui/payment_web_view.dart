import 'package:flutter/material.dart';
import 'package:nike_shop/ui/receipt/payment_recipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGatywayScreen extends StatefulWidget {
  final String url;

  const PaymentGatywayScreen({super.key, required this.url});

  @override
  State<PaymentGatywayScreen> createState() => _PaymentGatywayScreenState();
}

class _PaymentGatywayScreenState extends State<PaymentGatywayScreen> {
  final WebViewController webViewController = WebViewController();

  @override
  void initState() {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        final uri = Uri.parse(url);
        if (uri.pathSegments.contains("checkout") &&
            uri.host == "expertdevelopers.ir") {
          final orderId = int.parse(uri.queryParameters['order_id']!);
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PaymentReciptScreen(orderId: orderId),
          ));
        }
      }))
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: webViewController,
    );
  }
}
