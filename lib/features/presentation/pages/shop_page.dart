

import 'dart:async';

import 'package:firstapplication/features/presentation/components/navigation_controllers.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String _title = 'Himdeve Shop';

  final globalKey = GlobalKey<ScaffoldState>();

  late Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      floatingActionButton: _buildShowUrlBtn(),
      appBar: AppBar(
        title: Text(_title,style: const TextStyle(color: Colors.white),),
        actions: [
          NavigationController(_controller.future),
        ],
      ),
      body: Container(
        child: _buildWebView(context),
      ),
    );
  }

  Widget _buildWebView(BuildContext context)
  {
    return WebView(
      initialUrl: 'https://himdeve.com/',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController){
        _controller.complete(webViewController);
      },
      navigationDelegate: (request ) =>_buildNavigationDecision(request,context),
      onPageFinished: (url)=>_showPageTitle(),
      javascriptChannels: <JavascriptChannel>{
        _createTopBarJsChannel(),
      },
    );
  }

  Widget _buildShowUrlBtn()
  {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder: (BuildContext context, AsyncSnapshot<WebViewController>controller ){
        if(controller.hasData){
          return FloatingActionButton(
            onPressed: ()async{
              String? url = await controller.data!.currentUrl();
              print("current url : $url");
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Current url $url'),));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Current url $url'),));
            },
            child: Icon(Icons.title),
          );
        }
        else{
          return SizedBox.shrink();
        }
      },
    );
  }

  NavigationDecision _buildNavigationDecision(NavigationRequest request,BuildContext context)
  {

    if(request.url.contains('my-account')){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Don't have the right access to this page")));
      return NavigationDecision.prevent;
    }

    print("click Navigation button");
    return NavigationDecision.navigate;
  }

  void _showPageTitle(){
    _controller.future.then((webViewController){
      webViewController.runJavascript(
        "TopBarJsChannel.postMessage(document.title);"
      );
    });
  }

  JavascriptChannel _createTopBarJsChannel(){
    return JavascriptChannel(
      name: "TopBarJsChannel",
      onMessageReceived: (message){
        String newTitle = message.message;
        if(newTitle.contains("-")){
          newTitle = newTitle.substring(0,newTitle.indexOf('-')).trim();
        }
        setState((){
          _title = newTitle;
        });
      }
    );
  }
}
